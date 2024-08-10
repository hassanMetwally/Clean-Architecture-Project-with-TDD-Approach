import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {

  NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure , NumberTrivia?>?> call(Params params) async{
    return await repository.getConcreteNumberTrivia(params.number);
  }

}