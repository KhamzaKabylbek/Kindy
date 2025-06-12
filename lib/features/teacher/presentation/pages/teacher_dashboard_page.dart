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

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _groups = [
    {'name': 'Старшая группа "Солнышко"', 'count': 15, 'age': '5-6 лет'},
    {'name': 'Средняя группа "Звездочки"', 'count': 12, 'age': '4-5 лет'},
  ];

  @override
  void initState() {
    super.initState();
    print('TeacherDashboardPage: initState вызван');

    // Отложим проверку пользователя до построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserRole();
    });
  }

  void _checkUserRole() {
    // Проверяем текущего пользователя и его роль
    final authController = Provider.of<AuthController>(context, listen: false);
    print(
      'TeacherDashboardPage: Роль пользователя: ${authController.userDetails?.role}',
    );
    print(
      'TeacherDashboardPage: Данные пользователя: ${authController.userDetails?.toJson()}',
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
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
                label: Text('Мои группы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: Text('Расписание'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.trending_up_outlined),
                selectedIcon: Icon(Icons.trending_up),
                label: Text('Успеваемость'),
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
                    return _buildGroupsTab();
                  case 2:
                    return _buildScheduleTab();
                  case 3:
                    return _buildAcademicPerformanceTab();
                  case 4:
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
        return _buildGroupsTab();
      case 2:
        return _buildScheduleTab();
      case 3:
        return _buildAcademicPerformanceTab();
      case 4:
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
          icon: Icon(Icons.groups_outlined),
          activeIcon: Icon(Icons.groups),
          label: 'Группы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Расписание',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_outlined),
          activeIcon: Icon(Icons.trending_up),
          label: 'Успеваемость',
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
            _buildHeader('Личный кабинет воспитателя'),
            _buildWelcomeCard(),
            _buildNewsSection(),
            _buildTodaySchedule(),
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
          children: [_buildHeader('Мои группы'), ..._buildGroupsCards()],
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

  Widget _buildAcademicPerformanceTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Успеваемость'),
            _buildGroupSelector(),
            _buildPerformanceReport(),
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
                          'Здравствуйте, Анна Ивановна!',
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
                'У вас 5 запланированных мероприятий на сегодня',
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
                      child: const Text('Расписание на сегодня'),
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

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Новости и объявления', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          // Список новостей в стиле Instagram
          _buildNewsItem(
            title:
                'Рады сообщить: в нашем садике открывается шахматный кружок для детей старших групп! 🎉',
            content:
                'Шахматы помогают развивать внимание, мышление и усидчивость — и всё это в игровой форме.',
            date: 'сегодня в 10:25',
            imageUrl: 'assets/images/Image3.png',
            likes: 26,
            comments: 11,
            hasLiked: false,
          ),
          const SizedBox(height: 12),
          _buildNewsItem(
            title:
                'Сегодня в нашем саду прошел день открытых дверей! Благодарим всех родителей, которые смогли присутствовать и познакомиться с нашими воспитателями и программой обучения.',
            content: '',
            date: 'вчера в 15:40',
            imageUrl: '',
            likes: 42,
            comments: 8,
            hasLiked: true,
          ),
          const SizedBox(height: 12),
          _buildNewsItem(
            title:
                'В методическом кабинете обновлены материалы по развитию речи у дошкольников.',
            content: '',
            date: '3 дня назад',
            imageUrl: '',
            likes: 38,
            comments: 15,
            hasLiked: false,
          ),
        ],
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

            // Заменяем на новый виджет для социальных действий
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

  Widget _buildTodaySchedule() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Расписание на сегодня', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildScheduleItem('08:00 - 08:30', 'Прием детей'),
          _buildScheduleItem('08:30 - 09:00', 'Утренняя зарядка'),
          _buildScheduleItem('09:00 - 09:30', 'Завтрак'),
          _buildScheduleItem('09:30 - 10:30', 'Занятие: Развитие речи'),
          _buildScheduleItem('10:30 - 11:30', 'Прогулка'),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 2; // Переход на вкладку "Расписание"
                });
              },
              child: Text(
                'Показать полное расписание',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(activity, style: AppTextStyles.body1)),
        ],
      ),
    );
  }

  List<Widget> _buildGroupsCards() {
    return _groups.map((group) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                        Icons.groups,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group['name'], style: AppTextStyles.h3),
                          const SizedBox(height: 4),
                          Text(
                            'Возраст: ${group['age']}',
                            style: AppTextStyles.body1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Статистика группы в виде карточек
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGroupStatCard(
                      icon: Icons.people,
                      title: 'Всего детей',
                      value: group['count'].toString(),
                    ),
                    _buildGroupStatCard(
                      icon: Icons.check_circle,
                      title: 'Присутствует',
                      value: (group['count'] - 2).toString(),
                    ),
                    _buildGroupStatCard(
                      icon: Icons.boy,
                      title: 'Мальчики',
                      value: (group['count'] ~/ 2).toString(),
                    ),
                    _buildGroupStatCard(
                      icon: Icons.girl,
                      title: 'Девочки',
                      value:
                          (group['count'] ~/ 2 + group['count'] % 2).toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Список детей'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check),
                        label: const Text('Отметить посещаемость'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildGroupStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: AppTextStyles.h3),
                Text(
                  title,
                  style: AppTextStyles.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    // Текущая дата
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    // Пример важных дат для отметки
    final List<int> importantDates = [5, 12, 15, 20, 28];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Календарь', style: AppTextStyles.h3),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16),
                            onPressed: () {},
                          ),
                          Text(
                            '${_getMonthName(currentMonth)} $currentYear',
                            style: AppTextStyles.h3,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Дни недели
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
                            .map(
                              (day) => Expanded(
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        day == 'Сб' || day == 'Вс'
                                            ? Colors.red
                                            : Colors.black54,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  // Сетка календаря
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1.0,
                        ),
                    itemCount:
                        daysInMonth +
                        DateTime(currentYear, currentMonth, 1).weekday -
                        1,
                    itemBuilder: (context, index) {
                      final int day =
                          index -
                          DateTime(currentYear, currentMonth, 1).weekday +
                          2;
                      if (day <= 0) {
                        return const SizedBox.shrink();
                      }

                      final bool isToday = day == now.day;
                      final bool isImportant = importantDates.contains(day);

                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color:
                              isToday
                                  ? AppColors.primary
                                  : isImportant
                                  ? AppColors.primary.withOpacity(0.2)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isToday || isImportant
                                    ? Colors.transparent
                                    : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color:
                                  isToday
                                      ? Colors.white
                                      : isImportant
                                      ? AppColors.primary
                                      : null,
                              fontWeight:
                                  isToday || isImportant
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Легенда
                  Row(
                    children: [
                      _buildCalendarLegendItem(
                        color: AppColors.primary,
                        text: 'Сегодня',
                      ),
                      const SizedBox(width: 16),
                      _buildCalendarLegendItem(
                        color: AppColors.primary.withOpacity(0.2),
                        text: 'События',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarLegendItem({
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return monthNames[month - 1];
  }

  Widget _buildEventsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Предстоящие события', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildEventItem(
            'Родительское собрание',
            '15.11.2023 18:00',
            'Обсуждение планов на следующий квартал',
            isToday: false,
          ),
          _buildEventItem(
            'Утренник "Осенние мотивы"',
            '20.11.2023 10:00',
            'Подготовка костюмов и декораций',
            isToday: false,
          ),
          _buildEventItem(
            'Методическое совещание',
            '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} 13:30',
            'Обсуждение новых методик обучения',
            isToday: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(
    String title,
    String datetime,
    String description, {
    bool isToday = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isToday ? AppColors.primary.withOpacity(0.05) : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isToday
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.event,
                color:
                    isToday
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(title, style: AppTextStyles.h3)),
                      if (isToday)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Сегодня',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(datetime, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text(description, style: AppTextStyles.body1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Выберите группу',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        value: _groups[0]['name'],
        items:
            _groups.map((group) {
              return DropdownMenuItem<String>(
                value: group['name'],
                child: Text(group['name']),
              );
            }).toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildPerformanceReport() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Отчет по успеваемости', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  _buildPerformanceChart(),
                  const SizedBox(height: 16),
                  const Text(
                    'В группе "Старшая группа Солнышко" наблюдается стабильный прогресс в освоении материала. 80% детей показывают высокие результаты в развитии речи, 75% - в математических навыках.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Внести новые оценки'),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Индивидуальные показатели', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder:
                        (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Ребенок ${index + 1}'),
                        subtitle: Text('Общий прогресс: ${85 - index * 5}%'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    // Заглушка для графика успеваемости
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('График успеваемости')),
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
                'Анна Ивановна Петрова',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Воспитатель высшей категории',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfileStat('Стаж', '12 лет'),
                  const SizedBox(width: 24),
                  _buildProfileStat('Группы', '2'),
                  const SizedBox(width: 24),
                  _buildProfileStat('Дети', '27'),
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
}
