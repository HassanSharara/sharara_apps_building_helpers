import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Controllers/ShararaAppHelperController/sharara_app_helper_controller.dart';

class RoyalColors{

  RoyalColors._();
  static  Color get  mainAppColor => ShararaAppController.instance.themeController.mainColor;
  static  Color get  secondaryColor => ShararaAppController.instance.themeController.secondaryColor;

  static const Color secondFaintColor=Colors.teal;
  static const Color  greyFaintColor = Color.fromRGBO (144, 148, 156,1);
  static const Color grey=Colors.grey;
  static const Color green=Colors.green;
  static const Color pink=Colors.pink;
  static const Color black=Colors.black;
  static const Color white=Colors.white;
  static const Color red=Colors.red;
  static const Color orange=Colors.orange;
  static const Color brown=Colors.brown;
  static const Color teal=Colors.teal;
  static const Color transparent=Colors.transparent;
  static const Color purple=Colors.purple;
  static const Color lightBlue=Colors.lightBlue;
  static const Color indigoAccent=Colors.indigoAccent;
  static const Color blue=Colors.blue;
  static const Color indigo=Colors.indigo;

  static Color getBodyColor(BuildContext context)=>Theme.of(context).iconTheme.color!;
  static Color getCanvasColor(BuildContext context)=>Theme.of(context).canvasColor;
  static const Color  blueRGB =  Color.fromRGBO(29, 39, 231,1);
  static const Color  indigoBlackRGB =  Color.fromRGBO(8, 15, 77,1);
  static const Color  darkBackgroundColor =  Color.fromRGBO(36,37,38,1);
}