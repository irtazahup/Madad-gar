class Review {
  final String? id;
  final String serviceId;
  final String consumerId;
  final String providerId;
  final int rating;
  final String comment;

  Review({
    this.id,
    required this.serviceId,
    required this.consumerId,
    required this.providerId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toMap() => {
    'service_id': serviceId,
    'consumer_id': consumerId,
    'provider_id': providerId,
    'rating': rating,
    'comment': comment,
  };
}
