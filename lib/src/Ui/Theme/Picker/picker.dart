
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/sharara_apps_building_helpers.dart';
import 'package:sharara_apps_building_helpers/ui.dart';
class ShararaThemePicker extends StatelessWidget {
  const ShararaThemePicker({super.key,
   this.title = "اختر الثيم المناسب",
   this.directionHint = "تغيير اتجاه وماحذاة التطبيق ",
   this.darkModeName = "الوضع الليلي",
   this.onThemeUpdated,
  });
  final String title,directionHint,darkModeName;
  final Function()? onThemeUpdated;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title:Text(title),
      centerTitle:true,
      ),

      body:ListView(
        children: [

          ValueListenableBuilder(
            valueListenable:ShararaThemeController.instance.themeNotifier,
            builder:(BuildContext context,final ShararaTheme? chosenTheme,_){
              return ListView(
                shrinkWrap:true,
                primary:false,
                children: [

                  InkWell(
                    onTap:()=>ShararaDirectionalityController.switchDirection(),
                    child: ValueListenableBuilder(valueListenable: ShararaDirectionalityController.instance.directionalityNotifier,
                      builder:(BuildContext context,final TextDirection? direction,_){
                        return  Card(
                          child: Padding(
                            padding:const EdgeInsets.all(10),
                            child:Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  directionHint,
                                  style:TextStyle(
                                      color:ShararaThemeController.instance
                                          .themeNotifier.value?.mainColor
                                  ),
                                ),

                               const Icon(Icons.arrow_forward_ios_outlined)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Card(
                    child:Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Text(darkModeName),
                          ShararaSwitchIcon(
                          value:ShararaThemeController
                              .instance.brightness==Brightness.dark,
                          onChanged:(_)=>
                               ShararaThemeController.instance
                              .switchBrightness())
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height:20,),
                  
                  Text(title,textAlign:TextAlign.center,),

                  GridView.extent(
                   maxCrossAxisExtent:180,
                   shrinkWrap:true,
                   primary:false,
                   childAspectRatio:1,
                   children: [
                    ...ShararaThemeController
                     .instance
                     .themes
                     .entries
                     .map((e) {
                       final ShararaTheme theme = e.value;
                       return InkWell(
                         radius:15,
                         onTap:(){
                           ShararaAppController.instance
                                .themeController.changeTheme(
                              theme ,
                              onThemeUpdated:onThemeUpdated
                            );
                           },
                         child: Card(
                           child:Padding(
                             padding:const EdgeInsets.all(8.0),
                             child:Column(
                               mainAxisAlignment:MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   height:10,
                                   color:theme.mainColor,
                                  ),
                                 Text(theme.themeName),
                                 if(theme.themeId == chosenTheme?.themeId)
                                   Icon(
                                     Icons.check_circle,
                                     color:theme.mainColor,
                                   )
                               ],
                             ),
                           ),
                         ),
                       );
                    }
                       )
                   ],
                  ),

                  const SizedBox(height:50,)
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
