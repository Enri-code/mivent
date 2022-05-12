class CustomerData {
  const CustomerData({
    required this.email,
    required this.name,
    this.phoneNumber,
  });

  final String email, name;
  final String? phoneNumber;
}
