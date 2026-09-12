import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitials());

  void loadInitialsFavoriteStatus(String songId) async{
    var result = await sl<IsFavoriteSongUseCase>().call(params: songId);
    emit(FavoriteButtonUpdated(isFavorite: result));
  }

  void favoriteButtonUpdated(String songId) async {
    var result =
        await sl<AddOrRemoveFavoriteSongUseCase>().call(params: songId);

    result.fold((failure) {}, (isFavorite) {
      emit(FavoriteButtonUpdated(isFavorite: isFavorite));
    });
  }

  @override
  Future<void> close() {
    debugPrint('FavoriteSongCubit closed');
    return super.close();
  }
}
