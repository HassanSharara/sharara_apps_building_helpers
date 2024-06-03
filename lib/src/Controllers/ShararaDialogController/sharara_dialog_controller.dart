
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/ui.dart';
typedef QB = (Completer,WidgetBuilder);
class ShararaDialogController {
  ShararaDialogController._();
  static final ShararaDialogController instance = ShararaDialogController._();
  final List<QB> dialogsQueue = [];
  QB? _holder;
  int  activeDialogsCount = 0 ;
  Future<void> _forceEndingTheCurrentWorkLoad()async{
    cancelCurrentDialog();
    await Future.delayed(const Duration(milliseconds:100));
  }

  showShararaDialog(final Widget child,{
    final bool canPop = true,
    final Future Function()? onPopInvoked,
    final bool pushAsFirst = false
  })async{
    if(_holder!=null){
      await _holder!.$1.future;
      _holder = null;
    }
    final Completer completer = Completer();
    final item = (completer,(context) => _dialogWrapper(
        child,
        canPop:canPop,
        onPopInvoked:(_)async{
          if(onPopInvoked!=null){
            await onPopInvoked();
          }
          await _refreshDialogInvoking();
          if(activeDialogsCount>0)activeDialogsCount--;
          if(!completer.isCompleted)completer.complete();
        })
    );
    if(pushAsFirst){
      dialogsQueue.insert(0,item);
    }else{
      dialogsQueue.add(item);
    }
    if(dialogsQueue.isNotEmpty){
      await _contextUsingWorker();
    }
  }

  forceShowingDialog(final Widget child,{final bool canPop = true,
   final bool continueAfterCompletingThis = true,
   final Future Function()? doThenCancelCallBack
  })async{
    // await _forceEndingTheCurrentWorkLoad();
    await showShararaDialog(
        child,
        canPop:canPop,

    );
    if( doThenCancelCallBack!= null ){
      await FunctionHelpers.tryFuture(doThenCancelCallBack());
      await Future.delayed(const Duration(milliseconds:20));
      await cancelCurrentDialog();
    }
  }
  doYouReallyWantToTakeThisAction(final DialogAskHolder holder){
    showShararaDialog(
        DoYouReallyWantToTakeThisAction(
        holder: holder,
        functionWrapper:(BuildContext context)async{
          await FunctionHelpers.tryFutureCallBack(()async{
            _pop(context);
            await holder.onAgree();
          });
        },
    ),canPop:true);
  }

  Future<void> startLoading(
  {
    final Future Function()? onLoadingFutureCallback,
    final bool canPop = true})async=>
      await forceShowingDialog(
      const ShararaLoadingDialog(
        logo:Icon(
          Icons.check_circle,
          color:Colors.green,
        )
    ),
        doThenCancelCallBack:onLoadingFutureCallback
  );


  void stopLoading()=>cancelCurrentDialog();

   int cancelCounter = 0;

   // _cancelWorkerManager()async{
   //   if(cancelCounter<=2){
   //     await Future.delayed(const Duration(milliseconds:400));
   //     cancelCounter++;
   //     return  await cancelCurrentDialog();
   //   }else{
   //     cancelCounter = 0 ;
   //   }
   // }

   cancelCurrentDialog()async{
     await Future.delayed(const Duration(milliseconds:20));
     if(activeDialogsCount<=0){
      // await _cancelWorkerManager();
      return;
    }
    final ScreenMaskController? lastController = MaskRootController.lastScreenController;
    if( lastController==null || !lastController.canUse )return;
    _pop(lastController.context!);
    if(dialogsQueue.isNotEmpty)await _contextUsingWorker();
   }

  _pop(final BuildContext context){
    final NavigatorState navigator = Navigator.of(context);
    if(navigator.canPop())navigator.pop();
  }

   void jumpUsingDialog(final Widget child)async{
     await _forceEndingTheCurrentWorkLoad();
     final lastController = await getLastActiveScreenController;
     if( lastController==null || !lastController.canUse )return;
     await Future.delayed(const Duration(milliseconds:200));
     FunctionHelpers.jumpTo(lastController.context!, child);
   }

  _refreshDialogInvoking([final Future Function()? postFrameCallBack])async{
    await Future.delayed(const Duration(milliseconds:200));
    if(postFrameCallBack!=null) await postFrameCallBack();
  }

  Widget _dialogWrapper(final Widget child,{final bool canPop = true,final PopInvokedCallback? onPopInvoked})=>
      popperWrapper(
    child:Material(
      color:RoyalColors.transparent,
      child:child,
    ),canPop:canPop,
   onPopInvoked:onPopInvoked
  );

   Widget popperWrapper (
       {
         required final Widget child,
         final bool canPop = true,final PopInvokedCallback? onPopInvoked}){
     return PopScope(
         canPop:canPop,
         onPopInvoked:onPopInvoked ?? (_){
           if(activeDialogsCount>0)activeDialogsCount--;
           _refreshDialogInvoking();
     },child:child,);
   }


  Future<ScreenMaskController?>  get getLastActiveScreenController async{
  final ScreenMaskController? lastController =
      MaskRootController.lastScreenController ;
  if( lastController==null || !lastController.canUse )return null;
  return lastController;
}

 Future<BuildContext?> get getContextByQueue async {
   if(_holder!=null)await _holder!.$1.future;
   final ScreenMaskController? lastController = await getLastActiveScreenController;
    if(lastController==null || !lastController.canUse) return null;
    await Future.delayed(const Duration(milliseconds:250));
   return lastController.context;
  }

  Future<void> _contextUsingWorker()async{
    if ( dialogsQueue.isEmpty || activeDialogsCount>=1 )return ;
    final ScreenMaskController? lastController =
    await getLastActiveScreenController;
    if(lastController == null  || dialogsQueue.isEmpty)return;
     activeDialogsCount++;
     final QB qb = dialogsQueue.removeAt(0);
     _holder = qb;
    showDialog(
        context:lastController.context!,
        builder: qb.$2);
    final int hashCode = qb.hashCode;
    qb.$1.future.then((_){
      if(_holder?.hashCode != hashCode)return;
      _holder = null;
    });
  }
 
}


