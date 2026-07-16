import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/create_content_request.dart';
import 'content_notifier.dart';

final editContentNotifierProvider =
    NotifierProvider<EditContentNotifier, EditContentState>(
      EditContentNotifier.new,
    );

class EditContentState extends Equatable {
  const EditContentState({this.loading = false});

  final bool loading;

  EditContentState copyWith({bool? loading}) {
    return EditContentState(loading: loading ?? this.loading);
  }

  @override
  List<Object?> get props => [loading];
}

class EditContentNotifier extends Notifier<EditContentState> {
  @override
  EditContentState build() {
    return const EditContentState();
  }

  Future<void> update(int id, CreateContentRequest request) async {
    state = state.copyWith(loading: true);

    try {
      await ref.read(contentServiceProvider).updateContent(id, request);
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
