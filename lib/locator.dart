
import 'package:call_recorder/storage/prefs_storage.dart';
import 'package:call_recorder/storage/storage.dart';
import 'package:call_recorder/user/user_api.dart';
import 'package:call_recorder/user/user_repository.dart';
import 'package:get_it/get_it.dart';

final _locator = GetIt.instance;

IUserRepository get userRepository => _locator<IUserRepository>();
IStorage get storage => _locator<IStorage>();

abstract class DependencyInjectionEnvironment {
  static Future<void> setup() async {
    _locator.registerLazySingleton<IUserRepository>(() => UserApi());
    _locator.registerLazySingleton<IStorage>(() => PrefStorage());
  }
}
