

import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable{
  final int number;
  final String text;

  const NumberTrivia({required this.number, required this.text});
  @override
  // TODO: implement props
  List<Object?> get props => [number, text];


}