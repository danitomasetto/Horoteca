import 'package:flutter_test/flutter_test.dart';
import 'package:horoteca/features/collection/watch.dart';

void main() {
  test('converts a Supabase watch row', () {
    final watch = Watch.fromJson({
      'id': 7,
      'brand': 'Seiko',
      'model': 'Lord Matic',
      'reference_number': '5606-6029',
    });

    expect(watch.id, 7);
    expect(watch.brand, 'Seiko');
    expect(watch.referenceNumber, '5606-6029');
  });

  test('keeps unknown brand and model explicit instead of inventing values', () {
    final watch = Watch.fromJson({'id': 8, 'brand': null, 'model': null});

    expect(watch.brand, isEmpty);
    expect(watch.model, isEmpty);
    expect(watch.displayBrand, 'Marca não informada');
    expect(watch.displayModel, 'Modelo não informado');
  });

  test('reads ISO and Brazilian dates', () {
    expect(parseDatabaseDate('2026-05-31'), DateTime(2026, 5, 31));
    expect(parseDatabaseDate('10/06/2026'), DateTime(2026, 6, 10));
    expect(parseDatabaseDate('31/02/2026'), isNull);
  });

  test('preserves nullable listing-style facts and structured claims', () {
    final watch = Watch.fromJson({
      'id': 9,
      'has_original_box': null,
      'has_original_papers': false,
      'bezel_color': 'Prateado',
      'features': ['Dia', 'Data'],
    }).withRelated(
      maintenanceCount: 0,
      totalInvested: 0,
      claims: const [
        WatchClaim(
          fieldName: 'reference_number',
          assertedValue: '6308-801 LT',
          classification: 'seller_statement',
          status: 'pending',
        ),
      ],
    );

    expect(watch.hasOriginalBox, isNull);
    expect(watch.hasOriginalPapers, isFalse);
    expect(watch.features, ['Dia', 'Data']);
    expect(watch.claims.single.assertedValue, '6308-801 LT');
  });
}
