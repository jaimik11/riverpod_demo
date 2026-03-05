
import 'dart:convert';

import 'package:c2c/constants/app_constants.dart';
import 'package:hive/hive.dart';


import '../../../../constants/storage_constants.dart';
import 'local_repository.dart';

class LocalRepositoryImpl extends LocalRepository {
  @override
  Future setData(String key, value) async {
    var box = Hive.box(StorageConstants.boxName);
    box.put(key, value);
  }

  @override
  Future getData(String key) async {
    var box = Hive.box(StorageConstants.boxName);
    return box.get(key);
  }

  @override
  Future clearSpecificKey(String key) async {
    var box = Hive.box(StorageConstants.boxName);
    return box.delete(key);
  }

  @override
  void clearData() {
    clearSpecificKey(StorageConstants.token);
    clearSpecificKey(StorageConstants.userModel);
    // AppConstants.socketService?.disconnectSocket();
  }

  // @override
  // Future<void> clearLoginData() async {
  //   var box = Hive.box<UserModel>(StorageConstants.userSession);
  //   await box.clear(); // This will remove all keys and values in the box
  // }



  // @override
  // Future setSession(UserModel user) async{
  //   setData(StorageConstants.userModel, jsonEncode(user.toJson()));
  //   // Box<UserModel>  obj = await Hive.openBox<UserModel>(StorageConstants.userSession);
  //   // await obj.add(user);
  // }
  //
  // @override
  // Future<UserModel?> getSession() async{
  //   var model =  await getData(StorageConstants.userModel);
  //   //print("model----- $model");
  //   if(model == null) return null;
  //   UserModel userModel = UserModel.fromJson(jsonDecode(model));
  //   return userModel;
  //   // Box<UserModel>  data = await Hive.openBox<UserModel>(StorageConstants.userSession);
  //   // return data.values.firstOrNull;
  // }



}
