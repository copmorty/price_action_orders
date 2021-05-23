import 'dart:async';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_orderupdate.dart';
import 'package:price_action_orders/domain/usecases/get_userdata_openorders.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';

part 'orders_state.dart';

class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOpenOrders _getOpenOrders;
  final UserDataStream _userDataStream;
  StreamSubscription _subscription;

  OrdersNotifier({
    @required GetOpenOrders getOpenOrders,
    @required UserDataStream userDataStream,
    bool start = true,
  })  : _getOpenOrders = getOpenOrders,
        _userDataStream = userDataStream,
        super(OrdersInitial()) {
    if (start) this.getOpenOrders();
  }

  Future<void> getOpenOrders() async {
    state = OrdersLoading();

    final response = await _getOpenOrders(NoParams());
    response.fold(
      (failure) => state = OrdersError('failure.message'),
      (openOrderModels) {
        final List<Order> openOrders = openOrderModels.map((o) => o).toList();
        openOrders.sort((a, b) => b.time.compareTo(a.time));
        state = OrdersLoaded(openOrders: openOrders);
        _subscription = _userDataStream.stream().listen((data) => _checkForUpdate(data));
      },
    );
  }

  void _checkForUpdate(dynamic data) {
    if (data is UserDataPayloadOrderUpdate) {
      _updateOrders(data);
    }
  }

  void _updateOrders(UserDataPayloadOrderUpdate report) {
    print('_updateOrders');
    print(report.transactionTime);
    if (!(state is OrdersLoaded)) return;
    final List<Order> openOrders = (state as OrdersLoaded).openOrders;
    final List<Order> orderHistory = (state as OrdersLoaded).orderHistory.isEmpty ? [] : (state as OrdersLoaded).orderHistory;
    final List<Order> tradeHistory = (state as OrdersLoaded).tradeHistory.isEmpty ? [] : (state as OrdersLoaded).tradeHistory;

    final openOrdersIndex = openOrders.indexWhere((element) => element.symbol == report.symbol && element.orderId == report.orderId);
    final orderHistoryIndex = orderHistory.indexWhere((element) => element.symbol == report.symbol && element.orderId == report.orderId);
    final tradeHistoryIndex = tradeHistory.indexWhere((element) => element.symbol == report.symbol && element.orderId == report.orderId);

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
    // PARTIALLY_FILLED, FILLED, CANCELED, EXPIRED
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
    //PARTIALLY_FILLED, FILLED
    // if (tradeHistoryIndex == -1) {
    //   if (report.currentOrderStatus == BinanceOrderStatus.PARTIALLY_FILLED || report.currentOrderStatus == BinanceOrderStatus.FILLED) {
    //     final reportedOrder = Order(
    //       symbol: report.symbol,
    //       orderId: report.orderId,
    //       orderListId: report.orderListId,
    //       clientOrderId: report.clientOrderId,
    //       price: report.orderPrice,
    //       origQty: report.orderQuantity,
    //       executedQty: report.cumulativeFilledQuantity, //--
    //       cummulativeQuoteQty: report.cumulativeQuoteAssetTransactedQuantity, //--
    //       status: report.currentOrderStatus, //--
    //       timeInForce: report.timeInForce,
    //       type: report.orderType,
    //       side: report.side,
    //       stopPrice: report.stopPrice,
    //       icebergQty: report.icebergQuantity,
    //       time: report.transactionTime,
    //       updateTime: report.transactionTime, //--
    //       isWorking: false, //--
    //       origQuoteOrderQty: report.quoteOrderQuantity,
    //     );
    //     tradeHistory.insert(0, reportedOrder);
    //   }
    // } else {
    //   if (report.currentOrderStatus == BinanceOrderStatus.PARTIALLY_FILLED || report.currentOrderStatus == BinanceOrderStatus.FILLED) {
    //     final oldOrder = tradeHistory[tradeHistoryIndex];
    //     tradeHistory[tradeHistoryIndex] = Order(
    //       symbol: oldOrder.symbol,
    //       orderId: oldOrder.orderId,
    //       orderListId: oldOrder.orderListId,
    //       clientOrderId: oldOrder.clientOrderId,
    //       price: oldOrder.price,
    //       origQty: oldOrder.origQty,
    //       executedQty: report.cumulativeFilledQuantity, //--
    //       cummulativeQuoteQty: report.cumulativeQuoteAssetTransactedQuantity, //--
    //       status: report.currentOrderStatus, //--
    //       timeInForce: oldOrder.timeInForce,
    //       type: oldOrder.type,
    //       side: oldOrder.side,
    //       stopPrice: oldOrder.stopPrice,
    //       icebergQty: oldOrder.icebergQty,
    //       time: oldOrder.time,
    //       updateTime: report.transactionTime, //--
    //       isWorking: report.orderIsOnTheBook, //--
    //       origQuoteOrderQty: oldOrder.origQuoteOrderQty,
    //     );
    //   }
    // }

    state = OrdersLoaded(openOrders: openOrders, orderHistory: orderHistory, tradeHistory: tradeHistory);
  }
}
