import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/content_model.dart';
import 'content_notifier.dart';

final contentDetailNotifierProvider =
    NotifierProvider<ContentDetailNotifier, ContentDetailState>(
      ContentDetailNotifier.new,
    );

class ContentDetailState extends Equatable {
  const ContentDetailState({this.loading = false, this.data, this.error});

  final ContentModel? data;
  final String? error;
  final bool loading;

  bool get notFound => error == 'Content not found';

  ContentDetailState copyWith({
    ContentModel? data,
    String? error,
    bool? loading,
    bool clearData = false,
    bool clearError = false,
  }) {
    return ContentDetailState(
      data: clearData ? null : data ?? this.data,
      error: clearError ? null : error ?? this.error,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [data, error, loading];
}

class ContentDetailNotifier extends Notifier<ContentDetailState> {
  int? _contentId;

  @override
  ContentDetailState build() {
    return const ContentDetailState();
  }

  Future<void> loadContent(int id) async {
    _contentId = id;
    state = state.copyWith(loading: true, clearData: true, clearError: true);

    try {
      final content = await ref.read(contentServiceProvider).getContentById(id);
      state = state.copyWith(data: content, loading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(error: error.toString(), loading: false);
    }
  }

  Future<void> refresh() async {
    final id = _contentId;

    if (id == null) {
      return;
    }

    await loadContent(id);
  }
}
