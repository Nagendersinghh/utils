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

function vimwiki_markdown_to_html --argument-names force syntax extension \
    \output_dir input_file css_file template_path \
    \template_default template_ext root_path custom_args

    set input_filename (basename $input_file | sed 's/\.[^.]*$//')
    set output_path (string join "" $output_dir $input_filename ".html")

    if type -q pandoc
        pandoc -f $syntax -t html -c (basename $css_file) $input_file | \
        sed -e 's;<span class="done0"></span>;[ ] ;' \
        -e 's;<span class="done1"></span>;[.] ;' \
        -e 's;<span class="done2"></span>;[o] ;' \
        -e 's;<span class="done3"></span>;[O] ;' \
        -e 's;<span class="done4"></span>;[X] ;' \
        >$output_path
    else
        echo "Error: pandoc isn't installed."
        exit 1
    end
end

vimwiki_markdown_to_html $argv
