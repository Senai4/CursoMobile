import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/views/registro_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //atributos
  final FirebaseAuth _auth = FirebaseAuth.instance; //controller para autenticar usuários na plataforma do FireBase
  final _emailField = TextEditingController(); //controlador do campo de texto
  final _senhaField = TextEditingController(); //controlador do campo de texto
  bool _senhaOculta = true;

  //método de login
  void _login() async{
    try {
      //solicitar a autenticação do usuário
      await _auth.signInWithEmailAndPassword(
        email: _emailField.text.trim(), 
        password: _senhaField.text);
      //não precisa de Navigator , pois o AuthView(StreamBuilder)
      //já faz o direcionamento ao modificar o Status do Usuário
    } on FirebaseAuthException catch (e) { //tratamento mais especifico
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao Fazer Login $e"))
      );
    }
  }

  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailField,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _senhaField,
              decoration: InputDecoration(
                labelText: "Senha",
                suffixIcon: IconButton(onPressed: ()=>{
                  setState(() {
                    _senhaOculta = !_senhaOculta;
                  })
                }, icon: _senhaOculta ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
                ),
              obscureText: _senhaOculta,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _login, child: Text("Login")),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistroView()));
              }, 
              child: Text("Não tem uma conta? Registre-se"))
          ],
        ), 
        ),
    );
  }
}