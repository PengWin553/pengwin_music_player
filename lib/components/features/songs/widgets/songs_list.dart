import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/song.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  List<Song> songs = [
    Song(title: "Compared Child", artist: "TUYU"),
    Song(title: "It's Raining After All", artist: "TUYU"),
    Song(title: "Moonlight", artist: "Suisei"),
    Song(title: "Tabun", artist: "Yoasobi"),
    Song(title: "Gurenge", artist: "LiSa"),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              songs.map((song) {
                return Container(
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
                              Radius.circular(10.0),
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
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start, // This aligns children to the left
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
                          onPressed: () {},
                          icon: Icon(Icons.more_vert),
                          color: Colors.white,
                          iconSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        )
    ;
  }
}
