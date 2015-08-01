var/const/wikiurl = "https://github.com/sawu-tg/dragonroll/wiki"
var/const/giturl = "https://github.com/sawu-tg/dragonroll"
var/const/issuesurl = "https://github.com/sawu-tg/dragonroll/issues"
var/const/controlsurl = "https://github.com/sawu-tg/dragonroll/wiki/Game-Controls"

client/verb/github()
	set name = "github"
	set desc = "Visit the github."
	set hidden = 1
	if( giturl )
		if(alert("This will open github in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(giturl)
	else
		src << "\red The github URL is not set."
	return

client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(wikiurl)
	else
		src << "\red The wiki URL is not set."
	return

client/verb/issues()
	set name = "issues"
	set desc = "Visit the issue tracker."
	set hidden = 1
	if( issuesurl )
		if(alert("This will open the issue tracker in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(issuesurl)
	else
		src << "\red The issue tracker URL is not set."
	return

client/verb/controls()
	set name = "controls"
	set desc = "Visit the controls chart."
	set hidden = 1
	if( controlsurl )
		if(alert("This will open the Controls Chart in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(controlsurl)
	else
		src << "\red The control chart URL is not set."
	return
