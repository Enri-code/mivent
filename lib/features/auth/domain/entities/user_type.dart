import 'package:equatable/equatable.dart';

abstract class UserType extends Equatable {
  const UserType();

  factory UserType.fromString(String value) {
    switch (value) {
      case 'host':
        return const HostUser();
      default:
        return const AttenderUser();
    }
  }

  @override
  List<Object?> get props => [];
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
