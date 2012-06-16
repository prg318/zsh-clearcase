# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size and updated it after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x /usr/bin/lesspipe.sh ]; then
    eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

# Force color terminal
TERM=xterm-256color

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-*color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Set color escape codes
if [ "$color_prompt" = yes ]; then
    intensity=00 # 00: normal, 01: bold, 02: faint
    black="\[\033[$intensity;30m\]"
    red="\[\033[$intensity;31m\]"
    green="\[\033[$intensity;32m\]"
    yellow="\[\033[$intensity;33m\]"
    blue="\[\033[$intensity;34m\]"
    magenta="\[\033[$intensity;35m\]"
    cyan="\[\033[$intensity;36m\]"
    white="\[\033[$intensity;37m\]"
    reset="\[\033[00m\]"
fi

# Username prompt setup
PS1_USER="$green\u$reset"

# Hostname prompt setup
PS1_HOSTNAME="$yellow\h$reset"

# Git prompt setup (set branch name & status)
if [ -f $HOME/.bash-git ]; then
    . $HOME/.bash-git
    PS1_GIT='$(__git_ps1 :%s)'
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
fi

PS1="${PS1_USER}@${PS1_HOSTNAME}${PS1_GIT}> "

unset intensity black red green yellow blue magenta cyan white reset
unset color_prompt force_color_prompt

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto -F"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
    alias cgrep="coccigrep --color"
else
    alias ls="ls -F"
    alias cgrep="coccigrep"
fi

# Alias definitions
if [ -f ~/.bash-aliases ]; then
    . ~/.bash-aliases
fi

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export CSCOPE_EDITOR="vim"

export EDITOR="vim"

export INPUTRC="$HOME/.inputrc"

export MANPATH="$HOME/.local/man:$MANPATH"

export PATH="$HOME/.local/bin:/opt/local/bin:$PATH"

export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:/opt/local/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"

export PYTHONPATH="$HOME/.local/lib/python"

unset command_not_found_handle

ulimit -c unlimited

# vim: et:sw=4:ts=4
