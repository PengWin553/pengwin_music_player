import 'package:flutter/material.dart';
import '../../../data/models/song.dart';

class FullPlayer extends StatefulWidget {
  final Song song;
  
  const FullPlayer({Key? key, required this.song}) : super(key: key);

  @override
  State<FullPlayer> createState() => _FullPlayerState();
}

class _FullPlayerState extends State<FullPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  bool _isPlaying = true;
  double _currentSliderValue = 20;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 180), // 3 minutes song
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addListener(() {
        setState(() {
          _currentSliderValue = _progressAnimation.value;
        });
      });
    
    // Auto-start playback animation
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  String _formatDuration(double value) {
    final totalSeconds = (value / 100 * 180).round(); // 3 minutes in seconds
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
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
                              _controller.value = value / 100;
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
                                _formatDuration(_currentSliderValue),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const Text(
                                '3:00',
                                style: TextStyle(color: Colors.white70),
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
                                    _isPlaying = !_isPlaying;
                                    if (_isPlaying) {
                                      _controller.forward();
                                    } else {
                                      _controller.stop();
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