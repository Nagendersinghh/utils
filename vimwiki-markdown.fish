#!/usr/local/bin/fish

function markdown_to_html --argument-names force syntax extension \
    \output_dir input_file css_file template_path \
    \template_default template_ext root_path custom_args

    set input_filename (basename $input_file | sed 's/\.[^.]*$//')
    set output_path (string join "" $output_dir $input_filename ".html")

    if type -q pandoc
        pandoc -f $syntax -t html -c (basename $css_file) $input_file -o $output_path
    else
        echo "Error: pandoc isn't installed."
        exit 1
    end
end

markdown_to_html $argv
