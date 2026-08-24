DateTime? parseDatabaseDate(Object? value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  final iso = DateTime.tryParse(raw);
  if (iso != null) return iso;
  final parts = raw.split('/');
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  final parsed = DateTime(year, month, day);
  return parsed.day == day && parsed.month == month && parsed.year == year
      ? parsed
      : null;
}

String _text(Object? value) => value?.toString().trim() ?? '';
double? _number(Object? value) => (value as num?)?.toDouble();
int? _integer(Object? value) => (value as num?)?.toInt();
List<String> _strings(Object? value) =>
    (value as List?)?.map((item) => '$item').toList() ?? const [];

class Watch {
  const Watch({
    required this.id,
    required this.brand,
    required this.model,
    this.referenceNumber,
    this.serialNumber,
    this.caseCode,
    this.dialCode,
    this.movementType,
    this.movementDescription,
    this.dialColor,
    this.imageUri,
    this.notes,
    this.purchasePrice,
    this.estimatedValue,
    this.year,
    this.yearIsEstimated = false,
    this.periodStartYear,
    this.periodEndYear,
    this.caliber,
    this.jewels,
    this.complications = const [],
    this.condition,
    this.functionStatus,
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
    this.purchaseDate,
    this.manufactureCountry,
    this.diameterMm,
    this.caseThicknessMm,
    this.lugToLugMm,
    this.lugWidthMm,
    this.caseMaterial,
    this.caseFinish,
    this.caseColor,
    this.caseShape,
    this.dialDescription,
    this.dialInscriptions,
    this.indicesDescription,
    this.handsDescription,
    this.crystalMaterial,
    this.crystalCondition,
    this.crownDescription,
    this.casebackDescription,
    this.casebackInscriptions,
    this.strapMaterial,
    this.strapDescription,
    this.claspType,
    this.strapOriginality,
    this.dialOriginality,
    this.componentOriginality,
    this.accuracySecondsPerDay,
    this.accuracyNotes,
    this.knownDefects,
    this.waterResistance,
    this.sourceDocumentUrl,
    this.modelProfile,
    this.caliberProfile,
    this.acquisition,
    this.sources = const [],
    this.totalInvested = 0,
    this.maintenanceCount = 0,
  });

  final int id;
  final String brand;
  final String model;
  final String? referenceNumber, serialNumber, caseCode, dialCode;
  final String? movementType, movementDescription, dialColor, imageUri, notes;
  final double? purchasePrice, estimatedValue;
  final int? year, periodStartYear, periodEndYear, jewels;
  final bool yearIsEstimated;
  final String? caliber;
  final List<String> complications;
  final String? condition, functionStatus, horotecaCode;
  final String? orderNumber, marketplace, marketplaceItemId, sellerName;
  final int? orderItemNumber;
  final String? purchaseCurrency, paymentMethod;
  final double? purchaseAmountOriginal, purchaseTotalBrl;
  final DateTime? purchaseDate;
  final String? manufactureCountry;
  final double? diameterMm, caseThicknessMm, lugToLugMm, lugWidthMm;
  final String? caseMaterial, caseFinish, caseColor, caseShape;
  final String? dialDescription, dialInscriptions, indicesDescription;
  final String? handsDescription, crystalMaterial, crystalCondition;
  final String? crownDescription, casebackDescription, casebackInscriptions;
  final String? strapMaterial, strapDescription, claspType, strapOriginality;
  final String? dialOriginality, componentOriginality;
  final double? accuracySecondsPerDay;
  final String? accuracyNotes, knownDefects, waterResistance, sourceDocumentUrl;
  final WatchModelProfile? modelProfile;
  final CaliberProfile? caliberProfile;
  final Acquisition? acquisition;
  final List<WatchSource> sources;
  final double totalInvested;
  final int maintenanceCount;

  String get displayBrand => brand.isEmpty ? 'Marca não informada' : brand;
  String get displayModel => model.isEmpty ? 'Modelo não informado' : model;

