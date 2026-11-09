import matplotlib.pyplot as plt
import matplotlib.patches as patches

def generate_triage_diagram(output_path):
    fig, ax = plt.subplots(figsize=(10, 5), dpi=300)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis('off')

    # Background subtle styling
    fig.patch.set_facecolor('#ffffff')

    # Color palette
    c_blue = '#1f4e79'
    c_green = '#2e7d32'
    c_orange = '#e65100'
    c_red = '#c62828'
    c_gray = '#455a64'
    c_box = '#f5f7fa'

    # Box 1: Input Transaction
    box_in = patches.FancyBboxPatch((0.4, 2.3), 1.8, 1.4, boxstyle="round,pad=0.1", fc=c_box, ec=c_gray, lw=1.5)
    ax.add_patch(box_in)
    ax.text(1.3, 3.2, "Transacción\nEntrante", ha="center", va="center", fontsize=10, fontweight="bold", color=c_gray)
    ax.text(1.3, 2.6, "(Monto, Time, V1-V28)", ha="center", va="center", fontsize=8, color="#555")

    # Arrow 1 -> Model
    ax.annotate("", xy=(3.0, 3.0), xytext=(2.3, 3.0),
                arrowprops=dict(arrowstyle="->", lw=2, color=c_gray))

    # Box 2: Random Forest Model
    box_rf = patches.FancyBboxPatch((3.0, 2.1), 2.2, 1.8, boxstyle="round,pad=0.1", fc='#e8eaf6', ec=c_blue, lw=2)
    ax.add_patch(box_rf)
    ax.text(4.1, 3.3, "Random Forest\nClassifier", ha="center", va="center", fontsize=11, fontweight="bold", color=c_blue)
    ax.text(4.1, 2.5, "Inferencia en tiempo real\nCálculo de P(Fraude)", ha="center", va="center", fontsize=8, color="#333")

    # Arrows to 3 tiers
    ax.annotate("", xy=(6.0, 4.8), xytext=(5.3, 3.5),
                arrowprops=dict(arrowstyle="->", lw=2, color=c_green))
    ax.annotate("", xy=(6.0, 3.0), xytext=(5.3, 3.0),
                arrowprops=dict(arrowstyle="->", lw=2, color=c_orange))
    ax.annotate("", xy=(6.0, 1.2), xytext=(5.3, 2.5),
                arrowprops=dict(arrowstyle="->", lw=2, color=c_red))

    # Tier 1: Auto-Approve
    box_t1 = patches.FancyBboxPatch((6.0, 4.1), 3.6, 1.4, boxstyle="round,pad=0.1", fc='#e8f5e9', ec=c_green, lw=2)
    ax.add_patch(box_t1)
    ax.text(7.8, 5.0, "Nivel 1: Aprobación Inmediata", ha="center", va="center", fontsize=10, fontweight="bold", color=c_green)
    ax.text(7.8, 4.4, "P < 0.2600  |  99.83% del volumen\nCosto operativo: $0 USD", ha="center", va="center", fontsize=8.5, color="#222")

    # Tier 2: Manual Review
    box_t2 = patches.FancyBboxPatch((6.0, 2.3), 3.6, 1.4, boxstyle="round,pad=0.1", fc='#fff3e0', ec=c_orange, lw=2)
    ax.add_patch(box_t2)
    ax.text(7.8, 3.2, "Nivel 2: Revisión Manual", ha="center", va="center", fontsize=10, fontweight="bold", color=c_orange)
    ax.text(7.8, 2.6, "0.2600 <= P < 0.3100  |  Cola de analistas\nCosto operativo: $5 USD / caso", ha="center", va="center", fontsize=8.5, color="#222")

    # Tier 3: Auto-Block
    box_t3 = patches.FancyBboxPatch((6.0, 0.5), 3.6, 1.4, boxstyle="round,pad=0.1", fc='#ffebee', ec=c_red, lw=2)
    ax.add_patch(box_t3)
    ax.text(7.8, 1.4, "Nivel 3: Bloqueo Automático", ha="center", va="center", fontsize=10, fontweight="bold", color=c_red)
    ax.text(7.8, 0.8, "P >= 0.3100  |  Riesgo crítico\nPrevención de pérdida directa", ha="center", va="center", fontsize=8.5, color="#222")

    plt.tight_layout()
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Generated {output_path}")

if __name__ == "__main__":
    generate_triage_diagram("final_DS/assets/fig4_diagrama_triaje.png")
