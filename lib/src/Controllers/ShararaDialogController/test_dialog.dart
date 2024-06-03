

import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';

typedef Q = (Completer,WidgetBuilder);
class TestDialog {
  final Queue<Q> queue = Queue();
  Q? holder;

  showSD(){
    final Completer completer = Completer();
    queue.add((completer,(c)=>const SizedBox()));
    if(queue.length==1){
      show();
    }
  }


  show()async{
    if(holder!=null){
      await holder!.$1.future;
       holder = queue.removeFirst();
    }
  }
}