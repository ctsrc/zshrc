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

zmodload zsh/datetime

func yts () {
  cd ~/yt-shorts/
  TS_MAXFINISHED=10000 /usr/local/bin/ts yt-dlp --write-subs --add-metadata "$1"
}

func yt () {
  mkdir -p ~/youtube/
  cd ~/youtube/
  TS_MAXFINISHED=10000 /usr/local/bin/ts yt-dlp --write-subs --add-metadata "$1"
}

func ghu () {
  # Always go to gh repos dir, regardless of whether args are valid.
  cd "${HOME}/src/github.com/repos/"

  if ! echo "$1" | egrep -q "^https://github.com" ; then
    echo "Not a GitHub URL." 1>&2
    return 1
  fi
  if ! echo "$1" | egrep -q "^https://github.com/[^/]+/.+" ; then
    echo "Not a GitHub repository URL." 1>&2
    return 1
  fi
  ghuser="$( echo "$1" | sed -e 's#^https://github.com/\([^/]*\)/\([^/?#]*\).*#\1#' )"
  ghudir="${HOME}/src/github.com/repos/${ghuser}"
  [[ -d "${ghudir}" ]] || mkdir -p "${ghudir}"
  cd "$ghudir"
}

func ghn () {
  ghuser="$1"
  ghrepo="$2"
  echo "Cloning new repo, not previously seen 🌱" 1>&2
  if [[ -z "${ghuser}" ]] ; then
    echo "Error: GitHub username argument not provided" 1>&2
    return 1
  fi
  if [[ -z "${ghrepo}" ]] ; then
    echo "Error: GitHub repo name argument not provided" 1>&2
    return 1
  fi
  if ! [[ "${ghrepo}" == *.git ]] ; then
    echo "Error: GitHub repo name must include '.git' suffix" 1>&2
    return 1
  fi
  url="https://github.com/${ghuser}/${ghrepo}"
  wdir="$( mktemp -d -p /src/github.com/tmp/ )"
  cd "${wdir}"
  TS_MAXFINISHED=10000 /usr/local/bin/ts -L "${ghuser}/${ghrepo}" /usr/bin/env GIT_TERMINAL_PROMPT=0 zsh -c "git clone --bare '$url' && rm -rf '${HOME}/src/github.com/repos/${ghuser}/${ghrepo}' && mv '${ghrepo}' '${HOME}/src/github.com/repos/${ghuser}/${ghrepo}' && cd && rmdir '${wdir}'"
  cd "${HOME}/src/github.com/repos/${ghuser}/"
}

func ghx () {
  ghuser="$1"
  ghrepo="$2"
  echo "Fetching changes for already cloned repo 🚰" 1>&2
  if [[ -z "${ghuser}" ]] ; then
    echo "Error: GitHub username argument not provided" 1>&2
    return 1
  fi
  if [[ -z "${ghrepo}" ]] ; then
    echo "Error: GitHub repo name argument not provided" 1>&2
    return 1
  fi
  if ! [[ "${ghrepo}" == *.git ]] ; then
    echo "Error: GitHub repo name must include '.git' suffix" 1>&2
    return 1
  fi
  cd "${HOME}/src/github.com/repos/${ghuser}/${ghrepo}/" || return 1
  TS_MAXFINISHED=10000 /usr/local/bin/ts -L "${ghuser}/${ghrepo}" /usr/bin/env GIT_TERMINAL_PROMPT=0 zsh -c "git fetch origin '+refs/heads/*:refs/heads/*' '+refs/tags/*:refs/tags/*' --prune"
}

func gh () {
  # Always go to gh repos dir, regardless of whether args are valid.
  cd "${HOME}/src/github.com/repos/"

  if ! echo "$1" | egrep -q "^https://github.com" ; then
    echo "Not a GitHub URL." 1>&2
    return 1
  fi
  if ! echo "$1" | egrep -q "^https://github.com/[^/]+/.+" ; then
    echo "Not a GitHub repository URL." 1>&2
    return 1
  fi
  if [[ "$( hostname )" != "de1" ]] ; then
    echo "Wrong host?" 1>&2
    return 1
  fi
  ghu "$1"
  url="$( echo "$1" | sed -e 's#^https://github.com/\([^/]*\)/\([^/?#]*\).*#https://github.com/\1/\2#' -e 's#\.git$##' -e 's#$#.git#' )"
  ghuser="$( echo "${url}" | sed -e 's#^https://github.com/\([^/]*\)/\([^/?#]*\)$#\1#' )"
  ghrepo="$( echo "${url}" | sed -e 's#^https://github.com/\([^/]*\)/\([^/?#]*\)$#\2#' )"
  echo "${url}"
  echo "${ghuser}"
  echo "${ghrepo}"
  test -d "${ghrepo}" && ghx "${ghuser}" "${ghrepo}" || ghn "${ghuser}" "${ghrepo}"
}

alias s="pkg search"
alias i="doas pkg install"
alias u="doas freebsd-update fetch && doas freebsd-update install; doas pkg update && doas pkg upgrade"

alias sr="screen -dUR"
alias sl="screen -list"

alias vim="nvim"

alias tsp="/usr/local/bin/ts"

alias t="tmux a || tmux"

preexec() {
  printf "\033[47m\033[30m%s\033[0m\n" "$(strftime '%a %b %d %T %Z %Y')"
}
precmd() {
  printf "\033[47m\033[30m%s\033[0m\n" "$(strftime '%a %b %d %T %Z %Y')"
}
ps1_host_symbol='(?)'
hname="$( hostname -s )"
if [ "$hname" = "de1" ] ; then
  ps1_host_symbol='🇩🇪 '
elif [ "$hname" = "de2" ] ; then
  ps1_host_symbol='🍻'
elif [ "$hname" = "login.nstr.no" ] ; then
  ps1_host_symbol='⛩️'
elif [ "$hname" = "blacksmith" ] ; then
  ps1_host_symbol='⚒️'
elif [ "$hname" = "lynyrd" ] ; then
  ps1_host_symbol='⚡'
elif [ "$hname" = "fenris" ] ; then
  ps1_host_symbol='🐺'
fi
export PS1=$'\n'"%F{green}%n@%f%F{blue}%m%f ${ps1_host_symbol} %F{cyan}%~%f "$'\n'"%K{60}%# "
export POSTEDIT=$'\e[0m\e[K'

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
