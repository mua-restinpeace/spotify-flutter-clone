import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/auth/get_user_usecase.dart';
import 'package:spotify/presentation/profile/bloc/profile_state.dart';
import 'package:spotify/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  Future<void> getUser() async {
    var result = await sl<GetUserUsecase>().call();

    result.fold((fail) {
      emit(ProfileLoadFailure());
    }, (user) {
      debugPrint('getUser: Emitting favoriteSongLoaded');
      emit(ProfileLoaded(userEntity: user));
    });
  }
}
