import 'dart:async';

import 'package:berlin/bloc/blocs.dart';
import 'package:berlin/model/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlocHome extends Bloc {
  final _streamController = StreamController<HomeState>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  Sink<HomeState> get sink => _streamController.sink;
  Stream<HomeState> get stream => _streamController.stream;

  void init() {
    final resultat = HomeState(
      isActive: true,
      personlist: [],
      collectionReference: db.collection('personne'),
      person: Person(''),
    );
    sink.add(resultat);
  }

  BlocHome() {
    init();
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class HomeState {
  final bool? isActive;
  Person? person;
  CollectionReference? collectionReference;
  DocumentReference? documentReference;
  final List<Person>? personlist;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  HomeState(
      {this.isActive = false,
      this.person,
      this.personlist,
      this.documentReference,
      this.collectionReference});

  Future<void> addPerson() async {
    collectionReference = db.collection('personne');
    await collectionReference!
        .doc('1')
        .set(person!.toJson())
        .then((value) => print('geschaft'));
  }

  Future<void> deletePerson() async {
    collectionReference = db.collection('personne');
    await collectionReference!
        .doc('1')
        .delete()
        .then((value) => print('deleted'))
        .catchError((error) => print('failed to deleted: $error'));
  }

  Future<void> updatePerson() async {
    collectionReference = db.collection('personne');
    await collectionReference!
        .doc('1')
        .update({'name': 'papa jo'})
        .then((value) => print('Person updated'))
        .catchError((error) => print('$error'));
  }
}
