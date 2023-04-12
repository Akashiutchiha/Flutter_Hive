import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hiveapp/person.dart';

import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController ageController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Hive App',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
            color: Color(0xFF070f32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'images/hive_pic.png',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 250,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        TextField(
                          controller: ageController,
                          decoration: InputDecoration(
                            hintText: 'Age',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              boxPersons.put(
                                'key_${nameController.text}',
                                Person(
                                  name: nameController.text,
                                  age: int.parse(ageController.text),
                                ),
                              );
                            });
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Container(
                    height: 350,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          Person person = boxPersons.getAt(index);
                          return ListTile(
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  // boxPersons.deleteAt(index);
                                  nameController.text = person.name;
                                  ageController.text = person.age.toString();
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            title: Text(person.name),
                            subtitle: Text('age: ' + person.age.toString()),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  boxPersons.deleteAt(index);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        },
                        itemCount: boxPersons.length),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outlined,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            boxPersons.clear();
                          });
                        },
                        child: Text(
                          'Delete all',
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
