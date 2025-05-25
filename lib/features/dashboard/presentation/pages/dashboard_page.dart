import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/constants/app_dimensions.dart';
import 'package:super_app_kindergarten/core/constants/app_text_styles.dart';
import 'package:super_app_kindergarten/core/utils/screen_util.dart';
import 'package:super_app_kindergarten/shared/widgets/adaptive_widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  int _activeChildIndex = 0;

  final List<Map<String, dynamic>> _children = [
    {'name': 'Асанали', 'age': 5, 'group': 'Старшая группа'},
    {'name': 'Айнура', 'age': 4, 'group': 'Средняя группа'},
    {'name': 'Ерасыл', 'age': 3, 'group': 'Младшая группа'},
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;
    final maxWidth = isDesktop ? 1100.0 : (isTablet ? 800.0 : double.infinity);
    final horizontalPadding = isDesktop ? 48.0 : (isTablet ? 32.0 : 0.0);

    Widget content = _buildBody();
    if (!isDesktop) {
      content = SafeArea(child: SingleChildScrollView(child: content));
    } else {
      content = Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SingleChildScrollView(child: content),
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    // Для больших экранов (планшеты и десктопы) показываем двухпанельный интерфейс
    if (ScreenUtil.isLargeScreen() || ScreenUtil.isMediumScreen()) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Боковая навигация
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.backgroundPrimary,
            selectedIconTheme: IconThemeData(color: AppColors.primary),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            selectedLabelTextStyle: TextStyle(color: AppColors.primary),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Главная'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.child_care_outlined),
                selectedIcon: Icon(Icons.child_care),
                label: Text('Мои дети'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.apps_outlined),
                selectedIcon: Icon(Icons.apps),
                label: Text('Сервисы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Профиль'),
              ),
            ],
          ),
          // Вертикальный разделитель
          const VerticalDivider(width: 1, thickness: 1),
          // Основной контент
          Expanded(
            child: Builder(
              builder: (context) {
                switch (_selectedIndex) {
                  case 0:
                    return _buildHomeTab();
                  case 1:
                    return _buildChildrenTab();
                  case 2:
                    return _buildServicesTab();
                  case 3:
                    return _buildProfileTab();
                  default:
                    return _buildHomeTab();
                }
              },
            ),
          ),
        ],
      );
    }

    // Для мобильных устройств используем обычный стек с нижней навигацией
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildChildrenTab();
      case 2:
        return _buildServicesTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildBottomNavigationBar() {
    // На больших экранах используем боковую навигацию вместо нижней
    if (ScreenUtil.isLargeScreen()) {
      return const SizedBox.shrink(); // Не показываем нижнюю навигацию на больших экранах
    }

    // На средних экранах увеличиваем размеры иконок и подписей
    final double iconSize = ScreenUtil.adaptiveValue(
      mobile: 24.0,
      tablet: 30.0,
      desktop: 30.0,
    );

    final double labelFontSize = ScreenUtil.adaptiveValue(
      mobile: 12.0,
      tablet: 14.0,
      desktop: 14.0,
    );

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundPrimary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      iconSize: iconSize,
      selectedFontSize: labelFontSize,
      unselectedFontSize: labelFontSize - 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.child_care_outlined),
          activeIcon: Icon(Icons.child_care),
          label: 'Мои дети',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps_outlined),
          activeIcon: Icon(Icons.apps),
          label: 'Сервисы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildWelcomeSection(),
            const SizedBox(height: AppDimensions.spacingMedium),
            _buildChildrenSelector(),
            const SizedBox(height: AppDimensions.spacingMedium),
            _buildNotifications(),
            const SizedBox(height: AppDimensions.spacingLarge),
            _buildQuickActions(),
            const SizedBox(height: AppDimensions.spacingLarge),
            _buildNewsSection(),
            const SizedBox(height: AppDimensions.spacingLarge),
            _buildUpcomingEvents(),
            const SizedBox(height: AppDimensions.spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.padding16,
        horizontal: AppDimensions.padding16,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BalaBaqsha',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Детский сад «Балдаурен»',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.primary,
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.padding16),
      padding: const EdgeInsets.all(AppDimensions.padding16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Добрый день,', style: AppTextStyles.body1Light),
                  Text(
                    'Хамза Кабылбек',
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding16,
          ),
          child: Text('Мои дети', style: AppTextStyles.h3),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.padding16,
            ),
            itemCount: _children.length,
            itemBuilder: (context, index) {
              final child = _children[index];
              final bool isActive = index == _activeChildIndex;

              return _buildChildCard(
                name: child['name'] as String,
                age: child['age'] as int,
                group: child['group'] as String,
                isActive: isActive,
                onTap: () {
                  setState(() {
                    _activeChildIndex = index;
                  });
                },
                onLongPress: () {
                  context.push('/child-profile', extra: _children[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard({
    required String name,
    required int age,
    required String group,
    required bool isActive,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    // Адаптивная ширина карточки ребенка
    final double cardWidth = ScreenUtil.adaptiveValue(
      mobile: 100.0,
      tablet: 120.0,
      desktop: 150.0,
    );

    // Адаптивный радиус аватара
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 25.0,
      tablet: 30.0,
      desktop: 35.0,
    );

    // Адаптивный размер текста имени
    final double nameTextSize = ScreenUtil.adaptiveValue(
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );

    // Адаптивный отступ между элементами
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingSmall,
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(
          right: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(
            AppDimensions.getAdaptiveRadius(AppDimensions.radius12),
          ),
          border:
              isActive ? Border.all(color: AppColors.primary, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                name.substring(0, 1),
                style: TextStyle(
                  fontSize: nameTextSize,
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppColors.primary : Colors.grey.shade600,
                ),
              ),
            ),
            SizedBox(height: spacing),
            Text(
              name,
              style: AppTextStyles.body3.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontSize: nameTextSize - 4,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '$age ${_getAgeText(age)}',
              style: AppTextStyles.body3.copyWith(
                color: Colors.grey.shade600,
                fontSize: nameTextSize - 6,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              group,
              style: AppTextStyles.body3.copyWith(
                color: Colors.grey.shade600,
                fontSize: nameTextSize - 8,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getAgeText(int age) {
    // Russian grammar for years
    if (age % 10 == 1 && age % 100 != 11) {
      return 'год';
    } else if ((age % 10 == 2 || age % 10 == 3 || age % 10 == 4) &&
        (age % 100 < 10 || age % 100 >= 20)) {
      return 'года';
    } else {
      return 'лет';
    }
  }

  Widget _buildNotifications() {
    final currentChild = _children[_activeChildIndex];
    final childName = currentChild['name'];
    final childGroup = currentChild['group'];

    final double horizontalMargin = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(24.0);

    return AdaptiveLayout(
      mobile: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.orange.shade300, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.getAdaptivePadding(8)),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            SizedBox(
              width: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingMedium,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveText(
                    'Родительское собрание ($childGroup)',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AdaptiveText(
                    'Завтра, 18:00, актовый зал',
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: iconSize * 0.7),
              onPressed: () {
                // Navigate to notification details
              },
            ),
          ],
        ),
      ),

      // Вариант для планшетов и десктопов
      tablet: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.orange.shade300, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.getAdaptivePadding(12)),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            SizedBox(
              width: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingMedium,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AdaptiveText(
                        'Родительское собрание ($childGroup)',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Важно',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AdaptiveText(
                    'Приглашаем вас на родительское собрание, которое состоится завтра в 18:00 в актовом зале детского сада. На собрании будут обсуждаться важные вопросы, касающиеся учебной программы и предстоящих мероприятий.',
                    style: AppTextStyles.body2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      AdaptiveText(
                        'Завтра, 18:00',
                        style: AppTextStyles.body3.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      AdaptiveText(
                        'Актовый зал',
                        style: AppTextStyles.body3.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to notification details
              },
              child: const Text('Подробнее'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final currentChild = _children[_activeChildIndex];
    final childName = currentChild['name'];
    final double horizontalPadding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: AdaptiveText(
            'Действия для ${childName}',
            style: AppTextStyles.h3,
          ),
        ),
        SizedBox(
          height: AppDimensions.getAdaptivePadding(AppDimensions.spacingMedium),
        ),

        // Адаптивный грид для разных размеров экранов
        ScreenUtil.isSmallScreen()
            // Для мобильного - горизонтальный список
            ? SizedBox(
              height: ScreenUtil.adaptiveValue(
                mobile: 120.0,
                tablet: 150.0,
                desktop: 180.0,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                children: [
                  _buildActionCard('Встать в очередь', Icons.queue, () {
                    context.go('/queue');
                  }),
                  _buildActionCard('Меню питания', Icons.restaurant_menu, () {
                    // Navigate to menu
                  }),
                  _buildActionCard('Расписание', Icons.calendar_today, () {
                    // Navigate to schedule
                  }),
                  _buildActionCard('Загрузить фото', Icons.photo_camera, () {
                    // Navigate to photo upload
                  }),
                ],
              ),
            )
            // Для планшетов и десктопов - адаптивный грид
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Wrap(
                spacing: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingMedium,
                ),
                runSpacing: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingMedium,
                ),
                children: [
                  _buildActionCard('Встать в очередь', Icons.queue, () {
                    context.go('/queue');
                  }),
                  _buildActionCard('Меню питания', Icons.restaurant_menu, () {
                    // Navigate to menu
                  }),
                  _buildActionCard('Расписание', Icons.calendar_today, () {
                    // Navigate to schedule
                  }),
                  _buildActionCard('Загрузить фото', Icons.photo_camera, () {
                    // Navigate to photo upload
                  }),
                  // Дополнительные действия для больших экранов
                  _buildActionCard('Оплата', Icons.payment, () {
                    // Navigate to payment
                  }),
                  _buildActionCard('Сообщения', Icons.message, () {
                    // Navigate to messages
                  }),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    // Адаптивные размеры карточки
    final cardWidth = ScreenUtil.adaptiveValue(
      mobile: 100.0,
      tablet: 150.0,
      desktop: 200.0,
    );

    final iconSize = AppDimensions.getAdaptiveIconSize(30);
    final borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final padding = AppDimensions.getAdaptivePadding(AppDimensions.padding12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(
          right:
              ScreenUtil.isSmallScreen()
                  ? AppDimensions.getAdaptivePadding(
                    AppDimensions.spacingMedium,
                  )
                  : 0,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: iconSize),
            ),
            SizedBox(
              height: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AdaptiveText(
                title,
                style: AppTextStyles.body3.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    final double horizontalPadding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacingMedium = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdaptiveText('Новости', style: AppTextStyles.h3),
              TextButton(
                onPressed: () {
                  // Navigate to all news
                },
                child: AdaptiveText(
                  'Все',
                  style: AppTextStyles.body3.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacingMedium),

        // Адаптивный вид для разных размеров экранов
        ScreenUtil.isSmallScreen()
            // Горизонтальный список для мобильных устройств
            ? SizedBox(
              height: ScreenUtil.adaptiveValue(
                mobile: 200.0,
                tablet: 250.0,
                desktop: 300.0,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                children: [
                  _buildNewsCard(
                    'День открытых дверей',
                    'Приглашаем родителей на день открытых дверей в нашем детском саду',
                    'assets/images/news1.jpg',
                  ),
                  _buildNewsCard(
                    'Обновление меню',
                    'С 1 сентября в нашем саду обновляется меню питания детей',
                    'assets/images/news2.jpg',
                  ),
                  _buildNewsCard(
                    'Новые кружки',
                    'Запись на новые кружки по робототехнике и английскому языку',
                    'assets/images/news3.jpg',
                  ),
                ],
              ),
            )
            // Грид для планшетов и десктопов
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GridView.count(
                crossAxisCount: ScreenUtil.isMediumScreen() ? 2 : 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: spacingMedium,
                mainAxisSpacing: spacingMedium,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNewsCard(
                    'День открытых дверей',
                    'Приглашаем родителей на день открытых дверей в нашем детском саду',
                    'assets/images/news1.jpg',
                  ),
                  _buildNewsCard(
                    'Обновление меню',
                    'С 1 сентября в нашем саду обновляется меню питания детей',
                    'assets/images/news2.jpg',
                  ),
                  _buildNewsCard(
                    'Новые кружки',
                    'Запись на новые кружки по робототехнике и английскому языку',
                    'assets/images/news3.jpg',
                  ),
                  _buildNewsCard(
                    'Выставка детских работ',
                    'Приглашаем посетить выставку творческих работ наших воспитанников',
                    'assets/images/news4.jpg',
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildNewsCard(String title, String description, String imagePath) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding12,
    );

    // Адаптивный размер карточки
    final cardWidth =
        ScreenUtil.isSmallScreen()
            ? 250.0
            : double.infinity; // На больших экранах ширина определяется сеткой

    return Container(
      width: cardWidth,
      margin:
          ScreenUtil.isSmallScreen()
              ? EdgeInsets.only(
                right: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingMedium,
                ),
              )
              : EdgeInsets.zero, // Без горизонтальных отступов для сетки
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.photo,
                  size: AppDimensions.getAdaptiveIconSize(50),
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveText(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  AdaptiveText(
                    description,
                    style: AppTextStyles.body3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final double horizontalPadding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacingMedium = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdaptiveText('Ближайшие события', style: AppTextStyles.h3),
              TextButton(
                onPressed: () {
                  // Navigate to all events
                },
                child: AdaptiveText(
                  'Все',
                  style: AppTextStyles.body3.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacingMedium),

        // Адаптивный вид для разных размеров экранов
        AdaptiveLayout(
          // Мобильный вид - простой список
          mobile: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                _buildEventItem('Родительское собрание', 'Завтра, 18:00'),
                const Divider(),
                _buildEventItem('Утренник "Осенний бал"', '20 сентября, 10:00'),
                const Divider(),
                _buildEventItem('Экскурсия в зоопарк', '25 сентября, 9:00'),
              ],
            ),
          ),

          // Планшетный вид - карточки в 2 колонки
          tablet: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildEventCard(
                        'Родительское собрание',
                        'Завтра, 18:00',
                        'Обсуждение учебной программы на новый учебный год и планирование внеклассных мероприятий',
                        Icons.groups,
                      ),
                      SizedBox(height: spacingMedium),
                      _buildEventCard(
                        'Экскурсия в зоопарк',
                        '25 сентября, 9:00',
                        'Познавательная экскурсия для детей старшей группы',
                        Icons.pets,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacingMedium),
                Expanded(
                  child: Column(
                    children: [
                      _buildEventCard(
                        'Утренник "Осенний бал"',
                        '20 сентября, 10:00',
                        'Праздничное мероприятие с участием всех групп. Детям подготовить костюмы',
                        Icons.celebration,
                      ),
                      SizedBox(height: spacingMedium),
                      _buildEventCard(
                        'Медицинский осмотр',
                        '28 сентября, 9:00-12:00',
                        'Плановый медосмотр всех групп детского сада',
                        Icons.local_hospital,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(String title, String dateTime) {
    final double padding8 = AppDimensions.getAdaptivePadding(
      AppDimensions.padding8,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);
    final double radius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius8,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Icon(Icons.event, color: AppColors.primary, size: iconSize),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveText(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AdaptiveText(
                  dateTime,
                  style: AppTextStyles.body3.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: iconSize * 0.7,
              color: Colors.grey,
            ),
            onPressed: () {
              // Navigate to event details
            },
          ),
        ],
      ),
    );
  }

  // Новый метод для карточек событий на больших экранах
  Widget _buildEventCard(
    String title,
    String dateTime,
    String description,
    IconData icon,
  ) {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(32);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(padding * 0.7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: iconSize),
                ),
                SizedBox(
                  width: AppDimensions.getAdaptivePadding(
                    AppDimensions.spacingMedium,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdaptiveText(title, style: AppTextStyles.h3),
                      AdaptiveText(
                        dateTime,
                        style: AppTextStyles.body2.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingMedium,
              ),
            ),
            AdaptiveText(description, style: AppTextStyles.body2),
            SizedBox(
              height: AppDimensions.getAdaptivePadding(
                AppDimensions.spacingMedium,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to event details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('Подробнее'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingLarge = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingLarge,
    );

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Мои дети', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Выберите ребенка для управления его профилем, просмотра дневника и других действий.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _children.length,
              separatorBuilder: (context, index) => SizedBox(height: spacing),
              itemBuilder: (context, index) {
                final child = _children[index];
                return _buildChildDetailCard(
                  name: child['name'] as String,
                  age: child['age'] as int,
                  group: child['group'] as String,
                  isActive: index == _activeChildIndex,
                  onTap: () {
                    setState(() {
                      _activeChildIndex = index;
                    });

                    context.push('/child-profile', extra: _children[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),

      // Планшетный и десктопный вид - карточки в 2-3 колонки
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Мои дети', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Выберите ребенка для управления его профилем, просмотра дневника и других действий.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil.isLargeScreen() ? 3 : 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];
                return _buildChildGridCard(
                  name: child['name'] as String,
                  age: child['age'] as int,
                  group: child['group'] as String,
                  isActive: index == _activeChildIndex,
                  onTap: () {
                    setState(() {
                      _activeChildIndex = index;
                    });

                    context.push('/child-profile', extra: _children[index]);
                  },
                );
              },
            ),
            // Кнопка добавления нового ребенка для больших экранов
            SizedBox(height: spacingLarge),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to add child form
                },
                icon: const Icon(Icons.add),
                label: const Text('Добавить ребенка'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding * 1.5,
                    vertical: padding * 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildDetailCard({
    required String name,
    required int age,
    required String group,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding12,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingSmall,
    );
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 25.0,
      tablet: 35.0,
      desktop: 40.0,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side:
            isActive
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
      ),
      elevation: isActive ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(
                    fontSize: avatarRadius * 0.7,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primary : Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AdaptiveText(
                      name,
                      style: AppTextStyles.body1.copyWith(
                        color:
                            isActive
                                ? AppColors.primary
                                : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    AdaptiveText(
                      '$age ${_getAgeText(age)}',
                      style: AppTextStyles.body3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AdaptiveText(
                      group,
                      style: AppTextStyles.body3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: AppDimensions.getAdaptiveIconSize(20),
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Новый метод для отображения карточки ребенка в сетке (для больших экранов)
  Widget _buildChildGridCard({
    required String name,
    required int age,
    required String group,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius16,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 40.0,
      tablet: 45.0,
      desktop: 50.0,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side:
            isActive
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
      ),
      elevation: isActive ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Expanded(
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    name.substring(0, 1),
                    style: TextStyle(
                      fontSize: avatarRadius * 0.8,
                      fontWeight: FontWeight.bold,
                      color:
                          isActive ? AppColors.primary : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingSmall,
                ),
              ),
              AdaptiveText(
                name,
                style: AppTextStyles.h3.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                  fontSize: ScreenUtil.adaptiveValue(
                    mobile: 18.0,
                    tablet: 20.0,
                    desktop: 22.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              AdaptiveText(
                '$age ${_getAgeText(age)}',
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              AdaptiveText(
                group,
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingSmall,
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                child: const Text('Посмотреть'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.primary : null,
                  foregroundColor: isActive ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingLarge = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingLarge,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    // Список сервисов (удалены пункты "Чат" и "Фотогалерея")
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Оплата услуг',
        'icon': Icons.payment,
        'description': 'Оплата детского сада и дополнительных занятий',
      },
      {
        'title': 'Медицинская карта',
        'icon': Icons.healing,
        'description': 'Доступ к медицинской информации и прививкам',
      },
      {
        'title': 'Онлайн-камеры',
        'icon': Icons.videocam,
        'description': 'Просмотр видеотрансляции из группы',
      },
      {
        'title': 'Электронные справки',
        'icon': Icons.description,
        'description': 'Заказ и получение справок онлайн',
      },
    ];

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Сервисы', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Электронные сервисы для родителей и детей',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              separatorBuilder: (context, index) => SizedBox(height: spacing),
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(
                  title: service['title'],
                  icon: service['icon'],
                  description: service['description'],
                );
              },
            ),
          ],
        ),
      ),

      // Планшетный и десктопный вид - карточки в сетке
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Сервисы', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Электронные сервисы для родителей и детей',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil.isLargeScreen() ? 3 : 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(
                  title: service['title'],
                  icon: service['icon'],
                  description: service['description'],
                  isGrid: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required IconData icon,
    required String description,
    bool isGrid = false,
  }) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(30);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to service
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child:
              isGrid
                  // Вид для сетки (планшет/десктоп)
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(padding * 0.7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(height: padding * 0.5),
                      AdaptiveText(
                        title,
                        style: AppTextStyles.h3,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: padding * 0.3),
                      AdaptiveText(
                        description,
                        style: AppTextStyles.body2.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                  // Вид для списка (мобильный)
                  : Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(padding * 0.7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdaptiveText(title, style: AppTextStyles.h3),
                            SizedBox(height: 4),
                            AdaptiveText(
                              description,
                              style: AppTextStyles.body2.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingLarge = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingLarge,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 50.0,
      tablet: 70.0,
      desktop: 90.0,
    );

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(height: spacingLarge),
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                'ХК',
                style: TextStyle(
                  fontSize: avatarRadius * 0.6,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: spacing),
            AdaptiveText(
              'Хамза Кабылбек',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            AdaptiveText(
              'kabylbek@gmail.com',
              style: AppTextStyles.body1.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingLarge),
            _buildProfileMenuCard(),
            SizedBox(height: spacing),
            _buildSettingsCard(),
            SizedBox(height: spacing),
            _buildLogoutButton(),
            SizedBox(height: spacingLarge),
          ],
        ),
      ),

      // Планшетный и десктопный вид - двухколоночный макет
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Левая колонка - информация о пользователе
            Expanded(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      SizedBox(height: spacing),
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          'ХК',
                          style: TextStyle(
                            fontSize: avatarRadius * 0.6,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      AdaptiveText(
                        'Хамза Кабылбек',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      AdaptiveText(
                        'kabylbek@gmail.com',
                        style: AppTextStyles.body1.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      const Divider(),
                      _buildStatItem('Детей в системе', '3'),
                      _buildStatItem('Дата регистрации', '01.09.2023'),
                      _buildStatItem('Статус', 'Активен'),
                      SizedBox(height: spacing),
                      ElevatedButton(
                        onPressed: () {
                          // Edit profile
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Редактировать профиль'),
                      ),
                      SizedBox(height: spacing),
                      OutlinedButton(
                        onPressed: () {
                          // Logout
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Выйти'),
                      ),
                      SizedBox(height: spacing),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing),
            // Правая колонка - настройки и меню
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildProfileMenuCard(),
                  SizedBox(height: spacing),
                  _buildSettingsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuCard() {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Личные данные', 'icon': Icons.person_outline},
      {'title': 'Мои документы', 'icon': Icons.folder_outlined},
      {'title': 'История оплат', 'icon': Icons.receipt_long_outlined},
      {'title': 'Помощь', 'icon': Icons.help_outline},
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Личный кабинет', style: AppTextStyles.h3),
            ...menuItems.map(
              (item) => _buildMenuTile(
                title: item['title'],
                icon: item['icon'],
                onTap: () {
                  // Navigate to menu item
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    final List<Map<String, dynamic>> settingsItems = [
      {'title': 'Уведомления', 'icon': Icons.notifications_outlined},
      {'title': 'Язык приложения', 'icon': Icons.language_outlined},
      {'title': 'Смена пароля', 'icon': Icons.lock_outline},
      {'title': 'Конфиденциальность', 'icon': Icons.security_outlined},
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Настройки', style: AppTextStyles.h3),
            ...settingsItems.map(
              (item) => _buildMenuTile(
                title: item['title'],
                icon: item['icon'],
                onTap: () {
                  // Navigate to settings item
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: iconSize),
      title: AdaptiveText(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AdaptiveText(
            label,
            style: AppTextStyles.body2.copyWith(color: Colors.grey),
          ),
          AdaptiveText(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        context.go('/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black87,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text('Выйти из аккаунта'),
    );
  }
}
