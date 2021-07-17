import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/logic/orderconfig_state_notifier.dart';

void main() {
  OrderConfigNotifier/*!*/ notifier;

  setUp(() {
    notifier = OrderConfigNotifier();
  });

  group('setLoading', () {
    test(
      'should state OrderConfigInitial and OrderConfigLoading after first time call',
      () async {
        //arrange
        final List<OrderConfigState> tStates = [
          OrderConfigInitial(),
          OrderConfigLoading(),
        ];
        final List<OrderConfigState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        //act
        notifier.setLoading();
        //assert
        expect(actualStates, tStates);
      },
    );
  });

  group('setLoaded', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should state OrderConfigInitial and OrderConfigLoaded after first time call',
      () async {
        //arrange
        final List<OrderConfigState> tStates = [
          OrderConfigInitial(),
          OrderConfigLoaded(tTicker),
        ];
        final List<OrderConfigState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        //act
        notifier.setLoaded(tTicker);
        //assert
        expect(actualStates, tStates);
      },
    );
  });
}
