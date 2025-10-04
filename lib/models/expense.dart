class Expense {
  int? id;
  String category;
  double amount;
  String date; // ISO string
  String? notes;

  Expense({this.id, required this.category, required this.amount, required this.date, this.notes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date,
      'notes': notes,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int?,
        category: m['category'] as String,
        amount: (m['amount'] as num).toDouble(),
        date: m['date'] as String,
        notes: m['notes'] as String?,
      );
}
