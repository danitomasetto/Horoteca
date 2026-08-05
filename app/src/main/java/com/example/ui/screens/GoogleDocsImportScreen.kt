package com.example.ui.screens

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Description
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.data.parser.GoogleDocsParser
import com.example.data.parser.ParsedWatchResult
import com.example.ui.theme.GoldLight
import com.example.ui.theme.GoldPrimary
import com.example.ui.theme.HorologyNavyDark
import com.example.ui.theme.HorologyNavySurface
import java.text.NumberFormat
import java.util.Locale

private val SAMPLE_DOC_ROLEX = """
Marca: Rolex
Modelo: GMT-Master II 'Batman'
Referência: 126710BLNR
Ano de Compra: 2023
Data de Compra: 20/09/2023
Valor Pago: R$ 98.000
Valor Estimado: R$ 110.000
Procedência: Comprado na Boutique Rolex Cidade Jardim com Nota Fiscal, Certificado e Estojo Original
Estado: Excelente
Movimento: Automático Calibre 3285
Caixa: Aço Oystersteel 40mm
Pulseira: Jubilee em Aço
Caixa e Papéis: Sim
Mostrador: Preto
Observações: Bezel Cerachrom azul e preto. Função GMT para fuso horário duplo.

Histórico de Manutenção:
- 15/04/2024 - Teste de Estanqueidade e Verificação de Calibração - Autorizada Rolex SP - R$ 350 - Regulado para +1s/dia. Próxima: 2027
""".trimIndent()

private val SAMPLE_DOC_CARTIER = """
Marca: Cartier
Modelo: Santos de Cartier Large
Referência: WSSA0018
Ano: 2022
Quanto Paguei: R$ 42.000
Procedência: Boutique Cartier Shopping Iguatemi SP com garantia de 8 anos
Movimento: Automático 1847 MC
Caixa: Aço Inoxidável
Pulseira: Aço com sistema SmartLink e pulseira extra em couro de crocodilo
Diâmetro: 39.8mm
Mostrador: Prateado com numerais romanos

Histórico de Serviço:
- 10/01/2023 | Limpeza Ultra-sônica e Polimento de Pulseira | Atelier Cartier | R$ 600 | Polimento leve
- 05/02/2025 | Revisão do Mecanismo | Assistência Cartier | R$ 1.800 | Troca de vedação. Próxima em 2029
""".trimIndent()

