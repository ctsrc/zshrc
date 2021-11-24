# `~/.zshrc`

This is my `~/.zshrc` for various systems.

## Prerequisities for aliases

### macOS

* `s`, `i`, `u`: Install homebrew from https://brew.sh/
   in order to use these aliases.

* `vim`: Install the `neovim` package from homebrew
   in order to use this alias.

### FreeBSD

* `vim`: Install the `neovim` package
   in order to use this alias.

### KDE Neon, Ubuntu, Debian, etc

* `vim`: Install the `neovim` package
   in order to use this alias.

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
ln -s src/zshrc/FreeBSD.zshrc  ~/.zshrc
ln -s src/zshrc/FreeBSD.zshenv ~/.zshenv
```

#### Linux

##### KDE Neon, Ubuntu, Debian, etc

```zsh
ln -s src/zshrc/debian-family.zshrc  ~/.zshrc
ln -s src/zshrc/debian-family.zshenv ~/.zshenv
```
