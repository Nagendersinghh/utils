function replaceWithHtml(blocks)
	for _, blk in ipairs(blocks) do
		if (blk.t == "Plain") then
			for i, inl in ipairs(blk.content) do
				local span = pandoc.Span ''
				if inl.t == "Str" then
					if inl.text == "[.]" then
						-- blk.content[i] = pandoc.Span('', {class = 'done1'})
						blk.content.attr = {class = 'done1'}
					elseif inl.text == "[o]" then
						-- blk.content[i] = pandoc.Span('', {class = 'done2'})
						blk.content.attr = {class = 'done2'}
					elseif inl.text == "[O]" then
						blk.content.attr = {class = 'done3'}
						-- blk.content[i] = pandoc.Span('', {class = 'done3'})
					elseif inl.text == "[X]" then
						blk.content.attr = {class = 'done4'}
						-- blk.content[i] = pandoc.Span('', {class = 'done4'})
					end
				end
			end
		end
	end
	return blocks
end

function BulletList(l)
	l.content = l.content:map(replaceWithHtml)
	return l
end
