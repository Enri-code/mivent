import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwave_standard/flutterwave.dart';

import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/transactions/_private_keys.dart';
import 'package:mivent/features/transactions/data/models/customer.dart';
import 'package:mivent/features/transactions/domain/entities/customer.dart';
import 'package:mivent/features/transactions/domain/entities/pay_data.dart';
import 'package:mivent/features/transactions/domain/repos/payment.dart';

import 'package:mivent/core/error/failure.dart';

class FWPaymentProvider extends IPaymentProvider {
  FWPaymentProvider([this.currency = 'NGN']);

  final String currency;

  bool _crossCheckData(ChargeResponse data, String txRef) =>
      data.txRef == txRef;

  @override
  openPaymentDialog(num amount, String txRef, [CustomerData? customer]) async {
    if (customer == null) {
      var user = navContext.read<AuthBloc>().state.user;
      if (user == null) return const Left(null);
      customer = CustomerModel.fromUserData(user);
    }
    final style = FlutterwaveStyle(
        appBarText: "My Standard Blue",
        buttonColor: const Color(0xffd0ebff),
        appBarIcon: const Icon(Icons.message, color: Color(0xffd0ebff)),
        buttonTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        appBarColor: const Color(0xffd0ebff),
        dialogCancelTextStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 18,
        ),
        dialogContinueTextStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ));

    final Flutterwave flutterwave = Flutterwave(
      context: navContext,
      txRef: txRef,
      customer: Customer(
        email: customer.email,
        name: customer.name,
        phoneNumber: customer.phoneNumber ?? '+234',
      ),
      amount: amount.toString(),
      publicKey: publicKey,
      currency: currency,
      style: style,
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: true,
      redirectUrl: null,
    );
    try {
      final ChargeResponse? response = await flutterwave.charge();
      print({
        'status': response?.status,
        'trx id': response?.transactionId,
        'tx ref': response?.txRef,
      });
      if (response == null) return const Left(null);
      if (response.success) {
        print(response.toJson());
        if (_crossCheckData(response, txRef)) {
          ///TODO: Use in release and upload FB functions
          /* return (await confirmPaymentStatus(txRef)).fold(
            (l) => Left(l),
            (r) => r ? const Right(true) : const Left(Failure()),
          ); */
          return Right(TransactionResult(txRef));
        }
      }
      return const Left(Failure(message: 'The payment was unsuccessful'));
    } catch (e) {
      print(e);
      return const Left(Failure(message: 'The payment could not be completed'));
    }
  }

  @override
  confirmPaymentInServer(String txRef) async {
    /* var res = await FirebaseFunctions.instance
        .httpsCallable('verifyPayment')
        .call({'transaction_id': txRef});
    switch (res.data) {
      case 'verified':
        return const Right(true);
      case 'wrong-currency':
        return const Left(
            Failure(message: 'We are not accepting payments in this currency'));
      case 'incorrect-amount':
        return const Left(
            Failure(message: "You didn't supply the right amount"));
      default:
        return const Right(false);
    } */
    return const Left(null);
  }
}
