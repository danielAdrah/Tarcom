import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get_storage/get_storage.dart';

import '../../../../core/api/apiKeys/store_keys.dart';
import '../models/user_profile_model.dart';

/// مصدر محلي لآخر ملف شخصي ناجح عبر GetStorage،
/// يُعرض فوراً عند انقطاع الإنترنت (offline-first).
abstract class ProfileLocalDataSource {
  UserProfileModel? getCachedProfile();

  Future<void> cacheProfile(UserProfileModel profile);
}

//==-=-=-=-=-=-=-=-=-=-==

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final GetStorage storage;

  const ProfileLocalDataSourceImpl({required this.storage});

  @override
  UserProfileModel? getCachedProfile() {
    final String? raw = storage.read<String>(StorageKeys.userProfileCache);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserProfileModel.fromJson(decoded);
      }
    } catch (e, s) {
      developer.log(
        'ProfileLocalDataSource decode failed',
        name: 'ProfileCache',
        error: e,
        stackTrace: s,
      );
    }

    return null;
  }

  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    await storage.write(
      StorageKeys.userProfileCache,
      jsonEncode(profile.toJson()),
    );
  }
}
