import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/app_category_chip.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({required this.categories, super.key});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return AppCategoryChip(
            title: categories[index],
            selected: index == 0,
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemCount: categories.length,
      ),
    );
  }
}
