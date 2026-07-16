import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/storage/auth_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../shared/widgets/app_avatar.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../../shared/widgets/app_category_chip.dart';
import '../../shared/widgets/app_search_bar.dart';
import '../../shared/widgets/app_section_title.dart';
import '../../shared/widgets/banner_card.dart';
import '../../shared/widgets/content_card.dart';
import 'dashboard_dummy.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<UserModel?>(
                future: AuthStorage().getUser(),
                builder: (context, snapshot) {
                  final userName = snapshot.data?.name ?? 'John Doe';

                  return Row(
                    children: [
                      const AppAvatar(radius: 28),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.black.withValues(alpha: 0.84),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 44.w,
                        width: 44.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 18,
                              color: Colors.black.withValues(alpha: 0.06),
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 24.h),
              const AppSearchBar(hintText: 'Search course...', readOnly: true),
              SizedBox(height: 22.h),
              SizedBox(
                height: 46.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AppCategoryChip(
                      title: dashboardCategories[index],
                      selected: index == 0,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10.w),
                  itemCount: dashboardCategories.length,
                ),
              ),
              SizedBox(height: 24.h),
              BannerCard(
                title: featuredDashboardItem.title,
                subtitle: featuredDashboardItem.subtitle,
                buttonText: featuredDashboardItem.buttonText,
                onPressed: () {},
              ),
              SizedBox(height: 26.h),
              AppSectionTitle(
                title: 'Popular Courses',
                actionText: 'See All',
                onActionPressed: () {},
              ),
              SizedBox(height: 10.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final course = popularCourses[index];

                  return ContentCard(
                    title: course.title,
                    author: course.author,
                    date: '${course.category} • ${course.date}',
                    imageUrl: course.imageUrl,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 14.h),
                itemCount: popularCourses.length,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}
