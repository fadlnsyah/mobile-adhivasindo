import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class ContentForm extends StatelessWidget {
  const ContentForm({
    required this.cancelCallback,
    required this.contentController,
    required this.imageController,
    required this.loading,
    required this.submitCallback,
    required this.submitText,
    required this.titleController,
    super.key,
  });

  final VoidCallback? cancelCallback;
  final TextEditingController contentController;
  final TextEditingController imageController;
  final bool loading;
  final Future<void> Function()? submitCallback;
  final String submitText;
  final TextEditingController titleController;

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

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          AppTextField(
            controller: titleController,
            hintText: 'Title',
            prefixIcon: Icons.title_rounded,
            readOnly: loading,
            validator: _validateTitle,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: contentController,
            hintText: 'Content',
            keyboardType: TextInputType.multiline,
            maxLines: 7,
            minLines: 5,
            prefixIcon: Icons.notes_rounded,
            readOnly: loading,
            validator: _validateContent,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: imageController,
            hintText: 'Image URL',
            keyboardType: TextInputType.url,
            prefixIcon: Icons.link_rounded,
            readOnly: loading,
            validator: _validateImageUrl,
          ),
          SizedBox(height: 24.h),
          AppButton(
            text: submitText,
            icon: Icons.save_rounded,
            onPressed: loading ? null : submitCallback,
          ),
          SizedBox(height: 12.h),
          AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.secondary,
            onPressed: loading ? null : cancelCallback,
          ),
        ],
      ),
    );
  }
}
