class Saving {
  int? id;
  String type;
  double amount;
  String date;
  double? target; // optional target amount for a savings goal

  Saving({this.id, required this.type, required this.amount, required this.date, this.target});

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'date': date,
        'target': target,
      };

  factory Saving.fromMap(Map<String, dynamic> m) => Saving(
        id: m['id'] as int?,
        type: m['type'] as String,
        amount: (m['amount'] as num).toDouble(),
        date: m['date'] as String,
        target: m['target'] == null ? null : (m['target'] as num).toDouble(),
      );
}
