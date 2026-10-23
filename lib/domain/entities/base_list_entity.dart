class BaseListEntity<T> {
  final int count;
  final String? next;
  final String? previous;
  final T results;

  const BaseListEntity({
    this.count = 0,
    this.next,
    this.previous,
    required this.results,
  });

  bool get hasNext => next != null && next!.isNotEmpty;
  bool get hasPrevious => previous != null && previous!.isNotEmpty;
}
