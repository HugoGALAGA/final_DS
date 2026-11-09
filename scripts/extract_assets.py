import json
import base64
import os

def extract_notebook_figures(notebook_path, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    with open(notebook_path, "r", encoding="utf-8") as f:
        nb = json.load(f)

    # Map cell index to desired filename
    cell_mapping = {
        9: "fig1_eda_distribuciones.png",
        18: "fig2_curva_costo_umbral.png",
        27: "fig3_feature_importance.png"
    }

    for cell_idx, out_name in cell_mapping.items():
        cell = nb["cells"][cell_idx]
        found = False
        for out in cell.get("outputs", []):
            data = out.get("data", {})
            if "image/png" in data:
                img_data = data["image/png"]
                if isinstance(img_data, list):
                    img_data = "".join(img_data)
                raw_bytes = base64.b64decode(img_data)
                target_path = os.path.join(output_dir, out_name)
                with open(target_path, "wb") as img_file:
                    img_file.write(raw_bytes)
                print(f"Extracted {out_name} from cell {cell_idx} ({len(raw_bytes)} bytes)")
                found = True
                break
        if not found:
            print(f"Warning: No PNG found in cell {cell_idx}")

if __name__ == "__main__":
    extract_notebook_figures("final_DS/trabajo.ipynb", "final_DS/assets")
