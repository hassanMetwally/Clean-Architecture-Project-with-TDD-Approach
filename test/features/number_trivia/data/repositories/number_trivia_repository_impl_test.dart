import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
  final NumberTrivia tNumberTrivia = tNumberTriviaModel;

  runTestsOnline(Function body) {
    group(
      'Device is online',
      () {
        setUp(
          () {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => true);
          },
        );
        body();
      },
    );
  }

  runTestsOffLine(Function body) {
    group(
      'Device is offline',
      () {
        setUp(
          () {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => false);
          },
        );
        body();
      },
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      test(
        'should check if the device is online',
        () {
          // arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          //act
          repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(() => mockNetworkInfo.isConnected);
        },
      );

      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                .thenAnswer((_) async => tNumberTriviaModel);

            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);

            // assert
            expect(result, Right(tNumberTriviaModel));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                .thenAnswer((_) async => tNumberTriviaModel);

            // act
            await repository.getConcreteNumberTrivia(tNumber);

            // assert
            verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source unsuccessful',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                .thenThrow(ServerException());

            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);

            // assert
            expect(result, Left(ServerFailure()));
          },
        );
      });

      runTestsOffLine(() {
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);

            // assert
            // verifyZeroInteractions(mockLocalDataSource);
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTriviaModel)));
          },
        );

        test(
          'should return cache failure when there is no cache data is present',
          () async {
            // arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);

            //assert
            expect(result, Left(CacheFailure()));
          },
        );
      });
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      test(
        'should check if the device is online',
        () {
          //arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          //act
          repository.getRandomNumberTrivia();

          //assert
          verify(() => mockNetworkInfo.isConnected);
        },
      );

      runTestsOnline(
        () {
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);

              // act
              final result = await repository.getRandomNumberTrivia();

              // assert
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              expect(result, Right(tNumberTrivia));
            },
          );
          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);

              // act
              await repository.getRandomNumberTrivia();

              // assert
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              verify(() =>
                  mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );

          test(
            'should return server failure when the call to remote data source unsuccessful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());

              // act
              final result = await repository.getRandomNumberTrivia();

              // assert
              expect(result, Left(ServerFailure()));
              // verify(()=> mockRemoteDataSource.getRandomNumberTrivia());
            },
          );
        },
      );

      runTestsOffLine(
        () {
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              // arrange
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);

              // act
              final result = await repository.getRandomNumberTrivia();

              // assert
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, Right(tNumberTriviaModel));
            },
          );
          test(
            'should return cache failure when there is no cache data is present',
            () async {
              // arrange
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              // act
              final result = await repository.getRandomNumberTrivia();

              // assert
              expect(result, Left(CacheFailure()));
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              verifyZeroInteractions(mockRemoteDataSource);
            },
          );
        },
      );
    },
  );
}
