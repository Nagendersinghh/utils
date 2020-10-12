#!/usr/local/bin/fish

# A fish script to convert vimwiki files to markdown

function check_system
    if not type -q pandoc
        echo "Error: Can not find `pandoc`. Please install pandoc"
        exit 1
    end

    if not type -q gsed
        echo "Error: Can not find gsed. Please install gsed using \
        `brew install gsed`"
    end
end

function remove_bakup_file -a prefix
    rm $prefix".bak"
end

function clean_up -a file_path
    rm $file_path
    remove_bakup_file $file_path
end

function vimwiki_to_markdown -a vimwiki_file_path
    set filename (basename $vimwiki_file_path | gsed 's/\.[^.]*$//')
    set target_file_path $filename".md"
    set fixlink_lua_filter ~/Documents/utils/fixlinks.lua

    pandoc -f vimwiki \
    -t gfm \
    --wrap preserve \
    --preserve-tabs \
    --tab-stop 8 \
    --atx-headers \
    --lua-filter=$fixlink_lua_filter \
    -o $target_file_path \
    $vimwiki_file_path

    # Remove the span tags that pandoc's vimwiki reader
    # adds to todo lists

    gsed -i.bak \
    -e 's;<span class="done0"></span>;[ ] ;' \
    -e 's;<span class="done1"></span>;[.] ;' \
    -e 's;<span class="done2"></span>;[o] ;' \
    -e 's;<span class="done3"></span>;[O] ;' \
    -e 's;<span class="done4"></span>;[X] ;' $target_file_path

    if test $status -gt 0
        # gsed failed. Clean up.
        echo "Error: Can not format todo lists"
        clean_up $target_file_path
        exit 1
    end

    # pandoc adds multiple spaces between the - and [ ] of
    # todo list items. Remove the extra spaces
    gsed -i.bak -E 's;^(\s*)-\s+(\S);\1- \2;' $target_file_path

    if test $status -gt 0
        echo "Error: Error while fixing list item indentation"
        clean_up $target_file_path
        exit 1
    end

    # http links end up surrounded with <>.
    # Remove them
    gsed -i.bak -E 's;<http(s?):(.*)>;http\1:\2;' $target_file_path

    if test $status -gt 0
        echo "Error: Error while fixing http links"
        clean_up $target_file_path
        exit 1
    end

    # Remove empty comments
    gsed -i.bak -E '/^<!-- -->$/d' $target_file_path
    if test $status -gt 0
        # No need to abort the whole process
        # if comment removal fails. Write the
        # backup file back to the original and
        # continue
        cp $target_file_path".bak" $target_file_path
    end

    # Remove html for vimwiki-tags

    # This regex matches but probably not in a way
    # that you are thinking.  It will look for a
    # class="tag" inside a span. The span that
    # matches doesn't have to be the one which
    # contains the class tag.

    # For example, in this line:
    # <span id="whatever"></span><span id="duh" class="tag">tag-text</span>
    # The `<span` that matches is the outer one, whereas
    # the `class="tag"` that matches is from the inner one.

    # Right now, that actually works in our
    # favour, hence keeping it. When it becomes a
    # problem, fix it.
    gsed -i.bak \
    -E 's;<span .*class="tag"[^>]*>([^<]*)</span>;:\1:;' \
    $target_file_path

    if test $status -gt 0
        echo "Warning: Could not remove html for vimwiki-tags. Please do \
        a manual review"
    end

    remove_bakup_file $target_file_path
end

# Check whether the system has everything required
check_system

vimwiki_to_markdown $argv[1]
