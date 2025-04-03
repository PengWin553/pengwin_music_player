import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  )
);

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('My App'), // Add a title if needed
        leading: IconButton(
          // left icon
          onPressed: () {
            // print('You clicked me, an IconButton.');
          },
          icon: Icon(Icons.menu),
          color: Colors.white,
        ),

        actions: [
          // right-aligned icons
          IconButton(
            onPressed: () {
              // print('You clicked me, an IconButton.');
            },
            icon: Icon(Icons.search_sharp),
            color: Colors.white,
          ),
        ],
        
        backgroundColor: Colors.purple[900],
        foregroundColor: Colors.white,
      ),
    );
  }
}
