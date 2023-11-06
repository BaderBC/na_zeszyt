import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:na_zeszyt/pages/allSheets.dart';
import 'package:na_zeszyt/pages/sheet.dart';

void main() {
  runApp(const RouterWidget());
}

class RouterWidget extends StatelessWidget {
  const RouterWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Na Zeszyt',
      routerConfig: _router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/sheet/dom',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AllSheetsPage(),
    ),
    GoRoute(
      path: '/sheet/:sheetName',
      builder: (context, state) => SheetPage(
        sheetName: state.pathParameters['sheetName']!,
      ),
    ),
  ],
);
