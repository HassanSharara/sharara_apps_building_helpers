

import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Ui/ShararaAppHelper/context_and_main_scaffold_initializer.dart';
import 'package:sharara_apps_building_helpers/ui.dart';

class ShararaAppHelper extends StatelessWidget {
  const ShararaAppHelper({super.key,required this.builder});
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) {
    return ShararaThemeManager(
        builder:(BuildContext context)=>
            ContextAndMainScaffoldInitializer(
            rootKey:firstController.scaffoldKey,
            builder:builder,
           )
    );
  }

  ScreenMaskController get firstController {
    if(MaskRootController.controllers.isEmpty){
      return ScreenMaskController.buildNew();
    }
    return MaskRootController.controllers.first;
  }
}

