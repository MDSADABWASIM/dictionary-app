// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import 'exceptions.dart';

String getApiExceptionKey(ApiExceptionType type, Object key) {
  return '${type.hashCode}-${key.hashCode}';
}

mixin DictExceptionHandler on BaseViewModel {
  final SnackbarService _snackbarService = locator<SnackbarService>();


  /// Api exception helpers
  bool get hasApiExceptionError => hasError && modelError is ApiException;

  bool hasApiException(ApiExceptionType type) {
    if (!hasApiExceptionError) {
      return false;
    }

    ApiException exception = modelError as ApiException;
    return exception.type == type;
  }

  bool get hasAuthorizationError => hasApiException(ApiExceptionType.NotFound);
  bool get hasTimeoutError => hasApiException(ApiExceptionType.Timeout);
  bool get hasServerError => hasApiException(ApiExceptionType.ServerError);
  bool get hasSerializationError => hasApiException(ApiExceptionType.SerializationError);
  bool get hasBadRequestError => hasApiException(ApiExceptionType.BadRequest);

  Future<T> runExceptionFuture<T>(Future<T> future,
      {bool throwException = false,
      Object? busyObject,
      bool showSnackbar = true}) async {
    setError(null);
    try {
      var value = await future;
      return value;
    } on DictException catch (e) {
      if (busyObject == null) {
        setErrorForObject(this, e);
      } else {
        setErrorForObject(busyObject, e);
      }
      // logging exception message
      debugPrint(e.message);

      if (showSnackbar) _snackbarService.showSnackbar(message: e.message);

      if (throwException) rethrow;
      return Future.value();
    }
  }

  Object? runExceptionFunction(Function function,
      {bool throwException = false,
      Object? busyObject,
      bool showSnackbar = true})  {
    setError(null);
    try {
      return function();
    } on DictException catch (e) {
      if (busyObject == null) {
        setErrorForObject(this, e);
      } else {
        setErrorForObject(busyObject, e);
      }
      // logging exception message
      debugPrint(e.message);
      
      if (showSnackbar) _snackbarService.showSnackbar(message: e.message);

      if (throwException) rethrow;

      return null;
    }
  }

  Future<T> runExceptionBusyFuture<T>(Future<T> future,
      {bool throwException = false,
      Object? busyObject,
      bool showSnackbar = true}) async {
    if (busyObject == null) {
      setBusy(true);
    } else {
      setBusyForObject(busyObject, true);
    }
    try {
      var value = await runExceptionFuture(future,
          throwException: throwException, showSnackbar: showSnackbar);
      if (busyObject == null) {
        setBusy(false);
      } else {
        setBusyForObject(busyObject, false);
      }
      return value;
    } catch (e) {
      if (busyObject == null) {
        setBusy(false);
      } else {
        setBusyForObject(busyObject, false);
      }
      if (throwException) rethrow;

      return Future.value();
    }
  }
}
