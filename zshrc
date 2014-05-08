# Configuring environment: {{{1
#--------------------------
. /etc/profile

export PAGER="less"
export EDITOR="vim"
export USECOLOR="yes"


# History: {{{1
#----------
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory extendedglob nomatch notify
setopt append_history inc_append_history share_history extended_history
# Ignore duplicates
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups
# Don't save meaningless blanks
setopt hist_reduce_blanks
# Don't store history commands
setopt hist_no_store
# 1}}}

# Shell Options: {{{1
#----------------
# Disabling bell 
unsetopt beep
# Correct misspelled commands
setopt correct
# "in-word-completion"
setopt complete_in_word
# Extended globbing
setopt extendedglob
# Load zsh builtin functions
autoload zmv # Powerful file moving
autoload zcp # copying and
autoload zln # linking
# Vi-like commandline editing
bindkey -v
# 1}}}

# Completion settings: {{{1
#----------------------
autoload -Uz compinit
compinit
# Describe options
zstyle ':completion:*:options'         description 'yes'
# On processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'
# Provide verbose completion information
zstyle ':completion:*'                 verbose true
# Set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
# Complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:man:*'      menu yes select
# Always complete PIDs with menu
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
# 1}}}

# Configure Prompt: {{{1
#-------------------
autoload -U colors
colors

COLOR="yellow"
PROMPT="%F{black}%K{white}%n@%m%f%k %B%F{white}%D{%a, %d. %B} %D{%H:%M:%S}%b%f
%B%F{$COLOR}%K{black}%~/ %b%f%k"
PROMPT2="%B%F{yellow}%K{black} > %b%f%k"
# 1}}}

# Keybindings: {{{1
#--------------
# Vi-insert mode
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
		printf '%s' "${terminfo[smkx]}"
	}
	function zle-line-finish () {
		printf '%s' "${terminfo[rmkx]}"
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

bindkey '^H' run-help # Ctrl +'H' gives manpage of current command

# Show only entries in history beginning with command typed so far
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# Run command line as root via sudo:
sudo-command-line() {
    [[ $BUFFER != sudo\ * ]] && LBUFFER="sudo $LBUFFER"
}
watch-command-line() {
    [[ $BUFFER != watch\ * ]] && LBUFFER="watch $LBUFFER"
}
zle -N sudo-command-line
bindkey "^B" sudo-command-line
zle -N watch-command-line
bindkey "" watch-command-line
# 1}}}

# Aliases: {{{1
#----------
# ls aliases
alias ls="ls --color=auto"
alias ll="ls --color=auto -lh"
alias la="ls --color=auto -lhA"

# No-correction aliases
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rm='nocorrect rm'

alias cdtmp='cd $(mktemp -d)'

# Filetype suffix aliases
alias -s tex=vim
alias -s html=elinks
# Web suffix aliases
alias -s org=elinks
alias -s net=elinks
alias -s com=elinks
alias -s de=elinks
# 1}}}

# vim: fdm=marker
