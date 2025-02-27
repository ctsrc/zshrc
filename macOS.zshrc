# Lines configured by zsh-newuser-install
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

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
#	. "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
#    else
#	export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<

#
# PATH
#

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
# OpenJDK from Homebrew
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# Curl from Homebrew
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
# Python
export PATH="$HOME/Library/Python/3.12/bin:$PATH"
# Golang
export PATH="$HOME/go/bin:$PATH"
# Rust
export PATH="$HOME/.cargo/bin:$PATH"
# Pyenv
if /usr/bin/which -s pyenv ; then
  export PATH="$(pyenv root)/shims:$PATH"
fi
# Host- and/or user-specific programs and scripts
export PATH="$HOME/bin:$PATH"

#
# End of PATH
#

func ghu () {
  echo "Wrong machine, mate." 1>&2
}

func gh () {
  echo "Wrong machine, mate." 1>&2
}

hname="$(hostname -f)"
if [ "$hname" = "nova.local" ] ; then
  export PS1=$'\n'"%n@%m 🌟 %~ "$'\n'"%# "
elif [ "$hname" = "milkyway" ] ; then
  export PS1=$'\n'"%n@%m 🌌 %~ "$'\n'"%# "
else
  export PS1=$'\n'"%n@%m (?) %~ "$'\n'"%# "
fi

#export ALL_PROXY=http://10.69.69.1:3128
#export ALL_PROXY=http://192.168.1.15:3128
#export CURL_CA_BUNDLE=/opt/homebrew/etc/ca-certificates/cert.pem
#export HOMEBREW_CURLRC=1

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
