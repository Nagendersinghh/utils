--[[--
Summary. pandoc vimwiki reader adds custom title to links. Use this filter to
remove them.
usage:
`pandoc -f vimwiki -t `target-format` --lua-filter `path/to/this/file``
]]--

function Link(el)
    if el.title == 'wikilink' then
      el.title = ''
    end
    return el
end
