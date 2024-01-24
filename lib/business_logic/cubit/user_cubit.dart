import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sigma_task/repository/userRepository.dart';

import '../../models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  List<User> users = [];

  UserCubit(this.userRepository) : super(UserInitial());

  List<User> getAllUsers(int limit){
    userRepository.getAllUsers(limit).then((value){
      var newList = value;

      emit(UserLoaded(newList));
      users = newList;
    });

    return users;
  }
}
