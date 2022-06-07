import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/demo_localization.dart';
import 'localization/language_constants.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ea_frontend/routes/auth_service.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:developer';
import 'package:ea_frontend/views/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp() : super();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider notifier, child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            if (this._locale == null) {
              setLocale(Locale('es'));
            }
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "BookHub",
                theme: notifier.isDarkMode
                    ? MyThemes.darkTheme
                    : MyThemes.lightTheme,
                locale: _locale,
                supportedLocales: const [
                  Locale("en", ""),
                  Locale("es", ""),
                  Locale("ca", ""),
                ],
                localizationsDelegates: const [
                  DemoLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                home: AnimatedSplashScreen.withScreenFunction(
                    duration: 3000,
                    splash: "public/logosplash.png",
                    splashIconSize: 500,
                    screenFunction: () async {
                      var storage = LocalStorage('BookHub');
                      await storage.ready;

                      var token = LocalStorage('BookHub').getItem('token');
                      if (token == null) {
                        return const LoginPage();
                      }
                      var response = await AuthService.verifyToken(token);
                      if (response == '200') {
                        log('Load home scaffold');
                        return const HomeScaffold();
                      }
                      return const LoginPage();
                    },
                    splashTransition: SplashTransition.fadeTransition,
                    pageTransitionType: PageTransitionType.fade,
                    backgroundColor: Colors.blueGrey));
          },
        ),
      );
}
