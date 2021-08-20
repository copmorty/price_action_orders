import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/trade.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_orderupdate.dart';
import 'package:price_action_orders/domain/usecases/user_get_open_orders_uc.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';

part 'orders_state.dart';

class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOpenOrders _getOpenOrders;
  final UserDataStream _userDataStream;
  StreamSubscription? _subscription;

  OrdersNotifier({
    required GetOpenOrders getOpenOrders,
    required UserDataStream userDataStream,
    bool init = true,
  })  : _getOpenOrders = getOpenOrders,
        _userDataStream = userDataStream,
        super(OrdersInitial()) {
    if (init) this.getOpenOrders();
  }

  Future<void> getOpenOrders() async {
    state = OrdersLoading();

    await _subscription?.cancel();
    final response = await _getOpenOrders(NoParams());
    response.fold(
      (failure) => state = OrdersError(failure.message),
      (openOrderModels) {
        final List<Order> openOrders = openOrderModels.map((o) => o).toList();
        openOrders.sort((a, b) => b.time.compareTo(a.time));

        state = OrdersLoaded(openOrders: openOrders);

        _subscription = _userDataStream.stream().listen(
              (data) => _updateOrders(data),
              onError: (error) => state = OrdersError('Something went wrong.'),
              cancelOnError: true,
            );
      },
    );
  }

  void _updateOrders(dynamic report) {
    if (!(report is UserDataPayloadOrderUpdate)) return;
    if (!(state is OrdersLoaded)) return;

    final List<Order> openOrders = (state as OrdersLoaded).openOrders;
    final List<Order> orderHistory = (state as OrdersLoaded).orderHistory.isEmpty ? [] : (state as OrdersLoaded).orderHistory;
    final List<Trade> tradeHistory = (state as OrdersLoaded).tradeHistory.isEmpty ? [] : (state as OrdersLoaded).tradeHistory;

    final openOrdersIndex = openOrders.indexWhere((element) => element.symbol == report.symbol && element.orderId == report.orderId);
    final orderHistoryIndex = orderHistory.indexWhere((element) => element.symbol == report.symbol && element.orderId == report.orderId);

    final orderFromReport = Order(
      symbol: report.symbol,
      orderId: report.orderId,
      orderListId: report.orderListId,
      clientOrderId: report.originalClientOrderId == '' ? report.clientOrderId : report.originalClientOrderId,
      price: report.orderPrice,
      origQty: report.orderQuantity,
      executedQty: report.cumulativeFilledQuantity,
      cummulativeQuoteQty: report.cumulativeQuoteAssetTransactedQuantity,
      status: report.currentOrderStatus,
      timeInForce: report.timeInForce,
      type: report.orderType,
      side: report.side,
      stopPrice: report.stopPrice,
      icebergQty: report.icebergQuantity,
      time: report.orderCreationTime,
      updateTime: report.transactionTime,
      isWorking: report.orderIsOnTheBook,
      origQuoteOrderQty: report.quoteOrderQuantity,
    );

    //Open Orders
    if (openOrdersIndex == -1) {
      // Not found in openOrders -> Add it
      openOrders.insert(0, orderFromReport);
    } else {
      switch (report.currentOrderStatus) {
        case BinanceOrderStatus.NEW:
        case BinanceOrderStatus.PARTIALLY_FILLED:
        case BinanceOrderStatus.PENDING_CANCEL:
          openOrders[openOrdersIndex] = orderFromReport;
          break;
        case BinanceOrderStatus.FILLED:
        case BinanceOrderStatus.CANCELED:
        case BinanceOrderStatus.REJECTED:
        case BinanceOrderStatus.EXPIRED:
          openOrders.removeAt(openOrdersIndex);
          break;
      }
    }

    // Order History
    if (orderHistoryIndex == -1) {
      if (report.currentOrderStatus == BinanceOrderStatus.PARTIALLY_FILLED ||
          report.currentOrderStatus == BinanceOrderStatus.FILLED ||
          report.currentOrderStatus == BinanceOrderStatus.CANCELED ||
          report.currentOrderStatus == BinanceOrderStatus.EXPIRED) {
        orderHistory.insert(0, orderFromReport);
      }
    } else {
      if (report.currentOrderStatus == BinanceOrderStatus.PARTIALLY_FILLED || report.currentOrderStatus == BinanceOrderStatus.FILLED) {
        //BinanceOrderStatus.CANCELED && BinanceOrderStatus.EXPIRED do not affect order data already inside orderHistory
        //Those orders would just remain with their last status
        orderHistory[orderHistoryIndex] = orderFromReport;
      }
    }

    //Trade History
    if (report.currentExecutionType == BinanceOrderExecutionType.TRADE) {
      tradeHistory.insert(
        0,
        Trade(
          symbol: report.symbol,
          orderId: report.orderId,
          price: report.lastExecutedPrice,
          executedQty: report.lastExecutedQuantity,
          quoteQty: report.lastQuoteAssetTransactedQuantity,
          side: report.side,
          time: report.transactionTime,
          tradeId: report.tradeId,
          commisionAmount: report.commisionAmount,
          commisionAsset: report.commisionAsset ?? '',
        ),
      );
    }

    state = OrdersLoaded(openOrders: openOrders, orderHistory: orderHistory, tradeHistory: tradeHistory);
  }
}
