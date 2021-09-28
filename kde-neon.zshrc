# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt beep nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

. "$HOME/.cargo/env"

export EDITOR=vim

alias screen="systemd-run --scope --user screen"
alias sr="screen -dUR"
alias sl="screen -list"

alias s="apt search"
alias u="sudo apt-get update && sudo pkcon update"
alias i="sudo apt install"
