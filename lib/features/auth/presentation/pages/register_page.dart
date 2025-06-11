import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/shared/widgets/adaptive_form.dart' as form;
import 'package:kindy/shared/widgets/adaptive_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Проверка формата email
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  // Проверка номера телефона
  bool _isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,13}$');
    return phoneRegExp.hasMatch(phone);
  }

  // Проверка сложности пароля
  bool _isPasswordStrong(String password) {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  void _handleRegister() {
    // Проверка обязательных полей
    if (_lastNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите фамилию');
      return;
    }

    if (_firstNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите имя');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите email');
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showErrorSnackBar('Пожалуйста, введите корректный email');
      return;
    }

    if (_phoneController.text.trim().isNotEmpty &&
        !_isValidPhone(_phoneController.text.trim())) {
      _showErrorSnackBar('Пожалуйста, введите корректный номер телефона');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите пароль');
      return;
    }

    if (!_isPasswordStrong(_passwordController.text)) {
      _showErrorSnackBar(
        'Пароль должен содержать минимум 8 символов, включая буквы и цифры',
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Пароли не совпадают');
      return;
    }

    if (!_agreeToTerms) {
      _showErrorSnackBar('Пожалуйста, примите условия пользования');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate registration process
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Регистрация успешно завершена!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to dashboard
      Navigator.of(context).pushReplacementNamed('/dashboard');
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Инициализируем ScreenUtil для получения правильных размеров экрана
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
      extendBodyBehindAppBar: true,
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
            // Мобильный вид — современный UX
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppDimensions.getAdaptivePadding(20)),
                      // Логотип
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.family_restroom,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.getAdaptivePadding(24)),
                      // Заголовок
                      AdaptiveText(
                        'Регистрация',
                        style: AppTextStyles.h1Light,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.getAdaptivePadding(8)),
                      AdaptiveText(
                        'Создайте свой аккаунт',
                        style: AppTextStyles.body1Light,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.getAdaptivePadding(24)),
                      // Поля формы
                      Row(
                        children: [
                          Expanded(
                            child: form.AdaptiveFormField(
                              controller: _lastNameController,
                              hintText: 'Фамилия',
                              labelText: 'Фамилия *',
                              prefixIcon: Icons.person_outline,
                            ),
                          ),
                          SizedBox(width: AppDimensions.getAdaptivePadding(12)),
                          Expanded(
                            child: form.AdaptiveFormField(
                              controller: _firstNameController,
                              hintText: 'Имя',
                              labelText: 'Имя *',
                              prefixIcon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                      form.AdaptiveFormField(
                        controller: _middleNameController,
                        hintText: 'Отчество (необязательно)',
                        labelText: 'Отчество',
                        prefixIcon: Icons.person_outline,
                      ),
                      form.AdaptiveFormField(
                        controller: _emailController,
                        hintText: 'Email',
                        labelText: 'Email *',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      form.AdaptiveFormField(
                        controller: _phoneController,
                        hintText: 'Телефон',
                        labelText: 'Телефон',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      form.AdaptiveFormField(
                        controller: _passwordController,
                        hintText: 'Пароль',
                        labelText: 'Пароль *',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onVisibilityToggle: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      form.AdaptiveFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Повторите пароль',
                        labelText: 'Повторите пароль *',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        onVisibilityToggle: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      // Чекбокс согласия
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: AppColors.primary,
                            side: BorderSide(color: Colors.white.withAlpha(51)),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agreeToTerms = !_agreeToTerms;
                                });
                              },
                              child: AdaptiveText(
                                'Я согласен с условиями пользования и политикой конфиденциальности',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(229),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.getAdaptivePadding(24)),
                      // Кнопка Зарегистрироваться
                      SizedBox(
                        width: double.infinity,
                        height: ScreenUtil.adaptiveValue(
                          mobile: 50.0,
                          tablet: 54.0,
                          desktop: 58.0,
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.getAdaptiveRadius(
                                  AppDimensions.radius12,
                                ),
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
                                    'Зарегистрироваться',
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
                      SizedBox(height: AppDimensions.getAdaptivePadding(24)),
                      // Кнопка Войти
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AdaptiveText(
                            'Уже есть аккаунт?',
                            style: TextStyle(
                              fontSize: ScreenUtil.adaptiveValue(
                                mobile: 14.0,
                                tablet: 15.0,
                                desktop: 16.0,
                              ),
                              color: Colors.white.withAlpha(51),
                            ),
                          ),
                          TextButton(
                            onPressed:
                                () => Navigator.of(
                                  context,
                                ).pushReplacementNamed('/login'),
                            child: AdaptiveText(
                              'Войти',
                              style: TextStyle(
                                fontSize: ScreenUtil.adaptiveValue(
                                  mobile: 14.0,
                                  tablet: 15.0,
                                  desktop: 16.0,
                                ),
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.getAdaptivePadding(24)),
                      // Футер
                      AdaptiveText(
                        '© Детский сад «Балдаурен» — Все права защищены',
                        style: AppTextStyles.captionLight,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Планшетный вид - карточка по центру
            tablet: Center(
              child: Container(
                width: 700,
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              _buildLogoSection(),
                              SizedBox(
                                width: AppDimensions.getAdaptivePadding(
                                  AppDimensions.spacingLarge,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildWelcomeTexts(isTablet: true),
                                    SizedBox(
                                      height: AppDimensions.getAdaptivePadding(
                                        20,
                                      ),
                                    ),
                                    _buildRegisterForm(),
                                    _buildActionButtons(),
                                    _buildFooter(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Десктопный вид - двухколоночный макет
            desktop: Row(
              children: [
                // Левая колонка (информационная)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(
                      AppDimensions.getAdaptivePadding(40),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(204),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.family_restroom,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: AppDimensions.getAdaptivePadding(16),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AdaptiveText(
                                  'Kindy.kz',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Comic Sans MS',
                                  ),
                                ),
                                AdaptiveText(
                                  'Управление детским садом',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withAlpha(204),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.getAdaptivePadding(60)),
                        AdaptiveText(
                          'Присоединяйтесь к нашей семье',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: AppDimensions.getAdaptivePadding(20)),
                        AdaptiveText(
                          'Создайте аккаунт и получите доступ к:',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        SizedBox(height: AppDimensions.getAdaptivePadding(20)),
                        _buildFeatureItem('Электронному дневнику ребенка'),
                        _buildFeatureItem('Расписанию занятий и мероприятий'),
                        _buildFeatureItem('Меню питания на каждый день'),
                        _buildFeatureItem('Прямой связи с педагогами'),
                        _buildFeatureItem('Онлайн-оплате услуг'),
                        SizedBox(height: AppDimensions.getAdaptivePadding(80)),
                        _buildFooter(isDesktop: true),
                      ],
                    ),
                  ),
                ),

                // Правая колонка (форма регистрации)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SizedBox(
                        width: 450,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(
                            AppDimensions.getAdaptivePadding(40),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdaptiveText(
                                'Регистрация',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.getAdaptivePadding(10),
                              ),
                              AdaptiveText(
                                'Создайте свой аккаунт',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.getAdaptivePadding(30),
                              ),

                              // Поля имени в одну строку
                              Row(
                                children: [
                                  Expanded(
                                    child: form.AdaptiveFormField(
                                      controller: _lastNameController,
                                      hintText: 'Фамилия',
                                      labelText: 'Фамилия *',
                                      prefixIcon: Icons.person_outline,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: form.AdaptiveFormField(
                                      controller: _firstNameController,
                                      hintText: 'Имя',
                                      labelText: 'Имя *',
                                      prefixIcon: Icons.person_outline,
                                    ),
                                  ),
                                ],
                              ),

                              form.AdaptiveFormField(
                                controller: _middleNameController,
                                hintText: 'Отчество (необязательно)',
                                labelText: 'Отчество',
                                prefixIcon: Icons.person_outline,
                              ),

                              form.AdaptiveFormField(
                                controller: _emailController,
                                hintText: 'Введите email',
                                labelText: 'Email *',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              form.AdaptiveFormField(
                                controller: _phoneController,
                                hintText: 'Введите телефон',
                                labelText: 'Телефон',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),

                              form.AdaptiveFormField(
                                controller: _passwordController,
                                hintText: 'Введите пароль',
                                labelText: 'Пароль *',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: _obscurePassword,
                                onVisibilityToggle: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),

                              form.AdaptiveFormField(
                                controller: _confirmPasswordController,
                                hintText: 'Повторите пароль',
                                labelText: 'Повторите пароль *',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: _obscureConfirmPassword,
                                onVisibilityToggle: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),

                              // Чекбокс согласия
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _agreeToTerms = !_agreeToTerms;
                                        });
                                      },
                                      child: const Text(
                                        'Я согласен с условиями пользования',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: AppDimensions.getAdaptivePadding(20),
                              ),

                              form.AdaptiveButton(
                                text: 'Зарегистрироваться',
                                onPressed: _handleRegister,
                                isLoading: _isLoading,
                              ),

                              TextButton(
                                onPressed:
                                    () => Navigator.of(
                                      context,
                                    ).pushReplacementNamed('/login'),
                                child: AdaptiveText(
                                  'Уже есть аккаунт? Войти',
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(204),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          AdaptiveText(
            text,
            style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(204)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    final double size = ScreenUtil.adaptiveValue(
      mobile: 150.0,
      tablet: 120.0,
      desktop: 180.0,
    );

    final double iconSize = AppDimensions.getAdaptiveIconSize(
      AppDimensions.iconSizeHuge,
    );

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.family_restroom,
        size: iconSize,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildWelcomeTexts({bool isTablet = false}) {
    return Column(
      crossAxisAlignment:
          isTablet ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        AdaptiveText(
          'Регистрация',
          style: AppTextStyles.h1Light,
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingSmall),
        ),
        AdaptiveText(
          'Создайте аккаунт в детском саду',
          style: AppTextStyles.body1Light,
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                hintText: 'Фамилия',
                prefixIcon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                hintText: 'Имя',
                prefixIcon: Icons.person_outline,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        _buildTextField(
          controller: _middleNameController,
          hintText: 'Отчество',
          prefixIcon: Icons.person_outline,
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        _buildTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        _buildTextField(
          controller: _phoneController,
          hintText: 'Телефон',
          prefixIcon: Icons.phone_outlined,
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        _buildTextField(
          controller: _passwordController,
          hintText: 'Пароль',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        _buildTextField(
          controller: _confirmPasswordController,
          hintText: 'Повторите пароль',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    return TextField(
      controller: controller,
      obscureText:
          isPassword &&
          (isPassword ? _obscurePassword : _obscureConfirmPassword),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: iconSize),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    (isPassword ? _obscurePassword : _obscureConfirmPassword)
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey.shade400,
                    size: iconSize,
                  ),
                  onPressed: () {
                    setState(() {
                      if (controller == _passwordController) {
                        _obscurePassword = !_obscurePassword;
                      } else {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
                : null,
      ),
    );
  }

  Widget _buildActionButtons() {
    final double buttonHeight = ScreenUtil.adaptiveValue(
      mobile: 50.0,
      tablet: 54.0,
      desktop: 58.0,
    );

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleRegister,
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
                      'Зарегистрироваться',
                      style: AppTextStyles.buttonText,
                    ),
          ),
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getAdaptivePadding(
                AppDimensions.padding16,
              ),
              vertical: AppDimensions.getAdaptivePadding(
                AppDimensions.padding8,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.getAdaptiveRadius(AppDimensions.radius8),
              ),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
          ),
          child: AdaptiveText(
            'Уже есть аккаунт? Войти',
            style: AppTextStyles.body1Light.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter({bool isDesktop = false}) {
    return AdaptiveText(
      '© Детский сад «Балдаурен» — Все права защищены',
      style:
          isDesktop
              ? const TextStyle(color: Colors.white70, fontSize: 14)
              : AppTextStyles.captionLight,
      textAlign: TextAlign.center,
    );
  }
}
