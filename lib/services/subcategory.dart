import 'package:objectbox/objectbox.dart';

@Entity()
class Subcategory {
  @Id()
  int id;

  int icon;

  String name;


  Subcategory({required this.icon, required this.name, required this.id});

}