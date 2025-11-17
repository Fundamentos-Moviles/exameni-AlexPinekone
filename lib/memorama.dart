import 'dart:math';

import 'package:flutter/material.dart';

class Memorama extends StatefulWidget {
  const Memorama({super.key});

  @override
  State<Memorama> createState() => _MemoramaState();
}

List<int> numeros = [];
List<List<int>> matriz = [];
List<List<int>> girados = [];
bool stop = false;
List<int> card1 = [-1, -1];
List<int> card2 = [-1, -1];
int parejas = 0;
int totalParejas = 0;

class _MemoramaState extends State<Memorama> {

  final TextEditingController filasController = TextEditingController(text: "5");
  final TextEditingController colsController = TextEditingController(text: "4");

  int filas = 5;
  int columnas = 4;

  @override
  void initState() {
    super.initState();
    restartAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
            const SizedBox(height: 10),
            const Text("Piña Becerril Manuel Alejandro",
              style: TextStyle(
                fontSize: 30,
              ),),
            const SizedBox(height: 10),

            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                child: TextField(
                  controller: filasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Filas"),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: colsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Cols"),
                ),
              ),
              const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  filas = int.tryParse(filasController.text) ?? 5;
                  columnas = int.tryParse(colsController.text) ?? 4;

                  // Validaciones
                  if (filas < 1 || filas > 8 || columnas < 2 || columnas > 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("El tamaño debe estar entre 1x2 y 8x8")),
                    );
                    return;
                  }

                  if ((filas * columnas) % 2 != 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("El número total de casillas debe ser par")),
                    );
                    return;
                  }

                  // Si pasa las validaciones, regeneramos el memorama
                  setState(() {

                  restartAll();
                });
              },
              child: const Text("Restart"),
            ),
            ],
            ),

            // Tablero
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int fila = 0; fila < filas; fila++) ...[
                    FilaM(fila),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          ],
          ),
          if (parejas == totalParejas) cartaGanar()
        ]
      )
    );
  }

  Center cartaGanar() {
    return Center(
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "¡Ganaste!"
                "    Presiona Restart",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Genera una fila de casillas
  Row FilaM(int fila) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int col = 0; col < columnas; col++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Casilla(
              fila: fila,
              col: col,
              value: matriz[fila][col],
              color: getColorFromNumber(matriz[fila][col]),
              onTap: () {
                setState(() {
                  if(stop == false) {
                    if (girados[fila][col] == 0) {
                      girados[fila][col] = 1;
                      if (card1[0] == -1) {
                        card1[0] = fila;
                        card1[1] = col;
                      } else {
                        card2[0] = fila;
                        card2[1] = col;
                        checkPair();
                      }
                    }
                  }else{
                      checkPair();
                  }
                });
              },
            ),
          ),
      ],
    );
  }

  // Casilla individual
  InkWell Casilla({required int fila, required int col, required int value, required Color color, required VoidCallback onTap,}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 65,
        height: 65,
        child: Container(
          decoration: BoxDecoration(
            color: girados[fila][col] == 0 ? Colors.grey : color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  //MatrizCosas
  void MatrizInit() {
    numeros.clear();

    int totalCartas = filas * columnas;
    totalParejas = totalCartas ~/ 2;

    for (int i = 0; i < totalParejas; i++) {
      numeros.add(i);
      numeros.add(i);
    }

    numeros.shuffle();
    matriz.clear();
    girados.clear();

    int cont = 0;
    for (int fila = 0; fila < filas; fila++) {
      List<int> filaTemp = [];
      for (int col = 0; col < columnas; col++) {
        debugPrint("Num: ${numeros[cont]}");
        filaTemp.add(numeros[cont]);
        cont++;
      }
      matriz.add(filaTemp);
    }
  }

  void GiradosInit() {
    girados = List.generate(
      filas,
          (_) => List.generate(columnas, (_) => 0),
    );
  }


  // Mapea número a color
  Color getColorFromNumber(int n) {
    switch (n) {
      case 0: return Colors.blue;
      case 1: return Colors.red;
      case 2: return Colors.yellow;
      case 3: return Colors.orange;
      case 4: return Colors.indigo;
      case 5: return Colors.pink;
      case 6: return Colors.purple;
      case 7: return Colors.green;
      case 8: return Colors.brown;
      case 9: return Colors.cyan;
      case 10: return Colors.amber;
      case 11: return Colors.blueGrey;
      case 12: return Colors.deepPurple;
      case 13: return Colors.lime;
      case 14: return Colors.teal;
      default: return randomColor();
    }
  }

  Color randomColor(){
    final Random random = Random();
    return Color(0xFF000000 + random.nextInt(0xFFFFFF));
  }

  bool checkPair(){
    bool res;

    if(matriz[card1[0]][card1[1]] == matriz[card2[0]][card2[1]]) {
      stop = false;
      res = true;
      card1[0] = -1;
      card1[1] = -1;
      card2[0] = -1;
      card2[1] = -1;
      parejas++;
    }else {
      if(stop == true){
        stop = false;
        girados[card1[0]][card1[1]] = 0;
        girados[card2[0]][card2[1]] = 0;
        card1[0] = -1;
        card1[1] = -1;
        card2[0] = -1;
        card2[1] = -1;
      }else{
        stop = true;
      }
      res = false;
    }
    return res;
  }

  void restartAll() {

    MatrizInit();
    GiradosInit();

    stop = false;
    card1 = [-1, -1];
    card2 = [-1, -1];
    parejas = 0;
  }
}