

import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Ui/ShararaAppHelper/context_and_main_scaffold_initializer.dart';
import 'package:sharara_apps_building_helpers/ui.dart';

class ShararaAppHelper extends StatelessWidget {
  const ShararaAppHelper({super.key,
    required this.builder,
  });
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) =>  Launcher(builder: builder,);

}


class Launcher extends StatefulWidget {
  const Launcher({super.key,required this.builder,
  });
  final Widget Function(BuildContext) builder;

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {

  GlobalKey<ScaffoldState>? _key;

  GlobalKey<ScaffoldState> get key {
    _key??=firstController.scaffoldKey;
    return _key!;
  }

  @override
  Widget build(BuildContext context) {
    return ShararaThemeManager(
        builder:(BuildContext context){
          final child  = ContextAndMainScaffoldInitializer(
            rootKey:key,
            builder:widget.builder,
          );

          if(OuterScreenMaskController.forUsing){
            return ContextAndMainScaffoldInitializer(
              rootKey:key,
              builder:(_)=>OuterScreenMaskUi(builder: widget.builder),
            );
          }
          return child;
        }
    );
  }

  ScreenMaskController get firstController {
    if(MaskRootController.controllers.isEmpty){
      return ScreenMaskController.buildNew();
    }
    return MaskRootController.controllers.first;
  }
}


