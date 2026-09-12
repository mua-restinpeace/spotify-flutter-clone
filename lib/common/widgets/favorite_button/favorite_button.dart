import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_cubit_manager.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/domain/entities/song/songs.dart';
import 'package:spotify/service_locator.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity song;
  const FavoriteButton(
      {required this.song,
      super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteManager = sl<FavoriteCubitManager>();
    final favoriteCubit = favoriteManager.getCubit(song.songId);
    return BlocProvider.value(
      value: favoriteCubit,
      child: BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
        bloc: favoriteManager.getCubit(song.songId),
        builder: (context, state) {
          return IconButton(
              onPressed: (){
                context.read<FavoriteButtonCubit>().favoriteButtonUpdated(song.songId);
              },
              icon: Icon(
                state is FavoriteButtonUpdated && state.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: context.isDarkMode
                    ? const Color(0xff565656)
                    : const Color(0xffB4B4B4),
              ));
        },
      ),
    );
  }
}
