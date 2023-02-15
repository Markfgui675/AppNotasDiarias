import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tarefa = TextEditingController();
  TextEditingController _descricaoTarefa = TextEditingController();

  _exibirTelaCadastro(){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Adicionar anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tarefa,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Nota', hintText: 'Digite o título'),
                ),
                TextField(
                  controller: _descricaoTarefa,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Descrição', hintText: 'Digite a descrição'),
                ),
              ],
            ),
            actions: <Widget>[
              FloatingActionButton(onPressed: ()=>Navigator.pop(context), child: Icon(Icons.check),
                backgroundColor: Colors.green,),

              FloatingActionButton(onPressed: (){
                //salvar nota
                Navigator.pop(context);
              }, child: Icon(Icons.cancel), backgroundColor: CupertinoColors.destructiveRed,),
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _exibirTelaCadastro();
        },
        backgroundColor: Colors.green,
        icon: Icon(Icons.add),
        label: Text('Adicionar Nota'),
        elevation: 10,
      )
    );
  }
}
