
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';
import 'package:sharara_apps_building_helpers/src/Security/security1.dart';
import 'package:sharara_apps_building_helpers/src/Ui/ShararaAppHelper/context_and_main_scaffold_initializer.dart';

final class InitSecurity {

  final String packageName;
  final String? teamId;
  final String? watcherMail;
  final List<String> androidCertHashes ;
  final List<String> iosBundleIds;

  const InitSecurity({required this.packageName,  this.teamId,  this.watcherMail, required this.androidCertHashes, required this.iosBundleIds});
}
class ShararaAppHelperInitializer {
  @pragma("vm:prefer-inline")
  static void setDebugMode(){
    ContextAndMainScaffoldInitializer.init();
    ContextAndMainScaffoldInitializer.mInit();
  }


  static String formatCertHashForFreeRasp(String hexString) {
    // 1. Strip out all colons and spaces
    final cleanHex = hexString.replaceAll(':', '').replaceAll(' ', '');

    // 2. Convert the hex string into raw byte integers
    final List<int> bytes = [];
    for (int i = 0; i < cleanHex.length; i += 2) {
      final hexPair = cleanHex.substring(i, i + 2);
      bytes.add(int.parse(hexPair, radix: 16));
    }

    // 3. Encode the raw bytes directly to Base64
    return base64.encode(bytes);
  }
  static Future<bool> initialize({
    final bool withHiveFlutter = false,
    final bool  withOuter = false,
    final String? subdirOfHive,
    final InitSecurity? initSecurity,
    final List<String> initTheseBoxesNames = const [],
  final List<String> lazyBoxesNames = const [],
  })async{
    if ( withHiveFlutter ) {
      await Hive.initFlutter(subdirOfHive);
    }
    if(withOuter) OuterScreenMaskController.init();
    await ConstantsBoxesNames.initialize(injectedBoxesNames:initTheseBoxesNames,
    lazyBoxesNames:lazyBoxesNames
    );
    final Map<Object,Object> ao = ContextAndMainScaffoldInitializer.map;
    if( !(ao["threats_applied"]  == true && ao["invalid_env"] == true
        && ao["exit"] == true && ao["exit2"] == false
        && ao['exit3'] == false) || initSecurity != null  ) {
      if( initSecurity == null ) {
        throw Exception("invalid security trick you should enable debug mode to this library");
      }
      await ShararaSecurity1.init(initSecurity);
    }
    return true;
  }
}