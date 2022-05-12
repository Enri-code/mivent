import 'package:mivent/features/transactions/domain/repos/charge_provider.dart';

// TODO: implement remote charge data
class DefaultChargeProvider extends IChargesProvider {
  @override
  final double additionalCharge = 50;
  @override
  final double chargeMultiplier = 1.5;
}
