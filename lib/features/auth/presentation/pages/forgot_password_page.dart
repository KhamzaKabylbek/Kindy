import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/constants/app_dimensions.dart';
import 'package:super_app_kindergarten/core/constants/app_text_styles.dart';
import 'package:super_app_kindergarten/core/utils/screen_util.dart';
import 'package:super_app_kindergarten/shared/widgets/adaptive_form.dart'
    as form;
import 'package:super_app_kindergarten/shared/widgets/adaptive_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRequestCode() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите email'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate sending verification code
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _currentStep = 1; // Proceed to verification code step
      });
    });
  }

  void _handleVerifyCode() {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите код подтверждения'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate verifying code
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _currentStep = 2; // Proceed to new password step
      });
    });
  }

  void _handleResetPassword() {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все поля'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пароли не совпадают'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate password reset
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder:
            (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 64,
                  ),
                  const SizedBox(height: AppDimensions.spacingMedium),
                  AdaptiveText(
                    'Пароль успешно изменен!',
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  AdaptiveText(
                    'Теперь вы можете войти, используя новый пароль',
                    style: AppTextStyles.body2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingLarge),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
                      child: const Text('Вернуться к входу'),
                    ),
                  ),
                ],
              ),
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Инициализируем ScreenUtil для получения правильных размеров экрана
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановление пароля'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.mainGradient,
          ),
        ),
        child: SafeArea(
          child: AdaptiveLayout(
            // Мобильный вид - вертикальное расположение
            mobile: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.getAdaptivePadding(
                      AppDimensions.padding24,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimensions.getAdaptivePadding(20)),
                      _buildProgressIndicator(),
                      SizedBox(height: AppDimensions.getAdaptivePadding(30)),
                      _buildStepContent(),
                    ],
                  ),
                ),
              ),
            ),

            // Планшетный и десктопный вид - карточка по центру
            tablet: Center(
              child: Container(
                width: 600,
                height: 550,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.getAdaptiveRadius(AppDimensions.radius16),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      AppDimensions.getAdaptivePadding(AppDimensions.padding24),
                    ),
                    child: Column(
                      children: [
                        _buildProgressIndicator(),
                        SizedBox(height: AppDimensions.getAdaptivePadding(40)),
                        Expanded(child: _buildStepContent()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStepIndicator(0, 'Email', _currentStep >= 0)),
            _buildSeparator(_currentStep >= 1),
            Expanded(
              child: _buildStepIndicator(
                1,
                'Код подтверждения',
                _currentStep >= 1,
              ),
            ),
            _buildSeparator(_currentStep >= 2),
            Expanded(
              child: _buildStepIndicator(2, 'Новый пароль', _currentStep >= 2),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(20)),
        AdaptiveText(
          _getStepTitle(),
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 24.0,
              tablet: 28.0,
              desktop: 32.0,
            ),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(8)),
        AdaptiveText(
          _getStepDescription(),
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 16.0,
              tablet: 17.0,
              desktop: 18.0,
            ),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    final double indicatorSize = ScreenUtil.adaptiveValue(
      mobile: 30.0,
      tablet: 36.0,
      desktop: 40.0,
    );

    return Column(
      children: [
        Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.accent : Colors.white.withOpacity(0.3),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 14.0,
                  tablet: 16.0,
                  desktop: 18.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(8)),
        AdaptiveText(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 12.0,
              tablet: 14.0,
              desktop: 16.0,
            ),
            color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSeparator(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isActive ? AppColors.accent : Colors.white.withOpacity(0.3),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Введите ваш Email';
      case 1:
        return 'Введите код подтверждения';
      case 2:
        return 'Создайте новый пароль';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'Мы отправим вам код подтверждения';
      case 1:
        return 'Код был отправлен на ${_emailController.text}';
      case 2:
        return 'Придумайте надежный пароль';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildVerificationStep();
      case 2:
        return _buildNewPasswordStep();
      default:
        return Container();
    }
  }

  Widget _buildEmailStep() {
    return form.AdaptiveFormContainer(
      children: [
        Container(
          height: ScreenUtil.adaptiveValue(
            mobile: 56.0,
            tablet: 60.0,
            desktop: 64.0,
          ),
          child: TextField(
            controller: _emailController,
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 16.0,
                tablet: 17.0,
                desktop: 18.0,
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Введите ваш Email',
              hintStyle: TextStyle(
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 17.0,
                  tablet: 18.0,
                  desktop: 19.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(16),
                horizontal: AppDimensions.getAdaptivePadding(16),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.primary,
                size: AppDimensions.getAdaptiveIconSize(24),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(40)),
        SizedBox(
          width: double.infinity,
          height: ScreenUtil.adaptiveValue(
            mobile: 50.0,
            tablet: 54.0,
            desktop: 58.0,
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleRequestCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
              ),
              elevation: 2,
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(12),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 2.0,
                      ),
                    )
                    : AdaptiveText(
                      'Отправить код',
                      style: TextStyle(
                        fontSize: ScreenUtil.adaptiveValue(
                          mobile: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(16)),
        TextButton(
          onPressed: () => context.go('/login'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getAdaptivePadding(16),
              vertical: AppDimensions.getAdaptivePadding(8),
            ),
          ),
          child: AdaptiveText(
            'Вернуться к входу',
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 14.0,
                tablet: 15.0,
                desktop: 16.0,
              ),
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationStep() {
    return form.AdaptiveFormContainer(
      children: [
        Container(
          height: ScreenUtil.adaptiveValue(
            mobile: 56.0,
            tablet: 60.0,
            desktop: 64.0,
          ),
          child: TextField(
            controller: _codeController,
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 16.0,
                tablet: 17.0,
                desktop: 18.0,
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Введите код подтверждения',
              hintStyle: TextStyle(
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 17.0,
                  tablet: 18.0,
                  desktop: 19.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(16),
                horizontal: AppDimensions.getAdaptivePadding(16),
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.primary,
                size: AppDimensions.getAdaptiveIconSize(24),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(40)),
        SizedBox(
          width: double.infinity,
          height: ScreenUtil.adaptiveValue(
            mobile: 50.0,
            tablet: 54.0,
            desktop: 58.0,
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleVerifyCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
              ),
              elevation: 2,
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(12),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 2.0,
                      ),
                    )
                    : AdaptiveText(
                      'Подтвердить',
                      style: TextStyle(
                        fontSize: ScreenUtil.adaptiveValue(
                          mobile: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0; // Go back to email step
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.getAdaptivePadding(16),
                  vertical: AppDimensions.getAdaptivePadding(8),
                ),
              ),
              child: AdaptiveText(
                'Назад',
                style: TextStyle(
                  fontSize: ScreenUtil.adaptiveValue(
                    mobile: 14.0,
                    tablet: 15.0,
                    desktop: 16.0,
                  ),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Resend verification code
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Код подтверждения отправлен повторно'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.getAdaptivePadding(16),
                  vertical: AppDimensions.getAdaptivePadding(8),
                ),
              ),
              child: AdaptiveText(
                'Отправить код повторно',
                style: TextStyle(
                  fontSize: ScreenUtil.adaptiveValue(
                    mobile: 14.0,
                    tablet: 15.0,
                    desktop: 16.0,
                  ),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep() {
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    return form.AdaptiveFormContainer(
      children: [
        Container(
          height: ScreenUtil.adaptiveValue(
            mobile: 56.0,
            tablet: 60.0,
            desktop: 64.0,
          ),
          child: TextField(
            controller: _newPasswordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 16.0,
                tablet: 17.0,
                desktop: 18.0,
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Новый пароль',
              hintStyle: TextStyle(
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 17.0,
                  tablet: 18.0,
                  desktop: 19.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(16),
                horizontal: AppDimensions.getAdaptivePadding(16),
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.primary,
                size: iconSize,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400,
                  size: iconSize,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(16)),
        Container(
          height: ScreenUtil.adaptiveValue(
            mobile: 56.0,
            tablet: 60.0,
            desktop: 64.0,
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 16.0,
                tablet: 17.0,
                desktop: 18.0,
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Подтвердите пароль',
              hintStyle: TextStyle(
                fontSize: ScreenUtil.adaptiveValue(
                  mobile: 17.0,
                  tablet: 18.0,
                  desktop: 19.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(16),
                horizontal: AppDimensions.getAdaptivePadding(16),
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.primary,
                size: iconSize,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.shade400,
                  size: iconSize,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(40)),
        SizedBox(
          width: double.infinity,
          height: ScreenUtil.adaptiveValue(
            mobile: 50.0,
            tablet: 54.0,
            desktop: 58.0,
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
                ),
              ),
              elevation: 2,
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.getAdaptivePadding(12),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 2.0,
                      ),
                    )
                    : AdaptiveText(
                      'Сохранить новый пароль',
                      style: TextStyle(
                        fontSize: ScreenUtil.adaptiveValue(
                          mobile: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
        SizedBox(height: AppDimensions.getAdaptivePadding(16)),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 1; // Go back to verification step
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getAdaptivePadding(16),
              vertical: AppDimensions.getAdaptivePadding(8),
            ),
          ),
          child: AdaptiveText(
            'Назад',
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 14.0,
                tablet: 15.0,
                desktop: 16.0,
              ),
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
