import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_notifier.dart';

final deleteContentNotifierProvider =
    NotifierProvider<DeleteContentNotifier, DeleteContentState>(
      DeleteContentNotifier.new,
    );

class DeleteContentState extends Equatable {
  const DeleteContentState({this.loading = false});

  final bool loading;

  DeleteContentState copyWith({bool? loading}) {
    return DeleteContentState(loading: loading ?? this.loading);
  }

  @override
  List<Object?> get props => [loading];
}

class DeleteContentNotifier extends Notifier<DeleteContentState> {
  @override
  DeleteContentState build() {
    return const DeleteContentState();
  }

  Future<void> delete(int id) async {
    state = state.copyWith(loading: true);

    try {
      await ref.read(contentServiceProvider).deleteContent(id);
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
