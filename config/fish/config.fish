if status is-interactive
# Commands to run in interactive sessions can go here
starship init fish | source

# Ctrl+B: fzf search through ~/.command_bookmarks, paste selection to command line
# Format: each bookmark starts with `#name` (no space after #); following lines
# are the command, until the next `#name`. Trailing whitespace is trimmed.
function __fzf_bookmark_widget
    set -l file "$HOME/.command_bookmarks"
    test -f $file; or return 0

    set -l picked (awk '
        function flush(   flat, pad) {
          if (name != "") {
            sub(/[ \t\n]+$/, "", body)
            flat = body
            gsub(/\n/, " ", flat)
            gsub(/  +/, " ", flat)
            pad = sprintf("%300s", "")
            printf "%s\t%s%s\t%s%c", name, pad, flat, body, 0
          }
          name = ""
          body = ""
        }
        /^#[^[:space:]]/ {
          flush()
          name = substr($0, 2)
          next
        }
        name != "" {
          if ($0 ~ /^[[:space:]]*$/ && body == "") {
            next
          }
          body = (body == "" ? $0 : body "\n" $0)
        }
        END {
          flush()
        }
    ' "$file" \
        | fzf --read0 -d \t --nth=1,2 --with-nth=1,2 +x \
            --height=40% --reverse --prompt='bookmark> ' --tiebreak=index \
            --preview='printf "%s\n" {3..}' --preview-window=down:5:wrap \
        | string collect)

    test -n "$picked"; or begin
        commandline -f repaint
        return 0
    end

    set -l cmd (string split -m2 \t -- $picked)[3]
    commandline -i -- $cmd
    commandline -f repaint
end
bind \cb __fzf_bookmark_widget
end
