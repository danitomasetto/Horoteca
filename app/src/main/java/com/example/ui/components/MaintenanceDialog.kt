package com.example.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.example.data.model.MaintenanceLogEntity
import com.example.ui.theme.GoldPrimary

@Composable
fun MaintenanceDialog(
    watchId: Long,
    onDismiss: () -> Unit,
    onSave: (MaintenanceLogEntity) -> Unit
) {
    var serviceDate by remember { mutableStateOf("10/08/2025") }
    var serviceType by remember { mutableStateOf("Revisão Periódica & Estanqueidade") }
    var providerName by remember { mutableStateOf("Mestre Relojoeiro Autorizado") }
    var costText by remember { mutableStateOf("850.00") }
    var details by remember { mutableStateOf("Substituição de gaxetas de vedação, lubrificação e teste de pressão a 10 bar.") }
    var nextDueDate by remember { mutableStateOf("10/08/2028") }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Row {
                Icon(
                    imageVector = Icons.Default.Build,
                    contentDescription = null,
                    tint = GoldPrimary,
                    modifier = Modifier.padding(end = 8.dp)
                )
                Text(
                    text = "Registrar Manutenção",
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
                    label = { Text("Tipo de Serviço") },
                    placeholder = { Text("Ex: Revisão, Polimento, Troca de Bateria") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = providerName,
                    onValueChange = { providerName = it },
                    label = { Text("Relojoeiro / Oficina Técnica") },
                    leadingIcon = { Icon(Icons.Default.Person, contentDescription = null) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = costText,
                    onValueChange = { costText = it },
                    label = { Text("Custo do Serviço (R$)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = details,
                    onValueChange = { details = it },
                    label = { Text("Detalhes do Trabalho Realizado") },
                    maxLines = 3,
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = nextDueDate,
                    onValueChange = { nextDueDate = it },
                    label = { Text("Próxima Revisão Recomendada") },
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
                        nextServiceDueDate = nextDueDate.trim()
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
