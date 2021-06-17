### Add config
if [ -f ~/.exports.zsh ]; then
   source ~/.exports.zsh
fi

if [ -f ~/.aliases.zsh ]; then
   source ~/.aliases.zsh
fi

if [ -f ~/.functions.zsh ]; then
   source ~/.functions.zsh
fi

autoload -U colors
colors

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with investigating.
zinit load gko/ssh-connect
zinit load MichaelAquilina/zsh-you-should-use
zinit load srijanshetty/zsh-pip-completion
zinit load supercrabtree/k
zinit load trapd00r/zsh-syntax-highlighting-filetypes
zinit load zdharma/history-search-multi-word

# Load the pure theme, with zsh-async library that's bundled with it.
#zinit ice pick"async.zsh" src"pure.zsh"
#zinit light sindresorhus/pure

# Load OMZ Git library
zinit snippet OMZL::git.zsh

# Load Git plugin from OMZ
zinit snippet OMZP::common-aliases
zinit snippet OMZP::dotenv
zinit snippet OMZP::encode64
zinit snippet OMZP::extract
zinit snippet OMZP::git
zinit snippet OMZP::sublime
zinit snippet OMZP::sudo

zinit cdclear -q # <- forget completions provided up to this moment

setopt promptsubst

# Load theme from OMZ
zinit snippet OMZT::ys

# Load Plugin Prezto
#zinit snippet PZT::modules/utility
#zinit snippet PZT::modules/dpkg
#zinit snippet PZT::modules/helper

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS
