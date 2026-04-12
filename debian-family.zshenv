export EDITOR=vim

# golang
export GOPATH=$HOME/go
test -d $GOPATH && export PATH=$PATH:$GOPATH/bin

test -f "$HOME/.cargo/env" && source "$HOME/.cargo/env"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
