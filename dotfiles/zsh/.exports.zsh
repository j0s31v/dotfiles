#
export CASE_SENSITIVE="true"
#
export DISABLE_UNTRACKED_FILES_DIRTY="true"
#
export DISABLE_LS_COLORS="false"
#
export DISABLE_AUTO_TITLE="true"
#
export COMPLETION_WAITING_DOTS="true"
#
export HIST_STAMPS="dd.mm.yyyy"
#
export HISTFILE=~/.zsh_history
# big big history
export HISTSIZE=999999999
# big big history         
export HISTFILESIZE=100000
#
export SAVEHIST=$HISTSIZE

# Save and reload the history after each command finishes
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
#                      
#setopt share_history
