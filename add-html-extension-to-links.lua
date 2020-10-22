function Link(el)
	print(el.title)
	if el.title == 'wikilink' then
		el.title = ''
	end
	return el
end
