import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/content_card.dart';
import '../dashboard_dummy.dart';

class CourseCardSection extends StatelessWidget {
  const CourseCardSection({required this.courses, super.key});

  final List<PopularCourseItem> courses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final course = courses[index];

        return ContentCard(
          title: course.title,
          author: course.author,
          date: '${course.category} - ${course.date}',
          imageUrl: course.imageUrl,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemCount: courses.length,
    );
  }
}
