import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:dictionary_app/common/exceptions.dart';
import 'package:dictionary_app/common/strings.dart';
import 'package:dictionary_app/models/generic_response.dart';

abstract class BaseApiService {
  Dio? _client;
  Dio? get client => _client;

  String? _baseUrl;
  String? get baseUrl => _baseUrl;

  Dio createDio() {
    Dio dio = Dio(BaseOptions(
        connectTimeout: 100000, receiveTimeout: 1000000, baseUrl: _baseUrl!));

    dio.interceptors.add(LogInterceptor(
        requestHeader: true, responseBody: true, requestBody: true));

    return dio;
  }

  BaseApiService({baseUrl}) {
    if (baseUrl != null) {
      _baseUrl = baseUrl;
    } else {
      _baseUrl = dotenv.env["BASE_URL"];
    }
    _client = createDio();
  }

  String? getErrorMessage(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    try {
      final GenericResponse response = GenericResponse.fromMap(data);
      return response.message;
    } catch (e) {
      return null;
    }
  }

  ApiException serializationError() {
    return ApiException(serverErrorMessage,
        type: ApiExceptionType.SerializationError);
  }

  String? getResponseErroMessage(response) {
    if (response?.data is String) {
      return response?.data;
    } else if (response?.data is Map<String, dynamic>) {
      return getErrorMessage(response?.data);
    } else {
      return null;
    }
  }

  Future<T> runDioErrorFuture<T>(Future<T> future) async {
    try {
      return await future;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          throw apiTimeOutException;
        case DioErrorType.sendTimeout:
          throw apiTimeOutException;
        case DioErrorType.receiveTimeout:
          throw apiTimeOutException;
        case DioErrorType.response:
          int? statusCode = e.response?.statusCode;
          String? message = getResponseErroMessage(e.response);

          if (statusCode == 404) {
            throw404Exception(message ?? notFoundErrorMessage);
          } else if (statusCode == 401 || statusCode == 403) {
            throwUnAuthorizedException(message ?? noAuthorizationErrorMessage);
          } else if (statusCode == 400) {
            throw400Exception(message ?? badRequestErrorMessage);
          } else if (statusCode == 500) {
            throw apiServerErrorException;
          } else {
            throw ApiException(unknowErrorMessage);
          }
        case DioErrorType.other:
          if (e.error is SocketException) {
            throw apiSocketException;
          }
          throw apiUnKnownException;
        default:
          throw apiUnKnownException;
      }
    }
  }
}
