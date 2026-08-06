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
}
