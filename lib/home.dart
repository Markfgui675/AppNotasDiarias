import 'package:app_anotacao/model/Anotacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'helper/AnotacaoHelper.dart';





class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {




  TextEditingController _tarefa = TextEditingController();
  TextEditingController _descricaoTarefa = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = <Anotacao>[];

  _exibirTelaCadastro( {Anotacao? anotacao} ){

    String textoSalvarAtualizar = '';
    if(anotacao == null){//salvando
      _tarefa.text='';
      _descricaoTarefa.text='';
      textoSalvarAtualizar='Salvar';
    }else{//atualizar
      _tarefa.text= anotacao.titulo!;
      _descricaoTarefa.text= anotacao.descricao!;
      textoSalvarAtualizar='Atualizar';
    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('$textoSalvarAtualizar anotação'),
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
              FloatingActionButton(onPressed: ()=>Navigator.pop(context), child: Icon(Icons.cancel),
                backgroundColor: Colors.red,),

              FloatingActionButton(onPressed: (){
                //salvar nota
                _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                Navigator.pop(context);
              }, child: Icon(Icons.check), backgroundColor: Colors.green,),
            ],
          );
        }
    );

  }

  _recuperarAnotacoes() async {

    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao>? listaTemporaria = <Anotacao>[];
    for (var item in anotacoesRecuperadas){

      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);

    }
    setState(() {
      _anotacoes = listaTemporaria!;
    });
    listaTemporaria = null;
    //print('Lista anotacoes: '+anotacoesRecuperadas.toString());

  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tarefa.text;
    String descricao = _descricaoTarefa.text;

    if(anotacaoSelecionada == null){//salvar

      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao( anotacao );
      print('salvar anotacao: '+resultado.toString());

    }else{//atualizando

      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);

    }


    _tarefa.text = '';
    _descricaoTarefa.text = '';

    _recuperarAnotacoes();
  }

  _formatarData(String data){

    initializeDateFormatting('pt_BR');

    var formatador = DateFormat('d/M/y');
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format( dataConvertida );

    return dataFormatada;

  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }












  @override
  Widget build(BuildContext context) {
    _recuperarAnotacoes();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: <Widget>[
          Expanded(child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index){

                final anotacao = _anotacoes[index];

                return Card(
                  child: ListTile(
                    title: Text(anotacao.titulo.toString()),
                    subtitle: Text('${_formatarData(anotacao.data.toString())} - ${anotacao.descricao}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            _exibirTelaCadastro(anotacao: anotacao);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.edit, color: Colors.green,),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Icon(Icons.remove_circle, color: Colors.red,),
                        )
                      ],
                    ),
                  ),
                );
              }))
        ],
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
