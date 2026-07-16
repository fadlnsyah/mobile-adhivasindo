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
  const ContentState({this.loading = false, this.data = const [], this.error});

  final List<ContentModel> data;
  final String? error;
  final bool loading;

  ContentState copyWith({
    List<ContentModel>? data,
    String? error,
    bool? loading,
    bool clearError = false,
  }) {
    return ContentState(
      data: data ?? this.data,
      error: clearError ? null : error ?? this.error,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [data, error, loading];
}

class ContentNotifier extends Notifier<ContentState> {
  @override
  ContentState build() {
    return const ContentState();
  }

  Future<void> loadContents() async {
    await _fetchContents(showLoading: true);
  }

  Future<void> refresh() async {
    await _fetchContents(showLoading: state.data.isEmpty);
  }

  Future<void> _fetchContents({required bool showLoading}) async {
    if (showLoading) {
      state = state.copyWith(loading: true, clearError: true);
    } else {
      state = state.copyWith(clearError: true);
    }

    try {
      final contents = await ref.read(contentServiceProvider).getContents();
      state = state.copyWith(data: contents, loading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(error: error.toString(), loading: false);
    }
  }
}
