import 'package:flutter/material.dart';

import '../../../shared/widgets/banner_card.dart';
import '../dashboard_dummy.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({required this.item, super.key});

  final FeaturedDashboardItem item;

  @override
  Widget build(BuildContext context) {
    return BannerCard(
      title: item.title,
      subtitle: item.subtitle,
      buttonText: item.buttonText,
      onPressed: () {},
    );
  }
}
