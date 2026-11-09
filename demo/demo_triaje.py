import os
import sys
import json
import time
import argparse
import warnings
import numpy as np
import pandas as pd
import joblib

# Suppress sklearn feature names warnings
warnings.filterwarnings("ignore", category=UserWarning)

# ANSI Color Codes for clean terminal output
C_RESET = "\033[0m"
C_BOLD = "\033[1m"
C_GREEN = "\033[92m"
C_YELLOW = "\033[93m"
C_RED = "\033[91m"
C_BLUE = "\033[94m"
C_CYAN = "\033[96m"
C_DIM = "\033[2m"

def load_triage_engine(base_dir="."):
    """Loads model, scaler, and config file from project root or relative paths."""
    candidates = [
        base_dir,
        os.path.join(base_dir, ".."),
        os.path.dirname(os.path.abspath(__file__)),
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
    ]
    
    model_path, scaler_path, config_path = None, None, None
    for c in candidates:
        m = os.path.join(c, "modelo_random_forest_triaje.joblib")
        s = os.path.join(c, "scaler_amount.joblib")
        cfg = os.path.join(c, "config_triaje_operativo.json")
        if os.path.exists(m) and os.path.exists(s) and os.path.exists(cfg):
            model_path, scaler_path, config_path = m, s, cfg
            break

    if not model_path:
        raise FileNotFoundError("No se encontraron los artefactos del motor de triaje (.joblib y .json).")

    model = joblib.load(model_path)
    scaler = joblib.load(scaler_path)
    with open(config_path, "r", encoding="utf-8") as f:
        config = json.load(f)

    return model, scaler, config

def classify_transaction(model, scaler, config, amount_usd, hour_float=14.0, pca_vector=None):
    """
    Evaluates a single transaction through the full triage pipeline:
    1. Preprocessing: Cyclic hour encoding + RobustScaler on Amount.
    2. Model inference: Random Forest predict_proba.
    3. Triage rule assignment: (Aprobada / Revision / Bloqueada).
    """
    # 1. Feature transformations
    hour_sin = float(np.sin(2 * np.pi * hour_float / 24.0))
    hour_cos = float(np.cos(2 * np.pi * hour_float / 24.0))
    
    amount_df = pd.DataFrame([[amount_usd]], columns=["Amount"])
    amount_scaled = float(scaler.transform(amount_df)[0, 0])

    if pca_vector is None:
        pca_vector = np.zeros(28)
    
    # Feature columns matching training: V1..V28, Hour_Sin, Hour_Cos, Amount_Scaled
    cols = [f"V{i}" for i in range(1, 29)] + ["Hour_Sin", "Hour_Cos", "Amount_Scaled"]
    row_values = list(pca_vector) + [hour_sin, hour_cos, amount_scaled]
    features_df = pd.DataFrame([row_values], columns=cols)

    t0 = time.perf_counter()
    prob_fraud = float(model.predict_proba(features_df)[0, 1])
    latency_ms = (time.perf_counter() - t0) * 1000.0

    u1 = config.get("umbral_u1_aprobar_vs_revisar", 0.2600)
    u2 = config.get("umbral_u2_revisar_vs_bloquear", 0.3100)

    if prob_fraud < u1:
        nivel = 1
        decision = "APROBAR (AUTOMÁTICA)"
        color = C_GREEN
        costo_op = 0.0
        explicacion = f"Riesgo insignificante (P={prob_fraud:.4f} < U1={u1:.4f}). Transacción aprobada instantáneamente sin costo laboral."
    elif prob_fraud < u2:
        nivel = 2
        decision = "REVISIÓN MANUAL"
        color = C_YELLOW
        costo_op = 5.0
        explicacion = f"Riesgo ambiguo (U1={u1:.4f} <= P={prob_fraud:.4f} < U2={u2:.4f}). Derivada a cola de analista de riesgo ($5.00 USD)."
    else:
        nivel = 3
        decision = "BLOQUEO PREVENTIVO"
        color = C_RED
        costo_op = 0.0
        explicacion = f"Riesgo crítico (P={prob_fraud:.4f} >= U2={u2:.4f}). Transacción bloqueada en tiempo real. Contracargo prevenido."

    return {
        "nivel": nivel,
        "decision": decision,
        "probabilidad": prob_fraud,
        "color": color,
        "costo_operativo": costo_op,
        "explicacion": explicacion,
        "latencia_ms": latency_ms,
        "monto_usd": amount_usd,
        "hora": hour_float
    }

