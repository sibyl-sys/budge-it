import 'package:objectbox/objectbox.dart';

@Entity()
class Subcategory {
  @Id()
  int id = 0;

  int icon;

  String name;


  Subcategory({required this.icon, required this.name});

}