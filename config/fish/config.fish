# ==========================================================
# Fish Shell Configuration
# Nordic Grayscale Palette & Studio Minimalism
# ==========================================================

# Disable welcome greeting
set -g fish_greeting ""

# Keep readable directory names in prompt (e.g. ~/projects/foo instead of ~/p/foo)
set -g fish_prompt_pwd_dir_length 0

# Git prompt formatting
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_char_dirtystate "*"
set -g __fish_git_prompt_char_stagedstate "+"
set -g __fish_git_prompt_color_branch 656977
set -g __fish_git_prompt_color_dirtystate 8c909e
set -g __fish_git_prompt_color_stagedstate d6d6d6

# 97% Desaturated Nordic Grayscale Syntax Highlighting
set -g fish_color_normal d6d6d6
set -g fish_color_command d6d6d6 --bold
set -g fish_color_keyword 8c909e
set -g fish_color_quote 9ba09c
set -g fish_color_redirection 8c909e
set -g fish_color_end 656977
set -g fish_color_error 837f7f
set -g fish_color_param 8c909e
set -g fish_color_comment 656977
set -g fish_color_selection --background=282828
set -g fish_color_search_match --background=282828
set -g fish_color_operator 8c909e
set -g fish_color_escape 8c909e
set -g fish_color_autosuggestion 555555
set -g fish_color_cancel 837f7f

# Pager (Tab completion popup)
set -g fish_pager_color_prefix d6d6d6 --bold
set -g fish_pager_color_completion 8c909e
set -g fish_pager_color_description 656977
set -g fish_pager_color_selected_background --background=282828
set -g fish_pager_color_selected_prefix d6d6d6 --bold
set -g fish_pager_color_selected_completion d6d6d6

# Aliases
alias hypr="~/hypr.sh"
alias ff="fastfetch"
