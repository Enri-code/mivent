extension StringExt on String {
  static final trailingZeroFilter = RegExp(r"([.]*0+)(?!.*\d)");

  String get trimmedTrailingZeros => replaceAll(trailingZeroFilter, '');

  String ellipsed(int max) {
    if (length > max) return '${substring(0, max - 3).trimRight()}...';
    return this;
  }
}
