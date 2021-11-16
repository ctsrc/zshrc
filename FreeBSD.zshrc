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

PROMPT='%n@%m:%~ %# '

func gh () {
  url="$( echo "$1" | sed 's#^https://github.com/\(.*\)#git@github.com:\1.git#' )"
  git clone "$url"
}

func ghu () {
  # TODO: More robust
  user="$( echo "$1" | sed 's#^https://github.com/\([^/]*\)/.*#\1#' )"
  ghudir="$HOME/src/github.com/$user"
  [[ -d "$ghudir" ]] || mkdir -p "$ghudir"
  cd "$ghudir"
}

alias s="pkg search"
alias u="doas freebsd-update fetch && doas freebsd-update install; doas pkg update && doas pkg upgrade"
alias i="doas pkg install"

alias vim="nvim"
