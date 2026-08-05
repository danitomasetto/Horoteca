package com.example.data.model

data class Milestone(
    val year: String,
    val title: String,
    val description: String
)

data class BrandHistory(
    val brandName: String,
    val country: String,
    val foundedYear: Int,
    val founder: String,
    val summary: String,
    val fullHistory: String,
    val iconName: String = "watch",
    val iconicModels: List<String>,
    val keyInnovations: List<String>,
    val milestones: List<Milestone>
)

object BrandHistoryRepository {
    val allBrands = listOf(
        BrandHistory(
            brandName = "Rolex",
            country = "Suiça (Genebra)",
            foundedYear = 1905,
            founder = "Hans Wilsdorf",
            summary = "Pioneira absoluta em relógios de pulso impermeáveis, rotor automático e símbolo máximo de prestígio horológico mundial.",
            fullHistory = """
                Fundada originalmente em Londres em 1905 por Hans Wilsdorf e seu cunhado Alfred Davis como 'Wilsdorf & Davis', a empresa mudou seu nome para Rolex em 1908 e transferiu sua sede para Genebra, Suiça, em 1919.
                
                Hans Wilsdorf tinha a visão visionária de criar relógios de pulso que fossem não apenas elegantes, mas incrivelmente precisos e robustos. Em 1926, a Rolex revolucionou a indústria ao lançar o **Rolex Oyster**, o primeiro relógio de pulso verdadeiramente impermeável e hermético do mundo, graças ao seu case selado por rosca.
                
                Em 1931, a marca patenteou o primeiro mecanismo de corda automática do mundo com um rotor livre de 360º — o nascimento do lendário mecanismo **Perpetual**, fundamento de quase todos os relógios automáticos modernos.
                
                Nos anos 1950, a Rolex desenvolveu relógios ferramenta lendários para exploração humana: o Submariner para mergulho profundo, o GMT-Master para aviação intercontinental e o Explorer para o topo do Everest.
            """.trimIndent(),
            iconicModels = listOf("Submariner", "GMT-Master II", "Daytona", "Datejust", "Day-Date", "Explorer", "Oyster Perpetual"),
            keyInnovations = listOf(
                "Caixa Oyster Impermeável (1926)",
                "Rotor Automático Perpetual (1931)",
                "Calendário com Mudança Instantânea Datejust (1945)",
                "Lente de Aumento Cyclops (1953)",
                "Liga de Ouro Everose e Cerâmica Cerachrom"
            ),
            milestones = listOf(
                Milestone("1905", "Fundação", "Hans Wilsdorf estabelece a empresa de montagem horológica."),
                Milestone("1926", "Lançamento do Oyster", "Mercedes Gleitze cruza o Canal da Mancha usando um Rolex Oyster que permanece 100% seco."),
                Milestone("1931", "Rotor Perpetual", "Patente do mecanismo automático com rotor de 360 graus."),
                Milestone("1953", "Submariner & Everest", "Lançamento do Submariner (100m) e expedição de Hillary ao Everest."),
                Milestone("1963", "Cosmograph Daytona", "Relógio desenhado para pilotos de corrida profissionais de alta velocidade.")
            )
        ),

        BrandHistory(
            brandName = "Omega",
            country = "Suiça (Bienne)",
            foundedYear = 1848,
            founder = "Louis Brandt",
            summary = "A criadora do lendário Speedmaster Moonwatch, pioneira no espaço, cronometrista oficial das Olimpíadas e inovadora do Escapamento Co-Axial.",
            fullHistory = """
                Criada por Louis Brandt em La Chaux-de-Fonds em 1848, a marca adotou o nome OMEGA em 1894 após a criação do revolucionário calibre 'Omega' 19-linhas, tão bem construído que virou o próprio nome da empresa.
                
                A trajetória da Omega está gravada na história da exploração humana: em 1965, após testes rigorosos de vibração, temperatura e choque promovidos pela NASA, o **Omega Speedmaster Professional** foi qualificado como o único relógio aprovado para todas as missões espaciais tripuladas. Em 20 de julho de 1969, Buzz Aldrin pisou na Lua usando seu Speedmaster, consagrando o modelo como o 'Moonwatch'.
                
                Na relojoaria moderna, a Omega revolucionou o escapamento mecânico ao adotar o **Escapamento Co-Axial** inventado pelo mestre George Daniels, reduzindo drasticamente o atrito interno e garantindo a certificação Master Chronometer contra campos magnéticos de até 15.000 Gauss.
            """.trimIndent(),
            iconicModels = listOf("Speedmaster Professional Moonwatch", "Seamaster Diver 300M", "Constellation", "De Ville", "Aqua Terra", "Railmaster"),
            keyInnovations = listOf(
                "Mecanismo Calibre 19-Linhas Omega (1894)",
                "Aprovação da NASA para voos espaciais tripulados (1965)",
                "Escapamento Co-Axial por George Daniels (1999)",
                "Certificação Master Chronometer antimagnética a 15.000 Gauss (2015)"
            ),
            milestones = listOf(
                Milestone("1848", "Fundação em La Chaux-de-Fonds", "Louis Brandt abre seu primeiro oficina de montagem de bolso."),
                Milestone("1932", "Jogos Olímpicos de Los Angeles", "Primeira vez que uma única marca cronometra todas as provas olímpicas."),
                Milestone("1948", "Lançamento do Seamaster", "Nascimento da linha de relógios marinhos mais famosa do mundo."),
                Milestone("1969", "Chegada à Lua", "O Speedmaster torna-se o primeiro relógio usado na superfície lunar."),
                Milestone("1995", "Relógio Oficial de James Bond", "Pierce Brosnan estreia com o Seamaster Diver 300M Blue Dial em GoldenEye.")
            )
        ),

        BrandHistory(
            brandName = "Cartier",
            country = "França / Suiça (Paris/La Chaux-de-Fonds)",
            foundedYear = 1847,
            founder = "Louis-François Cartier",
            summary = "Denominada 'O Relojoeiro dos Reis e o Rei dos Relojoeiros', criadora do primeiro relógio de pulso masculino moderno para o aviador brasileiro Alberto Santos-Dumont.",
            fullHistory = """
                Fundada em Paris em 1847 por Louis-François Cartier, a Maison tornou-se mundialmente famosa pela sofisticação estética e proporção geométrica impecável.
                
                Em 1904, o aviador brasileiro **Alberto Santos-Dumont** reclamou ao seu amigo Louis Cartier sobre a dificuldade de consultar relógios de bolso enquanto pilotava suas aeronaves dirigíveis. Cartier atendeu ao pedido criando o **Santos de Cartier**, o primeiro relógio de pulso masculino moderno desenhado especificamente para ser usado no pulso com pulseira de couro.
                
                Em 1917, inspirando-se nas esteiras dos tanques Renault da Primeira Guerra Mundial, Louis Cartier desenhou o lendário **Cartier Tank**, cujas linhas retas e numerais romanos tornaram-se um ícone imortal de design e elegância atemporal.
            """.trimIndent(),
            iconicModels = listOf("Santos de Cartier", "Tank Solo / Must", "Ballon Bleu", "Pasha de Cartier", "Panthère", "Tortue"),
            keyInnovations = listOf(
                "Primeiro relógio de pulso aviador masculino (Santos, 1904)",
                "Design geométrico Art Déco com numerais romanos característicos",
                "Sistema de troca rápida de pulseira SmartLink & QuickSwitch"
            ),
            milestones = listOf(
                Milestone("1847", "Fundação em Paris", "Louis-François Cartier assume o ateliê de seu mestre."),
                Milestone("1904", "O Relógio de Santos-Dumont", "Criação do primeiro relógio de pulso aviador para o inventor brasileiro."),
                Milestone("1917", "Criação do Cartier Tank", "Design inspirado na geometria dos tanques da 1ª Guerra Mundial."),
                Milestone("1936", "Tank Cintrée e Basculante", "Expansão da alta relojoaria com caixas curvadas e giratórias.")
            )
        ),

        BrandHistory(
            brandName = "Seiko",
            country = "Japão (Tóquio)",
            foundedYear = 1881,
            founder = "Kintaro Hattori",
            summary = "Pioneira da alta relojoaria japonesa, inventora do relógio de quartzo em 1969, dos movimentos Spring Drive e mestre do acabamento Zaratsu.",
            fullHistory = """
                Em 1881, com apenas 21 anos, Kintaro Hattori abriu uma loja de venda e reparo de relógios em Ginza, Tóquio. Em 1892 ele criou a fábrica Seikosha ('Casa de Excelência Meticulosa'), que viria a dar origem à marca SEIKO em 1924.
                
                A Seiko construiu sua reputação com manufatura 100% verticalizada. Em 1913 produziu o **Laurel**, primeiro relógio de pulso fabricado no Japão. Em 25 de dezembro de 1969, a Seiko abalou a indústria suíça ao lançar o **Seiko Quartz Astron 35SQ**, o primeiro relógio de quartzo comercial do mundo, com precisão de ±5 segundos por mês.
                
                Mais tarde, a Seiko desenvolveu o exclusivo mecanismo **Spring Drive**, que combina a energia motriz de uma mola real com a precisão de um regulador de quartzo e movimento contínuo tri-synchro sem sobressaltos do ponteiro dos segundos.
            """.trimIndent(),
            iconicModels = listOf("Presage", "Prospex (Diver/Alpinist)", "Seiko 5 Sports", "King Seiko", "Astron GPS Solar", "SKX007"),
            keyInnovations = listOf(
                "Primeiro relógio de pulso japonês Laurel (1913)",
                "Primeiro relógio de quartzo comercial Astron (1969)",
                "Mecanismo híbrido Spring Drive (1999)",
                "Polimento de caixa espelhado Zaratsu"
            ),
            milestones = listOf(
                Milestone("1881", "Fundação em Ginza", "Kintaro Hattori abre a oficina original em Tóquio."),
                Milestone("1913", "Seikosha Laurel", "Primeiro relógio de pulso completo produzido no Japão."),
                Milestone("1969", "Astron 35SQ", "Lançamento do primeiro relógio de quartzo do mundo."),
                Milestone("1999", "Lançamento do Spring Drive", "Revolução mecânico-eletrônica com ponteiro de varredura fluida contínua.")
            )
        ),

        BrandHistory(
            brandName = "Patek Philippe",
            country = "Suiça (Genebra)",
            foundedYear = 1839,
            founder = "Antoni Patek & Adrien Philippe",
            summary = "Considerada a cúspide absoluta da Alta Relojoaria tradicional suíça, famosa por complicações virtuosas e pelo lema 'You never actually own a Patek Philippe...'",
            fullHistory = """
                Fundada em Genebra em 1839 pelo oficial polonês Antoni Patek e posteriormente associado ao mestre inventor francês Adrien Philippe (inventor do sistema de corda e ajuste de hora pela coroa sem necessidade de chave).
                
                A Patek Philippe é sinônimo de excelência horológica inigualável, mantendo a independência familiar sob a direção da família Stern desde 1932. Em 1932 lançou o modelo **Calatrava**, referência máxima de relógio social clássico. Em 1976, em parceria com o designer Gérald Genta, apresentou o **Nautilus**, tornando-se um marco divisor nos relógios esportivos de alto luxo em aço inoxidável.
            """.trimIndent(),
            iconicModels = listOf("Nautilus", "Calatrava", "Aquanaut", "Complications / Grand Complications", "World Time"),
            keyInnovations = listOf(
                "Mecanismo de corda e acerto por coroa sem chave (1845)",
                "Patente do Calendário Perpétuo para relógio de pulso (1925)",
                "Selo Patek Philippe Seal de precisão e acabamento impecável"
            ),
            milestones = listOf(
                Milestone("1839", "Fundação em Genebra", "Antoni Patek e Franciszek Czapek iniciam a fabricação."),
                Milestone("1845", "Invenção da Coroa sem Chave", "Adrien Philippe patenteia o mecanismo de corda pela coroa."),
                Milestone("1932", "Lançamento do Calatrava Ref. 96", "Definição do relógio vestir Bauhaus perfeito."),
                Milestone("1976", "Nascimento do Nautilus", "Desenho futurista por Gérald Genta com caixa inspirada em vigias de navio.")
            )
        ),

        BrandHistory(
            brandName = "Audemars Piguet",
            country = "Suiça (Le Brassus)",
            foundedYear = 1875,
            founder = "Jules Louis Audemars & Edward Auguste Piguet",
            summary = "Mestre das grandes complicações no Vale de Joux e criadora do revolucionário Royal Oak em 1972.",
            fullHistory = """
                Fundada em 1875 em Le Brassus por dois amigos de infância, Jules Louis Audemars e Edward Auguste Piguet. A manufatura permaneceu ininterruptamente nas mãos das famílias fundadoras.
                
                Em 1972, durante a crise do quartzo, a Audemars Piguet apostou tudo em um projeto ousado desenhado por Gérald Genta: o **Royal Oak**, um relógio esportivo em aço inoxidável com bisel octogonal exposto por parafusos sextavados e mostrador 'Tapisserie', vendido por um preço superior ao de relógios em ouro maciço. O Royal Oak criou a categoria de luxo esportivo integrada.
            """.trimIndent(),
            iconicModels = listOf("Royal Oak", "Royal Oak Offshore", "Royal Oak Concept", "Code 11.59"),
            keyInnovations = listOf(
                "Primeiro relógio de pulso com Repetidor de Minutos (1892)",
                "Relógio de pulso automático com Calendário Perpétuo mais fino (1978)",
                "Caixa octogonal com parafusos visíveis e acabamento escovado manual"
            ),
            milestones = listOf(
                Milestone("1875", "Fundação no Vallée de Joux", "Início da produção de relógios complicados de bolso."),
                Milestone("1972", "Lançamento do Royal Oak", "Revolução horológica com o aço de luxo na Feira de Basileia."),
                Milestone("1993", "Royal Oak Offshore", "Versão musculosa e esportiva extrema criada por Emmanuel Gueit.")
            )
        ),

        BrandHistory(
            brandName = "TAG Heuer",
            country = "Suiça (La Chaux-de-Fonds)",
            foundedYear = 1860,
            founder = "Edouard Heuer",
            summary = "Especialista em cronografia de precisão, intimamente associada ao automobilismo de alta velocidade e corridas da Fórmula 1.",
            fullHistory = """
                Fundada por Edouard Heuer em Saint-Imier em 1860. Em 1887 a empresa patenteou o **pinhão oscilante**, componente vital ainda hoje utilizado nos cronógrafos mecânicos.
                
                Sob a liderança de Jack Heuer nos anos 1960, a marca lançou modelos icônicos batizados em homenagem a corridas lendárias: o **Carrera** (1963) e o **Monaco** (1969), o primeiro cronógrafo automático com caixa quadrada impermeável, imortalizado por Steve McQueen no filme 'Le Mans'. Em 1985 a Heuer uniu-se ao grupo TAG (Techniques d'Avant Garde), formando a TAG Heuer.
            """.trimIndent(),
            iconicModels = listOf("Carrera", "Monaco", "Aquaracer", "Formula 1", "Autavia"),
            keyInnovations = listOf(
                "Pinhão Oscilante para Cronógrafos (1887)",
                "Primeiro Cronógrafo de painel de bordo de alta precisão Mikrograph (1916)",
                "Calibre 11 - Primeiro movimento de cronógrafo automático (1969)"
            ),
            milestones = listOf(
                Milestone("1860", "Fundação", "Edouard Heuer abre sua oficina aos 20 anos."),
                Milestone("1963", "Heuer Carrera", "Jack Heuer cria o cronógrafo com mostrador limpo para pilotos."),
                Milestone("1969", "Heuer Monaco", "Caixa quadrada e Calibre 11 usado por Steve McQueen."),
                Milestone("1985", "Aquisição TAG", "Fusão com o grupo TAG dá origem à TAG Heuer modernizada.")
            )
        ),

        BrandHistory(
            brandName = "Tudor",
            country = "Suiça (Genebra)",
            foundedYear = 1926,
            founder = "Hans Wilsdorf",
            summary = "Criada pelo fundado da Rolex para oferecer a lendária resistência e confiabilidade Oyster com preços mais acessíveis.",
            fullHistory = """
                Registrada em 1926 em nome de Hans Wilsdorf, criador da Rolex, a marca TUDOR foi criada para fabricar relógios que mantivessem os padrões de durabilidade, impermeabilidade da caixa Oyster e precisão da Rolex, mas a um ponto de preço mais amplo.
                
                Utilizada por forças navais militares de elite (como a Marinha Francesa e a US Navy nos anos 1960 e 70), a Tudor renasceu no século XXI com a renomada coleção **Black Bay**, combinando a estática 'vintage' (ponteiros 'Snowflake') com calibres de manufatura própria certificados COSC e Master Chronometer.
            """.trimIndent(),
            iconicModels = listOf("Black Bay 58 / 54", "Pelagos", "Black Bay Chrono", "Ranger", "Royal"),
            keyInnovations = listOf(
                "Ponteiro de Horas 'Snowflake' militar (1969)",
                "Caixa de Titânio Pelagos com fecho auto-ajustável para mergulho",
                "Mecanismos de Manufatura MT com espiral de silício e certificação METAS"
            ),
            milestones = listOf(
                Milestone("1926", "Registro da Marca", "Hans Wilsdorf adquire os direitos da marca Tudor."),
                Milestone("1952", "Tudor Oyster Prince", "Lançamento da caixa Oyster com rotor auto-corda."),
                Milestone("2012", "Renascentismo Black Bay", "Lançamento da linha que consolidou a marca no topo da horologia moderna.")
            )
        ),

        BrandHistory(
            brandName = "Breitling",
            country = "Suiça (Grenchen)",
            foundedYear = 1884,
            founder = "Léon Breitling",
            summary = "A especialista incontestável em aviação e cronógrafos profissionais para pilotos civis e militares.",
            fullHistory = """
                Fundada em Saint-Imier em 1884 por Léon Breitling. A marca dedicou-se ao aperfeiçoamento de cronógrafos e contadores de precisão para esportes e aviação.
                
                Em 1952 a Breitling apresentou o lendário **Navitimer**, equipado com uma régua de cálculo circular que permitia aos pilotos realizar todos os cálculos de navegação aérea (consumo de combustível, velocidade de subida, conversão de milhas) diretamente no bisel do relógio.
            """.trimIndent(),
            iconicModels = listOf("Navitimer", "Chronomat", "Superocean", "Avenger", "Premier", "Emergency"),
            keyInnovations = listOf(
                "Primeiro empurrador independente de cronógrafo às 2 horas (1915)",
                "Segundo empurrador dedicado de zera/reinício às 4 horas (1934)",
                "Régua de Cálculo Circular Aérea Navitimer (1952)",
                "Breitling Emergency com microtransmissor de socorro em 121.5 MHz"
            ),
            milestones = listOf(
                Milestone("1884", "Fundação", "Léon Breitling abre oficina focada em cronômetros."),
                Milestone("1952", "Nascimento do Navitimer", "O relógio de pulso oficial da AOPA (Aircraft Owners and Pilots Association)."),
                Milestone("1995", "Breitling Emergency", "Primeiro relógio com antena e transmissor de resgate de emergência integrado.")
            )
        )
    )

    fun getHistoryForBrand(brandName: String): BrandHistory? {
        val cleanQuery = brandName.trim().lowercase()
        return allBrands.find { it.brandName.lowercase() == cleanQuery }
            ?: allBrands.find { cleanQuery.contains(it.brandName.lowercase()) || it.brandName.lowercase().contains(cleanQuery) }
    }
}
