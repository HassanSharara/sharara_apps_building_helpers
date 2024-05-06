
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/src/Constants/Colors/colors.dart';

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
  showShararaDialog(final Widget child,{
    final bool canPop = true,
    final Future Function()? onPopInvoked,
  }){
    dialogsQueue.add((context) => _dialogWrapper(
        child,
        canPop:canPop,
        onPopInvoked:(_)async{
          if(onPopInvoked!=null){
            await onPopInvoked();
          }
          _refreshDialogInvoking();
          activeDialogsCount--;
        })
    );
    if(dialogsQueue.length == 1)_showDialog();
  }
  forceShowingDialog(final Widget child,{final bool canPop = true})async{
    await Future.delayed(const Duration(milliseconds:100));
    if ( dialogsQueue.isNotEmpty) {
      _queueHolder.addAll(dialogsQueue);
      dialogsQueue.clear();
    }
    cancelCurrentDialog();
    await Future.delayed(const Duration(milliseconds:100));
    showShararaDialog(
        child,
        canPop:canPop,
        onPopInvoked:()async{
          if(_queueHolder.isNotEmpty){
            await Future.delayed(const Duration(milliseconds:100));
            if(_queueHolder.isNotEmpty){
              dialogsQueue.addAll(_queueHolder);
              _queueHolder.clear();
              await Future.delayed(const Duration(milliseconds:100));
            }
          }
        }
    );


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

  Future<void> startLoading({final bool canPop = true})async=>forceShowingDialog(
    const ShararaLoadingDialog(
        logo:Icon(Icons.check_circle,color:Colors.green,)
    )
  );


  cancelCurrentDialog(){
    if(activeDialogsCount<=0)return;
    final ScreenMaskController? lastController = MaskRootController.lastScreenController;
    if( lastController==null || !lastController.canUse )return;
    Navigator.pop(lastController.context!);
    if(!unBlockThread.isCompleted){
      unBlockThread.complete();
    }
  }
  _refreshDialogInvoking([final Future Function()? postFrameCallBack])async{
    if(dialogsQueue.isEmpty)return;
    dialogsQueue.removeFirst();
    await Future.delayed(const Duration(milliseconds:200));
    if(postFrameCallBack!=null) await postFrameCallBack();
    _showDialog();
  }
  Widget _dialogWrapper(final Widget child,{final bool canPop = true,final PopInvokedCallback? onPopInvoked})=> PopScope(
    canPop:canPop,
    onPopInvoked:onPopInvoked ?? (_){
       _refreshDialogInvoking();
    },
    child:Material(
      color:RoyalColors.transparent,
      child:child,
    ),
  );

  void _showDialog()async{
    if ( dialogsQueue.isEmpty || activeDialogsCount>=1 )return;
    await unBlockThread.future;
    final ScreenMaskController? lastController = MaskRootController.lastScreenController;
    if( lastController==null || !lastController.canUse )return;
    final WidgetBuilder builder = dialogsQueue.first;
    activeDialogsCount++;
    showDialog(context:lastController.context!, builder: builder);
  }
}


