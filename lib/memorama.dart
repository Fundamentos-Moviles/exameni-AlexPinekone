import 'package:flutter/material.dart';

class Memorama extends StatefulWidget {
  const Memorama({super.key});

  @override
  State<Memorama> createState() => _MemoramaState();
}

List<int> numeros = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9];
List<List<int>> matriz = [];

class _MemoramaState extends State<Memorama> {
  var c1 = 1;

  @override
  void initState() {
    super.initState();
    MatrizInit();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text("Piña Becerril Manuel Alejandro"),

          //Tablero
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int fila = 0; fila < 5; fila++) ...[
                  FilaM(matriz[fila]),
                  const SizedBox(height: 2),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Fila
  Row FilaM(List<int> numcolores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numcolores
          .map(
            (num) => Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Casilla(
              color: getColorFromNumber(num),
              onTap: () {
                setState(() {
                  //c1 = color.value;
                });
                debugPrint("Tocaste casilla color $num");
              },
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  ///Casilla individual
  InkWell Casilla({required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  //MatrizCosas
  void MatrizInit(){

    numeros.shuffle();

    int cont = 0;

    for (int fila = 0; fila < 5; fila++) {
      for(int colu = 0; colu <4; colu++){
        matriz[fila][colu] = numeros[cont];
        cont++;
      }
    }
  }

  Color getColorFromNumber(int n) {
    switch (n) {
      case 0: return Colors.blue;
      case 1: return Colors.red;
      case 2: return Colors.yellow;
      case 3: return Colors.orange;
      case 4: return Colors.white;
      case 5: return Colors.pink;
      case 6: return Colors.purple;
      case 7: return Colors.green;
      case 8: return Colors.brown;
      case 9: return Colors.cyan;
      default: return Colors.grey;
    }
  }
}