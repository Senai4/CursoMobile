import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_view.dart'; // Sua tela inicial

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _register() async {
    try {
      // Tenta criar um novo usuário no Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );

      // Se for bem-sucedido, vai para a tela inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado! Você está logado.')),
      );

    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'A senha deve ter pelo menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Este email já está em uso.';
      } else if (e.code == 'invalid-email') {
        message = 'O formato do e-mail é inválido.';
      } else {
        message = 'Erro ao cadastrar: ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro inesperado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController, 
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: 'Senha (mín. 6 caracteres)'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _register, 
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}