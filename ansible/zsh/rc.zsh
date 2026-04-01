export PATH="$HOME/.local/bin:$PATH"

FPATH="$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH"
autoload -Uz compinit && compinit

eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(oh-my-posh init zsh --config "$(brew --prefix oh-my-posh)/themes/atomic.omp.json")"

source "${0:A:h}/functions.zsh"
