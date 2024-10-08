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

func yts () {
  cd ~/yt-shorts/
  ts yt-dlp --write-subs --sub-langs all --add-metadata "$1"
}

func yt () {
  mkdir -p ~/youtube/
  cd ~/youtube/
  ts yt-dlp --write-subs --sub-langs all --add-metadata "$1"
}

func ghu () {
  # TODO: More robust
  user="$( echo "$1" | sed 's#^https://github.com/\([^/]*\)/.*#\1#' )"
  ghudir="$HOME/src/github.com/$user"
  [[ -d "$ghudir" ]] || mkdir -p "$ghudir"
  cd "$ghudir"
}

func gh () {
  if ! echo "$1" | egrep -q "^https://github.com" ; then
    echo "Not a GitHub URL." 1>&2
    return 1
  fi
  if ! echo "$1" | egrep -q "^https://github.com/[^/]+/.+" ; then
    echo "Not a GitHub repository URL." 1>&2
    return 1
  fi
  ghu "$1"
  #url="$( echo "$1" | sed -e 's#^https://github.com/\([^/]*\)/\([^/?#]*\).*#git@github.com:\1/\2#' -e 's#\.git$##' -e 's#$#.git#' )"
  url="$( echo "$1" | sed -e 's#^https://github.com/\([^/]*\)/\([^/?#]*\).*#https://github.com/\1/\2#' -e 's#\.git$##' -e 's#$#.git#' )"
  echo "$url"
  ts /usr/bin/env GIT_TERMINAL_PROMPT=0 git clone --bare "$url"
}

alias s="pkg search"
alias i="doas pkg install"
alias u="doas freebsd-update fetch && doas freebsd-update install; doas pkg update && doas pkg upgrade"

alias sr="screen -dUR"
alias sl="screen -list"

alias vim="nvim"

alias tsp="ts"

hname="$(hostname -f)"
if [ "$hname" = "blacksmith" ] ; then
  export PS1=$'\n'"%n@%m ⚒️  %~ "$'\n'"%# "
elif [ "$hname" = "fenris" ] ; then
  export PS1=$'\n'"%n@%m 🐺 %~ "$'\n'"%# "
elif [ "$hname" = "de3" ] ; then
  export PS1=$'\n'"%n@%m 🌭 %~ "$'\n'"%# "
elif [ "$hname" = "de2" ] ; then
  export PS1=$'\n'"%n@%m 🍻 %~ "$'\n'"%# "
elif [ "$hname" = "de1" ] ; then
  export PS1=$'\n'"%n@%m 🇩🇪  %~ "$'\n'"%# "
elif [ "$hname" = "lynyrd" ] ; then
  export PS1=$'\n'"%n@%m ⚡ %~ "$'\n'"%# "
elif [ "$hname" = "login.nstr.no" ] ; then
  export PS1=$'\n'"%n@%m ⛩️  %~ "$'\n'"%# "
else
  export PS1=$'\n'"%n@%m (?) %~ "$'\n'"%# "
fi

# Begin atuin section
#
autoload -U add-zsh-hook

export ATUIN_SESSION=$(atuin uuid)
export ATUIN_HISTORY="atuin history list"

_atuin_preexec() {
    local id
    id=$(atuin history start -- "$1")
    export ATUIN_HISTORY_ID="$id"
}

_atuin_precmd() {
    local EXIT="$?"

    [[ -z "${ATUIN_HISTORY_ID}" ]] && return

    (RUST_LOG=error atuin history end --exit $EXIT -- $ATUIN_HISTORY_ID &) >/dev/null 2>&1
}

_atuin_search() {
    emulate -L zsh
    zle -I

    # Switch to cursor mode, then back to application
    echoti rmkx
    # swap stderr and stdout, so that the tui stuff works
    # TODO: not this
    # shellcheck disable=SC2048
    output=$(RUST_LOG=error atuin search $* -i -- $BUFFER 3>&1 1>&2 2>&3)
    echoti smkx

    if [[ -n $output ]]; then
        RBUFFER=""
        LBUFFER=$output
    fi

    zle reset-prompt
}

_atuin_up_search() {
    _atuin_search --shell-up-key-binding
}

add-zsh-hook preexec _atuin_preexec
add-zsh-hook precmd _atuin_precmd

zle -N _atuin_search_widget _atuin_search
zle -N _atuin_up_search_widget _atuin_up_search

bindkey '^r' _atuin_search_widget
bindkey '^[[A' _atuin_up_search_widget
bindkey '^[OA' _atuin_up_search_widget
#
# End atuin section
