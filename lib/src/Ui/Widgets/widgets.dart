import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Constants/Colors/colors.dart';

class RoyalPhoneTextFormField extends RoyalTextFormField {
   const RoyalPhoneTextFormField({super.key,
    required super.title,
    required super.controller,
  }):assert(
  controller is PhoneTextEditController
  ),super(
     inputType:TextInputType.phone
   );
}

class PhoneTextEditController extends TextEditingController {
  Country? country;
  final List<String> countryFilter ;
  PhoneTextEditController({this.countryFilter = const ["IQ"],super.text}):assert(countryFilter.isNotEmpty);
  String get phoneCode => country?.phoneCode??"964";
  String get nText => "+$phoneCode${super.text.replaceAll(phoneCode,"").replaceAll("+","")}".replaceAll("+${phoneCode}0","+$phoneCode");

}

class PhoneCodePicker extends StatefulWidget {
  const PhoneCodePicker({super.key,required this.controller});
  final PhoneTextEditController controller;
  @override
  State<PhoneCodePicker> createState() => _PhoneCodePickerState();
}
class _PhoneCodePickerState extends State<PhoneCodePicker> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        showCountryPicker(context: context,
            countryFilter:widget.controller.countryFilter,
            onSelect:(Country country){
          setState(() {
            widget.controller.country = country;
          });
        });
      },
      child: Row(
        mainAxisSize:MainAxisSize.min,
        children: [
          Text("+${widget.controller.country?.phoneCode??"964"}"),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }
}


class RoyalTextFormField extends StatefulWidget {
  const RoyalTextFormField(
      {super.key,
        this.title,
        required this.controller,
        this.inputType,
        this.width,
        this.height,
        this.radius = 25,
        this.suffixIcon,
        this.maxLength,
        this.borderColor ,
        this.focusColor ,
        this.hintText ,
        this.maxLines = 1,
        this.isPassword = false,
        this.contextMenuBuilder,
      });
  final String? title,hintText;
  final TextEditingController controller;
  final TextInputType? inputType;
  final bool isPassword;
  final int? maxLines,maxLength;
  final double? height, width;
  final double radius;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? focusColor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  @override
  State<RoyalTextFormField> createState() => _RoyalTextFormFieldState();
}

class _RoyalTextFormFieldState extends State<RoyalTextFormField> {
  bool password = false;

