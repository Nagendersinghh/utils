# If the record contains a "naked" markdown link, i.e., a non-http,
# non-html link, # append an html to it. Example:
# [Tasks](Tasks) -> [Tasks](Tasks.html)
{
	if ($0 ~ /\[[^][]+\]\([^)]+\)/ && \
	    $0 !~ /\[[^][]+\]\([^)]+\.html?\)/ && \
	    $0 !~ /\[[^][]+\]\(https?:\/\/[^)]+\)/ && \
	    $0 !~ /\[[^][]+\]\(ftp:\/\/[^)]+\)/)
		print gensub(/(\[[^][]+\])\(([^)#]+)(.*)\)(.*)/, \
		      "\\1(\\2.html\\3)\\4", \
		      "g")
	else
		print
}
