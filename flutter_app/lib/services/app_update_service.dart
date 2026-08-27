import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppUpdateService {
  static const _latestRelease =
      'https://api.github.com/repos/danitomasetto/Horoteca/releases/latest';

  Future<void> check(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    if (!Platform.isAndroid) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'No iPhone, as atualizações chegam pelo TestFlight ou pela App Store.',
          ),
        ),
      );
      return;
    }
    messenger.showSnackBar(
      const SnackBar(content: Text('Verificando nova versão...')),
    );
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(_latestRelease));
      request.headers.set(HttpHeaders.acceptHeader, 'application/vnd.github+json');
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw const HttpException('Atualização ainda não publicada');
      }
      final body = await utf8.decoder.bind(response).join();
      final release = jsonDecode(body) as Map<String, dynamic>;
      final package = await PackageInfo.fromPlatform();
      final tag = (release['tag_name'] as String? ?? '').replaceFirst('v', '');
      if (!_isNewer(tag, package.version)) {
        if (context.mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Você já está na versão mais recente.')),
          );
        }
        return;
      }
      final assets = (release['assets'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();
      final asset = assets.cast<Map<String, dynamic>?>().firstWhere(
            (item) => (item?['name'] as String? ?? '').endsWith('.apk'),
            orElse: () => null,
          );
      final url = asset?['browser_download_url'] as String?;
      if (url == null) throw const FormatException('APK não encontrado');
      if (!context.mounted) return;
      final install = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Nova versão disponível'),
          content: Text('Versão $tag pronta para instalar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Depois'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Atualizar aplicativo'),
            ),
          ],
        ),
      );
      if (install != true) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Baixando atualização...')),
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/horoteca-$tag.apk');
      final download = await client.getUrl(Uri.parse(url));
      final stream = await download.close();
      if (stream.statusCode != HttpStatus.ok) {
        throw const HttpException('Falha no download');
      }
      await stream.pipe(file.openWrite());
      await OpenFilex.open(file.path, type: 'application/vnd.android.package-archive');
      client.close();
    } catch (_) {
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Não foi possível verificar a atualização agora.'),
          ),
        );
      }
    }
  }

  bool _isNewer(String candidate, String current) {
    List<int> parts(String value) => value
        .split('.')
        .map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
    final a = parts(candidate);
    final b = parts(current);
    for (var i = 0; i < 3; i++) {
      final av = i < a.length ? a[i] : 0;
      final bv = i < b.length ? b[i] : 0;
      if (av != bv) return av > bv;
    }
    return false;
  }
}
