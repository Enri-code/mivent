class Failure {
  const Failure({this.message, this.cause});
  final String? message;
  final FailureCause? cause;
}

abstract class FailureCause {
  const FailureCause();
}
