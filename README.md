# Sharara apps building helpers

Sharara Video Player is a powerful tool for building and facilitating the construction of applications with dynamic forms and very high control over the application frames, with the presence of basic application building elements.
There are also algorithms ready to communicate on the Internet, verify information, secure data, etc

# Features
- Key building shapes and elements you need in every application.
- Algorithms and tools achieve a wonderful process.
- Manage application themes, colors, and day and night modes easily and smoothly.
- Easy to Use.
- Systems for saving data in RAM, as well as in permanent memory and hard disk.
- not effecting on any overlay or outer context layer.
- Custom animations.


# Rules 
 - initialize your Hive directory or you can use hive_flutter dependency then call Hive.initFlutter()
 - initialize sharara app helper by calling await ShararaAppHelperInitializer.initialize() before running your app
 - if you want to use this app helper you need to call `FunctionHelpers.jumpTo(parsed context);` to Navigate new Screen
 - if you were using Sharara Context or you create Sharara Dialog using dialog controller `ShararaDialogController` then you could use `ShararaDialogController.cancelCurrentDialog();` to pop of the current using context
### Installation

Add the following dependencies in your pubspec.yaml file of your flutter project.

```flutter
    sharara_apps_building_helpers: <latest_version>
```
or you can use terminal command
```terminal command 
   flutter pub add sharara_apps_building_helpers
```

### How to use
- import the package `import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';`.
- import either hive_flutter or hive and if you do not have these packages you need to added them by using your terminal

```shell
flutter pub add hive 
flutter pub add hive_flutter
```

- initialize your Hive directory or you can use hive_flutter dependency then call Hive.initFlutter()
- insure initialize flutter widget binding `  WidgetsFlutterBinding.ensureInitialized();`
- initialize your app helper by invoke ShararaAppHelperInitializer.initialize `await ShararaAppHelperInitializer.initialize();` 
- now you can run your app calling runApp and parse ShararaAppHelper as root Widget `  runApp( ShararaAppHelper(builder:(BuildContext context)=>const FirstScreen()));`
```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';

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




```
