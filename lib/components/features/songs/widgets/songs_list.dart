import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/song.dart';

class SongsList extends StatefulWidget {
  final Function(Song)? onSongSelected;
  
  const SongsList({super.key, this.onSongSelected});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  List<Song> songs = [
    Song(
      id: 1,
      title: "Compared Child",
      artist: "TUYU",
      album: "Compared Child",
      path: "assets/music/Compared Child.mp3",
      duration: const Duration(minutes: 3, seconds: 36),
    ),
    Song(
      id: 2,
      title: "It's Raining After All",
      artist: "TUYU",
      album: "It's Raining After All",
      path: "assets/music/Its Raining After All.mp3",
      duration: const Duration(minutes: 4, seconds: 06),
    ),
    Song(
      id: 3,
      title: "Moonlight",
      artist: "Suisei",
      album: "Stellar Moments",
      path: "assets/music/Moonlight.mp3",
      duration: const Duration(minutes: 3, seconds: 25),
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Important: disable scrolling in this ListView since the parent SingleChildScrollView handles it
      physics: NeverScrollableScrollPhysics(),
      // Important: ensure the ListView doesn't try to be infinitely tall
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return InkWell(
          onTap: () {
            if (widget.onSongSelected != null) {
              widget.onSongSelected!(song);
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // left container
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 43, 1, 92),
                          Color.fromARGB(255, 126, 13, 154),
                        ],
                      ),
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Icon(
                      CupertinoIcons.music_note,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),

                // center container
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 0, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          song.artist,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // right container
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      // Show options menu
                    },
                    icon: Icon(Icons.more_vert),
                    color: Colors.white,
                    iconSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}