  factory Watch.fromJson(Map<String, dynamic> json) => Watch(
        id: (json['id'] as num).toInt(),
        brand: _text(json['brand']),
        model: _text(json['model']),
        referenceNumber: json['reference_number'] as String?,
        serialNumber: json['serial_number'] as String?,
        caseCode: json['case_code'] as String?,
        dialCode: json['dial_code'] as String?,
        movementType: json['movement_type'] as String?,
        movementDescription: json['movement_description'] as String?,
        dialColor: json['dial_color'] as String?,
        imageUri: json['image_uri'] as String?,
        notes: json['notes'] as String?,
        purchasePrice: _number(json['purchase_price']),
        estimatedValue: _number(json['estimated_value']),
        year: _integer(json['manufacture_year'] ?? json['year']),
        yearIsEstimated: json['manufacture_year_is_estimated'] as bool? ?? false,
        periodStartYear: _integer(json['production_period_start_year']),
        periodEndYear: _integer(json['production_period_end_year']),
        caliber: json['movement_caliber'] as String? ?? json['caliber'] as String?,
        jewels: _integer(json['jewels']),
        complications: _strings(json['complications']),
        condition: json['condition'] as String?,
        functionStatus: json['function_status'] as String?,
        horotecaCode: json['horoteca_code'] as String?,
        orderNumber: json['order_number'] as String?,
        orderItemNumber: _integer(json['order_item_number']),
        marketplace: json['marketplace'] as String?,
        marketplaceItemId: json['marketplace_item_id'] as String?,
        sellerName: json['seller_name'] as String?,
        purchaseCurrency: json['purchase_currency'] as String?,
        purchaseAmountOriginal: _number(json['purchase_amount_original']),
        purchaseTotalBrl: _number(json['purchase_total_brl']),
        paymentMethod: json['payment_method'] as String?,
        purchaseDate: parseDatabaseDate(json['purchase_date']),
        manufactureCountry: json['manufacture_country'] as String?,
        diameterMm: _number(json['diameter_mm']),
        caseThicknessMm: _number(json['case_thickness_mm']),
        lugToLugMm: _number(json['lug_to_lug_mm']),
        lugWidthMm: _number(json['lug_width_mm']),
        caseMaterial: json['case_material'] as String?,
        caseFinish: json['case_finish'] as String?,
        caseColor: json['case_color'] as String?,
        caseShape: json['case_shape'] as String?,
        dialDescription: json['dial_description'] as String?,
        dialInscriptions: json['dial_inscriptions'] as String?,
        indicesDescription: json['indices_description'] as String?,
        handsDescription: json['hands_description'] as String?,
        crystalMaterial: json['crystal_material'] as String?,
        crystalCondition: json['crystal_condition'] as String?,
        crownDescription: json['crown_description'] as String?,
        casebackDescription: json['caseback_description'] as String?,
        casebackInscriptions: json['caseback_inscriptions'] as String?,
        strapMaterial: json['strap_material'] as String?,
        strapDescription: json['strap_description'] as String?,
        claspType: json['clasp_type'] as String?,
        strapOriginality: json['strap_originality'] as String?,
        dialOriginality: json['dial_originality'] as String?,
        componentOriginality: json['component_originality'] as String?,
        accuracySecondsPerDay: _number(json['accuracy_seconds_per_day']),
        accuracyNotes: json['accuracy_notes'] as String?,
        knownDefects: json['known_defects'] as String?,
        waterResistance: json['water_resistance'] as String?,
        sourceDocumentUrl: json['source_document_url'] as String?,
      );

