package com.example.data.dao

import androidx.room.*
import com.example.data.model.MaintenanceLogEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface MaintenanceDao {
    @Query("SELECT * FROM maintenance_logs WHERE watchId = :watchId ORDER BY timestamp DESC")
    fun getLogsForWatch(watchId: Long): Flow<List<MaintenanceLogEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertLog(log: MaintenanceLogEntity): Long

    @Update
    suspend fun updateLog(log: MaintenanceLogEntity)

    @Delete
    suspend fun deleteLog(log: MaintenanceLogEntity)

    @Query("DELETE FROM maintenance_logs WHERE id = :id")
    suspend fun deleteLogById(id: Long)

    @Query("DELETE FROM maintenance_logs")
    suspend fun deleteAllLogs()

    @Query("SELECT * FROM maintenance_logs")
    suspend fun getAllLogsList(): List<MaintenanceLogEntity>
}
