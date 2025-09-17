import 'package:firebase_auth/firebase_auth.dart';//clase modelo do User
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/views/login_view.dart';
import 'package:todo_list_firebase/views/tarefas_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( //widget de construção de telas a partir de uma tomada de decisão
      //a mudança de tela é determianda pela conexão do usuário ao firebase
      stream: FirebaseAuth.instance.authStateChanges(), //a mudança do status do usuário
      builder: (context, snapshot){
        if(snapshot.hasData){
          //se o snapshot tem dados do usuário, significa que o usuário está logado
          return TarefasView(); // navego par a tela de tarefas
        }
        //Caso Contrário -> não tenho dados do usuário armazenado no cache
        return LoginView(); // joga para tela de login
      }
      );
  }
}