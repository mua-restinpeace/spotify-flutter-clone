import 'package:spotify/domain/entities/song/songs.dart';

abstract class FavoriteSongState {}

class FavoriteSongLoading extends FavoriteSongState {}

class FavoriteSongLoaded extends FavoriteSongState {
  final List<SongEntity> favSongList;

  FavoriteSongLoaded({required this.favSongList});
}

class FavoriteSongLoadFail extends FavoriteSongState {}
