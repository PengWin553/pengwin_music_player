import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> mainMenu = [
    'Songs', 'Playlist', 'Folders', 'Albums', 'Artists'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(255, 52, 1, 114), Color.fromARGB(255, 126, 3, 156)],
        ),
      ),
      child: Scaffold(
        // By defaut, Scaffold background is white
        // Set its value to transparent
        backgroundColor: Colors.transparent,
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

          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),

        body: Column(
          children: [
            // Menu row
            Row(
              children: mainMenu.map((menuItem) {
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    child: Text(
                      menuItem,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}