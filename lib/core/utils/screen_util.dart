import 'package:flutter/material.dart';

class ScreenUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;
  static late double textScaleFactor;
  static late double pixelRatio;
  static late double statusBarHeight;
  static late double bottomBarHeight;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeAreaTop;
  static late double safeAreaBottom;
  static late double safeAreaWidth;
  static late double safeAreaHeight;

  // Базовые размеры дизайна в пикселях
  static const double designWidth = 375.0;
  static const double designHeight = 812.0;

  // Инициализируем утилиту с контекстом
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    textScaleFactor = _mediaQueryData.textScaleFactor;
    pixelRatio = _mediaQueryData.devicePixelRatio;

    // Получаем размеры системных областей
    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;

    // Расчет размеров безопасной зоны
    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeAreaTop = _mediaQueryData.padding.top;
    safeAreaBottom = _mediaQueryData.padding.bottom;
    safeAreaWidth = screenWidth - safeAreaHorizontal;
    safeAreaHeight = screenHeight - safeAreaVertical;

    // Определяем базовый размер для контрольной точки
    defaultSize =
        orientation == Orientation.landscape
            ? screenHeight * 0.024
            : screenWidth * 0.024;
  }

  // Получить пропорциональную высоту в зависимости от размера экрана
  static double getProportionateScreenHeight(double inputHeight) {
    return (inputHeight / designHeight) * screenHeight;
  }

  // Получить пропорциональную ширину в зависимости от размера экрана
  static double getProportionateScreenWidth(double inputWidth) {
    return (inputWidth / designWidth) * screenWidth;
  }

  // Адаптивный размер, рассчитанный для текущего экрана
  static double adaptive(double size) {
    return size * min(screenWidth / designWidth, screenHeight / designHeight);
  }

  // Получить адаптивный размер шрифта
  static double getFontSize(double fontSize) {
    return getProportionateScreenWidth(fontSize);
  }

  // Получить размер в зависимости от соотношения сторон
  static double getScaledSize(double size) {
    final aspectRatio = screenWidth / screenHeight;
    return size * min(1.0, aspectRatio * 1.5);
  }

  // Проверка размера экрана
  static bool isSmallScreen() => screenWidth < 600;
  static bool isMediumScreen() => screenWidth >= 600 && screenWidth < 900;
  static bool isLargeScreen() => screenWidth >= 900;
  static bool isLandscape() => orientation == Orientation.landscape;
  static bool isPortrait() => orientation == Orientation.portrait;
  static bool isTablet() =>
      pixelRatio < 2 && (screenWidth >= 600 || screenHeight >= 600);
  static bool isPhone() => !isTablet();

  // Адаптивное значение - возвращает разные значения в зависимости от размера экрана
  static T adaptiveValue<T>({
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isLargeScreen()) return desktop;
    if (isMediumScreen()) return tablet;
    return mobile;
  }

  // Утилита для выбора минимального значения
  static double min(double a, double b) {
    return a < b ? a : b;
  }
}
