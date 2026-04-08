import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/update/data/models/app_version_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class UpdateRemoteDataSource {
  Future<AppVersionModel> getAppVersion(String platform);
}

@LazySingleton(as: UpdateRemoteDataSource)
class UpdateRemoteDataSourceImpl implements UpdateRemoteDataSource {
  const UpdateRemoteDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<AppVersionModel> getAppVersion(String platform) async {
    try {
      final data = await _supabase
          .from('app_config')
          .select()
          .eq('platform', platform)
          .single();
      return AppVersionModel.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
