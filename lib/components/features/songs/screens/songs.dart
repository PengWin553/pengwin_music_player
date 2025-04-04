import 'package:flutter/material.dart';
import '../widgets/songs_list.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: const Songs()));

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // horizontal alignment
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // vertical alignment
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '314 Songs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 14.00,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.shuffle),
                    color: Colors.white,
                    iconSize: 22.00,
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.sort),
                    color: Colors.white,
                    iconSize: 18.00,
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.checklist),
                    color: Colors.white,
                    iconSize: 18.00,
                  ),
                ],
              ),
            ),
          ],
        ),

        SongsList(),

      ],
    );
  }
}

