#set document(
  title: "Defensa de Proyecto Final: Triaje Operativo y Control de Riesgo Financiero",
  author: ("Jonatan Aguilar", "Hugo Galina", "Matias Arroyo")
)

#set page(
  paper: "presentation-16-9",
  margin: (x: 1.4cm, top: 1.2cm, bottom: 1.0cm),
  header: context {
    if here().page() > 1 [
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        [
          #text(8.5pt, fill: rgb("#1f4e79"), weight: "bold", font: "Liberation Sans")[
            CIENCIA DE DATOS · PROYECTO FINAL · MOTOR DE TRIAJE OPERATIVO
          ]
        ],
        [
          #text(8.5pt, fill: rgb("#666666"), font: "Liberation Sans")[
            UFM · Segundo Semestre 2026
          ]
        ]
      )
      #v(2pt)
      #line(length: 100%, stroke: 0.5pt + rgb("#d0d7de"))
    ]
  },
  footer: context {
    if here().page() > 1 [
      #line(length: 100%, stroke: 0.5pt + rgb("#d0d7de"))
      #v(2pt)
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        [
          #text(8pt, fill: rgb("#777777"), font: "Liberation Sans")[
            Aguilar (20240565) · Galina (20240566) · Arroyo (20240575)
          ]
        ],
        [
          #text(8pt, fill: rgb("#1f4e79"), weight: "bold", font: "Liberation Sans")[
            #counter(page).display() / #counter(page).final().first()
          ]
        ]
      )
    ]
  }
)

#set text(
  font: "Liberation Sans",
  size: 11pt,
  lang: "es"
)

#set par(
  leading: 0.55em,
  justify: false
)

// Componentes modulares de diseño de diapositivas
#let badge_expositor(nombre, tiempo) = block(
  fill: rgb("#e8eaf6"),
  stroke: 0.8pt + rgb("#3f51b5"),
  inset: (x: 8pt, y: 4pt),
  radius: 3pt,
  [
    #text(8pt, weight: "bold", fill: rgb("#1a237e"))[Expositor: #nombre]
    #text(8pt, fill: rgb("#3949ab"))[ (#tiempo)]
  ]
)

#let slide_header(titulo, subtitulo, expositor: none, tiempo: none) = [
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    [
      #text(16pt, weight: "bold", fill: rgb("#0d233a"))[#titulo] \
      #if subtitulo != none [
        #v(1pt)
        #text(10pt, fill: rgb("#555555"), style: "italic")[#subtitulo]
      ]
    ],
    [
      #if expositor != none [
        #badge_expositor(expositor, tiempo)
      ]
    ]
  )
  #v(8pt)
]

#let card(titulo: none, color_borde: rgb("#1f4e79"), fondo: rgb("#f8fafc"), cuerpo) = block(
  fill: fondo,
  stroke: (left: 3.5pt + color_borde, rest: 0.5pt + rgb("#e2e8f0")),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #if titulo != none [
      #text(10pt, weight: "bold", fill: color_borde)[#titulo]
      #v(2pt)
    ]
    #text(9.5pt)[#cuerpo]
  ]
)

#let metrica_kpi(valor, etiqueta, descripcion: none, color: rgb("#1f4e79")) = block(
  fill: rgb("#f8fafc"),
  stroke: 1pt + rgb("#e2e8f0"),
  inset: 8pt,
  radius: 4pt,
  align(center)[
    #text(18pt, weight: "bold", fill: color)[#valor] \
    #text(9pt, weight: "bold", fill: rgb("#222222"))[#etiqueta]
    #if descripcion != none [
      \ #text(7.5pt, fill: rgb("#666666"))[#descripcion]
    ]
  ]
)

