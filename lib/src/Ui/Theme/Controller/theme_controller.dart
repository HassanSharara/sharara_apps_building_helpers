
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Cache/Systems/DefaultUiCacheManager/default_ui_cache_manager.dart';
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaThemeController {
  final Map<String,ShararaTheme> themes = {} ;
  late final DefaultUiCacheManager cacheManager;
  String? fontFamily;


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

    ShararaTheme(themeName: "الاندييجو",mainColor:Colors.indigo,brightness:_brightness,secondaryColor:RoyalColors.blue),
    ShararaTheme(themeName: "الاحمر",mainColor:Colors.red,brightness:_brightness,
    secondaryColor:const Color.fromRGBO(125, 10, 10,0.9)
    ),
    ShararaTheme(themeName: "الاخضر",mainColor:Colors.green,brightness:_brightness,
     secondaryColor:const Color.fromRGBO(138, 218, 178,1)
    ),
    ShararaTheme(themeName: "الارجواني",mainColor:Colors.purple,brightness:_brightness,
    secondaryColor:RoyalColors.indigoAccent
    ),
    ShararaTheme(themeName: "الزهري والسمائي",mainColor:Colors.pink,brightness:_brightness,
     secondaryColor:RoyalColors.lightBlue
    ),
    ShararaTheme(
        themeName: "الزهري والارجواني",mainColor:Colors.pink,brightness:_brightness,
        secondaryColor:RoyalColors.purple
    ),
    ShararaTheme(themeName: "البرتقالي",mainColor:Colors.orange,brightness:_brightness,
      secondaryColor:const Color.fromRGBO(239, 156, 102,1)
    ),
    ShararaTheme(themeName: "الجوزي",mainColor:Colors.brown,brightness:_brightness,
     secondaryColor:const Color.fromRGBO(236, 177, 118,0.9)
    ),
    ShararaTheme(themeName: "الازرق الفاتح",mainColor:Colors.lightBlueAccent,brightness:_brightness,
        secondaryColor:RoyalColors.indigoAccent
    ),
    ShararaTheme(themeName: "الفستقي",mainColor:Colors.teal,brightness:_brightness,
    secondaryColor:const Color.fromRGBO(255, 158, 170,0.9)
    ),

    ShararaTheme(themeName: "الفستقي والسمائي",mainColor:Colors.teal,brightness:_brightness,
    secondaryColor:RoyalColors.lightBlue
    ),
    ShararaTheme(themeName: "البحري الرصاصي",mainColor:Colors.blueGrey,brightness:_brightness,
      secondaryColor:RoyalColors.blue
    ),
    ShararaTheme(themeName: "الاصفر",mainColor:Colors.amber,brightness:_brightness,
      secondaryColor:const Color.fromRGBO(255, 221, 149,0.9)
    ),

  ];

   setNewFont(final String f){
     fontFamily = f;
     final List<ShararaTheme> themes  = [];
     this.themes.forEach( (key,value){
       value.fontFamily = fontFamily;
       themes.add(ShararaTheme.from(value));
     });
     setupNewThemes(themes: themes);
     final theme = themeNotifier.value ;
     if ( theme == null )return;
     theme.fontFamily = f;
     themeNotifier.value = ShararaTheme.from(theme)
     ;
   }
  static final ShararaThemeController instance = ShararaThemeController._();
  static Color get primaryColor => instance.mainColor;
  Color get mainColor => (instance.themeNotifier.value??getCachedTheme).mainColor;
  Color get secondaryColor => (instance.themeNotifier.value??getCachedTheme).secondaryColor;

  initializeNewThemes({required final List<ShararaTheme> themes}){
    for ( ShararaTheme theme in themes){
      theme.fontFamily = fontFamily;
      this.themes[theme.themeId] = ShararaTheme.from(theme);
    }
  }
  setupNewThemes({required final List<ShararaTheme> themes}){
    this.themes.clear();
    initializeNewThemes(themes: themes);
  }
  final ValueNotifier<ShararaTheme?> themeNotifier = ValueNotifier(null);

}

extension Worker on ShararaThemeController {
  ShararaTheme get defaultTheme {
    final ShararaTheme? theme = themes['default_theme']??themes['default'];
    if(theme!=null)return theme;
    if(themes.isNotEmpty)return themes.entries.first.value;
    return ShararaTheme(themeName: "الازرق");
  }


  setNewDefaultTheme(final ShararaTheme theme){
    initializeNewThemes(themes: [
      ShararaTheme(
        themeId: "default_theme",
        themeName:theme.themeName,
        mainColor:theme.mainColor,
        secondaryColor:theme.secondaryColor,
        brightness:theme.brightness
      )
    ]);
    final t = themes[cacheManager.get().toString()];
    if(t!=null && t.themeId!= "default_theme" && t.themeId != theme.themeId)return;
    changeToDefaultTheme();
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

  changeToDefaultTheme(){
    changeTheme(defaultTheme);
  }

  changeTheme(ShararaTheme theme,{final Function()? onThemeUpdated}){
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
    if( theme.themeId == "default")  {
      final ShararaTheme? ct = themes[cacheManager.get().toString()];
      if(ct==null)return;
    }
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
  final Color mainColor,secondaryColor;
  final Brightness brightness;
  String? fontFamily;
  int changes = 0;
  ShararaTheme({required this.themeName,
    final String? themeId,
    this.mainColor = Colors.blue,
    this.secondaryColor = Colors.indigo,
    this.brightness = Brightness.light,
    this.fontFamily
  })
  :themeData = ThemeData(
      fontFamily:fontFamily,
      cupertinoOverrideTheme:CupertinoThemeData(
        primaryContrastingColor:mainColor
      ),
      colorScheme:ColorScheme.fromSeed(seedColor:mainColor,
        brightness:brightness,
      )),
  themeId = themeId ?? mainColor.value.toString();



  factory ShararaTheme.from(final ShararaTheme theme){
    final ShararaTheme ne = ShararaTheme(themeName: theme.themeName,
      themeId:theme.themeId,
      mainColor:theme.mainColor,
      secondaryColor:theme.secondaryColor,
      brightness:theme.brightness,
      fontFamily:theme.fontFamily,
    );
    ne.changes = theme.changes + 1 ;
    return ne;
  }
  @override
  bool operator==(final Object other){
    return other is ShararaTheme &&
        other.themeId == themeId
        && other.themeData.colorScheme.brightness
            == themeData.colorScheme.brightness
        && other.fontFamily == fontFamily
    && other.changes == changes;
  }
  @override
  int get hashCode => super.hashCode + 10;

}