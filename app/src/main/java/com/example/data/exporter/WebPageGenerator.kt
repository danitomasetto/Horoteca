package com.example.data.exporter

import com.example.data.model.WatchWithMaintenance
import java.text.NumberFormat
import java.util.Locale

object WebPageGenerator {

    fun generateHTML(
        collectionTitle: String = "Coleção Horológica Privada",
        ownerName: String = "Colecionador Privado",
        watches: List<WatchWithMaintenance>
    ): String {
        val ptBr = Locale("pt", "BR")
        val currencyFormat = NumberFormat.getCurrencyInstance(ptBr)

        val totalValue = watches.sumOf { it.watch.estimatedValue.takeIf { v -> v > 0 } ?: it.watch.purchasePrice }
        val totalSpent = watches.sumOf { it.watch.purchasePrice }
        val totalServices = watches.sumOf { it.maintenanceLogs.size }
        val totalBrands = watches.map { it.watch.brand.trim().lowercase() }.distinct().size

        val htmlBuilder = StringBuilder()

        htmlBuilder.append("""
            <!DOCTYPE html>
            <html lang="pt-BR">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>$collectionTitle</title>
                <style>
                    :root {
                        --bg-color: #0f172a;
                        --card-bg: #1e293b;
                        --card-border: #334155;
                        --accent-gold: #d4af37;
                        --accent-gold-light: #f3e5ab;
                        --text-primary: #f8fafc;
                        --text-secondary: #94a3b8;
                        --badge-bg: #2d3748;
                    }
                    * { box-sizing: border-box; margin: 0; padding: 0; }
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                        background-color: var(--bg-color);
                        color: var(--text-primary);
                        line-height: 1.6;
                        padding: 20px;
                        max-width: 1200px;
                        margin: 0 auto;
                    }
                    header {
                        text-align: center;
                        padding: 40px 20px;
                        background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
                        border-radius: 16px;
                        border: 1px solid var(--accent-gold);
                        margin-bottom: 30px;
                        box-shadow: 0 10px 25px rgba(0,0,0,0.5);
                    }
                    h1 {
                        color: var(--accent-gold);
                        font-size: 2.2rem;
                        font-weight: 700;
                        letter-spacing: 1px;
                        margin-bottom: 8px;
                        text-transform: uppercase;
                    }
                    p.subtitle {
                        color: var(--text-secondary);
                        font-size: 1.1rem;
                    }
                    .stats-container {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 16px;
                        margin-bottom: 40px;
                    }
                    .stat-card {
                        background: var(--card-bg);
                        border: 1px solid var(--card-border);
                        border-radius: 12px;
                        padding: 20px;
                        text-align: center;
                    }
                    .stat-value {
                        font-size: 1.8rem;
                        font-weight: bold;
                        color: var(--accent-gold-light);
                    }
                    .stat-label {
                        font-size: 0.85rem;
                        color: var(--text-secondary);
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        margin-top: 4px;
                    }
                    .watch-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
                        gap: 24px;
                    }
                    .watch-card {
                        background: var(--card-bg);
                        border: 1px solid var(--card-border);
                        border-radius: 16px;
                        overflow: hidden;
                        display: flex;
                        flex-direction: column;
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }
                    .watch-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 12px 30px rgba(212, 175, 55, 0.15);
                        border-color: var(--accent-gold);
                    }
                    .watch-header {
                        padding: 20px;
                        border-bottom: 1px solid var(--card-border);
                        background: rgba(255,255,255,0.02);
                    }
                    .brand-tag {
                        display: inline-block;
                        background: rgba(212, 175, 55, 0.15);
                        color: var(--accent-gold);
                        font-size: 0.8rem;
                        font-weight: 700;
                        padding: 4px 10px;
                        border-radius: 20px;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        margin-bottom: 8px;
                    }
                    .model-name {
                        font-size: 1.4rem;
                        font-weight: 700;
                        color: var(--text-primary);
                    }
                    .ref-number {
                        font-size: 0.85rem;
                        color: var(--text-secondary);
                        font-family: monospace;
                    }
                    .watch-body {
                        padding: 20px;
                        flex: 1;
                    }
                    .specs-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 16px;
                        font-size: 0.9rem;
                    }
                    .specs-table td {
                        padding: 8px 0;
                        border-bottom: 1px solid rgba(255,255,255,0.05);
                    }
                    .specs-table td.label {
                        color: var(--text-secondary);
                        width: 45%;
                    }
                    .specs-table td.value {
                        color: var(--text-primary);
                        font-weight: 600;
                        text-align: right;
                    }
                    .section-title {
                        font-size: 0.95rem;
                        color: var(--accent-gold);
                        font-weight: 700;
                        margin: 16px 0 8px 0;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        border-bottom: 1px solid var(--accent-gold);
                        padding-bottom: 4px;
                    }
                    .provenance-box {
                        background: rgba(15, 23, 42, 0.6);
                        border-radius: 8px;
                        padding: 12px;
                        font-size: 0.88rem;
                        color: #cbd5e1;
                        margin-bottom: 16px;
                        border-left: 3px solid var(--accent-gold);
                    }
                    .service-list {
                        list-style: none;
                        font-size: 0.85rem;
                    }
                    .service-item {
                        background: rgba(0,0,0,0.2);
                        padding: 10px;
                        border-radius: 8px;
                        margin-bottom: 8px;
                        border: 1px solid rgba(255,255,255,0.05);
                    }
                    .service-header {
                        display: flex;
                        justify-content: space-between;
                        font-weight: bold;
                        color: var(--accent-gold-light);
                    }
                    .service-details {
                        color: var(--text-secondary);
                        margin-top: 4px;
                    }
                    .badge {
                        display: inline-block;
                        padding: 2px 8px;
                        border-radius: 4px;
                        font-size: 0.75rem;
                        font-weight: 600;
                    }
                    .badge-success { background: #10b98122; color: #10b981; border: 1px solid #10b98155; }
                    .badge-info { background: #3b82f622; color: #60a5fa; border: 1px solid #3b82f655; }
                    footer {
                        text-align: center;
                        margin-top: 50px;
                        padding: 30px;
                        color: var(--text-secondary);
                        font-size: 0.85rem;
                        border-top: 1px solid var(--card-border);
                    }
                    @media print {
                        body { background: white; color: black; }
                        .watch-card { break-inside: avoid; border: 1px solid #ccc; background: white; color: black; }
                        .brand-tag { color: black; background: #eee; }
                        .model-name { color: black; }
                    }
                </style>
            </head>
            <body>
                <header>
                    <h1>👑 $collectionTitle</h1>
                    <p class="subtitle">Catálogo de Alta Horologia • Proprietário: $ownerName</p>
                </header>

                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-value">${watches.size}</div>
                        <div class="stat-label">Relógios na Coleção</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">$totalBrands</div>
                        <div class="stat-label">Marcas Distintas</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${currencyFormat.format(totalValue)}</div>
                        <div class="stat-label">Valor Estimado Total</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">$totalServices</div>
                        <div class="stat-label">Manutenções Registradas</div>
                    </div>
                </div>

                <div class="watch-grid">
        """.trimIndent())

        for (item in watches) {
            val w = item.watch
            val logs = item.maintenanceLogs
            val formattedPrice = currencyFormat.format(w.purchasePrice)
            val formattedEst = currencyFormat.format(if (w.estimatedValue > 0) w.estimatedValue else w.purchasePrice)

            htmlBuilder.append("""
                <div class="watch-card">
                    <div class="watch-header">
                        <span class="brand-tag">${w.brand}</span>
                        <div class="model-name">${w.model}</div>
                        ${if (w.referenceNumber.isNotEmpty()) "<div class=\"ref-number\">Ref: ${w.referenceNumber}</div>" else ""}
                    </div>
                    <div class="watch-body">
                        <table class="specs-table">
                            <tr>
                                <td class="label">Ano de Compra:</td>
                                <td class="value">${w.purchaseYear} ${if (w.purchaseDateFormatted.isNotEmpty()) "(${w.purchaseDateFormatted})" else ""}</td>
                            </tr>
                            <tr>
                                <td class="label">Valor Pago:</td>
                                <td class="value">$formattedPrice</td>
                            </tr>
                            <tr>
                                <td class="label">Valor Estimado:</td>
                                <td class="value">$formattedEst</td>
                            </tr>
                            <tr>
                                <td class="label">Movimento:</td>
                                <td class="value">${w.movementType} ${if (w.movementCaliber.isNotEmpty()) "(${w.movementCaliber})" else ""}</td>
                            </tr>
                            <tr>
                                <td class="label">Caixa / Tamanho:</td>
                                <td class="value">${w.caseMaterial} • ${w.caseDiameterMm}mm</td>
                            </tr>
                            <tr>
                                <td class="label">Pulseira:</td>
                                <td class="value">${w.strapMaterial}</td>
                            </tr>
                            <tr>
                                <td class="label">Estado de Conservação:</td>
                                <td class="value"><span class="badge badge-info">${w.condition}</span></td>
                            </tr>
                            <tr>
                                <td class="label">Caixa e Documentos:</td>
                                <td class="value">${if (w.boxAndPapers) "<span class=\"badge badge-success\">✓ Completo (Box & Papers)</span>" else "<span class=\"badge badge-info\">Apenas Relógio</span>"}</td>
                            </tr>
                        </table>

                        ${if (w.provenance.isNotEmpty()) """
                            <div class="section-title">Procedência & Vendedor</div>
                            <div class="provenance-box">🏛️ ${w.provenance}</div>
                        """.trimIndent() else ""}

                        ${if (w.notes.isNotEmpty()) """
                            <div class="section-title">Notas do Colecionador</div>
                            <div class="provenance-box">📝 ${w.notes}</div>
                        """.trimIndent() else ""}

                        <div class="section-title">Histórico de Manutenção (${logs.size})</div>
                        ${if (logs.isEmpty()) """
                            <p style="font-size:0.85rem; color: var(--text-secondary); font-style: italic;">Nenhuma revisão cadastrada para este relógio.</p>
                        """.trimIndent() else """
                            <div class="service-list">
                                ${logs.joinToString("") { log -> """
                                    <div class="service-item">
                                        <div class="service-header">
                                            <span>🛠️ ${log.serviceType}</span>
                                            <span>${log.serviceDate}</span>
                                        </div>
                                        <div class="service-details">
                                            Relojoeiro: <strong>${log.providerName}</strong> • Custo: ${currencyFormat.format(log.cost)}
                                            ${if (log.details.isNotEmpty()) "<br>Details: ${log.details}" else ""}
                                            ${if (log.nextServiceDueDate.isNotEmpty()) "<br><em>Próxima Revisão: ${log.nextServiceDueDate}</em>" else ""}
                                        </div>
                                    </div>
                                """.trimIndent() }}
                            </div>
                        """.trimIndent()}
                    </div>
                </div>
            """.trimIndent())
        }

        htmlBuilder.append("""
                </div>
                <footer>
                    <p>Horologium • Documentação Gerada pelo Aplicativo Coleção de Relógios</p>
                    <p>Relatório de propriedade autenticado digitalmente.</p>
                </footer>
            </body>
            </html>
        """.trimIndent())

        return htmlBuilder.toString()
    }
}