// ==========================================
// SLIDE 1: PORTADA
// ==========================================
#align(center + horizon)[
  #text(11pt, weight: "bold", fill: rgb("#1f4e79"))[UNIVERSIDAD FRANCISCO MARROQUÍN · CIENCIA DE DATOS (SECCIÓN A)] \
  #v(8pt)
  #text(22pt, weight: "bold", fill: rgb("#0d233a"))[Optimización del Triaje Operativo y Control de Riesgo Financiero en Transacciones con Tarjeta] \
  #v(6pt)
  #text(13pt, fill: rgb("#444444"), style: "italic")[Defensa Técnica de Proyecto Final: Un Enfoque Basado en Costos Asimétricos y Decisión de Tres Vías] \
  #v(18pt)
  
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 14pt,
    [
      #block(fill: rgb("#f1f5f9"), inset: 8pt, radius: 4pt)[
        #text(10pt, weight: "bold", fill: rgb("#1f4e79"))[Matias Arroyo] \
        #text(8.5pt)[Carnet: 20240575] \
        #text(8pt, fill: rgb("#555555"))[Bloque 1: Framing, EDA y Costos]
      ]
    ],
    [
      #block(fill: rgb("#f1f5f9"), inset: 8pt, radius: 4pt)[
        #text(10pt, weight: "bold", fill: rgb("#1f4e79"))[Hugo Galina] \
        #text(8.5pt)[Carnet: 20240566] \
        #text(8pt, fill: rgb("#555555"))[Bloque 2: ML Pipeline & Validación]
      ]
    ],
    [
      #block(fill: rgb("#f1f5f9"), inset: 8pt, radius: 4pt)[
        #text(10pt, weight: "bold", fill: rgb("#1f4e79"))[Jonatan Aguilar] \
        #text(8.5pt)[Carnet: 20240565] \
        #text(8pt, fill: rgb("#555555"))[Bloque 3: Triaje, ROI & Despliegue]
      ]
    ]
  )
  #v(12pt)
  #text(9pt, fill: rgb("#666666"))[Noviembre 2026 · Tiempo de Exposición: 12 Minutos · Sesión de Defensa en Vivo: 8 Minutos]
]

#pagebreak()

// ==========================================
// SLIDE 2: FRAMING DE NEGOCIO Y DECISIÓN OPERATIVA
// ==========================================
#slide_header(
  "Framing de Negocio: La Decisión Transaccional",
  "Transición de predicción abstracta a un motor de decisión en tiempo real",
  expositor: "Matias Arroyo",
  tiempo: "Minuto 0:00 - 1:20"
)

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 14pt,
  [
    #card(titulo: "El Problema Real de Negocio", color_borde: rgb("#c62828"))[
      - La detección binaria tradicional ("Fraude vs Legítima") fracasa en operaciones bancarias.
      - *Falsos Positivos:* Costos humanos de revisión y fricción comercial severa con clientes legítimos bloqueados.
      - *Falsos Negativos:* Pérdida económica directa íntegra por contracargo asumido por el emisor.
    ]
    #v(6pt)
    #card(titulo: "La Decisión Operativa (Y) de Tres Vías", color_borde: rgb("#1f4e79"))[
      + *Aprobar Automáticamente:* Para transacciones con riesgo despreciable ($p < U_1$).
      + *Enviar a Revisión Manual:* Casos de riesgo intermedio o ambiguo ($U_1 <= p < U_2$) donde el monto justifica el costo humano (\$5 USD).
      + *Bloquear Automáticamente:* Alerta preventiva para riesgo crítico ($p >= U_2$).
    ]
  ],
  [
    #card(titulo: "Por Qué Descartamos Métricas Tradicionales", color_borde: rgb("#e65100"))[
      - *Accuracy es Inútil:* Predecir siempre "legítima" otorga un *99.83% de accuracy*, pero pierde el 100% del dinero expuesto a fraude.
      - *ROC-AUC Oculta Errores:* En extremo desbalance, evalúa falsos positivos contra la gigantesca masa de legítimas, camuflando miles de falsas alarmas.
      - *Métricas Mandatarias:* *PR-AUC* (Precision-Recall) y la *Función de Costo Financiero Total (\$ USD)*.
    ]
  ]
)

#pagebreak()

