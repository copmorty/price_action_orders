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
    state = Ordersloading();

    final response = await _getOpenOrders(NoParams());
    response.fold(
      (failure) => state = OrdersError('failure.message'),
      (openOrders) {
        openOrders.removeWhere((order) => order.isWorking != true);
        openOrders.sort((a, b) => b.time.compareTo(a.time));
        state = OrdersLoaded(openOrders);
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
    // final List<Order> openOrders = (state as OrdersLoaded).openOrders;
    final List<Order> openOrders = (state as OrdersLoaded).openOrders.map((o) => o).toList();

    final orderIndex = openOrders.indexWhere((element) => element.orderId == report.orderId);
    if (orderIndex == -1) {
      openOrders.insert(
        0,
        Order(
          symbol: report.symbol,
          orderId: report.orderId,
          orderListId: report.orderListId,
          clientOrderId: report.clientOrderId,
          price: report.orderPrice,
          origQty: report.orderQuantity,
          executedQty: report.cumulativeFilledQuantity, //--
          cummulativeQuoteQty: report.cumulativeQuoteAssetTransactedQuantity, //--
          status: report.currentOrderStatus, //--
          timeInForce: report.timeInForce,
          type: report.orderType,
          side: report.side,
          stopPrice: report.stopPrice,
          icebergQty: report.icebergQuantity,
          time: report.transactionTime,
          updateTime: report.transactionTime, //--
          isWorking: report.orderIsOnTheBook, //--
          origQuoteOrderQty: report.quoteOrderQuantity,
        ),
      );
    } else {
      switch (report.currentOrderStatus) {
        case BinanceOrderStatus.NEW:
        case BinanceOrderStatus.PARTIALLY_FILLED:
        case BinanceOrderStatus.PENDING_CANCEL:
          final oldOrder = openOrders[orderIndex];
          openOrders[orderIndex] = Order(
            symbol: oldOrder.symbol,
            orderId: oldOrder.orderId,
            orderListId: oldOrder.orderListId,
            clientOrderId: oldOrder.clientOrderId,
            price: oldOrder.price,
            origQty: oldOrder.origQty,
            executedQty: report.cumulativeFilledQuantity, //--
            cummulativeQuoteQty: report.cumulativeQuoteAssetTransactedQuantity, //--
            status: report.currentOrderStatus, //--
            timeInForce: oldOrder.timeInForce,
            type: oldOrder.type,
            side: oldOrder.side,
            stopPrice: oldOrder.stopPrice,
            icebergQty: oldOrder.icebergQty,
            time: oldOrder.time,
            updateTime: report.transactionTime, //--
            isWorking: report.orderIsOnTheBook, //--
            origQuoteOrderQty: oldOrder.origQuoteOrderQty,
          );
          break;
        default:
          openOrders.removeAt(orderIndex);
      }
    }

    // switch (report.currentOrderStatus) {
    //   case BinanceOrderStatus.NEW:
    //     openOrders.insert(
    //       0,
    //       Order(
    //         symbol: report.symbol,
    //         orderId: report.orderId,
    //         orderListId: report.orderListId,
    //         clientOrderId: report.clientOrderId,
    //         price: report.orderPrice,
    //         origQty: report.orderQuantity,
    //         executedQty: report.cumulativeFilledQuantity, //--
    //         cummulativeQuoteQty: report.cumulativeQuoteAssetTransactedQuantity, //--
    //         status: report.currentOrderStatus, //--
    //         timeInForce: report.timeInForce,
    //         type: report.orderType,
    //         side: report.side,
    //         stopPrice: report.stopPrice,
    //         icebergQty: report.icebergQuantity,
    //         time: report.transactionTime,
    //         updateTime: report.transactionTime, //--
    //         isWorking: report.orderIsOnTheBook, //--
    //         origQuoteOrderQty: report.quoteOrderQuantity,
    //       ),
    //     );
    //     break;
    //   case BinanceOrderStatus.PARTIALLY_FILLED:
    //   case BinanceOrderStatus.PENDING_CANCEL:
    //     if (orderIndex == -1) return;
    //     final oldOrder = openOrders[orderIndex];
    //     openOrders[orderIndex] = Order(
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
    //     break;
    //   default:
    //     if (orderIndex == -1) return;
    //     openOrders.removeAt(orderIndex);
    // }

    state = OrdersLoaded(openOrders);
  }
}
