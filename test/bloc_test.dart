
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sigma_task/business_logic/cubit/user_cubit.dart';
import 'package:sigma_task/models/user.dart';
import 'package:sigma_task/repository/userRepository.dart';
import 'package:sigma_task/webServices/user_web_service.dart';

import 'bloc_test.mocks.dart';

@GenerateMocks([UserRepository])
void main(){
  MockUserRepository userRepository = MockUserRepository();

  group("Bloc test", () {

    var list = [User()];

    when(userRepository.getAllUsers(1)).thenAnswer((realInvocation) => Future.value(list));
    
    blocTest<UserCubit,UserState>(
        "User cubit test",
        build: () => UserCubit(userRepository),
      act: (bloc){
        bloc.getAllUsers(1);
      },
      expect: () => <UserState>[
        UserLoaded(list)
      ]
    );
    
  });
}