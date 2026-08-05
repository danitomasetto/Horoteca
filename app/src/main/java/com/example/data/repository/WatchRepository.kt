package com.example.data.repository

import com.example.data.dao.MaintenanceDao
import com.example.data.dao.WatchDao
import com.example.data.model.MaintenanceLogEntity
import com.example.data.model.WatchEntity
import com.example.data.model.WatchWithMaintenance
import kotlinx.coroutines.flow.Flow

class WatchRepository(
    private val watchDao: WatchDao,
    private val maintenanceDao: MaintenanceDao
) {
    val allWatchesWithMaintenance: Flow<List<WatchWithMaintenance>> =
        watchDao.getAllWatchesWithMaintenance()

    fun getWatchById(id: Long): Flow<WatchWithMaintenance?> =
        watchDao.getWatchWithMaintenanceById(id)

    suspend fun insertWatch(watch: WatchEntity): Long =
        watchDao.insertWatch(watch)

    suspend fun updateWatch(watch: WatchEntity) =
        watchDao.updateWatch(watch)

    suspend fun deleteWatch(id: Long) =
        watchDao.deleteWatchById(id)

    suspend fun insertMaintenanceLog(log: MaintenanceLogEntity): Long =
        maintenanceDao.insertLog(log)

    suspend fun deleteMaintenanceLog(id: Long) =
        maintenanceDao.deleteLogById(id)
}
