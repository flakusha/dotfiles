# Nushell Config File
#
# version = 0.90.1

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
    separator: white
    leading_trailing_space_bg: {attr: n} # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: {||
        
        # Closures can be used to choose colors for specific values.
        # The value (in this case, a bool) is piped into the closure.
        if $in { 'light_cyan' } else { 'light_gray' }
    }
    int: white
    filesize: {|e|
        if $e == 0b {
            'white'
        } else if $e < 1mb {
            'cyan'
        } else { 'blue' }
    }
    duration: white
    date: {|| (date now) - $in
    | if $in < 1hr {
        'purple'
    } else if $in < 6hr {
        'red'
    } else if $in < 1day {
        'yellow'
    } else if $in < 3day {
        'green'
    } else if $in < 1wk {
        'light_green'
    } else if $in < 6wk {
        'cyan'
    } else if $in < 52wk {
        'blue'
    } else { 'dark_gray' } }
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: {bg: red, fg: white}
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_garbage: {fg: white, bg: red, attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: {attr: u}
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

let light_theme = {
    separator: dark_gray
    leading_trailing_space_bg: {attr: n} # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: {||
        
        # Closures can be used to choose colors for specific values.
        # The value (in this case, a bool) is piped into the closure.
        if $in { 'dark_cyan' } else { 'dark_gray' }
    }
    int: dark_gray
    filesize: {|e|
        if $e == 0b {
            'dark_gray'
        } else if $e < 1mb {
            'cyan_bold'
        } else { 'blue_bold' }
    }
    duration: dark_gray
    date: {|| (date now) - $in
    | if $in < 1hr {
        'purple'
    } else if $in < 6hr {
        'red'
    } else if $in < 1day {
        'yellow'
    } else if $in < 3day {
        'green'
    } else if $in < 1wk {
        'light_green'
    } else if $in < 6wk {
        'cyan'
    } else if $in < 52wk {
        'blue'
    } else { 'dark_gray' } }
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cellpath: dark_gray
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: {fg: white, bg: red}
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_garbage: {fg: white, bg: red, attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: {attr: u}
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}

{
    __zoxide_z => $zoxide_completer
    __zoxide_zi => $zoxide_completer
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    # carapace completions are incorrect for nu
    # fish completes commits and branch names in a nicer way
    # carapace doesn't have completions for asdf
    # use zoxide completions for zoxide commands
    match $spans.0 {
        nu => $fish_completer
        git => $fish_completer
        asdf => $fish_completer
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: true
    ls: {use_ls_colors: true, clickable_links: true}
    rm: {always_trash: false}
    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
        show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        trim: {methodology: wrapping, wrapping_try_keep_words: true, truncating_suffix: "..."}
    }
    datetime_format: {normal: '%a, %d %b %Y %H:%M:%S %z'}
    explore: {
        help_banner: true
        exit_esc: true
        command_bar_text: '#C4C9C6'
        status_bar_background: {fg: '#1D1F21', bg: '#C4C9C6'}
        highlight: {bg: 'yellow', fg: 'black'}
        status: {}
        try: {}
        table: {
            split_line: '#404040'
            cursor: true
            line_index: true
            line_shift: true
            line_head_top: true
            line_head_bottom: true
            show_head: true
            show_index: true
        }
        config: {
            cursor_color: {bg: 'yellow', fg: 'black'}
        }
    }
    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: false # true enables history isolation, false disables it. true will allow the history to be isolated to the current session. false will allow the history to be shared across all sessions.
    }
    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true # set this to false to prevent auto-selecting completions when only one remains
        partial: true # set this to false to prevent partial filling of the prompt
        algorithm: "prefix" # prefix or fuzzy
        external: {enable: true, max_results: 500, completer: $external_completer}
    }
    cursor_shape: {emacs: line, vi_insert: block, vi_normal: underscore}
    color_config: $dark_theme # if you want a light theme, replace `$dark_theme` to `$light_theme`
    footer_mode: 25 # always, never, number_of_rows, auto
    float_precision: 2 # the precision for displaying floats in tables
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: emacs # emacs, vi
    render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    hooks: {
        pre_prompt: [
            {||
                null # replace with source code to run before the prompt is shown
            }
        ]
        pre_execution: [
            {||
                null # replace with source code to run before the repl input is run
            }
        ]
        env_change: {
            PWD: [
                {|before, after|
                    null # replace with source code to run if the PWD environment is different since the last repl input
                }
            ]
        }
        display_output: {||
            if (term size).columns >= 100 { table -e } else { table }
        }
        command_not_found: {||
            null # replace with source code to return an error message when a command is not found
        }
    }
    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20 # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {text: green, selected_text: green_reverse, description_text: yellow}
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {layout: list, page_size: 10}
            style: {text: green, selected_text: green_reverse, description_text: yellow}
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 4
                col_width: 20 # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {text: green, selected_text: green_reverse, description_text: yellow}
        }
        {
            name: commands_menu
            only_buffer_difference: false
            marker: "# "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {text: green, selected_text: green_reverse, description_text: yellow}
            source: {|buffer, position|
                # Example of extra menus created using a nushell source
                # Use the source field to create a list of records that populates
                # the menu
                scope commands
                | where name =~ $buffer
                | each {|it| {value: $it.name description: $it.usage} }
            }
        }
        {
            name: vars_menu
            only_buffer_difference: true
            marker: "# "
            type: {layout: list, page_size: 10}
            style: {text: green, selected_text: green_reverse, description_text: yellow}
            source: {|buffer, position|
                scope variables
                | where name =~ $buffer
                | sort-by name
                | each {|it| {value: $it.name description: $it.type} }
            }
        }
        {
            name: commands_with_description
            only_buffer_difference: true
            marker: "# "
            type: {
                layout: description
                columns: 4
                col_width: 20
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {text: green, selected_text: green_reverse, description_text: yellow}
            source: {|buffer, position|
                scope commands
                | where name =~ $buffer
                | each {|it| {value: $it.name description: $it.usage} }
            }
        }
    ]
    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    {send: menu, name: completion_menu}
                    {send: menunext}
                ]
            }
        }
        {
            name: completion_previous
            modifier: shift
            keycode: backtab
            mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
            event: {send: menuprevious}
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: emacs
            event: {send: menu, name: history_menu}
        }
        {
            name: next_page
            modifier: control
            keycode: char_x
            mode: emacs
            event: {send: menupagenext}
        }
        {
            name: undo_or_previous_page
            modifier: control
            keycode: char_z
            mode: emacs
            event: {
                until: [
                    {send: menupageprevious}
                    {edit: undo}
                ]
            }
        }
        {
            name: yank
            modifier: control
            keycode: char_y
            mode: emacs
            event: {
                until: [
                    {edit: pastecutbufferafter}
                ]
            }
        }
        {
            name: unix-line-discard
            modifier: control
            keycode: char_u
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {edit: cutfromlinestart}
                ]
            }
        }
        {
            name: kill-line
            modifier: control
            keycode: char_k
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {edit: cuttolineend}
                ]
            }
        }
        {
            name: commands_menu
            modifier: control
            keycode: char_t
            mode: [emacs, vi_normal, vi_insert]
            event: {send: menu, name: commands_menu}
        }
        {
            name: vars_menu
            modifier: alt
            keycode: char_o
            mode: [emacs, vi_normal, vi_insert]
            event: {send: menu, name: vars_menu}
        }
        {
            name: commands_with_description
            modifier: control
            keycode: char_s
            mode: [emacs, vi_normal, vi_insert]
            event: {send: menu, name: commands_with_description}
        }
    ]
}

