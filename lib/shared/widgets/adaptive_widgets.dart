import 'package:flutter/material.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/utils/screen_util.dart';

/// Адаптивный контейнер, который изменяет свои размеры в зависимости от экрана
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Color? color;
  final BoxConstraints? constraints;
  final Alignment? alignment;
  final double? maxWidth;

  const AdaptiveContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.constraints,
    this.alignment,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Адаптивное значение padding в зависимости от размера экрана
    final adaptivePadding =
        padding ??
        EdgeInsets.all(
          ScreenUtil.adaptiveValue(mobile: 16.0, tablet: 24.0, desktop: 32.0),
        );

    // Адаптивная ширина контейнера
    final adaptiveWidth =
        width != null ? ScreenUtil.getProportionateScreenWidth(width!) : null;

    // Максимальная ширина для ограничения на больших экранах
    final effectiveMaxWidth =
        maxWidth ?? (ScreenUtil.isLargeScreen() ? 1200.0 : double.infinity);

    return Container(
      width: adaptiveWidth,
      height:
          height != null
              ? ScreenUtil.getProportionateScreenHeight(height!)
              : null,
      padding: adaptivePadding,
      margin: margin,
      decoration: decoration,
      color: color,
      alignment: alignment,
      constraints: constraints ?? BoxConstraints(maxWidth: effectiveMaxWidth),
      child: child,
    );
  }
}

/// Адаптивная сетка, изменяющая количество элементов в строке в зависимости от размера экрана
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double childAspectRatio;

  const AdaptiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.alignment = WrapAlignment.start,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.childAspectRatio = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Определяем количество элементов в строке в зависимости от размера экрана
    final crossAxisCount =
        ScreenUtil.adaptiveValue(
              mobile: mobileColumns ?? 2,
              tablet: tabletColumns ?? 3,
              desktop: desktopColumns ?? 4,
            )
            as int;

    // Используем GridView для единообразного отображения
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Адаптивный макет, автоматически выбирающий правильное представление
/// в зависимости от размера экрана
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Определяем ориентацию экрана
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        // Приоритет отдаем размеру ширины окна, а не экрана
        if (constraints.maxWidth >= 900 && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= 600 && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Адаптивный текст, автоматически масштабирующийся под размер экрана
class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool scaleByWidth;
  final double? minFontSize;
  final double? maxFontSize;

  const AdaptiveText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.scaleByWidth = true,
    this.minFontSize,
    this.maxFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle =
        style ?? Theme.of(context).textTheme.bodyMedium!;

    // Расчет адаптивного размера шрифта
    double? adaptiveFontSize;
    if (defaultStyle.fontSize != null) {
      if (scaleByWidth) {
        // Масштабирование по ширине экрана
        adaptiveFontSize = ScreenUtil.getFontSize(defaultStyle.fontSize!);
      } else {
        // Использование фактора масштабирования
        adaptiveFontSize =
            defaultStyle.fontSize! *
            ScreenUtil.adaptiveValue(mobile: 1.0, tablet: 1.15, desktop: 1.3);
      }

      // Ограничиваем минимальный и максимальный размер шрифта
      if (minFontSize != null && adaptiveFontSize != null) {
        adaptiveFontSize =
            adaptiveFontSize < minFontSize! ? minFontSize : adaptiveFontSize;
      }
      if (maxFontSize != null && adaptiveFontSize != null) {
        adaptiveFontSize =
            adaptiveFontSize > maxFontSize! ? maxFontSize : adaptiveFontSize;
      }
    }

    return Text(
      text,
      style: defaultStyle.copyWith(fontSize: adaptiveFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Адаптивная кнопка
class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? minWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AdaptiveButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.minWidth,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Адаптивные размеры
    final double buttonHeight =
        height ??
        ScreenUtil.adaptiveValue(mobile: 48.0, tablet: 54.0, desktop: 60.0);

    final double fontSize = ScreenUtil.adaptiveValue(
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );

    // Адаптивное скругление
    final BorderRadius effectiveBorderRadius =
        borderRadius ??
        BorderRadius.circular(
          ScreenUtil.adaptiveValue(mobile: 8.0, tablet: 10.0, desktop: 12.0),
        );

    // Адаптивные отступы
    final EdgeInsetsGeometry effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: ScreenUtil.adaptiveValue(
            mobile: 16.0,
            tablet: 24.0,
            desktop: 32.0,
          ),
          vertical: ScreenUtil.adaptiveValue(
            mobile: 8.0,
            tablet: 12.0,
            desktop: 16.0,
          ),
        );

    final Color effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final Color effectiveTextColor = textColor ?? Colors.white;

    Widget buttonContent =
        isLoading
            ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: effectiveTextColor,
                strokeWidth: 2.0,
              ),
            )
            : (icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: effectiveTextColor),
                    SizedBox(width: 8),
                    AdaptiveText(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: effectiveTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                : AdaptiveText(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: effectiveTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ));

    return Container(
      height: buttonHeight,
      constraints: BoxConstraints(minWidth: minWidth ?? double.infinity),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          padding: effectivePadding,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          elevation: ScreenUtil.adaptiveValue(mobile: 2, tablet: 3, desktop: 4),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Адаптивная карточка с масштабируемыми отступами и скруглениями
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const AdaptiveCard({
    Key? key,
    required this.child,
    this.color,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Адаптивные отступы
    final EdgeInsetsGeometry effectivePadding =
        padding ??
        EdgeInsets.all(
          ScreenUtil.adaptiveValue(mobile: 16.0, tablet: 20.0, desktop: 24.0),
        );

    // Адаптивные внешние отступы
    final EdgeInsetsGeometry effectiveMargin =
        margin ??
        EdgeInsets.all(
          ScreenUtil.adaptiveValue(mobile: 8.0, tablet: 12.0, desktop: 16.0),
        );

    // Адаптивное скругление
    final BorderRadius effectiveBorderRadius =
        borderRadius ??
        BorderRadius.circular(
          ScreenUtil.adaptiveValue(mobile: 8.0, tablet: 12.0, desktop: 16.0),
        );

    // Адаптивная высота тени
    final double effectiveElevation =
        elevation ??
        ScreenUtil.adaptiveValue(mobile: 2.0, tablet: 3.0, desktop: 4.0);

    Widget cardContent = Card(
      color: color,
      margin: effectiveMargin,
      elevation: effectiveElevation,
      shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
      child: Padding(padding: effectivePadding, child: child),
    );

    // Если указан onTap, оборачиваем карточку в InkWell для эффекта нажатия
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Адаптивная разделительная линия
class AdaptiveDivider extends StatelessWidget {
  final double? thickness;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const AdaptiveDivider({Key? key, this.thickness, this.color, this.margin})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Адаптивная толщина
    final double effectiveThickness =
        thickness ??
        ScreenUtil.adaptiveValue(mobile: 1.0, tablet: 1.5, desktop: 2.0);

    // Адаптивные отступы
    final EdgeInsetsGeometry effectiveMargin =
        margin ??
        EdgeInsets.symmetric(
          vertical: ScreenUtil.adaptiveValue(
            mobile: 8.0,
            tablet: 12.0,
            desktop: 16.0,
          ),
        );

    return Container(
      margin: effectiveMargin,
      child: Divider(thickness: effectiveThickness, color: color),
    );
  }
}
