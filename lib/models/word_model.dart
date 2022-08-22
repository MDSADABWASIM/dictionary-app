import 'dart:convert';

import 'defination_model.dart';

WordModel wordModelFromMap(String str) => WordModel.fromMap(json.decode(str));

String wordModelToMap(WordModel data) => json.encode(data.toMap());

class WordModel {
  WordModel({
    this.word,
    this.pronunciation,
    this.definitions,
  });

  String? word;
  String? pronunciation;
  List<Definition>? definitions;

  factory WordModel.fromMap(Map<String, dynamic> json) => WordModel(
        word: json["word"] ?? "",
        pronunciation: json["pronunciation"] ?? "",
        definitions: json["definitions"] == null
            ? null
            : List<Definition>.from(
                json["definitions"].map((x) => Definition.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "word": word ?? "",
        "pronunciation": pronunciation ?? "",
        "definitions": definitions == null
            ? null
            : List<dynamic>.from(definitions!.map((x) => x.toMap())),
      };
}
