class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final String path;
  final String cover;
  final Duration duration;  // Track length
  final int trackNumber;    // Position in album
  final int year;          // Release year
  final int fileSize;      // In bytes
  
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    this.genre = '',
    required this.path,
    this.cover = '',
    required this.duration,
    this.trackNumber = 0,
    this.year = 0,
    this.fileSize = 0,
  });
}