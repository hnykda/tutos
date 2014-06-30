# Path to your oh-my-zsh installation.
DISABLE_AUTO_UPDATE="true"
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="gentoo"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git screen django history dirhistory pip )

source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:/usr/local/bin:$PATH

# System aliases
alias trem="transmission-remote 9998"
alias mv="mv -i"
alias cp="cp -i --preserve=all"
alias rm="rm -i"
alias du="du -h"
alias df="df -h"
alias grep="egrep"
alias ls='ls --color=auto --human-readable --group-directories-first --classify'
alias ll="ls -l --color=auto --human-readable --group-directories-first --classify"
rsync_push() {
    rsync -r -v --progress -e ssh "$*" dan@192.168.0.22:/mnt/tmp
}

# Not all servers have terminfo for rxvt-256color. :<
if [ "${TERM}" = 'rxvt-256color' ] && ! [ -f '/usr/share/terminfo/r/rxvt-256color' ] && ! [ -f '/lib/terminfo/r/rxvt-256color' ] && ! [ -f "${HOME}/.terminfo/r/rxvt-256color" ]; then
    export TERM='rxvt-unicode'
fi

# Ignore duplicates in history
setopt HIST_IGNORE_DUPS

SAVEHIST="10000"
HISTSIZE="10000"
HISTFILE="${HOME}/.zsh_history"

#Completition and it's style
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

# Complete aliases
setopt completealiases

export PATH=/usr/local/bin:/usr/bin:/root/scripts
export EDITOR=/usr/bin/vim

if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
    eval $(dircolors ~/.dircolors.256colors)
elif [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi

# Globing
setopt extended_glob

bindkey '^R' history-incremental-search-backward

