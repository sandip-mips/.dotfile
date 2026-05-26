# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH=$PATH:~/.local/go/bin
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Ctrl+B: fzf search through ~/.command_bookmarks, paste selection to command line
# Format: each bookmark starts with `#name` (no space after #); following lines
# are the command, until the next `#name`. Trailing whitespace is trimmed.
__fzf_bookmark_widget() {
  local file="$HOME/.command_bookmarks"
  [[ -f $file ]] || return 0
  local picked
  picked=$(awk '
    function flush(   flat, pad) {
      if (name != "") {
        sub(/[ \t\n]+$/, "", body)
        flat = body
        gsub(/[\n\\]/, " ", flat)
        gsub(/  +/, " ", flat)
        pad = sprintf("%300s", "")
        printf "%s\t%s%s\t%s%c", name, pad, flat, body, 0
      }
      name = ""; body = ""
    }
    /^#[^[:space:]]/ { flush(); name = substr($0, 2); next }
    name != "" {
      if ($0 ~ /^[[:space:]]*$/ && body == "") next
      body = (body == "" ? $0 : body "\n" $0)
    }
    END { flush() }
  ' "$file" \
        | fzf --read0 -d $'\t' --with-nth=1,2 --nth=1,2 \
          --height=40% --reverse --prompt='bookmark> ' --tiebreak=index \
          --preview='printf "%s\n" {3..}' --preview-window=down:5:wrap) || return 0
  [[ -z $picked ]] && return 0
  local rest="${picked#*$'\t'}"
  local cmd="${rest#*$'\t'}"
  local left="${READLINE_LINE:0:$READLINE_POINT}"
  local right="${READLINE_LINE:$READLINE_POINT}"
  READLINE_LINE="${left}${cmd}${right}"
  READLINE_POINT=$(( ${#left} + ${#cmd} ))
}
bind -x '"\C-b": __fzf_bookmark_widget' 2>/dev/null
