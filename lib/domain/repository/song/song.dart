import 'package:dartz/dartz.dart';

abstract class SongRepository{
  Future<Either> getNewsSong();
  Future<Either> playlistSong();
  Future<Either> addOrRemoveFavoriteSong(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
}