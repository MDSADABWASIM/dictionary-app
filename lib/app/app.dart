import 'package:dictionary_app/services/dict_api_service.dart';
import 'package:dictionary_app/ui/home_page/home_page_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

//Added all routes and services to generate helper functions,
//for router and service locator.
@StackedApp(
  routes: [
    MaterialRoute(page: HomePage,initial: true),
  ],
  dependencies: [
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DictApiService),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