  Watch withRelated({
    required int maintenanceCount,
    required double totalInvested,
    WatchModelProfile? modelProfile,
    CaliberProfile? caliberProfile,
    Acquisition? acquisition,
    List<WatchSource> sources = const [],
  }) => Watch(
        id: id, brand: brand, model: model, referenceNumber: referenceNumber,
        serialNumber: serialNumber, caseCode: caseCode, dialCode: dialCode,
        movementType: movementType, movementDescription: movementDescription,
        dialColor: dialColor, imageUri: imageUri, notes: notes,
        purchasePrice: purchasePrice, estimatedValue: estimatedValue, year: year,
        yearIsEstimated: yearIsEstimated, periodStartYear: periodStartYear,
        periodEndYear: periodEndYear, caliber: caliber, jewels: jewels,
        complications: complications, condition: condition,
        functionStatus: functionStatus, horotecaCode: horotecaCode,
        orderNumber: orderNumber, orderItemNumber: orderItemNumber,
        marketplace: marketplace, marketplaceItemId: marketplaceItemId,
        sellerName: sellerName, purchaseCurrency: purchaseCurrency,
        purchaseAmountOriginal: purchaseAmountOriginal,
        purchaseTotalBrl: purchaseTotalBrl, paymentMethod: paymentMethod,
        purchaseDate: purchaseDate, manufactureCountry: manufactureCountry,
        diameterMm: diameterMm, caseThicknessMm: caseThicknessMm,
        lugToLugMm: lugToLugMm, lugWidthMm: lugWidthMm,
        caseMaterial: caseMaterial, caseFinish: caseFinish,
        caseColor: caseColor, caseShape: caseShape,
        dialDescription: dialDescription, dialInscriptions: dialInscriptions,
        indicesDescription: indicesDescription, handsDescription: handsDescription,
        crystalMaterial: crystalMaterial, crystalCondition: crystalCondition,
        crownDescription: crownDescription, casebackDescription: casebackDescription,
        casebackInscriptions: casebackInscriptions, strapMaterial: strapMaterial,
        strapDescription: strapDescription, claspType: claspType,
        strapOriginality: strapOriginality, dialOriginality: dialOriginality,
        componentOriginality: componentOriginality,
        accuracySecondsPerDay: accuracySecondsPerDay, accuracyNotes: accuracyNotes,
        knownDefects: knownDefects, waterResistance: waterResistance,
        sourceDocumentUrl: sourceDocumentUrl, modelProfile: modelProfile,
        caliberProfile: caliberProfile, acquisition: acquisition,
        sources: sources, totalInvested: totalInvested,
        maintenanceCount: maintenanceCount,
      );
}

class Acquisition {
  const Acquisition({required this.id, this.marketplace, this.sellerName,
    this.orderNumber, this.marketplaceItemId, this.itemSequence,
    this.visualPosition, this.purchaseDate, this.purchasePaymentDate,
    this.taxesPaymentDate, this.shippedDate, this.receivedDate,
    this.paymentMethod, this.carrier, this.trackingNumber,
    this.sourceDocumentUrl, this.notes});
  final int id;
  final String? marketplace, sellerName, orderNumber, marketplaceItemId;
  final int? itemSequence;
  final String? visualPosition;
  final DateTime? purchaseDate, purchasePaymentDate, taxesPaymentDate;
  final DateTime? shippedDate, receivedDate;
  final String? paymentMethod, carrier, trackingNumber, sourceDocumentUrl, notes;

  factory Acquisition.fromJson(Map<String, dynamic> value, Map<String, dynamic> item) => Acquisition(
        id: (value['id'] as num).toInt(),
        marketplace: value['marketplace'] as String?,
        sellerName: value['seller_name'] as String?,
        orderNumber: value['order_number'] as String?,
        marketplaceItemId: item['marketplace_item_id'] as String?,
        itemSequence: _integer(item['item_sequence']),
        visualPosition: item['visual_position'] as String?,
        purchaseDate: parseDatabaseDate(value['purchase_date']),
        purchasePaymentDate: parseDatabaseDate(value['purchase_payment_date']),
        taxesPaymentDate: parseDatabaseDate(value['taxes_payment_date']),
        shippedDate: parseDatabaseDate(value['shipped_date']),
        receivedDate: parseDatabaseDate(value['received_date']),
        paymentMethod: value['payment_method'] as String?,
        carrier: value['carrier'] as String?,
        trackingNumber: value['tracking_number'] as String?,
        sourceDocumentUrl: value['source_document_url'] as String?,
        notes: value['notes'] as String?,
      );
}