  @override
  void dispose() {
    //widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhoneController = widget.controller is PhoneTextEditController;
    final Widget? suffix = isPhoneController ?
    PhoneCodePicker(controller: widget.controller as PhoneTextEditController)
        :
    (widget.isPassword == true
        ? IconButton(
      icon: const Icon(
        Icons.remove_red_eye,
        color:Colors.blueGrey,
      ),
      onPressed: () {
        setState(() {
          password = !password;
        });
      },
    )
        : null
    );

    return Container(
      height: widget.height,
      width: widget.width,
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextFormField(
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        controller: widget.controller,
        contextMenuBuilder:widget.contextMenuBuilder ??
           (BuildContext context,editableText)=>
            AdaptiveTextSelectionToolbar.buttonItems(
              anchors:editableText.contextMenuAnchors,
              buttonItems: [
                ContextMenuButtonItem(
                    label:"نسخ",
                    onPressed:
                        ()=>editableText.copySelection(SelectionChangedCause.toolbar)),
                ContextMenuButtonItem(
                    label:"تحديد الكل",
                    onPressed:
                        ()=>editableText.selectAll(SelectionChangedCause.toolbar)),
                ContextMenuButtonItem(
                    label:"لصق",
                    onPressed:
                        ()=>editableText.pasteText(SelectionChangedCause.toolbar))

              ],
            ),
        keyboardType: widget.inputType,
        obscureText: password,
        style: const TextStyle(
            color:Colors.blueGrey, fontWeight: FontWeight.w300),
        decoration: InputDecoration(

          suffixIcon: suffix,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color:RoyalColors.greyFaintColor.withOpacity(0.6),
          ),
          hintFadeDuration:const Duration(seconds:0),
          label: widget.title==null?null: Text(
            '  ${widget.title}',
            style: const TextStyle(color:Colors.blueGrey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide:  BorderSide(
              color: widget.borderColor ?? RoyalColors.greyFaintColor,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide:  BorderSide(
              color: widget.focusColor ?? RoyalColors.mainAppColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide:  BorderSide(
              color: widget.borderColor?? RoyalColors.greyFaintColor,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class RoyalRoundedButton extends StatelessWidget {
  const RoyalRoundedButton(
      {
        super.key,
        this.title,
        this.onPressed,
        this.color,
        this.opacity,
        this.linearGradientColors,
        this.gradient,
        this.textStyle,
        this.height,
        this.width,
        this.borderRadius,
        this.boxShadowColorOpacity = 0.3,
        this.boxShadowBlurRadius = 9.0,
        this.boxShadowSpreadRadius = 4.0,
        this.padding = const EdgeInsets.symmetric(horizontal:16,vertical:10),
        this.child});
  final String? title;
  final Widget? child;
  final GestureTapCallback? onPressed;
  final Color? color;
  final List<Color>? linearGradientColors;
  final TextStyle? textStyle;
  final double boxShadowSpreadRadius,boxShadowBlurRadius,boxShadowColorOpacity;
  final double? opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  final Gradient? gradient;
  final double? height,width;
  @override
  Widget build(BuildContext context) {
    final Color color = this.color ?? RoyalColors.mainAppColor;

    final Gradient defaultGradient = LinearGradient(
        colors:
        onPressed==null?
        (
            linearGradientColors!=null?
            linearGradientColors!.map(
                    (e)=>e.withOpacity(0.35)
            ).toList():
            [
              color.withOpacity(0.35),
              color.withOpacity(0.35),
            ])

            :
        linearGradientColors!=null?
        linearGradientColors!:
        [
          color,
          color.withOpacity(0.6),
        ]
    );
    return Column(
      mainAxisSize:MainAxisSize.min,
      children: [
        InkWell(
          onTap:onPressed,
          radius:15,

          child: Container(
            padding:padding,
            margin:const EdgeInsets.symmetric(horizontal:4.0),
            height:height,
            width:width,
            decoration:BoxDecoration(
                borderRadius:borderRadius??BorderRadius.circular(15),
                gradient: onPressed!=null ?
                gradient ??
                defaultGradient:
                defaultGradient,
                boxShadow:[
                  BoxShadow(
                    color:color.withOpacity(boxShadowColorOpacity),
                    spreadRadius:boxShadowSpreadRadius,
                    blurRadius:boxShadowBlurRadius
                  )
                ]
            ),
            child:Center(
              child: child ??
                  Text(
                    title!,
                    style: textStyle ?? const TextStyle(color:RoyalColors.white),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShararaSwitchIcon extends CupertinoSwitch {
        ShararaSwitchIcon(
      { super.key,
        required super.value,
        required super.onChanged
      }):super(
     activeColor:RoyalColors.mainAppColor
    );
}

class SquareProfileHeaderWithCenterOverFWidget extends StatelessWidget {
  const SquareProfileHeaderWithCenterOverFWidget({super.key,
   required this.backgroundImagePath,
   required this.child,
   this.onEditWidgetTap,
  });
  final String backgroundImagePath;
  final GestureTapCallback? onEditWidgetTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return       Stack(
      children: [
        Container(
          clipBehavior:Clip.none,
          height:260,
          width:size.width,
          margin:const EdgeInsets.only(bottom:50),
          decoration: BoxDecoration(
              image:DecorationImage(
                  image:AssetImage(backgroundImagePath),
                  fit:BoxFit.fill
              )
          ),
        ),
        Positioned(
          bottom:-0,
          child:GestureDetector(
            onTap:onEditWidgetTap,
            child: SizedBox(
              width:size.width,
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      child,

                      if(onEditWidgetTap!=null)
                      Positioned(
                        bottom:0,
                        right:2,
                        child:RoyalShadowContainer(
                          padding:4,
                          shape:BoxShape.circle,
                          child:Icon(Icons.edit,
                            size:15,
                            color:RoyalColors.mainAppColor,),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top:10,
          right:4,
          child:GestureDetector(
            onTap:()=>Navigator.maybePop(context),
            child:const RoyalShadowContainer(
              shape:BoxShape.circle,
              backgroundColor:RoyalColors.white,
              child:Icon(Icons.arrow_back_ios_new),
            ),
          ),
        )
      ],
    );
  }
}

class SnakeLikeBackgroundProfileHeaders extends StatefulWidget {
  const SnakeLikeBackgroundProfileHeaders({super.key,
    required this.profileImageWidget,
    this.onEditProfileTap,
  });
  final Widget profileImageWidget;
  final GestureTapCallback? onEditProfileTap;
  @override
  State<SnakeLikeBackgroundProfileHeaders> createState() => _SnakeLikeBackgroundProfileHeadersState();
}

class _SnakeLikeBackgroundProfileHeadersState extends State<SnakeLikeBackgroundProfileHeaders> with
    SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation animation;
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration:const Duration(
        seconds:2));
    animation = CurvedAnimation(parent:animationController,
        curve:Curves.elasticInOut);
    super.initState();
    animationController.forward();
  }

  @override
  dispose(){
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height:300,
          width:size.width,
          child: Stack(
            children: [
              SizedBox.expand(
                child:AnimatedBuilder(
                  animation:animation,
                  builder:(BuildContext context,_){
                    return  CustomPaint(
                      painter:SnakeLikeBackgroundProfilePainter(
                          animationValue:animation.value
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment:const Alignment(0,0.5),
                child:GestureDetector(
                  onTap:widget.onEditProfileTap,
                  child: Stack(
                    children: [
                      Wrap(
                        children: [
                          RoyalShadowContainer(
                            shape:BoxShape.circle,
                            child:widget.profileImageWidget,
                          )
                        ],
                      ),
                      Positioned(
                        bottom:0,
                        right:3,
                        child:RoyalShadowContainer(
                          shape:BoxShape.circle,
                          padding:4,
                          child: Icon(Icons.edit,
                            size: 14,
                            color:RoyalColors.secondaryColor,),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              if(Navigator.canPop(context))
                Align(
                  alignment:const Alignment(0.9,-0.7),
                  child:InkWell(
                    borderRadius:BorderRadius.circular(15),
                    onTap:()=>Navigator.maybePop(context),
                    splashColor:RoyalColors.mainAppColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoyalShadowContainer(
                        child: Icon(Icons.arrow_back_ios_new_outlined,
                          color:RoyalColors.mainAppColor,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        )


      ],
    );
  }
}




class SnakeLikeBackgroundProfilePainter extends CustomPainter {
  final double animationValue;
  SnakeLikeBackgroundProfilePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = RoyalColors.mainAppColor;
    final double width = size.width ;
    final double height = size.height;
    canvas.drawPath(_generatePathFrom(
        size ,
        animationValue
    ),paint);
    canvas.drawPath(_generatePathFrom(
        size ,
        animationValue,
        extraValue:15
    ), Paint()..color = RoyalColors.secondaryColor.withOpacity(0.25));
    canvas.drawCircle( Offset(width - 50 ,height - 50) * animationValue,10 * animationValue,
        paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  static Path _generatePathFrom(final Size size,final double animationValue,{
    final double extraValue = 0
  }){
    final Path path = Path();
    final double width = size.width ;
    final double height = size.height;
    path.moveTo(0,height/2);
    path.lineTo(0,0);
    path.lineTo(width,0);
    path.quadraticBezierTo(((width/2) + extraValue) * animationValue,30  * animationValue,((width/2) + extraValue) * animationValue,(200) * animationValue);
    path.quadraticBezierTo(((width/2) + extraValue) * animationValue,350 * animationValue ,0 , 400 * animationValue);
    return path;
  }
}
class RoyalShadowContainer extends StatelessWidget {
  const RoyalShadowContainer(
      {super.key,
        required this.child,
        this.spreadRadius,
        this.insidePadding,
        this.padding,
        this.borderRadius,
        this.height,
        this.width,
        this.radius,
        this.opacity = 0.2,
        this.shadowColor,
        this.backgroundColor,
        this.boxShadow,
        this.shape = BoxShape.rectangle,
        this.clipBehavior = Clip.none,
        this.margin});
  final Widget child;
  final double? padding, radius;
  final Color? shadowColor, backgroundColor;
  final EdgeInsets? margin, insidePadding;
  final double? height, width, spreadRadius, opacity;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;
  final BoxShape shape;
  final List<BoxShadow>? boxShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        margin: margin,
        padding: insidePadding ?? EdgeInsets.all(padding ?? 8.0),
        decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).canvasColor,
            shape:shape,
            borderRadius:
                shape == BoxShape.circle ? null :
            borderRadius ?? BorderRadius.all(Radius.circular(radius ?? 15)),
            boxShadow: boxShadow ?? [
              BoxShadow(
                  color: shadowColor ??
                      RoyalColors.getBodyColor(context)
                          .withOpacity(opacity!),
                  blurRadius: 4,
                  spreadRadius: spreadRadius ?? 0.02)
            ]),
        child: child);
  }
}

class ShararaDialog extends StatelessWidget {
  const ShararaDialog({
    super.key,
    required this.child,
    this.fullHeight = false,
    this.padding = const EdgeInsets.symmetric(vertical:8.0),
    this.heightDivideOn,
    this.width,
  });
  final Widget child;
  final bool fullHeight;
  final EdgeInsets padding;
  final double? heightDivideOn,width;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child:RoyalShadowContainer(
        insidePadding:padding,
        height:size.height/ (heightDivideOn ?? (fullHeight?1:2)),
        width:width ?? size.width,
        child:child,
      ),
    );
  }
}

class ShararaLoadingDialog extends StatelessWidget {
  const ShararaLoadingDialog({super.key,required this.logo});
  final Widget logo;
  @override
  Widget build(BuildContext context) {
    return ShararaDialog(
      heightDivideOn:4,
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Expanded(child: Center( child: logo,)),
          const CircularProgressIndicator()
        ],
      ),
    );
  }
}

class CurvedAbstractProfileHeader extends StatelessWidget {
  const CurvedAbstractProfileHeader({super.key,
    required this.coverImagePath,
    required this.profileImageWidget,
    this.abstractColor,
    this.onProfileImageTap,
  });
  final String coverImagePath;
  final Color? abstractColor;
  final Widget profileImageWidget;
  final GestureTapCallback? onProfileImageTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:300,
      child: Stack(
        children: [
          ClipPath(
            clipper:  ProfileClipper(),
            child:Container(
              decoration: BoxDecoration(
                  image:DecorationImage(
                      image: AssetImage(coverImagePath),
                      fit:BoxFit.fill
                  )
              ),
            ),
          ),
          SizedBox.expand(
            child: CustomPaint(
              painter:ProfileBCPainter(
                  color:abstractColor
              ),

            ),
          ),
          GestureDetector(
            onTap:()=>Navigator.maybePop(context),
            child:const Align(
              alignment: Alignment(0.95,- 0.8),
              child:RoyalShadowContainer(
                shape:BoxShape.circle,
                child:Icon(Icons.arrow_back_ios_new),
              ),
            ),
          ),
          Center(
            child: Align(
              child: GestureDetector(
                onTap:onProfileImageTap,
                child: Stack(
                  children: [
                    RoyalShadowContainer(
                      padding:0,
                      shape:BoxShape.circle,
                      shadowColor:RoyalColors.mainAppColor
                          .withOpacity(0.3),
                      spreadRadius:5,
                      height:100,
                      width:100,
                      child:profileImageWidget,
                    ),

                    Positioned(
                      bottom:0,
                      right:5,
                      child:RoyalShadowContainer(
                        shape:BoxShape.circle,
                        shadowColor:RoyalColors.mainAppColor.withOpacity(0.5),
                        padding:4,
                        child:const Icon(Icons.edit,
                          color:RoyalColors.greyFaintColor,
                          size:20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

final class ProfileBCPainter extends CustomPainter {
  Color? color;
  ProfileBCPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    buildArc(canvas, size,opacity:0.24);
    buildArc(canvas, size,extraHeightValue:30);
    buildArc(canvas, size,extraHeightValue:50,opacity:0.04);
  }

  buildArc(final Canvas canvas,final Size size,{final double extraHeightValue = 0,
    final double opacity = 0.07
  }){
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    path.moveTo(0, 90);
    path.lineTo(0,120 + extraHeightValue);
    path.quadraticBezierTo((width/4),((height/2)-30) + extraHeightValue,(width/2)-40,(height/2) +  20 + extraHeightValue );
    path.quadraticBezierTo((width*0.8),(height - 40) + extraHeightValue,
        width,height-(40 * 1.3) + extraHeightValue);

    final double backHeight = height - 80;
    path.lineTo(size.width,backHeight );
    path.lineTo(size.width - 50 ,backHeight);
    path.quadraticBezierTo(size.width - 70, backHeight , width/2,( height /2 ) + extraHeightValue);
    path.quadraticBezierTo(40 * 2 ,90 - 10, 0,90);
    canvas.drawPath(path,Paint()..color=(color??= RoyalColors.mainAppColor)
        .withOpacity(opacity)
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class ProfileClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    path.moveTo(0, 0);
    path.lineTo(0,90);
    path.quadraticBezierTo((width/4),(height/2)-60,(width/2)-40,(height/2));
    path.quadraticBezierTo((width*0.8),(height*0.8),width,height-80);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}


class DoYouReallyWantToTakeThisAction extends StatelessWidget {
  const DoYouReallyWantToTakeThisAction({super.key,
    required this.holder,
    this.functionWrapper,
  });
  final Function(BuildContext)? functionWrapper;
  final DialogAskHolder holder;
  @override
  Widget build(BuildContext context) {
    return ShararaDialog(
      heightDivideOn:2.4,
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          holder.titleWidget ??
          Expanded(
            child: Center(child: Text(holder.message,textAlign:TextAlign.center,)),
          ),
          Center(child:
             Row(
               mainAxisAlignment:MainAxisAlignment.spaceAround,
               crossAxisAlignment:CrossAxisAlignment.center,
               children:holder.actions ??
                [
                  Align(
                    child: RoyalRoundedButton(
                      onPressed:()async{
                        if ( functionWrapper !=null ){
                          return await functionWrapper!(context);
                        }
                        Navigator.pop(context);
                        await holder.onAgree();
                      },
                      title:holder.agreeHint??"نعم",
                    ),
                  ),

                  ElevatedButton(
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      child: Text(holder.refuseHint??"لا"))
                ]
               ,
             )
            ,)
        ],
      ),
    );
  }
}

class DialogAskHolder {
  final Future Function() onAgree;
  final String message;
  final Function()? onRefuse;
  final List<Widget>? actions;
  final Widget? titleWidget;
  final String? agreeHint,refuseHint;
  const DialogAskHolder({
    required this.onAgree,
    this.message = "هل فعلاً تريد اتخاذ هذا الاجراء ؟",
    this.onRefuse,
    this.agreeHint,
    this.refuseHint,
    this.titleWidget,
    this.actions});
}



