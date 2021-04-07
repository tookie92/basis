import 'package:berlin/bloc/bloc_home.dart';
import 'package:berlin/bloc/bloc_router.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc_provider.dart';

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
                child: Text('ok'),
              ),
            );
          }
        },
      ),
    );
  }
}
