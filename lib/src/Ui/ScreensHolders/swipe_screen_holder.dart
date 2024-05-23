import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Constants/Colors/colors.dart';

class SlidePageTurner extends StatefulWidget {
  final Widget primaryScreen, secondaryScreen;
  final String? goToSecondScreenLabel,goToFirstScreenLabel;
  const SlidePageTurner(
      {super.key, required this.primaryScreen, required this.secondaryScreen,
        this.goToSecondScreenLabel,this.goToFirstScreenLabel});
  @override
  RoyalPageSwitcherState createState() => RoyalPageSwitcherState();
}

class RoyalPageSwitcherState extends State<SlidePageTurner> {
  /// Offsets
  Offset clipOffset = const Offset(0, 0);
  late Offset indicatorOffset ;


  @override
  void initState() {
    indicatorOffset= const Offset(0,400);
    super.initState();
  }
  /// arrow State
  bool forward=false;

  /// Pointer
  double pointer = 0;
  /// indicator Size
  Size? iniSize,mediaSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.primaryScreen,
        ClipPath(

          clipper: RoyalSideLiquidClipper(offset: clipOffset, pointer: pointer),
          child: widget.secondaryScreen,
        ),
        AnimatedPositioned(
            left: indicatorOffset.dx,
            top: indicatorOffset.dy,
            duration: const Duration(milliseconds: 100),
            child: RoyalIndicator(
              onPanUpdated: (Offset position, Size indicatorSize, Size size) =>
                  onPanUpdated(position, indicatorSize, size),
              onPanEnd: (Size indicatorSize, Size size) =>
                  onPanEnded(indicatorSize, size),
              forWard: forward,
              goToFirst:widget.goToFirstScreenLabel,
              goToSecond:widget.goToSecondScreenLabel,
            ))
      ],
    );
  }

  void onPanUpdated(final Offset position, Size indicatorSize, Size size) {

    Offset lastPosition=position;
    /// determine The Size of Indicator Widget
    final double mH=size.height;
    final double mW=size.width;
    final double h=indicatorSize.height;
    final double w=indicatorSize.width;

    final double dy=mH-h;
    final double dx=mW-w;


    /// check if position in The Screen and Fix it
    if(position.dx>=dx){lastPosition=Offset(dx,lastPosition.dy);}
    if(position.dx<=0){lastPosition=Offset(0,lastPosition.dy);}
    if(position.dy>=dy-(dy/20)){lastPosition=Offset(lastPosition.dx,dy/2);}
    if(position.dy<=0){lastPosition=Offset(lastPosition.dx,0);}

    /// updating all Values
    update(lastPosition,position,indicatorSize.width*2.5);
  }

  void update(Offset indicatorPosition,screenPosition,double p){
    setState(() {
      indicatorOffset=indicatorPosition;
      clipOffset=screenPosition;
      pointer=p;
    });
  }


  void onPanEnded(Size indicatorSize, Size size) {
    if(!forward){
      forward=true;
      indicatorOffset=Offset(size.width-indicatorSize.width,indicatorOffset.dy);
      clipOffset=Offset(size.width,size.height);
    }
    else{
      forward=false;
      indicatorOffset= Offset(0,indicatorOffset.dy);
      clipOffset=const Offset(0,0);
    }
    update(indicatorOffset,clipOffset,0);
  }
}

class RoyalIndicator extends StatelessWidget {
  const RoyalIndicator(
      {super.key,
        required this.onPanUpdated,
        required this.onPanEnd,
        required this.forWard,
        this.goToSecond,
        this.goToFirst
      });
  final Function(Offset position, Size indicatorSize, Size size) onPanUpdated;
  final Function(Size indicatorSize, Size size) onPanEnd;
  final String? goToSecond,goToFirst;
  final bool forWard;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (details) =>
          onPanUpdated(details.globalPosition, context.size!, size),
      onPanEnd: (details) => onPanEnd(context.size!, size),
      child:Container(
        padding:const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color:RoyalColors.mainAppColor,
            borderRadius:forWard?const BorderRadius.horizontal(left:Radius.circular(35)):const BorderRadius.horizontal(right:Radius.circular(35))
        ),
        child:goToFirst!=null?forWard?textIndicator(goToFirst!):textIndicator(goToSecond!):Icon(forWard?Icons.arrow_forward:Icons.arrow_back,
          color:Colors.white,),
      ),
    );
  }
  Row textIndicator(final String hint){
    return Row(
      textDirection:!forWard?TextDirection.rtl:TextDirection.ltr,
      children: [
        Icon(forWard?Icons.arrow_forward:Icons.arrow_back,
          color:Colors.white,),
        Text(hint,style:const TextStyle(color:Colors.white),),

      ],
    );
  }
}

class RoyalSideLiquidClipper extends CustomClipper<Path> {
  RoyalSideLiquidClipper({required this.pointer, required this.offset});
  final Offset offset;
  final double pointer;
  final Path path = Path();

  @override
  Path getClip(Size size) {
    // final double x=size.width;
    final double y=size.height;
    /// Start Clipping
    path.moveTo(0,0);
    path.lineTo(offset.dx,0);
    path.quadraticBezierTo(offset.dx+pointer,offset.dy,offset.dx,y);
    path.lineTo(0, y);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
