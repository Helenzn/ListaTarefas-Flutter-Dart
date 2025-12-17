import 'package:flutter/material.dart';

class Tarefa{
  String nome;
  DateTime data = DateTime.now();
  bool concluida = false;
  Tarefa(this.nome){
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new TodoListApp());
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TodoList App',
      home: new ListaScreen()
      );
  }
}

class ListaScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new ListaScreenState();
  }
}

class ListaScreenState extends State<ListaScreen>{
  List<Tarefa> tarefas = <Tarefa>[];
  TextEditingController controller = new TextEditingController();
  
void adicionaTarefa(String nome){
  setState(() {
    tarefas.add(Tarefa(nome));
  });  
  controller.clear();
}

void removeTarefa(int index) {
  setState(() {
  tarefas.removeAt(index);
  });
}

void editaTarefa(int index, String novoNome) {
  setState(() {
  tarefas[index].nome = novoNome;
  });
}

Widget getItem(Tarefa tarefa, int index) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: new Icon(tarefa.concluida ? Icons.check_box : Icons.check_box_outline_blank, size: 42.0, color: Colors.green),
          padding: EdgeInsets.only(left: 10.0, right: 30.0),
          onPressed: () {
            setState(() {
              tarefa.concluida = !tarefa.concluida;
            });
          },
        ),
        new Expanded (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(tarefa.nome), 
              Text(tarefa.data.toIso8601String())
            ],
        ),   
    ),
    
    IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final editController = TextEditingController(text: tarefa.nome);
                return AlertDialog(
                  title: Text('Editar Tarefa'),
                  content: TextField(controller: editController),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        editaTarefa(index, editController.text);
                        Navigator.pop(context);
                      },
                      child: Text('Salvar'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            removeTarefa(index);
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Lista de Tarefas'),
        backgroundColor: const Color.fromARGB(255, 213, 188, 255)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
              hintText: '  Digite uma tarefa...',
              ),
              onSubmitted: (value) {
                adicionaTarefa(value);
              },
            )
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, indice){
                return getItem(tarefas[indice], indice);
              },
            ),
          ),
        ],
      ),
    );
  }
}
