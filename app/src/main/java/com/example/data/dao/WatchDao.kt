package com.example.data.dao

import androidx.room.*
import com.example.data.model.WatchEntity
import com.example.data.model.WatchWithMaintenance
import kotlinx.coroutines.flow.Flow

@Dao
interface WatchDao {
    @Transaction
    @Query("SELECT * FROM watches ORDER BY brand ASC, model ASC")
    fun getAllWatchesWithMaintenance(): Flow<List<WatchWithMaintenance>>

    @Transaction
    @Query("SELECT * FROM watches WHERE id = :id")
    fun getWatchWithMaintenanceById(id: Long): Flow<WatchWithMaintenance?>

    @Query("SELECT * FROM watches WHERE id = :id")
    suspend fun getWatchById(id: Long): WatchEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertWatch(watch: WatchEntity): Long

    @Update
    suspend fun updateWatch(watch: WatchEntity)

    @Delete
    suspend fun deleteWatch(watch: WatchEntity)

    @Query("DELETE FROM watches WHERE id = :id")
    suspend fun deleteWatchById(id: Long)

    @Query("DELETE FROM watches")
    suspend fun deleteAllWatches()

    @Query("SELECT * FROM watches")
    suspend fun getAllWatchesList(): List<WatchEntity>

    @Query("SELECT COUNT(*) FROM watches")
    fun getWatchCount(): Flow<Int>
}
