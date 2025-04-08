import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/song.dart';
import '../widgets/songs_list.dart';

class FullPlayer extends StatefulWidget {
  final Song song;
  final AudioPlayer audioPlayer;
  final bool isPlaying;

  const FullPlayer({
    Key? key,
    required this.song,
    required this.audioPlayer,
    required this.isPlaying,
  }) : super(key: key);

  @override
  State<FullPlayer> createState() => _FullPlayerState();
}

class _FullPlayerState extends State<FullPlayer> {
  bool _isPlaying = false;
  double _currentSliderValue = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Track the current song index in the playlist
  int _currentSongIndex = 0;
  // Reference to the playlist
  List<Song> _playlist = [];
  // Current song
  late Song _currentSong;

  // Stream subscriptions
  late final _positionSubscription;
  late final _durationSubscription;
  late final _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    _currentSong = widget.song;

    // Initialize the playlist and find current song index
    _initializePlaylist();

    // Set up position listener
    _positionSubscription = widget.audioPlayer.positionStream.listen((
      position,
    ) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _position = position;
          if (_duration.inMilliseconds > 0) {
            _currentSliderValue = (_position.inMilliseconds /
                    _duration.inMilliseconds *
                    100)
                .clamp(0.0, 100.0);
          }
        });
      }
    });

    // Set up duration listener
    _durationSubscription = widget.audioPlayer.durationStream.listen((
      duration,
    ) {
      if (duration != null && mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Set up player state listener
    _playerStateSubscription = widget.audioPlayer.playerStateStream.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    // Listen to play completion to handle auto-next
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && mounted) {
        _playNextSong();
      }
    });
  }

  void _initializePlaylist() {
    // Get the playlist from the SongsList
    final songsData = SongsList.getSongsList();

    setState(() {
      _playlist = songsData;
      // Find the index of the current song in the playlist
      _currentSongIndex = _playlist.indexWhere((s) => s.id == _currentSong.id);
      if (_currentSongIndex < 0) _currentSongIndex = 0; // Fallback if not found
    });
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions when widget is disposed
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // method to seek forward by 5 seconds
  void _seekForward() {
    final newPosition = _position + const Duration(seconds: 5);
    // Ensure we don't seek beyond the duration
    if (newPosition <= _duration) {
      widget.audioPlayer.seek(newPosition);
    } else {
      widget.audioPlayer.seek(_duration);
    }
  }

  // method to rewind by 5 seconds
  void _seekBackward() {
    final newPosition = _position - const Duration(seconds: 5);
    // Ensure we don't seek before the beginning
    if (newPosition.inMilliseconds > 0) {
      widget.audioPlayer.seek(newPosition);
    } else {
      widget.audioPlayer.seek(Duration.zero);
    }
  }

  // Play the next song in the playlist
  void _playNextSong() {
    if (_playlist.isEmpty) return;

    setState(() {
      // Move to next song, loop back to first if we're at the end
      _currentSongIndex = (_currentSongIndex + 1) % _playlist.length;
      _currentSong = _playlist[_currentSongIndex];
    });

    // Play the next song
    _playSong(_currentSong);
  }

  // Play the previous song in the playlist
  void _playPreviousSong() {
    if (_playlist.isEmpty) return;

    setState(() {
      // Move to previous song, loop to the last if we're at the beginning
      _currentSongIndex =
          (_currentSongIndex - 1 + _playlist.length) % _playlist.length;
      _currentSong = _playlist[_currentSongIndex];
    });

    // Play the previous song
    _playSong(_currentSong);
  }

  // Method to play a specific song
  Future<void> _playSong(Song song) async {
    // Stop any currently playing audio
    await widget.audioPlayer.stop();

    try {
      // Set the asset source - make sure the path is correctly set in pubspec.yaml
      await widget.audioPlayer.setAsset(song.path);
      await widget.audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 30, 1, 63),
              Color.fromARGB(255, 102, 10, 124),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Now Playing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 60, 10, 110),
                          Color.fromARGB(255, 150, 30, 180),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        size: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),

              // Song information and controls - more compact layout
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentSong.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentSong.artist,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Progress bar with rewind and forward buttons
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // 5-second rewind button
                            IconButton(
                              icon: const Icon(
                                Icons.replay_5,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: _seekBackward,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            // Slider taking most of the space
                            Expanded(
                              child: Slider(
                                value: _currentSliderValue,
                                min: 0,
                                max: 100,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white24,
                                onChanged: (double value) {
                                  setState(() {
                                    _currentSliderValue = value;
                                    if (_duration.inMilliseconds > 0) {
                                      final position =
                                          (_duration.inMilliseconds *
                                                  (value / 100))
                                              .round();
                                      widget.audioPlayer.seek(
                                        Duration(milliseconds: position),
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            // 5-second forward button
                            IconButton(
                              icon: const Icon(
                                Icons.forward_5,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: _seekForward,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),

                        // Time indicators
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                _formatDuration(_duration),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),

                        // Playback controls - reduced vertical spacing
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.shuffle,
                                color: Colors.white70,
                                size: 24,
                              ),
                              onPressed: () {},
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed:
                                  _playPreviousSong, // Connect to previous song method
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: const Color.fromARGB(
                                    255,
                                    102,
                                    10,
                                    124,
                                  ),
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_isPlaying) {
                                      widget.audioPlayer.pause();
                                    } else {
                                      widget.audioPlayer.play();
                                    }
                                  });
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed:
                                  _playNextSong, // Connect to next song method
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.repeat,
                                color: Colors.white70,
                                size: 24,
                              ),
                              onPressed: () {},
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}