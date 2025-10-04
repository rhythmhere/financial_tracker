class Profile {
  String name;
  String currency;

  Profile({required this.name, required this.currency});

  Map<String, dynamic> toMap() => {
        'name': name,
        'currency': currency,
      };

  factory Profile.fromMap(Map<String, dynamic> m) => Profile(
        name: m['name'] as String,
        currency: m['currency'] as String,
      );
}
