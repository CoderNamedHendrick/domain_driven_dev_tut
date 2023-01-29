import 'package:domain_driven_tut/injection.dart';
import 'package:domain_driven_tut/presentation/core/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  configureInjection(Environment.prod);
  runApp(const AppWidget());
}
