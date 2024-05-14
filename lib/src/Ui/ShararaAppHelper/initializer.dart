
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaAppHelperInitializer {
  static Future<bool> initialize({final bool withHiveFlutter = true})async{
    await ConstantsBoxesNames.initialize();
    return true;
  }
}