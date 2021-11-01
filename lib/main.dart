import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:layout/dao/employee_dao.dart';
import 'package:layout/database/database.dart';
import 'package:layout/entity/employee.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('my_database.db').build();
  final dao = database.employeeDao;

  runApp(MyApp(dao: dao));
}

class MyApp extends StatelessWidget {
  final EmployeeDao? dao;

  const MyApp({Key? key, required this.dao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppTitle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(dao: dao),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.dao}) : super(key: key);

  final EmployeeDao? dao;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Floor2'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final employee = Employee(
                  firstName: Faker().person.firstName(),
                  lastName: Faker().person.lastName(),
                  email: Faker().internet.email());
              await widget.dao!.insertEmployee(employee);
              makeASnackBar('Updated', context);
            },
          ),
          IconButton(
            onPressed: () async {
              widget.dao!.deleteAllEmployees();
              setState(() {
                makeASnackBar('List Cleared', context);
              });
            },
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: StreamBuilder(
        stream: widget.dao!.getAllEmployee(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: (Text('${snapshot.error}')));
          } else if (snapshot.hasData) {
            var listEmployee = snapshot.data as List<Employee>;
            return Container(
              color: Colors.black12,
              padding: const EdgeInsets.all(0),
              child: ListView.builder(
                  itemCount: listEmployee.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                        actionPane: const SlidableDrawerActionPane(),
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Update',
                            color: Colors.pink,
                            icon: Icons.update,
                            onTap: () async {
                              final updateEmployee = listEmployee[index];
                              updateEmployee.firstName =
                                  Faker().person.firstName();
                              updateEmployee.lastName =
                                  Faker().person.lastName();
                              updateEmployee.email = Faker().internet.email();

                              await widget.dao!.updateEmployee(updateEmployee);
                              makeASnackBar('Updated', context);
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              final deleteEmployee = listEmployee[index];
                              await widget.dao!.deleteEmployee(deleteEmployee);
                              makeASnackBar('Deleted', context);
                            },
                          )
                        ],
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 20),
                          tileColor: Colors.black12,
                          title: Text(
                            '${listEmployee[index].firstName} ${listEmployee[index].lastName}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                          subtitle: Text(
                            listEmployee[index].email,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        ));
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

void makeASnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 300),
    ),
  );
}