// ==========================================
// SLIDE 3: FUNCIÓN DE COSTO FINANCIERO ASIMÉTRICO
// ==========================================
#slide_header(
  "Métrica Causal de Costo: La Realidad Financiera del Error",
  "Modelado cuantitativo de las pérdidas operativas y monetarias directas",
  expositor: "Matias Arroyo",
  tiempo: "Minuto 1:20 - 2:40"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #card(titulo: "Estructura de la Matriz de Pérdida Asimétrica", color_borde: rgb("#1f4e79"))[
      - *Costo de Falso Positivo (FP):* \$5.00 USD (tiempo de analista en inspección manual inútil).
      - *Costo de Falso Negativo (FN):* Monto real total ($M_i$) de la transacción defraudada.
      - *Costo de Verdadero Positivo (TP):* \$5.00 USD de validación, pero rescatando el 100% de $M_i$.
      - *Costo de Verdadero Negativo (TN):* \$0.00 USD.
    ]
    #v(6pt)
    #block(fill: rgb("#f0f4f8"), inset: 10pt, radius: 4pt, stroke: 1pt + rgb("#1f4e79"))[
      #text(9pt, weight: "bold", fill: rgb("#1f4e79"))[Función Objetivo de Optimización Financiera:]
      #v(3pt)
      $ C_text("total") = sum_(i in "FP") 5.00 + sum_(j in "FN") M_j + sum_(k in "TP") 5.00 $
    ]
  ],
  [
    #card(titulo: "Parámetros del Dataset de Evaluación (Test)", color_borde: rgb("#2e7d32"))[
      - Conjunto de Prueba Aislado: *56,962 transacciones*.
      - Fraudes Reales en Test: *98 casos*.
      - *Capital en Riesgo Directo:* *\$10,644.93 USD*.
    ]
    #v(6pt)
    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      metrica_kpi("$10,644.93", "Riesgo Expuesto", descripcion: "En 98 fraudes de test", color: rgb("#c62828")),
      metrica_kpi("$5.00 USD", "Costo / Revisión", descripcion: "Analista humano de riesgo", color: rgb("#e65100"))
    )
  ]
)

#pagebreak()

// ==========================================
// SLIDE 4: HALLAZGOS CLAVE DE EDA Y PROCEDENCIA
// ==========================================
#slide_header(
  "Los Fraudes Exhiben Patrones de Ataques de Bots y Desbalance Extremo",
  "El análisis exploratorio reveló señales críticas que impidieron la pérdida del 6.5% de los fraudes",
  expositor: "Matias Arroyo",
  tiempo: "Minuto 2:40 - 4:00"
)

#grid(
  columns: (1.3fr, 0.7fr),
  gutter: 12pt,
  [
    #image("assets/fig1_eda_distribuciones.png", width: 100%)
  ],
  [
    #card(titulo: "Hallazgo Crítico: Duplicados", color_borde: rgb("#c62828"))[
      - *32 fraudes duplicados exactos:* Representan el *6.5% de todos los fraudes*.
      - Proceden de ataques programados por *bots* en ráfaga.
      - *Decisión técnica:* Prohibición expresa de eliminarlos con `drop_duplicates`.
    ]
    #v(6pt)
    #card(titulo: "El Monto No Discrimina Solo", color_borde: rgb("#1f4e79"))[
      - Mediana legítima: *\$22.00 USD*.
      - Mediana fraude: *\$9.25 USD*.
      - Los defraudadores testean montos bajos para evadir filtros heurísticos.
    ]
  ]
)

#pagebreak()

// ==========================================
// SLIDE 5: PIPELINE Y PARTICIÓN SIN FUGA DE DATOS
// ==========================================
#slide_header(
  "Pipeline sin Fuga de Datos: Escalamiento Robusto y Variables Cíclicas",
  "Garantía metodológica de aislamiento absoluto del conjunto de prueba",
  expositor: "Hugo Galina",
  tiempo: "Minuto 4:00 - 5:20"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #card(titulo: "1. Tratamiento Temporal Cíclico", color_borde: rgb("#1f4e79"))[
      - `Time` en segundos carece de continuidad 24 horas.
      - Extracción de la hora local del día:
        $ "Hour" = ("Time" / 3600) mod 24 $
      - Proyección trigonométrica polar sin saltos entre 23:59 y 00:00:
        $ "Hour"_text("sin") = sin(frac(2 pi "Hour", 24)), quad "Hour"_text("cos") = cos(frac(2 pi "Hour", 24)) $
    ]
    #v(6pt)
    #card(titulo: "2. Escalamiento Inmune a Outliers", color_borde: rgb("#2e7d32"))[
      - `RobustScaler` basado en mediana e IQR ($Q_3 - Q_1$).
      - *Zero Data Leakage:* `fit` exclusivo en Train (80%) y `transform` en Test (20%).
    ]
  ],
  [
    #card(titulo: "3. Partición Estratificada Rigurosa", color_borde: rgb("#e65100"))[
      - *Train Set (80%):* 227,845 transacciones (394 fraudes, 0.1729%).
      - *Test Set (20%):* 56,962 transacciones (98 fraudes, 0.1720%).
      - *Regla inviolable de la rúbrica:* El conjunto de prueba se mantuvo 100% sellado hasta la evaluación final.
    ]
    #v(6pt)
    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      metrica_kpi("0.17%", "Tasa Fraude", descripcion: "Estratificada en Train y Test"),
      metrica_kpi("5 Folds", "Stratified CV", descripcion: "En Train para modelado", color: rgb("#2e7d32"))
    )
  ]
)

