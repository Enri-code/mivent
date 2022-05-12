import 'package:hive/hive.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';

class UserAdapter extends TypeAdapter<UserData> {
  @override
  final typeId = 4;

  @override
  UserData read(BinaryReader reader) => UserData(
        id: reader.read(),
        displayName: reader.read(),
        email: reader.read(),
        imageUrl: reader.read(),
        phoneNumber: reader.read(),
      );

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..write(obj.id)
      ..write(obj.displayName)
      ..write(obj.email)
      ..write(obj.imageUrl)
      ..write(obj.phoneNumber);
  }
}
