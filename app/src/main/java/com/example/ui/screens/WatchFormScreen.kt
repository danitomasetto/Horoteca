package com.example.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.example.data.model.WatchEntity
import com.example.ui.components.PresetImagePicker
import com.example.ui.theme.GoldPrimary
import com.example.ui.theme.HorologyNavyDark
import com.example.ui.theme.HorologyNavySurface

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WatchFormScreen(
    initialWatch: WatchEntity? = null,
    onBackClick: () -> Unit,
    onSaveWatch: (WatchEntity) -> Unit,
    onOpenBrandHistoryClick: (String) -> Unit = {}
) {
    var brand by remember { mutableStateOf(initialWatch?.brand ?: "") }
    var model by remember { mutableStateOf(initialWatch?.model ?: "") }
    var referenceNumber by remember { mutableStateOf(initialWatch?.referenceNumber ?: "") }
    var serialNumber by remember { mutableStateOf(initialWatch?.serialNumber ?: "") }
    var purchaseYearText by remember { mutableStateOf(initialWatch?.purchaseYear?.toString() ?: "2023") }
    var purchaseDateFormatted by remember { mutableStateOf(initialWatch?.purchaseDateFormatted ?: "15/05/2023") }
    var purchasePriceText by remember { mutableStateOf(initialWatch?.purchasePrice?.toString() ?: "12000.0") }
    var currency by remember { mutableStateOf(initialWatch?.currency ?: "R$") }
    var estimatedValueText by remember { mutableStateOf(initialWatch?.estimatedValue?.toString() ?: "15000.0") }
    var provenance by remember { mutableStateOf(initialWatch?.provenance ?: "Boutique Oficial com Nota Fiscal e Garantia") }
    var condition by remember { mutableStateOf(initialWatch?.condition ?: "Excelente") }
    var movementType by remember { mutableStateOf(initialWatch?.movementType ?: "Automático") }
    var movementCaliber by remember { mutableStateOf(initialWatch?.movementCaliber ?: "") }
    var caseMaterial by remember { mutableStateOf(initialWatch?.caseMaterial ?: "Aço Inoxidável") }
    var strapMaterial by remember { mutableStateOf(initialWatch?.strapMaterial ?: "Aço Inoxidável") }
    var caseDiameterText by remember { mutableStateOf(initialWatch?.caseDiameterMm?.toString() ?: "40.0") }
    var waterResistance by remember { mutableStateOf(initialWatch?.waterResistance ?: "100m") }
    var dialColor by remember { mutableStateOf(initialWatch?.dialColor ?: "Preto") }
    var boxAndPapers by remember { mutableStateOf(initialWatch?.boxAndPapers ?: true) }
    var imageUri by remember { mutableStateOf(initialWatch?.imageUri ?: "") }
    var notes by remember { mutableStateOf(initialWatch?.notes ?: "") }

    var errorMessage by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = if (initialWatch == null) "Nova Ficha de Cadastro" else "Editar Ficha de Cadastro",
                        color = GoldPrimary,
                        style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold)
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Voltar", tint = Color.White)
                    }
                },
                actions = {
                    Button(
                        onClick = {
                            if (brand.isBlank() || model.isBlank()) {
                                errorMessage = "Por favor preencha pelo menos a Marca e o Modelo."
                                return@Button
                            }
                            val year = purchaseYearText.toIntOrNull() ?: 2023
                            val price = purchasePriceText.replace(",", ".").toDoubleOrNull() ?: 0.0
                            val estValue = estimatedValueText.replace(",", ".").toDoubleOrNull() ?: price
                            val diameter = caseDiameterText.replace(",", ".").toDoubleOrNull() ?: 40.0

                            val watchToSave = (initialWatch ?: WatchEntity(brand = "", model = "")).copy(
                                brand = brand.trim(),
                                model = model.trim(),
                                referenceNumber = referenceNumber.trim(),
                                serialNumber = serialNumber.trim(),
                                purchaseYear = year,
                                purchaseDateFormatted = purchaseDateFormatted.trim(),
                                purchasePrice = price,
                                currency = currency,
                                estimatedValue = estValue,
                                provenance = provenance.trim(),
                                condition = condition.trim(),
                                movementType = movementType.trim(),
                                movementCaliber = movementCaliber.trim(),
                                caseMaterial = caseMaterial.trim(),
                                strapMaterial = strapMaterial.trim(),
                                caseDiameterMm = diameter,
                                waterResistance = waterResistance.trim(),
                                dialColor = dialColor.trim(),
                                boxAndPapers = boxAndPapers,
                                imageUri = imageUri,
                                notes = notes.trim()
                            )
                            onSaveWatch(watchToSave)
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = GoldPrimary)
                    ) {
                        Icon(Icons.Default.Check, contentDescription = null, tint = Color.Black)
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Salvar", color = Color.Black, fontWeight = FontWeight.Bold)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = HorologyNavySurface)
            )
        },
        containerColor = HorologyNavyDark
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            if (errorMessage.isNotEmpty()) {
                Card(
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.errorContainer)
                ) {
                    Text(
                        text = errorMessage,
                        color = MaterialTheme.colorScheme.onErrorContainer,
                        modifier = Modifier.padding(12.dp)
                    )
                }
            }

            // Photo Selection Section
            PresetImagePicker(
                selectedImageUri = imageUri,
                onImageSelected = { imageUri = it }
            )

            HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))

            Text("Informações Básicas do Relógio", style = MaterialTheme.typography.titleMedium, color = GoldPrimary)

            OutlinedTextField(
                value = brand,
                onValueChange = { brand = it },
                label = { Text("Marca (ex: Rolex, Omega, Seiko, Cartier)") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth()
            )

            if (brand.isNotBlank()) {
                TextButton(
                    onClick = { onOpenBrandHistoryClick(brand) },
                    contentPadding = PaddingValues(0.dp)
                ) {
                    Text("📖 Consultar história e tradição da marca '$brand'", style = MaterialTheme.typography.labelSmall, color = GoldPrimary)
                }
            }

            OutlinedTextField(
                value = model,
                onValueChange = { model = it },
                label = { Text("Modelo (ex: Submariner Date, Speedmaster, Presage)") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth()
            )

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = referenceNumber,
                    onValueChange = { referenceNumber = it },
                    label = { Text("Referência (ex: 126610LN)") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )

                OutlinedTextField(
                    value = serialNumber,
                    onValueChange = { serialNumber = it },
                    label = { Text("Nº de Série") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )
            }

            HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))

            Text("Aquisição & Procedência (Ficha Financeira)", style = MaterialTheme.typography.titleMedium, color = GoldPrimary)

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = purchasePriceText,
                    onValueChange = { purchasePriceText = it },
                    label = { Text("Quanto Paguei (R$)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )

                OutlinedTextField(
                    value = estimatedValueText,
                    onValueChange = { estimatedValueText = it },
                    label = { Text("Valor Estimado Atual") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )
            }

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = purchaseDateFormatted,
                    onValueChange = { purchaseDateFormatted = it },
                    label = { Text("Data de Compra (ex: 15/05/2023)") },
                    singleLine = true,
                    modifier = Modifier.weight(1.2f)
                )

                OutlinedTextField(
                    value = purchaseYearText,
                    onValueChange = { purchaseYearText = it },
                    label = { Text("Ano") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.weight(0.8f)
                )
            }

            OutlinedTextField(
                value = provenance,
                onValueChange = { provenance = it },
                label = { Text("Procedência / Vendedor / Origem (ex: Boutique Oficial SP, Leilão, Particular)") },
                maxLines = 2,
                modifier = Modifier.fillMaxWidth()
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Possui Caixa & Documentos Originais (Box & Papers)?",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.weight(1f)
                )
                Switch(
                    checked = boxAndPapers,
                    onCheckedChange = { boxAndPapers = it },
                    colors = SwitchDefaults.colors(checkedThumbColor = GoldPrimary)
                )
            }

            OutlinedTextField(
                value = condition,
                onValueChange = { condition = it },
                label = { Text("Estado de Conservação (ex: Novo, Excelente, Vintage)") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth()
            )

            HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))

            Text("Especificações Técnicas", style = MaterialTheme.typography.titleMedium, color = GoldPrimary)

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = movementType,
                    onValueChange = { movementType = it },
                    label = { Text("Movimento (Automático, Corda, Quartzo)") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )

                OutlinedTextField(
                    value = movementCaliber,
                    onValueChange = { movementCaliber = it },
                    label = { Text("Calibre (ex: 3235, 3861)") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )
            }

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = caseMaterial,
                    onValueChange = { caseMaterial = it },
                    label = { Text("Material Caixa") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )

                OutlinedTextField(
                    value = strapMaterial,
                    onValueChange = { strapMaterial = it },
                    label = { Text("Pulseira") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )
            }

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = caseDiameterText,
                    onValueChange = { caseDiameterText = it },
                    label = { Text("Diâmetro (mm)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )

                OutlinedTextField(
                    value = waterResistance,
                    onValueChange = { waterResistance = it },
                    label = { Text("Resistência d'Água") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )
            }

            OutlinedTextField(
                value = dialColor,
                onValueChange = { dialColor = it },
                label = { Text("Cor do Mostrador") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = notes,
                onValueChange = { notes = it },
                label = { Text("Notas Adicionais do Colecionador") },
                maxLines = 4,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}
