import 'package:flutter/material.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/shared/widgets/adaptive_widgets.dart';

class AdaptiveFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onVisibilityToggle;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AdaptiveFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onVisibilityToggle,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double fontSize = ScreenUtil.adaptiveValue(
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
    final double hintFontSize = ScreenUtil.adaptiveValue(
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    return Container(
      width: ScreenUtil.adaptiveValue(
        mobile: double.infinity,
        tablet: 400,
        desktop: 450,
      ),
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.getAdaptivePadding(AppDimensions.spacingSmall),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: hintFontSize,
            color: Colors.grey.shade600,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: hintFontSize,
            color: AppColors.primary,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.primary,
            size: iconSize,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade400,
                      size: iconSize,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.getAdaptivePadding(
              AppDimensions.padding16,
            ),
            vertical: AppDimensions.getAdaptivePadding(AppDimensions.padding12),
          ),
        ),
      ),
    );
  }
}

class AdaptiveFormContainer extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final String? subtitle;

  const AdaptiveFormContainer({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding24,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius16,
    );

    return Container(
      width: ScreenUtil.adaptiveValue(
        mobile: double.infinity,
        tablet: 500,
        desktop: 600,
      ),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            AdaptiveText(
              title!,
              style: TextStyle(
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingSmall,
              ),
            ),
          ],
          if (subtitle != null) ...[
            AdaptiveText(
              subtitle!,
              style: TextStyle(
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingMedium,
              ),
            ),
          ],
          ...children,
        ],
      ),
    );
  }
}

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;

  const AdaptiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double height = ScreenUtil.adaptiveValue(
      mobile: 50.0,
      tablet: 56.0,
      desktop: 60.0,
    );

    final double fontSize = ScreenUtil.adaptiveValue(
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );

    final Widget buttonContent =
        isLoading
            ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: isPrimary ? Colors.white : AppColors.primary,
                strokeWidth: 2.0,
              ),
            )
            : (icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon),
                    SizedBox(width: AppDimensions.getAdaptivePadding(8)),
                    Text(text),
                  ],
                )
                : Text(text));

    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
      ),
      child:
          isPrimary
              ? ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: fontSize),
                ),
                child: buttonContent,
              )
              : OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  textStyle: TextStyle(fontSize: fontSize),
                ),
                child: buttonContent,
              ),
    );
  }
}
