class Investment {
  int? id;
  String type;
  String name;
  double buyPrice;
  double currentPrice;
  double quantity;
  String date;

  Investment({this.id, required this.type, required this.name, required this.buyPrice, required this.currentPrice, required this.quantity, required this.date});

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'name': name,
        'buyPrice': buyPrice,
        'currentPrice': currentPrice,
        'quantity': quantity,
        'date': date,
      };

  factory Investment.fromMap(Map<String, dynamic> m) => Investment(
        id: m['id'] as int?,
        type: m['type'] as String,
        name: m['name'] as String,
        buyPrice: (m['buyPrice'] as num).toDouble(),
        currentPrice: (m['currentPrice'] as num).toDouble(),
        quantity: (m['quantity'] as num).toDouble(),
        date: m['date'] as String,
      );
}
