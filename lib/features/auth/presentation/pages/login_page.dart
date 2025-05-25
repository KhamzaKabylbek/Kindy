import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/constants/app_dimensions.dart';
import 'package:super_app_kindergarten/core/constants/app_text_styles.dart';
import 'package:super_app_kindergarten/core/utils/screen_util.dart';
import 'package:super_app_kindergarten/shared/widgets/adaptive_form.dart'
    as form;
import 'package:super_app_kindergarten/shared/widgets/adaptive_widgets.dart';
import 'package:super_app_kindergarten/shared/widgets/kindergarten_illustration.dart';

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

  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все поля'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate login process
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      context.go('/dashboard');
    });
  }

  void _handleDigitalSignatureLogin() {
    // Handle digital signature login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Вход с помощью ЭЦП будет доступен в ближайшее время'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _handleRegister() {
    context.go('/register');
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
            // Мобильная версия - точное соответствие Figma
            mobile: Stack(
              children: [
                // Фоновая иллюстрация (если нужна)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.figmaPastelGradient,
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),

                // Основная карточка логина - увеличиваем высоту и подгоняем отступы
                Center(
                  child: Container(
                    width: 299,
                    height:
                        450, // Увеличена высота для размещения кнопки регистрации
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
                      // Добавляем прокрутку для предотвращения overflow
                      padding: const EdgeInsets.symmetric(
                        horizontal: 44,
                        vertical: 25, // Уменьшаем отступ
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Заголовок "ВХОД В СИСТЕМУ"
                          Text(
                            'Kindy.kz',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.figmaGreen,
                              letterSpacing: 0,
                              height: 1.39,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24), // Уменьшаем отступ
                          // Поле ввода email
                          _buildFigmaTextField(
                            controller: _emailController,
                            hintText: 'Введите почту',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 12), // Уменьшаем отступ
                          // Поле ввода пароля
                          _buildFigmaPasswordField(),

                          const SizedBox(height: 6), // Уменьшаем отступ
                          // Ссылка "Забыли пароль?"
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.go('/forgot-password'),
                              child: Text(
                                'Забыли пароль?',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.figmaTextSecondary,
                                  height: 0.85,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18), // Уменьшаем отступ
                          // Кнопка "Войти"
                          _buildLoginButton(),

                          const SizedBox(height: 12), // Уменьшаем отступ
                          // Разделитель "или"
                          _buildOrDivider(),

                          const SizedBox(height: 10), // Уменьшаем отступ
                          // Кнопка "Войти с помощью ЭЦП"
                          _buildDigitalSignatureButton(),

                          const SizedBox(height: 12), // Добавляем отступ
                          // Кнопка "Регистрация"
                          _buildRegisterButton(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Иллюстрация детей внизу - фиксированная позиция
                Positioned(
                  bottom: 40, // Фиксированная позиция от низа экрана
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    // Игнорируем прикосновения к изображению
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

            // Планшетная версия - адаптированная
            tablet: Scaffold(
              resizeToAvoidBottomInset: false, // Также для планшетной версии
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
                            'ВХОД В СИСТЕМУ',
                            style: TextStyle(
                              fontFamily: 'System',
                              fontSize: 30,
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
            ),
          ),
        ),
      ),
    );
  }

  // Поле ввода в стиле Figma
  Widget _buildFigmaTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 230,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.figmaInputBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.figmaTextSecondary.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  // Поле ввода пароля с иконкой глаза
  Widget _buildFigmaPasswordField() {
    return Container(
      width: 230,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.figmaInputBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Введите пароль',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.figmaTextSecondary.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
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
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 18,
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
        width: 230,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.figmaGreen,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child:
              _isLoading
                  ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.8,
                    ),
                  )
                  : Text(
                    'Войти',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.17,
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
      width: 210,
      height: 8,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Color(0xFF707070).withOpacity(0.78),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'или',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 8,
                fontWeight: FontWeight.w300,
                color: Color(0xFF707070).withOpacity(0.78),
                height: 1.17,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Color(0xFF707070).withOpacity(0.78),
            ),
          ),
        ],
      ),
    );
  }

  // Кнопка "Войти с помощью ЭЦП"
  Widget _buildDigitalSignatureButton() {
    return GestureDetector(
      onTap: _handleDigitalSignatureLogin,
      child: Container(
        width: 230,
        height: 32, // Уменьшаем высоту
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.figmaGreen, width: 1),
        ),
        child: Center(
          child: Text(
            'Войти с помощью ЭЦП',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13, // Уменьшаем размер шрифта
              fontWeight: FontWeight.w500,
              color: AppColors.figmaGreen,
              height: 1.17,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Кнопка "Регистрация"
  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: _handleRegister,
      child: Container(
        width: 230,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.figmaTextSecondary, width: 1),
        ),
        child: Center(
          child: Text(
            'Регистрация',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.figmaTextSecondary,
              height: 1.17,
            ),
            textAlign: TextAlign.center,
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
            onTap: () => context.go('/forgot-password'),
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
        const SizedBox(height: 16),
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
