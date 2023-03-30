# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
setopt beep nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

func ghu () {
  # TODO: More robust
  user="$( echo "$1" | sed 's#^https://github.com/\([^/]*\)/.*#\1#' )"
  ghudir="$HOME/src/github.com/$user"
  [[ -d "$ghudir" ]] || mkdir -p "$ghudir"
  cd "$ghudir"
}

func gh () {
  ghu "$1"
  url="$( echo "$1" | sed 's#^https://github.com/\(.*\)#git@github.com:\1.git#' )"
  git clone "$url"
}

alias s="pkg search"
alias i="doas pkg install"
alias u="doas freebsd-update fetch && doas freebsd-update install; doas pkg update && doas pkg upgrade"

alias sr="screen -dUR"
alias sl="screen -list"

alias vim="nvim"

hname="$(hostname -f)"
if [ "$hname" = "login.nstr.no" ] ; then
  export PS1="%n@%m ⛩️  %~ %# "
elif [ "$hname" = "quetzal.infra.nstr.no" ] ; then
  export PS1="%n@%m 🐦 %~ %# "
else
  export PS1="%n@%m (?) %~ %# "
fi
