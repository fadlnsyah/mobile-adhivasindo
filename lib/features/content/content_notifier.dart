import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/content_model.dart';
import '../../services/content_service.dart';

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService();
});

final contentNotifierProvider = NotifierProvider<ContentNotifier, ContentState>(
  ContentNotifier.new,
);

class ContentState extends Equatable {
  const ContentState({
    this.loading = false,
    this.loadingMore = false,
    this.data = const [],
    this.error,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.search = '',
    this.total = 0,
  });

  final int currentPage;
  final List<ContentModel> data;
  final String? error;
  final int lastPage;
  final bool loading;
  final bool loadingMore;
  final int perPage;
  final String search;
  final int total;

  bool get hasMore => currentPage < lastPage;
  bool get hasSearch => search.trim().isNotEmpty;

  ContentState copyWith({
    int? currentPage,
    List<ContentModel>? data,
    String? error,
    int? lastPage,
    bool? loading,
    bool? loadingMore,
    int? perPage,
    String? search,
    int? total,
    bool clearError = false,
  }) {
    return ContentState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      error: clearError ? null : error ?? this.error,
      lastPage: lastPage ?? this.lastPage,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    data,
    error,
    lastPage,
    loading,
    loadingMore,
    perPage,
    search,
    total,
  ];
}

class ContentNotifier extends Notifier<ContentState> {
  @override
  ContentState build() {
    return const ContentState();
  }

  Future<void> loadContents() async {
    await _fetchContents(page: 1, search: state.search, resetData: true);
  }

  Future<void> refresh() async {
    await _fetchContents(page: 1, search: state.search, resetData: true);
  }

  Future<void> searchContents(String search) async {
    await _fetchContents(page: 1, search: search, resetData: true);
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) {
      return;
    }

    await _fetchContents(
      page: state.currentPage + 1,
      search: state.search,
      resetData: false,
    );
  }

  Future<void> _fetchContents({
    required int page,
    required bool resetData,
    required String search,
  }) async {
    state = state.copyWith(
      data: resetData ? const [] : null,
      loading: resetData,
      loadingMore: !resetData,
      search: search,
      clearError: true,
    );

    try {
      final response = await ref
          .read(contentServiceProvider)
          .getContents(page: page, perPage: state.perPage, search: search);

      state = state.copyWith(
        currentPage: response.meta.currentPage,
        data: resetData ? response.data : [...state.data, ...response.data],
        lastPage: response.meta.lastPage,
        loading: false,
        loadingMore: false,
        perPage: response.meta.perPage,
        total: response.meta.total,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        error: error.toString(),
        loading: false,
        loadingMore: false,
      );
    }
  }
}
