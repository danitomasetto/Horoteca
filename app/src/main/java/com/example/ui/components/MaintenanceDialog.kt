package com.example.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.ConfirmationNumber
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.ShoppingBag
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.example.data.model.MaintenanceLogEntity
import com.example.ui.theme.GoldPrimary
import com.example.ui.theme.GoldLight
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.random.Random

@Composable
fun MaintenanceDialog(
    watchId: Long,
    onDismiss: () -> Unit,
    onSave: (MaintenanceLogEntity) -> Unit
) {
    val currentDateStr = remember {
        SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(Date())
    }

    var serviceDate by remember { mutableStateOf(currentDateStr) }
    var serviceType by remember { mutableStateOf("Revisão Periódica / Compra de Peças") }
    var orderCode by remember { mutableStateOf("EBAY-${Random.nextInt(100000, 999999)}") }
    var providerName by remember { mutableStateOf("Vendedor eBay / Mestre Relojoeiro") }
    var costText by remember { mutableStateOf("250.00") }
    var details by remember { mutableStateOf("Substituição de peças / manutenção preventiva.") }
    var nextDueDate by remember { mutableStateOf("") }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Default.Build,
                    contentDescription = null,
                    tint = GoldPrimary,
                    modifier = Modifier.padding(end = 8.dp)
                )
                Text(
                    text = "Registrar Manutenção / Custo",
                    style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold)
                )
            }
        },
        text = {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .verticalScroll(rememberScrollState()),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedTextField(
                    value = serviceDate,
                    onValueChange = { serviceDate = it },
                    label = { Text("Data do Serviço") },
                    leadingIcon = { Icon(Icons.Default.CalendarToday, contentDescription = null) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = serviceType,
                    onValueChange = { serviceType = it },
                    label = { Text("Tipo de Serviço / Peça") },
                    placeholder = { Text("Ex: Revisão, Peças eBay, Polimento, Troca de Vidro") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                // eBay / Order Code Field
                Column {
                    OutlinedTextField(
                        value = orderCode,
                        onValueChange = { orderCode = it },
                        label = { Text("N° do Pedido / Código eBay") },
                        placeholder = { Text("Ex: EBAY-2819034") },
                        leadingIcon = { Icon(Icons.Default.ConfirmationNumber, contentDescription = null, tint = GoldLight) },
                        trailingIcon = {
                            TextButton(onClick = {
                                orderCode = "EBAY-${Random.nextInt(100000, 999999)}"
                            }) {
                                Text("Gerar", style = MaterialTheme.typography.labelSmall, color = GoldPrimary)
                            }
                        },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth()
                    )
                    Text(
                        text = "Junta o número do pedido eBay com a referência da manutenção",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(start = 4.dp, top = 2.dp)
                    )
                }

                OutlinedTextField(
                    value = providerName,
                    onValueChange = { providerName = it },
                    label = { Text("Relojoeiro / Fornecedor (Ex: eBay Store)") },
                    leadingIcon = { Icon(Icons.Default.Person, contentDescription = null) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = costText,
                    onValueChange = { costText = it },
                    label = { Text("Custo Envolvido (R$)") },
                    leadingIcon = { Icon(Icons.Default.ShoppingBag, contentDescription = null, tint = GoldPrimary) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = details,
                    onValueChange = { details = it },
                    label = { Text("Detalhes do Serviço / Compra") },
                    maxLines = 3,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = nextDueDate,
                    onValueChange = { nextDueDate = it },
                    label = { Text("Próxima Revisão Recomendada (Opcional)") },
                    leadingIcon = { Icon(Icons.Default.CalendarToday, contentDescription = null) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    val costVal = costText.replace(",", ".").toDoubleOrNull() ?: 0.0
                    val log = MaintenanceLogEntity(
                        watchId = watchId,
                        serviceDate = serviceDate.trim(),
                        serviceType = serviceType.trim(),
                        providerName = providerName.trim(),
                        cost = costVal,
                        details = details.trim(),
                        nextServiceDueDate = nextDueDate.trim(),
                        orderCode = orderCode.trim()
                    )
                    onSave(log)
                },
                colors = ButtonDefaults.buttonColors(containerColor = GoldPrimary)
            ) {
                Text("Salvar Manutenção", color = MaterialTheme.colorScheme.onPrimary)
            }
        },
        dismissButton = {
            OutlinedButton(onClick = onDismiss) {
                Text("Cancelar")
            }
        },
        shape = RoundedCornerShape(16.dp)
    )
}
