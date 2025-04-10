import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/song.dart';
import '../widgets/songs_list.dart';

// Define an enum for the repeat modes
enum RepeatMode {
  off,
  all,
  one,
}

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
  
  // Add repeat mode state
  RepeatMode _repeatMode = RepeatMode.off;

  // Stream subscriptions
  late final _positionSubscription;
  late final _durationSubscription;
  late final _playerStateSubscription;
  late final _processingStateSubscription;

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

    // Listen to processing state specifically for song completion
    _processingStateSubscription = widget.audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && mounted) {
        // Handle song completion based on repeat mode
        _handleSongCompletion();
      }
    });
    
    // Configure the AudioPlayer's loop mode based on our RepeatMode
    _updateAudioPlayerLoopMode();
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

  // Update the AudioPlayer's loop mode based on our RepeatMode
  void _updateAudioPlayerLoopMode() {
    switch (_repeatMode) {
      case RepeatMode.off:
        widget.audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatMode.all:
        widget.audioPlayer.setLoopMode(LoopMode.all);
        break;
      case RepeatMode.one:
        widget.audioPlayer.setLoopMode(LoopMode.one);
        break;
    }
  }

  // Handle song completion based on repeat mode
  void _handleSongCompletion() {
    switch (_repeatMode) {
      case RepeatMode.off:
        // If it's the last song, do nothing (playback stops)
        if (_currentSongIndex < _playlist.length - 1) {
          _playNextSong();
        }
        break;
      case RepeatMode.all:
        // If it's the last song, loop back to the first
        if (_currentSongIndex == _playlist.length - 1) {
          setState(() {
            _currentSongIndex = 0;
            _currentSong = _playlist[_currentSongIndex];
          });
          _playSong(_currentSong);
        } else {
          _playNextSong();
        }
        break;
      case RepeatMode.one:
        // Just replay the current song - it should be handled by AudioPlayer's loop mode
        // But we'll ensure it explicitly here
        _playSong(_currentSong);
        break;
    }
  }

  // Method to cycle through repeat modes
  void _cycleRepeatMode() {
    setState(() {
      switch (_repeatMode) {
        case RepeatMode.off:
          _repeatMode = RepeatMode.all;
          break;
        case RepeatMode.all:
          _repeatMode = RepeatMode.one;
          break;
        case RepeatMode.one:
          _repeatMode = RepeatMode.off;
          break;
      }
      // Update the AudioPlayer's loop mode when we change our repeat mode
      _updateAudioPlayerLoopMode();
    });
  }

  // Get the appropriate icon for the current repeat mode
  IconData _getRepeatIcon() {
    switch (_repeatMode) {
      case RepeatMode.off:
        return Icons.repeat;
      case RepeatMode.all:
        return Icons.repeat;
      case RepeatMode.one:
        return Icons.repeat_one;
    }
  }

  // Get the color for the repeat icon based on mode
  Color _getRepeatIconColor() {
    switch (_repeatMode) {
      case RepeatMode.off:
        return Colors.white70;
      case RepeatMode.all:
      case RepeatMode.one:
        return Colors.white;
    }
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions when widget is disposed
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    _processingStateSubscription.cancel();
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
      if (_currentSongIndex < _playlist.length - 1) {
        // Move to next song
        _currentSongIndex++;
      } else {
        // We're at the end, check if we should loop
        if (_repeatMode == RepeatMode.all) {
          _currentSongIndex = 0; // Loop back to first song
        } else {
          // If repeat is off, we'll stop at the last song
          return;
        }
      }
      _currentSong = _playlist[_currentSongIndex];
    });

    // Play the next song
    _playSong(_currentSong);
  }

  // Play the previous song in the playlist
  void _playPreviousSong() {
    if (_playlist.isEmpty) return;

    // If we're more than 3 seconds into the song, restart current song instead of previous
    if (_position.inSeconds > 3) {
      widget.audioPlayer.seek(Duration.zero);
      return;
    }

    setState(() {
      if (_currentSongIndex > 0) {
        // Move to previous song
        _currentSongIndex--;
      } else {
        // We're at the beginning, check if we should loop
        if (_repeatMode == RepeatMode.all) {
          _currentSongIndex = _playlist.length - 1; // Loop to the last song
        } else {
          // If repeat is off, we'll stay at the first song
          _currentSongIndex = 0;
        }
      }
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
                              onPressed: _playPreviousSong,
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
                              onPressed: _playNextSong,
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: Icon(
                                _getRepeatIcon(),
                                color: _getRepeatIconColor(), 
                                size: 24,
                              ),
                              onPressed: _cycleRepeatMode,
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        
                        // Display current repeat mode as text for better user feedback
                        const SizedBox(height: 8),
                        Text(
                          _repeatMode == RepeatMode.off 
                              ? 'Repeat: Off' 
                              : _repeatMode == RepeatMode.all 
                                  ? 'Repeat: All' 
                                  : 'Repeat: One',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
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