#pagebreak()

// ==========================================
// SLIDE 6: BENCHMARKING DE MODELOS EN CROSS-VALIDATION
// ==========================================
#slide_header(
  "Random Forest Supera Categóricamente a LightGBM en CV Estratificada",
  "El bagging de árboles profundos aísla eficientemente subespacios en extremo desbalance",
  expositor: "Hugo Galina",
  tiempo: "Minuto 5:20 - 6:40"
)

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 14pt,
  [
    #card(titulo: "Resultados Cuantitativos en 5-Fold Stratified CV", color_borde: rgb("#1f4e79"))[
      #align(center)[
      #table(
        columns: (auto, auto, auto, auto),
        fill: (col, row) => if row == 0 { rgb("#1f4e79") } else if row == 1 { rgb("#e8f5e9") } else { white },
        stroke: 0.5pt + rgb("#cccccc"),
        align: (left, center, center, center),
        [#text(white, weight: "bold")[Modelo Evaluado]],
        [#text(white, weight: "bold")[PR-AUC Promedio]],
        [#text(white, weight: "bold")[Desv. Est.]],
        [#text(white, weight: "bold")[Decisión]],
        [*Random Forest*], [*0.8361*], [± 0.0346], [*Seleccionado*],
        [LightGBM (Default)], [0.5322], [± 0.0482], [Descartado],
        [Regresión Logística], [0.7640], [N/A (Baseline)], [Superado]
      )
      ]
    ]
    #v(6pt)
    #card(titulo: "Justificación Teórica del Descarte de LightGBM", color_borde: rgb("#c62828"))[
      - Boosting por gradiente penaliza globalmente los residuos. Con 99.83% de legítimas, los gradientes minoritarios se enmascaran.
      - Random Forest crea particiones ortogonales no lineales que aíslan el fraude sin diluirlo en el ensemble.
    ]
  ],
  [
    #grid(
      columns: (1fr),
      gutter: 10pt,
      metrica_kpi("0.8361", "PR-AUC CV (Random Forest)", descripcion: "Consistencia sólida en 5 folds", color: rgb("#2e7d32")),
      metrica_kpi("0.5322", "PR-AUC CV (LightGBM)", descripcion: "Colapso predictivo en default", color: rgb("#c62828"))
    )
  ]
)

#pagebreak()

// ==========================================
// SLIDE 7: IMPORTANCIA DE CARACTERÍSTICAS E INTERPRETABILIDAD
// ==========================================
#slide_header(
  "El 47.9% del Poder Predictivo Radica en Tres Componentes Latentes",
  "Las componentes V17, V12 y V14 capturan los desvíos estructurales de comportamiento delictivo",
  expositor: "Hugo Galina",
  tiempo: "Minuto 6:40 - 8:00"
)

#grid(
  columns: (1.3fr, 0.7fr),
  gutter: 12pt,
  [
    #image("assets/fig3_feature_importance.png", width: 100%)
  ],
  [
    #card(titulo: "Concentración de la Señal", color_borde: rgb("#1f4e79"))[
      - *$V_{17}$:* 17.97% de importancia Gini.
      - *$V_{12}$:* 15.08% de importancia Gini.
      - *$V_{14}$:* 14.85% de importancia Gini.
      - En conjunto acumulan casi la mitad de toda la discriminación del bosque.
    ]
    #v(6pt)
    #card(titulo: "Interpretabilidad Financiera", color_borde: rgb("#2e7d32"))[
      - Aunque anonimizadas, sintetizan correlaciones de velocidad de gasto y desvío de patrones habituales.
    ]
  ]
)

#pagebreak()

