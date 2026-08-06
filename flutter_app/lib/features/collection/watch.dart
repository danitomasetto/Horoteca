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
    this.horotecaCode,
    this.orderNumber,
    this.orderItemNumber,
    this.marketplace,
    this.marketplaceItemId,
    this.sellerName,
    this.purchaseCurrency,
    this.purchaseAmountOriginal,
    this.purchaseTotalBrl,
    this.paymentMethod,
    this.totalInvested = 0,
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
  final String? horotecaCode;
  final String? orderNumber;
  final int? orderItemNumber;
  final String? marketplace;
  final String? marketplaceItemId;
  final String? sellerName;
  final String? purchaseCurrency;
  final double? purchaseAmountOriginal;
  final double? purchaseTotalBrl;
  final String? paymentMethod;
  final double totalInvested;
  final int maintenanceCount;

  Watch withHistory({required int count, required double invested}) => Watch(
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
        horotecaCode: horotecaCode,
        orderNumber: orderNumber,
        orderItemNumber: orderItemNumber,
        marketplace: marketplace,
        marketplaceItemId: marketplaceItemId,
        sellerName: sellerName,
        purchaseCurrency: purchaseCurrency,
        purchaseAmountOriginal: purchaseAmountOriginal,
        purchaseTotalBrl: purchaseTotalBrl,
        paymentMethod: paymentMethod,
        totalInvested: invested,
        maintenanceCount: count,
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
        horotecaCode: json['horoteca_code'] as String?,
        orderNumber: json['order_number'] as String?,
        orderItemNumber: (json['order_item_number'] as num?)?.toInt(),
        marketplace: json['marketplace'] as String?,
        marketplaceItemId: json['marketplace_item_id'] as String?,
        sellerName: json['seller_name'] as String?,
        purchaseCurrency: json['purchase_currency'] as String?,
        purchaseAmountOriginal:
            (json['purchase_amount_original'] as num?)?.toDouble(),
        purchaseTotalBrl: (json['purchase_total_brl'] as num?)?.toDouble(),
        paymentMethod: json['payment_method'] as String?,
      );
}

class WatchHistory {
  const WatchHistory({
    required this.description,
    required this.type,
    this.date,
    this.category,
    this.amountBrl,
    this.amountOriginal,
    this.currency = 'BRL',
  });

  final String description;
  final String type;
  final DateTime? date;
  final String? category;
  final double? amountBrl;
  final double? amountOriginal;
  final String currency;

  factory WatchHistory.fromJson(Map<String, dynamic> json) => WatchHistory(
        description: json['description'] as String? ?? 'Histórico',
        type: json['event_type'] as String? ?? 'manutencao',
        date: DateTime.tryParse(
            (json['event_date'] ?? json['service_date'] ?? '') as String),
        category: json['expense_category'] as String?,
        amountBrl: (json['amount_brl'] as num? ?? json['cost'] as num?)
            ?.toDouble(),
        amountOriginal: (json['amount_original'] as num?)?.toDouble(),
        currency: json['currency'] as String? ?? 'BRL',
      );
}

class BrandProfile {
  const BrandProfile({required this.name, this.country, this.foundedYear, this.founder, this.history});
  final String name;
  final String? country;
  final int? foundedYear;
  final String? founder;
  final String? history;

  factory BrandProfile.fromJson(Map<String, dynamic> json) => BrandProfile(
        name: json['name'] as String,
        country: json['country'] as String?,
        foundedYear: (json['founded_year'] as num?)?.toInt(),
        founder: json['founder'] as String?,
        history: json['history'] as String?,
      );
}
