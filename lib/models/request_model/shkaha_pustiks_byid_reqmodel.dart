class RequestModelById {
  final int id;

  RequestModelById({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
