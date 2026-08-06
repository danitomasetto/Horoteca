import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'watch.dart';
import 'watch_repository.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final _repository = WatchRepository();
  late Future<List<Watch>> _watches = _repository.list();

  void _reload() => setState(() => _watches = _repository.list());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Horoteca', style: TextStyle(fontWeight: FontWeight.w700)),
            Text('Minha coleção', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
          IconButton(
            tooltip: 'Sair',
            onPressed: () => Supabase.instance.client.auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Watch>>(
        future: _watches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _Message(
              icon: Icons.cloud_off_outlined,
              title: 'Não foi possível carregar a coleção',
              detail: snapshot.error.toString(),
              action: _reload,
            );
          }
          final watches = snapshot.data ?? const [];
          if (watches.isEmpty) {
            return _Message(
              icon: Icons.watch_outlined,
              title: 'Sua Horoteca está vazia',
              detail: 'Os relógios cadastrados aparecerão aqui.',
              action: _reload,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              itemCount: watches.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _WatchCard(watch: watches[index]),
            ),
          );
        },
      ),
    );
  }
}

class _WatchCard extends StatelessWidget {
  const _WatchCard({required this.watch});
  final Watch watch;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.watch_outlined, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(watch.brand.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          )),
                  const SizedBox(height: 3),
                  Text(watch.model,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                  if (watch.referenceNumber?.isNotEmpty == true)
                    Text('Ref. ${watch.referenceNumber}'),
                  if (watch.movementType?.isNotEmpty == true)
                    Text(watch.movementType!,
                        style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.detail,
    required this.action,
  });
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(detail, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            OutlinedButton(
                onPressed: action, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}
