package com.example.data.parser

import com.example.data.model.MaintenanceLogEntity
import com.example.data.model.WatchEntity

data class ParsedWatchResult(
    val watch: WatchEntity,
    val maintenanceLogs: List<MaintenanceLogEntity>
)

object GoogleDocsParser {

    fun parseDocumentText(rawText: String): ParsedWatchResult {
        val lines = rawText.lines().map { it.trim() }.filter { it.isNotEmpty() }
        
        var brand = ""
        var model = ""
        var ref = ""
        var serial = ""
        var year = 2023
        var dateFormatted = ""
        var price = 0.0
        var currency = "R$"
        var estimatedVal = 0.0
        var provenance = ""
        var condition = "Excelente"
        var movement = "Automático"
        var caliber = ""
        var caseMat = "Aço Inoxidável"
        var strapMat = "Aço Inoxidável"
        var diameter = 40.0
        var waterRes = "100m"
        var dialColor = "Preto"
        var boxPapers = true
        var notes = ""

        val maintenanceLogs = mutableListOf<MaintenanceLogEntity>()
        var inMaintenanceSection = false
        val notesBuilder = StringBuilder()

        for (line in lines) {
            val lower = line.lowercase()

            // Detect section headers
            if (lower.contains("manutenção") || lower.contains("manutencao") || lower.contains("histórico de serviço") || lower.contains("historico de servico")) {
                inMaintenanceSection = true
                continue
            }

            if (inMaintenanceSection) {
                // Try to parse maintenance item: e.g. "15/03/2024 - Revisão Completa - Oficina Silva - R$ 1200 - Detalhes"
                val log = parseMaintenanceLine(line)
                if (log != null) {
                    maintenanceLogs.add(log)
                } else if (!lower.contains("histórico") && line.length > 5) {
                    // General maintenance description
                    maintenanceLogs.add(
                        MaintenanceLogEntity(
                            watchId = 0,
                            serviceDate = "2024",
                            serviceType = "Manutenção Registrada",
                            providerName = "Relojoeiro Especializado",
                            cost = 0.0,
                            details = line
                        )
                    )
                }
                continue
            }

            // Key-Value parsing
            when {
                lower.startsWith("marca:") || lower.startsWith("brand:") -> {
                    brand = extractValue(line)
                }
                lower.startsWith("modelo:") || lower.startsWith("model:") -> {
                    model = extractValue(line)
                }
                lower.startsWith("referência:") || lower.startsWith("referencia:") || lower.startsWith("ref:") -> {
                    ref = extractValue(line)
                }
                lower.startsWith("série:") || lower.startsWith("serie:") || lower.startsWith("serial:") -> {
                    serial = extractValue(line)
                }
                lower.startsWith("ano:") || lower.startsWith("ano de compra:") || lower.startsWith("ano compra:") -> {
                    val str = extractValue(line)
                    str.filter { it.isDigit() }.take(4).toIntOrNull()?.let { year = it }
                    if (str.length >= 4) dateFormatted = str
                }
                lower.startsWith("data de compra:") || lower.startsWith("quando comprei:") -> {
                    dateFormatted = extractValue(line)
                    dateFormatted.filter { it.isDigit() }.takeLast(4).toIntOrNull()?.let { year = it }
                }
                lower.startsWith("preço:") || lower.startsWith("preco:") || lower.startsWith("valor pago:") || lower.startsWith("quanto paguei:") || lower.startsWith("valor:") -> {
                    val valStr = extractValue(line)
                    if (valStr.contains("$") || valStr.lowercase().contains("usd")) currency = "$"
                    if (valStr.contains("€") || valStr.lowercase().contains("eur")) currency = "€"
                    val cleanDigits = valStr.replace(".", "").replace(",", ".").replace(Regex("[^0-9.]"), "")
                    cleanDigits.toDoubleOrNull()?.let { price = it }
                }
                lower.startsWith("valor estimado:") || lower.startsWith("estimativa:") -> {
                    val valStr = extractValue(line)
                    val cleanDigits = valStr.replace(".", "").replace(",", ".").replace(Regex("[^0-9.]"), "")
                    cleanDigits.toDoubleOrNull()?.let { estimatedVal = it }
                }
                lower.startsWith("procedência:") || lower.startsWith("procedencia:") || lower.startsWith("origem:") || lower.startsWith("vendedor:") -> {
                    provenance = extractValue(line)
                }
                lower.startsWith("estado:") || lower.startsWith("condição:") || lower.startsWith("condicao:") -> {
                    condition = extractValue(line)
                }
                lower.startsWith("movimento:") || lower.startsWith("mecanismo:") || lower.startsWith("calibre:") -> {
                    movement = extractValue(line)
                }
                lower.startsWith("caixa:") || lower.startsWith("material caixa:") || lower.startsWith("material:") -> {
                    caseMat = extractValue(line)
                }
                lower.startsWith("pulseira:") -> {
                    strapMat = extractValue(line)
                }
                lower.startsWith("diâmetro:") || lower.startsWith("diametro:") || lower.startsWith("tamanho:") -> {
                    val str = extractValue(line)
                    str.replace(",", ".").filter { it.isDigit() || it == '.' }.toDoubleOrNull()?.let { diameter = it }
                }
                lower.startsWith("mostrador:") || lower.startsWith("cor mostrador:") -> {
                    dialColor = extractValue(line)
                }
                lower.startsWith("caixa e papéis:") || lower.startsWith("caixa e papeis:") || lower.startsWith("documentos:") -> {
                    val str = extractValue(line).lowercase()
                    boxPapers = !str.contains("não") && !str.contains("nao") && !str.contains("sem")
                }
                lower.startsWith("notas:") || lower.startsWith("observações:") || lower.startsWith("observacoes:") || lower.startsWith("histórico:") || lower.startsWith("historico:") -> {
                    notesBuilder.append(extractValue(line)).append("\n")
                }
                else -> {
                    // Unstructured fallback inference
                    if (brand.isEmpty() && (lower.contains("rolex") || lower.contains("omega") || lower.contains("seiko") || lower.contains("cartier") || lower.contains("patek") || lower.contains("casio") || lower.contains("tissot") || lower.contains("tag heuer") || lower.contains("longines") || lower.contains("tudor") || lower.contains("breitling") || lower.contains("hamilton") || lower.contains("orient") || lower.contains("citizen") || lower.contains("audemars"))) {
                        val words = line.split(" ")
                        if (words.isNotEmpty()) {
                            brand = words[0]
                            if (words.size > 1) model = words.drop(1).joinToString(" ")
                        }
                    } else if (brand.isNotEmpty() && model.isEmpty()) {
                        model = line
                    } else {
                        notesBuilder.append(line).append("\n")
                    }
                }
            }
        }

        if (brand.isEmpty()) brand = "Relógio Cadastrado"
        if (model.isEmpty()) model = "Modelo sem Nome"
        if (dateFormatted.isEmpty()) dateFormatted = "01/01/$year"
        if (estimatedVal == 0.0) estimatedVal = price

        notes = notesBuilder.toString().trim()

        val watch = WatchEntity(
            brand = brand,
            model = model,
            referenceNumber = ref,
            serialNumber = serial,
            purchaseYear = year,
            purchaseDateFormatted = dateFormatted,
            purchasePrice = price,
            currency = currency,
            estimatedValue = estimatedVal,
            provenance = provenance,
            condition = condition,
            movementType = movement,
            movementCaliber = caliber,
            caseMaterial = caseMat,
            strapMaterial = strapMat,
            caseDiameterMm = diameter,
            waterResistance = waterRes,
            dialColor = dialColor,
            boxAndPapers = boxPapers,
            imageUri = "",
            notes = notes
        )

        return ParsedWatchResult(watch, maintenanceLogs)
    }

