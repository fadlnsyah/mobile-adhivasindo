import 'package:flutter/material.dart';

import '../../../shared/widgets/app_section_title.dart';

class PopularCourseSection extends StatelessWidget {
  const PopularCourseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSectionTitle(
      title: 'Popular Courses',
      actionText: 'See All',
      onActionPressed: () {},
    );
  }
}
