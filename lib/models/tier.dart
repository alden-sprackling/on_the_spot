class Tier {
  final int tier;       // changed from String → int
  final String name;    // new: the tier’s name
  final int minIq;
  final int maxIq;
  final int count;

  Tier({
    required this.tier,
    required this.name,
    required this.minIq,
    required this.maxIq,
    required this.count,
  });

  factory Tier.fromJson(Map<String, dynamic> json) => Tier(
        tier: json['tier']        as int,
        name: json['name']        as String,
        minIq: json['minIq']      as int,
        maxIq: json['maxIq']      as int,
        count: json['count']      as int,
      );
}

class TierStats {
  final List<Tier> tiers;
  final int myTier;     // changed from String → int

  TierStats({
    required this.tiers,
    required this.myTier,
  });

  factory TierStats.fromJson(Map<String, dynamic> json) => TierStats(
        tiers: (json['tiers'] as List)
            .map((e) => Tier.fromJson(e as Map<String, dynamic>))
            .toList(),
        myTier: json['myTier'] as int,
      );
}
