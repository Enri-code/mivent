import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/features/transactions/domain/entities/pay_data.dart';
import 'package:mivent/features/transactions/domain/repos/charge_provider.dart';
import 'package:mivent/features/transactions/domain/repos/payment.dart';

abstract class IPurchaseManager {
  IPaymentProvider get payer;
  IChargesProvider get charger;

  Future<Either<Failure?, TransactionResult>> userPay(double amount,
      {String refPrefix = ''}) {
    var total = charger.getGrossPrice(amount);
    return payer.openPaymentDialog(total, generateRefId(refPrefix));
  }

  String generateRefId([String refPrefix = '']);

  setNavContext(BuildContext context) {
    payer.setNavContext(context);
  }
}
