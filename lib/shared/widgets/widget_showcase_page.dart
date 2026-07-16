import 'package:flutter/material.dart';

import 'app_avatar.dart';
import 'app_bottom_navigation.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_category_chip.dart';
import 'app_search_bar.dart';
import 'app_section_title.dart';
import 'app_text_field.dart';
import 'banner_card.dart';
import 'content_card.dart';

class WidgetShowcasePage extends StatelessWidget {
  const WidgetShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Showcase')),
      bottomNavigationBar: const AppBottomNavigation(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            BannerCard(
              title: 'Learn faster with Adhivasindo',
              subtitle: 'Explore modern learning materials in one place.',
              buttonText: 'Start',
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            const AppSearchBar(hintText: 'Search lesson'),
            const SizedBox(height: 24),
            AppSectionTitle(
              title: 'Latest Content',
              actionText: 'See all',
              onActionPressed: () {},
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AppCategoryChip(title: 'All', selected: true, onTap: () {}),
                AppCategoryChip(title: 'Design', onTap: () {}),
                AppCategoryChip(title: 'Coding', onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),
            ContentCard(
              title: 'Frontend Modern dengan Flutter',
              author: 'Adhivasindo',
              date: '16 Jul 2026',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const AppTextField(
              hintText: 'Reusable input',
              prefixIcon: Icons.edit_rounded,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Primary Button',
              icon: Icons.arrow_forward_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'Secondary Button',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Row(
                children: [
                  const AppAvatar(radius: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Reusable white card with soft shadow.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
