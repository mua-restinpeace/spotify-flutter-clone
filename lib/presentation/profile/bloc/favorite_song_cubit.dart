import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_user_favorite_songs.dart';
import 'package:spotify/presentation/profile/bloc/favorite_song_state.dart';
import 'package:spotify/service_locator.dart';

class FavoriteSongCubit extends Cubit<FavoriteSongState> {
  FavoriteSongCubit() : super(FavoriteSongLoading());

  Future<void> getUserFavoriteSongs() async {
    var result = await sl<GetUserFavoriteSongsUseCase>().call();

    result.fold((fail) {
      emit(FavoriteSongLoadFail());
    }, (favSongs) {
      emit(FavoriteSongLoaded(favSongList: favSongs));
    });
  }
}
