import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/create_content_request.dart';
import 'content_notifier.dart';

final createContentNotifierProvider =
    NotifierProvider<CreateContentNotifier, CreateContentState>(
      CreateContentNotifier.new,
    );

class CreateContentState extends Equatable {
  const CreateContentState({this.loading = false});

  final bool loading;

  CreateContentState copyWith({bool? loading}) {
    return CreateContentState(loading: loading ?? this.loading);
  }

  @override
  List<Object?> get props => [loading];
}

class CreateContentNotifier extends Notifier<CreateContentState> {
  @override
  CreateContentState build() {
    return const CreateContentState();
  }

  Future<void> create(CreateContentRequest request) async {
    state = state.copyWith(loading: true);

    try {
      await ref.read(contentServiceProvider).createContent(request);
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
