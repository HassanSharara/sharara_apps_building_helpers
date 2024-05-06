import 'package:hive/hive.dart';

class ConstantsBoxesNames {

  static const String prefix = "ShararaAppsBuildingHelpersDefaultThemeCacheManager";
  static const String defaultThemeUiCacheManager = "${prefix}DefaultThemeUiCache==";
  static const String defaultDirectionalityCacheManager = "${prefix}DefaultDirectionalityCache==";

  static List<String> get allSystems => [
    defaultThemeUiCacheManager,
    defaultDirectionalityCacheManager,
  ];

  static Future<void> initialize()async{
    for (final String cacheSystemName in allSystems){
      if( ! Hive.isBoxOpen(cacheSystemName)){
       await Hive.openBox(cacheSystemName);
      }
    }
  }
}