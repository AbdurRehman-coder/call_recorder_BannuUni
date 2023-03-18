import 'package:json_annotation/json_annotation.dart';

part 'local_user.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalUser {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final String? token;


  LocalUser(
      {required this.name,
        required this.phoneNumber,
        required this.email,
        this.token,
        required this.password,
        });
  factory LocalUser.fromJson(Map<String, dynamic> json) =>
      _$LocalUserFromJson(json);

  Map<String, dynamic> toJson() => _$LocalUserToJson(this);
}
