import 'package:berlin/bloc/bloc_home.dart';
import 'package:berlin/bloc/bloc_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocRouter().home(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocHome>(context);
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: StreamBuilder<HomeState>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          final truc = snapshot.data;

          if (truc == null) {
            return Container(
              child: Center(
                child: Text('nothing to show '),
              ),
            );
          } else if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: Text('nothing to show '),
              ),
            );
          } else {
            return Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Container(
                          width: 200.0,
                          height: 100.0,
                          decoration: BoxDecoration(color: Colors.amber),
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter was' : null,
                            onSaved: (newValue) => truc.person!.name = newValue,
                          ),
                        ),
                        Container(
                          width: 200.0,
                          height: 100.0,
                          decoration: BoxDecoration(color: Colors.red),
                          child: TextButton(
                            child: Text('save'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await truc.addPerson();
                              }
                              _formKey.currentState!.reset();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SizedBox(
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: truc.collectionReference!.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }

                        return (snapshot.data!.docs.isEmpty)
                            ? Text('nothing')
                            : ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  return new ListTile(
                                    title: new Text(document.data()!['name']),
                                    subtitle: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              await truc.updatePerson();
                                            },
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () async {
                                              await truc.deletePerson();
                                            },
                                            icon: Icon(Icons.delete_forever)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                      },
                    ),
                  ))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
