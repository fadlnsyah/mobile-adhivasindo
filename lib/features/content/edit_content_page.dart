import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../models/content_model.dart';
import '../../models/create_content_request.dart';
import '../../shared/widgets/app_card.dart';
import 'content_detail_notifier.dart';
import 'content_notifier.dart';
import 'edit_content_notifier.dart';
import 'widgets/content_form.dart';

class EditContentPage extends ConsumerStatefulWidget {
  const EditContentPage({required this.contentId, super.key});

  final String contentId;

  @override
  ConsumerState<EditContentPage> createState() => _EditContentPageState();
}

class _EditContentPageState extends ConsumerState<EditContentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();
  bool _formInitialized = false;

  int? get _contentId => int.tryParse(widget.contentId);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final id = _contentId;

      if (id == null) {
        return;
      }

      ref.read(contentDetailNotifierProvider.notifier).loadContent(id);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _populateForm(ContentModel content) {
    if (_formInitialized) {
      return;
    }

    _titleController.text = content.title;
    _contentController.text = content.content;
    _imageController.text = content.image ?? '';
    _formInitialized = true;
  }

  Future<void> _handleSubmit() async {
    final id = _contentId;
    final isValid = _formKey.currentState?.validate() ?? false;

    if (id == null || !isValid) {
      return;
    }

    final image = _imageController.text.trim();

    try {
      await ref
          .read(editContentNotifierProvider.notifier)
          .update(
            id,
            CreateContentRequest(
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              image: image.isEmpty ? null : image,
            ),
          );

      await ref.read(contentNotifierProvider.notifier).refresh();
      await ref.read(contentDetailNotifierProvider.notifier).loadContent(id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content updated successfully')),
      );

      context.go('/content/$id');
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = error.toString();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (message == 'Unauthorized') {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(contentDetailNotifierProvider);
    final editState = ref.watch(editContentNotifierProvider);
    final id = _contentId;

    if (detailState.data != null) {
      _populateForm(detailState.data!);
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
          children: [
            Text(
              'Edit Content',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black.withValues(alpha: 0.84),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Update your learning material content.',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.48),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            if (id == null || detailState.notFound)
              const _EditNotFoundState()
            else if (detailState.loading && detailState.data == null)
              const _EditLoadingState()
            else if (detailState.error != null)
              _EditErrorState(
                message: detailState.error!,
                onRetry: () =>
                    ref.read(contentDetailNotifierProvider.notifier).refresh(),
              )
            else
              Form(
                key: _formKey,
                child: ContentForm(
                  titleController: _titleController,
                  contentController: _contentController,
                  imageController: _imageController,
                  loading: editState.loading,
                  submitText: editState.loading ? 'Saving...' : 'Save',
                  submitCallback: _handleSubmit,
                  cancelCallback: () => context.go('/content/$id'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EditLoadingState extends StatelessWidget {
  const _EditLoadingState();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonLine(width: double.infinity),
          SizedBox(height: 16.h),
          _SkeletonLine(width: double.infinity),
          SizedBox(height: 16.h),
          _SkeletonLine(width: 180.w),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _EditNotFoundState extends StatelessWidget {
  const _EditNotFoundState();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppTheme.primaryColor,
            size: 44,
          ),
          SizedBox(height: 12.h),
          Text(
            'Content not found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _EditErrorState extends StatelessWidget {
  const _EditErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppTheme.primaryColor,
            size: 44,
          ),
          SizedBox(height: 12.h),
          Text(
            'Error loading content',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black.withValues(alpha: 0.48)),
          ),
          SizedBox(height: 18.h),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
