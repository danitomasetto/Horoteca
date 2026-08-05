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
        .onEach { list ->
            if (list.isEmpty()) {
                seedInitialData()
            }
        }
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

    fun generateWebShowcaseHtml(title: String, owner: String): String {
        return WebPageGenerator.generateHTML(
            collectionTitle = title,
            ownerName = owner,
            watches = _allWatches.value
        )
    }

    private fun seedInitialData() {
        viewModelScope.launch {
            val rolexId = repository.insertWatch(
                WatchEntity(
                    brand = "Rolex",
                    model = "Submariner Date 41mm",
                    referenceNumber = "126610LN",
                    serialNumber = "W79482A9",
                    purchaseYear = 2022,
                    purchaseDateFormatted = "18/05/2022",
                    purchasePrice = 72000.0,
                    currency = "R$",
                    estimatedValue = 85000.0,
                    provenance = "Boutique Oficial Rolex São Paulo • NF #98124 com Certificado de Garantia Internacional",
                    condition = "Excelente (Mint)",
                    movementType = "Automático",
                    movementCaliber = "Calibre 3235",
                    caseMaterial = "Aço Inoxidável Oystersteel 904L",
                    strapMaterial = "Pulseira Oyster com fecho Glidelock",
                    caseDiameterMm = 41.0,
                    waterResistance = "300m / 1000ft",
                    dialColor = "Preto Brilhante",
                    boxAndPapers = true,
                    imageUri = "android.resource://com.example/drawable/rolex_submariner_1785946310385",
                    notes = "Adquirido novo na caixa. Guardado em estojo com winder automático. Bezel Cerachrom em cerâmica preta inalterável."
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = rolexId,
                    serviceDate = "15/01/2024",
                    serviceType = "Inspeção Periódica de Estanqueidade",
                    providerName = "Assistência Autorizada Rolex SP",
                    cost = 450.0,
                    details = "Teste de estanqueidade em câmara hiperbárica a 30 bar. Substituição da vedação da coroa Triplock.",
                    nextServiceDueDate = "15/01/2027"
                )
            )

            val omegaId = repository.insertWatch(
                WatchEntity(
                    brand = "Omega",
                    model = "Speedmaster Moonwatch Professional",
                    referenceNumber = "310.30.42.50.01.001",
                    serialNumber = "83912041",
                    purchaseYear = 2021,
                    purchaseDateFormatted = "10/11/2021",
                    purchasePrice = 45000.0,
                    currency = "R$",
                    estimatedValue = 52000.0,
                    provenance = "Leilão de Horologia Fina RJ com estojo de viagem e medalha comemorativa da missão Apollo 11",
                    condition = "Excelente",
                    movementType = "Corda Manual (Manual Wind)",
                    movementCaliber = "Omega Co-Axial Master Chronometer 3861",
                    caseMaterial = "Aço Inoxidável 316L",
                    strapMaterial = "Pulseira de Couro de Crocodilo Preta extra",
                    caseDiameterMm = 42.0,
                    waterResistance = "50m",
                    dialColor = "Preto Step Dial",
                    boxAndPapers = true,
                    imageUri = "android.resource://com.example/drawable/omega_speedmaster_1785946324723",
                    notes = "O lendário relógio usado na Lua. Cristal Hesalite com logotipo Omega gravado no centro. Resistência magnética até 15.000 gauss."
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = omegaId,
                    serviceDate = "20/06/2023",
                    serviceType = "Revisão Completa & Lubrificação",
                    providerName = "Mestre Relojoeiro Horologia Fina",
                    cost = 2200.0,
                    details = "Desmontagem completa do calibre 3861, lavagem por ultrassom, substituição do tambor de corda e lubrificação com óleos Moebius.",
                    nextServiceDueDate = "20/06/2028"
                )
            )

            val seikoId = repository.insertWatch(
                WatchEntity(
                    brand = "Seiko",
                    model = "Presage Cocktail Time 'Blue Moon'",
                    referenceNumber = "SRPB41J1",
                    serialNumber = "9D1823",
                    purchaseYear = 2023,
                    purchaseDateFormatted = "05/02/2023",
                    purchasePrice = 3800.0,
                    currency = "R$",
                    estimatedValue = 4500.0,
                    provenance = "Boutique Seiko Japão / Importado com Nota Fiscal e Garantia",
                    condition = "Novo na Caixa",
                    movementType = "Automático com Corda Manual",
                    movementCaliber = "Seiko 4R35",
                    caseMaterial = "Aço Inoxidável Polido Zaratsu",
                    strapMaterial = "Pulseira de Aço Inoxidável com fecho Deployant",
                    caseDiameterMm = 40.5,
                    waterResistance = "50m",
                    dialColor = "Azul Sunbrush Guilloché",
                    boxAndPapers = true,
                    imageUri = "android.resource://com.example/drawable/seiko_presage_1785946338262",
                    notes = "Mostrador inspirado nos coquetéis do Star Bar em Ginza, Tóquio. Ponteiros facetados em corte diamante."
                )
            )

            repository.insertMaintenanceLog(
                MaintenanceLogEntity(
                    watchId = seikoId,
                    serviceDate = "10/02/2024",
                    serviceType = "Ajuste Fino de Precisão",
                    providerName = "Ateliê Horológico Seiko SP",
                    cost = 250.0,
                    details = "Regulagem no cronocomparador para +3 segundos/dia.",
                    nextServiceDueDate = "10/02/2026"
                )
            )
        }
    }
}
