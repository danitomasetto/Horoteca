package com.example.data.model

import androidx.room.Embedded
import androidx.room.Relation

data class WatchWithMaintenance(
    @Embedded val watch: WatchEntity,
    @Relation(
        parentColumn = "id",
        entityColumn = "watchId"
    )
    val maintenanceLogs: List<MaintenanceLogEntity>
)
