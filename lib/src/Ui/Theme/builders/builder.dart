

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
          return MaterialApp(
            debugShowCheckedModeBanner:false,
            theme:theme?.themeData??
            ShararaThemeController.instance
            .defaultTheme.themeData,
            home:ShararaDirectionBuilder(builder:builder),
          );
        });
  }
}
