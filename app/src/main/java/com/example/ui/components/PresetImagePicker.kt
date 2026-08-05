package com.example.ui.components

import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddAPhoto
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.example.R
import com.example.ui.theme.GoldPrimary

data class WatchPhotoPreset(
    val id: String,
    val label: String,
    val drawableRes: Int
)

val PRESET_WATCH_PHOTOS = listOf(
    WatchPhotoPreset("rolex", "Rolex Diver", R.drawable.rolex_submariner_1785946310385),
    WatchPhotoPreset("omega", "Omega Chrono", R.drawable.omega_speedmaster_1785946324723),
    WatchPhotoPreset("seiko", "Seiko Dress", R.drawable.seiko_presage_1785946338262)
)

@Composable
fun PresetImagePicker(
    selectedImageUri: String,
    onImageSelected: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier) {
        Text(
            text = "Foto do Relógio",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onSurface
        )
        Text(
            text = "Escolha um modelo visual ou insira o caminho da sua foto",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 8.dp)
        )

        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            contentPadding = PaddingValues(vertical = 4.dp)
        ) {
            items(PRESET_WATCH_PHOTOS) { preset ->
                val uri = "android.resource://com.example/drawable/${preset.drawableRes}"
                val isSelected = selectedImageUri == uri || (selectedImageUri.contains(preset.id))

                Box(
                    modifier = Modifier
                        .size(90.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .border(
                            width = if (isSelected) 3.dp else 1.dp,
                            color = if (isSelected) GoldPrimary else MaterialTheme.colorScheme.outline,
                            shape = RoundedCornerShape(12.dp)
                        )
                        .clickable { onImageSelected(uri) }
                ) {
                    Image(
                        painter = painterResource(id = preset.drawableRes),
                        contentDescription = preset.label,
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize()
                    )

                    Surface(
                        color = Color.Black.copy(alpha = 0.6f),
                        modifier = Modifier
                            .fillMaxWidth()
                            .align(Alignment.BottomCenter)
                    ) {
                        Text(
                            text = preset.label,
                            style = MaterialTheme.typography.labelSmall,
                            color = Color.White,
                            modifier = Modifier.padding(4.dp),
                            maxLines = 1
                        )
                    }

                    if (isSelected) {
                        Surface(
                            color = GoldPrimary,
                            shape = RoundedCornerShape(topStart = 0.dp, bottomEnd = 8.dp),
                            modifier = Modifier.align(Alignment.TopStart)
                        ) {
                            Icon(
                                imageVector = Icons.Default.Check,
                                contentDescription = "Selecionado",
                                tint = Color.Black,
                                modifier = Modifier
                                    .padding(2.dp)
                                    .size(16.dp)
                            )
                        }
                    }
                }
            }
        }
    }
}
