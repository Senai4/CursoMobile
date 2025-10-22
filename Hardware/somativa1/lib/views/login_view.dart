import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_view.dart'; // Sua tela inicial
import 'register_view.dart'; // NOVA TELA de Cadastro que vamos criar

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _senha.text,
      );
      
      // Sucesso no Login: Navega para a Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // Trata os erros de login do Firebase
      String message = 'Erro ao fazer login. Verifique e-mail e senha.';
      
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Credenciais inválidas. Tente novamente.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os itens na tela
          children: [
            TextField(
              controller: _email, 
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senha, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 30),
            
            // BOTÃO DE LOGIN
            ElevatedButton(
              onPressed: _login, 
              child: const Text('Entrar'),
            ),
            
            const SizedBox(height: 20),
            
            // BOTÃO PARA CADASTRO (NOVIDADE)
            TextButton(
              onPressed: () {
                // Navega para a tela de Cadastro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Não tem conta? Cadastre-se aqui'),
            ),
          ],
        ),
      ),
    );
  }
}