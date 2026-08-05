package com.example.data.model

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "maintenance_logs",
    foreignKeys = [
        ForeignKey(
            entity = WatchEntity::class,
            parentColumns = ["id"],
            childColumns = ["watchId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("watchId")]
)
data class MaintenanceLogEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val watchId: Long,
    val serviceDate: String,
    val serviceType: String,
    val providerName: String,
    val cost: Double = 0.0,
    val details: String = "",
    val nextServiceDueDate: String = "",
    val timestamp: Long = System.currentTimeMillis()
)
