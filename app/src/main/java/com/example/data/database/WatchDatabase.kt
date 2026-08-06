package com.example.data.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.example.data.dao.MaintenanceDao
import com.example.data.dao.WatchDao
import com.example.data.model.MaintenanceLogEntity
import com.example.data.model.WatchEntity

@Database(
    entities = [WatchEntity::class, MaintenanceLogEntity::class],
    version = 2,
    exportSchema = false
)
abstract class WatchDatabase : RoomDatabase() {
    abstract fun watchDao(): WatchDao
    abstract fun maintenanceDao(): MaintenanceDao

    companion object {
        @Volatile
        private var INSTANCE: WatchDatabase? = null

        fun getDatabase(context: Context): WatchDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    WatchDatabase::class.java,
                    "watch_collection_database"
                )
                    .fallbackToDestructiveMigration()
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
