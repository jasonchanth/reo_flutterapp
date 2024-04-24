class Ticket {
  final String id;
  final String type;
  final String subject;
  final String details;
  final String status;
  final String updatedAt;

  Ticket({
    required this.id,
    required this.type,
    required this.subject,
    required this.details,
    required this.status,
    required this.updatedAt,
  });
}
