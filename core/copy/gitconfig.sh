[credential "https://github.com"]
	helper = !gh auth git-credential
[user]
	name = Derek Scott
	email = derek@huement.com
	mail = derek@huement.com
[color]
	ui = true
	diff = auto
	status = auto
	branch = auto
[filter "lfs"]
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
	clean = git-lfs clean -- %f
[cola]
	spellcheck = true
	fontdiff = Fira Code,12,-1,5,50,0,0,0,0,0
	expandtab = true
	theme = flat-dark-grey
	icontheme = dark
	boldheaders = true
	statusindent = true
	statusshowtotals = true
[gui]
	editor = micro
[commit]
  template = ~/.gitmessage
