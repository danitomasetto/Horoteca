import 'package:supabase_flutter/supabase_flutter.dart';

import 'watch.dart';

class WatchRepository {
  WatchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Watch>> list() async {
    final rows = await _client.from('watches').select().order('brand');
    final logRows = await _client.from('maintenance_logs').select('watch_id');
    final counts = <int, int>{};
    for (final row in logRows) {
      final id = (row['watch_id'] as num?)?.toInt();
      if (id != null) counts[id] = (counts[id] ?? 0) + 1;
    }
    return rows
        .map<Watch>((row) => Watch.fromJson(row))
        .map((watch) => watch.withMaintenanceCount(counts[watch.id] ?? 0))
        .toList();
  }
}
