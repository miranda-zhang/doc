# Watchman
`sudo apt install watchman` only install an old version, 
to install the latest use `brew`
```sh
# Install prerequisites
sudo apt update
sudo apt install -y build-essential procps curl file git
suod apt --fix-broken install -y
# Install Homebrew (Linuxbrew)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# follow instructions from brew to add it to your PATH
brew update

brew install watchman
watchman --version
```
