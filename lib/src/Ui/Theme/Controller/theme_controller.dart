
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
    // =============================================================
    // 1. العائلة الملكية والأساسيات (Royal & Classics) - 12 ثيم
    // =============================================================
    ShararaTheme(themeName: "الأزرق الملكي", themeId: "default", brightness: _brightness,mainColor:RoyalColors.lightBlue,secondaryColor:RoyalColors.indigoAccent),
    ShararaTheme(themeName: "الإنديغو", mainColor: Colors.indigo, brightness: _brightness, secondaryColor: const Color(0xFF303F9F)),
    ShararaTheme(themeName: "الأحمر الفاخر", mainColor: const Color(0xFFB71C1C), brightness: _brightness, secondaryColor: const Color(0xFFD32F2F)),
    ShararaTheme(themeName: "الأخضر الزمردي", mainColor: const Color(0xFF1B5E20), brightness: _brightness, secondaryColor: const Color(0xFF388E3C)),
    ShararaTheme(themeName: "الأرجواني", mainColor: Colors.purple, brightness: _brightness, secondaryColor: const Color(0xFF7B1FA2)),
    ShararaTheme(themeName: "البرتقالي العميق", mainColor: Colors.orange, brightness: _brightness, secondaryColor: const Color(0xFFF57C00)),
    ShararaTheme(themeName: "الأصفر الكهرماني", mainColor: Colors.amber, brightness: _brightness, secondaryColor: const Color(0xFFFFA000)),
    ShararaTheme(themeName: "الأزرق السماوي", mainColor: Colors.blue, brightness: _brightness, secondaryColor: const Color(0xFF1976D2)),
    ShararaTheme(themeName: "البني الخشبي", mainColor: Colors.brown, brightness: _brightness, secondaryColor: const Color(0xFF5D4037)),
    ShararaTheme(themeName: "الرمادي الحديدي", mainColor: Colors.blueGrey, brightness: _brightness, secondaryColor: const Color(0xFF455A64)),
    ShararaTheme(themeName: "الأسود القاتم", mainColor: const Color(0xFF212121), brightness: _brightness, secondaryColor: const Color(0xFF424242)),
    ShararaTheme(themeName: "الأحمر الوردي", mainColor: Colors.pink, brightness: _brightness, secondaryColor: const Color(0xFFC2185B)),

    // =============================================================
    // 2. مجموعة الـ Deep & Dark (فخامة عالية) - 12 ثيم
    // =============================================================
    ShararaTheme(themeName: "أزرق منتصف الليل", mainColor: const Color(0xFF1A237E), brightness: _brightness, secondaryColor: const Color(0xFF3F51B5)),
    ShararaTheme(themeName: "أخضر الغابة", mainColor: const Color(0xFF004D40), brightness: _brightness, secondaryColor: const Color(0xFF00796B)),
    ShararaTheme(themeName: "عنابي ملكي", mainColor: const Color(0xFF880E4F), brightness: _brightness, secondaryColor: const Color(0xFFAD1457)),
    ShararaTheme(themeName: "بنفسجي داكن", mainColor: const Color(0xFF4A148C), brightness: _brightness, secondaryColor: const Color(0xFF7B1FA2)),
    ShararaTheme(themeName: "بترولي غامق", mainColor: const Color(0xFF006064), brightness: _brightness, secondaryColor: const Color(0xFF00838F)),
    ShararaTheme(themeName: "أحمر بركاني", mainColor: const Color(0xFFBF360C), brightness: _brightness, secondaryColor: const Color(0xFFE64A19)),
    ShararaTheme(themeName: "زيتوني مكثف", mainColor: const Color(0xFF33691E), brightness: _brightness, secondaryColor: const Color(0xFF558B2F)),
    ShararaTheme(themeName: "بني الشوكولاتة", mainColor: const Color(0xFF3E2723), brightness: _brightness, secondaryColor: const Color(0xFF5D4037)),
    ShararaTheme(themeName: "كحلي رصين", mainColor: const Color(0xFF0D47A1), brightness: _brightness, secondaryColor: const Color(0xFF1565C0)),
    ShararaTheme(themeName: "رمادي الفضاء", mainColor: const Color(0xFF263238), brightness: _brightness, secondaryColor: const Color(0xFF37474F)),
    ShararaTheme(themeName: "أرجواني ليلي", mainColor: const Color(0xFF311B92), brightness: _brightness, secondaryColor: const Color(0xFF512DA8)),
    ShararaTheme(themeName: "أخضر محيطي", mainColor: const Color(0xFF004D40), brightness: _brightness, secondaryColor: const Color(0xFF00695C)),

    // =============================================================
    // 3. مجموعة الـ Pastel المشبعة (ألوان ناعمة وواضحة) - 15 ثيم
    // =============================================================
    ShararaTheme(themeName: "لافندر مودرن", mainColor: const Color(0xFF9575CD), brightness: _brightness, secondaryColor: const Color(0xFFD1C4E9)),
    ShararaTheme(themeName: "فيروزي هادئ", mainColor: const Color(0xFF4DB6AC), brightness: _brightness, secondaryColor: const Color(0xFFB2DFDB)),
    ShararaTheme(themeName: "مرجاني مشرق", mainColor: const Color(0xFFFF8A65), brightness: _brightness, secondaryColor: const Color(0xFFFFCCBC)),
    ShararaTheme(themeName: "سماوي ناعم", mainColor: const Color(0xFF64B5F6), brightness: _brightness, secondaryColor: const Color(0xFFBBDEFB)),
    ShararaTheme(themeName: "أخضر تفاحي", mainColor: const Color(0xFF81C784), brightness: _brightness, secondaryColor: const Color(0xFFC8E6C9)),
    ShararaTheme(themeName: "وردي مغبر", mainColor: const Color(0xFFF06292), brightness: _brightness, secondaryColor: const Color(0xFFF8BBD0)),
    ShararaTheme(themeName: "أصفر خردلي", mainColor: const Color(0xFFFFD54F), brightness: _brightness, secondaryColor: const Color(0xFFFFF9C4)),
    ShararaTheme(themeName: "بيج رملي دافئ", mainColor: const Color(0xFFA1887F), brightness: _brightness, secondaryColor: const Color(0xFFD7CCC8)),
    ShararaTheme(themeName: "أرجواني فاتح", mainColor: const Color(0xFFBA68C8), brightness: _brightness, secondaryColor: const Color(0xFFE1BEE7)),
    ShararaTheme(themeName: "أزرق ثلجي", mainColor: const Color(0xFF4FC3F7), brightness: _brightness, secondaryColor: const Color(0xFFB3E5FC)),
    ShararaTheme(themeName: "برتقالي باهت", mainColor: const Color(0xFFFFB74D), brightness: _brightness, secondaryColor: const Color(0xFFFFE0B2)),
    ShararaTheme(themeName: "نعناعي", mainColor: const Color(0xFF80CBC4), brightness: _brightness, secondaryColor: const Color(0xFFE0F2F1)),
    ShararaTheme(themeName: "ذهبي مطفي", mainColor: const Color(0xFFD4AF37), brightness: _brightness, secondaryColor: const Color(0xFFF9F1C6)),
    ShararaTheme(themeName: "رمادي لؤلؤي", mainColor: const Color(0xFF90A4AE), brightness: _brightness, secondaryColor: const Color(0xFFCFD8DC)),
    ShararaTheme(themeName: "سلمون", mainColor: const Color(0xFFFFA07A), brightness: _brightness, secondaryColor: const Color(0xFFFFE4E1)),

    // =============================================================
    // 4. مجموعة الـ Neon & Vibrant (حيوية عالية) - 15 ثيم
    // =============================================================
    ShararaTheme(themeName: "سايبر بانك", mainColor: const Color(0xFFE040FB), brightness: _brightness, secondaryColor: const Color(0xFF00E5FF)),
    ShararaTheme(themeName: "أخضر نيون", mainColor: const Color(0xFF76FF03), brightness: _brightness, secondaryColor: const Color(0xFF1B5E20)),
    ShararaTheme(themeName: "كهربائي", mainColor: const Color(0xFF2979FF), brightness: _brightness, secondaryColor: const Color(0xFF0D47A1)),
    ShararaTheme(themeName: "برتقالي ناري", mainColor: const Color(0xFFFF3D00), brightness: _brightness, secondaryColor: const Color(0xFFDD2C00)),
    ShararaTheme(themeName: "أصفر مشع", mainColor: const Color(0xFFFFEA00), brightness: _brightness, secondaryColor: const Color(0xFFF57F17)),
    ShararaTheme(themeName: "فيروزي مشع", mainColor: const Color(0xFF00E5FF), brightness: _brightness, secondaryColor: const Color(0xFF006064)),
    ShararaTheme(themeName: "أحمر صارخ", mainColor: const Color(0xFFFF1744), brightness: _brightness, secondaryColor: const Color(0xFF880E4F)),
    ShararaTheme(themeName: "فوشيا", mainColor: const Color(0xFFFF00FF), brightness: _brightness, secondaryColor: const Color(0xFF7B1FA2)),
    ShararaTheme(themeName: "بنفسجي مشع", mainColor: const Color(0xFF6200EA), brightness: _brightness, secondaryColor: const Color(0xFFD1C4E9)),
    ShararaTheme(themeName: "أخضر ليموني نيون", mainColor: const Color(0xFFC6FF00), brightness: _brightness, secondaryColor: const Color(0xFF33691E)),
    ShararaTheme(themeName: "أزرق سيان", mainColor: const Color(0xFF00B0FF), brightness: _brightness, secondaryColor: const Color(0xFF01579B)),
    ShararaTheme(themeName: "برتقالي حيوي", mainColor: const Color(0xFFFF9100), brightness: _brightness, secondaryColor: const Color(0xFFFF3D00)),
    ShararaTheme(themeName: "توت بري نيون", mainColor: const Color(0xFFF50057), brightness: _brightness, secondaryColor: const Color(0xFF880E4F)),
    ShararaTheme(themeName: "بنفسجي كهربائي", mainColor: const Color(0xFFD500F9), brightness: _brightness, secondaryColor: const Color(0xFF4A148C)),
    ShararaTheme(themeName: "أزرق تيركواز", mainColor: const Color(0xFF1DE9B6), brightness: _brightness, secondaryColor: const Color(0xFF004D40)),

    // =============================================================
    // 5. مجموعة الطبيعة والأرض (Earth & Nature) - 15 ثيم
    // =============================================================
    ShararaTheme(themeName: "خريف دافئ", mainColor: const Color(0xFFD84315), brightness: _brightness, secondaryColor: const Color(0xFFFFB300)),
    ShararaTheme(themeName: "محيط عميق", mainColor: const Color(0xFF0277BD), brightness: _brightness, secondaryColor: const Color(0xFF80DEEA)),
    ShararaTheme(themeName: "جبال ضبابية", mainColor: const Color(0xFF546E7A), brightness: _brightness, secondaryColor: const Color(0xFFB0BEC5)),
    ShararaTheme(themeName: "رمال الصحراء", mainColor: const Color(0xFF8D6E63), brightness: _brightness, secondaryColor: const Color(0xFFFFE082)),
    ShararaTheme(themeName: "زيتوني بري", mainColor: const Color(0xFF558B2F), brightness: _brightness, secondaryColor: const Color(0xFFDCEDC8)),
    ShararaTheme(themeName: "شروق الشمس", mainColor: const Color(0xFFFF6F00), brightness: _brightness, secondaryColor: const Color(0xFFFFD54F)),
    ShararaTheme(themeName: "تراب مبلل", mainColor: const Color(0xFF4E342E), brightness: _brightness, secondaryColor: const Color(0xFFA1887F)),
    ShararaTheme(themeName: "طحالب بحرية", mainColor: const Color(0xFF2E7D32), brightness: _brightness, secondaryColor: const Color(0xFFC0CA33)),
    ShararaTheme(themeName: "سماء صافية", mainColor: const Color(0xFF03A9F4), brightness: _brightness, secondaryColor: const Color(0xFFE1F5FE)),
    ShararaTheme(themeName: "حجر الجرانيت", mainColor: const Color(0xFF37474F), brightness: _brightness, secondaryColor: const Color(0xFF90A4AE)),
    ShararaTheme(themeName: "كستناء", mainColor: const Color(0xFF795548), brightness: _brightness, secondaryColor: const Color(0xFFD7CCC8)),
    ShararaTheme(themeName: "غابة صنوبر", mainColor: const Color(0xFF1B5E20), brightness: _brightness, secondaryColor: const Color(0xFF81C784)),
    ShararaTheme(themeName: "مرجان بحري", mainColor: const Color(0xFFF06292), brightness: _brightness, secondaryColor: const Color(0xFFFFAB91)),
    ShararaTheme(themeName: "صخر بركاني", mainColor: const Color(0xFF212121), brightness: _brightness, secondaryColor: const Color(0xFFBDBDBD)),
    ShararaTheme(themeName: "واحة هادئة", mainColor: const Color(0xFF009688), brightness: _brightness, secondaryColor: const Color(0xFF80CBC4)),

    // =============================================================
    // 6. مجموعة الألوان المدمجة (Modern Hybrid) - 15 ثيم
    // =============================================================
    ShararaTheme(themeName: "نبيذي مع ذهبي", mainColor: const Color(0xFF641E16), brightness: _brightness, secondaryColor: const Color(0xFFD4AC0D)),
    ShararaTheme(themeName: "كحلي مع مرجان", mainColor: const Color(0xFF1B2631), brightness: _brightness, secondaryColor: const Color(0xFFE74C3C)),
    ShararaTheme(themeName: "بنفسجي مع فيروزي", mainColor: const Color(0xFF512DA8), brightness: _brightness, secondaryColor: const Color(0xFF1ABC9C)),
    ShararaTheme(themeName: "رمادي مع ليموني", mainColor: const Color(0xFF424949), brightness: _brightness, secondaryColor: const Color(0xFF2ECC71)),
    ShararaTheme(themeName: "أزرق مع برتقالي", mainColor: const Color(0xFF2E86C1), brightness: _brightness, secondaryColor: const Color(0xFFE67E22)),
    ShararaTheme(themeName: "نحاسي مودرن", mainColor: const Color(0xFFBA4A00), brightness: _brightness, secondaryColor: const Color(0xFFEDBB99)),
    ShararaTheme(themeName: "فيروزي مع أرجواني", mainColor: const Color(0xFF138D75), brightness: _brightness, secondaryColor: const Color(0xFF8E44AD)),
    ShararaTheme(themeName: "أزرق بترولي مطفي", mainColor: const Color(0xFF21618C), brightness: _brightness, secondaryColor: const Color(0xFFAED6F1)),
    ShararaTheme(themeName: "نبيذي غامق جداً", mainColor: const Color(0xFF51084E), brightness: _brightness, secondaryColor: const Color(0xFFE91E63)),
    ShararaTheme(themeName: "أخضر مينت قوي", mainColor: const Color(0xFF0E6251), brightness: _brightness, secondaryColor: const Color(0xFF48C9B0)),
    ShararaTheme(themeName: "أرجواني ملكي قديم", mainColor: const Color(0xFF4A235A), brightness: _brightness, secondaryColor: const Color(0xFFAF7AC5)),
    ShararaTheme(themeName: "أصفر مع رمادي", mainColor: const Color(0xFFD4AC0D), brightness: _brightness, secondaryColor: const Color(0xFF2C3E50)),
    ShararaTheme(themeName: "أزرق فولاذي هادئ", mainColor: const Color(0xFF2874A6), brightness: _brightness, secondaryColor: const Color(0xFFD4E6F1)),
    ShararaTheme(themeName: "أحمر طوبي", mainColor: const Color(0xFF7B241C), brightness: _brightness, secondaryColor: const Color(0xFFE6B0AA)),
    ShararaTheme(themeName: "أخضر ليموني هادئ", mainColor: const Color(0xFF1D8348), brightness: _brightness, secondaryColor: const Color(0xFFABEBC6)),
  ];


   setBrightness(Brightness br){
     if (gotCachedBrightness)return;
     _brightness = br;
   }
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
     theme.brightness = ShararaThemeController._brightness;
     themeNotifier.value = ShararaTheme.from(theme);
   }
  bool gotCachedBrightness = false;

  static final ShararaThemeController instance = ShararaThemeController._();
  static Color get primaryColor => instance.mainColor;
  Color get mainColor => (instance.themeNotifier.value??getCachedTheme).mainColor;
  Color get secondaryColor => (instance.themeNotifier.value??getCachedTheme).secondaryColor;

  initializeNewThemes({required final List<ShararaTheme> themes}){
    themes.sort((a,b)=>a.themeId.contains("default")?0:1);
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
  List<LocalizationsDelegate> localizationsDelegates = [];
  List<Locale> supportedLocales = [];

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
        brightness:ShararaThemeController._brightness
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
        gotCachedBrightness = true;
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
    theme.brightness = ShararaThemeController._brightness;
    themeNotifier.value = theme;
    if(onThemeUpdated!=null)onThemeUpdated();
  }
  _setupNotifiers(){
    themeNotifier.addListener(_themeListener);
  }
  _themeListener()async{
    final ShararaTheme? theme = themeNotifier.value;
    if(theme==null)return ;
    theme.brightness = ShararaThemeController._brightness;
    if( theme.themeId == "default")  {
      final ShararaTheme? ct = themes[cacheManager.get().toString()];
      if(ct==null)return;
    }
    await _saveTheme(theme);
  }
  ShararaTheme get getCachedTheme  {
    final res = (){final ShararaTheme? theme = themes[cacheManager.get().toString()];
    if(theme!=null)return theme;
    return defaultTheme;}();
    return res..brightness = ShararaThemeController._brightness;
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
  Brightness brightness;
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
  themeId = themeId ?? mainColor.toARGB32().toString();



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