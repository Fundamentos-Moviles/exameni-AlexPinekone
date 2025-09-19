import 'package:flutter/material.dart';

class Memorama extends StatefulWidget {
  const Memorama({super.key});

  @override
  State<Memorama> createState() => _MemoramaState();
}

List<int> numeros = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9];
List<List<int>> matriz = [];
List<List<int>> girados = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
];
bool stop = false;
List<int> card1 = [-1, -1];
List<int> card2 = [-1, -1];

int parejas = 0;

class _MemoramaState extends State<Memorama> {
  @override
  void initState() {
    super.initState();
    MatrizInit(); // Se inicializa una vez
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
            const SizedBox(height: 10),
            const Text("Piña Becerril Manuel Alejandro"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  restartAll();
                });
              },
              child: const Text("Restart"),
            ),

            // Tablero
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int fila = 0; fila < 5; fila++) ...[
                    FilaM(fila),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          ],
          ),
          if (parejas == 10) cartaGanar()
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
              fontSize: 24,
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
        for (int col = 0; col < 4; col++)
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
        width: 120,
        height: 120,
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
  void MatrizInit(){

    numeros.shuffle();
    matriz.clear();

    int cont = 0;

    for (int fila = 0; fila < 5; fila++) {
      List<int> filaTemp = [];
      for (int col = 0; col < 4; col++) {
        filaTemp.add(numeros[cont]);
        cont++;
      }
      matriz.add(filaTemp);
    }
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
      default: return Colors.grey;
    }
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

    for (int i = 0; i < girados.length; i++) {
      for (int j = 0; j < girados[i].length; j++) {
        girados[i][j] = 0;
      }
    }

    stop = false;
    card1 = [-1, -1];
    card2 = [-1, -1];
    parejas = 0;
  }
}