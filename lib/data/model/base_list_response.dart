class BaseListResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final T results;

  const BaseListResponse({
    this.count = 0,
    this.next,
    this.previous,
    required this.results,
  });

  factory BaseListResponse.fromJson({
    required Map<String, dynamic> response,
    required T Function(List<dynamic> jsonList) onResult,
  }) {
    return BaseListResponse<T>(
      count: response['count'] as int? ?? 0,
      next: response['next'] as String?,
      previous: response['previous'] as String?,
      results: onResult(response['results'] as List<dynamic>? ?? []),
    );
  }
}
