import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mivent/features/events/presentation/screens/event_details.dart';
import 'package:mivent/features/events/presentation/screens/event_tickets.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/auth/presentation/screens/onboard.dart';
import 'package:mivent/features/auth/presentation/screens/register.dart';
import 'package:mivent/features/auth/presentation/screens/sign_in.dart';
import 'package:mivent/features/tickets/presentation/screens/ticket_cart.dart';
import 'package:mivent/features/tickets/presentation/screens/ticket_view.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/screens/image_full_view.dart';

abstract class ThemeSettings {
  static const routes = {
    OnboardScreen.route: OnboardScreen(),
    RegisterScreen.route: RegisterScreen(),
    SignInScreen.route: SignInScreen(),
    MenuScreen.route: MenuScreen(),
    EventDetailsScreen.route: EventDetailsScreen(),
    EventTicketsScreen.route: EventTicketsScreen(),
    ImageFullView.route: ImageFullView(),
    TicketFullView.route: ImageFullView(),
    TicketCartScreen.route: TicketCartScreen(),
  };

  static final myTextTheme =
      Typography.blackRedmond.apply(fontFamily: 'Lucette').copyWith(
            bodyText1: const TextStyle(fontSize: 16.5, height: 1.02),
            bodyText2: const TextStyle(fontSize: 14.5, height: 1.02),
            button: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              wordSpacing: 1,
            ),
          );

  static final myTheme = ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: ColorPalette.primary,
    ),
    textTheme: myTextTheme,
  ).copyWith(
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      //primary: ColorPalette.orange,
      minimumSize: const Size(300, 54),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: const Size(300, 54),
      padding: const EdgeInsets.all(12),
      side: const BorderSide(width: 2, color: ColorPalette.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    )),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 21),
    ),
  );
}
