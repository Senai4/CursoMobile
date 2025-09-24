import 'package:cine_favorite/views/favorite_view.dart';
import 'package:cine_favorite/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  //garantir o carregamanetos do widgets primeiro
  WidgetsFlutterBinding.ensureInitialized();

  //conectar com o firebase
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: "Cine Favorite",
    theme: ThemeData(
      primarySwatch: Colors.orange,
      brightness: Brightness.dark
    ),
    debugShowCheckedModeBanner: false,
    home: AuthStream(), // permite a navegação de tela de acordo com alguma decisão

  ));
}

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    // ouvinte das mudanças de estado (listener)
    return StreamBuilder<User?>( //retorna o status do Usuário (null/logado)
      stream: FirebaseAuth.instance.authStateChanges(),//identifica a mundaça de status do usuário 
      builder: (context, snapshot){ // analisa o instantâneo da aplicação
      //se tiver logado, vai para a tela de favoritos
      if(snapshot.hasData){
        return FavoriteView();
      }//caso contrário => tela de login
      return LoginView();

      });
  }
}