
import 'package:flutter/material.dart';
class ShararaAnimatedNavigator extends PageRouteBuilder{
  final Widget child;
  final Curve curve ;
  ShararaAnimatedNavigator(this.child,{
    this.curve =   Curves.easeInToLinear,
    super.transitionDuration = const Duration(milliseconds:300)
  }):super(
      transitionsBuilder: ( BuildContext context,Animation<double> animation,Animation<double> second,Widget child){
        animation=CurvedAnimation(parent: animation,curve:curve);
        return ScaleTransition(
            alignment: Alignment.center,
            scale: animation,
            child: child
        );
      },
      pageBuilder:
      ( BuildContext context,Animation<double> animation,Animation<double> second){
        return child;
      }
  );
}