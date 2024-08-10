import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  test(
    'should be a subClass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the json number is integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the json number is regarded as a double',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('trivia_double.json'));

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tNumberTriviaModel.toJson();
          // assert
          final expectedJsonMap = {'number': 1, 'text': 'Test Text'};
          expect(result, expectedJsonMap);
        },
      );
    },
  );


}
