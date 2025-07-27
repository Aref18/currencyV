import 'package:flutter/material.dart';

void main() {
  runApp(currencyV());
}

class currencyV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          actions: [
            SizedBox(width: 10),
            Icon(Icons.menu),

            Spacer(),
            Text(
              'currencyV',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 169, 124, 108),
              backgroundImage: AssetImage('assets/images/V.png'),
              radius: 20,
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
