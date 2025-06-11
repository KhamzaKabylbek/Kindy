import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/shared/widgets/adaptive_form.dart' as form;
import 'package:kindy/shared/widgets/adaptive_widgets.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      authController.clearResetState();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRequestCode() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите email');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authController = Provider.of<AuthController>(context, listen: false);
    final success = await authController.requestResetCode(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      setState(() {
        _currentStep = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Код подтверждения отправлен на вашу почту'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      _showErrorSnackBar(
        authController.errorMessage ?? 'Ошибка при отправке кода',
      );
    }
  }

  void _handleVerifyCode() async {
    if (_codeController.text.isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите код подтверждения');
      return;
    }

    int? code;
    try {
      code = int.parse(_codeController.text.trim());
    } catch (e) {
      _showErrorSnackBar('Введите корректный код');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authController = Provider.of<AuthController>(context, listen: false);
    final success = await authController.verifyResetCode(code: code);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      setState(() {
        _currentStep = 2;
      });
    } else {
      _showErrorSnackBar(
        authController.errorMessage ?? 'Неверный код подтверждения',
      );
    }
  }

  void _handleResetPassword() async {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Пожалуйста, заполните все поля');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Пароли не совпадают');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authController = Provider.of<AuthController>(context, listen: false);
    final success = await authController.resetPassword(
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _showSuccessDialog();
    } else {
      _showErrorSnackBar(
        authController.errorMessage ?? 'Ошибка при изменении пароля',
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.warning),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Пароль успешно изменен!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Теперь вы можете войти, используя новый пароль',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.figmaGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text('Вернуться к входу'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.figmaPastelGradient,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Кнопка "Назад"
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.figmaGreen,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // Основной контент
              AdaptiveLayout(
                mobile: Center(
                  child: Container(
                    width: ScreenUtil.adaptiveValue(
                      mobile: 340.0,
                      tablet: 400.0,
                      desktop: 450.0,
                    ),
                    height: ScreenUtil.adaptiveValue(
                      mobile: _getContainerHeight(),
                      tablet: _getContainerHeight() + 50,
                      desktop: _getContainerHeight() + 100,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil.adaptiveValue(
                          mobile: 28.0,
                          tablet: 32.0,
                          desktop: 36.0,
                        ),
                        vertical: ScreenUtil.adaptiveValue(
                          mobile: 25.0,
                          tablet: 30.0,
                          desktop: 35.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Заголовок
                          Text(
                            _getStepTitle(),
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: ScreenUtil.adaptiveValue(
                                mobile: 22.0,
                                tablet: 26.0,
                                desktop: 30.0,
                              ),
                              fontWeight: FontWeight.w700,
                              color: AppColors.figmaGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 24.0,
                              tablet: 28.0,
                              desktop: 32.0,
                            ),
                          ),

                          // Индикатор прогресса
                          _buildProgressIndicator(),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 24.0,
                              tablet: 28.0,
                              desktop: 32.0,
                            ),
                          ),

                          // Контент в зависимости от шага
                          _buildStepContent(),
                        ],
                      ),
                    ),
                  ),
                ),

                tablet: Center(
                  child: Container(
                    width: 500,
                    height: _getContainerHeight() + 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _getStepTitle(),
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.figmaGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),
                          _buildProgressIndicator(),
                          const SizedBox(height: 30),
                          _buildStepContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getContainerHeight() {
    switch (_currentStep) {
      case 0:
        return 350.0;
      case 1:
        return 380.0;
      case 2:
        return 450.0;
      default:
        return 350.0;
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'ВОССТАНОВЛЕНИЕ ПАРОЛЯ';
      case 1:
        return 'ПОДТВЕРЖДЕНИЕ';
      case 2:
        return 'НОВЫЙ ПАРОЛЬ';
      default:
        return 'ВОССТАНОВЛЕНИЕ ПАРОЛЯ';
    }
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProgressDot(0),
        _buildProgressLine(0),
        _buildProgressDot(1),
        _buildProgressLine(1),
        _buildProgressDot(2),
      ],
    );
  }

  Widget _buildProgressDot(int step) {
    bool isActive = step <= _currentStep;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.figmaGreen : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressLine(int step) {
    bool isActive = step < _currentStep;
    return Container(
      width: 30,
      height: 2,
      color: isActive ? AppColors.figmaGreen : Colors.grey.shade300,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildCodeStep();
      case 2:
        return _buildPasswordStep();
      default:
        return _buildEmailStep();
    }
  }

  Widget _buildEmailStep() {
    return Column(
      children: [
        Text(
          'Введите ваш email для получения кода восстановления',
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            color: AppColors.figmaTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        _buildFigmaTextField(
          controller: _emailController,
          hintText: 'Введите почту',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        _buildActionButton(
          text: 'Отправить код',
          onPressed: _isLoading ? null : _handleRequestCode,
        ),
      ],
    );
  }

  Widget _buildCodeStep() {
    return Column(
      children: [
        Text(
          'Введите код подтверждения, отправленный на вашу почту',
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            color: AppColors.figmaTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        _buildFigmaTextField(
          controller: _codeController,
          hintText: 'Введите код',
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        _buildActionButton(
          text: 'Подтвердить',
          onPressed: _isLoading ? null : _handleVerifyCode,
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentStep = 0;
            });
          },
          child: Text(
            'Отправить код повторно',
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 12.0,
                tablet: 14.0,
                desktop: 16.0,
              ),
              color: AppColors.figmaGreen,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      children: [
        Text(
          'Введите новый пароль',
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            color: AppColors.figmaTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        _buildFigmaPasswordField(
          controller: _newPasswordController,
          hintText: 'Новый пароль',
          obscureText: _obscurePassword,
          onToggle: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 12.0,
            tablet: 16.0,
            desktop: 20.0,
          ),
        ),
        _buildFigmaPasswordField(
          controller: _confirmPasswordController,
          hintText: 'Повторите пароль',
          obscureText: _obscureConfirmPassword,
          onToggle: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        SizedBox(
          height: ScreenUtil.adaptiveValue(
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        _buildActionButton(
          text: 'Изменить пароль',
          onPressed: _isLoading ? null : _handleResetPassword,
        ),
      ],
    );
  }

  Widget _buildFigmaTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: ScreenUtil.adaptiveValue(
        mobile: 250.0,
        tablet: 320.0,
        desktop: 360.0,
      ),
      height: ScreenUtil.adaptiveValue(
        mobile: 38.0,
        tablet: 44.0,
        desktop: 50.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.figmaInputBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: ScreenUtil.adaptiveValue(
            mobile: 14.0,
            tablet: 16.0,
            desktop: 18.0,
          ),
          color: AppColors.figmaTextSecondary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            color: AppColors.figmaTextSecondary.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.adaptiveValue(
              mobile: 12.0,
              tablet: 16.0,
              desktop: 20.0,
            ),
            vertical: ScreenUtil.adaptiveValue(
              mobile: 8.0,
              tablet: 10.0,
              desktop: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Container(
      width: ScreenUtil.adaptiveValue(
        mobile: 250.0,
        tablet: 320.0,
        desktop: 360.0,
      ),
      height: ScreenUtil.adaptiveValue(
        mobile: 38.0,
        tablet: 44.0,
        desktop: 50.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.figmaInputBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: ScreenUtil.adaptiveValue(
            mobile: 14.0,
            tablet: 16.0,
            desktop: 18.0,
          ),
          color: AppColors.figmaTextSecondary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            color: AppColors.figmaTextSecondary.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.adaptiveValue(
              mobile: 12.0,
              tablet: 16.0,
              desktop: 20.0,
            ),
            vertical: ScreenUtil.adaptiveValue(
              mobile: 8.0,
              tablet: 10.0,
              desktop: 12.0,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.figmaTextSecondary.withOpacity(0.5),
              size: ScreenUtil.adaptiveValue(
                mobile: 16.0,
                tablet: 18.0,
                desktop: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: ScreenUtil.adaptiveValue(
        mobile: 250.0,
        tablet: 320.0,
        desktop: 360.0,
      ),
      height: ScreenUtil.adaptiveValue(
        mobile: 32.0,
        tablet: 38.0,
        desktop: 42.0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.figmaGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child:
            _isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: ScreenUtil.adaptiveValue(
                      mobile: 16.0,
                      tablet: 18.0,
                      desktop: 20.0,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
      ),
    );
  }
}
