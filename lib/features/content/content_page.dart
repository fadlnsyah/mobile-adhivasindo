import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_search_bar.dart';
import '../../shared/widgets/content_card.dart';
import 'content_date_formatter.dart';
import 'content_notifier.dart';

class ContentPage extends ConsumerStatefulWidget {
  const ContentPage({super.key});

  @override
  ConsumerState<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(contentNotifierProvider.notifier).loadContents();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(contentNotifierProvider.notifier).searchContents(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Content')),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: ref.read(contentNotifierProvider.notifier).refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 24.h),
          children: [
            AppSearchBar(
              controller: _searchController,
              hintText: 'Search content...',
              onChanged: _handleSearchChanged,
            ),
            SizedBox(height: 20.h),
            if (contentState.loading && contentState.data.isEmpty)
              const _ContentLoadingState()
            else if (contentState.error != null)
              _ContentErrorState(
                message: contentState.error!,
                onRetry: ref.read(contentNotifierProvider.notifier).refresh,
              )
            else if (contentState.data.isEmpty)
              _ContentEmptyState(hasSearch: contentState.hasSearch)
            else ...[
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  '${contentState.total} content found',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...contentState.data.map((content) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: ContentCard(
                    title: content.title,
                    author: content.author.name,
                    date: formatContentDate(content.createdAt),
                    excerpt: content.content,
                    imageUrl: content.image,
                    onTap: () => context.go('/content/${content.id}'),
                  ),
                );
              }),
              if (contentState.loadingMore)
                const _ContentLoadMoreState()
              else if (contentState.hasMore)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: FilledButton(
                    onPressed: ref
                        .read(contentNotifierProvider.notifier)
                        .loadMore,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Load More'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContentLoadingState extends StatelessWidget {
  const _ContentLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: AppCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  height: 102,
                  width: 102,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonLine(width: 160.w),
                      const SizedBox(height: 10),
                      _SkeletonLine(width: 90.w),
                      const SizedBox(height: 12),
                      _SkeletonLine(width: 190.w),
                      const SizedBox(height: 8),
                      _SkeletonLine(width: 120.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
      height: 12,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _ContentLoadMoreState extends StatelessWidget {
  const _ContentLoadMoreState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
            strokeWidth: 2.4,
          ),
        ),
      ),
    );
  }
}

class _ContentEmptyState extends StatelessWidget {
  const _ContentEmptyState({required this.hasSearch});

  final bool hasSearch;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          children: [
            const Icon(
              Icons.article_outlined,
              color: AppTheme.primaryColor,
              size: 42,
            ),
            SizedBox(height: 12.h),
            Text(
              hasSearch ? 'No search results found' : 'No content available',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentErrorState extends StatelessWidget {
  const _ContentErrorState({required this.message, required this.onRetry});

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
            size: 42,
          ),
          SizedBox(height: 12.h),
          Text(
            'Error loading contents',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.48),
              fontSize: 12,
            ),
          ),
          SizedBox(height: 18.h),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
