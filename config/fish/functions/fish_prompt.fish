function fish_prompt
    set -l last_status $status

    # Blank line before prompt for clean separation
    echo ""

    # Line 1: Absolute directory path in #8c909e
    set_color 8c909e
    echo -n $PWD

    # Git branch and status in #656977
    set_color 656977
    fish_git_prompt "  · %s"

    echo ""

    # Line 2: Glyph ❯ in #656977 (or soft muted red #837f7f on error)
    if test $last_status -eq 0
        set_color 656977
    else
        set_color 837f7f
    end
    echo -n "> "

    set_color normal
end
