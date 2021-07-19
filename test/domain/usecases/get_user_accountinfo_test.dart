import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/get_user_accountinfo.dart';
import 'get_user_accountinfo_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetAccountInfo usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetAccountInfo(mockUserRepository);
  });

  final UserData tUserData = UserData(
    updateTime: 123456789,
    makerCommission: 15,
    takerCommission: 15,
    buyerCommission: 0,
    sellerCommission: 0,
    canTrade: true,
    canWithdraw: true,
    canDeposit: true,
    accountType: 'SPOT',
    balances: [
      Balance(asset: 'BTC', free: Decimal.parse('4723846.89208129'), locked: Decimal.parse('0.00000000')),
      Balance(asset: 'LTC', free: Decimal.parse('4763368.68006011'), locked: Decimal.parse('0.00000000')),
    ],
    permissions: ['SPOT'],
  );

  test(
    'should return user data when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.getAccountInfo()).thenAnswer((_) async => Right(tUserData));
      //act
      final Either<Failure, UserData>? result = await usecase(NoParams());
      //assert
      verify(mockUserRepository.getAccountInfo());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(tUserData));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserRepository.getAccountInfo()).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, UserData>? result = await usecase(NoParams());
      //assert
      verify(mockUserRepository.getAccountInfo());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
