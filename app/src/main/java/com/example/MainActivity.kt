package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.data.database.WatchDatabase
import com.example.data.repository.WatchRepository
import com.example.ui.screens.*
import com.example.ui.theme.HorologyNavyDark
import com.example.ui.theme.WatchCollectionTheme
import com.example.ui.viewmodel.WatchViewModel
import com.example.ui.viewmodel.WatchViewModelFactory

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        val db = WatchDatabase.getDatabase(applicationContext)
        val repository = WatchRepository(db.watchDao(), db.maintenanceDao())
        val factory = WatchViewModelFactory(repository)

        setContent {
            WatchCollectionTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = HorologyNavyDark
                ) {
                    val viewModel: WatchViewModel = viewModel(factory = factory)
                    WatchAppNavigation(viewModel)
                }
            }
        }
    }
}

@Composable
fun WatchAppNavigation(viewModel: WatchViewModel) {
    val navController = rememberNavController()

    val filteredWatches by viewModel.filteredWatches.collectAsState()
    val searchQuery by viewModel.searchQuery.collectAsState()
    val brandFilter by viewModel.brandFilter.collectAsState()
    val selectedWatch by viewModel.selectedWatch.collectAsState()
    val syncStatus by viewModel.syncStatus.collectAsState()

    NavHost(navController = navController, startDestination = "home") {
        composable("home") {
            CollectionHomeScreen(
                watches = filteredWatches,
                searchQuery = searchQuery,
                onSearchQueryChange = { viewModel.setSearchQuery(it) },
                selectedBrandFilter = brandFilter,
                onBrandFilterChange = { viewModel.setBrandFilter(it) },
                onWatchClick = { id ->
                    viewModel.selectWatch(id)
                    navController.navigate("detail/$id")
                },
                onAddWatchClick = {
                    navController.navigate("form")
                },
                onImportDocsClick = {
                    navController.navigate("import_docs")
                },
                onOpenWebShowcaseClick = {
                    navController.navigate("web_showcase")
                },
                onOpenBrandHistoryClick = { brandName ->
                    val route = if (!brandName.isNullOrBlank()) "brand_history?brand=$brandName" else "brand_history"
                    navController.navigate(route)
                },
                syncStatus = syncStatus,
                onSyncSupabaseClick = { viewModel.syncWithSupabase() },
                onPushSupabaseClick = { viewModel.pushAllToSupabase() },
                onClearAllDataClick = { viewModel.clearAllData() },
                onLoadSampleDataClick = { viewModel.seedInitialData() }
            )
        }

        composable(
            route = "detail/{watchId}",
            arguments = listOf(navArgument("watchId") { type = NavType.LongType })
        ) { backStackEntry ->
            val watchId = backStackEntry.arguments?.getLong("watchId") ?: 0L
            viewModel.selectWatch(watchId)

            WatchDetailScreen(
                watchWithMaintenance = selectedWatch,
                onBackClick = { navController.popBackStack() },
                onEditClick = { navController.navigate("form?watchId=$watchId") },
                onDeleteClick = {
                    viewModel.deleteWatch(watchId)
                    navController.popBackStack()
                },
                onAddMaintenanceLog = { log ->
                    viewModel.addMaintenanceLog(log)
                },
                onDeleteMaintenanceLog = { logId ->
                    viewModel.deleteMaintenanceLog(logId)
                },
                onGenerateWebPageClick = {
                    navController.navigate("web_showcase")
                },
                onOpenBrandHistoryClick = { brandName ->
                    navController.navigate("brand_history?brand=$brandName")
                }
            )
        }

        composable(
            route = "form?watchId={watchId}",
            arguments = listOf(
                navArgument("watchId") {
                    type = NavType.LongType
                    defaultValue = -1L
                }
            )
        ) { backStackEntry ->
            val watchId = backStackEntry.arguments?.getLong("watchId") ?: -1L
            val watchToEdit = if (watchId != -1L) selectedWatch?.watch else null

            WatchFormScreen(
                initialWatch = watchToEdit,
                onBackClick = { navController.popBackStack() },
                onSaveWatch = { watchEntity ->
                    viewModel.saveWatch(watchEntity)
                    navController.popBackStack()
                },
                onOpenBrandHistoryClick = { brandName ->
                    navController.navigate("brand_history?brand=$brandName")
                }
            )
        }

        composable("import_docs") {
            GoogleDocsImportScreen(
                onBackClick = { navController.popBackStack() },
                onImportSave = { rawText ->
                    viewModel.importFromGoogleDocsText(rawText)
                },
                onImportSaveMultiple = { parsedList ->
                    viewModel.importMultipleParsedWatches(parsedList)
                }
            )
        }

        composable("web_showcase") {
            val htmlContent = viewModel.generateWebShowcaseHtml(
                title = "Minha Coleção Horológica",
                owner = "Colecionador Privado"
            )

            WebShowcaseScreen(
                htmlContent = htmlContent,
                onBackClick = { navController.popBackStack() }
            )
        }

        composable(
            route = "brand_history?brand={brand}",
            arguments = listOf(
                navArgument("brand") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                }
            )
        ) { backStackEntry ->
            val brandParam = backStackEntry.arguments?.getString("brand")
            BrandHistoryScreen(
                initialBrandName = brandParam,
                onBackClick = { navController.popBackStack() }
            )
        }
    }
}
