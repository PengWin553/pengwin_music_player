import 'package:flutter/material.dart';
import '../../data/models/song.dart';
import '../../features/songs/screens/full_player.dart';

class MiniPlayer extends StatelessWidget {
  final Song? currentSong;

  const MiniPlayer({Key? key, this.currentSong}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no song is selected, hide the miniplayer
    if (currentSong == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _navigateToFullPlayer(context, currentSong!);
      },
      child: Hero(
        tag: 'player-${currentSong!.title}',
        child: Material(
          // Material is needed for the Hero animation to work with text
          color: Colors.transparent,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 43, 1, 92),
                  Color.fromARGB(255, 126, 13, 154),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Song icon/art
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 60, 10, 110),
                        Color.fromARGB(255, 150, 30, 180),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                // Song info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong!.artist,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add previous song functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.play_arrow, // or Icons.pause
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add play/pause functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add next song functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToFullPlayer(BuildContext context, Song song) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FullPlayer(song: song),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          
          // Create a sliding animation from bottom to top
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}