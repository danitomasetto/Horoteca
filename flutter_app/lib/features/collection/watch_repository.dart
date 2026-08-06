import 'package:supabase_flutter/supabase_flutter.dart';

import 'watch.dart';

class WatchRepository {
  WatchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Watch>> list() async {
    final rows = await _client.from('watches').select().order('brand');
    return rows.map<Watch>((row) => Watch.fromJson(row)).toList();
  }
}
