import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            // Container with a background color for the Row
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      child: Text(
                        'Songs',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ), // Color for individual items
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      child: Text(
                        'Playlists',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      child: Text(
                        'Folders',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      child: Text(
                        'Albums',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      child: Text(
                        'Artists',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
