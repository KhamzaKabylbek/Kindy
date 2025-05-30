import 'package:flutter/material.dart';
import 'package:kindy/core/utils/screen_util.dart';

class AppDimensions {
  // Padding and margin values
  static const double padding4 = 4.0;
  static const double padding8 = 8.0;
  static const double padding12 = 12.0;
  static const double padding16 = 16.0;
  static const double padding24 = 24.0;
  static const double padding32 = 32.0;
  static const double padding40 = 40.0;
  static const double padding48 = 48.0;

  // Border radius values
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius24 = 24.0;
  static const double radius32 = 32.0;

  // Button heights
  static const double buttonHeight = 50.0;
  static const double smallButtonHeight = 40.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  static const double iconSizeXXLarge = 64.0;
  static const double iconSizeHuge = 80.0;

  // Avatar sizes
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;
  static const double avatarSizeXXLarge = 128.0;

  // Card elevations
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;

  // Divider thickness
  static const double dividerThickness = 1.0;
  static const double thickDividerThickness = 2.0;

  // Spacings between items
  static const double spacingTiny = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // Коэффициенты масштабирования для разных размеров экрана
  static const double mobileFactor = 1.0;
  static const double tabletFactor = 1.25;
  static const double desktopFactor = 1.5;

  // Размеры экрана для разных устройств
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Контрольные точки для адаптивного дизайна
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Адаптивные методы для получения размеров в зависимости от экрана
  static double getAdaptivePadding(double size) {
    return ScreenUtil.adaptiveValue(
      mobile: size,
      tablet: size * tabletFactor,
      desktop: size * desktopFactor,
    );
  }

  static double getAdaptiveRadius(double radius) {
    return ScreenUtil.adaptiveValue(
      mobile: radius,
      tablet: radius * tabletFactor,
      desktop: radius * desktopFactor,
    );
  }

  static double getAdaptiveIconSize(double size) {
    return ScreenUtil.adaptiveValue(
      mobile: size,
      tablet: size * tabletFactor,
      desktop: size * desktopFactor,
    );
  }

  static double getAdaptiveFontSize(double size) {
    return ScreenUtil.adaptiveValue(
      mobile: size,
      tablet: size * 1.1, // Меньший коэффициент для шрифтов
      desktop: size * 1.2,
    );
  }

  // Адаптивные значения для размеров карточек и контейнеров
  static double getAdaptiveCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ScreenUtil.adaptiveValue(
      mobile: screenWidth * 0.9,
      tablet: 400,
      desktop: 500,
    );
  }

  static double getAdaptiveGridItemWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ScreenUtil.adaptiveValue(
      mobile: screenWidth * 0.45,
      tablet: 200,
      desktop: 250,
    );
  }

  // Адаптивный padding для основного контента
  static EdgeInsets getAdaptiveContentPadding() {
    return EdgeInsets.all(
      ScreenUtil.adaptiveValue(
        mobile: padding16,
        tablet: padding24,
        desktop: padding32,
      ),
    );
  }

  // Адаптивные отступы по размеру экрана
  static EdgeInsets getAdaptiveEdgeInsets({
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? all,
  }) {
    // Приоритет к более детальным настройкам
    if (all != null) {
      return EdgeInsets.all(getAdaptivePadding(all));
    }

    return EdgeInsets.only(
      left:
          left != null
              ? getAdaptivePadding(left)
              : (horizontal != null ? getAdaptivePadding(horizontal) : 0),
      right:
          right != null
              ? getAdaptivePadding(right)
              : (horizontal != null ? getAdaptivePadding(horizontal) : 0),
      top:
          top != null
              ? getAdaptivePadding(top)
              : (vertical != null ? getAdaptivePadding(vertical) : 0),
      bottom:
          bottom != null
              ? getAdaptivePadding(bottom)
              : (vertical != null ? getAdaptivePadding(vertical) : 0),
    );
  }

  // Получение адаптивного размера для иконок
  static double adaptiveIconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * tabletFactor;
    return baseSize * desktopFactor;
  }

  // Получение адаптивной высоты элемента
  static double adaptiveHeight(BuildContext context, double baseHeight) {
    final screenHeight = MediaQuery.of(context).size.height;
    final percentOfScreen = baseHeight / ScreenUtil.designHeight;
    return screenHeight * percentOfScreen;
  }

  // Получение адаптивной ширины элемента
  static double adaptiveWidth(BuildContext context, double baseWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final percentOfScreen = baseWidth / ScreenUtil.designWidth;
    return screenWidth * percentOfScreen;
  }

  // Получение адаптивного отступа для сейф-зоны
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: padding.top,
      bottom: padding.bottom,
      left: padding.left,
      right: padding.right,
    );
  }

  // Вычисление адаптивного размера относительно ширины экрана
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent / 100;
  }

  // Вычисление адаптивного размера относительно высоты экрана
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent / 100;
  }
}
