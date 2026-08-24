import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../theme/horoteca_theme.dart';

class WatchPhotos extends StatefulWidget {
  const WatchPhotos({super.key, required this.watchId});
  final int watchId;

  @override
  State<WatchPhotos> createState() => _WatchPhotosState();
}

class _WatchPhotosState extends State<WatchPhotos> {
  final _client = Supabase.instance.client;
  late Future<List<String>> _photos = _load();
  bool _uploading = false;

  Future<List<String>> _load() async {
    final rows = await _client
        .from('watch_photos')
        .select('storage_path')
        .eq('watch_id', widget.watchId)
        .order('sort_order');
    return Future.wait(rows.map((row) => _client.storage
        .from('watch-photos')
        .createSignedUrl(row['storage_path'] as String, 3600)));
  }

  Future<void> _add(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 2400,
    );
    if (picked == null) return;
    setState(() => _uploading = true);
    try {
      final userId = _client.auth.currentUser!.id;
      final extension = picked.name.split('.').last.toLowerCase();
      final safeExtension = ['jpg', 'jpeg', 'png', 'webp'].contains(extension)
          ? extension
          : 'jpg';
      final path =
          '$userId/${widget.watchId}/${DateTime.now().millisecondsSinceEpoch}.$safeExtension';
      await _client.storage.from('watch-photos').uploadBinary(
            path,
            await picked.readAsBytes(),
            fileOptions: const FileOptions(upsert: false),
          );
      await _client.from('watch_photos').insert({
        'watch_id': widget.watchId,
        'user_id': userId,
        'storage_path': path,
        'photo_type': source == ImageSource.camera ? 'collection_photo' : 'gallery_import',
        'source_type': 'owner_photo',
        'evidence_classification': 'visual_observation',
      });
      if (mounted) setState(() => _photos = _load());
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível enviar a foto.')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.photo_library_outlined, color: HorotecaTheme.gold),
                SizedBox(width: 8),
                Text('Fotografias',
                    style: TextStyle(
                        color: HorotecaTheme.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 12),
              FutureBuilder<List<String>>(
                future: _photos,
                builder: (context, snapshot) {
                  final photos = snapshot.data ?? const <String>[];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator(color: HorotecaTheme.gold);
                  }
                  if (photos.isEmpty) {
                    return const Text('Nenhuma foto adicionada.');
                  }
                  return SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(photos[index],
                            width: 150, height: 150, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _uploading ? null : () => _add(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Câmera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _uploading ? null : () => _add(ImageSource.gallery),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Galeria'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      );
}
