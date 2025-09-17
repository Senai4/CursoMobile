import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  //atributos
  final _auth = FirebaseAuth.instance;
  final _emailField = TextEditingController();
  final _senhaField = TextEditingController();
  final _confirmarSenhaField = TextEditingController();
  bool _senhaOculta = true;
  bool _confirmarSenhaOculta = true;

  //método de registro
  void _registrar() async {
    if (_confirmarSenhaField.text != _senhaField.text) {
      throw Exception("Senhas Diferentes");
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailField.text.trim(),
        password: _senhaField.text.trim(),
      );
      Navigator.pop(context);
      // ao criar usuário , é logado automaticamente para a tela de tarefas
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao Criar Usuário: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro"),),
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
            TextField(
              controller: _confirmarSenhaField,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                suffixIcon: IconButton(onPressed: ()=>{
                  setState(() {
                    _confirmarSenhaOculta = !_confirmarSenhaOculta;
                  })
                }, icon: _confirmarSenhaOculta ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
                ),
              obscureText: _confirmarSenhaOculta,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _registrar, child: Text("Registrar")),
          ],
        ), 
        ),
    );
  }
}