// ==========================================
// SLIDE 8: OPTIMIZACIÓN DE UMBRAL DE DECISIÓN
// ==========================================
#slide_header(
  "Optimizar el Umbral a 0.99 Reduce el Costo Operativo de Falsos Positivos en 95.3%",
  "El umbral simétrico de 0.50 colapsa la operación; calibrar según costos multiplica el ahorro",
  expositor: "Jonatan Aguilar",
  tiempo: "Minuto 8:00 - 9:20"
)

#grid(
  columns: (1.3fr, 0.7fr),
  gutter: 12pt,
  [
    #image("assets/fig2_curva_costo_umbral.png", width: 100%)
  ],
  [
    #card(titulo: "Evolución Financiera del Corte", color_borde: rgb("#e65100"))[
      - *En Umbral 0.50:*
        1,442 Falsos Positivos generan *\$7,210 USD* de costo en analistas.
      - *En Umbral Óptimo 0.99:*
        Falsos Positivos caen a *67*.
        Costo total cae de \$7,868 a *\$2,582 USD*.
    ]
    #v(6pt)
    #card(titulo: "Lección de Negocio", color_borde: rgb("#1f4e79"))[
      - Calibrar la probabilidad a la función de pérdida monetaria aporta más valor que modificar la estructura del modelo.
    ]
  ]
)

#pagebreak()

// ==========================================
// SLIDE 9: ARQUITECTURA DEL MOTOR DE TRIAJE OPERATIVO
// ==========================================
#slide_header(
  "Motor de Triaje de Tres Niveles: Aprobación, Revisión y Bloqueo",
  "Resolución simultánea del costo laboral humano y el riesgo de contracargos bancarios",
  expositor: "Jonatan Aguilar",
  tiempo: "Minuto 9:20 - 10:20"
)

#align(center)[
  #image("assets/fig4_diagrama_triaje.svg", width: 95%)
]

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  card(titulo: "Nivel 1: Aprobación (p < 0.2600)", color_borde: rgb("#2e7d32"))[
    - *56,865 transacciones (99.83%)*.
    - Procesamiento instantáneo a costo \$0 USD.
  ],
  card(titulo: "Nivel 2: Revisión (0.26 <= p < 0.31)", color_borde: rgb("#e65100"))[
    - *2 transacciones* derivadas a analistas.
    - Captura fraude con solo \$10 USD de costo humano.
  ],
  card(titulo: "Nivel 3: Bloqueo (p >= 0.3100)", color_borde: rgb("#c62828"))[
    - *95 transacciones bloqueadas*.
    - 80 fraudes detenidos automáticamente.
  ]
)

#pagebreak()

// ==========================================
// SLIDE 10: IMPACTO FINANCIERO Y RESULTADOS EN TEST
// ==========================================
#slide_header(
  "El Triaje Operativo Logra 82.2% de Ahorro Neto con 99.83% de Automatización",
  "Evaluación honesta sobre el test set tocado una sola vez: $8,749.21 USD de ahorro directo",
  expositor: "Jonatan Aguilar",
  tiempo: "Minuto 10:20 - 11:10"
)