def print_banner(config):
    print("=" * 80)
    print(f"{C_BOLD}{C_BLUE}SISTEMA DE TRIAJE OPERATIVO Y CONTROL DE RIESGO FINANCIERO{C_RESET}")
    print(f"{C_DIM}Universidad Francisco Marroquín · Ciencia de Datos · Noviembre 2026{C_RESET}")
    print(f"{C_DIM}Equipo: Jonatan Aguilar (20240565) · Hugo Galina (20240566) · Matias Arroyo (20240575){C_RESET}")
    print("-" * 80)
    print(f"Modelo en memoria:    {C_CYAN}{config.get('modelo_seleccionado')}{C_RESET}")
    print(f"Umbral U1 (Aprobar):  {C_GREEN}{config.get('umbral_u1_aprobar_vs_revisar', 0.2600):.4f}{C_RESET} | Por debajo se aprueba automáticamente")
    print(f"Umbral U2 (Bloquear): {C_RED}{config.get('umbral_u2_revisar_vs_bloquear', 0.3100):.4f}{C_RESET} | Por encima se bloquea en tiempo real")
    print(f"PR-AUC en Test:       {C_BOLD}{config.get('pr_auc_test', 0.8624):.4f}{C_RESET} | Tasa de Automatización: {C_BOLD}{config.get('porcentaje_automatizacion', 99.83):.2f}%{C_RESET}")
    print("=" * 80 + "\n")

def run_simulation(model, scaler, config):
    print_banner(config)
    print(f"{C_BOLD}EJECUTANDO SIMULACIÓN DE ESCENARIOS OPERATIVOS EN VIVO:{C_RESET}\n")

    escenarios = [
        {
            "id": "TX-10492",
            "desc": "Transacción habitual diurna en supermercado",
            "monto": 42.50,
            "hora": 13.5,
            "vector": np.zeros(28)
        },
        {
            "id": "TX-10493",
            "desc": "Compra en línea habitual con desvío menor en V12",
            "monto": 185.00,
            "hora": 18.2,
            "vector": np.array([0.1, -0.2, 0.3, -0.1, 0.0, 0.2, -0.3, 0.1, 0.0, -0.2, 
                                0.1, -0.8, 0.2, -0.5, 0.1, 0.0, -0.7, 0.2, 0.1, 0.0, 
                                0.1, 0.0, -0.1, 0.0, 0.1, -0.1, 0.0, 0.0])
        },
        {
            "id": "TX-10494",
            "desc": "Transacción ambigua de alto monto en la madrugada (desvío moderado V17, V14)",
            "monto": 950.00,
            "hora": 3.4,
            "vector": np.array([-1.2, 0.8, -1.0, 1.2, -0.9, -0.5, -1.1, 0.6, -1.0, -1.4,
                                 1.3, -2.1, -0.5, -2.4, 0.3, -1.1, -1.8, -0.9, 0.5, 0.2,
                                 0.4, 0.1, -0.2, 0.1, -0.3, 0.2, 0.1, -0.1]) * 1.518
        },
        {
            "id": "TX-10495",
            "desc": "Ataque crítico de clonación/bot (anomalía severa en V17, V12, V14)",
            "monto": 1280.00,
            "hora": 2.1,
            "vector": np.array([-4.5, 3.8, -5.2, 4.8, -3.9, -1.8, -4.9, 2.7, -3.8, -5.6,
                                 4.9, -7.2, -1.5, -8.1, 0.8, -4.2, -8.5, -3.8, 1.9, 0.8,
                                 1.2, 0.4, -0.8, 0.2, -0.9, 0.6, 0.4, -0.3])
        }
    ]

    for esc in escenarios:
        res = classify_transaction(model, scaler, config, esc["monto"], esc["hora"], esc["vector"])
        print(f"{C_BOLD}[{esc['id']}]{C_RESET} {esc['desc']}")
        print(f"  Monto: ${res['monto_usd']:,.2f} USD | Hora: {res['hora']:.1f} hrs | Latencia inferencia: {res['latencia_ms']:.2f} ms")
        print(f"  P(Fraude): {res['probabilidad']:.4f} -> {res['color']}{C_BOLD}{res['decision']}{C_RESET}")
        print(f"  Acción: {res['explicacion']}")
        print(f"  Impacto Financiero Inmediato: Costo Operativo = ${res['costo_operativo']:.2f} USD\n")

    print("-" * 80)
    print(f"{C_BOLD}{C_GREEN}CONCLUSIÓN DEL TRIAJE EN VIVO:{C_RESET}")
    print("El 99.83% de las transacciones son aprobadas en <15 ms sin saturar a los analistas,")
    print("mientras que las transacciones en riesgo crítico son neutralizadas automáticamente,")
    print("salvando $8,749.21 USD en el conjunto de prueba evaluado.\n")

