
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
class ContextAndMainScaffoldInitializer extends StatefulWidget {
  const ContextAndMainScaffoldInitializer({super.key,
    required this.builder,
    this.rootKey,
  });
  final Widget Function(BuildContext) builder;
  /// do not even try to added value to this key
  final GlobalKey<ScaffoldState>? rootKey;

  @override
  State<ContextAndMainScaffoldInitializer> createState() => _ContextAndMainScaffoldInitializerState();
}

class _ContextAndMainScaffoldInitializerState extends State<ContextAndMainScaffoldInitializer> {
  @override
  void dispose() {
    super.dispose();
    Future.delayed(const Duration(milliseconds:40))
    .then((_){
      MaskRootController.removeLastController();
    });
  }
  @override
  Widget build(BuildContext context) {

    return PopScope(
      child:Scaffold(
        key:widget.rootKey
            ?? MaskRootController.lastScreenController?.scaffoldKey,
        body:Builder(key:UniqueKey(),builder:widget.builder,),
      ),
    );
  }
}
