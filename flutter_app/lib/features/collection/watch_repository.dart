import 'package:supabase_flutter/supabase_flutter.dart';

import 'watch.dart';

class WatchRepository {
  WatchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Watch>> list() async {
    final results = await Future.wait([
      _client.from('watches').select().order('brand'),
      _client.from('watch_models').select(),
      _client.from('movement_calibers').select(),
      _client.from('acquisitions').select(),
      _client.from('acquisition_items').select(),
      _client.from('watch_events').select('watch_id, event_type'),
      _client.from('watch_sources').select(),
      _client.from('watch_claims').select(),
      _client.from('expenses').select('id, watch_id, amount_brl, is_shared'),
      _client.from('expense_allocations').select('watch_id, amount_brl_allocated'),
    ]);

    final watchRows = results[0];
    final models = _byId(results[1]);
    final calibers = _byId(results[2]);
    final acquisitions = _byId(results[3]);
    final itemsByWatch = _byForeignKey(results[4], 'watch_id');
    final sourcesByWatch = _groupByForeignKey(results[6], 'watch_id');
    final claimsByWatch = _groupByForeignKey(results[7], 'watch_id');

    final maintenanceCounts = <int, int>{};
    for (final row in results[5]) {
      final watchId = (row['watch_id'] as num?)?.toInt();
      if (watchId != null && row['event_type'] == 'maintenance') {
        maintenanceCounts[watchId] = (maintenanceCounts[watchId] ?? 0) + 1;
      }
    }

    final totals = <int, double>{};
    for (final row in results[8]) {
      final watchId = (row['watch_id'] as num?)?.toInt();
      final amount = (row['amount_brl'] as num?)?.toDouble();
      if (watchId != null && amount != null && row['is_shared'] != true) {
        totals[watchId] = (totals[watchId] ?? 0) + amount;
      }
    }
    for (final row in results[9]) {
      final watchId = (row['watch_id'] as num?)?.toInt();
      final amount = (row['amount_brl_allocated'] as num?)?.toDouble();
      if (watchId != null && amount != null) {
        totals[watchId] = (totals[watchId] ?? 0) + amount;
      }
    }

    return watchRows.map<Watch>((row) {
      final watch = Watch.fromJson(row);
      final modelId = (row['watch_model_id'] as num?)?.toInt();
      final caliberId = (row['movement_caliber_id'] as num?)?.toInt();
      final item = itemsByWatch[watch.id];
      final acquisitionId = (item?['acquisition_id'] as num?)?.toInt();
      final sourceRows = sourcesByWatch[watch.id] ?? const [];
      final claimRows = claimsByWatch[watch.id] ?? const [];
      final structuredTotal = totals[watch.id];
      return watch.withRelated(
        maintenanceCount: maintenanceCounts[watch.id] ?? 0,
        totalInvested: structuredTotal ??
            watch.purchaseTotalBrl ??
            watch.purchasePrice ??
            0,
        modelProfile: modelId == null || models[modelId] == null
            ? null
            : WatchModelProfile.fromJson(models[modelId]!),
        caliberProfile: caliberId == null || calibers[caliberId] == null
            ? null
            : CaliberProfile.fromJson(calibers[caliberId]!),
        acquisition: item == null ||
                acquisitionId == null ||
                acquisitions[acquisitionId] == null
            ? null
            : Acquisition.fromJson(acquisitions[acquisitionId]!, item),
        sources: sourceRows.map(WatchSource.fromJson).toList(),
        claims: claimRows.map(WatchClaim.fromJson).toList(),
      );
    }).toList();
  }

  Future<List<WatchHistory>> history(int watchId) async {
    final rows = await _client
        .from('watch_events')
        .select()
        .eq('watch_id', watchId)
        .order('event_date', ascending: false);
    if (rows.isNotEmpty) {
      return rows.map<WatchHistory>(WatchHistory.fromJson).toList();
    }

    final legacyRows = await _client
        .from('maintenance_logs')
        .select()
        .eq('watch_id', watchId)
        .order('event_date', ascending: false);
    return legacyRows.map<WatchHistory>(WatchHistory.fromJson).toList();
  }

  Future<List<ExpenseSummary>> expenses(int watchId) async {
    final directRows = await _client
        .from('expenses')
        .select()
        .eq('watch_id', watchId)
        .eq('is_shared', false);
    final allocationRows = await _client
        .from('expense_allocations')
        .select()
        .eq('watch_id', watchId);

    final result = directRows.map<ExpenseSummary>((row) => ExpenseSummary(
          category: row['category'] as String,
          description: row['description'] as String? ?? row['category'] as String,
          amountBrl: (row['amount_brl'] as num?)?.toDouble(),
          amountOriginal: (row['amount_original'] as num?)?.toDouble(),
          currency: row['currency'] as String? ?? 'BRL',
          date: parseDatabaseDate(row['expense_date']),
          allocationMethod: row['allocation_method'] as String?,
        )).toList();

    if (allocationRows.isEmpty) return result;
    final expenseIds = allocationRows
        .map((row) => (row['expense_id'] as num).toInt())
        .toList();
    final expenseRows = await _client
        .from('expenses')
        .select()
        .inFilter('id', expenseIds);
    final expensesById = _byId(expenseRows);
    for (final allocation in allocationRows) {
      final expenseId = (allocation['expense_id'] as num).toInt();
      final expense = expensesById[expenseId];
      if (expense == null) continue;
      result.add(ExpenseSummary(
        category: expense['category'] as String,
        description: expense['description'] as String? ?? expense['category'] as String,
        amountBrl: (allocation['amount_brl_allocated'] as num).toDouble(),
        amountOriginal:
            (allocation['amount_original_allocated'] as num?)?.toDouble(),
        currency: expense['currency'] as String? ?? 'BRL',
        date: parseDatabaseDate(expense['expense_date']),
        allocationMethod: allocation['allocation_basis'] as String? ??
            expense['allocation_method'] as String?,
      ));
    }
    result.sort((a, b) => (a.date ?? DateTime(1900))
        .compareTo(b.date ?? DateTime(1900)));
    return result;
  }

  Future<List<BrandProfile>> brands() async {
    final rows = await _client.from('brands').select().order('name');
    return rows.map<BrandProfile>(BrandProfile.fromJson).toList();
  }

  Map<int, Map<String, dynamic>> _byId(List<dynamic> rows) => {
        for (final row in rows)
          (row['id'] as num).toInt(): Map<String, dynamic>.from(row),
      };

  Map<int, Map<String, dynamic>> _byForeignKey(
          List<dynamic> rows, String key) =>
      {
        for (final row in rows)
          if (row[key] != null)
            (row[key] as num).toInt(): Map<String, dynamic>.from(row),
      };

  Map<int, List<Map<String, dynamic>>> _groupByForeignKey(
      List<dynamic> rows, String key) {
    final result = <int, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final value = (row[key] as num?)?.toInt();
      if (value != null) {
        result.putIfAbsent(value, () => []).add(Map<String, dynamic>.from(row));
      }
    }
    return result;
  }
}
