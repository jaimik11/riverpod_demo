
abstract class LocalRepository {

  // Future<dynamic> setSession(UserModel user);
  //
  // Future<UserModel?> getSession();

  Future<dynamic> setData(String key, dynamic value);

  Future<dynamic> getData(String key);

  void clearData();

  Future<dynamic> clearSpecificKey(String key);

  // Future<dynamic> clearLoginData();
}
