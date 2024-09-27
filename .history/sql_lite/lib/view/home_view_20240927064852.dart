import 'package:flutter/material.dart';
import 'package:sql_lite/helper/databse_helpter.dart';
import 'package:sql_lite/model/user_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserModle> users = [];
  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  String? name, phone, email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: getAllUser(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.red,
      onPressed: () {
        openAlert();
      },
    );
  }

  Widget getAllUser() {
    return FutureBuilder<List<UserModle>>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users available"));
        } else {
          return createListView(context: context, snapshot: snapshot);
        }
      },
    );
  }

  Future<List<UserModle>> getdata() async {
    var data = await DatabaseHelper.db.getAllUsers();
    users = data;
    return users;
  }

  Widget createListView({
    required BuildContext context,
    required AsyncSnapshot<List<UserModle>> snapshot,
  }) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          child: buildItem(snapshot.data![index], index),
          onDismissed: (direction) {
            DatabaseHelper.db.delete(users[index].id);
          },
        );
      },
    );
  }

  void openAlert({UserModle? user}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 300,
            child: Form(
              key: mykey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return " enter name";
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Add name",
                      fillColor: Colors.grey,
                    ),
                    onSaved: (newValue) {
                      name = newValue;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Add phone",
                      fillColor: Colors.grey,
                    ),
                    onSaved: (newValue) {
                      phone = newValue;
                    },
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Add email",
                      fillColor: Colors.grey,
                    ),
                    onSaved: (newValue) {
                      email = newValue;
                    },
                  ),
                  MaterialButton(
                    child: const Text("Add User"),
                    onPressed: () {
                      if (mykey.currentState!.validate()) {
                        mykey.currentState?.save();

                        addUser().then((_) {
                          if (mykey.currentState!.validate() == false) {
                            return " enter any thing ";
                          } else
                            Navigator.pop(context);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addUser() async {
    var database = DatabaseHelper.db;
    await database.insert(
      UserModle(
        name: name!,
        email: email!,
        phone: phone!,
      ),
    );
    setState(() {});
  }

  Widget buildItem(UserModle user, int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(user.name.substring(0, 1).toUpperCase()),
          ),
          title: Text(user.name),
          subtitle: Text('${user.email}   - ${user.phone}'),
          trailing: Column(
            children: [
              MaterialButton(
                onPressed: () async {
                  print("object");
                  setState(() {});
                  _update(user, index);
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update(UserModle user, int index) {
    openAlert();
  }
}
