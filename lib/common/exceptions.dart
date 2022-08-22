// ignore_for_file: constant_identifier_names

import 'package:dictionary_app/common/strings.dart';

class DictException<T> implements Exception {
  late final T type;
  late final String message;
}

/// === API Exception ===
///
/// All exceptions realated to rest-api call goes in this
/// category.
enum ApiExceptionType {
  NotFound,
  InvalidAccessToken,
  UnAuthorized,
  SerializationError,
  Timeout,
  BadRequest,
  ServerError,
  Other,
  SocketException
}

class ApiException implements DictException<ApiExceptionType> {
  @override
  String message;

  @override
  ApiExceptionType type;

  ApiException(this.message, {this.type = ApiExceptionType.Other});

  @override
  String toString() => "$type, Message: $message";
}

/// Throwed when dio error has type [DioError.connectTimeout], [DioErrorType.receiveTimeout] or [DioErrorType.sendTimeout]
/// All of the above error types are mapped to one exception type
var apiTimeOutException =
    ApiException(networkErrorMessage, type: ApiExceptionType.Timeout);

/// Throwed when dio error has type [DioError.other] and error is [SocketException]
/// All of the above error types are mapped to one exception type
var apiSocketException =
    ApiException(networkErrorMessage, type: ApiExceptionType.SocketException);

/// Throwed when dio error has type [DioError.response] and has status code 500
var apiServerErrorException =
    ApiException(serverErrorMessage, type: ApiExceptionType.ServerError);

/// When error is not of any type and cannot be determined goes into this category
var apiUnKnownException = ApiException(unknowErrorMessage);

/// Throwed when dio error has type [DioError.response] and has a status code 404
var throw404Exception = (String message) =>
    throw ApiException(message, type: ApiExceptionType.NotFound);

/// Throwed when dio error has type [DioError.response] and has a status code 401
var throwUnAuthorizedException = (String message) =>
    throw ApiException(message, type: ApiExceptionType.UnAuthorized);

/// Throwed when dio error has type [DioError.response] and has a status code 400
var throw400Exception = (String message) =>
    throw ApiException(message, type: ApiExceptionType.BadRequest);
