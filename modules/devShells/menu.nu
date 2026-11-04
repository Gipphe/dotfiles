#!/usr/bin/env nu

def intersperse []: list<any> -> list<any> {
    each { [null, $in] } | update 0 first | flatten
}

def "category format" [cat: string, comms: table] {
    [
        $"(ansi yellow)($cat)(ansi reset)"
        ($comms
            | select name help
            | each { { $in.name: $in.help } }
            | into record
        )
    ]
}

def "category print" []: any -> nothing {
    table --collapse --index false --theme none | $"\n($in)" | print
}

def "menu print" []: any -> nothing {
    table --collapse --index false --theme none | print
}

def main [] {
    let category_commands = $env.commands | from json | group-by category
    [
        $"(ansi yellow)dotfiles(ansi reset)"
        {menu: 'Show this menu'}
    ] | menu print

    $category_commands
    | items {|cat, comms| category format $cat $comms }
    | each { category print }

    null
}
