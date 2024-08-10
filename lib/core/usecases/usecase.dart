
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';



// Parameters have to be put into a container object so that they can be
// included in this abstract base class method definition.

abstract class Usecase<Type, Params>{
 Future<Either<Failure, Type?>?> call(Params params);
}

class Params extends Equatable{
   int number;
   Params({required this.number});

  @override
  List<Object?> get props => [number];
}

class NoParams extends Equatable{

  @override
  List<Object?> get props => [];
}