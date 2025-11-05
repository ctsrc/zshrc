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
  mkdir -p ~/yt-shorts3/
  cd ~/yt-shorts3/
  tsp "$HOME/.pyenv/shims/yt-dlp" --add-metadata "$1"
}

func yt () {
  mkdir -p ~/youtube6/
  cd ~/youtube6/
  tsp "$HOME/.pyenv/shims/yt-dlp" --add-metadata "$1"
}

func ghu () {
  echo "Wrong machine, mate." 1>&2
}

func gh () {
  echo "Wrong machine, mate." 1>&2
}

func htu () {
  # TODO: More robust
  user="$( echo "$1" | sed 's#^https://\(git\.\)\?sr.ht/~\([^/]*\)/.*#\2#' )"
  htudir="$HOME/src/sr.ht/$user"
  [[ -d "$htudir" ]] || mkdir -p "$htudir"
  cd "$htudir"
}

func ht () {
  htu "$1"
  #url="$( echo "$1" | sed 's#^https://\(git\.\)\?sr.ht/~\(.*\)#git@git.sr.ht:~\2#' )"
  url="$( echo "$1" | sed 's#^https://\(git\.\)\?sr.ht/~\([^/]*\)/\([^/]*\).*#https://git.sr.ht/~\2/\3#' )"
  git clone --bare "$url"
}

alias s="apt search"
alias i="sudo apt install"
alias u="sudo apt-get update && sudo pkcon update || sudo apt-get upgrade"

alias sr="systemd-run --scope --user screen -dUR"
alias sl="screen -list"

alias vim="nvim"

hname="$(hostname -s)"
if [ "$hname" = "displaydude" ] ; then
  export PS1=$'\n'"%n@%m 🖥  %~ "$'\n'"%# "
elif [ "$hname" = "blixen" ] ; then
  export PS1=$'\n'"%n@%m 🐎 %~ "$'\n'"%# "
elif [ "$hname" = "rough" ] ; then
  export PS1=$'\n'"%n@%m 🥺 %~ "$'\n'"%# "
elif [ "$hname" = "hoover" ] ; then
  export PS1=$'\n'"%n@%m 🧹 %~ "$'\n'"%# "
elif [ "$hname" = "cascade-delight" ] ; then
  export PS1=$'\n'"%n@%m 💦 %~ "$'\n'"%# "
elif [ "$hname" = "minitower" ] ; then
  export PS1=$'\n'"%n@%m 🗼 %~ "$'\n'"%# "
else
  export PS1=$'\n'"%n@%m (?) %~ "$'\n'"%# "
fi

# We use a host-specific committer name,
# paired with our author name.
if (( ${+SSH_CLIENT} )); then
  # Looking at $SSH_CLIENT is not perfect. There are some cases
  # where spawning a new shell will not have $SSH_CLIENT set in
  # the spawned shell. But for most cases it's good enough for now.
  export GIT_COMMITTER_NAME="Committed from host ${hname} via remote ssh session"
else
  export GIT_COMMITTER_NAME="Locally committed from host ${hname}"
fi
export GIT_COMMITTER_EMAIL="${USER}@${hname}"
export GIT_AUTHOR_NAME="Erik Nordstrøm"
export GIT_AUTHOR_EMAIL="erik@nordstroem.no"

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

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
. "/home/erikn/.deno/env"
