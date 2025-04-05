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
    Song(title: "Compared Child", artist: "TUYU"),
    Song(title: "It's Raining After All", artist: "TUYU"),
    Song(title: "Moonlight", artist: "Suisei"),
    Song(title: "Tabun", artist: "Yoasobi"),
    Song(title: "Gurenge", artist: "LiSa"),
    Song(title: "Cruel Angel's Thesis", artist: "Yoko Takahashi"),
    Song(title: "Renai Circulation", artist: "Kana Hanazawa"),
    Song(title: "Unlasting", artist: "LiSa"),
    Song(title: "Gotoubun no Katachi", artist: "Nakano Quintuplets"),
    Song(title: "Fly Me to the Moon", artist: "Claire"),
    Song(title: "Unravel", artist: "TK from Ling Tosite Sigure"),
    Song(title: "Blue Bird", artist: "Ikimono Gakari"),
    Song(title: "Resister", artist: "ASCA"),
    Song(title: "Kawaki wo Ameku", artist: "Minami"),
    Song(title: "RISE", artist: "MADKID"),
    Song(title: "Black Catcher", artist: "Vickeblanka"),
    Song(title: "Kaikai Kitan", artist: "Eve"),
    Song(title: "Sparkle", artist: "RADWIMPS"),
    Song(title: "Nandemonaiya", artist: "RADWIMPS"),
    Song(title: "Grand Escape", artist: "RADWIMPS ft. Toko Miura"),
    Song(title: "Suzume", artist: "RADWIMPS ft. Toaka"),
    Song(title: "Racing Into The Night", artist: "YOASOBI"),
    Song(title: "Idol", artist: "YOASOBI"),
    Song(title: "Monster", artist: "YOASOBI"),
    Song(title: "Haruka", artist: "YOASOBI"),
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