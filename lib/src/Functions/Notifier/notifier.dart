


 import 'package:flutter/foundation.dart';

final class ShararaNotifier<T> implements ValueListenable<T>{

  T __v;
  bool _disposed = false;
  final ValueNotifier<bool> notifier  = ValueNotifier(false);

  ShararaNotifier(final T value):__v = value;


  @override
  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  @override
  T get value => __v;

  set value(final T v){
    __v = v;
    if(_disposed)return;
    notifyListeners();
  }

  notifyListeners(){
    notifier.value = !notifier.value;
  }

  dispose(){
    if(_disposed)return;
    _disposed=true;
    notifier.dispose();
  }

}