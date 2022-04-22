import 'package:equatable/equatable.dart';

abstract class UserType extends Equatable {
  const UserType();
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
