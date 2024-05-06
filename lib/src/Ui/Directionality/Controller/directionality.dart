import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharara_apps_building_helpers/src/Cache/Systems/Directionality/d_cache_manager.dart';
import 'package:sharara_apps_building_helpers/src/Constants/boxes_names.dart';

class ShararaDirectionalityController {
  ShararaDirectionalityController._(){
    cacheManager = DirectionalityCacheManager(boxName:ConstantsBoxesNames.defaultDirectionalityCacheManager);
    _init();
  }
  late final DirectionalityCacheManager cacheManager;
  static final ShararaDirectionalityController instance = ShararaDirectionalityController._();
  final ValueNotifier<TextDirection?> directionalityNotifier = ValueNotifier(null);
  static switchDirection(){
    if(instance.directionalityNotifier.value == TextDirection.ltr){
      instance.changeDirectionTo(TextDirection.rtl);
    }else{
      instance.changeDirectionTo(TextDirection.ltr);
    }
  }
  changeDirectionTo(final TextDirection direction){
    if(directionalityNotifier.value==direction)return;
    directionalityNotifier.value = direction;
  }
}

extension DirectionalityWorker on ShararaDirectionalityController {
  _init()async{
    _setupListeners();
    directionalityNotifier.value = cachedDirectionality;
  }

  TextDirection get cachedDirectionality {
    final String cachedDString = cacheManager.get().toString();
    for(final TextDirection direction in TextDirection.values){
      if(direction.name==cachedDString)return direction;
    }
    return TextDirection.ltr;
  }
  _setupListeners(){
    directionalityNotifier.addListener(_directionalityListener);
  }
  _directionalityListener()async{
    final TextDirection? directionality = directionalityNotifier.value;
    if(directionality==null)return;
    await _cache(directionality);
  }
  Future<void>_cache(final TextDirection direction)async{
    await cacheManager.insert(direction.name);
  }
}

