import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:na_zeszyt/pages/all_sheets.dart';
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
        colorScheme: const ColorScheme.light(),
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/sheet/dom',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => defaultTransitionPage(
        context,
        state,
        const AllSheetsPage(),
      ),
    ),
    GoRoute(
      path: '/sheet/:sheetName',
      pageBuilder: (context, state) => defaultTransitionPage(
        context,
        state,
        SheetPage(sheetName: state.pathParameters['sheetName']!),
      ),
    ),
  ],
);

Page defaultTransitionPage(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeIn).animate(animation),
        child: child,
      );
    },
  );
}
