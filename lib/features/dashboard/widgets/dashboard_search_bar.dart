import 'package:flutter/material.dart';

import '../../../shared/widgets/app_search_bar.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSearchBar(hintText: 'Search course...', readOnly: true);
  }
}
