import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';

class FavoriteCubitManager {
  final Map<String, FavoriteButtonCubit> _cubitMap = {};

  FavoriteButtonCubit getCubit(String songId){
    if(!_cubitMap.containsKey(songId)){
      final cubit = FavoriteButtonCubit();
      cubit.loadInitialsFavoriteStatus(songId);
      _cubitMap[songId] = cubit;
    }
    return _cubitMap[songId]!;
  }
}