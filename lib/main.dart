import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:viacep/componentes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController txtCep = TextEditingController();
  GlobalKey<FormState> cForm = GlobalKey<FormState>();
  String rua = "Rua:";
  String complemento = "Complemento: ";
  String bairro = "Bairro:";
  String cidade = "Cidade:";
  String uf = "UF:";

  Function validaCep = ((value) {
    if (value.isEmpty) {
      return "Cep inválido";
    }
    return null;
  });

  clicouBotao() async {
    if (!cForm.currentState.validate()) return;
    String url = "https://viacep.com.br/ws/${txtCep.text}/json/";
    Response resposta = await get(url);
    Map endereco = json.decode(resposta.body);
    setState(() {
      rua = endereco["logradouro"];
      complemento = endereco["complemento"];
      bairro = endereco["bairro"];
      cidade = endereco["localidade"];
      uf = endereco["uf"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: cForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset(
                  "assets/imgs/logo.jpg",
                  fit: BoxFit.contain,
                ),
              ),
              Componentes.caixaDeTexto("CEP", "Digite o CEP", txtCep, validaCep,
                  numero: true),
              Container(
                alignment: Alignment.center,
                height: 100,
                child: IconButton(
                  onPressed: clicouBotao,
                  icon: FaIcon(
                    FontAwesomeIcons.globe,
                    size: 64,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Componentes.rotulo(rua),
                    Componentes.rotulo(complemento),
                    Componentes.rotulo(bairro),
                    Componentes.rotulo(cidade),
                    Componentes.rotulo(uf),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
