


import 'package:sharara_apps_building_helpers/src/Cache/BoxCache/basic.dart';
import 'package:hive/hive.dart';
class LazyCache extends BasicCache{
  final LazyBox box;
  LazyCache({required super.boxName,super.boxKey,super.settings}):
        box = Hive.lazyBox(boxName);

  /// retrieve data from cached box
  Future<dynamic> get({final String? key,dynamic defaultValue})async{
    final data = await box.get(key ?? boxKey,defaultValue:defaultValue);
    return exportData(data);
  }

  /// use this method to save or cache the wanted data
  Future<void> insert<T>(T data)async{
    return await box.put(boxKey,super.hashData(data));
  }

  /// use this method to clear the data from cached box
  Future<int> clear()=> box.clear();
}

