import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mivent/features/events/presentation/screens/event_details.dart';
import 'package:mivent/features/events/presentation/screens/event_tickets.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/onboard/presentation/screens/onboard.dart';
import 'package:mivent/features/onboard/presentation/screens/register.dart';
import 'package:mivent/features/onboard/presentation/screens/sign_in.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/screens/image_full_view.dart';

abstract class ThemeSettings {
  static const appName = 'Mivent';

  static const routes = {
    OnboardScreen.routeName: OnboardScreen(),
    RegisterScreen.routeName: RegisterScreen(),
    SignInScreen.routeName: SignInScreen(),
    MenuScreen.routeName: MenuScreen(),
    EventDetailsScreen.routeName: EventDetailsScreen(),
    EventTicketsScreen.routeName: EventTicketsScreen(),
    ImageFullView.routeName: ImageFullView(),
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
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      //primary: ColorPalette.orange,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minimumSize: const Size(300, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: const Size(300, 60),
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
