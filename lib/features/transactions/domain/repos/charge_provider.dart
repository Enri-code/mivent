abstract class IChargesProvider {
  double get chargeMultiplier;
  double get additionalCharge;

  double getGrossPrice(double price) =>
      price * chargeMultiplier + additionalCharge;
  //init();
}
