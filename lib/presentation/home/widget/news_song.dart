import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_cubit_manager.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/helpers/url_fetch.dart';
import 'package:spotify/presentation/home/bloc/news_song_cubit.dart';
import 'package:spotify/presentation/home/bloc/news_song_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player_page.dart';
import 'package:spotify/service_locator.dart';

class NewsSong extends StatelessWidget {
  final favoriteManager = sl<FavoriteCubitManager>();
  NewsSong({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit, NewsSongState>(
            builder: (context, state) {
          if (state is NewsSongsLoading) {
            return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          }

          if (state is NewsSongsLoaded) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: state.songs.length,
                itemBuilder: (context, index) {
                  final song = state.songs[index];
                  final favoriteCubit = favoriteManager.getCubit(song.songId);

                  return BlocProvider.value(
                    value: favoriteCubit,
                    child:
                        BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
                            builder: (context, favState) {
                      return GestureDetector(
                        onTap: () {
                          var result = Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SongPlayerPage(
                                        song: song
                                      )));
                          if (result == true) {
                            favoriteCubit
                                .loadInitialsFavoriteStatus(song.songId);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: SizedBox(
                            width: 160,
                            // height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(songCoverUrl(
                                                '${song.title} by ${song.artist}.jpg')))),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        transform: Matrix4.translationValues(
                                            10, 10, 0),
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: context.isDarkMode
                                                ? const Color(0xff2C2C2C)
                                                : const Color(0xffE6E6E6)),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: context.isDarkMode
                                              ? const Color(0xff959595)
                                              : const Color(0xff555555),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  song.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  song.artist,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                });
          }

          if (state is NewsSongsLoadFailure) {
            return ScaffoldMessenger(child: Text(state.toString()));
          }

          return Container();
        }),
      ),
    );
  }
}
