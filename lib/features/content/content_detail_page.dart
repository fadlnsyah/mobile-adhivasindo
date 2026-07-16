import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_card.dart';
import 'content_date_formatter.dart';
import 'content_detail_notifier.dart';
import 'content_notifier.dart';
import 'delete_content_notifier.dart';

class ContentDetailPage extends ConsumerStatefulWidget {
  const ContentDetailPage({required this.contentId, super.key});

  final String contentId;

  @override
  ConsumerState<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends ConsumerState<ContentDetailPage> {
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
  Widget build(BuildContext context) {
    final detailState = ref.watch(contentDetailNotifierProvider);
    final deleteState = ref.watch(deleteContentNotifierProvider);
    final id = _contentId;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: ref.read(contentDetailNotifierProvider.notifier).refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
            children: [
              _DetailTopBar(onBack: () => _goBack(context)),
              SizedBox(height: 20.h),
              if (id == null || detailState.notFound)
                _ContentNotFoundState(onBack: () => _goBack(context))
              else if (detailState.loading && detailState.data == null)
                const _ContentDetailLoadingState()
              else if (detailState.error != null)
                _ContentDetailErrorState(
                  message: detailState.error!,
                  onRetry: ref
                      .read(contentDetailNotifierProvider.notifier)
                      .refresh,
                )
              else if (detailState.data != null)
                _ContentDetailBody(
                  id: detailState.data!.id,
                  title: detailState.data!.title,
                  author: detailState.data!.author.name,
                  date: formatContentDate(detailState.data!.createdAt),
                  content: detailState.data!.content,
                  imageUrl: detailState.data!.image,
                  loading: detailState.loading,
                  deleting: deleteState.loading,
                  onBack: () => _goBack(context),
                  onDelete: () => _confirmDelete(context, detailState.data!.id),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final result = await showDialog<_DeleteResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final isDeleting = ref.watch(deleteContentNotifierProvider).loading;

            return AlertDialog(
              title: const Text('Delete Content?'),
              content: const Text('This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isDeleting
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(deleteContentNotifierProvider.notifier)
                                .delete(id);
                            await ref
                                .read(contentNotifierProvider.notifier)
                                .refresh();

                            if (dialogContext.mounted) {
                              Navigator.of(
                                dialogContext,
                              ).pop(const _DeleteResult.success());
                            }
                          } catch (error) {
                            if (dialogContext.mounted) {
                              Navigator.of(
                                dialogContext,
                              ).pop(_DeleteResult.error(error.toString()));
                            }
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isDeleting ? 'Deleting...' : 'Delete'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !context.mounted) {
      return;
    }

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content deleted successfully')),
      );

      context.go('/content');
      return;
    }

    final message = result.message ?? 'Error deleting content';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    if (message == 'Unauthorized') {
      context.go('/login');
    }
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/content');
  }
}

class _DetailTopBar extends StatelessWidget {
  const _DetailTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: onBack,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black.withValues(alpha: 0.72),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        SizedBox(width: 10.w),
        Text(
          'Content Detail',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _ContentDetailBody extends StatelessWidget {
  const _ContentDetailBody({
    required this.author,
    required this.content,
    required this.date,
    required this.deleting,
    required this.id,
    required this.loading,
    required this.onDelete,
    required this.onBack,
    required this.title,
    this.imageUrl,
  });

  final String author;
  final String content;
  final String date;
  final bool deleting;
  final int id;
  final String? imageUrl;
  final bool loading;
  final VoidCallback onBack;
  final VoidCallback onDelete;
  final String title;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 220.h,
            width: double.infinity,
            color: AppTheme.primaryColor.withValues(alpha: 0.12),
            child: hasImage
                ? Image.network(imageUrl!, fit: BoxFit.cover)
                : const Icon(
                    Icons.image_rounded,
                    color: AppTheme.primaryColor,
                    size: 56,
                  ),
          ),
        ),
        SizedBox(height: 22.h),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.22,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            const Icon(
              Icons.person_rounded,
              color: AppTheme.primaryColor,
              size: 18,
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.58),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.primaryColor,
              size: 18,
            ),
            SizedBox(width: 6.w),
            Text(
              date,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.48),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        AppCard(
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.72),
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.go('/content/$id/edit'),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: deleting ? null : onDelete,
            icon: const Icon(Icons.delete_rounded),
            label: Text(deleting ? 'Deleting...' : 'Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        if (loading) ...[
          const LinearProgressIndicator(
            color: AppTheme.primaryColor,
            minHeight: 3,
          ),
          SizedBox(height: 14.h),
        ],
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onBack,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Back'),
          ),
        ),
      ],
    );
  }
}

class _ContentNotFoundState extends StatelessWidget {
  const _ContentNotFoundState({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppTheme.primaryColor,
            size: 48,
          ),
          SizedBox(height: 12.h),
          Text(
            'Content not found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 18.h),
          FilledButton(
            onPressed: onBack,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}

class _ContentDetailErrorState extends StatelessWidget {
  const _ContentDetailErrorState({
    required this.message,
    required this.onRetry,
  });

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
            size: 48,
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

class _ContentDetailLoadingState extends StatelessWidget {
  const _ContentDetailLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBox(height: 220.h, width: double.infinity, radius: 30),
        SizedBox(height: 22.h),
        _SkeletonBox(height: 22, width: 250.w),
        SizedBox(height: 12.h),
        _SkeletonBox(height: 14, width: 150.w),
        SizedBox(height: 8.h),
        _SkeletonBox(height: 14, width: 120.w),
        SizedBox(height: 20.h),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBox(height: 12, width: double.infinity),
              SizedBox(height: 10.h),
              _SkeletonBox(height: 12, width: double.infinity),
              SizedBox(height: 10.h),
              _SkeletonBox(height: 12, width: 220.w),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.width,
    this.radius = 12,
  });

  final double height;
  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _DeleteResult {
  const _DeleteResult.success() : success = true, message = null;

  const _DeleteResult.error(this.message) : success = false;

  final String? message;
  final bool success;
}
