

 import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Ui/Directionality/Controller/directionality.dart';

class ShararaDirectionBuilder extends StatelessWidget {
  const ShararaDirectionBuilder({super.key,required this.builder});
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ShararaDirectionalityController.instance.directionalityNotifier,
        builder:(BuildContext context,final TextDirection? direction,_){
          if( direction == null ) return const SizedBox();
          return Directionality(
                 textDirection:direction, child:
                  Builder(builder:builder )
          );
    }
    );
  }
}
