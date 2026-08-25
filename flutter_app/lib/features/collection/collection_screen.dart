import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../theme/horoteca_theme.dart';
import '../../services/app_update_service.dart';
import 'watch.dart';
import 'watch_repository.dart';
import 'watch_photos.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final _repository = WatchRepository();
  final _search = TextEditingController();
  late Future<List<Watch>> _watches = _repository.list();
  String? _brand;

  void _reload() => setState(() => _watches = _repository.list());

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coleção de Relógios',
                style: TextStyle(
                    color: HorotecaTheme.gold, fontWeight: FontWeight.w800)),
            Text('CATÁLOGO & HISTÓRICO HOROLÓGICO',
                style: TextStyle(
                    color: HorotecaTheme.muted,
                    fontSize: 10,
                    letterSpacing: 1.1)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'História das marcas',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BrandsScreen()),
            ),
            icon: const Icon(Icons.menu_book_outlined,
                color: HorotecaTheme.gold),
          ),
          IconButton(
              tooltip: 'Atualizar coleção',
              onPressed: _reload,
              icon: const Icon(Icons.sync, color: HorotecaTheme.gold)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: HorotecaTheme.gold),
            onSelected: (value) {
              if (value == 'logout') {
                Supabase.instance.client.auth.signOut();
              } else if (value == 'update') {
                AppUpdateService().check(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'update',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.system_update_alt),
                  title: Text('Atualizar aplicativo'),
                ),
              ),
              PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastros são revisados antes de entrar na Horoteca.'),
          ),
        ),
        backgroundColor: HorotecaTheme.gold,
        foregroundColor: HorotecaTheme.navy,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Watch>>(
        future: _watches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: HorotecaTheme.gold));
          }
          if (snapshot.hasError) {
            return _Message(
              icon: Icons.cloud_off_outlined,
              title: 'Não foi possível carregar a coleção',
              detail: 'Verifique sua conexão e tente novamente.',
              action: _reload,
            );
          }
          final watches = snapshot.data ?? const <Watch>[];
          final brands = watches.map((e) => e.displayBrand).toSet().toList()
            ..sort();
          final query = _search.text.trim().toLowerCase();
          final filtered = watches.where((watch) {
            final matchesBrand =
                _brand == null || watch.displayBrand == _brand;
            final matchesQuery = query.isEmpty ||
                '${watch.displayBrand} ${watch.displayModel} ${watch.referenceNumber ?? ''} ${watch.horotecaCode ?? ''}'
                    .toLowerCase()
                    .contains(query);
            return matchesBrand && matchesQuery;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            color: HorotecaTheme.gold,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _Summary(watches: watches),
                const SizedBox(height: 14),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Buscar por marca, modelo ou referência...',
                    prefixIcon:
                        Icon(Icons.search, color: HorotecaTheme.muted),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        selected: _brand == null,
                        onTap: () => setState(() => _brand = null),
                      ),
                      for (final brand in brands)
                        _FilterChip(
                          label: brand,
                          selected: _brand == brand,
                          onTap: () => setState(() => _brand = brand),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (watches.isEmpty)
                  _Message(
                    icon: Icons.watch_outlined,
                    title: 'Sua Horoteca está vazia',
                    detail: 'Os relógios cadastrados aparecerão aqui.',
                    action: _reload,
                  )
                else if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Nenhum relógio encontrado.')),
                  )
                else
                  ...filtered.map((watch) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _WatchCard(
                          watch: watch,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WatchDetailScreen(watch: watch),
                            ),
                          ),
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.watches});
  final List<Watch> watches;

  @override
  Widget build(BuildContext context) {
    final value = watches.fold<double>(
        0, (sum, watch) => sum + (watch.estimatedValue ?? watch.purchasePrice ?? 0));
    final services =
        watches.fold<int>(0, (sum, watch) => sum + watch.maintenanceCount);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: HorotecaTheme.navySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HorotecaTheme.gold.withValues(alpha: .38)),
      ),
      child: Row(
        children: [
          _Metric(icon: Icons.watch, value: '${watches.length}', label: 'Relógios'),
          _Metric(icon: Icons.payments_outlined, value: _money(value), label: 'Valor da Coleção'),
          _Metric(icon: Icons.build_outlined, value: '$services', label: 'Manutenções'),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Icon(icon, color: HorotecaTheme.gold, size: 22),
            const SizedBox(height: 6),
            FittedBox(
              child: Text(value,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ),
            Text(label,
                style: const TextStyle(color: HorotecaTheme.muted, fontSize: 10)),
          ],
        ),
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          selectedColor: HorotecaTheme.gold,
          labelStyle: TextStyle(
              color: selected ? HorotecaTheme.navy : HorotecaTheme.text,
              fontWeight: FontWeight.w700),
          side: const BorderSide(color: HorotecaTheme.gold),
        ),
      );
}

