part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoaded extends UserState{
  final List<User> users;

  UserLoaded(this.users);

  @override
  // TODO: implement props
  List<Object?> get props => [users];

}
