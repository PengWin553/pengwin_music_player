import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/song.dart';
import '../../features/songs/screens/full_player.dart';
import '../../features/songs/widgets/songs_list.dart';

class MiniPlayer extends StatefulWidget {
  final Song? currentSong;

  const MiniPlayer({Key? key, this.currentSong}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Track the current song index in the playlist
  int _currentSongIndex = 0;
  // Reference to the playlist - we'll initialize this when a song is played
  List<Song> _playlist = [];
  // Add this state variable to track the currently playing song
  Song? _currentSong;

  @override
  void initState() {
    super.initState();
    // Initialize audio session for better control
    _setupAudioPlayer();
    // Initialize the current song from widget prop
    _currentSong = widget.currentSong;
  }

  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the widget updates and there's a new song, play it
    if (widget.currentSong != null &&
        (oldWidget.currentSong == null ||
            widget.currentSong!.id != oldWidget.currentSong!.id)) {
      // Update our local state with the new song
      setState(() {
        _currentSong = widget.currentSong;
      });

      // We need to fetch the playlist and find the index of the current song
      _fetchPlaylistAndPlay(widget.currentSong!);
    }
  }

  // Fetch the playlist and find the current song's index
  void _fetchPlaylistAndPlay(Song song) {
    // Get the playlist from the SongsList
    final songsData = SongsList.getSongsList();

    setState(() {
      _playlist = songsData;
      // Find the index of the current song in the playlist
      _currentSongIndex = _playlist.indexWhere((s) => s.id == song.id);
      if (_currentSongIndex < 0) _currentSongIndex = 0; // Fallback if not found
    });

    // Play the song
    _playSong(song);
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

    // Listen to play completion to handle auto-next
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextSong();
      }
    });
  }

  Future<void> _playSong(Song song) async {
    // Stop any currently playing audio
    await _audioPlayer.stop();

    // Update the current song in state
    setState(() {
      _currentSong = song;
    });

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

  void _playNextSong() {
    if (_playlist.isEmpty) return;

    // Update index first
    setState(() {
      // Move to next song, loop back to first if we're at the end
      _currentSongIndex = (_currentSongIndex + 1) % _playlist.length;
    });

    // Then play the next song (which will update _currentSong)
    _playSong(_playlist[_currentSongIndex]);
  }

  void _playPreviousSong() {
    if (_playlist.isEmpty) return;

    // Update index first
    setState(() {
      // Move to previous song, loop to the last if we're at the beginning
      _currentSongIndex =
          (_currentSongIndex - 1 + _playlist.length) % _playlist.length;
    });

    // Then play the previous song (which will update _currentSong)
    _playSong(_playlist[_currentSongIndex]);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If no song is selected, hide the miniplayer
    if (_currentSong == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _navigateToFullPlayer(context, _currentSong!);
      },
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

            // Song info - Use _currentSong instead of widget.currentSong
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentSong!.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _currentSong!.artist,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: _playPreviousSong,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: _playNextSong,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFullPlayer(BuildContext context, Song song) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => FullPlayer(
              song: song,
              audioPlayer: _audioPlayer,
              isPlaying: _isPlaying,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          // Create a sliding animation from bottom to top
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        maintainState: true,
        opaque: true, // Set to true to prevent see-through background
      ),
    );
  }
}
