#!/usr/local/bin/fish

# An html converter for markdown syntax vimwiki
# To use this as the html converter for markdown syntax
# wiki, add the path to this file in vimwiki's `custom_wiki2html` option.
#
# let markdown_wiki = {'path': '~/Documents/wiki_markdown/',
#             \ 'syntax': 'markdown',
#             \ 'ext': '.md',
#             \ 'custom_wiki2html': 'path/to/this/file' }
# let g:vimwiki_list = [markdown_wiki]
#
# NOTE: If it doesn't work, make sure that the file is executable.
# If not, you can make it executable using
# `chmod u+x /path/to/this/file`
function is_system_compatible
    if type -q pandoc || type -q gawk
        return 0
    else
        echo "Required programs not installed. Please install
        them and try again"
        return 1
    end
end

function vimwiki_markdown_to_html --argument-names force syntax extension \
    \output_dir input_file css_file template_path template_default \
    \template_ext root_path custom_args

    echo $force $syntax $extension $output_dir $input_file $css_file
    echo $template_path $template_default $template_ext $root_path $custom_args
    set replace_todo_lua_filter ~/Documents/utils/replace-todo-with-html.lua
    set full_template_path = (string join "" $template_path $template_default $template_ext)

    is_system_compatible; or exit 1

    set input_filename (basename $input_file | sed 's/\.[^.]*$//')
    set output_path (string join "" $output_dir $input_filename ".html")

    # Add .html to local wiki links
    gawk -f ~/Documents/utils/add-html-to-naked-links.awk $input_file |
    pandoc -f $syntax \
    --lua-filter=$replace_todo_lua_filter \
    -t html \
    --css (basename $css_file) \
    -s \
    --template=$full_template_path \
    -o $output_path

end

vimwiki_markdown_to_html $argv
