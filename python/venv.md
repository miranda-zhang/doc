```sh
# 1. Make sure you have venv support
sudo apt update
sudo apt install python3-venv python3-pip -y

# 2. Create a virtual environment
python3 -m venv semantic_search

# 3. Activate it
source semantic_search/bin/activate

# 4. Install the packages inside the virtualenv
pip install --upgrade pip
pip install ipykernel jupyter
```
Then, in VS Code, point your Python interpreter to `~/Documents/workspace/venv/semantic_search/bin/python`.
# VScode
### **Select the Python Interpreter**

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) → type **Python: Select Interpreter**.
2. Click **Enter interpreter path → Find**.
3. Navigate to your venv
4. Select it. VS Code will now use this Python for the project.

> ⚠️ Sometimes VS Code caches interpreters, so you may need to reload the window after adding a new venv.
