import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/transactions/domain/entities/customer.dart';

class CustomerModel extends CustomerData {
  CustomerModel.fromUserData(UserData user)
      : super(
          email: user.email,
          name: user.displayName,
          phoneNumber: user.phoneNumber,
        );
}
