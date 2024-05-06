


import 'package:sharara_apps_building_helpers/src/Cache/BoxCache/basic.dart';
import 'package:hive/hive.dart';
class NormalCache extends BasicCache{
  final Box box;
  NormalCache({required super.boxName,super.boxKey,super.settings}):
  box = Hive.box(boxName);

  /// retrieve data from cached box
  dynamic get({final String? key,dynamic defaultValue}) {
    return exportData(box.get( key ?? boxKey,defaultValue:defaultValue));
  }

  /// use this method to save or cache the wanted data
  Future<void> insert<T>(T data,{final String? key})async{
    return await box.put( key ?? boxKey,super.hashData(data));
  }

  /// use this method to clear the data from cached box
  Future<int> clear()=> box.clear();
}

