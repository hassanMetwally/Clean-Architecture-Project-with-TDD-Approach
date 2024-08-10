import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';


class MocKNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MocKNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MocKNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get TRIVIA for the NUMBER from the REPOSITORY',
    () async {

      // arrange
      // "On the fly" implementation of the Repository using the Mockito package.
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async =>  const Right(tNumberTrivia));

      // act
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase(Params(number: tNumber));

      // assert
      // UseCase should simply return whatever was returned from the Repository
      expect(result, const Right(tNumberTrivia));
      // Verify that the method has been called on the Repository
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },

  );

}
