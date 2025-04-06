import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/song.dart';

class FullPlayer extends StatefulWidget {
  final Song song;
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  
  const FullPlayer({
    Key? key, 
    required this.song, 
    required this.audioPlayer, 
    required this.isPlaying
  }) : super(key: key);

  @override
  State<FullPlayer> createState() => _FullPlayerState();
}

class _FullPlayerState extends State<FullPlayer> {
  bool _isPlaying = false;
  double _currentSliderValue = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  // Stream subscriptions
  late final _positionSubscription;
  late final _durationSubscription;
  late final _playerStateSubscription;
  
  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    
    // Set up position listener
    _positionSubscription = widget.audioPlayer.positionStream.listen((position) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _position = position;
          if (_duration.inMilliseconds > 0) {
            _currentSliderValue = (_position.inMilliseconds / _duration.inMilliseconds * 100)
                .clamp(0.0, 100.0);
          }
        });
      }
    });
    
    // Set up duration listener
    _durationSubscription = widget.audioPlayer.durationStream.listen((duration) {
      if (duration != null && mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });
    
    // Set up player state listener
    _playerStateSubscription = widget.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
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
              
              // Album artwork - using less vertical space
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
                          widget.song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.song.artist,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        // Progress bar
                        const SizedBox(height: 16),
                        Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: 100,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white24,
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                              if (_duration.inMilliseconds > 0) {
                                final position = (_duration.inMilliseconds * (value / 100)).round();
                                widget.audioPlayer.seek(Duration(milliseconds: position));
                              }
                            });
                          },
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
                              icon: const Icon(Icons.shuffle, color: Colors.white70, size: 24),
                              onPressed: () {},
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                              onPressed: () {},
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
                                  color: const Color.fromARGB(255, 102, 10, 124),
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
                              icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                              onPressed: () {},
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.repeat, color: Colors.white70, size: 24),
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