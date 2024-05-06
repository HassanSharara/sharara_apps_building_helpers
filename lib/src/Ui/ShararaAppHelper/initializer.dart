
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaAppHelperInitializer {
  static Future<bool> initialize({final bool withHiveFlutter = true})async{
    await Hive.initFlutter();
    await ConstantsBoxesNames.initialize();
    return true;
  }
}