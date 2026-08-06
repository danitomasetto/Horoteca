package com.example.data.repository

import android.util.Log
import com.example.data.dao.MaintenanceDao
import com.example.data.dao.WatchDao
import com.example.data.model.MaintenanceLogEntity
import com.example.data.model.WatchEntity
import com.example.data.model.WatchWithMaintenance
import com.example.data.remote.SupabaseClient
import com.example.data.remote.toMaintenanceLogEntity
import com.example.data.remote.toSupabaseDto
import com.example.data.remote.toWatchEntity
import kotlinx.coroutines.flow.Flow

class WatchRepository(
    private val watchDao: WatchDao,
    private val maintenanceDao: MaintenanceDao
) {
    val allWatchesWithMaintenance: Flow<List<WatchWithMaintenance>> =
        watchDao.getAllWatchesWithMaintenance()

    fun getWatchById(id: Long): Flow<WatchWithMaintenance?> =
        watchDao.getWatchWithMaintenanceById(id)

    suspend fun insertWatch(watch: WatchEntity): Long {
        val insertedId = watchDao.insertWatch(watch)
        val watchWithId = watch.copy(id = insertedId)

        try {
            val dto = watchWithId.toSupabaseDto()
            SupabaseClient.api.insertWatch(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader(),
                watch = dto
            )
            Log.d("WatchRepository", "Watch inserted to Supabase: $insertedId")
        } catch (e: Exception) {
            Log.e("WatchRepository", "Failed to sync insertWatch with Supabase", e)
        }

        return insertedId
    }

    suspend fun updateWatch(watch: WatchEntity) {
        watchDao.updateWatch(watch)
        try {
            val dto = watch.toSupabaseDto()
            SupabaseClient.api.insertWatch(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader(),
                watch = dto
            )
            Log.d("WatchRepository", "Watch updated on Supabase: ${watch.id}")
        } catch (e: Exception) {
            Log.e("WatchRepository", "Failed to sync updateWatch with Supabase", e)
        }
    }

    suspend fun deleteWatch(id: Long) {
        watchDao.deleteWatchById(id)
        try {
            SupabaseClient.api.deleteWatch(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader(),
                idFilter = "eq.$id"
            )
            Log.d("WatchRepository", "Watch deleted from Supabase: $id")
        } catch (e: Exception) {
            Log.e("WatchRepository", "Failed to sync deleteWatch with Supabase", e)
        }
    }

    suspend fun insertMaintenanceLog(log: MaintenanceLogEntity): Long {
        val insertedId = maintenanceDao.insertLog(log)
        val logWithId = log.copy(id = insertedId)

        try {
            val dto = logWithId.toSupabaseDto()
            SupabaseClient.api.insertMaintenanceLog(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader(),
                log = dto
            )
            Log.d("WatchRepository", "Maintenance log inserted to Supabase: $insertedId")
        } catch (e: Exception) {
            Log.e("WatchRepository", "Failed to sync insertMaintenanceLog with Supabase", e)
        }

        return insertedId
    }

    suspend fun deleteMaintenanceLog(id: Long) {
        maintenanceDao.deleteLogById(id)
        try {
            SupabaseClient.api.deleteMaintenanceLog(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader(),
                idFilter = "eq.$id"
            )
            Log.d("WatchRepository", "Maintenance log deleted from Supabase: $id")
        } catch (e: Exception) {
            Log.e("WatchRepository", "Failed to sync deleteMaintenanceLog with Supabase", e)
        }
    }

    suspend fun syncWithSupabase(): Result<String> {
        return try {
            val remoteWatches = SupabaseClient.api.getWatches(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader()
            )

            val remoteLogs = SupabaseClient.api.getMaintenanceLogs(
                apiKey = SupabaseClient.DEFAULT_ANON_KEY,
                auth = SupabaseClient.authHeader()
            )

            var addedCount = 0
            remoteWatches.forEach { dto ->
                val entity = dto.toWatchEntity()
                watchDao.insertWatch(entity)
                addedCount++
            }

            remoteLogs.forEach { dto ->
                val entity = dto.toMaintenanceLogEntity()
                maintenanceDao.insertLog(entity)
            }

            Result.success("Sincronizado com Supabase! $addedCount relógios carregados.")
        } catch (e: Exception) {
            Log.e("WatchRepository", "Error syncing with Supabase", e)
            Result.failure(e)
        }
    }
}
