import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/widgets/app_bottom_navigation.dart';
import 'dashboard_dummy.dart';
import 'widgets/category_list.dart';
import 'widgets/course_card_section.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_search_bar.dart';
import 'widgets/featured_banner.dart';
import 'widgets/popular_course_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              SizedBox(height: 24.h),
              const DashboardSearchBar(),
              SizedBox(height: 22.h),
              const CategoryList(categories: dashboardCategories),
              SizedBox(height: 24.h),
              const FeaturedBanner(item: featuredDashboardItem),
              SizedBox(height: 26.h),
              const PopularCourseSection(),
              SizedBox(height: 10.h),
              const CourseCardSection(courses: popularCourses),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}