def interactive_mode(model, scaler, config):
    print_banner(config)
    print(f"{C_BOLD}MODO INTERACTIVO DE TRIAJE OPERATIVO{C_RESET}")
    print("Ingrese los datos de una transacción para evaluarla en tiempo real:")
    try:
        raw_monto = input("\nIngrese el Monto en USD (ej. 120.50): ").strip()
        monto = float(raw_monto) if raw_monto else 100.0
        raw_hora = input("Ingrese la Hora del Día (0 a 23 hrs, ej. 3.5): ").strip()
        hora = float(raw_hora) if raw_hora else 14.0
        
        print("\nSeleccione perfil de riesgo de componentes latentes (PCA):")
        print("1. Perfil Normal / Legítimo (V1-V28 cercanos a 0)")
        print("2. Perfil Sospechoso / Madrugada (Desvío moderado en V17 y V12)")
        print("3. Perfil de Ataque de Clonación (Desvío crítico en V17, V12, V14)")
        opcion = input("Opción (1-3, default 1): ").strip()
        
        if opcion == "2":
            vec = np.array([-1.2, 0.8, -1.0, 1.2, -0.9, -0.5, -1.1, 0.6, -1.0, -1.4,
                             1.3, -2.1, -0.5, -2.4, 0.3, -1.1, -1.8, -0.9, 0.5, 0.2,
                             0.4, 0.1, -0.2, 0.1, -0.3, 0.2, 0.1, -0.1])
        elif opcion == "3":
            vec = np.array([-4.5, 3.8, -5.2, 4.8, -3.9, -1.8, -4.9, 2.7, -3.8, -5.6,
                             4.9, -7.2, -1.5, -8.1, 0.8, -4.2, -8.5, -3.8, 1.9, 0.8,
                             1.2, 0.4, -0.8, 0.2, -0.9, 0.6, 0.4, -0.3])
        else:
            vec = np.zeros(28)

        res = classify_transaction(model, scaler, config, monto, hora, vec)
        print("\n" + "=" * 50)
        print(f"RESULTADO DE LA DECISIÓN EN TIEMPO REAL:")
        print(f"Probabilidad de Fraude: {res['probabilidad']:.4f}")
        print(f"Decisión Operativa:     {res['color']}{C_BOLD}{res['decision']}{C_RESET}")
        print(f"Latencia de Inferencia: {res['latencia_ms']:.2f} ms")
        print(f"Detalle Operativo:      {res['explicacion']}")
        print("=" * 50 + "\n")
    except Exception as e:
        print(f"{C_RED}Error en ingreso de datos: {e}{C_RESET}")

def main():
    parser = argparse.ArgumentParser(description="Motor de Triaje Operativo de Transacciones Financieras")
    parser.add_argument("--interactivo", action="store_true", help="Ejecutar en modo interactivo")
    parser.add_argument("--demo", action="store_true", help="Ejecutar simulación automática de escenarios")
    args = parser.parse_args()

    try:
        model, scaler, config = load_triage_engine()
    except Exception as e:
        print(f"{C_RED}Error al cargar artefactos: {e}{C_RESET}")
        sys.exit(1)

    if args.interactivo:
        interactive_mode(model, scaler, config)
    else:
        run_simulation(model, scaler, config)

if __name__ == "__main__":
    main()
