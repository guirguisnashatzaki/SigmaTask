import 'package:sigma_task/models/user.dart';
import 'package:sigma_task/webServices/user_web_service.dart';

class UserRepository{
  late UserWebService userWebService;

  UserRepository(this.userWebService);

  Future<List<User>> getAllUsers(int limit) async{
    final user = await userWebService.getAllUsers(limit);
    return user.map((user) => User.fromJson(user)).toList();
  }
}