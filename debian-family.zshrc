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

func yt () {
  mkdir -p ~/youtube/
  cd ~/youtube/
  yt-dlp "$1"
}

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

alias s="apt search"
alias i="sudo apt install"
alias u="sudo apt-get update && sudo pkcon update"

alias screen="systemd-run --scope --user screen"
alias sr="screen -dUR"
alias sl="screen -list"

alias vim="nvim"

hname="$(hostname -f)"
if [ "$hname" = "cascade-delight" ] ; then
  export PS1="%n@%m 💦 %~ %# "
elif [ "$hname" = "minitower" ] ; then
  export PS1="%n@%m 🗼 %~ %# "
elif [ "$hname" = "displaydude" ] ; then
  export PS1="%n@%m 🖥  %~ %# "
elif [ "$hname" = "rough" ] ; then
  export PS1="%n@%m 🥺 %~ %# "
else
  export PS1="%n@%m (?) %~ %# "
fi
