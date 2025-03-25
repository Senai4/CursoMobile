import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

//Construir a Janela
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo Widget de Exibição"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Olá, Flutter!!!", style: TextStyle(fontSize: 20, color: Colors.blue)),
            Text("Flutter é Incrível!!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              letterSpacing: 2
            ),), // Texto Personalizado
            Icon(Icons.star, size: 50, color: Colors.amber,),
            IconButton(
              onPressed: ()=> print("Icone Pressionado"),
               icon: Icon(Icons.notifications, size: 50,)),
              //Imagens
               Image.network("https://petitgato.com.br/img/webp/gatos-persas-em-sao-paulo-img-3780.webp",
               height: 300,
               width: 300,
               fit: BoxFit.cover,),
               //Imagem local
               Image.asset("assets/img/image.png",
               height: 300,
               width: 300,
               fit: BoxFit.cover,)
          ],
        ),
      )
    );
  }
}
