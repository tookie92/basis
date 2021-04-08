import 'package:berlin/bloc/bloc_home.dart';
import 'package:berlin/bloc/bloc_router.dart';
import 'package:berlin/service/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    SizedBox(
                      height: 100,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              validator: (value) =>
                                  value!.isEmpty ? 'name fehlt' : null,
                              decoration: InputDecoration(labelText: 'name'),
                            ),
                            TextFormField(
                              controller: emailController,
                              validator: (value) =>
                                  value!.isEmpty ? 'email fehlt' : null,
                              decoration: InputDecoration(labelText: 'email'),
                            ),
                            TextFormField(
                              controller: passwordController,
                              validator: (value) =>
                                  value!.isEmpty ? 'password fehlt' : null,
                              decoration:
                                  InputDecoration(labelText: 'password'),
                            ),
                          ],
                        )),
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await DbFire().createUser(emailController.text,
                                nameController.text, passwordController.text);
                          }
                          _formKey.currentState!.reset();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('enter'),
                        ))
                  ]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
