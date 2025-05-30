import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kindy/config/router.dart';
import 'package:kindy/core/theme/app_theme.dart';
import 'package:kindy/core/utils/screen_util.dart';

void main() {
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Kindy',
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        // Инициализируем ScreenUtil при запуске приложения
        ScreenUtil.init(context);

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
