import 'package:floor/floor.dart';

@entity
class Employee {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String firstName,lastName,email;

  Employee({this.id, required this.firstName, required this.lastName, required this.email});
}