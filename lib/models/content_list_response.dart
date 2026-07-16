import 'package:equatable/equatable.dart';

import 'content_model.dart';

class ContentListResponse extends Equatable {
  const ContentListResponse({required this.data, required this.meta});

  factory ContentListResponse.fromJson(Map<String, dynamic> json) {
    final contents = json['data'];

    return ContentListResponse(
      data: contents is List
          ? contents
                .whereType<Map<String, dynamic>>()
                .map(ContentModel.fromJson)
                .toList()
          : const [],
      meta: ContentPaginationMeta.fromJson(
        json['meta'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final List<ContentModel> data;
  final ContentPaginationMeta meta;

  @override
  List<Object?> get props => [data, meta];
}

class ContentPaginationMeta extends Equatable {
  const ContentPaginationMeta({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
  });

  factory ContentPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ContentPaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
    );
  }

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
