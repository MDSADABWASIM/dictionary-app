import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dictionary_app/common/api_endpoints.dart';
import 'package:dictionary_app/models/word_model.dart';
import 'package:dictionary_app/services/base_api_service.dart';

class DictApiService extends BaseApiService {
  setAuthToken() {
    String token = "Token ${dotenv.env["API_KEY"]}";
    client!.options.headers[HttpHeaders.authorizationHeader] = token;
  }

  Future<WordModel> getWordDefinationFromAPI(String word) async {
    setAuthToken();
    Response httpResponse =
        await runDioErrorFuture(client!.get("$dict_api_url/$word"));
    try {
      return WordModel.fromMap(httpResponse.data);
    } catch (e) {
      debugPrint(e.toString());
      throw serializationError();
    }
  }
}
