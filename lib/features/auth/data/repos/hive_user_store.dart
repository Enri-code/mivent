import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/features/auth/data/models/user_type_model.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';

class HiveUserStore extends IUserStore {
  Box? _box;

  @override
  Future init() async => _box ??= await Hive.openBox('user');

  @override
  bool get isSignedIn => _box!.get('signed_in', defaultValue: false);

  @override
  set isSignedIn(bool val) => _box!.put('signed_in', val);

  @override
  UserData? get user => _box!.get('user_data', defaultValue: null) as UserData?;

  @override
  UserType get type => UserTypeModel.fromString(
      _box!.get('user_type', defaultValue: const AttenderUser().toString()));

  @override
  saveType(UserType type) => _box!.put('user_type', type.toString());

  @override
  saveUser(UserData user) => _box!.put('user_data', user);

  @override
  Future delete() => _box!.deleteFromDisk();
}