    private fun extractValue(line: String): String {
        val colonIdx = line.indexOf(':')
        return if (colonIdx != -1 && colonIdx < line.length - 1) {
            line.substring(colonIdx + 1).trim()
        } else {
            line.trim()
        }
    }

    private fun parseMaintenanceLine(line: String): MaintenanceLogEntity? {
        val parts = line.split("|", "-", ";").map { it.trim() }
        if (parts.size >= 2) {
            val datePart = parts[0]
            val typePart = parts[1]
            val providerPart = if (parts.size > 2) parts[2] else "Assistência Técnica"
            
            var costVal = 0.0
            var detailsText = ""
            var nextDue = ""

            for (i in 2 until parts.size) {
                val p = parts[i]
                if (p.lowercase().contains("r$") || p.lowercase().contains("$") || p.lowercase().contains("custo") || p.lowercase().contains("paguei")) {
                    p.replace(".", "").replace(",", ".").filter { it.isDigit() || it == '.' }.toDoubleOrNull()?.let { costVal = it }
                } else if (p.lowercase().contains("próxima") || p.lowercase().contains("proxima") || p.lowercase().contains("revisão em")) {
                    nextDue = p
                } else {
                    if (detailsText.isNotEmpty()) detailsText += " | "
                    detailsText += p
                }
            }

            return MaintenanceLogEntity(
                watchId = 0,
                serviceDate = datePart,
                serviceType = typePart,
                providerName = providerPart,
                cost = costVal,
                details = detailsText,
                nextServiceDueDate = nextDue
            )
        }
        return null
    }
}
