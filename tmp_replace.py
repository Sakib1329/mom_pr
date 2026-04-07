import os

dir_path = r'd:\flutter projects\mom_pr\lib\app\modules'

replacements = [
    ("type: ToastificationType.success", "style: ToastificationStyle.fillColored, type: ToastificationType.success"),
    ("type: ToastificationType.error", "style: ToastificationStyle.fillColored, type: ToastificationType.error"),
    ("type: ToastificationType.warning", "style: ToastificationStyle.fillColored, type: ToastificationType.warning"),
    ("type: ToastificationType.info", "style: ToastificationStyle.fillColored, type: ToastificationType.info")
]

modified_count = 0
for root, _, files in os.walk(dir_path):
    for filename in files:
        if filename.endswith('.dart'):
            filepath = os.path.join(root, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                original_content = content
                
                # In case we already replaced, avoid double substitution
                if "style: ToastificationStyle.fillColored" in content:
                    continue
                    
                for old, new in replacements:
                    content = content.replace(old, new)
                
                if content != original_content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Modified {filepath}")
                    modified_count += 1
            except Exception as e:
                print(f"Error processing {filepath}: {e}")

print(f"Total modified {modified_count} files.")
