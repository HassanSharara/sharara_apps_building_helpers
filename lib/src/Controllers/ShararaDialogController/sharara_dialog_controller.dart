
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Constants/Colors/colors.dart';
import 'package:sharara_apps_building_helpers/ui.dart';

class ShararaDialogController {
  ShararaDialogController._();

  static final ShararaDialogController instance = ShararaDialogController._();

  final Queue<WidgetBuilder> _queueHolder = Queue();
  final Queue<WidgetBuilder> dialogsQueue = Queue();
  int  activeDialogsCount = 0 ;
  Completer _unBThread = Completer()..complete();
  Completer get unBlockThread => _unBThread;
  set unBlockThread(final newValue){
    if(!_unBThread.isCompleted)_unBThread.complete();
    _unBThread = newValue;
  }


  Future<void> _forceEndingTheCurrentWorkLoad([final bool cacheThem = true])async{
    await Future.delayed(const Duration(milliseconds:100));
    if ( dialogsQueue.isNotEmpty && cacheThem) {
      _queueHolder.addAll(dialogsQueue);
    }
    dialogsQueue.clear();
    cancelCurrentDialog();
    await Future.delayed(const Duration(milliseconds:100));
  }
  showShararaDialog(final Widget child,{
    final bool canPop = true,
    final Future Function()? onPopInvoked,
  }){
    dialogsQueue.add((context) => _dialogWrapper(
        child,
        canPop:canPop,
        onPopInvoked:(_)async{
          activeDialogsCount--;
          if(onPopInvoked!=null){
            await onPopInvoked();
          }
          _refreshDialogInvoking();
        })
    );
    if(dialogsQueue.length == 1)_showDialog();
  }
  forceShowingDialog(final Widget child,{final bool canPop = true,
   final bool continueAfterCompletingThis = true,
   final Future Function()? doThenCancelCallBack
  })async{
    await _forceEndingTheCurrentWorkLoad();
    showShararaDialog(
        child,
        canPop:canPop,
        onPopInvoked:()async{
          if(continueAfterCompletingThis && _queueHolder.isNotEmpty){
            await Future.delayed(const Duration(milliseconds:100));
            if(_queueHolder.isNotEmpty){
              dialogsQueue.addAll(_queueHolder);
              _queueHolder.clear();
              await Future.delayed(const Duration(milliseconds:100));
            }
          }else {
            _queueHolder.clear();
          }
        }
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
          unBlockThread = Completer();
          await FunctionHelpers.tryFutureCallBack(()async{
            Navigator.pop(context);
            await holder.onAgree();
          });
         if(!unBlockThread.isCompleted) unBlockThread.complete();
        },
    ),canPop:true);
  }

  Future<void> startLoading(
  {
    final Future Function()? onLoadingFutureCallback,
    final bool canPop = true})async=>
      forceShowingDialog(
    const ShararaLoadingDialog(
        logo:Icon(
          Icons.check_circle,
          color:Colors.green,
        )
    ),
        doThenCancelCallBack:onLoadingFutureCallback
  );


  void stopLoading()=>cancelCurrentDialog();
  
   cancelCurrentDialog(){
    if(activeDialogsCount<=0)return;
    final ScreenMaskController? lastController = MaskRootController.lastScreenController;
    if( lastController==null || !lastController.canUse )return;
    Navigator.pop(lastController.context!);
    if(!unBlockThread.isCompleted){
      unBlockThread.complete();
    }
  }

   void jumpUsingDialog(final Widget child)async{
     await _forceEndingTheCurrentWorkLoad();
     final lastController = await getLastActiveScreenController;
     if( lastController==null || !lastController.canUse )return;
     await Future.delayed(const Duration(milliseconds:200));
     FunctionHelpers.jumpTo(lastController.context!, child);
   }

  _refreshDialogInvoking([final Future Function()? postFrameCallBack])async{
    if(dialogsQueue.isEmpty)return;
    dialogsQueue.removeFirst();
    await Future.delayed(const Duration(milliseconds:200));
    if(postFrameCallBack!=null) await postFrameCallBack();
    _showDialog();
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
       _refreshDialogInvoking();
     },child:child,);
   }


  Future<ScreenMaskController?>  get getLastActiveScreenController async{
  await unBlockThread.future;
  final ScreenMaskController? lastController = MaskRootController.lastScreenController;
  if( lastController==null || !lastController.canUse )return null;
  return lastController;
}

 Future<BuildContext?> get lastAvailableBuildContext async {
   final ScreenMaskController? lastController = await getLastActiveScreenController;
    if(lastController==null || !lastController.canUse) return null;
    await Future.delayed(const Duration(milliseconds:250));
    return lastController.context;
  }

  void _showDialog()async{
    if ( dialogsQueue.isEmpty || activeDialogsCount>=1 )return null;
    final ScreenMaskController? lastController = await getLastActiveScreenController;
    if(lastController == null )return;
    final WidgetBuilder builder = dialogsQueue.first;
    activeDialogsCount++;
    showDialog(context:lastController.context!, builder: builder);
  }
}


