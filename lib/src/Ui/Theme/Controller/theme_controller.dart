
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Cache/Systems/DefaultUiCacheManager/default_ui_cache_manager.dart';
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaThemeController {
  final Map<String,ShararaTheme> themes = {} ;
  late final DefaultUiCacheManager cacheManager;
  ShararaThemeController._(){
    cacheManager = DefaultUiCacheManager(boxName:ConstantsBoxesNames.defaultThemeUiCacheManager);
    init();
  }
  static Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;
   switchBrightness()async{
    final Brightness brightness = _brightness ==
        Brightness.light ? Brightness.dark:
    Brightness.light;
   _brightness = brightness;
    instance._refreshThemes();
    instance._saveBrightness();
    changeTheme(instance.getCachedTheme);
  }
  static List<ShararaTheme> get _defaultThemes => [
    ShararaTheme(themeName: "الازرق", themeId: "default",brightness:_brightness),
    ShararaTheme(themeName: "الاندييجو",mainColor:Colors.indigo,brightness:_brightness),
    ShararaTheme(themeName: "الاحمر",mainColor:Colors.red,brightness:_brightness),
    ShararaTheme(themeName: "الاخضر",mainColor:Colors.green,brightness:_brightness),
    ShararaTheme(themeName: "الارجواني",mainColor:Colors.purple,brightness:_brightness),
    ShararaTheme(themeName: "الزهري",mainColor:Colors.pink,brightness:_brightness),
    ShararaTheme(themeName: "البرتقالي",mainColor:Colors.orange,brightness:_brightness),
    ShararaTheme(themeName: "الجوزي",mainColor:Colors.brown,brightness:_brightness),
    ShararaTheme(themeName: "الازرق الفاتح",mainColor:Colors.lightBlueAccent,brightness:_brightness),
    ShararaTheme(themeName: "الفستقي",mainColor:Colors.teal,brightness:_brightness),
    ShararaTheme(themeName: "البحري الرصاصي",mainColor:Colors.blueGrey,brightness:_brightness),
    ShararaTheme(themeName: "الاصفر",mainColor:Colors.amber,brightness:_brightness),

  ];
  static final ShararaThemeController instance = ShararaThemeController._();
  static Color get primaryColor => instance.mainColor;
  Color get mainColor => (instance.themeNotifier.value??getCachedTheme).mainColor;

  initializeNewThemes({required final List<ShararaTheme> themes}){
    for (final ShararaTheme theme in themes){
      this.themes[theme.themeId] = theme;
    }
  }
  final ValueNotifier<ShararaTheme?> themeNotifier = ValueNotifier(null);

}

extension Worker on ShararaThemeController {
  ShararaTheme get defaultTheme {
    final ShararaTheme? theme = themes['default'];
    if(theme!=null)return theme;
    if(themes.isNotEmpty)return themes.entries.first.value;
    return ShararaTheme(themeName: "الازرق");
  }

  _refreshThemes(){
    final Map<String,ShararaTheme> n = {};
    themes.forEach((key, value) {
      n[key] = ShararaTheme(themeName: value.themeName,themeId:value.themeId,
        mainColor:value.mainColor,
        brightness:ShararaThemeController._brightness,);
    });
    themes.clear();
    themes.addAll(n);
  }
  init()async{
    _changeBrightnessFromCache();
    initializeNewThemes(themes:ShararaThemeController._defaultThemes);
    changeTheme(getCachedTheme);
    _setupNotifiers();
  }

  _changeBrightnessFromCache(){
    final dynamic b = cacheManager.get(key:"brightness");
    Brightness? bb;
    for(final br in Brightness.values){
      if(br.name == b.toString()){
        bb = br;
      }
    }
    if(bb!=null){
      ShararaThemeController._brightness  = bb;
    }
  }

  changeTheme(final ShararaTheme theme,{final Function()? onThemeUpdated}){
    if(themeNotifier.value == theme)return;
    themeNotifier.value = theme;
    if(onThemeUpdated!=null)onThemeUpdated();
  }
  _setupNotifiers(){
    themeNotifier.addListener(_themeListener);
  }
  _themeListener()async{
    final ShararaTheme? theme = themeNotifier.value;
    if(theme==null)return ;
    await _saveTheme(theme);
  }
  ShararaTheme get getCachedTheme  {
    final ShararaTheme? theme = themes[cacheManager.get().toString()];
    if(theme!=null)return theme;
    return defaultTheme;
  }
  Future<void> _saveTheme(final ShararaTheme theme)async{
    await cacheManager.insert(theme.themeId);
  }

   Future<void> _saveBrightness()async{
    await cacheManager.
    insert(ShararaThemeController._brightness.name,key:"brightness");
  }

}










class ShararaTheme {
  ThemeData themeData;
  final String themeName,themeId;
  final Color mainColor;
  final Brightness brightness;
  ShararaTheme({required this.themeName,
    final String? themeId,
    this.mainColor = Colors.blue,
    this.brightness = Brightness.light
  })
  :themeData = ThemeData(
      cupertinoOverrideTheme:CupertinoThemeData(
        primaryContrastingColor:mainColor
      ),
      colorScheme:ColorScheme.fromSeed(seedColor:mainColor,
        brightness:brightness,
      )),
  themeId = themeId ?? mainColor.value.toString();


  @override
  bool operator==(final Object other)=> other is ShararaTheme &&
        other.themeId == themeId
       && other.themeData.colorScheme.brightness
       == themeData.colorScheme.brightness;

  @override
  int get hashCode => super.hashCode + 10;

}