def git-pull-full [] {
    git fetch -fptP --all --recurse-submodules
    git submodule update --init
    git merge --no-commit
}

alias ll = ls -mlas
alias ez = eza -laghmuU --icons --group-directories-first --hyperlink --time-style long-iso -F=auto
alias rust-apps-update = doas rsync -uP ~/.cargo/bin/[!.]*[!.] /usr/local/bin
alias git-pull-full = git-pull-full

alias gamescope-steam = with-env {RADV_PERFTEST: "rt", VKD3D_CONFIG: 'dxr' } {(
  gamemoderun vk_radv gamescope -w 3840 -h 2160 -W 3840 -H 2160 -r 144 -o 15 -e -f --rt
  --adaptive-sync -- steam
)}

alias gamescope-steam-native = with-env {RADV_PERFTEST: "rt", VKD3D_CONFIG: 'dxr' } {(
  gamemoderun vk_radv gamescope -w 3840 -h 2160 -W 3840 -H 2160 -r 144 -o 15 -e -f --rt
  --adaptive-sync -- steam-native
)}

source ~/.cache/carapace/init.nu
source ~/.cache/starship/init.nu
source ~/.cache/zoxide/zoxide.nu
# source ~/.config/broot/launcher/nushell/br
# use '~/.config/broot/launcher/nushell/br' *
source ~/.local/share/atuin/init.nu
