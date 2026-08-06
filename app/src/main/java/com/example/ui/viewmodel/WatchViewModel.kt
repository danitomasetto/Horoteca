package com.example.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.data.exporter.WebPageGenerator
import com.example.data.model.MaintenanceLogEntity
import com.example.data.model.WatchEntity
import com.example.data.model.WatchWithMaintenance
import com.example.data.parser.GoogleDocsParser
import com.example.data.repository.WatchRepository
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class WatchViewModel(private val repository: WatchRepository) : ViewModel() {

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private val _brandFilter = MutableStateFlow<String?>(null)
    val brandFilter: StateFlow<String?> = _brandFilter.asStateFlow()

    private val _allWatches = repository.allWatchesWithMaintenance
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    val filteredWatches: StateFlow<List<WatchWithMaintenance>> = combine(
        _allWatches,
        _searchQuery,
        _brandFilter
    ) { watches, query, brand ->
        watches.filter { item ->
            val w = item.watch
            val matchesQuery = query.isEmpty() ||
                    w.brand.contains(query, ignoreCase = true) ||
                    w.model.contains(query, ignoreCase = true) ||
                    w.referenceNumber.contains(query, ignoreCase = true) ||
                    w.serialNumber.contains(query, ignoreCase = true) ||
                    w.provenance.contains(query, ignoreCase = true)

            val matchesBrand = brand == null || w.brand.equals(brand, ignoreCase = true)

            matchesQuery && matchesBrand
        }
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )

    private val _selectedWatchId = MutableStateFlow<Long?>(null)
    val selectedWatch: StateFlow<WatchWithMaintenance?> = _selectedWatchId
        .flatMapLatest { id ->
            if (id == null) flowOf(null)
            else repository.getWatchById(id)
        }
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = null
        )

    private val _syncStatus = MutableStateFlow<String?>(null)
    val syncStatus: StateFlow<String?> = _syncStatus.asStateFlow()

    fun syncWithSupabase() {
        viewModelScope.launch {
            _syncStatus.value = "Sincronizando (Baixando)..."
            val result = repository.syncWithSupabase()
            _syncStatus.value = result.getOrElse { "Falha na sincronização: ${it.localizedMessage}" }
        }
    }

    fun pushAllToSupabase() {
        viewModelScope.launch {
            _syncStatus.value = "Enviando para Supabase..."
            val result = repository.pushAllToSupabase()
            _syncStatus.value = result.getOrElse { "Falha ao enviar: ${it.localizedMessage}" }
        }
    }

    fun setSearchQuery(query: String) {
        _searchQuery.value = query
    }

    fun setBrandFilter(brand: String?) {
        _brandFilter.value = brand
    }

    fun selectWatch(id: Long?) {
        _selectedWatchId.value = id
    }

    fun saveWatch(watch: WatchEntity, logs: List<MaintenanceLogEntity> = emptyList()) {
        viewModelScope.launch {
            val watchId = if (watch.id == 0L) {
                repository.insertWatch(watch)
            } else {
                repository.updateWatch(watch)
                watch.id
            }

            logs.forEach { log ->
                repository.insertMaintenanceLog(log.copy(watchId = watchId))
            }
        }
    }

    fun deleteWatch(id: Long) {
        viewModelScope.launch {
            repository.deleteWatch(id)
            if (_selectedWatchId.value == id) {
                _selectedWatchId.value = null
            }
        }
    }

    fun addMaintenanceLog(log: MaintenanceLogEntity) {
        viewModelScope.launch {
            repository.insertMaintenanceLog(log)
        }
    }

    fun deleteMaintenanceLog(logId: Long) {
        viewModelScope.launch {
            repository.deleteMaintenanceLog(logId)
        }
    }

    fun importFromGoogleDocsText(rawText: String): Long {
        val parsed = GoogleDocsParser.parseDocumentText(rawText)
        var generatedId = 0L
        viewModelScope.launch {
            generatedId = repository.insertWatch(parsed.watch)
            parsed.maintenanceLogs.forEach { log ->
                repository.insertMaintenanceLog(log.copy(watchId = generatedId))
            }
        }
        return generatedId
    }

    fun importMultipleParsedWatches(parsedList: List<com.example.data.parser.ParsedWatchResult>) {
        viewModelScope.launch {
            parsedList.forEach { parsed ->
                val newWatchId = repository.insertWatch(parsed.watch)
                parsed.maintenanceLogs.forEach { log ->
                    repository.insertMaintenanceLog(log.copy(watchId = newWatchId))
                }
            }
        }
    }

    fun generateWebShowcaseHtml(title: String, owner: String): String {
        return WebPageGenerator.generateHTML(
            collectionTitle = title,
            ownerName = owner,
            watches = _allWatches.value
        )
    }

    fun clearAllData() {
        viewModelScope.launch {
            repository.clearAllData()
        }
    }

    fun seedInitialData() {
        viewModelScope.launch {
            // 1. Seiko 5 Automático (Mostrador Branco / Prata)
            val seiko5Id = repository.insertWatch(
                WatchEntity(
                    brand = "Seiko",
                    model = "Seiko 5 Automatic Vintage",
                    referenceNumber = "7009-SEIKO5",
                    serialNumber = "EBAY-127730961092-1",
                    purchaseYear = 2026,
                    purchaseDateFormatted = "15/03/2026",
                    purchasePrice = 450.0, // Custo base pro-rata do Lote (R$ 1.350 / 3)
                    currency = "R$",
                    estimatedValue = 850.0, // Valor estimado mercado BR pós-restauro (R$ 700 - 900)
                    provenance = "Lote 3x Seiko eBay #127730961092 • Rastreio DHL: 1998979684 (Comprado em 15/03/2026)",
                    condition = "Vintage (Em Restauração)",
                    movementType = "Automático",
                    movementCaliber = "Seiko Calibre 7009",
                    caseMaterial = "Aço Inoxidável",
                    strapMaterial = "Pulseira de Aço Expansível (Fixoflex)",
                    caseDiameterMm = 37.0,
                    waterResistance = "Resistente a respingos (3 bar)",
                    dialColor = "Branco / Prata Sunburst (Dia/Data)",
                    boxAndPapers = false,
                    imageUri = "android.resource://com.example/drawable/seiko_presage_1785946338262",
                    notes = "★ PRIORIDADE 1 DO LOTE: Seiko 5 automático clássico com calendário duplo dia/data. Custo lote pro-rata: R$ 450 + Peças R$ 160 + Pulseira R$ 20 + Revisão R$ 450 = Custo Total R$ 1.080. Valor de venda estimado no mercado BR: R$ 700 a R$ 900."
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seiko5Id,
                    serviceDate = "15/03/2026",
                    serviceType = "Compra de Peças & Pulseira",
                    providerName = "Fornecedor eBay / Peças",
                    cost = 180.0, // R$ 160 peças + R$ 20 pulseira
                    details = "Componentes para restauração (R$ 160) e nova pulseira de aço (R$ 20).",
                    nextServiceDueDate = "",
                    orderCode = "EBAY-127730961092"
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seiko5Id,
                    serviceDate = "20/03/2026",
                    serviceType = "Revisão Geral & Lubrificação (Orçamento)",
                    providerName = "Mestre Relojoeiro",
                    cost = 450.0,
                    details = "Estimativa de revisão completa do movimento calibre 7009, lubrificação Moebius e polimento suave.",
                    nextServiceDueDate = "20/03/2029",
                    orderCode = "REV-7009"
                )
            )

            // 2. Seiko Prata Automático (7005)
            val seikoPrataId = repository.insertWatch(
                WatchEntity(
                    brand = "Seiko",
                    model = "Seiko Automatic Prata Vintage",
                    referenceNumber = "7005-SILVER",
                    serialNumber = "EBAY-127730961092-2",
                    purchaseYear = 2026,
                    purchaseDateFormatted = "15/03/2026",
                    purchasePrice = 450.0,
                    currency = "R$",
                    estimatedValue = 750.0, // Valor estimado mercado BR (R$ 650 - 850)
                    provenance = "Lote 3x Seiko eBay #127730961092 • Rastreio DHL: 1998979684 (Comprado em 15/03/2026)",
                    condition = "Vintage (Em Restauração)",
                    movementType = "Automático",
                    movementCaliber = "Seiko Calibre 7005",
                    caseMaterial = "Aço Inoxidável",
                    strapMaterial = "Pulseira de Aço Articulada (Beads of Rice)",
                    caseDiameterMm = 36.0,
                    waterResistance = "Resistente a respingos",
                    dialColor = "Prata Sunburst Vintage",
                    boxAndPapers = false,
                    imageUri = "android.resource://com.example/drawable/seiko_presage_1785946338262",
                    notes = "★ PRIORIDADE 2 DO LOTE: Mostrador prata clássico. Opção de colocar pulseira de couro preta (R$ 20). Custo base lote: R$ 450 + Peças/Pulseira R$ 180 + Revisão R$ 450 = Custo Total R$ 1.080."
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seikoPrataId,
                    serviceDate = "15/03/2026",
                    serviceType = "Peças & Pulseira de Couro Preta",
                    providerName = "Loja de Peças / eBay",
                    cost = 180.0,
                    details = "Peças de reposição (R$ 160) + Pulseira de couro genuíno preta (R$ 20).",
                    nextServiceDueDate = "",
                    orderCode = "EBAY-127730961092"
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seikoPrataId,
                    serviceDate = "20/03/2026",
                    serviceType = "Revisão Periódica (Orçamento)",
                    providerName = "Oficina Técnica Relojoeira",
                    cost = 450.0,
                    details = "Orçamento para revisão e regulagem do movimento 7005.",
                    nextServiceDueDate = "20/03/2029",
                    orderCode = "REV-7005"
                )
            )

            // 3. Seiko Kinetic SQ Bicolor
            val seikoKineticId = repository.insertWatch(
                WatchEntity(
                    brand = "Seiko",
                    model = "Seiko Kinetic SQ Bicolor",
                    referenceNumber = "KINETIC-SQ-BICOLOR",
                    serialNumber = "EBAY-127730961092-3",
                    purchaseYear = 2026,
                    purchaseDateFormatted = "15/03/2026",
                    purchasePrice = 450.0,
                    currency = "R$",
                    estimatedValue = 350.0, // Venda no estado recomendada (R$ 300 - 400)
                    provenance = "Lote 3x Seiko eBay #127730961092 • Rastreio DHL: 1998979684 (Comprado em 15/03/2026)",
                    condition = "Vintage / Necessita Reparo",
                    movementType = "Kinetic (Quartzo com gerador auto)",
                    movementCaliber = "Seiko Kinetic SQ",
                    caseMaterial = "Aço Inoxidável com Aro Dourado (Bicolor)",
                    strapMaterial = "Pulseira Bicolor Aço e Ouro",
                    caseDiameterMm = 38.0,
                    waterResistance = "50m",
                    dialColor = "Preto com Detalhes Dourados",
                    boxAndPapers = false,
                    imageUri = "android.resource://com.example/drawable/seiko_presage_1785946338262",
                    notes = "⚠️ ESTRATÉGIA DE REDUÇÃO DE RISCO: Recomendado vender no estado (R$ 300 ~ R$ 400) para recuperar caixa e reduzir o custo real dos 2 Seiko automáticos para R$ 800 - R$ 900. Evita gastar R$ 320 em acumulador (Orçamento Cláudio Pinheiro R$ 320 + R$ 450 revisão = R$ 770)."
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seikoKineticId,
                    serviceDate = "15/03/2026",
                    serviceType = "Orçamento Acumulador / Troca de Capacitor",
                    providerName = "Cláudio Pinheiro Relojoeiro",
                    cost = 320.0,
                    details = "Orçamento para troca de acumulador Kinetic por Cláudio Pinheiro (Ref R$ 407 original).",
                    nextServiceDueDate = "",
                    orderCode = "ORC-CLAUDIO-320"
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seikoKineticId,
                    serviceDate = "20/03/2026",
                    serviceType = "Revisão Técnica Estimada",
                    providerName = "Oficina de Relojoaria",
                    cost = 450.0,
                    details = "Estimativa de revisão completa se optar por restaurar.",
                    nextServiceDueDate = "",
                    orderCode = "REV-KINETIC"
                )
            )
        }
    }
}
