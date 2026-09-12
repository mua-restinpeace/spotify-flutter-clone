import 'package:spotify/domain/entities/song/songs.dart';

abstract class NewsSongState {}

class NewsSongsLoading extends NewsSongState{}

class NewsSongsLoaded extends NewsSongState{
  final List<SongEntity> songs;

  NewsSongsLoaded({required this.songs});
}

class NewsSongsLoadFailure extends NewsSongState{}