//
// main.dart
// appflix
//
// Author: wess (me@wess.io)
// Created: 12/29/2021
//
// Copywrite (c) 2022 Wess.io
//

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:netflix_clone/providers/account.dart';
import 'package:netflix_clone/providers/entry.dart';
import 'package:netflix_clone/providers/watchlist.dart';
import 'package:netflix_clone/screens/navigation.dart';
import 'package:netflix_clone/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AccountProvider()),
      ChangeNotifierProvider(create: (context) => EntryProvider()),
      ChangeNotifierProvider(create: (context) => WatchListProvider()),
    ],
    child: const Main(),
  ));
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterNativeSplash.remove();
    }
    var f = context.watch<AccountProvider>().isValid();
    return MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        title: 'Appflix',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: f,
          builder: (context, snapshot) =>
              context.watch<AccountProvider>().session == null
                  ? const OnboardingScreen()
                  : const NavScreen(),
        ));
  }
}
