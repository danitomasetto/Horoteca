class Watch {
  const Watch({
    required this.id,
    required this.brand,
    required this.model,
    this.referenceNumber,
    this.movementType,
    this.dialColor,
    this.imageUri,
    this.notes,
    this.purchasePrice,
    this.estimatedValue,
    this.year,
    this.caliber,
    this.condition,
    this.maintenanceCount = 0,
  });

  final int id;
  final String brand;
  final String model;
  final String? referenceNumber;
  final String? movementType;
  final String? dialColor;
  final String? imageUri;
  final String? notes;
  final double? purchasePrice;
  final double? estimatedValue;
  final int? year;
  final String? caliber;
  final String? condition;
  final int maintenanceCount;

  Watch withMaintenanceCount(int value) => Watch(
        id: id,
        brand: brand,
        model: model,
        referenceNumber: referenceNumber,
        movementType: movementType,
        dialColor: dialColor,
        imageUri: imageUri,
        notes: notes,
        purchasePrice: purchasePrice,
        estimatedValue: estimatedValue,
        year: year,
        caliber: caliber,
        condition: condition,
        maintenanceCount: value,
      );

  factory Watch.fromJson(Map<String, dynamic> json) => Watch(
        id: (json['id'] as num).toInt(),
        brand: json['brand'] as String? ?? 'Sem marca',
        model: json['model'] as String? ?? 'Sem modelo',
        referenceNumber: json['reference_number'] as String?,
        movementType: json['movement_type'] as String?,
        dialColor: json['dial_color'] as String?,
        imageUri: json['image_uri'] as String?,
        notes: json['notes'] as String?,
        purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
        estimatedValue: (json['estimated_value'] as num?)?.toDouble(),
        year: (json['year'] as num?)?.toInt() ??
            (json['manufacture_year'] as num?)?.toInt(),
        caliber: json['movement_caliber'] as String? ??
            json['caliber'] as String?,
        condition: json['condition'] as String?,
      );
}
