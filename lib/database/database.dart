import 'package:floor/floor.dart';
import 'package:layout/dao/employee_dao.dart';
import 'package:layout/entity/employee.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';



part 'database.g.dart';

@Database(version:1,entities:[Employee])
abstract class AppDatabase extends FloorDatabase{
  EmployeeDao get employeeDao;

}
