import 'package:objectbox/objectbox.dart';

@Entity()
class Currency {
  @Id()
  int id = 0;

  String name;

  String symbol;

  double exchangeRateToUSD;

  Currency({required this.name,required this.symbol, required this.exchangeRateToUSD});
}