class _WatchCard extends StatelessWidget {
  const _WatchCard({required this.watch, required this.onTap});
  final Watch watch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _WatchImage(watch: watch, height: 170),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: const BoxDecoration(
                        color: HorotecaTheme.navySurface,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                      ),
                      child: Text(watch.displayBrand.toUpperCase(),
                          style: const TextStyle(
                              color: HorotecaTheme.gold,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .8)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(watch.displayModel,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    if (watch.referenceNumber?.isNotEmpty == true)
                      Text('Ref. ${watch.referenceNumber}',
                          style: const TextStyle(color: HorotecaTheme.muted)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            [watch.movementType, watch.dialColor]
                                .whereType<String>()
                                .where((e) => e.isNotEmpty)
                                .join(' • '),
                            style: const TextStyle(color: HorotecaTheme.muted),
                          ),
                        ),
                        if (watch.maintenanceCount > 0) ...[
                          const Icon(Icons.build_outlined,
                              size: 16, color: HorotecaTheme.gold),
                          const SizedBox(width: 4),
                          Text('${watch.maintenanceCount}',
                              style: const TextStyle(color: HorotecaTheme.gold)),
                        ],
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: HorotecaTheme.muted),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class WatchDetailScreen extends StatelessWidget {
  const WatchDetailScreen({super.key, required this.watch});
  final Watch watch;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(watch.displayBrand,
              style: const TextStyle(
                  color: HorotecaTheme.gold, fontWeight: FontWeight.w800)),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                _WatchImage(watch: watch, height: 270),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: .88)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Text(watch.displayModel,
                          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                      if (watch.referenceNumber?.isNotEmpty == true)
                        Text('Referência: ${watch.referenceNumber}',
                            style: const TextStyle(color: HorotecaTheme.goldSoft)),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailCard(
                    icon: Icons.fingerprint,
                    title: 'Identificação da Peça',
                    rows: [
                      ('Código Horoteca', _or(watch.horotecaCode)),
                      ('Marca', watch.displayBrand),
                      ('Modelo', watch.displayModel),
                      ('Referência', _or(watch.referenceNumber)),
                      ('Número de série', _or(watch.serialNumber)),
                      ('Código da caixa', _or(watch.caseCode)),
                      ('Código do mostrador', _or(watch.dialCode)),
                      ('Ano ou período', _watchPeriod(watch)),
                      ('País de fabricação', _or(watch.manufactureCountry)),
                      ('Estado de conservação', _or(watch.condition)),
                      ('Funcionamento', _or(watch.functionStatus)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _DetailCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Aquisição & Procedência',
                    rows: [
                      ('Pedido de origem', _or(watch.acquisition?.orderNumber ?? watch.orderNumber)),
                      ('Item do pedido', _itemNumber(watch)),
                      ('Posição visual no lote', _or(watch.acquisition?.visualPosition)),
                      ('Marketplace', _or(watch.acquisition?.marketplace ?? watch.marketplace)),
                      ('Item do anúncio', _or(watch.acquisition?.marketplaceItemId ?? watch.marketplaceItemId)),
                      ('Vendedor', _or(watch.acquisition?.sellerName ?? watch.sellerName)),
                      ('Data da compra', _date(watch.acquisition?.purchaseDate ?? watch.purchaseDate)),
                      ('Data do pagamento', _date(watch.acquisition?.purchasePaymentDate)),
                      ('Pagamento dos impostos', _date(watch.acquisition?.taxesPaymentDate)),
                      ('Data de envio', _date(watch.acquisition?.shippedDate)),
                      ('Entrega prevista', _date(watch.acquisition?.estimatedDeliveryDate)),
                      ('Data de recebimento', _date(watch.acquisition?.receivedDate)),
                      ('Transportadora', _or(watch.acquisition?.carrier)),
                      ('Rastreamento', _or(watch.acquisition?.trackingNumber)),
                      ('Forma de pagamento', _or(watch.acquisition?.paymentMethod ?? watch.paymentMethod)),
                      ('Valor original da peça', _originalMoney(watch)),
                      ('Custo total atribuído', _money(watch.totalInvested)),
                      ('Valor estimado', _optionalMoney(watch.estimatedValue)),
                      ('Título do anúncio', _or(watch.acquisition?.listingTitle)),
                      ('Categoria do anúncio', _or(watch.acquisition?.listingCategory)),
                      ('Condição declarada', _list([
                        watch.acquisition?.sellerConditionLabel,
                        watch.acquisition?.sellerConditionDescription,
                      ])),
                      ('Quantidade anunciada', _orNumber(watch.acquisition?.listingQuantity)),
                      ('Idioma do anúncio', _or(watch.acquisition?.listingLanguage)),
                      ('Dados específicos do anúncio', _specifics(watch.acquisition?.listingSpecifics)),
                      ('Documento de origem', _or(watch.acquisition?.sourceDocumentName)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FutureBuilder<List<ExpenseSummary>>(
                    future: WatchRepository().expenses(watch.id),
                    builder: (context, snapshot) {
                      final expenses = snapshot.data ?? const <ExpenseSummary>[];
                      return _DetailCard(
                        icon: Icons.payments_outlined,
                        title: 'Composição dos Custos',
                        rows: expenses.isEmpty
                            ? const [('Custos', 'Nenhuma despesa estruturada registrada')]
                            : expenses.map((expense) => (
                                _expenseCategory(expense.category),
                                '${_optionalMoney(expense.amountBrl)}${expense.allocationMethod == null ? '' : ' • ${expense.allocationMethod}'}',
                              )).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _DetailCard(
                    icon: Icons.settings_outlined,
                    title: 'Movimento & Funcionamento',
                    rows: [
                      ('Tipo de movimento', _or(watch.movementType ?? watch.caliberProfile?.movementType)),
                      ('Calibre', _or(watch.caliber ?? watch.caliberProfile?.code)),
                      ('Descrição do movimento', _or(watch.movementDescription ?? watch.caliberProfile?.technicalDescription)),
                      ('Rubis', _orNumber(watch.jewels ?? watch.caliberProfile?.jewels)),
                      ('Complicações', _list(watch.complications.isNotEmpty ? watch.complications : watch.caliberProfile?.complications)),
                      ('Frequência', _frequency(watch.caliberProfile?.frequencyVph)),
                      ('Reserva de marcha', _hours(watch.caliberProfile?.powerReserveHours)),
                      ('Diâmetro do movimento', _mm(watch.caliberProfile?.movementDiameterMm)),
                      ('Espessura do movimento', _mm(watch.caliberProfile?.movementThicknessMm)),
                      ('Corda manual', _yesNoUnknown(watch.caliberProfile?.hasManualWinding)),
                      ('Parada de segundos', _yesNoUnknown(watch.caliberProfile?.hasHackingSeconds)),
                      ('Correções rápidas', _list(watch.caliberProfile?.quicksetFeatures)),
                      ('Proteção contra choques', _or(watch.caliberProfile?.shockProtection)),
                      ('Escape', _or(watch.caliberProfile?.escapementType)),
                      ('Sistema de corda', _or(watch.caliberProfile?.windingDescription)),
                      ('Precisão', _accuracy(watch)),
                      ('Resistência à água', _or(watch.waterResistance)),
                      ('Defeitos conhecidos', _or(watch.knownDefects)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _DetailCard(
                    icon: Icons.watch_outlined,
                    title: 'Caixa, Mostrador & Pulseira',
                    rows: [
                      ('Diâmetro', _mm(watch.diameterMm)),
                      ('Espessura', _mm(watch.caseThicknessMm)),
                      ('Lug-to-lug', _mm(watch.lugToLugMm)),
                      ('Entre-alças', _mm(watch.lugWidthMm)),
                      ('Material da caixa', _or(watch.caseMaterial)),
                      ('Tipo de relógio', _or(watch.watchType)),
                      ('Exibição', _or(watch.displayType)),
                      ('Público / departamento', _or(watch.intendedAudience)),
                      ('Acabamento / cor / formato', _list([watch.caseFinish, watch.caseColor, watch.caseShape])),
                      ('Luneta', _list([watch.bezelType, watch.bezelMaterial, watch.bezelColor])),
                      ('Mostrador', _or(watch.dialDescription ?? watch.dialColor)),
                      ('Inscrições do mostrador', _or(watch.dialInscriptions)),
                      ('Índices', _or(watch.indicesDescription)),
                      ('Ponteiros', _or(watch.handsDescription)),
                      ('Cristal', _list([watch.crystalMaterial, watch.crystalCondition])),
                      ('Coroa', _or(watch.crownDescription)),
                      ('Fundo da caixa', _or(watch.casebackDescription)),
                      ('Inscrições do fundo', _or(watch.casebackInscriptions)),
                      ('Pulseira', _or(watch.strapDescription ?? watch.strapMaterial)),
                      ('Cor da pulseira', _or(watch.strapColor)),
                      ('Fecho', _or(watch.claspType)),
                      ('Originalidade da pulseira', _or(watch.strapOriginality)),
                      ('Originalidade do mostrador', _or(watch.dialOriginality)),
                      ('Originalidade geral', _or(watch.componentOriginality)),
                      ('Caixa original incluída', _yesNoUnknown(watch.hasOriginalBox)),
                      ('Documentos originais incluídos', _yesNoUnknown(watch.hasOriginalPapers)),
                      ('Acessórios incluídos', _list(watch.includedAccessories)),
                      ('Personalizado', _yesNoUnknown(watch.isCustomized)),
                      ('Descrição da personalização', _or(watch.customizationDescription)),
                      ('Outras características', _list(watch.features)),
                    ],
                  ),
                  if (watch.modelProfile != null) ...[
                    const SizedBox(height: 14),
                    _DetailCard(
                      icon: Icons.auto_stories_outlined,
                      title: 'História do Modelo',
                      rows: [
                        ('Linha', _or(watch.modelProfile!.lineName)),
                        ('Lançamento', _orNumber(watch.modelProfile!.launchYear)),
                        ('Período de produção', _period(watch.modelProfile!.productionStartYear, watch.modelProfile!.productionEndYear)),
                        ('Designer / autor', _or(watch.modelProfile!.designer)),
                        ('Contexto de criação', _or(watch.modelProfile!.creationContext)),
                        ('História', _or(watch.modelProfile!.history)),
                        ('Características marcantes', _or(watch.modelProfile!.notableFeatures)),
                        ('Importância histórica', _or(watch.modelProfile!.historicalImportance)),
                        ('Pesquisa revisada em', _date(watch.modelProfile!.reviewedAt)),
                      ],
                    ),
                  ],
                  if (watch.caliberProfile != null) ...[
                    const SizedBox(height: 14),
                    _DetailCard(
                      icon: Icons.precision_manufacturing_outlined,
                      title: 'História do Calibre',
                      rows: [
                        ('Fabricante', _or(watch.caliberProfile!.manufacturer)),
                        ('Calibre', _or(watch.caliberProfile!.code)),
                        ('Período de produção', _period(watch.caliberProfile!.productionStartYear, watch.caliberProfile!.productionEndYear)),
                        ('História', _or(watch.caliberProfile!.history)),
                        ('Importância histórica', _or(watch.caliberProfile!.historicalImportance)),
                        ('Pesquisa revisada em', _date(watch.caliberProfile!.reviewedAt)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  _DetailCard(
                    icon: Icons.fact_check_outlined,
                    title: 'Fontes & Grau de Evidência',
                    rows: watch.sources.isEmpty
                        ? const [('Fontes', 'Nenhuma fonte estruturada registrada')]
                        : watch.sources.map((source) => (
                            source.name?.isNotEmpty == true ? source.name! : _sourceType(source.type),
                            '${_evidence(source.classification)}${source.confidencePercent == null ? '' : ' • ${source.confidencePercent}%'}${source.excerpt?.isNotEmpty == true ? '\n${source.excerpt}' : ''}',
                          )).toList(),
                  ),
                  const SizedBox(height: 14),
                  _DetailCard(
                    icon: Icons.rule_outlined,
                    title: 'Alegações & Pendências de Verificação',
                    rows: watch.claims.isEmpty
                        ? const [('Alegações', 'Nenhuma alegação pendente registrada')]
                        : watch.claims.map((claim) => (
                            claim.fieldName,
                            '${claim.assertedValue}${claim.normalizedValue?.isNotEmpty == true ? '\nNormalizado: ${claim.normalizedValue}' : ''}\n${_evidence(claim.classification)} • ${_claimStatus(claim.status)}${claim.confidencePercent == null ? '' : ' • ${claim.confidencePercent}%'}',
                          )).toList(),
                  ),
                  if (watch.notes?.isNotEmpty == true) ...[
                    const SizedBox(height: 14),
                    _DetailCard(
                      icon: Icons.notes_outlined,
                      title: 'Observações do Colecionador',
                      rows: [('Notas', watch.notes!)],
                    ),
                  ],
                  const SizedBox(height: 14),
                  FutureBuilder<List<WatchHistory>>(
                    future: WatchRepository().history(watch.id),
                    builder: (context, snapshot) {
                      final history = snapshot.data ?? const <WatchHistory>[];
                      return _DetailCard(
                        icon: Icons.history,
                        title: 'Linha do Tempo & Manutenções',
                        rows: history.isEmpty
                            ? const [('Histórico', 'Nenhum lançamento registrado')]
                            : history
                                .map((item) => (
                                      item.description,
                                      '${_date(item.date)} • ${item.type}${item.provider?.isNotEmpty == true ? ' • ${item.provider}' : ''}${item.amountBrl == null ? '' : ' • ${_money(item.amountBrl!)}'}',
                                    ))
                                .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  WatchPhotos(watchId: watch.id),
                ],
              ),
            ),
          ],
        ),
      );
}

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('História das Marcas',
              style: TextStyle(
                  color: HorotecaTheme.gold, fontWeight: FontWeight.w800)),
        ),
        body: FutureBuilder<List<BrandProfile>>(
          future: WatchRepository().brands(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: HorotecaTheme.gold));
            }
            final brands = snapshot.data ?? const <BrandProfile>[];
            if (brands.isEmpty) {
              return const Center(child: Text('Nenhuma marca cadastrada.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.history_edu_outlined,
                        color: HorotecaTheme.gold),
                    title: Text(brand.name,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text([
                      brand.country,
                      brand.foundedYear?.toString(),
                    ].whereType<String>().join(' • ')),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    children: [
                      if (brand.founder?.isNotEmpty == true)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Fundador: ${brand.founder}'),
                        ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(brand.history?.isNotEmpty == true
                            ? brand.history!
                            : 'História ainda não cadastrada.'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.icon, required this.title, required this.rows});
  final IconData icon;
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, color: HorotecaTheme.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: HorotecaTheme.gold,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                ),
              ]),
              const SizedBox(height: 14),
              for (final row in rows) ...[
                Text(row.$1.toUpperCase(),
                    style: const TextStyle(
                        color: HorotecaTheme.muted,
                        fontSize: 10,
                        letterSpacing: .8)),
                const SizedBox(height: 2),
                Text(row.$2),
                if (row != rows.last)
                  const Divider(color: HorotecaTheme.navySoft, height: 20),
              ],
            ],
          ),
        ),
      );
}

class _WatchImage extends StatelessWidget {
  const _WatchImage({required this.watch, required this.height});
  final Watch watch;
  final double height;

  @override
  Widget build(BuildContext context) {
    final uri = watch.imageUri;
    if (uri != null && uri.startsWith('http')) {
      return Image.network(uri,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder());
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: double.infinity,
        height: height,
        color: HorotecaTheme.navySoft,
        child: const Icon(Icons.watch_outlined,
            size: 72, color: HorotecaTheme.gold),
      );
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
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: HorotecaTheme.gold),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(detail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: HorotecaTheme.muted)),
              const SizedBox(height: 18),
              OutlinedButton(onPressed: action, child: const Text('Tentar novamente')),
            ],
          ),
        ),
      );
}

String _money(double value) {
  final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
  return 'R\$ $formatted';
}

String _originalMoney(Watch watch) {
  final value = watch.purchaseAmountOriginal;
  if (value == null && watch.purchasePrice == null) return 'Não informado';
  if (value == null) return _money(watch.purchasePrice!);
  return '${watch.purchaseCurrency ?? ''} ${value.toStringAsFixed(2).replaceAll('.', ',')}'.trim();
}

String _optionalMoney(double? value) =>
    value == null ? 'Não informado' : _money(value);

String _or(String? value) =>
    value == null || value.trim().isEmpty ? 'Não informado' : value.trim();

String _orNumber(num? value) => value?.toString() ?? 'Não informado';

String _date(DateTime? value) => value == null
    ? 'Não informado'
    : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

String _mm(double? value) =>
    value == null ? 'Não informado' : '${value.toStringAsFixed(2).replaceAll('.', ',')} mm';

String _list(Iterable<Object?>? values) {
  final present = values
          ?.where((value) => value != null && value.toString().trim().isNotEmpty)
          .map((value) => value.toString().trim())
          .toList() ??
      const <String>[];
  return present.isEmpty ? 'Não informado' : present.join(' • ');
}

String _period(int? start, int? end) {
  if (start == null && end == null) return 'Não informado';
  if (start != null && end != null) return '$start–$end';
  return start?.toString() ?? 'Até $end';
}

String _watchPeriod(Watch watch) {
  if (watch.year != null) {
    return '${watch.year}${watch.yearIsEstimated ? ' (estimado)' : ''}';
  }
  return _period(watch.periodStartYear, watch.periodEndYear);
}

String _accuracy(Watch watch) {
  final parts = <String>[];
  if (watch.accuracySecondsPerDay != null) {
    parts.add('${watch.accuracySecondsPerDay!.toStringAsFixed(2).replaceAll('.', ',')} s/dia');
  }
  if (watch.accuracyNotes?.trim().isNotEmpty == true) {
    parts.add(watch.accuracyNotes!.trim());
  }
  return _list(parts);
}

String _yesNoUnknown(bool? value) => value == null
    ? 'Não informado'
    : value
        ? 'Sim'
        : 'Não';

String _frequency(int? value) => value == null ? 'Não informado' : '$value alternâncias/hora';

String _hours(double? value) => value == null
    ? 'Não informado'
    : '${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2).replaceAll('.', ',')} horas';

String _specifics(Map<String, dynamic>? values) {
  if (values == null || values.isEmpty) return 'Não informado';
  final entries = values.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return entries.map((entry) => '${entry.key}: ${entry.value}').join('\n');
}

String _itemNumber(Watch watch) {
  final value = watch.acquisition?.itemSequence ?? watch.orderItemNumber;
  return value?.toString().padLeft(2, '0') ?? 'Não informado';
}

String _expenseCategory(String value) => const {
      'product': 'Relógio',
      'freight': 'Frete',
      'tax': 'Impostos',
      'fee': 'Taxas',
      'carrier': 'Transportadora',
      'maintenance': 'Manutenção',
      'parts': 'Peças',
      'strap': 'Pulseira',
      'other': 'Outros gastos',
    }[value] ?? value;

String _sourceType(String? value) => const {
      'document': 'Documento',
      'listing': 'Anúncio',
      'photo': 'Fotografia',
      'research': 'Pesquisa',
    }[value] ?? _or(value);

String _evidence(String value) => const {
      'document_confirmed': 'Confirmado por documento',
      'seller_statement': 'Declaração do vendedor',
      'visual_observation': 'Observação visual',
      'researched': 'Pesquisado',
      'estimated': 'Estimado',
      'missing': 'Ausente',
      'inconsistent': 'Inconsistente',
    }[value] ?? value;

String _claimStatus(String value) => const {
      'pending': 'Pendente',
      'accepted': 'Aceita',
      'rejected': 'Rejeitada',
      'superseded': 'Substituída',
    }[value] ?? value;
