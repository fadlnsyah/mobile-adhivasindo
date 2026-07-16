import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';

class CreateContentPage extends StatefulWidget {
  const CreateContentPage({super.key});

  @override
  State<CreateContentPage> createState() => _CreateContentPageState();
}

class _CreateContentPageState extends State<CreateContentPage> {
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

    if (uri == null || !uri.hasAbsolutePath || !uri.hasScheme) {
      return 'Image harus berupa URL valid';
    }

    return null;
  }

  void _handleSubmit() {
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
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
                      validator: _validateContent,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _imageController,
                      hintText: 'Image URL',
                      keyboardType: TextInputType.url,
                      prefixIcon: Icons.link_rounded,
                      validator: _validateImageUrl,
                    ),
                    SizedBox(height: 24.h),
                    AppButton(
                      text: 'Create',
                      icon: Icons.add_rounded,
                      onPressed: _handleSubmit,
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      text: 'Cancel',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.go('/content'),
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
