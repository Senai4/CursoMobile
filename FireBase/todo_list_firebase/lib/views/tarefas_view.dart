import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  //atributos
  final _db = FirebaseFirestore.instance; //controller para enviar tarefas para o BS FireStore
  final User? _user = FirebaseAuth.instance.currentUser; //pega o usuário logado atualmente
  final _tarefasField = TextEditingController(); //pegar o título da tarefa

  //métodos do CRUD
  //addTarefa
  void _addTarefa() async{
    //verificar se o campo de texto não esta vazio
    if(_tarefasField.text.trim().isEmpty) return; //return null
    //adicionar a tarefa ao banco
    try {
      await _db.collection("usuarios")
      .doc(_user!.uid)
      .collection("tarefas")
      .add({
        "titulo":_tarefasField.text.trim(),
        "concluida":false,
        "dataCriacao": Timestamp.now()
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao adicionar Tarefa: $e"))
      );
    }
  }

  //updateTarefa
  void _updateTarefa(String tarefaID, bool statusTarefa) async{
    await _db.collection("usuarios")
    .doc(_user!.uid)
    .collection("tarefas")
    .doc(tarefaID)
    .update({"concluida":!statusTarefa}); //inverte o status da tarefa
  }

  //deleteTArefa
  void _deleteTarefa(String tarefaID) async{
    //posso criar um alert para confirmar a exclusão da tarefa
    await _db.collection("usuarios")
    .doc(_user!.uid)
    .collection("tarefas")
    .doc(tarefaID)//passa o id da tarefa a ser deletada
    .delete();
  }

  //listar tarefas será feita diretamente no build da tela (StreamBuilder)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Tarefas"),
        actions: [
          IconButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _tarefasField,
            decoration: InputDecoration(
              labelText: "Nova Tarefa",
              border: OutlineInputBorder(),
              suffix: IconButton(
                onPressed: _addTarefa, 
                icon: Icon(Icons.add, color: Colors.green,))
            ),
          ),
          SizedBox(height: 16,),
          Expanded(
            child: StreamBuilder<QuerySnapshot>( //dependendo do resultado da Query exibe a tela desejada
              stream: _db.collection("usuarios")
                          .doc(_user?.uid)
                          .collection("tarefas")
                          .orderBy("dataCriacao", descending: true)
                          .snapshots(), //consulta a lista de tarefas (ordena pela data de criacao)
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                  return Center(child: Text("Nenhuma Tarefa Cadastrada"),);
                }
                //exibir as tarefas
                final tarefas = snapshot.data!.docs;//adicona a busca ao vetor de tarefas
                return ListView.builder(
                  itemCount: tarefas.length, //conta o numero de tarefas no vetor
                  itemBuilder: (context, index){
                    final tarefa = tarefas[index]; //tarefa em formato Json
                    final tarefaMap = tarefa.data() as Map<String,dynamic>;
                    //ajusta da variavel booleana
                    bool concluida = tarefaMap["concluida"] == true ? true : false;
                    //bool concluida = tarefaMap["concluida"] == 1 ? true : false;
                    //bool concluida = tarefaMap["concluida"] ?? false; // se for nulo atribui false
                    //fazer o item da lista
                    return ListTile(
                      title: Text(tarefaMap["titulo"]),
                      leading: Checkbox(
                        value: concluida, 
                        onChanged: (value){
                          setState(() {
                            //concluida = !concluida;
                            _updateTarefa(tarefa.id, concluida);
                          });
                        }),
                      trailing: IconButton(
                        onPressed: () => _deleteTarefa(tarefa.id), 
                        icon: Icon(Icons.delete, color: Colors.red,)),
                    );
                  });
              }))
        ],
      ),),
    );
  }
}