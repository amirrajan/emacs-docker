export ZSH="$HOME/.oh-my-zsh/"
ZSH_THEME="amirrajan"

export PATH="$HOME/.cargo:$PATH"
export HOST_IP="$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')"

DISABLE_UNTRACTED_FILES_DIRTY="true"

SAVEHIST=10000
HISTFILE=~/.zsh_history

plugins=(git colored-man-pages)

source $ZSH/oh-my-zsh.sh

alias v="emacs -nw"
alias t="tmux"
alias e="exit"
alias b="cd .."
alias ga="git add -A && git status"
alias gs="git status && ls *.patch"
alias gm="git commit -m"
alias ft="git add -A && git reset --hard head"
alias r=reset
alias c=clear

set -o vi

# =====================
# vi mode
# =====================
bindkey -v
export KEYTIMEOUT=1

# =====================
# Change cursor shape for different vi modes.
# =====================
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# =========================
# yank to clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# =====================
# ctrl+f does fzf
# =====================
# fzf-file-search() {
#   item="$(find '/' -type d \( -path '/proc/*' -o -path '/dev/*' \) -prune -false -o -iname '*' 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --rev    erse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@")"
#   if [[ -d ${item} ]]; then
#     cd "${item}" || return 1
#   elif [[ -f ${item} ]]; then
#     (vi "${item}" < /dev/tty) || return 1
#   else
#     return 1
#   fi
#    zle accept-line
# }
# zle     -N   fzf-file-search

# have to eval fzf after enabling vi mode
# source <(fzf)

bindkey -s '^f' 'cd **\t'
bindkey -a '^g' vi-insert
bindkey -s '^e' "ls | fzf | xargs -n1 -I{} sh -c './{}'"
bindkey -s '^b' 'sh **\t'