#align(center)[
#table(
  columns: (auto, auto, auto, auto, auto, auto),
  fill: (col, row) => if row == 0 { rgb("#1f4e79") } else if row == 4 { rgb("#e8f5e9") } else { white },
  stroke: 0.5pt + rgb("#cccccc"),
  align: (left, center, center, center, center, center),
  [#text(white, weight: "bold")[Estrategia de Decisión]],
  [#text(white, weight: "bold")[Costo Analistas (FP)]],
  [#text(white, weight: "bold")[Fraude Escapado (FN)]],
  [#text(white, weight: "bold")[Costo Total USD]],
  [#text(white, weight: "bold")[Ahorro Neto USD]],
  [#text(white, weight: "bold")[% Ahorro]],
  [Sin Modelo (Dejar pasar)], [\$0.00 USD], [\$10,644.93 USD], [\$10,644.93 USD], [\$0.00 USD], [0.0%],
  [Regresión Logística (0.50)], [\$7,210.00 USD], [\$658.61 USD], [\$7,868.61 USD], [\$2,776.32 USD], [26.1%],
  [Regresión Logística (0.99)], [\$335.00 USD], [\$2,247.72 USD], [\$2,582.72 USD], [\$8,062.21 USD], [75.7%],
  [*Triaje Random Forest (3 Niveles)*], [*\$10.00 USD*], [*\$1,830.72 USD*], [*\$1,895.72 USD*], [*\$8,749.21 USD*], [*82.2%*]
)
]

#v(8pt)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  metrica_kpi("99.83%", "Tasa Automatización", descripcion: "56,865 / 56,962 aprobadas sin fricción", color: rgb("#2e7d32")),
  metrica_kpi("$8,749.21", "Ahorro Neto Directo", descripcion: "82.2% reducción de costo en test", color: rgb("#1f4e79")),
  metrica_kpi("0.8624", "PR-AUC en Test", descripcion: "Evaluado una sola vez en test sellado", color: rgb("#3949ab"))
)

#pagebreak()

// ==========================================
// SLIDE 11: PLAN DE DESPLIEGUE Y MONITOREO
// ==========================================
#slide_header(
  "Plan de Despliegue en Streaming y Monitoreo de Data Drift",
  "Inferencia en menos de 15 ms y gobernanza adaptativa de umbrales",
  expositor: "Jonatan Aguilar",
  tiempo: "Minuto 11:10 - 11:40"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #card(titulo: "Arquitectura de Despliegue Operativo", color_borde: rgb("#1f4e79"))[
      - *Serialización:* Estructuras `.joblib` empaquetadas para inferencia ultra-rápida (inferior a 15 ms).
      - *Microservicio FastAPI:* Consumo de eventos transaccionales vía colas Kafka.
      - *Respuestas Semánticas:*
        - `200 APPROVE`
        - `202 QUEUE_MANUAL_REVIEW`
        - `403 DECLINE_FRAUD_ALERT`
    ]
  ],
  [
    #card(titulo: "Monitoreo Continuo y Gobernanza", color_borde: rgb("#e65100"))[
      - *Detección de Data Drift:* Test Kolmogorov-Smirnov sobre $V_{17}$ y $V_{12}$ para alertar cambios poblacionales.
      - *Detección de Concept Drift:* Monitoreo semanal de variaciones en la tasa de contracargos.
      - *Recalibración Mensual:* Ajuste dinámico de $U_1$ y $U_2$ ante incrementos del costo laboral de analistas o cambios en el ticket promedio.
    ]
  ]
)

#pagebreak()

// ==========================================
// SLIDE 12: LÍMITES, BITÁCORA AI Y CONCLUSIONES
// ==========================================
#slide_header(
  "Límites de Extrapolabilidad, Bitácora de IA y Conclusiones",
  "Honestidad intelectual y síntesis ejecutiva para la defensa en vivo",
  expositor: "Jonatan Aguilar",
  tiempo: "Minuto 11:40 - 12:00"
)

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 12pt,
  [
    #card(titulo: "Lo que NO se Puede Concluir (Límites)", color_borde: rgb("#c62828"))[
      - *Anonimización PCA:* No es posible asociar fraudes a comercios específicos (MCC) o ubicaciones geográficas.
      - *Horizonte Temporal de 48 Horas:* Datos europeos de septiembre 2013; no extrapolan directamente a Black Friday o pasarelas latinoamericanas.
      - *Correlación vs Causalidad:* Predecir no equivale a intervenir causas de raíz.
    ]
    #v(6pt)
    #card(titulo: "Bitácora de IA: Criterio Propio", color_borde: rgb("#2e7d32"))[
      - *Asistió:* Estructura `uv`, JSONs y sintaxis Typst.
      - *Rechazos del Equipo:* Se descartó LightGBM sin calibrar (PR-AUC 0.53) y se impidió el borrado de duplicados críticos (bots).
    ]
  ],
  [
    #block(fill: rgb("#1f4e79"), inset: 12pt, radius: 4pt)[
      #text(12pt, weight: "bold", fill: white)[Conclusión Final] \
      #v(4pt)
      #text(9.5pt, fill: rgb("#e2e8f0"))[
        El proyecto demostró que la optimización causal del triaje operativo convierte el machine learning en una herramienta de rentabilidad directa, reduciendo los costos un *82.2%* y preservando la agilidad transaccional de la institución.
      ]
      #v(8pt)
      #line(length: 100%, stroke: 0.5pt + rgb("#ffffff"))
      #v(4pt)
      #text(10pt, weight: "bold", fill: white)[Estamos listos para la sesión de defensa y preguntas en vivo (8 min).]
    ]
  ]
)
