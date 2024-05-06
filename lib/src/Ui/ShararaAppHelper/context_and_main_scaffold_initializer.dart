
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
class ContextAndMainScaffoldInitializer extends StatelessWidget {
  const ContextAndMainScaffoldInitializer({super.key,
    required this.builder,
    this.rootKey,
  });
  final Widget Function(BuildContext) builder;
  /// do not even try to added value to this key
  final GlobalKey<ScaffoldState>? rootKey;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked:(value){
        if ( value ){
          MaskRootController.removeLastController();
        }
      },
      child:Scaffold(
        key:rootKey
            ?? MaskRootController.lastScreenController?.scaffoldKey,
        body:Builder(key:UniqueKey(),builder:builder,),
      ),
    );
  }
}
