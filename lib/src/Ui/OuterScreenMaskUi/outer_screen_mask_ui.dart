import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Ui/exporter.dart';


class OuterScreenMaskUi extends StatelessWidget {
  const OuterScreenMaskUi({super.key,
    required this.builder
  });

  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        builder(context),
        BubbleWidget(size: size,)
      ],
    );
  }
}

class BubbleWidget extends StatefulWidget {
  const BubbleWidget({super.key,
    required this.size
  });

  final Size size;

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {

  static const double apHeight = 80;

  bool get _isRtl =>
      ShararaDirectionalityController
          .direction == TextDirection.rtl;
  Size widgetSize = const Size(40, 40);

  Offset get defaultPosition {
    const double height = apHeight;
    if (_isRtl) {
      return Offset(apX, height);
    }
    return const Offset(0, height);
  }

  late Offset offset;

  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    offset = defaultPosition;
    oldPosition = defaultPosition;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box = _key.currentContext
          ?.findRenderObject() as RenderBox?;
      if (box == null) return;
      setState(() {
        widgetSize = box.size;
        offset = defaultPosition;
      });
    });
  }

  _toPosition(final Offset pos) {
    if (isOpen) return;
    setState(() {
      offset = Offset(pos.dx, pos.dy);
    });
  }

  double get apX => widget.size.width - widgetSize.width;

  double get apY {
    double y = offset.dy;
    if (y < defaultPosition.dy) {
      y = defaultPosition.dy;
    } else if (y > widget.size.height - defaultPosition.dy) {
      y = widget.size.height - defaultPosition.dy;
    }
    return y;
  }

  _onEnd(DragEndDetails details) {
    if (isOpen) return;
    final d = duration;
    setState(() {
      duration = d * 2;
      offset = Offset(
          offset.dx + (widgetSize.width / 2) > (widget.size.width / 2) ? (

              apX
                  - (
                  _isRtl ? 0 :
                  4
              )
          ) : (
              _isRtl ? 4 :
              0
          ), apY);
    });

    Future.delayed(duration).then((_) => duration = d);
  }

  bool isOpen = false;


  late Offset oldPosition;

  _onClick() async {
    final d = duration;

    if (isOpen) {
      setState(() {
        isOpen = false;
      });
      await Future.delayed(duration);
      setState(() {
        duration *= 4;
        offset = oldPosition;
      });
      Future.delayed(duration).then((_) => duration = d);

      return;
    }
    oldPosition = offset;
    setState(() {
      duration *= 4;
      offset = defaultPosition;
    });
    await Future.delayed(duration);
    setState(() {
      isOpen = true;
    });
    Future.delayed(duration).then((_) => duration = d);
  }

  Duration duration = const Duration(milliseconds: 60);

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onHorizontalDragUpdate: (details) {
        _toPosition(details.globalPosition);
      },
      onVerticalDragUpdate: (details) {
        _toPosition(details.globalPosition);
      },
      onTap: _onClick,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragEnd: _onEnd,
      child: ValueListenableBuilder(
          valueListenable: OuterScreenMaskController.instance.tasksProgress,
          builder: (context, t, _) {
            final bubble = AnimatedOpacity(
              duration: const Duration(milliseconds: 300),

              // opacity:1,
              opacity: !isOpen && t.isEmpty ? 0 : 1,
              child: Badge(
                label: Text(t.length.toString()),
                child: AnimatedContainer(
                  key: _key,
                  duration: duration,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        RoyalColors.secondaryColor,
                        RoyalColors.mainAppColor,
                      ])
                  ),
                  child: const Icon(
                    Icons.computer_sharp,
                    size: 25,
                    color: RoyalColors.white,
                  ),
                ),
              ),
            );
            if (isOpen) {
              return SizedBox(
                height: widget.size.height,
                width: widget.size.width,
                child: Column(
                  children: [
                    const SizedBox(height: apHeight,),
                    Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          bubble,
                          Expanded(
                            child: RoyalShadowContainer(
                              shadowColor: RoyalColors.secondaryColor
                                  .withValues(alpha: 0.4),
                              margin: EdgeInsets.symmetric(
                                  vertical: widgetSize.height / 2
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    if(t.isEmpty)
                                      const Icon(Icons.access_time),
                                    for(final TaskProgressHolder item in t)
                                      ValueListenableBuilder(
                                          valueListenable: item.progress!,
                                          builder: (BuildContext context,
                                              final double per, _) {
                                            if(item.results != null)
                                              {
                                                return RoyalShadowContainer(
                                                  margin:const EdgeInsets.symmetric(vertical:5),
                                                  shadowColor:RoyalColors.mainAppColor.withValues(alpha: 0.5),
                                                  child:item.results!.child??
                                                      Column(
                                                        mainAxisAlignment:MainAxisAlignment.start,
                                                        crossAxisAlignment:CrossAxisAlignment.start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap:()=>OuterScreenMaskController.instance.remove(item),
                                                            child: const Row(
                                                              children: [
                                                                SizedBox(width:5,),
                                                                Icon(Icons.cancel,color:RoyalColors.pink,size:12,),
                                                              ],
                                                            ),
                                                          ),

                                                          Row(
                                                            mainAxisAlignment:MainAxisAlignment.center,
                                                            crossAxisAlignment:CrossAxisAlignment.center,
                                                            children: [
                                                              if(item.results?.success == true)
                                                                const Icon(
                                                                  Icons.check_circle,color:RoyalColors.green,
                                                                  size:20,
                                                                )
                                                              else
                                                                const Icon(
                                                                  Icons.error,color:RoyalColors.red,
                                                                  size:20,
                                                                )
                                                            ],
                                                          ),
                                                          const SizedBox(height:8,),
                                                          Row(
                                                            mainAxisAlignment:MainAxisAlignment.center,
                                                            crossAxisAlignment:CrossAxisAlignment.center,
                                                            children: [
                                                              Text(item.results!.label!,
                                                                style:const TextStyle(
                                                                    fontSize:12,
                                                                    fontWeight:FontWeight.bold
                                                                ),)
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:MainAxisAlignment.center,
                                                            crossAxisAlignment:CrossAxisAlignment.center,
                                                            children: [
                                                              Text("( ${per.toStringAsFixed(0)} )",
                                                                style:const TextStyle(
                                                                    fontSize:10,
                                                                    color:RoyalColors.greyFaintColor
                                                                ),)

                                                            ],
                                                          )
                                                        ],
                                                      )
                                                  ,
                                                );
                                              }
                                            else
                                             {
                                               return  RoyalShadowContainer(
                                                   margin:const EdgeInsets.symmetric(vertical:5),
                                                   shadowColor:RoyalColors.mainAppColor.withValues(alpha: 0.5),
                                                   child:Column(
                                                     mainAxisAlignment:MainAxisAlignment.center,
                                                     crossAxisAlignment:CrossAxisAlignment.center,
                                                     children: [
                                                     Text(item.title,textAlign:TextAlign.center,style:const TextStyle(
                                                       fontSize:12,
                                                       fontWeight:FontWeight.bold),),
                                                   if(item.progress != null )
                                               Column(
                                                 children: [
                                                   Text("${(per * 100).toStringAsFixed(1)} %",style: TextStyle(
                                                       color:RoyalColors.secondaryColor,
                                                       fontSize:10
                                                   ),),
                                                   Row(
                                                     children: [
                                                       Expanded(
                                                           child: LinearProgressIndicator(
                                                             value:per,
                                                             backgroundColor:RoyalColors.greyFaintColor.withValues(alpha:0.3),
                                                             color:RoyalColors.mainAppColor,
                                                           )
                                                       )
                                                     ],
                                                   ),
                                                 ],
                                               )]));
                                             }

                                          }
                                      )

                                  ],
                                ),
                              )
                            ),
                          ),
                  ],
                ),
              )],
            ),
            );
            }


            return bubble;
            }
      ),
    );
    if (isOpen) return child;
    return AnimatedPositioned(
      duration: duration,
      top: offset.dy,
      left: offset.dx,
      child: child,
    );
  }
}

