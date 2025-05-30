import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kindy/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:kindy/features/auth/presentation/pages/login_page.dart';
import 'package:kindy/features/auth/presentation/pages/queue_page.dart';
import 'package:kindy/features/auth/presentation/pages/queue_status_page.dart';
import 'package:kindy/features/auth/presentation/pages/register_page.dart';
import 'package:kindy/features/auth/presentation/pages/role_selection_page.dart';
import 'package:kindy/features/auth/presentation/pages/parent_register_page.dart';
import 'package:kindy/features/auth/presentation/pages/teacher_register_step1_page.dart';
import 'package:kindy/features/auth/presentation/pages/teacher_register_step2_page.dart';
import 'package:kindy/features/auth/presentation/pages/manager_register_step1_page.dart';
import 'package:kindy/features/auth/presentation/pages/manager_register_step2_page.dart';
import 'package:kindy/features/auth/presentation/pages/manager_register_step3_page.dart';
import 'package:kindy/features/dashboard/presentation/pages/child_profile_page.dart';
import 'package:kindy/features/dashboard/presentation/pages/dashboard_page.dart';

// Импортируй другие страницы по мере их создания

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const KindergartenLoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: '/register/parent',
      builder: (context, state) => const ParentRegisterPage(),
    ),
    GoRoute(
      path: '/register/teacher/step1',
      builder: (context, state) => const TeacherRegisterStep1Page(),
    ),
    GoRoute(
      path: '/register/teacher/step2',
      builder: (context, state) {
        final previousData = state.extra as Map<String, dynamic>?;
        return TeacherRegisterStep2Page(previousData: previousData);
      },
    ),
    GoRoute(
      path: '/register/manager/step1',
      builder: (context, state) => const ManagerRegisterStep1Page(),
    ),
    GoRoute(
      path: '/register/manager/step2',
      builder: (context, state) {
        final previousData = state.extra as Map<String, dynamic>?;
        return ManagerRegisterStep2Page(previousData: previousData);
      },
    ),
    GoRoute(
      path: '/register/manager/step3',
      builder: (context, state) {
        final previousData = state.extra as Map<String, dynamic>?;
        return ManagerRegisterStep3Page(previousData: previousData);
      },
    ),
    GoRoute(
      path: '/register/old',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(path: '/queue', builder: (context, state) => const QueuePage()),
    GoRoute(
      path: '/queue-status',
      builder: (context, state) => const QueueStatusPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/child-profile',
      builder: (context, state) {
        final Map<String, dynamic> childData =
            state.extra as Map<String, dynamic>;
        return ChildProfilePage(childData: childData);
      },
    ),
    // Добавляй новые маршруты здесь
  ],
);
