import 'package:f1/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:f1/auth/auth_notifier.dart';
import 'package:f1/widgets/login.dart';

GoRouter configureRouter(AuthNotifier authNotifier) {
  return GoRouter(
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isAuthenticated;
      final isLoggingIn = state.uri.toString() == '/login';

      // Chưa đăng nhập và không ở trang login -> redirect đến login
      if (!isLoggedIn && !isLoggingIn) return '/login';

      // Đã đăng nhập và đang ở trang login -> redirect về dashboard
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginForm()),
      ),
      GoRoute(
        path: '/',
        pageBuilder:
            (context, state) => const MaterialPage(child: DashboardPage()),
      ),
    ],
  );
}
