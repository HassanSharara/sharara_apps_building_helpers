import 'package:hive/hive.dart';

class ConstantsBoxesNames {

  static const String prefix = "ShararaAppsBuildingHelpersDefaultThemeCacheManager";
  static const String defaultThemeUiCacheManager = "${prefix}DefaultThemeUiCache==";
  static const String defaultDirectionalityCacheManager = "${prefix}DefaultDirectionalityCache==";

  static List<String> get allSystems => [
    defaultThemeUiCacheManager,
    defaultDirectionalityCacheManager,
  ];

  static Future<void> initialize({
    final List<String> injectedBoxesNames = const [],
    final List<String> lazyBoxesNames = const []
})async{
    for (final String cacheSystemName in (allSystems + injectedBoxesNames)){
      if( ! Hive.isBoxOpen(cacheSystemName)){
       await Hive.openBox(cacheSystemName);
      }
    }

    for(final String cacheSystemName in (lazyBoxesNames)){
      if( ! Hive.isBoxOpen(cacheSystemName)){
        await Hive.openLazyBox(cacheSystemName);
      }
    }
  }
}