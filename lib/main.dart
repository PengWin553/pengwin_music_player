import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));

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

      body: Column(
        children: [
          // Container with a background color for the Row
          Container(
            color: Colors.purple, // Set background color here
            // padding: EdgeInsets.symmetric(vertical: 10), // Optional padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.deepPurple,
                  child: Text('Songs', style: TextStyle(color: Colors.white)), // Color for individual items
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.deepPurple,
                  child: Text('Playlists', style: TextStyle(color: Colors.white)),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.deepPurple,
                  child: Text('Folders', style: TextStyle(color: Colors.white)),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.deepPurple,
                  child: Text('Albums', style: TextStyle(color: Colors.white)),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.deepPurple,
                  child: Text('Artists', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Another Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.blue,
                child: Text('Temp Container', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
