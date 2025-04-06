import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/song.dart';
import '../../features/songs/screens/full_player.dart';

class MiniPlayer extends StatefulWidget {
  final Song? currentSong;

  const MiniPlayer({Key? key, this.currentSong}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize audio session for better control
    _setupAudioPlayer();
  }
  
  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the widget updates and there's a new song, play it
    if (widget.currentSong != null && 
        (oldWidget.currentSong == null || 
         widget.currentSong!.id != oldWidget.currentSong!.id)) {
      _playSong(widget.currentSong!);
    }
  }
  
  void _setupAudioPlayer() {
    // Listen to playback events
    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing != _isPlaying) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
  }
  
  Future<void> _playSong(Song song) async {
    // Stop any currently playing audio
    await _audioPlayer.stop();
    
    try {
      // Set the asset source - make sure the path is correctly set in pubspec.yaml
      await _audioPlayer.setAsset(song.path);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }
  
  void _togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If no song is selected, hide the miniplayer
    if (widget.currentSong == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _navigateToFullPlayer(context, widget.currentSong!);
      },
      child: Hero(
        tag: 'player-${widget.currentSong!.title}',
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
                        widget.currentSong!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.currentSong!.artist,
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
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
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
        pageBuilder: (context, animation, secondaryAnimation) => 
            FullPlayer(song: song, audioPlayer: _audioPlayer, isPlaying: _isPlaying),
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