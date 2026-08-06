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
  });

  final int id;
  final String brand;
  final String model;
  final String? referenceNumber;
  final String? movementType;
  final String? dialColor;
  final String? imageUri;
  final String? notes;

  factory Watch.fromJson(Map<String, dynamic> json) => Watch(
        id: (json['id'] as num).toInt(),
        brand: json['brand'] as String? ?? 'Sem marca',
        model: json['model'] as String? ?? 'Sem modelo',
        referenceNumber: json['reference_number'] as String?,
        movementType: json['movement_type'] as String?,
        dialColor: json['dial_color'] as String?,
        imageUri: json['image_uri'] as String?,
        notes: json['notes'] as String?,
      );
}
