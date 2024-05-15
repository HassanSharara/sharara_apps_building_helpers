import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/ui.dart';

main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await ShararaAppHelperInitializer.initialize();
  runApp( ShararaAppHelper(builder:(BuildContext context)=>const FirstScreen()));
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Test();
  }
}
class Test extends StatelessWidget {
  const Test({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:Drawer(
        child:ListView(
          children: const [
            SizedBox(height: 80,),
            Text("Hi")
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton(
        child:const Icon(Icons.add),
        onPressed:(){},
      ),
      appBar:AppBar(
        title:const Text("app bar"),
        centerTitle:true,
      ),
      body:Center(
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
               Card(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding:const EdgeInsets.all(10),
                        child:const Icon(Icons.ac_unit_outlined),
                      ),

                      Container(
                        padding:const EdgeInsets.all(10),
                        child: Text("${Colors.green.value}"),
                      ),
                    ],
                  ),
                ),
              ),


              ElevatedButton(
                onPressed:(){
                  FunctionHelpers.
                  jumpTo(context, const ShararaThemePicker());
                  FunctionHelpers.toast("success",status:true);
                },
                child:const Text("settings"),
              ),
              const SizedBox(height:20,),
              RoyalRoundedButton(
                key:UniqueKey(),
                onPressed:()async{
                 ShararaDialogController
                 .instance
                     .startLoading(
                   onLoadingFutureCallback:()async{
                     await Future.delayed(const Duration(seconds:3));
                   }
                 );
                 await Future.delayed(const Duration(seconds:1));
                 ShararaDialogController
                 .instance.jumpUsingDialog(
                   const ShararaThemePicker()
                 );
                },
                title:"settings",
              ),

            ],
          )
      ),
    );
  }
}

