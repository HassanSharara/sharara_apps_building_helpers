

import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/ui.dart';

class ShararaAppController {
  const ShararaAppController._();
  static const ShararaAppController instance = ShararaAppController._();
  ShararaThemeController get themeController => ShararaThemeController.instance;
  ShararaDirectionalityController get directionalityController => ShararaDirectionalityController.instance;
  ShararaDialogController get shararaDialogController => ShararaDialogController.instance;
 }

 class ScreenMaskController {

  final GlobalKey<ScaffoldState> scaffoldKey;
  ScreenMaskController ._() :
        scaffoldKey = GlobalKey() ;
   factory ScreenMaskController.buildNew(){
      final ScreenMaskController controller = ScreenMaskController._();
      MaskRootController.controllers.add(controller);
      return controller;
    }
    BuildContext? get context => scaffoldKey.currentContext;
    bool get mounted => scaffoldKey.currentState?.mounted == true;
    bool get canUse => mounted && context!=null ;

    showSnack(final SnackBar snack){
      if(!canUse)return;
      final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context!);
      scaffoldMessenger.showSnackBar(
          snack
      );
    }

    cancelCurrentSnackBar(){
      if(!canUse)return;
      final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context!);
      scaffoldMessenger.removeCurrentSnackBar();
    }
 }

 extension MaskRootController on ScreenMaskController {

   static final List<ScreenMaskController> controllers = [];
   static ScreenMaskController? get lastScreenController => controllers.lastOrNull;
   static void removeLastController (){
     if(! (controllers.length>1))return;
     controllers.removeLast();
   }
   static Future<bool> popLastContext() async {
     if(controllers.isEmpty)return false;
     final ScreenMaskController? controller  = lastScreenController;
     final BuildContext? context = controller?.context;
     if ( controller==null || !controller.mounted || context==null) return false;
     final NavigatorState navigator = Navigator.of(context);
     return await navigator.maybePop();
   }


}