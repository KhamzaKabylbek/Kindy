import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kindy/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:kindy/features/auth/presentation/pages/login_page.dart';
import 'package:kindy/features/auth/presentation/pages/profile_page.dart';
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
import 'package:kindy/features/teacher/presentation/pages/teacher_dashboard_page.dart';
import 'package:kindy/features/manager/presentation/pages/manager_dashboard_page.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/features/auth/domain/entities/auth_entities.dart';
import 'package:provider/provider.dart';

// Импортируй другие страницы по мере их создания

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    // Корневой маршрут с проверкой аутентификации
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );

        if (authController.state == AuthState.authenticated) {
          final userDetails = authController.userDetails;
          final userRole = userDetails?.role;

          print(
            'Root Route: Перенаправление авторизованного пользователя. Роль: $userRole, данные: ${userDetails?.toJson()}',
          );

          if (userRole != null && userRole.toUpperCase() == 'TEACHER') {
            print('Root Route: Перенаправление на /teacher/dashboard');
            return '/teacher/dashboard';
          } else if (userRole != null && userRole.toUpperCase() == 'MANAGER') {
            print('Root Route: Перенаправление на /manager/dashboard');
            return '/manager/dashboard';
          }

          print('Root Route: Перенаправление на /parent/dashboard');
          return '/parent/dashboard';
        }

        print(
          'Root Route: Перенаправление неавторизованного пользователя на /login',
        );
        return '/login';
      },
    ),
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
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );
        if (authController.state != AuthState.authenticated) {
          return '/login';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/queue',
      builder: (context, state) => const QueuePage(),
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );
        if (authController.state != AuthState.authenticated) {
          return '/login';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/queue-status',
      builder: (context, state) => const QueueStatusPage(),
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );
        if (authController.state != AuthState.authenticated) {
          return '/login';
        }
        return null;
      },
    ),

    // Теперь у нас раздельные маршруты для родителя и воспитателя
    GoRoute(
      path: '/parent/dashboard',
      builder: (context, state) => const DashboardPage(),
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );

        if (authController.state != AuthState.authenticated) {
          print(
            'Parent Dashboard Redirect: Перенаправление на /login (не авторизован)',
          );
          return '/login';
        }

        final userDetails = authController.userDetails;
        final userRole = userDetails?.role;

        print(
          'Parent Dashboard Redirect: Проверка роли пользователя: $userRole',
        );

        if (userRole != null && userRole.toUpperCase() == 'TEACHER') {
          print(
            'Parent Dashboard Redirect: Перенаправление на /teacher/dashboard (роль учителя)',
          );
          return '/teacher/dashboard';
        } else if (userRole != null && userRole.toUpperCase() == 'MANAGER') {
          print(
            'Parent Dashboard Redirect: Перенаправление на /manager/dashboard (роль менеджера)',
          );
          return '/manager/dashboard';
        }

        print('Parent Dashboard Redirect: Оставляем на /parent/dashboard');
        return null;
      },
    ),

    GoRoute(
      path: '/teacher/dashboard',
      builder: (context, state) {
        print(
          'Teacher Dashboard Builder: Построение страницы TeacherDashboardPage',
        );
        return const TeacherDashboardPage();
      },
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );

        if (authController.state != AuthState.authenticated) {
          print(
            'Teacher Dashboard Redirect: Перенаправление на /login (не авторизован)',
          );
          return '/login';
        }

        final userDetails = authController.userDetails;
        final userRole = userDetails?.role;

        print(
          'Teacher Dashboard Redirect: Проверка роли пользователя: $userRole',
        );

        if (userRole == null || userRole.toUpperCase() != 'TEACHER') {
          print(
            'Teacher Dashboard Redirect: Перенаправление на /parent/dashboard (не роль учителя)',
          );
          return '/parent/dashboard';
        }

        print('Teacher Dashboard Redirect: Оставляем на /teacher/dashboard');
        return null;
      },
    ),

    // Поддерживаем старый маршрут для обратной совместимости
    GoRoute(
      path: '/dashboard',
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );

        if (authController.state != AuthState.authenticated) {
          print(
            'Dashboard Redirect: Перенаправление на /login (не авторизован)',
          );
          return '/login';
        }

        final userDetails = authController.userDetails;
        final userRole = userDetails?.role;

        print('Dashboard Redirect: Проверка роли пользователя: $userRole');

        if (userRole != null && userRole.toUpperCase() == 'TEACHER') {
          print(
            'Dashboard Redirect: Перенаправление на /teacher/dashboard (роль учителя)',
          );
          return '/teacher/dashboard';
        } else if (userRole != null && userRole.toUpperCase() == 'MANAGER') {
          print(
            'Dashboard Redirect: Перенаправление на /manager/dashboard (роль менеджера)',
          );
          return '/manager/dashboard';
        }

        print(
          'Dashboard Redirect: Перенаправление на /parent/dashboard (роль родителя)',
        );
        return '/parent/dashboard';
      },
    ),

    GoRoute(
      path: '/child-profile',
      builder: (context, state) {
        final Map<String, dynamic> childData =
            state.extra as Map<String, dynamic>;
        return ChildProfilePage(childData: childData);
      },
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );
        if (authController.state != AuthState.authenticated) {
          return '/login';
        }
        return null;
      },
    ),

    GoRoute(
      path: '/manager/dashboard',
      builder: (context, state) {
        print(
          'Manager Dashboard Builder: Построение страницы ManagerDashboardPage',
        );
        return const ManagerDashboardPage();
      },
      redirect: (context, state) {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );

        if (authController.state != AuthState.authenticated) {
          print(
            'Manager Dashboard Redirect: Перенаправление на /login (не авторизован)',
          );
          return '/login';
        }

        final userDetails = authController.userDetails;
        final userRole = userDetails?.role;

        print(
          'Manager Dashboard Redirect: Проверка роли пользователя: $userRole',
        );

        if (userRole == null || userRole.toUpperCase() != 'MANAGER') {
          if (userRole != null && userRole.toUpperCase() == 'TEACHER') {
            print(
              'Manager Dashboard Redirect: Перенаправление на /teacher/dashboard (роль учителя)',
            );
            return '/teacher/dashboard';
          }

          print(
            'Manager Dashboard Redirect: Перенаправление на /parent/dashboard (не роль менеджера)',
          );
          return '/parent/dashboard';
        }

        print('Manager Dashboard Redirect: Оставляем на /manager/dashboard');
        return null;
      },
    ),
    // Добавляй новые маршруты здесь
  ],
);
