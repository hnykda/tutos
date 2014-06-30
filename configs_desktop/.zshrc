# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="gentoo"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git virtualenvwrapper screen django history dirhistory pip)

source $ZSH/oh-my-zsh.sh
DISABLE_AUTO_UPDATE=true

# System aliases
alias _="sudo"
alias reboot="systemctl reboot"
alias suspend="systemctl suspend"
alias mv="mv -i"
alias cp="cp -i --preserve=all"
alias rm="rm -i"
alias du="du -h"
alias df="df -h"
alias grep="egrep -i"
alias ls='ls --color=auto --human-readable --group-directories-first --classify'
alias ll="ls -l --color=auto --human-readable --group-directories-first --classify"
alias netauto_restart='sudo systemctl restart netctl-auto@wlp1s0.service;rfkill unblock wifi'


alias ssh_smecpi="ssh smecpi -t screen -dRUS mainS"
alias ssh_smecpi_out="ssh smecpi_out -t screen -dRUS mainS"


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

# create a zkbd compatible hash;
source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# Arrow keys for history
#[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
#[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

export PATH=/usr/local/bin:/usr/bin:/usr/local/texlive/2012/bin/x86_64-linux:/home/dan/prac/scripts
export EDITOR=/usr/bin/vim

if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
    eval $(dircolors ~/.dircolors.256colors)
elif [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi

# Globing
setopt extended_glob

bindkey '^R' history-incremental-search-backward

