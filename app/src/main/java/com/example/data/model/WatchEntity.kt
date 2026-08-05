package com.example.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "watches")
data class WatchEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val brand: String,
    val model: String,
    val referenceNumber: String = "",
    val serialNumber: String = "",
    val purchaseYear: Int = 2023,
    val purchaseDateFormatted: String = "",
    val purchasePrice: Double = 0.0,
    val currency: String = "R$",
    val estimatedValue: Double = 0.0,
    val provenance: String = "",
    val condition: String = "Excelente",
    val movementType: String = "Automático",
    val movementCaliber: String = "",
    val caseMaterial: String = "Aço Inoxidável",
    val strapMaterial: String = "Aço Inoxidável",
    val caseDiameterMm: Double = 40.0,
    val waterResistance: String = "100m",
    val dialColor: String = "Preto",
    val boxAndPapers: Boolean = true,
    val imageUri: String = "",
    val notes: String = "",
    val createdAt: Long = System.currentTimeMillis()
)
