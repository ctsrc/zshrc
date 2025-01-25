export XDG_RUNTIME_DIR=/var/run/user/`id -u`
export XDG_CONFIG_HOME="$HOME/.config"
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR=vim
