import 'package:spotify/domain/entities/song/songs.dart';

abstract class PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final List<SongEntity> songs;

  PlaylistLoaded({required this.songs});
}

class PlaylistLoadError extends PlaylistState{}
