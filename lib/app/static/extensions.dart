extension NullableStringUtils on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty || this!.trim().isEmpty;
  bool get isNotNullOrNotEmpty => this != null && this!.isNotEmpty && this!.trim().isNotEmpty;
}

extension StringUtils on String {
  bool get isNullOrEmpty => isEmpty || trim().isEmpty;
  bool get isNotNullOrNotEmpty => isNotEmpty && trim().isNotEmpty;
}