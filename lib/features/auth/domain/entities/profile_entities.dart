// Модель данных профиля пользователя

class UserProfile {
  final int id;
  final String fio;
  final String iin;
  final String email;
  final String? phone;
  final int? addressId;
  final String? avatarPath;
  final List<String> roles;

  UserProfile({
    required this.id,
    required this.fio,
    required this.iin,
    required this.email,
    this.phone,
    this.addressId,
    this.avatarPath,
    required this.roles,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      fio: json['fio'] as String,
      iin: json['iin'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      addressId: json['addressId'] as int?,
      avatarPath: json['avatarPath'] as String?,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fio': fio,
      'iin': iin,
      'email': email,
      'phone': phone,
      'addressId': addressId,
      'avatarPath': avatarPath,
      'roles': roles,
    };
  }

  // Создаем копию с обновленными полями
  UserProfile copyWith({
    int? id,
    String? fio,
    String? iin,
    String? email,
    String? phone,
    int? addressId,
    String? avatarPath,
    List<String>? roles,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fio: fio ?? this.fio,
      iin: iin ?? this.iin,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addressId: addressId ?? this.addressId,
      avatarPath: avatarPath ?? this.avatarPath,
      roles: roles ?? this.roles,
    );
  }
}