class WatchModelProfile {
  const WatchModelProfile({this.lineName, this.launchYear,
    this.productionStartYear, this.productionEndYear, this.designer,
    this.creationContext, this.history, this.notableFeatures,
    this.historicalImportance, this.reviewedAt});
  final String? lineName, designer, creationContext, history;
  final String? notableFeatures, historicalImportance;
  final int? launchYear, productionStartYear, productionEndYear;
  final DateTime? reviewedAt;
  factory WatchModelProfile.fromJson(Map<String, dynamic> json) => WatchModelProfile(
        lineName: json['line_name'] as String?, launchYear: _integer(json['launch_year']),
        productionStartYear: _integer(json['production_start_year']),
        productionEndYear: _integer(json['production_end_year']),
        designer: json['designer'] as String?, creationContext: json['creation_context'] as String?,
        history: json['history'] as String?, notableFeatures: json['notable_features'] as String?,
        historicalImportance: json['historical_importance'] as String?,
        reviewedAt: parseDatabaseDate(json['reviewed_at']));
}

class CaliberProfile {
  const CaliberProfile({this.manufacturer, this.code, this.movementType,
    this.jewels, this.complications = const [], this.productionStartYear,
    this.productionEndYear, this.technicalDescription, this.history,
    this.historicalImportance, this.reviewedAt});
  final String? manufacturer, code, movementType, technicalDescription;
  final String? history, historicalImportance;
  final int? jewels, productionStartYear, productionEndYear;
  final List<String> complications;
  final DateTime? reviewedAt;
  factory CaliberProfile.fromJson(Map<String, dynamic> json) => CaliberProfile(
        manufacturer: json['manufacturer'] as String?, code: json['caliber_code'] as String?,
        movementType: json['movement_type'] as String?, jewels: _integer(json['jewels']),
        complications: _strings(json['complications']),
        productionStartYear: _integer(json['production_start_year']),
        productionEndYear: _integer(json['production_end_year']),
        technicalDescription: json['technical_description'] as String?,
        history: json['history'] as String?,
        historicalImportance: json['historical_importance'] as String?,
        reviewedAt: parseDatabaseDate(json['reviewed_at']));
}

class WatchSource {
  const WatchSource({required this.classification, this.type, this.name,
    this.url, this.confidencePercent, this.excerpt, this.notes, this.accessedAt});
  final String classification;
  final String? type, name, url, excerpt, notes;
  final int? confidencePercent;
  final DateTime? accessedAt;
  factory WatchSource.fromJson(Map<String, dynamic> json) => WatchSource(
        classification: _text(json['evidence_classification']),
        type: json['source_type'] as String?, name: json['source_name'] as String?,
        url: json['source_url'] as String?, confidencePercent: _integer(json['confidence_percent']),
        excerpt: json['excerpt'] as String?, notes: json['notes'] as String?,
        accessedAt: parseDatabaseDate(json['accessed_at']));
}

class WatchHistory {
  const WatchHistory({required this.description, required this.type, this.date,
    this.provider, this.amountBrl, this.amountOriginal, this.currency = 'BRL', this.notes});
  final String description, type, currency;
  final DateTime? date;
  final String? provider, notes;
  final double? amountBrl, amountOriginal;
  factory WatchHistory.fromJson(Map<String, dynamic> json) {
    final description = _text(json['description']);
    final type = _text(json['event_type']);
    return WatchHistory(
      description: description.isEmpty ? 'Histórico' : description,
      type: type.isEmpty ? 'manutencao' : type,
      date: parseDatabaseDate(json['event_date'] ?? json['service_date']),
      provider: json['provider'] as String? ?? json['service_provider'] as String?,
      amountBrl: _number(json['amount_brl'] ?? json['cost']),
      amountOriginal: _number(json['amount_original']),
      currency: json['currency'] as String? ?? 'BRL', notes: json['notes'] as String?);
  }
}

class ExpenseSummary {
  const ExpenseSummary({required this.category, required this.description,
    this.amountBrl, this.amountOriginal, this.currency = 'BRL',
    this.date, this.allocationMethod});
  final String category, description, currency;
  final double? amountBrl, amountOriginal;
  final DateTime? date;
  final String? allocationMethod;
}

class BrandProfile {
  const BrandProfile({required this.name, this.country, this.foundedYear,
    this.founder, this.history});
  final String name;
  final String? country, founder, history;
  final int? foundedYear;
  factory BrandProfile.fromJson(Map<String, dynamic> json) => BrandProfile(
        name: json['name'] as String, country: json['country'] as String?,
        foundedYear: _integer(json['founded_year']), founder: json['founder'] as String?,
        history: json['history'] as String?);
}
