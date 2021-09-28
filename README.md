# `~/.zshrc`

This is my `~/.zshrc` for various systems.

## Installation

### Step 1: Clone repo

Clone repo to `~/src/zshrc`:

```zsh
cd
mkdir -p ~/src/
cd ~/src/
git clone git@github.com:ctsrc/zshrc.git
```

### Step 2: Symlinks

#### macOS

```zsh
ln -s src/zshrc/macOS.zshrc  ~/.zshrc
ln -s src/zshrc/macOS.zshenv ~/.zshenv
```

#### FreeBSD

```zsh
ln -s src/zshrc/FreeBSD.zshrc ~/.zshrc
```

#### Linux

##### KDE Neon User Edition

```zsh
ln -s src/zshrc/kde-neon.zshrc ~/.zshrc
```
