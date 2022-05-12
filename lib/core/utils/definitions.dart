enum OperationStatus {
  initial,
  success,
  minorFail,
  majorFail,
  minorLoading,
  majorLoading
}

typedef Reader = T Function<T>();
