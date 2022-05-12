import 'package:intl/intl.dart';

class Constants {
  static const maxTicketUnitsPerPurchase = 5, maxUnitsPerTicket = 10;
  static final currencyFormatter =
      NumberFormat.simpleCurrency(locale: 'en_NG', name: 'NGN');

  static final currencySymbol = currencyFormatter.currencySymbol;

  //TODO use filter when creating ticket prices
  static final currencyNumberFilter =
      RegExp(r"^(?=\D*(?:\d\D*){1,10}$)\d+(?:\.\d{1,1})?$");

  static final phoneNumberFilter = RegExp(
      r"/^(?:(?:(?:\+?234(?:\h1)?|01)\h*)?(?:\(\d{3}\)|\d{3})|\d{4})(?:\W*\d{3})?\W*\d{4}$/gm");

  static final emailFilter = RegExp(
      r"^[-!#$%&'*+/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+/0-9=?A-Z^_a-z{|}~])*@[a-zA-Z](-?[a-zA-Z0-9])*(\.[a-zA-Z](-?[a-zA-Z0-9])*)+$");
}
