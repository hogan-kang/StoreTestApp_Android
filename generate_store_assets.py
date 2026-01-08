import os
import sys

# 检查是否安装了 Pillow 库
try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("❌ 错误: 未找到 Pillow 库。")
    print("请先运行安装命令: pip install Pillow")
    sys.exit(1)

# 配置输出目录
OUTPUT_DIR = "play_store_assets"
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def create_placeholder(filename, width, height, text, bg_color, text_color=(255, 255, 255)):
    """生成一张带文字的占位图片"""
    # 创建图片
    img = Image.new('RGB', (width, height), color=bg_color)
    draw = ImageDraw.Draw(img)

    # 尝试加载默认字体，如果失败则使用默认位图字体
    try:
        # 尝试根据系统加载一个较大的字体
        # Windows/Linux/Mac 路径可能不同，这里尝试通用的 Arial 或 DejaVu
        font_path = None
        if sys.platform == "darwin": # macOS
            font_path = "/System/Library/Fonts/Helvetica.ttc"
        elif sys.platform == "win32": # Windows
            font_path = "C:\\Windows\\Fonts\\arial.ttf"
        
        # 计算字体大小（粗略估计：高度的 10%）
        font_size = int(min(width, height) * 0.1)
        
        if font_path and os.path.exists(font_path):
            font = ImageFont.truetype(font_path, font_size)
        else:
            # 加载默认字体（不支持调整大小，会很小）
            font = ImageFont.load_default()
            print(f"⚠️ Warning: Using default font for {filename}, text might be small.")
    except Exception:
        font = ImageFont.load_default()

    # 计算文字位置以居中
    try:
        # Pillow >= 10.0.0
        left, top, right, bottom = draw.textbbox((0, 0), text, font=font)
        text_w = right - left
        text_h = bottom - top
    except AttributeError:
        # Older Pillow
        text_w, text_h = draw.textsize(text, font=font)

    x = (width - text_w) / 2
    y = (height - text_h) / 2

    # 绘制文字
    draw.text((x, y), text, font=font, fill=text_color)

    # 保存文件
    file_path = os.path.join(OUTPUT_DIR, filename)
    img.save(file_path)
    print(f"✅ Generated: {file_path} ({width}x{height})")

# === 开始生成 ===
print("🚀 Starting to generate Play Store assets...")

# 1. App Icon (512x512)
create_placeholder("icon_512.png", 512, 512, "ICON", (33, 150, 243)) # Blue

# 2. Feature Graphic (1024x500)
create_placeholder("feature_graphic.png", 1024, 500, "FEATURE\nGRAPHIC", (76, 175, 80)) # Green

# 3. Phone Screenshots (1080x1920)
create_placeholder("screenshot_1.png", 1080, 1920, "Screenshot 1\nMain Screen", (96, 125, 139)) # Grey
create_placeholder("screenshot_2.png", 1080, 1920, "Screenshot 2\nDetails", (255, 87, 34)) # Deep Orange

print("\n🎉 All assets generated in folder: " + OUTPUT_DIR)
