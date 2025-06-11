import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/features/auth/domain/entities/auth_entities.dart';
import 'package:kindy/shared/widgets/adaptive_form.dart' as form;
import 'package:kindy/shared/widgets/adaptive_widgets.dart';
import 'package:kindy/shared/widgets/kindergarten_illustration.dart';

class KindergartenLoginPage extends StatefulWidget {
  const KindergartenLoginPage({super.key});

  @override
  State<KindergartenLoginPage> createState() => _KindergartenLoginPageState();
}

class _KindergartenLoginPageState extends State<KindergartenLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все поля'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        print('Вход выполнен успешно!');

        // Переход на дашборд
        context.go('/dashboard');
      } else {
        final errorMessage = authController.errorMessage ?? 'Ошибка входа';
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      print('Ошибка при входе: $e');
      _showErrorSnackBar('Произошла ошибка при входе');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDigitalSignatureLogin() {
    // Handle digital signature login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Вход с помощью ЭЦП будет доступен в ближайшее время'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRegister() {
    Navigator.of(context).pushNamed('/register');
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
          child: AdaptiveLayout(
            // Мобильная версия - красивый дизайн без анимаций
            mobile: Stack(
              children: [
                // Основная карточка логина
                Center(
                  child: Container(
                    width: 340,
                    height: 580,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 25,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),

                          // Логотип
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.figmaGreen,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'Kindy',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Поле ввода email
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Введите почту',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 15),

                          // Поле ввода пароля
                          _buildPasswordField(),

                          const SizedBox(height: 8),

                          // Ссылка "Забыли пароль?"
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap:
                                  () => Navigator.of(
                                    context,
                                  ).pushNamed('/forgot-password'),
                              child: Text(
                                'Забыли пароль?',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.figmaGreen,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Кнопка "Войти"
                          _buildLoginButton(),

                          const SizedBox(height: 15),

                          // Разделитель "или"
                          _buildOrDivider(),

                          const SizedBox(height: 15),

                          // Кнопка "Войти с помощью ЭЦП"
                          _buildDigitalSignatureButton(),

                          const SizedBox(height: 12),

                          // Кнопка "Регистрация"
                          _buildRegisterButton(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Иллюстрация детей внизу
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        height: 150,
                        child: KindergartenIllustration(
                          height: 150,
                          showWelcomeSign: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Планшетная версия
            tablet: _buildTabletVersion(),
          ),
        ),
      ),
    );
  }

  // Поле ввода
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 280,
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),
        ),
      ),
    );
  }

  // Поле ввода пароля
  Widget _buildPasswordField() {
    return Container(
      width: 280,
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Введите пароль',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Кнопка "Войти"
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin,
      child: Container(
        width: 280,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.figmaGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child:
              _isLoading
                  ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    'Войти',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
        ),
      ),
    );
  }

  // Разделитель "или"
  Widget _buildOrDivider() {
    return SizedBox(
      width: 280,
      height: 20,
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'или',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  // Кнопка ЭЦП
  Widget _buildDigitalSignatureButton() {
    return GestureDetector(
      onTap: _handleDigitalSignatureLogin,
      child: Container(
        width: 280,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.figmaGreen, width: 1.5),
        ),
        child: Center(
          child: Text(
            'Войти с помощью ЭЦП',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.figmaGreen,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Кнопка регистрации
  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: _handleRegister,
      child: Container(
        width: 280,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
        ),
        child: Center(
          child: Text(
            'Регистрация',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Планшетная версия
  Widget _buildTabletVersion() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kindy',
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.figmaGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildTabletForm(),
                  const SizedBox(height: 40),
                  KindergartenIllustration(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Форма для планшетной версии
  Widget _buildTabletForm() {
    return Column(
      children: [
        Container(
          width: 300,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.figmaInputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _emailController,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Введите почту',
              hintStyle: TextStyle(
                fontSize: 17,
                color: AppColors.figmaTextSecondary.withOpacity(0.7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 300,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.figmaInputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Введите пароль',
                    hintStyle: TextStyle(
                      fontSize: 17,
                      color: AppColors.figmaTextSecondary.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
            child: Text(
              'Забыли пароль?',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.figmaTextSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _isLoading ? null : _handleLogin,
          child: Container(
            width: 300,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.figmaGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
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
                        'Войти',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _handleDigitalSignatureLogin,
          child: Container(
            width: 300,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.figmaGreen, width: 1),
            ),
            child: Center(
              child: Text(
                'Войти с помощью ЭЦП',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.figmaGreen,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _handleRegister,
          child: Container(
            width: 300,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.figmaTextSecondary, width: 1),
            ),
            child: Center(
              child: Text(
                'Регистрация',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.figmaTextSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
