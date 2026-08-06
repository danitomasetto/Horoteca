package com.example.data.remote

import com.example.data.model.MaintenanceLogEntity
import com.example.data.model.WatchEntity
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SupabaseWatchDto(
    @Json(name = "id") val id: Long? = null,
    @Json(name = "brand") val brand: String,
    @Json(name = "model") val model: String,
    @Json(name = "reference_number") val referenceNumber: String? = null,
    @Json(name = "movement_type") val movementType: String? = null,
    @Json(name = "case_material") val caseMaterial: String? = null,
    @Json(name = "dial_color") val dialColor: String? = null,
    @Json(name = "strap_material") val strapMaterial: String? = null,
    @Json(name = "purchase_date") val purchaseDate: String? = null,
    @Json(name = "purchase_price") val purchasePrice: Double? = null,
    @Json(name = "notes") val notes: String? = null,
    @Json(name = "image_uri") val imageUri: String? = null,
    @Json(name = "qr_code") val qrCode: String? = null
)

@JsonClass(generateAdapter = true)
data class SupabaseMaintenanceDto(
    @Json(name = "id") val id: Long? = null,
    @Json(name = "watch_id") val watchId: Long,
    @Json(name = "service_date") val serviceDate: String,
    @Json(name = "description") val description: String,
    @Json(name = "service_provider") val serviceProvider: String? = null,
    @Json(name = "cost") val cost: Double? = null,
    @Json(name = "next_service_due") val nextServiceDue: String? = null
)

fun WatchEntity.toSupabaseDto(): SupabaseWatchDto = SupabaseWatchDto(
    id = if (id > 0) id else null,
    brand = brand,
    model = model,
    referenceNumber = referenceNumber.ifBlank { null },
    movementType = movementType.ifBlank { null },
    caseMaterial = caseMaterial.ifBlank { null },
    dialColor = dialColor.ifBlank { null },
    strapMaterial = strapMaterial.ifBlank { null },
    purchaseDate = purchaseDateFormatted.ifBlank { null },
    purchasePrice = if (purchasePrice > 0) purchasePrice else null,
    notes = notes.ifBlank { null },
    imageUri = imageUri.ifBlank { null },
    qrCode = null
)

fun SupabaseWatchDto.toWatchEntity(): WatchEntity = WatchEntity(
    id = id ?: 0L,
    brand = brand,
    model = model,
    referenceNumber = referenceNumber ?: "",
    serialNumber = "",
    purchaseYear = 2023,
    purchaseDateFormatted = purchaseDate ?: "",
    purchasePrice = purchasePrice ?: 0.0,
    currency = "R$",
    estimatedValue = purchasePrice ?: 0.0,
    provenance = "",
    condition = "Excelente",
    movementType = movementType ?: "Automático",
    movementCaliber = "",
    caseMaterial = caseMaterial ?: "Aço Inoxidável",
    strapMaterial = strapMaterial ?: "Aço Inoxidável",
    caseDiameterMm = 40.0,
    waterResistance = "100m",
    dialColor = dialColor ?: "Preto",
    boxAndPapers = true,
    imageUri = imageUri ?: "",
    notes = notes ?: "",
    createdAt = System.currentTimeMillis()
)

fun MaintenanceLogEntity.toSupabaseDto(): SupabaseMaintenanceDto {
    val typePart = if (orderCode.isNotBlank()) "[$orderCode] $serviceType" else serviceType
    val fullDesc = if (details.isNotBlank()) "$typePart - $details" else typePart
    return SupabaseMaintenanceDto(
        id = if (id > 0) id else null,
        watchId = watchId,
        serviceDate = serviceDate,
        description = fullDesc,
        serviceProvider = providerName.ifBlank { null },
        cost = if (cost > 0) cost else null,
        nextServiceDue = nextServiceDueDate.ifBlank { null }
    )
}

fun SupabaseMaintenanceDto.toMaintenanceLogEntity(): MaintenanceLogEntity {
    var rawType = description.substringBefore(" - ")
    var orderCodeParsed = ""
    if (rawType.startsWith("[") && rawType.contains("]")) {
        orderCodeParsed = rawType.substringAfter("[").substringBefore("]")
        rawType = rawType.substringAfter("]").trim()
    }
    val detailsParsed = if (description.contains(" - ")) description.substringAfter(" - ") else ""

    return MaintenanceLogEntity(
        id = id ?: 0L,
        watchId = watchId,
        serviceDate = serviceDate,
        serviceType = rawType.ifBlank { description },
        providerName = serviceProvider ?: "",
        cost = cost ?: 0.0,
        details = detailsParsed,
        nextServiceDueDate = nextServiceDue ?: "",
        orderCode = orderCodeParsed,
        timestamp = System.currentTimeMillis()
    )
}
