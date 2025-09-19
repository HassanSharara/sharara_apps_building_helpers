
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaAppHelperInitializer {
  static Future<bool> initialize({
    final bool withHiveFlutter = false,
    final String? subdirOfHive,
    final List<String> initTheseBoxesNames = const [],
  final List<String> lazyBoxesNames = const []
  })async{
    if ( withHiveFlutter ) {
      await Hive.initFlutter(subdirOfHive);
    }
    await ConstantsBoxesNames.initialize(injectedBoxesNames:initTheseBoxesNames,
    lazyBoxesNames:lazyBoxesNames
    );
    return true;
  }
}