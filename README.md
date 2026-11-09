# Optimización del Triaje Operativo y Control de Riesgo Financiero en Transacciones con Tarjeta

**Universidad Francisco Marroquín**  
**Facultad de Ciencias Económicas / Ingeniería**  
**Ciencia de Datos · Sección A · Segundo Semestre 2026**  

### Equipo de Investigación y Desarrollo:
* **Jonatan Aguilar** — Carnet: 20240565
* **Hugo Galina** — Carnet: 20240566
* **Matias Arroyo** — Carnet: 20240575

---

## 1. Resumen Ejecutivo y Resultados de Negocio

Este proyecto implementa un **Motor de Triaje Operativo de Tres Vías** para transacciones financieras con tarjeta de crédito en tiempo real. Frente a clasificadores binarios simétricos que colapsan operativamente por exceso de falsos positivos o incurren en pérdidas millonarias por fraude escapado, nuestro sistema optimiza una **función de costo financiero asimétrico real**:
* **Falso Positivo (FP):** \$5.00 USD por costo operativo de inspección manual por analista humano.
* **Falso Negativo (FN):** Pérdida monetaria directa igual al monto real total (\$ USD) de la transacción defraudada.

### Indicadores Clave de Desempeño (KPIs) en Test Set Aislado (56,962 transacciones):
* **Ahorro Neto Generado:** **\$8,749.21 USD (82.2% de reducción del costo total)** frente al escenario sin sistema (\$10,644.93 USD).
* **Tasa de Automatización Operativa:** **99.83%** (56,865 transacciones aprobadas instantáneamente a costo de analista \$0 USD).
* **Derivación Eficiente a Revisión:** Solo **2 transacciones** enviadas a cola de analistas (\$10.00 USD de costo laboral), neutralizando fraudes de alto valor sin saturar la capacidad humana.
* **Métrica Técnica Principal:** **PR-AUC de 0.8624** (Random Forest con 100 estimadores), superando ampliamente al baseline de Regresión Logística (0.7640) y a LightGBM por defecto (0.5322 en CV).

---

## 2. Mapa Integral de Entregables del Proyecto

El repositorio está organizado de forma modular para permitir la auditoría inmediata de código, modelos y documentos:

| Componente | Ruta en el Repositorio | Descripción |
| :--- | :--- | :--- |
| **Informe Técnico Formal** | [`informe/informe.pdf`](informe/informe.pdf) | Documento académico autónomo de 13 páginas en Typst con código, gráficas nativas, tablas de salida y análisis sin necesidad de abrir Jupyter. Código fuente en [`informe/informe.typ`](informe/informe.typ). |
| **Diapositivas de Presentación** | [`presentacion/presentacion.pdf`](presentacion/presentacion.pdf) | Presentación de 12 diapositivas en formato 16:9 en Typst, con gráficas con títulos afirmativos y asignación de tiempos para los 12 minutos entre los 3 integrantes. Código en [`presentacion/presentacion.typ`](presentacion/presentacion.typ). |
| **Notebook de Modelado** | [`trabajo.ipynb`](trabajo.ipynb) | Cuaderno de Jupyter estructurado y completamente ejecutado con los 10 pasos metodológicos, salidas y visualizaciones. |
| **Guía de Defensa en Vivo** | [`defensa/guia_defensa.md`](defensa/guia_defensa.md) | Banco de 10 preguntas críticas esperadas del jurado, protocolos de respuesta individual (8 min / 6 pts) y desglose de tiempos. |
| **Plantilla de Coevaluación** | [`defensa/plantilla_coevaluacion.md`](defensa/plantilla_coevaluacion.md) | Formato para registrar los resúmenes y calificaciones durante las sesiones del 10 y 12 de noviembre (5 pts). |
| **Demo CLI Interactiva** | [`demo/demo_triaje.py`](demo/demo_triaje.py) | Script interactivo para simular transacciones y clasificar decisiones de triaje en tiempo real (<15 ms). |
| **Artefactos del Modelo** | `modelo_random_forest_triaje.joblib`<br>`scaler_amount.joblib`<br>`config_triaje_operativo.json` | Pesos serializados del ensamble, parámetros del escalador robusto y metadatos de umbrales ($U_1=0.2600$, $U_2=0.3100$). |
| **Ficha de Procedencia** | [`procedencia_datos.json`](procedencia_datos.json) | Metadatos de la fuente Kaggle (MLG-ULB), licencia DbCL v1.0 y volumen de 284,807 transacciones. |

---

## 3. Arquitectura del Motor de Triaje

```
[Transacción Entrante]
        │
        ▼
[Preprocesamiento sin Data Leakage]
  • RobustScaler (Monto)
  • Codificación Cíclica (Hour_Sin, Hour_Cos)
        │
        ▼
[Random Forest Classifier (100 Estimadores)]
        │
        ▼
  Cálculo de Probabilidad: P(Fraude) ∈ [0, 1]
        │
   ┌────┴──────────────────────────┐
   │                               │                               │
   ▼                               ▼                               ▼
Nivel 1: Aprobación        Nivel 2: Revisión Manual       Nivel 3: Bloqueo Automático
  P < 0.2600 (U1)            0.2600 ≤ P < 0.3100 (U2)       P ≥ 0.3100
  99.83% del tráfico         Cola de Analistas ($5 USD)     Bloqueo preventivo
  Costo analista: $0         2 transacciones en Test        95 transacciones en Test
```

---

## 4. Instrucciones de Reproducción del Entorno (`uv`)

El proyecto gestiona sus dependencias de forma determinista mediante `uv` y `pyproject.toml`.

### 4.1. Clonar el repositorio y preparar el entorno
```bash
git clone https://github.com/HugoGALAGA/final_DS
cd final_DS
uv sync
```

### 4.2. Ejecutar la Demostración de Triaje en Vivo
Para ejecutar la simulación automática de transacciones en consola:
```bash
uv run python demo/demo_triaje.py --demo
```
Para ejecutar el modo interactivo e ingresar montos manuales:
```bash
uv run python demo/demo_triaje.py --interactivo
```

### 4.3. Compilar los Documentos Typst
Si se dispone de `typst` instalado en el sistema:
```bash
# Compilar Informe Técnico Formal
typst compile --root . informe/informe.typ informe/informe.pdf

# Compilar Diapositivas de Presentación
typst compile --root . presentacion/presentacion.typ presentacion/presentacion.pdf
```

---

## 5. Licencia y Procedencia de Datos
* **Datos:** *Credit Card Fraud Detection Dataset* (Machine Learning Group - ULB), disponible bajo licencia *Database Contents License (DbCL) v1.0*.
* **Código y Modelos:** Proyecto desarrollado con fines académicos bajo licencia MIT.
