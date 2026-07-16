import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../models/create_content_request.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import 'content_notifier.dart';
import 'create_content_notifier.dart';
import 'widgets/content_form.dart';

class CreateContentPage extends ConsumerStatefulWidget {
  const CreateContentPage({super.key});

  @override
  ConsumerState<CreateContentPage> createState() => _CreateContentPageState();
}

class _CreateContentPageState extends ConsumerState<CreateContentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final image = _imageController.text.trim();

    try {
      await ref
          .read(createContentNotifierProvider.notifier)
          .create(
            CreateContentRequest(
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              image: image.isEmpty ? null : image,
            ),
          );

      await ref.read(contentNotifierProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content created successfully')),
      );

      context.go('/content');
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createContentNotifierProvider).loading;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
          children: [
            Text(
              'Create Content',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black.withValues(alpha: 0.84),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Add new learning material for your content library.',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.48),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            Form(
              key: _formKey,
              child: ContentForm(
                titleController: _titleController,
                contentController: _contentController,
                imageController: _imageController,
                loading: isLoading,
                submitText: isLoading ? 'Creating...' : 'Create',
                submitCallback: _handleSubmit,
                cancelCallback: () => context.go('/content'),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Image upload is not available yet. Use a public image URL.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryColor.withValues(alpha: 0.72),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }
}
