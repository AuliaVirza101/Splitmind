import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/expense/presentation/pages/add_expense_page.dart';
import '../features/group/presentation/pages/group_detail_page.dart';
import '../features/group/presentation/pages/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/group-detail',
      name: 'group-detail',
      builder: (context, state) => const GroupDetailPage(),
    ),
    GoRoute(
      path: '/add-expense',
      name: 'add-expense',
      builder: (context, state) => const AddExpensePage(),
    ),
  ],
);
