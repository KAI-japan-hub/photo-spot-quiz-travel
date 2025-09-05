##写真を白黒変換にする
from pathlib import Path
import cv2

input_folder = Path("京都産業大学(室外)/the others")
output_folder = input_folder / "output_bw"
output_folder.mkdir(parents=True, exist_ok=True)

for file_path in input_folder.iterdir():
    if file_path.suffix.lower() == ".jpg":
        img = cv2.imread(str(file_path))
        if img is not None:
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            save_path = output_folder / file_path.name
            cv2.imwrite(str(save_path), gray)
            print(f"✅ 白黒変換成功: {file_path.name}")
        else:
            print(f"❌ 読み込み失敗: {file_path.name}")
