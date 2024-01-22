import 'package:hive/hive.dart';

part 'currency.g.dart';

@HiveType(typeId: 5)
class Currency {
  @HiveField(0)
  String name;

  @HiveField(1)
  String symbol;

  @HiveField(2)
  double exchangeRateToUSD;

  Currency({required this.name,required this.symbol, required this.exchangeRateToUSD});
}