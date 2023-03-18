

import 'package:call_recorder/model/local_user.dart';

abstract class IStorage {
  Future<void> init();

  Future<bool> setUser(LocalUser user);
  LocalUser? get user;
  Future<void> setUserToken(String user);


  Future<void> allClear();
  Future<bool> removeUser();
}
