import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kindy/core/theme/app_theme.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/features/auth/auth_injection.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:kindy/features/dashboard/presentation/pages/child_profile_page.dart';
import 'package:kindy/features/auth/presentation/pages/login_page.dart';
import 'package:kindy/features/auth/presentation/pages/role_selection_page.dart';
import 'package:kindy/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:kindy/features/auth/presentation/pages/parent_register_page.dart';
import 'package:kindy/features/auth/presentation/pages/teacher_register_step1_page.dart';
import 'package:kindy/features/auth/presentation/pages/teacher_register_step2_page.dart';
import 'package:kindy/features/auth/presentation/pages/manager_register_step1_page.dart';
import 'package:kindy/features/auth/presentation/pages/manager_register_step2_page.dart';
import 'package:kindy/features/auth/presentation/pages/manager_register_step3_page.dart';
import 'package:kindy/features/auth/presentation/pages/profile_page.dart';
import 'package:kindy/features/auth/presentation/pages/queue_status_page.dart';
import 'package:kindy/features/auth/presentation/pages/queue_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kindy/config/router.dart';

// teacher@test.com
// manager@test.com

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем предпочтительную ориентацию экрана
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Устанавливаем цвет системной навигационной панели и статус-бара
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Инициализация модуля аутентификации
  await AuthInjection.init();

  // Инициализация SharedPreferences для Riverpod
  final sharedPreferences = await SharedPreferences.getInstance();

  // Запуск приложения
  runApp(
    ProviderScope(
      overrides: [
        // Переопределяем провайдер SharedPreferences для Riverpod
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        // Включаем переопределения из модуля аутентификации
        ...AuthInjection.riverpodOverrides,
      ],
      child: const MyApp(),
    ),
  );

  print('Приложение запущено, навигация инициализирована');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        // Используем провайдеры из модуля аутентификации
        ...AuthInjection.providers,
      ],
      child: MaterialApp.router(
        title: 'Kindy',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) {
          // Инициализируем ScreenUtil при запуске приложения
          ScreenUtil.init(context);

          // Добавляем отладочный вывод для навигации
          print('MyApp: Построение интерфейса с текущим роутером');

          // Получаем текущее состояние авторизации из провайдера
          final authController = provider.Provider.of<AuthController>(
            context,
            listen: false,
          );

          print(
            'MyApp: Текущее состояние авторизации: ${authController.state}',
          );
          if (authController.userDetails != null) {
            print(
              'MyApp: Роль текущего пользователя: ${authController.userDetails?.role}',
            );
          }

          // Добавляем обработку для адаптивности UI
          return MediaQuery(
            // Устанавливаем textScaleFactor для предотвращения слишком большого текста
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
              ),
            ),
            child: _ResponsiveWrapper(child: child!),
          );
        },
      ),
    );
  }
}

/// Виджет-обертка для адаптивности
class _ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const _ResponsiveWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    // Определяем ориентацию устройства
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Устанавливаем максимальную ширину контента для больших экранов
    final maxWidth = ScreenUtil.isLargeScreen() ? 1200.0 : double.infinity;

    // В альбомной ориентации на мобильных устройствах контент может выглядеть лучше
    // если ограничить его ширину
    final phoneMaxWidth =
        isLandscape && ScreenUtil.isPhone() ? 700.0 : double.infinity;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil.isLargeScreen() ? maxWidth : phoneMaxWidth,
        ),
        child: child,
      ),
    );
  }
}
