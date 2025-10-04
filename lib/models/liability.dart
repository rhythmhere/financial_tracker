class Liability {
  int? id;
  String type;
  double amount;
  String dueDate;

  Liability({this.id, required this.type, required this.amount, required this.dueDate});

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'dueDate': dueDate,
      };

  factory Liability.fromMap(Map<String, dynamic> m) => Liability(
        id: m['id'] as int?,
        type: m['type'] as String,
        amount: (m['amount'] as num).toDouble(),
        dueDate: m['dueDate'] as String,
      );
}
