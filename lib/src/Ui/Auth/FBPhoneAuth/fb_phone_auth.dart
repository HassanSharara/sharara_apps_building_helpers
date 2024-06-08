import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Ui/exporter.dart';

class FbPhoneAuthScreen extends StatefulWidget {
  const FbPhoneAuthScreen({super.key,
    this.title = "التحقق من رقم الهاتف",
    this.verificationSucceedMessage = "تم التحقق بنجاح",
    this.pleaseInsertOtp = "يرجى ادخال رمز التحقق",
    this.resendOtp = "اعادة ارسال رمز التحقق",
    required this.phoneNumber,
    required this.onVerificationSucceed,
    this.topWidgets = const [],
    this.onVerificationFail
  });
  final String phoneNumber;
  final String title,verificationSucceedMessage,pleaseInsertOtp,resendOtp;
  final PhoneVerificationFailed? onVerificationFail;
  final Function(UserCredential) onVerificationSucceed;
  final List<Widget> topWidgets ;
  @override
  State<FbPhoneAuthScreen> createState() => _FbPhoneAuthScreenState();
}

class _FbPhoneAuthScreenState extends State<FbPhoneAuthScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ValueNotifier<int> counter = ValueNotifier(30);
  final TextEditingController otpController = TextEditingController();

  PhoneAuthCredential? credential;
  UserCredential? _userCredential;
  String? verificationId;
  bool codeSent = false;

  @override
  void initState() {
    super.initState();
    otpController.addListener(_otpCounterListener);
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      _otpCounterListener();
      await Future.delayed(const Duration(milliseconds:150));
      _authenticatedByPhoneNumber();
    });
  }

  @override
  dispose(){
    super.dispose();
    if(_userCredential==null)return;
    widget.onVerificationSucceed(_userCredential!);
  }

  _otpCounterListener()async{
    if(counter.value >= 30 ){
      int previousNumber = counter.value +1 ;
      for(int i = counter.value;counter.value>0 && i+1 == previousNumber;i--){
        previousNumber = i;
        counter.value = previousNumber;
        await Future.delayed(const Duration(seconds:1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar:AppBar(
          title: Text(widget.title),
          centerTitle:true,
        ),
        body:_userCredential != null ?
            Center(
              child:Column(
                mainAxisSize:MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle,color:RoyalColors.green,size:28,),
                  const SizedBox(height:10,),
                  RoyalRoundedButton(
                    title:widget.verificationSucceedMessage,
                    onPressed:()=>Navigator.maybePop(context),
                  )
                ],
              ),
            ):
            ListView(
              padding:const EdgeInsets.all(10),
              children: [

                ...widget.topWidgets,
                const SizedBox(height:10,),
                if(verificationId!=null)
                  Text(widget.pleaseInsertOtp,textAlign:TextAlign.center,),
                const SizedBox(height:10,),
                RoyalTextFormField(title:"OTP", controller:otpController,inputType:TextInputType.phone,),
                const SizedBox(height:15,),

                ValueListenableBuilder(
                  valueListenable:counter,
                  builder:(BuildContext context,final int value,_){
                    if(value>=30)return const SizedBox();
                   return ElevatedButton(
                     onPressed:value>0?null:_authenticatedByPhoneNumber,
                     child:Text(
                        "${widget.resendOtp} ${value > 0 ? value.toString() : ""} ",textAlign:TextAlign.center,),

                   );
                  },
                ),
                const SizedBox(height:15,),

                ValueListenableBuilder(
                  valueListenable:otpController,
                  builder:(BuildContext context,final tv,_){
                    return RoyalRoundedButton(
                      title:widget.title,
                      onPressed:tv.text.isEmpty?null:()async{
                        await FunctionHelpers
                            .tryFutureCallBack(
                            _verify,
                          withLoading:true
                        );
                      },
                    );
                  },
                )
              ],
            )
        ,
      );
  }

Future<void>_verify()async{
    if(otpController.text.isEmpty || verificationId==null)return;
    credential =
    PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otpController.text);
    await _credentialToUse();
  }
  _credentialToUse()async{
    if(credential==null)return;
    _userCredential = await FunctionHelpers.tryFuture(auth.signInWithCredential(credential!));
    print("callllllllled ${_userCredential}");
    setState(() {});
  }
  _authenticatedByPhoneNumber()async{
    auth.verifyPhoneNumber(
       phoneNumber:widget.phoneNumber,
       verificationCompleted:(final credential)async{
         this.credential = credential;
         await _credentialToUse();
        },
        verificationFailed:widget.onVerificationFail??(_){
         FunctionHelpers.toast(_.message??"حصل خطأ في التحقق برقم الهاتف",status:false);
        },
        codeSent:(final String verificationId,__){
         WidgetsBinding.instance
             .addPostFrameCallback((_){
               setState(() {
                 this.verificationId = verificationId;
                 codeSent = true;
                 counter.value = 30;
               });
         });
        },
        codeAutoRetrievalTimeout:(final verificationId){
        });
  }
}
