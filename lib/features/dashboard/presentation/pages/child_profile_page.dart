import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/constants/app_dimensions.dart';
import 'package:super_app_kindergarten/core/constants/app_text_styles.dart';
import 'package:super_app_kindergarten/core/utils/screen_util.dart';
import 'package:super_app_kindergarten/shared/widgets/adaptive_widgets.dart';

class ChildProfilePage extends StatefulWidget {
  final Map<String, dynamic> childData;

  const ChildProfilePage({super.key, required this.childData});

  @override
  State<ChildProfilePage> createState() => _ChildProfilePageState();
}

class _ChildProfilePageState extends State<ChildProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Инициализируем ScreenUtil для получения правильных размеров экрана
    ScreenUtil.init(context);

    final String childName = widget.childData['name'] as String;
    final int childAge = widget.childData['age'] as int;
    final String childGroup = widget.childData['group'] as String;

    String ageText = '$childAge ';
    if (childAge % 10 == 1 && childAge % 100 != 11) {
      ageText += 'год';
    } else if ((childAge % 10 == 2 ||
            childAge % 10 == 3 ||
            childAge % 10 == 4) &&
        (childAge % 100 < 10 || childAge % 100 >= 20)) {
      ageText += 'года';
    } else {
      ageText += 'лет';
    }

    return AdaptiveLayout(
      // Мобильный вид
      mobile: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight:
                      250, // Увеличена высота для лучшего отображения
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 40, // Увеличиваем радиус аватара
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: Text(
                            childName.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 32, // Увеличиваем размер шрифта
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Увеличиваем отступ
                        Text(
                          childName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil.adaptiveValue(
                              mobile: 20.0, // Увеличиваем шрифт
                              tablet: 22.0,
                              desktop: 24.0,
                            ),
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    titlePadding: const EdgeInsets.only(
                      bottom: 60,
                    ), // Значительно увеличиваем отступ снизу, чтобы поднять содержимое
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: AppColors.mainGradient,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        isScrollable: false,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          SizedBox(
                            width: ScreenUtil.adaptiveValue(
                              mobile: ScreenUtil.screenWidth / 4 - 10,
                              tablet: 100,
                              desktop: 120,
                            ),
                            child: const Tab(text: 'Профиль'),
                          ),
                          SizedBox(
                            width: ScreenUtil.adaptiveValue(
                              mobile: ScreenUtil.screenWidth / 4 - 10,
                              tablet: 100,
                              desktop: 120,
                            ),
                            child: const Tab(text: 'Дневник'),
                          ),
                          SizedBox(
                            width: ScreenUtil.adaptiveValue(
                              mobile: ScreenUtil.screenWidth / 4 - 10,
                              tablet: 100,
                              desktop: 120,
                            ),
                            child: const Tab(text: 'Расписание'),
                          ),
                          SizedBox(
                            width: ScreenUtil.adaptiveValue(
                              mobile: ScreenUtil.screenWidth / 4 - 10,
                              tablet: 100,
                              desktop: 120,
                            ),
                            child: const Tab(text: 'Меню'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(childName, ageText, childGroup),
              _buildDiaryTab(),
              _buildScheduleTab(),
              _buildMenuTab(),
            ],
          ),
        ),
      ),

      // Планшетный и десктопный вид - двухпанельный интерфейс
      tablet: Scaffold(
        appBar: AppBar(
          title: AdaptiveText('Профиль ребенка: $childName'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Row(
          children: [
            // Левая панель с информацией о ребенке
            Container(
              width: ScreenUtil.adaptiveValue(
                mobile: 0, // Не используется в мобильном
                tablet: ScreenUtil.screenWidth * 0.3,
                desktop: ScreenUtil.screenWidth * 0.25,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  AppDimensions.getAdaptivePadding(AppDimensions.padding16),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: AppDimensions.getAdaptivePadding(
                        AppDimensions.spacingLarge,
                      ),
                    ),
                    // Увеличенный аватар с хорошим контрастом
                    CircleAvatar(
                      radius: ScreenUtil.adaptiveValue(
                        mobile: 60,
                        tablet: 100,
                        desktop: 100,
                      ),
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        childName.substring(0, 1),
                        style: TextStyle(
                          fontSize: ScreenUtil.adaptiveValue(
                            mobile: 48,
                            tablet: 80,
                            desktop: 80,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.getAdaptivePadding(
                        AppDimensions
                            .spacingLarge, // Увеличенный отступ для лучшего разделения
                      ),
                    ),
                    // Увеличенный размер текста имени для лучшей читаемости
                    Container(
                      width: double.infinity,
                      child: AdaptiveText(
                        childName,
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ScreenUtil.adaptiveValue(
                            mobile: 24,
                            tablet: 30,
                            desktop: 32,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AdaptiveText(
                      ageText,
                      style: AppTextStyles.body1,
                      textAlign: TextAlign.center,
                    ),
                    AdaptiveText(
                      childGroup,
                      style: AppTextStyles.body1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: AppDimensions.getAdaptivePadding(
                        AppDimensions.spacingLarge,
                      ),
                    ),
                    const Divider(),
                    _buildSidebarMenuItem(
                      'Профиль',
                      Icons.person,
                      _tabController.index == 0,
                      () {
                        setState(() {
                          _tabController.animateTo(0);
                        });
                      },
                    ),
                    _buildSidebarMenuItem(
                      'Дневник',
                      Icons.book,
                      _tabController.index == 1,
                      () {
                        setState(() {
                          _tabController.animateTo(1);
                        });
                      },
                    ),
                    _buildSidebarMenuItem(
                      'Расписание',
                      Icons.calendar_today,
                      _tabController.index == 2,
                      () {
                        setState(() {
                          _tabController.animateTo(2);
                        });
                      },
                    ),
                    _buildSidebarMenuItem(
                      'Меню',
                      Icons.restaurant_menu,
                      _tabController.index == 3,
                      () {
                        setState(() {
                          _tabController.animateTo(3);
                        });
                      },
                    ),
                    const Divider(),
                    SizedBox(
                      height: AppDimensions.getAdaptivePadding(
                        AppDimensions.spacingMedium,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Действие "Редактировать профиль"
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Редактировать'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Правая панель с содержимым
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfileTab(childName, ageText, childGroup),
                  _buildDiaryTab(),
                  _buildScheduleTab(),
                  _buildMenuTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarMenuItem(
    String title,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.primary : Colors.grey,
        size: AppDimensions.getAdaptiveIconSize(AppDimensions.iconSizeMedium),
      ),
      title: AdaptiveText(
        title,
        style: TextStyle(
          color: isActive ? AppColors.primary : Colors.grey.shade700,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isActive ? AppColors.primary.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppDimensions.getAdaptiveRadius(AppDimensions.radius8),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildProfileTab(String name, String age, String group) {
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

    // Для больших экранов используем горизонтальное разделение контента
    final bool isWideScreen =
        ScreenUtil.isMediumScreen() || ScreenUtil.isLargeScreen();

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child:
          isWideScreen
              // Широкий экран - два столбца информации
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Левая колонка
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard('Основная информация', [
                          _buildInfoRow('Имя', name),
                          _buildInfoRow('Возраст', age),
                          _buildInfoRow('Группа', group),
                          _buildInfoRow('Дата поступления', '01.09.2023'),
                        ]),
                        SizedBox(height: spacingLarge),
                        _buildInfoCard('Здоровье', [
                          _buildInfoRow('Рост', '110 см'),
                          _buildInfoRow('Вес', '18 кг'),
                          _buildInfoRow('Аллергии', 'Нет'),
                        ]),
                      ],
                    ),
                  ),

                  SizedBox(width: spacing),

                  // Правая колонка
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard('Достижения', [
                          _buildAchievementItem(
                            'Лучший чтец',
                            'Конкурс чтецов "Осень золотая"',
                            '15.10.2023',
                          ),
                          const Divider(),
                          _buildAchievementItem(
                            'Участник',
                            'Спортивные соревнования "Веселые старты"',
                            '20.11.2023',
                          ),
                        ]),
                        SizedBox(height: spacingLarge),
                        _buildInfoCard('Контактная информация', [
                          _buildInfoRow('Родитель', 'Хамза Кабылбек'),
                          _buildInfoRow('Телефон', '+7 (777) 123-45-67'),
                          _buildInfoRow('Email', 'kabylbek@gmail.com'),
                        ]),
                      ],
                    ),
                  ),
                ],
              )
              // Узкий экран - вертикальное расположение
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard('Основная информация', [
                    _buildInfoRow('Имя', name),
                    _buildInfoRow('Возраст', age),
                    _buildInfoRow('Группа', group),
                    _buildInfoRow('Дата поступления', '01.09.2023'),
                  ]),
                  SizedBox(height: spacingLarge),
                  _buildInfoCard('Здоровье', [
                    _buildInfoRow('Рост', '110 см'),
                    _buildInfoRow('Вес', '18 кг'),
                    _buildInfoRow('Аллергии', 'Нет'),
                  ]),
                  SizedBox(height: spacingLarge),
                  _buildInfoCard('Достижения', [
                    _buildAchievementItem(
                      'Лучший чтец',
                      'Конкурс чтецов "Осень золотая"',
                      '15.10.2023',
                    ),
                    const Divider(),
                    _buildAchievementItem(
                      'Участник',
                      'Спортивные соревнования "Веселые старты"',
                      '20.11.2023',
                    ),
                  ]),
                ],
              ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText(title, style: AppTextStyles.h3),
            SizedBox(height: spacing),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.getAdaptivePadding(AppDimensions.spacingSmall),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AdaptiveText(label, style: AppTextStyles.body2),
          AdaptiveText(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String description, String date) {
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.getAdaptivePadding(AppDimensions.spacingSmall),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.getAdaptivePadding(8)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: AppColors.primary,
              size: iconSize,
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveText(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AdaptiveText(description, style: AppTextStyles.body2),
                AdaptiveText(
                  date,
                  style: AppTextStyles.body3.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    // Получаем данные дневника (в реальном приложении они будут загружаться из API)
    final List<Map<String, dynamic>> diaryEntries = List.generate(
      5,
      (index) => {
        'date': '${index + 1} Сентября, 2023',
        'dayOfWeek':
            index == 0
                ? 'Понедельник'
                : (index == 1
                    ? 'Вторник'
                    : (index == 2
                        ? 'Среда'
                        : (index == 3 ? 'Четверг' : 'Пятница'))),
        'content':
            'Сегодня ребенок активно участвовал в занятиях, выполнил все задания по математике и чтению. Хорошо кушал, особенно на обед.',
        'activities': ['Математика', 'Чтение', 'Прогулка', 'Сон'],
        'activityIcons': [
          Icons.calculate,
          Icons.book,
          Icons.park,
          Icons.nightlight,
        ],
      },
    );

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];
          return Card(
            margin: EdgeInsets.only(bottom: spacing),
            elevation: AppDimensions.elevationSmall,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdaptiveText(entry['date'], style: AppTextStyles.h3),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.getAdaptivePadding(
                            AppDimensions.padding8,
                          ),
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AdaptiveText(
                          entry['dayOfWeek'],
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  AdaptiveText(entry['content']),
                  SizedBox(height: spacing),
                  Wrap(
                    spacing: AppDimensions.getAdaptivePadding(
                      AppDimensions.spacingSmall,
                    ),
                    runSpacing: AppDimensions.getAdaptivePadding(
                      AppDimensions.spacingSmall,
                    ),
                    children: List.generate(
                      entry['activities'].length,
                      (i) => _buildActivityChip(
                        entry['activities'][i],
                        entry['activityIcons'][i],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Планшетный и десктопный вид - календарный формат
      tablet: Column(
        children: [
          // Верхняя панель с фильтрами и выбором месяца
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdaptiveText(
                  'Дневник - Сентябрь 2023',
                  style: AppTextStyles.h2,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () {},
                    ),
                    AdaptiveText('Сентябрь', style: AppTextStyles.body1),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Сетка календаря
          Container(
            padding: EdgeInsets.all(padding),
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30, // 30 дней в месяце
              itemBuilder: (context, index) {
                final bool isActive =
                    index < 5; // Первые 5 дней имеют записи в дневнике
                final bool isToday = index == 0;

                return GestureDetector(
                  onTap: isActive ? () {} : null,
                  child: Container(
                    width: 60,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color:
                          isToday
                              ? AppColors.primary
                              : (isActive
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.getAdaptiveRadius(AppDimensions.radius8),
                      ),
                      border:
                          isActive && !isToday
                              ? Border.all(color: AppColors.primary)
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AdaptiveText(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                isToday
                                    ? Colors.white
                                    : (isActive
                                        ? AppColors.primary
                                        : Colors.grey),
                          ),
                        ),
                        AdaptiveText(
                          index == 0
                              ? 'Пн'
                              : (index == 1
                                  ? 'Вт'
                                  : (index == 2
                                      ? 'Ср'
                                      : (index == 3
                                          ? 'Чт'
                                          : (index == 4
                                              ? 'Пт'
                                              : (index == 5 ? 'Сб' : 'Вс'))))),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isToday
                                    ? Colors.white
                                    : (isActive
                                        ? AppColors.primary
                                        : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Содержимое дневника
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(padding),
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                final entry = diaryEntries[index];

                return Card(
                  margin: EdgeInsets.only(bottom: spacing),
                  elevation: AppDimensions.elevationSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Левая часть с датой и днем недели
                        Container(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdaptiveText(
                                entry['date'],
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AdaptiveText(
                                entry['dayOfWeek'],
                                style: TextStyle(color: AppColors.primary),
                              ),
                              SizedBox(height: spacing),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.event_note,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Вертикальный разделитель
                        Container(
                          width: 1,
                          height: 120,
                          color: Colors.grey.shade300,
                          margin: EdgeInsets.symmetric(horizontal: spacing),
                        ),

                        // Правая часть с содержимым
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdaptiveText(
                                'Дневная запись',
                                style: AppTextStyles.h3,
                              ),
                              SizedBox(height: 8),
                              AdaptiveText(entry['content']),
                              SizedBox(height: spacing),
                              Wrap(
                                spacing: AppDimensions.getAdaptivePadding(
                                  AppDimensions.spacingSmall,
                                ),
                                runSpacing: AppDimensions.getAdaptivePadding(
                                  AppDimensions.spacingSmall,
                                ),
                                children: List.generate(
                                  entry['activities'].length,
                                  (i) => _buildActivityChip(
                                    entry['activities'][i],
                                    entry['activityIcons'][i],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChip(String label, IconData icon) {
    final double iconSize = ScreenUtil.adaptiveValue(
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );

    return Chip(
      avatar: Icon(icon, size: iconSize, color: AppColors.primary),
      label: AdaptiveText(label),
      backgroundColor: AppColors.backgroundSecondary,
      labelPadding: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(
        ScreenUtil.adaptiveValue(mobile: 2.0, tablet: 4.0, desktop: 6.0),
      ),
    );
  }

  Widget _buildScheduleTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    List<Map<String, dynamic>> scheduleItems = [
      {
        'time': '09:00 - 09:30',
        'activity': 'Утренняя зарядка',
        'icon': Icons.fitness_center,
      },
      {
        'time': '09:30 - 10:00',
        'activity': 'Завтрак',
        'icon': Icons.restaurant,
      },
      {
        'time': '10:00 - 10:45',
        'activity': 'Развитие речи',
        'icon': Icons.record_voice_over,
      },
      {
        'time': '11:00 - 11:45',
        'activity': 'Математика',
        'icon': Icons.calculate,
      },
      {'time': '12:00 - 12:30', 'activity': 'Прогулка', 'icon': Icons.park},
      {'time': '12:30 - 13:00', 'activity': 'Обед', 'icon': Icons.lunch_dining},
      {
        'time': '13:00 - 15:00',
        'activity': 'Дневной сон',
        'icon': Icons.nightlight,
      },
      {'time': '15:15 - 15:30', 'activity': 'Полдник', 'icon': Icons.cake},
      {'time': '15:30 - 16:15', 'activity': 'Творчество', 'icon': Icons.brush},
      {
        'time': '16:30 - 17:30',
        'activity': 'Свободные игры',
        'icon': Icons.toys,
      },
      {
        'time': '17:30 - 18:00',
        'activity': 'Ужин',
        'icon': Icons.dinner_dining,
      },
    ];

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Расписание на понедельник', style: AppTextStyles.h3),
            SizedBox(height: spacing),
            Card(
              margin: EdgeInsets.zero,
              elevation: AppDimensions.elevationSmall,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scheduleItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = scheduleItems[index];
                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(
                        AppDimensions.getAdaptivePadding(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: AppDimensions.getAdaptiveIconSize(24),
                      ),
                    ),
                    title: AdaptiveText(
                      item['activity'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: AdaptiveText(item['time'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Планшетный и десктопный вид - временная шкала
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdaptiveText('Расписание на неделю', style: AppTextStyles.h2),
                DropdownButton<String>(
                  value: 'Понедельник',
                  items:
                      ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница']
                          .map(
                            (day) =>
                                DropdownMenuItem(value: day, child: Text(day)),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    // Смена дня недели
                  },
                ),
              ],
            ),
            SizedBox(height: spacing),

            // Временная шкала с расписанием
            Card(
              margin: EdgeInsets.zero,
              elevation: AppDimensions.elevationSmall,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Временная шкала слева
                    Container(
                      width: 80,
                      child: Column(
                        children: [
                          ...List.generate(
                            10,
                            (index) => Container(
                              height: 60,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                '${index + 9}:00',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Вертикальная линия
                    Container(
                      width: 1,
                      height: 600, // Высота временной шкалы
                      color: Colors.grey.shade300,
                      margin: EdgeInsets.only(right: spacing),
                    ),

                    // Активности
                    Expanded(
                      child: Stack(
                        children:
                            scheduleItems.map((item) {
                              // Определяем положение и высоту элемента на основе времени
                              final timeParts = item['time'].toString().split(
                                ' - ',
                              );
                              final startHour = int.parse(
                                timeParts[0].split(':')[0],
                              );
                              final startMinute = int.parse(
                                timeParts[0].split(':')[1],
                              );
                              final endHour = int.parse(
                                timeParts[1].split(':')[0],
                              );
                              final endMinute = int.parse(
                                timeParts[1].split(':')[1],
                              );

                              final topPosition =
                                  (startHour - 9) * 60 + startMinute;
                              final height =
                                  (endHour * 60 + endMinute) -
                                  (startHour * 60 + startMinute);

                              return Positioned(
                                top: topPosition.toDouble(),
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: height.toDouble(),
                                  margin: EdgeInsets.only(bottom: 2),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        item['icon'] as IconData,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item['activity'] as String,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              item['time'] as String,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    List<String> daysOfWeek = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
    ];

    return AdaptiveLayout(
      // Мобильный вид - табы по дням недели
      mobile: DefaultTabController(
        length: daysOfWeek.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: daysOfWeek.map((day) => Tab(text: day)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: daysOfWeek.map((day) => _buildDayMenu(day)).toList(),
              ),
            ),
          ],
        ),
      ),

      // Планшетный и десктопный вид - развернутое меню на неделю
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Меню питания на неделю', style: AppTextStyles.h2),
            SizedBox(height: spacing),

            // Таблица меню на неделю
            Card(
              margin: EdgeInsets.zero,
              elevation: AppDimensions.elevationSmall,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    // Заголовок таблицы с днями недели
                    Row(
                      children: [
                        Container(
                          width: 120,
                          padding: EdgeInsets.all(padding * 0.5),
                          child: AdaptiveText(
                            'Приём пищи',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ...daysOfWeek.map(
                          (day) => Expanded(
                            child: Container(
                              padding: EdgeInsets.all(padding * 0.5),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AdaptiveText(
                                day,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: spacing),

                    // Строки таблицы - типы приемов пищи
                    ..._buildMenuTableRows([
                      'Завтрак',
                      'Обед',
                      'Полдник',
                      'Ужин',
                    ], daysOfWeek),
                  ],
                ),
              ),
            ),

            SizedBox(height: spacing),

            // Легенда аллергенов
            Card(
              margin: EdgeInsets.zero,
              elevation: AppDimensions.elevationSmall,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'Информация об аллергенах',
                      style: AppTextStyles.h3,
                    ),
                    SizedBox(height: spacing * 0.5),
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing * 0.5,
                      children: [
                        _buildAllergenChip('Глютен', Colors.amber),
                        _buildAllergenChip('Молоко', Colors.blue.shade200),
                        _buildAllergenChip('Орехи', Colors.brown.shade300),
                        _buildAllergenChip('Яйца', Colors.yellow.shade200),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный метод для создания строк таблицы меню
  List<Widget> _buildMenuTableRows(List<String> mealTypes, List<String> days) {
    final Map<String, List<String>> mealsByDay = {
      'Понедельник': [
        'Каша овсяная, хлеб с маслом, чай',
        'Суп с фрикадельками, макароны с котлетой, компот',
        'Йогурт, печенье',
        'Творожная запеканка, кефир',
      ],
      'Вторник': [
        'Каша манная, бутерброд с сыром, какао',
        'Борщ, рис с тефтелями, салат, компот',
        'Фрукты, сок',
        'Запеканка картофельная, чай',
      ],
      'Среда': [
        'Омлет, хлеб с джемом, чай',
        'Щи, гречка с гуляшом, компот',
        'Сырники со сметаной',
        'Рыба с овощами, кисель',
      ],
      'Четверг': [
        'Каша рисовая, хлеб с маслом, чай',
        'Рассольник, картофельное пюре с курицей, компот',
        'Булочка, молоко',
        'Макароны с сыром, чай',
      ],
      'Пятница': [
        'Каша пшенная, бутерброд с сыром, какао',
        'Суп овощной, плов, компот',
        'Фрукты, кефир',
        'Овощное рагу с курицей, чай',
      ],
    };

    return mealTypes.map((meal) {
      int index = mealTypes.indexOf(meal);

      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Тип приема пищи
            Container(
              width: 120,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    index == 0
                        ? Icons.free_breakfast
                        : (index == 1
                            ? Icons.lunch_dining
                            : (index == 2 ? Icons.cake : Icons.dinner_dining)),
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: AdaptiveText(
                      meal,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Содержимое меню по дням недели
            ...days.map(
              (day) => Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(left: 4),
                  height: 80,
                  child: AdaptiveText(
                    mealsByDay[day]![index],
                    style: AppTextStyles.body3,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // Метод для создания чипа аллергена
  Widget _buildAllergenChip(String name, Color color) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 8),
      label: AdaptiveText(name),
      backgroundColor: Colors.grey.shade100,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildDayMenu(String day) {
    Map<String, List<String>> meals = {
      'Завтрак': ['Каша овсяная', 'Хлеб с маслом', 'Чай с молоком'],
      'Обед': [
        'Суп с фрикадельками',
        'Макароны с котлетой',
        'Салат из свежих овощей',
        'Компот',
      ],
      'Полдник': ['Йогурт', 'Печенье'],
      'Ужин': ['Творожная запеканка', 'Кефир'],
    };

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppDimensions.getAdaptivePadding(AppDimensions.padding16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...meals.entries.map(
            (entry) => _buildMealSection(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(String mealTitle, List<String> dishes) {
    IconData iconData;
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingSmall,
    );
    final double spacingMedium = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    switch (mealTitle) {
      case 'Завтрак':
        iconData = Icons.free_breakfast;
        break;
      case 'Обед':
        iconData = Icons.lunch_dining;
        break;
      case 'Полдник':
        iconData = Icons.cake;
        break;
      case 'Ужин':
        iconData = Icons.dinner_dining;
        break;
      default:
        iconData = Icons.restaurant;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: AppColors.primary, size: iconSize),
            ),
            SizedBox(width: spacingMedium),
            AdaptiveText(mealTitle, style: AppTextStyles.h3),
          ],
        ),
        SizedBox(height: spacing),
        Card(
          margin: EdgeInsets.only(
            left: AppDimensions.getAdaptivePadding(AppDimensions.padding24),
            bottom: AppDimensions.getAdaptivePadding(
              AppDimensions.spacingLarge,
            ),
          ),
          elevation: AppDimensions.elevationSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  dishes
                      .map(
                        (dish) => Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: spacing),
                              AdaptiveText(dish),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
