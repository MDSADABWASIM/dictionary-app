import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dictionary_app/common/assets_name.dart';
import 'package:dictionary_app/common/colors.dart';
import 'package:dictionary_app/common/fontstyle.dart';
import 'package:dictionary_app/common/strings.dart';
import 'package:dictionary_app/ui/home_page/home_page_viewmodel.dart';
import 'package:dictionary_app/ui/home_page/widgets/text_card_widget.dart';
import 'package:stacked/stacked.dart';
import '../../models/defination_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageViewModel model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageViewModel>.reactive(
      viewModelBuilder: () => HomePageViewModel(),
      onModelReady: (viewModel) async {
        model = viewModel;
        await viewModel.initSpeech();
      },
      builder: (BuildContext context, HomePageViewModel model, Widget? child) {
        return ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(color: kBaseColor),
          inAsyncCall: model.iswordLoading,
          child: Scaffold(
              appBar: _appbar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    model.definationLoaded ? definationBody() : initialBody()
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: micIconButton()),
        );
      },
    );
  }

  Widget micIconButton() {
    return AvatarGlow(
      animate: model.isListening,
      glowColor: Theme.of(context).primaryColor,
      endRadius: 75.0,
      duration: const Duration(milliseconds: 2000),
      repeatPauseDuration: const Duration(milliseconds: 100),
      repeat: true,
      child: FloatingActionButton(
        onPressed:
            model.isListening ? model.stopListening : model.startListening,
        child: const Icon(
          Icons.mic_outlined,
        ),
      ),
    );
  }

  Widget initialBody() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          model.isListening ? model.words : model.speechStatus,
          style: headerTextStyle,
        ),
      ),
    );
  }

  Widget definationBody() {
    return model.hasException ? wordNotFoundWidget() : wordDefinationWidget();
  }

  Widget wordNotFoundWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        '$yourWordText:\n${model.words}\n\n$notFound\n$tryAgainMessage',
        style: headerTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget wordDefinationWidget() {
    Definition definition = model.wordModel.definitions!.first;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            '$yourWordText:\n${model.words}',
            style: headerTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        TextCardWidget(title: meaningText, body: definition.definition!),
        const SizedBox(height: 20),
        TextCardWidget(title: exampleText, body: definition.example!),
        const SizedBox(height: 20),
        definition.imageUrl!.isNotEmpty
            ? Image.network(
                definition.imageUrl!,
                height: 200,
                width: 200,
              )
            : Image.asset(
                imageNotFound,
                height: 200,
                width: 200,
              )
      ],
    );
  }

  PreferredSizeWidget _appbar() {
    return AppBar(
      title: const Text(appbarTitleText),
      centerTitle: true,
    );
  }
}
