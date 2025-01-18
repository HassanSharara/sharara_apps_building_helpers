import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Ui/exporter.dart';
export 'package:whatsapp_author/whatsapp_author.dart';
class WhatsAppAuthenticator extends StatefulWidget {
  const WhatsAppAuthenticator({super.key,
   required this.appAuthor,
   required this.toPhoneNumber,
   required this.onSuccess,
    this.onFail,
    this.topperBuilder,
    this.onHttpResponse,
    this.buttonColor = RoyalColors.green,
    this.textInput = TextInputType.phone,
    this.title = "التحقق",
    this.waitLabel = "يرجى الانتظار",
    this.textControllerLabel = "الرمز المرسل",
    this.buttonLabel = "تحقق عبر الواتساب",
    this.reSendOtpLabel = "اعادة ارسال رمز التحقق",
    this.authenticateLabel = "تحقق",
    this.otpCodeRequired = "رمز التحقق مطلوب",
  });
  final String toPhoneNumber;
  final WhatsAppAuthor appAuthor;
  final TextInputType textInput;
  final String title,textControllerLabel,buttonLabel,waitLabel,reSendOtpLabel,authenticateLabel,otpCodeRequired;
  final Color buttonColor;
  final Function() onSuccess;
  final Function()? onFail;
  final Function(dynamic)? onHttpResponse;
  final List<Widget> Function(BuildContext)? topperBuilder;
  @override
  State<WhatsAppAuthenticator> createState() => _WhatsAppAuthenticatorState();
}

class _WhatsAppAuthenticatorState extends State<WhatsAppAuthenticator> {
  final TextEditingController controller = TextEditingController();
  String? otpCode;
  final ValueNotifier<int> counter = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    counter.addListener(_counterListener);
    WidgetsBinding.instance.addPostFrameCallback(
        (_)async{
          await Future.delayed(const Duration(milliseconds:400));
          if(!mounted)return;
          _sendOtpCode();
        }
    );
  }
  _counterListener()async{
    if(counter.value<=0)return;
      await Future.delayed(const Duration(seconds: 1));
      if(!mounted)return;
      counter.value -=1;

  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text(widget.title),
        centerTitle:true,
      ),
      body:ListView(
        padding:const EdgeInsets.symmetric(vertical:12,horizontal:6),
        children: [
          if(widget.topperBuilder!=null)
            ...widget.topperBuilder!(context),
          RoyalTextFormField(
            title: widget.textControllerLabel,
            controller: controller,
            inputType:widget.textInput,
          ),
          const SizedBox(height:10,),
          ValueListenableBuilder(
              valueListenable: counter,
              builder:(BuildContext context,final int counter,_){
                final bool counterIsRunning = counter >= 1;
                return ElevatedButton(
                    onPressed:counterIsRunning?null:_sendOtpCode,
                    child: Text(
                        !counterIsRunning?widget.reSendOtpLabel:
                        "${widget.waitLabel}  ${counter<=0 ? 0 : counter}")
                );
              }
          ),
          const SizedBox(height:10,),
          ValueListenableBuilder(
              valueListenable: controller,
              builder: (BuildContext context,final text,_){
                return RoyalRoundedButton(
                  color:widget.buttonColor,
                  onPressed:text.text.isEmpty?null:authenticate,
                  title:widget.authenticateLabel,
                );
              })
        ],
      ),
    );
  }

  String get generateNewOtpCode{
    final StringBuffer buffer = StringBuffer();
    for(final int _ in List.generate(6,(_)=>_)){
      buffer.write(Random().nextInt(10));
    }
    return buffer.toString();
  }
   _sendOtpCode()async{
     _changeCounter(15);

     final String nOtp = generateNewOtpCode;
    final bool? sent = await FunctionHelpers.tryFutureCallBack<bool>(
                ( ) async {
      return await WhatsAppApiCaller
          .sendCodeToWhatsAppAccount(
          author: widget.appAuthor,
          code: nOtp,
          toPhoneNumber:widget.toPhoneNumber,
          onHttpResponse:widget.onHttpResponse,
      );
    },withLoading:true);
    if(sent==false){
      _changeCounter(0);
      return;
    }
    otpCode = nOtp;
   }
   _changeCounter(final int value){
    if(!mounted)return;
    counter.value = value;
   }
   authenticate(){
    if(controller.text.isEmpty){
      FunctionHelpers.toast(widget.otpCodeRequired);
      return;
    }
    if(controller.text == otpCode){
      widget.onSuccess();
      Navigator.maybePop(context);
    }else if(widget.onFail!=null){
      widget.onFail!();
    }
  }
}
