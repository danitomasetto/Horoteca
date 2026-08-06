package com.example.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.data.model.WatchWithMaintenance
import com.example.ui.components.WatchCard
import com.example.ui.theme.GoldLight
import com.example.ui.theme.GoldPrimary
import com.example.ui.theme.HorologyNavyDark
import com.example.ui.theme.HorologyNavySurface
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CollectionHomeScreen(
    watches: List<WatchWithMaintenance>,
    searchQuery: String,
    onSearchQueryChange: (String) -> Unit,
    selectedBrandFilter: String?,
    onBrandFilterChange: (String?) -> Unit,
    onWatchClick: (Long) -> Unit,
    onAddWatchClick: () -> Unit,
    onImportDocsClick: () -> Unit,
    onOpenWebShowcaseClick: () -> Unit,
    onOpenBrandHistoryClick: (String?) -> Unit,
    syncStatus: String? = null,
    onSyncSupabaseClick: () -> Unit = {},
    onClearAllDataClick: () -> Unit = {},
    onLoadSampleDataClick: () -> Unit = {}
) {
    var isFabExpanded by remember { mutableStateOf(false) }
    var showMenu by remember { mutableStateOf(false) }
    var showDeleteConfirmDialog by remember { mutableStateOf(false) }
    val ptBr = Locale("pt", "BR")
    val currencyFormat = NumberFormat.getCurrencyInstance(ptBr)

    val totalValue = watches.sumOf { item ->
        val w = item.watch
        if (w.estimatedValue > 0) w.estimatedValue else w.purchasePrice
    }
    val totalServices = watches.sumOf { it.maintenanceLogs.size }
    val allBrands = remember(watches) {
        watches.map { it.watch.brand.trim() }.distinct().sorted()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Column {
                        Text(
                            text = "Coleção de Relógios",
                            style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold),
                            color = GoldPrimary
                        )
                        Text(
                            text = "Catálogo & Histórico Horológico",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                },
                actions = {
                    IconButton(onClick = onSyncSupabaseClick) {
                        Icon(
                            imageVector = Icons.Default.CloudSync,
                            contentDescription = "Sincronizar Supabase",
                            tint = GoldPrimary
                        )
                    }
                    IconButton(onClick = { onOpenBrandHistoryClick(selectedBrandFilter) }) {
                        Icon(
                            imageVector = Icons.Default.MenuBook,
                            contentDescription = "História das Marcas",
                            tint = GoldPrimary
                        )
                    }
                    IconButton(onClick = onOpenWebShowcaseClick) {
                        Icon(
                            imageVector = Icons.Default.Public,
                            contentDescription = "Página Web da Coleção",
                            tint = GoldPrimary
                        )
                    }
                    Box {
                        IconButton(onClick = { showMenu = true }) {
                            Icon(
                                imageVector = Icons.Default.MoreVert,
                                contentDescription = "Mais opções",
                                tint = GoldPrimary
                            )
                        }
                        DropdownMenu(
                            expanded = showMenu,
                            onDismissRequest = { showMenu = false },
                            modifier = Modifier.background(HorologyNavySurface)
                        ) {
                            DropdownMenuItem(
                                text = { Text("Carregar Dados de Exemplo") },
                                leadingIcon = { Icon(Icons.Default.Download, contentDescription = null, tint = GoldPrimary) },
                                onClick = {
                                    showMenu = false
                                    onLoadSampleDataClick()
                                }
                            )
                            HorizontalDivider()
                            DropdownMenuItem(
                                text = { Text("Apagar Todos os Dados", color = MaterialTheme.colorScheme.error) },
                                leadingIcon = { Icon(Icons.Default.DeleteForever, contentDescription = null, tint = MaterialTheme.colorScheme.error) },
                                onClick = {
                                    showMenu = false
                                    showDeleteConfirmDialog = true
                                }
                            )
                        }
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = HorologyNavySurface
                )
            )
        },
        floatingActionButton = {
            Column(horizontalAlignment = Alignment.End) {
                AnimatedVisibility(visible = isFabExpanded) {
                    Column(
                        horizontalAlignment = Alignment.End,
                        verticalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.padding(bottom = 8.dp)
                    ) {
                        ExtendedFloatingActionButton(
                            onClick = {
                                isFabExpanded = false
                                onImportDocsClick()
                            },
                            icon = { Icon(Icons.Default.Description, contentDescription = null) },
                            text = { Text("Importar do Google Docs") },
                            containerColor = MaterialTheme.colorScheme.surfaceVariant,
                            contentColor = GoldPrimary
                        )

                        ExtendedFloatingActionButton(
                            onClick = {
                                isFabExpanded = false
                                onOpenWebShowcaseClick()
                            },
                            icon = { Icon(Icons.Default.Public, contentDescription = null) },
                            text = { Text("Gerar Catálogo Web") },
                            containerColor = MaterialTheme.colorScheme.surfaceVariant,
                            contentColor = GoldLight
                        )

                        ExtendedFloatingActionButton(
                            onClick = {
                                isFabExpanded = false
                                onAddWatchClick()
                            },
                            icon = { Icon(Icons.Default.Add, contentDescription = null) },
                            text = { Text("Nova Ficha Manual") },
                            containerColor = GoldPrimary,
                            contentColor = Color.Black
                        )
                    }
                }

                FloatingActionButton(
                    onClick = { isFabExpanded = !isFabExpanded },
                    containerColor = GoldPrimary,
                    contentColor = Color.Black
                ) {
                    Icon(
                        imageVector = if (isFabExpanded) Icons.Default.Close else Icons.Default.Add,
                        contentDescription = "Ações"
                    )
                }
            }
        },
        containerColor = HorologyNavyDark
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            syncStatus?.let { status ->
                Surface(
                    color = HorologyNavySurface,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Icon(Icons.Default.CloudDone, contentDescription = null, modifier = Modifier.size(18.dp), tint = GoldPrimary)
                        Text(text = status, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurface)
                    }
                }
            }

            // Stats Banner Header
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = HorologyNavySurface),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
                    .border(
                        width = 1.dp,
                        brush = Brush.horizontalGradient(
                            colors = listOf(GoldPrimary, GoldLight)
                        ),
                        shape = RoundedCornerShape(16.dp)
                    )
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceAround,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(
                            text = "${watches.size}",
                            style = MaterialTheme.typography.headlineMedium.copy(fontWeight = FontWeight.Bold),
                            color = GoldLight
                        )
                        Text(
                            text = "Relógios",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }

                    VerticalDivider(
                        modifier = Modifier.height(36.dp),
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.4f)
                    )

                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(
                            text = currencyFormat.format(totalValue),
                            style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold),
                            color = GoldPrimary
                        )
                        Text(
                            text = "Valor da Coleção",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }

                    VerticalDivider(
                        modifier = Modifier.height(36.dp),
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.4f)
                    )

                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(
                            text = "$totalServices",
                            style = MaterialTheme.typography.headlineMedium.copy(fontWeight = FontWeight.Bold),
                            color = GoldLight
                        )
                        Text(
                            text = "Manutenções",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            // Search Bar
            OutlinedTextField(
                value = searchQuery,
                onValueChange = onSearchQueryChange,
                placeholder = { Text("Buscar por Marca, Modelo, Ref, Procedência...") },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null, tint = GoldPrimary) },
                trailingIcon = {
                    if (searchQuery.isNotEmpty()) {
                        IconButton(onClick = { onSearchQueryChange("") }) {
                            Icon(Icons.Default.Clear, contentDescription = "Limpar Busca")
                        }
                    }
                },
                singleLine = true,
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = GoldPrimary,
                    unfocusedBorderColor = MaterialTheme.colorScheme.outline
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
            )

            // Brand Chips
            if (allBrands.isNotEmpty()) {
                LazyRow(
                    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 10.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    item {
                        FilterChip(
                            selected = selectedBrandFilter == null,
                            onClick = { onBrandFilterChange(null) },
                            label = { Text("Todas as Marcas") },
                            colors = FilterChipDefaults.filterChipColors(
                                selectedContainerColor = GoldPrimary,
                                selectedLabelColor = Color.Black
                            )
                        )
                    }

                    items(allBrands) { brand ->
                        FilterChip(
                            selected = selectedBrandFilter.equals(brand, ignoreCase = true),
                            onClick = {
                                if (selectedBrandFilter.equals(brand, ignoreCase = true)) {
                                    onBrandFilterChange(null)
                                } else {
                                    onBrandFilterChange(brand)
                                }
                            },
                            label = { Text(brand) },
                            colors = FilterChipDefaults.filterChipColors(
                                selectedContainerColor = GoldPrimary,
                                selectedLabelColor = Color.Black
                            )
                        )
                    }
                }
            }

            // Watch List / Grid
            if (watches.isEmpty()) {
                Box(
                    contentAlignment = Alignment.Center,
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(32.dp)
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Icon(
                            imageVector = Icons.Default.Watch,
                            contentDescription = null,
                            tint = GoldPrimary.copy(alpha = 0.5f),
                            modifier = Modifier.size(64.dp)
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        Text(
                            text = "Nenhum relógio encontrado",
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Text(
                            text = "Cadastre um relógio manualmente ou importe fichas do Google Docs",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        Button(
                            onClick = onImportDocsClick,
                            colors = ButtonDefaults.buttonColors(containerColor = GoldPrimary)
                        ) {
                            Icon(Icons.Default.Description, contentDescription = null)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("Importar do Google Docs", color = Color.Black)
                        }
                    }
                }
            } else {
                LazyVerticalGrid(
                    columns = GridCells.Adaptive(minSize = 300.dp),
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp),
                    horizontalArrangement = Arrangement.spacedBy(16.dp),
                    modifier = Modifier.fillMaxSize()
                ) {
                    items(watches, key = { it.watch.id }) { item ->
                        WatchCard(
                            watchWithMaintenance = item,
                            onClick = { onWatchClick(item.watch.id) }
                        )
                    }
                }
            }
        }
    }

    if (showDeleteConfirmDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteConfirmDialog = false },
            title = {
                Text(
                    text = "Apagar Todos os Relógios?",
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold)
                )
            },
            text = {
                Text(
                    text = "Esta ação apagar todos os relógios e históricos de manutenção armazenados localmente no aplicativo. Deseja continuar?",
                    style = MaterialTheme.typography.bodyMedium
                )
            },
            confirmButton = {
                Button(
                    onClick = {
                        showDeleteConfirmDialog = false
                        onClearAllDataClick()
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error)
                ) {
                    Text("Apagar Tudo", color = MaterialTheme.colorScheme.onError)
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteConfirmDialog = false }) {
                    Text("Cancelar")
                }
            }
        )
    }
}
