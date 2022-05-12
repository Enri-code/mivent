
abstract class UserType {
  const UserType();
}

class HostUser extends UserType {
  const HostUser();
  @override
  String toString() => 'host';
}

class AttenderUser extends UserType {
  const AttenderUser();
  @override
  String toString() => 'attender';
}
