import 'package:supabase_flutter/supabase_flutter.dart';

import 'watch.dart';

class WatchRepository {
  WatchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Watch>> list() async {
    final rows = await _client.from('watches').select().order('brand');
    final logRows = await _client
        .from('maintenance_logs')
        .select('watch_id, amount_brl, cost');
    final counts = <int, int>{};
    final totals = <int, double>{};
    for (final row in logRows) {
      final id = (row['watch_id'] as num?)?.toInt();
      if (id != null) {
        counts[id] = (counts[id] ?? 0) + 1;
        final amount = (row['amount_brl'] as num? ?? row['cost'] as num?)
                ?.toDouble() ??
            0;
        totals[id] = (totals[id] ?? 0) + amount;
      }
    }
    return rows
        .map<Watch>((row) => Watch.fromJson(row))
        .map((watch) => watch.withHistory(
              count: counts[watch.id] ?? 0,
              invested: totals[watch.id] ?? watch.purchaseTotalBrl ??
                  watch.purchasePrice ?? 0,
            ))
        .toList();
  }

  Future<List<WatchHistory>> history(int watchId) async {
    final rows = await _client
        .from('maintenance_logs')
        .select()
        .eq('watch_id', watchId)
        .order('event_date', ascending: false);
    return rows.map<WatchHistory>((row) => WatchHistory.fromJson(row)).toList();
  }

  Future<List<BrandProfile>> brands() async {
    final rows = await _client.from('brands').select().order('name');
    return rows.map<BrandProfile>((row) => BrandProfile.fromJson(row)).toList();
  }
}
