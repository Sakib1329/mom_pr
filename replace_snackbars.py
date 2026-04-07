import os
import sys

dir_path = r"d:\flutter projects\mom_pr\lib\app\modules"

def replace_snackbars(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if "Get.snackbar(" not in content:
        return

    # Replace "Get.snackbar(" with "CustomToast.show("
    new_content = content.replace("Get.snackbar(", "CustomToast.show(")

    # Add import if missing
    import_str = "import 'package:Nuweli/app/widgets/custom_toast.dart';"
    if import_str not in new_content:
        # insert it near the top of the file
        idx = new_content.find("import ")
        if idx != -1:
            new_content = new_content[:idx] + import_str + "\n" + new_content[idx:]
        else:
            new_content = import_str + "\n" + new_content

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f"Replaced in {file_path}")

for root, _, files in os.walk(dir_path):
    for f in files:
        if f.endswith('.dart'):
            replace_snackbars(os.path.join(root, f))
