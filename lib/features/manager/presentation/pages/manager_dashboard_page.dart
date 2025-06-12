import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/shared/widgets/adaptive_widgets.dart';
import 'package:provider/provider.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/shared/widgets/social_actions.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    print('ManagerDashboardPage: initState вызван');

    // Отложим проверку пользователя до построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserRole();
    });
  }

  void _checkUserRole() {
    // Проверяем текущего пользователя и его роль
    final authController = Provider.of<AuthController>(context, listen: false);
    print(
      'ManagerDashboardPage: Роль пользователя: ${authController.userDetails?.role}',
    );
    print(
      'ManagerDashboardPage: Данные пользователя: ${authController.userDetails?.toJson()}',
    );
  }

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
                icon: Icon(Icons.newspaper_outlined),
                selectedIcon: Icon(Icons.newspaper),
                label: Text('Новости'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: Text('Заявки'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
                label: Text('Группы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outlined),
                selectedIcon: Icon(Icons.people),
                label: Text('Сотрудники'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: Text('Статистика'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: Text('Расписание'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: Text('Курсы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu),
                label: Text('Меню'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_outlined),
                selectedIcon: Icon(Icons.inventory),
                label: Text('Склад'),
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
                    return _buildNewsTab();
                  case 2:
                    return _buildRequestsTab();
                  case 3:
                    return _buildGroupsTab();
                  case 4:
                    return _buildEmployeesTab();
                  case 5:
                    return _buildStatisticsTab();
                  case 6:
                    return _buildScheduleTab();
                  case 7:
                    return _buildCoursesTab();
                  case 8:
                    return _buildMenuTab();
                  case 9:
                    return _buildInventoryTab();
                  case 10:
                    return _buildProfileTab();
                  case 11:
                    return _buildMoreTab();
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
        return _buildNewsTab();
      case 2:
        return _buildRequestsTab();
      case 3:
        return _buildGroupsTab();
      case 4:
        return _buildEmployeesTab();
      case 5:
        return _buildStatisticsTab();
      case 6:
        return _buildScheduleTab();
      case 7:
        return _buildCoursesTab();
      case 8:
        return _buildMenuTab();
      case 9:
        return _buildInventoryTab();
      case 10:
        return _buildProfileTab();
      case 11:
        return _buildMoreTab();
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

    // Мобильная навигация показывает только основные разделы
    return BottomNavigationBar(
      currentIndex: _selectedIndex > 4 ? 4 : _selectedIndex,
      onTap: (index) {
        setState(() {
          if (index == 4) {
            // Если нажата кнопка "Еще", показываем меню с остальными разделами
            _showMoreMenu(context);
          } else {
            _selectedIndex = index;
          }
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
          icon: Icon(Icons.newspaper_outlined),
          activeIcon: Icon(Icons.newspaper),
          label: 'Новости',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          activeIcon: Icon(Icons.groups),
          label: 'Группы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outlined),
          activeIcon: Icon(Icons.people),
          label: 'Сотрудники',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          activeIcon: Icon(Icons.more_horiz),
          label: 'Ещё',
        ),
      ],
    );
  }

  void _showMoreMenu(BuildContext context) {
    // Показываем меню на весь экран для лучшего взаимодействия
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Почти на весь экран
          minChildSize: 0.7, // Минимальная высота
          maxChildSize: 0.95, // Максимальная высота
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Полоса для обозначения возможности перетаскивания
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Заголовок
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text('Дополнительно', style: AppTextStyles.h2),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Прокручиваемый список
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      _buildMoreMenuItem(
                        icon: Icons.assignment_outlined,
                        iconColor: Colors.orange,
                        title: 'Заявки',
                        subtitle: 'Управление заявками в системе',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMoreMenuItem(
                        icon: Icons.analytics_outlined,
                        iconColor: Colors.blue,
                        title: 'Статистика',
                        subtitle: 'Аналитика и отчеты',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 5;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMoreMenuItem(
                        icon: Icons.calendar_today_outlined,
                        iconColor: Colors.purple,
                        title: 'Расписание',
                        subtitle: 'Управление расписанием занятий',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 6;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMoreMenuItem(
                        icon: Icons.school_outlined,
                        iconColor: Colors.indigo,
                        title: 'Курсы',
                        subtitle: 'Дополнительные образовательные программы',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 7;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMoreMenuItem(
                        icon: Icons.restaurant_menu_outlined,
                        iconColor: Colors.green,
                        title: 'Меню',
                        subtitle: 'Управление питанием детей',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 8;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMoreMenuItem(
                        icon: Icons.inventory_outlined,
                        iconColor: Colors.brown,
                        title: 'Склад',
                        subtitle: 'Учет и хранение инвентаря',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 9;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMoreMenuItem(
                        icon: Icons.person_outline,
                        iconColor: Colors.teal,
                        title: 'Профиль',
                        subtitle: 'Настройки личного профиля',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 10;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMoreMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Личный кабинет руководителя'),
            _buildWelcomeCard(),
            _buildStatsOverview(),
            _buildRecentRequests(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Новости и объявления'),
            _buildNewsControls(),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Заявки'),
            _buildRequestsTabBar(),
            _buildRequestsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Группы ДДО'),
            _buildGroupsControls(),
            _buildGroupsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Сотрудники'),
            _buildEmployeesControls(),
            Padding(
              padding: EdgeInsets.all(padding),
              child: _buildEmployeesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Статистика'),
            _buildStatisticsControls(),
            _buildStatisticsCharts(),
            _buildStatisticsDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Расписание событий'),
            _buildCalendar(),
            _buildEventsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Курсы и кружки'),
            _buildCoursesControls(),
            _buildCoursesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Электронное меню'),
            _buildMenuControls(),
            _buildMenuCalendar(),
            _buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Электронный склад'),
            _buildInventoryControls(),
            _buildInventoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Мой профиль'),
            _buildProfileCard(),
            _buildProfileSettings(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: AppTextStyles.h1),
    );
  }

  Widget _buildWelcomeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Здравствуйте, Алия Каримовна!',
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Сегодня: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                          style: AppTextStyles.body1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'У вас 3 новых заявки и 5 событий на сегодня',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Просмотреть заявки'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Статистика учреждения', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount:
                ScreenUtil.isLargeScreen()
                    ? 4
                    : (ScreenUtil.isMediumScreen() ? 3 : 2),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Группы', '12', Icons.groups, Colors.indigo),
              _buildStatCard('Дети', '245', Icons.child_care, Colors.teal),
              _buildStatCard(
                'Сотрудники',
                '38',
                Icons.people,
                Colors.deepOrange,
              ),
              _buildStatCard(
                'Посещаемость',
                '91%',
                Icons.trending_up,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Icon(icon, size: 24, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRequests() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Последние заявки', style: AppTextStyles.h2),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: Text(
                  'Показать все',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRequestItem(
            title: 'Заявка на отпуск',
            author: 'Айнур Сергеевна',
            date: '12.06.2023',
            status: 'На рассмотрении',
            statusColor: Colors.orange,
          ),
          _buildRequestItem(
            title: 'Запрос на ремонт оборудования',
            author: 'Марат Айдарович',
            date: '10.06.2023',
            status: 'Одобрено',
            statusColor: Colors.green,
          ),
          _buildRequestItem(
            title: 'Заявка на прием ребенка',
            author: 'Семья Ахметовых',
            date: '09.06.2023',
            status: 'Новая',
            statusColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem({
    required String title,
    required String author,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'От: $author',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Создать новость'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    // Имитация списка новостей
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildNewsItem(
            title: 'Новость ${index + 1}',
            content: 'Содержимое новости ${index + 1}',
            date:
                '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
            imageUrl: 'assets/images/Image${index + 1}.png',
            likes: 10 + index,
            comments: 5 + index,
            hasLiked: false,
          );
        },
      ),
    );
  }

  Widget _buildNewsItem({
    required String title,
    required String content,
    required String date,
    required String imageUrl,
    required int likes,
    required int comments,
    required bool hasLiked,
  }) {
    return Container(
      width:
          MediaQuery.of(context).size.width * 0.95, // Чуть меньше ширины экрана
      margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок новости и дата
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(content),
                    ),
                ],
              ),
            ),

            // Изображение, если есть
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                child: Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            // Используем новый виджет для социальных действий
            SocialActionsWidget(
              likes: likes,
              comments: comments,
              hasLiked: hasLiked,
              onLikePressed: () {},
              onCommentPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Вкладки для разных типов заявок
  Widget _buildRequestsTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Сотрудники'),
                Tab(text: 'Очередь'),
                Tab(text: 'Прочие'),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 300, // Фиксированная высота для демонстрации
              child: TabBarView(
                children: [
                  Center(child: Text('Список заявок от сотрудников')),
                  Center(child: Text('Список заявок на очередь')),
                  Center(child: Text('Прочие заявки')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    // Заглушка списка заявок
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          for (int i = 0; i < 5; i++)
            _buildRequestItem(
              title: 'Заявка на отпуск #${i + 1}',
              author: 'Сотрудник ${i + 1}',
              date: '${i + 10}.06.2023',
              status:
                  i % 3 == 0
                      ? 'Новая'
                      : (i % 3 == 1 ? 'На рассмотрении' : 'Одобрено'),
              statusColor:
                  i % 3 == 0
                      ? Colors.blue
                      : (i % 3 == 1 ? Colors.orange : Colors.green),
            ),
        ],
      ),
    );
  }

  // Контролы для групп
  Widget _buildGroupsControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по группам...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    // Список групп
    final List<Map<String, dynamic>> groups = [
      {'name': 'Старшая группа "Солнышко"', 'count': 15, 'age': '5-6 лет'},
      {'name': 'Средняя группа "Звездочки"', 'count': 12, 'age': '4-5 лет'},
      {'name': 'Младшая группа "Радуга"', 'count': 10, 'age': '3-4 года'},
      {'name': 'Ясельная группа "Капельки"', 'count': 8, 'age': '2-3 года'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              ScreenUtil.isLargeScreen()
                  ? 3
                  : (ScreenUtil.isMediumScreen() ? 2 : 1),
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return _buildGroupCard(
            name: group['name'],
            count: group['count'],
            age: group['age'],
          );
        },
      ),
    );
  }

  Widget _buildGroupCard({
    required String name,
    required int count,
    required String age,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(Icons.groups, size: 25, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text('Возраст: $age', style: AppTextStyles.body1),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Количество детей: $count',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesControls() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск сотрудников...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesList() {
    return Column(
      children: [
        for (int i = 0; i < 5; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  ['АК', 'ТС', 'МН', 'ЛВ', 'АП'][i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              title: Text(
                [
                  'Айнур Каримова',
                  'Татьяна Сергеева',
                  'Марат Нурланов',
                  'Лаура Викторова',
                  'Алексей Петров',
                ][i],
              ),
              subtitle: Text(
                [
                  'Воспитатель',
                  'Логопед',
                  'Учитель музыки',
                  'Воспитатель',
                  'Учитель физкультуры',
                ][i],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
      ],
    );
  }

  // Заглушки для оставшихся разделов
  Widget _buildStatisticsControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Период',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: 'Текущий месяц',
              items:
                  ['Текущий месяц', 'Предыдущий месяц', 'Квартал', 'Год']
                      .map(
                        (period) => DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        ),
                      )
                      .toList(),
              onChanged: (value) {},
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('Экспорт'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCharts() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Посещаемость по группам', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    color: Colors.grey.shade200,
                    child: const Center(child: Text('График посещаемости')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Финансовые показатели', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    color: Colors.grey.shade200,
                    child: const Center(child: Text('Финансовый график')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Детальная статистика', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              _buildStatisticItem('Общее количество детей', '245'),
              _buildStatisticItem('Средняя посещаемость', '91%'),
              _buildStatisticItem('Количество групп', '12'),
              _buildStatisticItem('Количество сотрудников', '38'),
              _buildStatisticItem('Количество курсов/кружков', '8'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body1),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Заглушки для оставшихся разделов
  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text('Календарь событий', style: AppTextStyles.h3),
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Предстоящие события', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          for (int i = 0; i < 3; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(Icons.event, color: AppColors.primary),
                ),
                title: Text('Событие ${i + 1}'),
                subtitle: Text('Описание события ${i + 1}'),
                trailing: Text('${i + 15}.06.2023'),
              ),
            ),
        ],
      ),
    );
  }

  // Заглушки для остальных разделов
  Widget _buildCoursesControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск курсов...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text('Курс ${index + 1}'),
              subtitle: Text('Описание курса ${index + 1}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  // Заглушки для меню и склада
  Widget _buildMenuControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'День недели',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: 'Понедельник',
              items:
                  ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница']
                      .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)),
                      )
                      .toList(),
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCalendar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          for (int i = 0; i < 5; i++)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: i == 0 ? AppColors.primary : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      ['Пн', 'Вт', 'Ср', 'Чт', 'Пт'][i],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: i == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      '${i + 15}',
                      style: TextStyle(
                        color: i == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Меню на день', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildMealSection('Завтрак', [
            'Каша овсяная',
            'Хлеб с маслом',
            'Чай',
          ]),
          _buildMealSection('Обед', [
            'Суп куриный',
            'Макароны с котлетой',
            'Компот',
          ]),
          _buildMealSection('Полдник', ['Творожная запеканка', 'Кефир']),
        ],
      ),
    );
  }

  Widget _buildMealSection(String title, List<String> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(item),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по складу...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInventoryCategory('Канцелярские товары'),
          _buildInventoryCategory('Игрушки'),
          _buildInventoryCategory('Мебель'),
          _buildInventoryCategory('Продукты питания'),
        ],
      ),
    );
  }

  Widget _buildInventoryCategory(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(title),
        children: [
          for (int i = 0; i < 3; i++)
            ListTile(
              title: Text('Товар ${i + 1}'),
              subtitle: Text('Количество: ${(i + 1) * 10} шт.'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(Icons.person, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Алия Каримовна Нурланова',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Директор ДДО',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfileStat('Опыт', '15 лет'),
                  const SizedBox(width: 24),
                  _buildProfileStat('Сотрудники', '38'),
                  const SizedBox(width: 24),
                  _buildProfileStat('Группы', '12'),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Редактировать профиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProfileSettings() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Настройки', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildSettingsItem(
            Icons.notifications_outlined,
            'Уведомления',
            'Настройте уведомления системы',
          ),
          _buildSettingsItem(
            Icons.lock_outline,
            'Безопасность',
            'Изменить пароль, настроить двухфакторную аутентификацию',
          ),
          _buildSettingsItem(
            Icons.school_outlined,
            'Информация об учреждении',
            'Редактировать данные об учреждении',
          ),
          _buildSettingsItem(
            Icons.help_outline,
            'Помощь',
            'Поддержка и руководство пользователя',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          final authController = Provider.of<AuthController>(
            context,
            listen: false,
          );
          // Выход из аккаунта
          authController.logout().then((_) {
            context.go('/login');
          });
        },
        icon: const Icon(Icons.logout),
        label: const Text('Выйти из аккаунта'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Добавляем новый метод для вкладки "Ещё"
  Widget _buildMoreTab() {
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

    // Список дополнительных сервисов
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Электронные документы',
        'icon': Icons.description,
        'description': 'Работа с официальными документами учреждения',
      },
      {
        'title': 'Отчетность',
        'icon': Icons.assessment,
        'description': 'Формирование и отправка отчетов',
      },
      {
        'title': 'Финансы',
        'icon': Icons.attach_money,
        'description': 'Управление финансами и платежами',
      },
      {
        'title': 'Мероприятия',
        'icon': Icons.event,
        'description': 'Планирование и проведение мероприятий',
      },
      {
        'title': 'Настройки учреждения',
        'icon': Icons.settings,
        'description': 'Общие настройки детского сада',
      },
      {
        'title': 'Уведомления',
        'icon': Icons.notifications,
        'description': 'Настройка и управление уведомлениями',
      },
      {
        'title': 'Интеграции',
        'icon': Icons.integration_instructions,
        'description': 'Подключение к внешним сервисам',
      },
      {
        'title': 'Архив',
        'icon': Icons.archive,
        'description': 'Архивные данные и документы',
      },
    ];

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Дополнительные сервисы', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Расширенные возможности для управления учреждением',
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
            AdaptiveText('Дополнительные сервисы', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Расширенные возможности для управления учреждением',
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isGrid
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 40, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Icon(icon, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
