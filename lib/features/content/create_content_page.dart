import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../models/create_content_request.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';
import 'content_notifier.dart';
import 'create_content_notifier.dart';

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

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';

    if (title.isEmpty) {
      return 'Title wajib diisi';
    }

    if (title.length < 3) {
      return 'Title minimal 3 karakter';
    }

    if (title.length > 255) {
      return 'Title maksimal 255 karakter';
    }

    return null;
  }

  String? _validateContent(String? value) {
    final content = value?.trim() ?? '';

    if (content.isEmpty) {
      return 'Content wajib diisi';
    }

    return null;
  }

  String? _validateImageUrl(String? value) {
    final image = value?.trim() ?? '';

    if (image.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(image);

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Image harus berupa URL valid';
    }

    return null;
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
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _titleController,
                      hintText: 'Title',
                      prefixIcon: Icons.title_rounded,
                      readOnly: isLoading,
                      validator: _validateTitle,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _contentController,
                      hintText: 'Content',
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      minLines: 5,
                      prefixIcon: Icons.notes_rounded,
                      readOnly: isLoading,
                      validator: _validateContent,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _imageController,
                      hintText: 'Image URL',
                      keyboardType: TextInputType.url,
                      prefixIcon: Icons.link_rounded,
                      readOnly: isLoading,
                      validator: _validateImageUrl,
                    ),
                    SizedBox(height: 24.h),
                    AppButton(
                      text: isLoading ? 'Creating...' : 'Create',
                      icon: Icons.add_rounded,
                      onPressed: isLoading ? null : _handleSubmit,
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      text: 'Cancel',
                      variant: AppButtonVariant.secondary,
                      onPressed: isLoading
                          ? null
                          : () => context.go('/content'),
                    ),
                  ],
                ),
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
    );
  }
}
