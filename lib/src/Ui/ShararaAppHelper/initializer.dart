
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaAppHelperInitializer {
  static Future<bool> initialize({final bool withHiveFlutter = true,
  final List<String> initTheseBoxesNames = const [],
  final List<String> lazyBoxesNames = const []
  })async{
    await ConstantsBoxesNames.initialize(injectedBoxesNames:initTheseBoxesNames,
    lazyBoxesNames:lazyBoxesNames
    );
    return true;
  }
}