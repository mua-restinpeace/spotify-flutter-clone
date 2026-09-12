import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_news_song.dart';
import 'package:spotify/presentation/home/bloc/news_song_state.dart';
import 'package:spotify/service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongState> {
  NewsSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    var result = await sl<GetNewsSongUseCase>().call();

    result.fold((failure) {
      emit(NewsSongsLoadFailure());
    }, (songs) {
      emit(NewsSongsLoaded(songs: songs));
    });
  }
}
