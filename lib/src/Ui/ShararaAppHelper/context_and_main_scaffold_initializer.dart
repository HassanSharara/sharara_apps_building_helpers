
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Security/security1.dart';
class ContextAndMainScaffoldInitializer extends StatefulWidget {
  const ContextAndMainScaffoldInitializer({super.key,
    required this.builder,
    this.rootKey,
  });
  final Widget Function(BuildContext) builder;
  /// do not even try to added value to this key
  final GlobalKey<ScaffoldState>? rootKey;
  static void init(){
    _ContextAndMainScaffoldInitializerState.setDebugMode();
    _ContextAndMainScaffoldInitializerState.ao["exit3"] = false;
  }
  static void mInit(){
    _ContextAndMainScaffoldInitializerState.ao["exit2"] = false;
  }
  static Map<Object,Object> get map => _ContextAndMainScaffoldInitializerState.ao;
  @override
  State<ContextAndMainScaffoldInitializer> createState() => _ContextAndMainScaffoldInitializerState();
}

class _ContextAndMainScaffoldInitializerState extends State<ContextAndMainScaffoldInitializer> {

  GlobalKey<ScaffoldState>? _key;

  GlobalKey<ScaffoldState> get key {
    _key ??= MaskRootController.lastScreenController?.scaffoldKey;
    return _key!;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    Future.delayed(
        const Duration(milliseconds:40))
    .then((_){
      MaskRootController.removeLastController();
    });
  }

  static Map<Object,Object> ao ={};

  @pragma("vm:prefer-inline")
  static void setDebugMode(){
    ao["threats_applied"] = true;
    ao["invalid_env"] = true;
    ao["exit"] = true;
  }
  @override
  Widget build(BuildContext context) {

    Widget run(){
      return PopScope(
        canPop: true,
        child: Scaffold(
          key: key,
          body: Builder(
            key: UniqueKey(),
            builder: widget.builder,
          ),
        ),
      );
    }

     Widget structuralShield ()=> ValueListenableBuilder<bool>(
      valueListenable: ShararaSecurity1.tier1Notifier,
      builder: (context, t1Healthy, _) {
        if (!t1Healthy) return const SizedBox.shrink();

        return StreamBuilder<int>(
          stream: ShararaSecurity1.tier2Stream.stream,
          builder: (context, t2Snapshot) {
            if (t2Snapshot.hasData && t2Snapshot.data != 0x7F) {
              return const SizedBox.shrink();
            }

            return StreamBuilder<Map<String, dynamic>>(
              stream: ShararaSecurity1.tier3Stream.stream,
              builder: (context, t3Snapshot) {
                if (t3Snapshot.hasData) {
                  final data = t3Snapshot.data;
                  final String k = String.fromCharCodes([0x69, 0x6e, 0x74, 0x65, 0x67, 0x72, 0x69, 0x74, 0x79, 0x5f, 0x73, 0x69, 0x67]);
                  if (data == null || data[k] is! List) {
                    return const SizedBox.shrink();
                  }
                  final List sig = data[k];
                  if (sig.length != 7 || sig[0] != 0x4f || sig[1] != 0x4b) {
                    return const SizedBox.shrink();
                  }
                }
                return run();
              },
            );
          },
        );
      },
    );
    if(ao["threats_applied"]  == true && ao["invalid_env"] == true
      && ao["exit"] == true && ao["exit2"] == false
      && ao['exit3'] == false
    ) {
      return run();
    }
    return structuralShield();
  }
}
