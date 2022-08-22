import 'package:flutter/material.dart';
import 'package:dictionary_app/common/strings.dart';
import 'package:dictionary_app/models/word_model.dart';
import 'package:dictionary_app/services/dict_api_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';
import '../../common/exception_handler_mixin.dart';

class HomePageViewModel extends BaseViewModel with DictExceptionHandler {
  final DictApiService _dictApiService = locator<DictApiService>();
  bool _speechEnabled = false;
  String _lastWords = '';
  final wordLoadingKey = 'word-key';
  final SpeechToText speechToText = SpeechToText();
  WordModel _wordModel = WordModel();

  bool get iswordLoading => busy(wordLoadingKey);
  WordModel get wordModel => _wordModel;
  bool get speechEnabled => _speechEnabled;
  String get words => _lastWords;
  bool get isWordNotEmpty => _lastWords.isNotEmpty;
  bool get isListening => speechToText.isListening;
  bool get hasException => hasApiExceptionError;
  bool get definationLoaded => isWordNotEmpty && iswordLoading == false;
  String get speechStatus => status();

  String status() {
    if (speechEnabled && iswordLoading == false) {
      return pressButtonText;
    } else if (speechEnabled == false && iswordLoading == false) {
      return speechNotAvailableText;
    } else {
      return '';
    }
  }

  Future<void> initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    notifyListeners();
  }

  void startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    notifyListeners();
  }

  void stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    if (_lastWords.isNotEmpty) {
      getWordDefination(_lastWords);
    }
  }

  Future<void> getWordDefination(String word) async {
    try {
      _wordModel = await runExceptionBusyFuture(
          _dictApiService.getWordDefinationFromAPI(word),
          throwException: true,
          showSnackbar: false,
          busyObject: wordLoadingKey);
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}
