

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Ui/ShararaAppHelper/context_and_main_scaffold_initializer.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class FunctionHelpers {

static Future<T?> tryFuture<T>(Future<T?> future,
    {
    final int? timeoutSeconds,
    final bool withLoading  = false,
    final Function(dynamic er)? onError})async{
    final T? result =  await future.then((value) => value)
        .timeout(Duration(seconds: timeoutSeconds ?? 90))
        .catchError((e){
      if(onError!=null)onError(e);
      return null;
    });
    return result;
  }

static Future<T?> tryFutureCallBack<T>(Future<T?> Function() callback,
    {final bool withLoading = false,
      final Function(dynamic)? onError
    })async{
  return await tryFuture(callback(),withLoading:withLoading,onError:onError);
}

  static String get generateUniqueString {
  const String charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random random = Random.secure();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < 12; i++) {
    final int randomIndex = random.nextInt(charset.length);
    buffer.write(charset[randomIndex]);
  }
  return "${buffer.toString()}${DateTime.now().toIso8601String().replaceAll("-","_")}";
}

  static toast(final String message, {final Color? color, final bool? status}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength:Toast.LENGTH_LONG,
        backgroundColor:
        color ?? (status==null?Colors.blueGrey:status ? Colors.green : Colors.red));
  }


  static jumpTo(final BuildContext context,final Widget child){
  ScreenMaskController.buildNew();
  Navigator.push(
   context,
   ShararaAnimatedNavigator(
     ShararaDirectionBuilder(
       builder:(_)=>ContextAndMainScaffoldInitializer(
         builder:(_)=>child,
       ),
     ),
   )
  );
  }

  static bool isInt(final dynamic d,{String? message = ""}){
     bool onError(final dynamic d){
       if(message!=null) {
         if(message?.isEmpty==true){
           message = "يحب ان تكون القيمة $d قيمة صحيحة ";
         }
         toast(message!);
      }
      return false;
     }
     if( d is List ){
       for(final dynamic v in d){
         if ( isInt(v) == false){
           return onError(v);
         }
       }
     }
     return int.tryParse(d.toString())!=null;
}
  static bool isDouble(final dynamic d,{String? message = ""}){
  bool onError(final dynamic d){
    if(message!=null) {
      if(message?.isEmpty==true){
        message = "يحب ان تكون القيمة $d قيمة صحيحة ";
      }
      toast(message!);
    }
    return false;
  }
  if( d is List ){
    for(final dynamic v in d){
      if ( isInt(v) == false){
        return onError(v);
      }
    }
  }
  return double.tryParse(d.toString())!=null;
}

static T? tryCatch<T>(Function() callback, {final Function(dynamic)? onError}){
  try{
    return callback();
  }catch(e){
    if(onError!=null){
      onError(e);
    }
  }
  return null;
}
  static bool isEmail(final String email,{final String message="يجب ان يكون البريد الالكتروني صالح"}){
    final check= RegExp(
        r'''
^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''')
        .hasMatch(email);
    if(!check)toast(message);
    return check;
  }

  static Future launchUrl(final String url,{
    final url_launcher.LaunchMode mode = url_launcher.LaunchMode.platformDefault,
  })async{
    await url_launcher.launchUrl(Uri.parse(url),mode:mode);
}
  static String executeIraqCode( String phone,{final String qCode = "+964"}){
    if(phone.contains(qCode))return phone;
    return qCode+phone;
  }
  static Future openWhatsAppFor({required  String phone,required final String message})async{
    String url;
    if (Platform.isAndroid) {
      url= "whatsapp://send?phone=$phone&text=${Uri.parse(message)}"; // new line
    } else {
      url = "https://wa.me/$phone?text=${Uri.parse(message)}"; // new line
    }
    await launchUrl(url);
  }

  static Future<void>phoneCall(final String? phone)async{
    if(phone==null) return;
    await launchUrl("tel:$phone");
  }

  static checkInputs(final List<TextEditingController> values,{final String message="جميع الحقول مطلوبة"}){
    for (final TextEditingController input in values){
      if(input.text.isEmpty){
        toast(message);
        return false;
      }
    }
    return true;
  }
}