

  import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sharara_apps_building_helpers/notifier.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';

final class OuterScreenMaskController {
    final ShararaNotifier<List<TaskProgressHolder>> tasksProgress = ShararaNotifier([]);
    OuterScreenMaskController._();
    static  OuterScreenMaskController? _controller;
    static OuterScreenMaskController init()=> instance;
    static bool get forUsing  => _controller != null;


    static OuterScreenMaskController get instance {
      _controller??=OuterScreenMaskController._();
      return _controller!;
    }
    launch(final TaskProgressHolder holder)async{
     tasksProgress
         ..value.add(holder..startProgressing())
         ..notifyListeners();
     final rs = await FunctionHelpers.tryFuture(holder.future);
     if( rs != null && rs is CompletingResults ) {
       if(holder._disposed)return;
       holder._timer?.cancel();
       holder._timer = null;
       holder.results = rs;
       holder.progress?.notifyListeners();
       holder._startDownTown();
       return;
     }
     tasksProgress
       ..value.removeWhere((e){
         final p = e.id == holder.id;
         if ( p ) {
           Future.delayed(const Duration(seconds: 3)).then((_)=>e.dispose());
         }
         return p;
       })
       ..notifyListeners();
    }


    remove(final TaskProgressHolder holder) async {
      bool edited = false;
      tasksProgress
          .value.removeWhere((e){
            final r = e.id == holder.id;
            if( r ){
              edited = true;
              Future.delayed(const Duration(seconds:3))
              .then((_)=>e.dispose());
            }
            return r;
      });
      if(!edited)return;
      tasksProgress.notifyListeners();
    }
  }



  final class TaskProgressHolder {
   final String id ;
    final String title;
    final Future<dynamic> future;
    CompletingResults? results;
    ShararaNotifier<double>? progress;
     TaskProgressHolder({
      required this.title,
      required this.future,
      this.progress ,
     }):

     id = FunctionHelpers.generateUniqueString;
     bool _disposed = false;
     Timer? _timer;

     totalToUsedPercentage(final int? total,final int sent){
       if ( total == null )return;
       progress??= ShararaNotifier(0);
       progress!.value = (sent / total);

     }

     startProgressing()async{
       if(progress != null || _timer != null  )return;
       progress ??= ShararaNotifier(0);
       _timer = Timer.periodic(const Duration(milliseconds:10), (_){
         if(_disposed)return;
         final v = progress!.value;
         if( v >= 99.9){progress?.value = 0;}
         else {progress?.value +=0.0001;}
         progress?.notifyListeners();
       });
     }


     _startDownTown(){
       if(_timer != null )_timer?.cancel();
       progress??= ShararaNotifier(10);
       progress?.value = 10;
       _timer = Timer.periodic(const Duration(seconds: 1), (_){

         if(_disposed)return;
         progress?.value -=1;
         if( (progress?.value??0) <= 0 ) {
           OuterScreenMaskController.instance.remove(this);
           return;
         }
         progress?.notifyListeners();
       });
     }
     dispose()async{
       if(_disposed)return;
       _disposed = true;
       _timer?.cancel();
       progress?.dispose();
     }
}

  final class CompletingResults {
    final bool? success ;
    final String? label;
    final Widget? child;
   const CompletingResults({ this.label, this.success,
      this.child,
    }):assert(child != null || ( success != null && label != null));

  }