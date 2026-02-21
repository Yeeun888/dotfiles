# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# MACOS SPECIFICS - START ----------------------
if [[ "$OSTYPE" == darwin* ]]; then
    source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
    export PATH="/opt/homebrew/lib/python3.10/site-packages:$PATH"
    export PATH="$PATH:/opt/gradle/gradle-8.5/bin"
    export PATH="$PATH:/Users/ner0/.local/bin"
    export HOMEBREW_NO_AUTO_UPDATE=1
fi
# MACOS SPECIFICS - END ------------------------

# LINUX SPECIFICS - START -----------------
if [[ "$OSTYPE" == linux* ]]; then
    # ROS SHIT
    source /opt/ros/humble/setup.zsh                  # Add ROS as source
    export ROS_DOMAIN_ID=1                            # Based on ROS Documentation  
    source /usr/share/colcon_cd/function/colcon_cd.sh # ROS Package build
    export _colcon_cd_root=/opt/ros/humble/

    export PATH="/home/ner0/.local/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH=$PATH:/usr/local/go/bin
fi
# LINUX SPECIFICS - END   -----------------

alias nvim="bob run v0.11.0"

alias pip=pip3
alias python=python3

eval "$(zoxide init zsh)"
alias cd="z"
alias ls="eza --icons=always"

# Useful Commands :3

# <name> untar          -> Extracts into <name> directory
# <name> untar dir_name -> Extracts into dir_name directory
untar() {
  if [[ -z "$1" ]]; then
    echo "Usage: untar <archive.tar[.gz|.bz2|.xz]> [target_folder]"
    return 1
  fi

  archive="$1"
  target="$2"

  # If no target supplied, strip extensions from archive name
  if [[ -z "$target" ]]; then
    target="${archive%.tar.*}"   # handles .tar.gz, .tar.bz2, .tar.xz
    target="${target%.tar}"      # handles plain .tar
  fi

  mkdir -p "$target" || return 1
  tar -xvf "$archive" -C "$target"
}

# tree <level>      -> Generates a tree of depth <level>
# tree <path> <level> -> Generates a tree of depth <level> for <path>
tree() {
  if [[ -z "$1" ]]; then
    echo "Usage: tree <LEVEL>"
    return 1
  fi

  if [[ $# -eq 1 ]]; then
    eza --icons=always --tree --level="$1"
    return 1;
  elif [[ $# -eq 2 ]]; then 
    eza "$1" --icons=always --tree --level="$2"
    return 1;
  fi
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Enable timestamps in history (required for relative time display in Ctrl+R)
# INC_APPEND_HISTORY_TIME writes after command finishes for accurate timestamps
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME

# fzf shell integration (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# Override fzf history widget to show relative time instead of entry numbers
fzf-history-widget() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
  selected=$(fc -rl -t '%s' 1 2>/dev/null | awk -v now="$(date +%s)" -v tz="$(date +%z)" '
    BEGIN {
      sign   = (substr(tz,1,1) == "-") ? -1 : 1
      tz_off = sign * (substr(tz,2,2)*3600 + substr(tz,4,2)*60)
    }
    {
      num = $1; epoch = $2
      cmd = $0; sub(/^ *[0-9]+ +[0-9]+ +/, "", cmd)
      if (seen[cmd]++) next
      diff = now - epoch
      if (epoch == 0) {
        ago = "?"
      } else if (diff < 0) {
        ago = "+" int(-diff/86400) "d"
      } else if (diff < 72000) {
        loc = epoch + tz_off
        h   = int(loc % 86400 / 3600)
        m   = int(loc % 3600  / 60)
        ago = sprintf("%02d:%02d", h, m)
      } else {
        ago = int(diff/86400) "d"
      }
      printf "%s\t%-8s%s\n", num, ago, cmd
    }
  ' | FZF_DEFAULT_OPTS=$(__fzf_defaults "" "--scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '\t↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m") fzf --delimiter=$'\t' --with-nth=2 --nth=2)
  local ret=$?
  if [[ -n "$selected" ]]; then
    local num
    num=$(cut -f1 <<< "$selected")
    [[ -n "$num" ]] && zle vi-fetch-history -n "$num"
  fi
  zle reset-prompt
  return $ret
}
