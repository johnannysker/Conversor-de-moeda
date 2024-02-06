import 'package:conversor/main.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final realController = TextEditingController();
final dolarController = TextEditingController();
final euroController = TextEditingController();

double? dolar;
double? euro;

void realChanged(String texto) {
  String texto1 = "0.01";
  double real = texto != "" ? double.parse(texto) : double.parse(texto1);
  dolarController.text = (real / dolar!).toStringAsFixed(2);
  euroController.text = (real / euro!).toStringAsFixed(2);
}

void dolarChanged(String texto) {
  double dolari = double.parse(texto);
  realController.text = (dolari * dolar!).toStringAsFixed(2);
  euroController.text = (dolari * dolar! / euro!).toStringAsFixed(2);
}

void euroChanged(String texto) {
  double euru = double.parse(texto);
  realController.text = (euru * euro!).toStringAsFixed(2);
  euroController.text = (euru * euro! / dolar!).toStringAsFixed(2);
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "\$ Conversor \$",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text(
                    "Conexão Falhou!",
                    style: TextStyle(color: Colors.amberAccent, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    "Carregando Dados",
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amberAccent, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        const Text(
                          "Faça a conversão entre moedas.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(255, 224, 224, 224),
                              fontSize: 18),
                        ),
                        buildTextFild(
                            "Reais", "R\$ ", realController, realChanged),
                        const Divider(),
                        buildTextFild(
                            "Dolares", "US\$ ", dolarController, dolarChanged),
                        const Divider(),
                        buildTextFild(
                            "Euros", "EU ", euroController, euroChanged),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            onPressed: () => {
                              realController.clear(),
                              euroController.clear(),
                              dolarController.clear()
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 236, 236, 236),
                            ),
                            child: const Text("Limpar",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextFild(
    String label, String prefix, TextEditingController dado, Function cgd) {
  return TextField(
    controller: dado,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 22, color: Colors.amberAccent),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(color: Colors.amberAccent),
    onChanged: (String a) => cgd(a),
  );
}
