import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/features/transactions/domain/entities/customer.dart';
import 'package:mivent/features/transactions/domain/entities/pay_data.dart';

abstract class IPaymentProvider {
  IPaymentProvider();
  BuildContext get navContext => _navContext!;
  BuildContext? _navContext;

  Future<Either<Failure?, TransactionResult>> openPaymentDialog(
      num amount, String txRef,
      [CustomerData? customer]);

  Future<Either<Failure?, TransactionResult>> confirmPaymentInServer(
      String txRef);

  void setNavContext(BuildContext context) => _navContext = context;
}
