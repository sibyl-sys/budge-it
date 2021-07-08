import 'package:hive/hive.dart';

part 'subcategory.g.dart';

@HiveType(typeId: 8)
class Subcategory {
  @HiveField(0)
  int icon;

  @HiveField(2)
  String name;

  Subcategory({this.icon, this.name});

}