import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Constants/Colors/colors.dart';


class RoyalTextFormField extends StatefulWidget {
  const RoyalTextFormField(
      {super.key,
        required this.title,
        required this.controller,
        this.inputType,
        this.width,
        this.height,
        this.radius = 25,
        this.suffixIcon,
        this.maxLength,
        this.borderColor ,
        this.focusColor ,
        this.maxLines = 1,
        this.isPassword = false,
        this.contextMenuBuilder,
      });
  final String title;
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

          suffixIcon: widget.suffixIcon ??
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
                  : null),
          label: Text(
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
              color: widget.borderColor?? RoyalColors.mainAppColor,
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
        this.textStyle,
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
  final TextStyle? textStyle;
  final double boxShadowSpreadRadius,boxShadowBlurRadius,boxShadowColorOpacity;
  final double? opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    final Color color = this.color ?? RoyalColors.mainAppColor;
    return Column(
      mainAxisSize:MainAxisSize.min,
      children: [
        InkWell(
          onTap:onPressed,
          radius:15,
          splashColor:RoyalColors.white,
          child: Container(
            padding:padding,
            margin:const EdgeInsets.symmetric(horizontal:4.0),

            decoration:BoxDecoration(
                borderRadius:borderRadius??BorderRadius.circular(15),
                gradient: LinearGradient(
                    colors:
                    [
                      color,
                      color,
                    ]),
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
        this.clipBehavior = Clip.none,
        this.margin});
  final Widget child;
  final double? padding, radius;
  final Color? shadowColor, backgroundColor;
  final EdgeInsets? margin, insidePadding;
  final double? height, width, spreadRadius, opacity;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        margin: margin,
        padding: insidePadding ?? EdgeInsets.all(padding ?? 8.0),
        decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).canvasColor,
            borderRadius:
            borderRadius ?? BorderRadius.all(Radius.circular(radius ?? 15)),
            boxShadow: [
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



