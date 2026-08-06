package com.example.data.remote

import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import retrofit2.http.*
import java.util.concurrent.TimeUnit

interface SupabaseApi {
    @GET("rest/v1/watches")
    suspend fun getWatches(
        @Header("apikey") apiKey: String,
        @Header("Authorization") auth: String,
        @Query("select") select: String = "*"
    ): List<SupabaseWatchDto>

    @POST("rest/v1/watches")
    suspend fun insertWatch(
        @Header("apikey") apiKey: String,
        @Header("Authorization") auth: String,
        @Header("Prefer") prefer: String = "return=representation",
        @Body watch: SupabaseWatchDto
    ): List<SupabaseWatchDto>

    @DELETE("rest/v1/watches")
    suspend fun deleteWatch(
        @Header("apikey") apiKey: String,
        @Header("Authorization") auth: String,
        @Query("id") idFilter: String
    ): Response<Unit>

    @GET("rest/v1/maintenance_logs")
    suspend fun getMaintenanceLogs(
        @Header("apikey") apiKey: String,
        @Header("Authorization") auth: String,
        @Query("select") select: String = "*"
    ): List<SupabaseMaintenanceDto>

    @POST("rest/v1/maintenance_logs")
    suspend fun insertMaintenanceLog(
        @Header("apikey") apiKey: String,
        @Header("Authorization") auth: String,
        @Header("Prefer") prefer: String = "return=representation",
        @Body log: SupabaseMaintenanceDto
    ): List<SupabaseMaintenanceDto>

    @DELETE("rest/v1/maintenance_logs")
    suspend fun deleteMaintenanceLog(
        @Header("apikey") apiKey: String,
        @Header("Authorization") auth: String,
        @Query("id") idFilter: String
    ): Response<Unit>
}

object SupabaseClient {
    const val DEFAULT_URL = "https://nlkhbhgzscpdistzuyod.supabase.co/"
    const val DEFAULT_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sa2hiaGd6c2NwZGlzdHp1eW9kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU5NTQ3MDgsImV4cCI6MjEwMTUzMDcwOH0.Niy8n76LZnvIbwbItuP8164Rx7wduU9q8tTwTGY21B8"

    private val moshi = Moshi.Builder()
        .addLast(KotlinJsonAdapterFactory())
        .build()

    private val okHttpClient = OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(15, TimeUnit.SECONDS)
        .addInterceptor(HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BASIC
        })
        .build()

    private val retrofit: Retrofit by lazy {
        Retrofit.Builder()
            .baseUrl(DEFAULT_URL)
            .client(okHttpClient)
            .addConverterFactory(MoshiConverterFactory.create(moshi))
            .build()
    }

    val api: SupabaseApi by lazy {
        retrofit.create(SupabaseApi::class.java)
    }

    fun authHeader(): String = "Bearer $DEFAULT_ANON_KEY"
}
