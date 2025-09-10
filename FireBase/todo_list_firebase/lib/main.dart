import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/firebase_options.dart';
import 'package:todo_list_firebase/views/auth_view.dart';

void main() async{
  //garante o construção dos Widgets antes de inicar a conexão
  WidgetsFlutterBinding.ensureInitialized();
  //conectar com o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform //conecta com a plataforma android do firebase
  );
  runApp(MaterialApp(
    title: "Lista de Tarefas com FireBase",
    home: AuthView(), // widget que decide qual tela vai mostrar ,
    // dependendo da Autenticação do Usuário
  ));
}