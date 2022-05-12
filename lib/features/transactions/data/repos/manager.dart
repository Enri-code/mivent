import 'package:mivent/features/transactions/data/repos/charge_provider.dart';
import 'package:mivent/features/transactions/data/repos/payment.dart';
import 'package:mivent/features/transactions/domain/repos/manager.dart';
import 'package:nanoid/nanoid.dart';

class PurchaseManager extends IPurchaseManager {
  PurchaseManager();
  @override
  final charger = DefaultChargeProvider();
  @override
  final payer = FWPaymentProvider();

  @override
  String generateRefId([String refPrefix = '']) => '$refPrefix-${nanoid(10)}';
}
