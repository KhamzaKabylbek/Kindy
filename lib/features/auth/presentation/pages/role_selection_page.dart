import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/shared/widgets/adaptive_widgets.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;

  void _handleRoleSelection(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _handleNext() {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, выберите роль'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    switch (selectedRole) {
      case 'parent':
        context.go('/register/parent');
        break;
      case 'teacher':
        context.go('/register/teacher/step1');
        break;
      case 'manager':
        context.go('/register/manager/step1');
        break;
    }
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
                // Мобильная версия
                mobile: Center(
                  child: Container(
                    width: ScreenUtil.adaptiveValue(
                      mobile: 340.0,
                      tablet: 400.0,
                      desktop: 450.0,
                    ),
                    height: ScreenUtil.adaptiveValue(
                      mobile: 380.0,
                      tablet: 430.0,
                      desktop: 470.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        ScreenUtil.adaptiveValue(
                          mobile: 28.0,
                          tablet: 32.0,
                          desktop: 36.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Заголовок
                          Text(
                            'РЕГИСТРАЦИЯ',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: ScreenUtil.adaptiveValue(
                                mobile: 22.0,
                                tablet: 26.0,
                                desktop: 30.0,
                              ),
                              fontWeight: FontWeight.bold,
                              color: AppColors.figmaGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 33.0,
                              tablet: 38.0,
                              desktop: 42.0,
                            ),
                          ),

                          // Выбор ролей
                          Row(
                            children: [
                              Expanded(
                                child: _buildRoleButton('parent', 'Родитель'),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildRoleButton(
                                  'teacher',
                                  'Воспитатель',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildRoleButton(
                                  'manager',
                                  'Руководитель',
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 55.0,
                              tablet: 60.0,
                              desktop: 65.0,
                            ),
                          ),

                          // Кнопка "Далее"
                          SizedBox(
                            width: ScreenUtil.adaptiveValue(
                              mobile: 250.0,
                              tablet: 280.0,
                              desktop: 310.0,
                            ),
                            height: ScreenUtil.adaptiveValue(
                              mobile: 32.0,
                              tablet: 38.0,
                              desktop: 42.0,
                            ),
                            child: ElevatedButton(
                              onPressed: _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.figmaGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Далее',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Планшетная версия
                tablet: Center(
                  child: Container(
                    width: 500,
                    height: 490,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Text(
                            'РЕГИСТРАЦИЯ',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.figmaGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          Row(
                            children: [
                              Expanded(
                                child: _buildRoleButton('parent', 'Родитель'),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildRoleButton(
                                  'teacher',
                                  'Воспитатель',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildRoleButton(
                                  'manager',
                                  'Руководитель',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 60),

                          SizedBox(
                            width: 320,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.figmaGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Далее',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
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

  Widget _buildRoleButton(String role, String label) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () => _handleRoleSelection(role),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.adaptiveValue(
          mobile: 28.0,
          tablet: 32.0,
          desktop: 36.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.figmaGreen : Colors.transparent,
          border: Border.all(color: AppColors.figmaGreen, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ScreenUtil.adaptiveValue(
                mobile: 13.0,
                tablet: 15.0,
                desktop: 17.0,
              ),
              color: isSelected ? Colors.white : AppColors.figmaGreen,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
