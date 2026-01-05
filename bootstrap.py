import subprocess
import sys
from pathlib import Path
import requests
import json

def get_installed_version():
    """Get the currently installed version of lasso."""
    try:
        result = subprocess.run(
            [sys.executable, "-m", "pip", "show", "lasso"],
            capture_output=True,
            text=True
        )
        for line in result.stdout.split('\n'):
            if line.startswith('Version:'):
                return line.split(':')[1].strip()
    except Exception as e:
        print(f"Error getting installed version: {e}")
    return None

def get_latest_stable_version():
    """Fetch the latest stable release version from git/PyPI."""
    try:
        response = requests.get("https://pypi.org/pypi/lasso/json", timeout=5)
        data = response.json()
        return data['info']['version']
    except Exception as e:
        print(f"Error fetching latest version: {e}")
    return None

def update_lasso():
    """Update lasso to the latest stable release."""
    try:
        subprocess.run(
            [sys.executable, "-m", "pip", "install", "--upgrade", "lasso"],
            check=True
        )
        print("Lasso updated successfully!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error updating lasso: {e}")
        return False

def bootstrap():
    """Main bootstrap function."""
    installed = get_installed_version()
    latest = get_latest_stable_version()
    
    print(f"Installed version: {installed}")
    print(f"Latest stable version: {latest}")
    
    if installed and latest and installed != latest:
        print("Update available. Updating...")
        update_lasso()
    else:
        print("Lasso is up to date!")

if __name__ == "__main__":
    bootstrap()