private val SAMPLE_DOC_MULTI_ORDER = """
--- ITEM 1 (Unidade 1) ---
Marca: Omega
Modelo: Speedmaster Professional Moonwatch
Referência: 310.30.42.50.01.001
Ano de Compra: 2022
Valor Pago: R$ 48.000
Procedência: Pedido de Compra 10452 - Lote de Colecionador RJ
Movimento: Corda Manual Calibre 3861
Caixa: Aço 42mm

--- ITEM 2 (Unidade 2) ---
Marca: Tudor
Modelo: Black Bay Fifty-Eight
Referência: M79030N-0001
Ano de Compra: 2023
Valor Pago: R$ 24.500
Procedência: Pedido de Compra 10452 - Lote de Colecionador RJ
Movimento: Automático MT5402
Caixa: Aço 39mm
""".trimIndent()

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GoogleDocsImportScreen(
    onBackClick: () -> Unit,
    onImportSave: (String) -> Unit,
    onImportSaveMultiple: ((List<ParsedWatchResult>) -> Unit)? = null
) {
    var rawText by remember { mutableStateOf(SAMPLE_DOC_MULTI_ORDER) }
    var orderNumberInput by remember { mutableStateOf("10452") }
    var suffixType by remember { mutableStateOf("01") } // "01" or "A"
    var parsedResults by remember { mutableStateOf<List<ParsedWatchResult>>(emptyList()) }
    var importSuccessMessage by remember { mutableStateOf("") }

    val ptBr = Locale("pt", "BR")
    val currencyFormat = NumberFormat.getCurrencyInstance(ptBr)

    LaunchedEffect(rawText, orderNumberInput, suffixType) {
        if (rawText.isNotBlank()) {
            parsedResults = GoogleDocsParser.parseMultiWatchDocument(
                rawText = rawText,
                orderNumber = orderNumberInput,
                suffixType = suffixType
            )
        } else {
            parsedResults = emptyList()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Importar Documento / Pedido",
                        color = GoldPrimary,
                        style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold)
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Voltar", tint = Color.White)
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
            Card(
                colors = CardDefaults.cardColors(containerColor = HorologyNavySurface),
                shape = RoundedCornerShape(12.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Description, contentDescription = null, tint = GoldPrimary)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = "Copie e cole o texto do seu arquivo ou nota",
                            style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
                            color = GoldLight
                        )
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = "Cole o texto do documento da compra. Se o arquivo contiver 2 ou 3 unidades do mesmo pedido, digite o Número do Pedido abaixo para gerar automaticamente os códigos de registro com sufixo (ex: 10452-01, 10452-02).",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            // Order Number & Suffix Section
            Card(
                colors = CardDefaults.cardColors(containerColor = HorologyNavySurface),
                shape = RoundedCornerShape(12.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "Identificação do Pedido / Arquivo (Opcional)",
                        style = MaterialTheme.typography.titleSmall.copy(fontWeight = FontWeight.Bold),
                        color = GoldPrimary
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    OutlinedTextField(
                        value = orderNumberInput,
                        onValueChange = { orderNumberInput = it },
                        label = { Text("Número do Pedido / Arquivo (Ex: 10452)") },
                        placeholder = { Text("10452") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(8.dp),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = GoldPrimary,
                            unfocusedBorderColor = MaterialTheme.colorScheme.outline
                        )
                    )

                    if (orderNumberInput.isNotBlank()) {
                        Spacer(modifier = Modifier.height(10.dp))
                        Text(
                            text = "Sufixo para múltiplas unidades no mesmo pedido:",
                            style = MaterialTheme.typography.labelSmall,
                            color = Color.White
                        )
                        Row(
                            horizontalArrangement = Arrangement.spacedBy(8.dp),
                            modifier = Modifier.padding(top = 4.dp)
                        ) {
                            FilterChip(
                                selected = suffixType == "01",
                                onClick = { suffixType = "01" },
                                label = { Text("Numérico (-01, -02)") },
                                colors = FilterChipDefaults.filterChipColors(
                                    selectedContainerColor = GoldPrimary,
                                    selectedLabelColor = Color.Black
                                )
                            )

                            FilterChip(
                                selected = suffixType == "A",
                                onClick = { suffixType = "A" },
                                label = { Text("Letras (-A, -B)") },
                                colors = FilterChipDefaults.filterChipColors(
                                    selectedContainerColor = GoldPrimary,
                                    selectedLabelColor = Color.Black
                                )
                            )
                        }
                    }
                }
            }

            // Quick Preset Buttons
            Text(
                text = "Exemplos Práticos para Testar:",
                style = MaterialTheme.typography.labelLarge,
                color = GoldPrimary
            )

            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                OutlinedButton(
                    onClick = {
                        rawText = SAMPLE_DOC_MULTI_ORDER
                        orderNumberInput = "10452"
                        suffixType = "01"
                        importSuccessMessage = ""
                    },
                    modifier = Modifier.weight(1.3f)
                ) {
                    Text("Pedido 10452 (2 Unid.)", style = MaterialTheme.typography.labelSmall, color = GoldLight)
                }

                OutlinedButton(
                    onClick = {
                        rawText = SAMPLE_DOC_ROLEX
                        orderNumberInput = ""
                        importSuccessMessage = ""
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Rolex Unic.", style = MaterialTheme.typography.labelSmall)
                }

                OutlinedButton(
                    onClick = {
                        rawText = SAMPLE_DOC_CARTIER
                        orderNumberInput = ""
                        importSuccessMessage = ""
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Cartier Unic.", style = MaterialTheme.typography.labelSmall)
                }
            }

            // Text Area Input
            OutlinedTextField(
                value = rawText,
                onValueChange = {
                    rawText = it
                    importSuccessMessage = ""
                },
                label = { Text("Conteúdo do Documento do Pedido") },
                placeholder = { Text("Cole aqui o texto contendo os relógios...") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp),
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = GoldPrimary,
                    unfocusedBorderColor = MaterialTheme.colorScheme.outline
                )
            )

            // Parsed Results Live Preview
            if (parsedResults.isNotEmpty()) {
                Text(
                    text = "Relógios Identificados no Documento (${parsedResults.size}):",
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
                    color = GoldPrimary
                )

                parsedResults.forEachIndexed { index, parsed ->
                    val w = parsed.watch
                    val logs = parsed.maintenanceLogs

                    Card(
                        shape = RoundedCornerShape(16.dp),
                        colors = CardDefaults.cardColors(containerColor = HorologyNavySurface),
                        modifier = Modifier
                            .fillMaxWidth()
                            .border(1.dp, GoldPrimary, RoundedCornerShape(16.dp))
                    ) {
                        Column(modifier = Modifier.padding(16.dp)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = GoldPrimary)
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text(
                                        text = "Item #${index + 1}",
                                        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
                                        color = GoldPrimary
                                    )
                                }

                                if (orderNumberInput.isNotBlank()) {
                                    Surface(
                                        color = GoldPrimary.copy(alpha = 0.2f),
                                        shape = RoundedCornerShape(6.dp),
                                        border = androidx.compose.foundation.BorderStroke(1.dp, GoldPrimary)
                                    ) {
                                        Text(
                                            text = "ID: ${if (suffixType == "A") "$orderNumberInput-${'A' + index}" else "$orderNumberInput-${String.format("%02d", index + 1)}"}",
                                            style = MaterialTheme.typography.labelSmall.copy(fontWeight = FontWeight.Bold),
                                            color = GoldLight,
                                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                                        )
                                    }
                                }
                            }

                            Spacer(modifier = Modifier.height(10.dp))

                            Text(
                                text = "${w.brand} - ${w.model}",
                                style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold),
                                color = Color.White
                            )

                            if (w.referenceNumber.isNotEmpty()) {
                                Text(
                                    text = "Ref/Registro: ${w.referenceNumber}",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = GoldLight
                                )
                            }

                            Spacer(modifier = Modifier.height(8.dp))

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("Ano: ${w.purchaseYear}", style = MaterialTheme.typography.bodyMedium, color = Color.White)
                                Text("Valor Pago: ${currencyFormat.format(w.purchasePrice)}", style = MaterialTheme.typography.bodyMedium.copy(fontWeight = FontWeight.Bold), color = GoldLight)
                            }

                            if (w.provenance.isNotEmpty()) {
                                Spacer(modifier = Modifier.height(6.dp))
                                Text("Procedência: ${w.provenance}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                            }

                            if (logs.isNotEmpty()) {
                                Spacer(modifier = Modifier.height(8.dp))
                                HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
                                Spacer(modifier = Modifier.height(8.dp))

                                Text(
                                    text = "Manutenções Extraídas: ${logs.size} registro(s)",
                                    style = MaterialTheme.typography.titleSmall,
                                    color = GoldPrimary
                                )

                                logs.forEach { log ->
                                    Text(
                                        text = "• [${log.serviceDate}] ${log.serviceType} - ${log.providerName} (${currencyFormat.format(log.cost)})",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = Color.White,
                                        modifier = Modifier.padding(vertical = 2.dp)
                                    )
                                }
                            }
                        }
                    }
                }
            }

            if (importSuccessMessage.isNotEmpty()) {
                Surface(
                    color = MaterialTheme.colorScheme.primaryContainer,
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier.padding(12.dp)
                    ) {
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GoldPrimary)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = importSuccessMessage,
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onPrimaryContainer
                        )
                    }
                }
            }

            Button(
                onClick = {
                    if (parsedResults.isNotEmpty()) {
                        if (onImportSaveMultiple != null) {
                            onImportSaveMultiple(parsedResults)
                        } else {
                            parsedResults.forEach { parsed ->
                                onImportSave(parsed.watch.notes + "\n" + parsed.watch.brand + " " + parsed.watch.model)
                            }
                        }
                        importSuccessMessage = "${parsedResults.size} relógio(s) importado(s) e adicionado(s) à sua coleção com sucesso!"
                    }
                },
                enabled = parsedResults.isNotEmpty(),
                colors = ButtonDefaults.buttonColors(containerColor = GoldPrimary),
                shape = RoundedCornerShape(12.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(52.dp)
            ) {
                Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Color.Black)
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = if (parsedResults.size > 1) "Salvar Todos os ${parsedResults.size} Relógios" else "Importar e Salvar no Banco de Dados",
                    color = Color.Black,
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold)
                )
            }

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}
