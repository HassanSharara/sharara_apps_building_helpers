

import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Ui/Directionality/Builder/builder.dart';
import 'package:sharara_apps_building_helpers/src/Ui/Theme/Controller/theme_controller.dart';


class ShararaThemeManager extends StatelessWidget {
  const ShararaThemeManager({super.key,required this.builder});
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:ShararaThemeController.instance.themeNotifier,
        builder:(BuildContext context,ShararaTheme? theme,_){
          final t = theme?.themeData??
              ShararaThemeController.instance
                  .defaultTheme.themeData;
          return MaterialApp(
            debugShowCheckedModeBanner:false,
            localizationsDelegates: ShararaThemeController.instance.localizationsDelegates,
            supportedLocales: ShararaThemeController.instance.supportedLocales,
            theme:t,
            home:ShararaDirectionBuilder(builder:builder),
          );
        });
  }
}
