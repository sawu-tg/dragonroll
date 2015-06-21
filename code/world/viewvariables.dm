/client/Topic(href, href_list, hsrc)
	..()
	view_var_Topic(href, href_list, hsrc)

/client/verb/debug_variables(datum/D in world)
	set category = "Debug Verbs"
	set name = "View Variables"
	//set src in world

	var/title = ""
	var/body = ""

	if(!D)	return
	if(istype(D, /atom))
		var/atom/A = D
		title = "[A.name] (\ref[A]) = [A.type]"

		#ifdef VARSICON
		if (A.icon)
			body += debug_variable("icon", new/icon(A.icon, A.icon_state, A.dir), 0)
		#endif

	var/icon/sprite

	if(istype(D,/atom))
		var/atom/AT = D
		if(AT.icon && AT.icon_state)
			sprite = new /icon(AT.icon, AT.icon_state)
			usr << browse_rsc(sprite, "view_vars_sprite.png")

	title = "[D] (\ref[D]) = [D.type]"

	body += {"<script type="text/javascript">

				function updateSearch(){
					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(event.keyCode == 13){	//Enter / return
						var vars_ol = document.getElementById('vars');
						var lis = vars_ol.getElementsByTagName("li");
						for ( var i = 0; i < lis.length; ++i )
						{
							try{
								var li = lis\[i\];
								if ( li.style.backgroundColor == "#ffee88" )
								{
									alist = lis\[i\].getElementsByTagName("a")
									if(alist.length > 0){
										location.href=alist\[0\].href;
									}
								}
							}catch(err) {   }
						}
						return
					}

					if(event.keyCode == 38){	//Up arrow
						var vars_ol = document.getElementById('vars');
						var lis = vars_ol.getElementsByTagName("li");
						for ( var i = 0; i < lis.length; ++i )
						{
							try{
								var li = lis\[i\];
								if ( li.style.backgroundColor == "#ffee88" )
								{
									if( (i-1) >= 0){
										var li_new = lis\[i-1\];
										li.style.backgroundColor = "white";
										li_new.style.backgroundColor = "#ffee88";
										return
									}
								}
							}catch(err) {  }
						}
						return
					}

					if(event.keyCode == 40){	//Down arrow
						var vars_ol = document.getElementById('vars');
						var lis = vars_ol.getElementsByTagName("li");
						for ( var i = 0; i < lis.length; ++i )
						{
							try{
								var li = lis\[i\];
								if ( li.style.backgroundColor == "#ffee88" )
								{
									if( (i+1) < lis.length){
										var li_new = lis\[i+1\];
										li.style.backgroundColor = "white";
										li_new.style.backgroundColor = "#ffee88";
										return
									}
								}
							}catch(err) {  }
						}
						return
					}

					//This part here resets everything to how it was at the start so the filter is applied to the complete list. Screw efficiency, it's client-side anyway and it only looks through 200 or so variables at maximum anyway (mobs).
					if(complete_list != null && complete_list != ""){
						var vars_ol1 = document.getElementById("vars");
						vars_ol1.innerHTML = complete_list
					}

					if(filter.value == ""){
						return;
					}else{
						var vars_ol = document.getElementById('vars');
						var lis = vars_ol.getElementsByTagName("li");

						for ( var i = 0; i < lis.length; ++i )
						{
							try{
								var li = lis\[i\];
								if ( li.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									vars_ol.removeChild(li);
									i--;
								}
							}catch(err) {   }
						}
					}
					var lis_new = vars_ol.getElementsByTagName("li");
					for ( var j = 0; j < lis_new.length; ++j )
					{
						var li1 = lis\[j\];
						if (j == 0){
							li1.style.backgroundColor = "#ffee88";
						}else{
							li1.style.backgroundColor = "white";
						}
					}
				}



				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();

				}

				function loadPage(list) {

					if(list.options\[list.selectedIndex\].value == ""){
						return;
					}

					location.href=list.options\[list.selectedIndex\].value;

				}
			</script> "}

	body += "<body onload='selectTextField(); updateSearch()' onkeyup='updateSearch()'>"

	body += "<div align='center'><table width='100%'><tr><td width='50%'>"

	if(sprite)
		body += "<table align='center' width='100%'><tr><td><img src='view_vars_sprite.png'></td><td>"
	else
		body += "<table align='center' width='100%'><tr><td>"

	body += "<div align='center'>"

	if(istype(D,/atom))
		var/atom/A = D
		body += "<a href='?_src_=vars;datumedit=\ref[D];varnameedit=name'><b>[D]</b></a>"
		if(A.dir)
			body += "<br><font size='1'><a href='?_src_=vars;rotatedatum=\ref[D];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=\ref[D];varnameedit=dir'>[dir2text(A.dir)]</a> <a href='?_src_=vars;rotatedatum=\ref[D];rotatedir=right'>>></a></font>"
	else
		body += "<b>[D]</b>"

	body += "</div>"

	body += "</tr></td></table>"

	var/formatted_type = text("[D.type]")
	if(length(formatted_type) > 25)
		var/middle_point = length(formatted_type) / 2
		var/splitpoint = findtext(formatted_type,"/",middle_point)
		if(splitpoint)
			formatted_type = "[copytext(formatted_type,1,splitpoint)]<br>[copytext(formatted_type,splitpoint)]"
		else
			formatted_type = "Type too long" //No suitable splitpoint (/) found.

	body += "<div align='center'><b><font size='1'>[formatted_type]</font></b>"

	body += "</div>"

	body += "</div></td>"

	body += "<td width='50%'><div align='center'><a href='?_src_=vars;datumrefresh=\ref[D]'>Refresh</a>"

	//if(ismob(D))
	//	body += "<br><a href='?_src_=vars;mob_player_panel=\ref[D]'>Show player panel</a></div></td></tr></table></div><hr>"

	body += {"	<form>
				<select name="file" size="1"
				onchange="loadPage(this.form.elements\[0\])"
				target="_parent._top"
				onmouseclick="this.focus()"
				style="background-color:#ffffff">
			"}

	body += {"	<option value>Select option</option>
				<option value> </option>
			"}


	body += "<option value='?_src_=vars;mark_object=\ref[D]'>Mark Object</option>"
	if(ismob(D))
		body += "<option value='?_src_=vars;mob_player_panel=\ref[D]'>Show player panel</option>"

	body += "<option value>---</option>"

	if(ismob(D))
		body += "<option value='?_src_=vars;give_spell=\ref[D]'>Give Spell</option>"
		body += "<option value='?_src_=vars;give_disease=\ref[D]'>Give Disease</option>"
		body += "<option value='?_src_=vars;ninja=\ref[D]'>Make Space Ninja</option>"
		body += "<option value='?_src_=vars;godmode=\ref[D]'>Toggle Godmode</option>"
		body += "<option value='?_src_=vars;build_mode=\ref[D]'>Toggle Build Mode</option>"
		body += "<option value='?_src_=vars;direct_control=\ref[D]'>Assume Direct Control</option>"
		body += "<option value='?_src_=vars;drop_everything=\ref[D]'>Drop Everything</option>"
		body += "<option value='?_src_=vars;regenerateicons=\ref[D]'>Regenerate Icons</option>"
		body += "<option value>---</option>"
		body += "<option value='?_src_=vars;gib=\ref[D]'>Gib</option>"
	if(isobj(D))
		body += "<option value='?_src_=vars;delall=\ref[D]'>Delete all of type</option>"
	if(isobj(D) || ismob(D) || isturf(D))
		body += "<option value='?_src_=vars;addreagent=\ref[D]'>Add reagent</option>"
		body += "<option value='?_src_=vars;explode=\ref[D]'>Trigger explosion</option>"
		body += "<option value='?_src_=vars;emp=\ref[D]'>Trigger EM pulse</option>"

	body += "</select></form>"

	body += "</div></td></tr></table></div><hr>"

	body += "<font size='1'><b>E</b> - Edit, tries to determine the variable type by itself.<br>"
	body += "<b>C</b> - Change, asks you for the var type first.<br>"
	body += "<b>M</b> - Mass modify: changes this variable for all objects of this type.</font><br>"

	body += "<hr><table width='100%'><tr><td width='20%'><div align='center'><b>Search:</b></div></td><td width='80%'><input type='text' id='filter' name='filter_text' value='' style='width:100%;'></td></tr></table><hr>"

	body += "<ol id='vars'>"

	var/list/names = list()
	for (var/V in D.vars)
		names += V

	for (var/V in names)
		body += debug_variable(V, D.vars[V], 0, D)

	body += "</ol>"

	var/html = "<html><head>"
	if (title)
		html += "<title>[title]</title>"
	html += {"<style>
body
{
	font-family: Verdana, sans-serif;
	font-size: 9pt;
}
.value
{
	font-family: "Courier New", monospace;
	font-size: 8pt;
}
</style>"}
	html += "</head><body>"
	html += body

	html += {"
		<script type='text/javascript'>
			var vars_ol = document.getElementById("vars");
			var complete_list = vars_ol.innerHTML;
		</script>
	"}

	html += "</body></html>"

	usr << browse(html, "window=variables\ref[D];size=475x650")

	return

/client/proc/debug_variable(name, value, level, var/datum/DA = null)
	var/html = ""

	if(DA)
		html += "<li style='backgroundColor:white'>(<a href='?_src_=vars;datumedit=\ref[DA];varnameedit=[name]'>E</a>) (<a href='?_src_=vars;datumchange=\ref[DA];varnamechange=[name]'>C</a>) (<a href='?_src_=vars;datummass=\ref[DA];varnamemass=[name]'>M</a>) "
	else
		html += "<li>"

	if (isnull(value))
		html += "[name] = <span class='value'>null</span>"

	else if (istext(value))
		html += "[name] = <span class='value'>\"[value]\"</span>"

	else if (isicon(value))
		#ifdef VARSICON
		var/icon/I = new/icon(value)
		var/rnd = rand(1,10000)
		var/rname = "tmp\ref[I][rnd].png"
		usr << browse_rsc(I, rname)
		html += "[name] = (<span class='value'>[value]</span>) <img class=icon src=\"[rname]\">"
		#else
		html += "[name] = /icon (<span class='value'>[value]</span>)"
		#endif

/*		else if (istype(value, /image))
		#ifdef VARSICON
		var/rnd = rand(1, 10000)
		var/image/I = value

		src << browse_rsc(I.icon, "tmp\ref[value][rnd].png")
		html += "[name] = <img src=\"tmp\ref[value][rnd].png\">"
		#else
		html += "[name] = /image (<span class='value'>[value]</span>)"
		#endif
*/
	else if (isfile(value))
		html += "[name] = <span class='value'>'[value]'</span>"

	else if (istype(value, /datum))
		var/datum/D = value
		html += "<a href='?_src_=vars;Vars=\ref[value]'>[name] \ref[value]</a> = [D.type]"

	else if (istype(value, /client))
		var/client/C = value
		html += "<a href='?_src_=vars;Vars=\ref[value]'>[name] \ref[value]</a> = [C] [C.type]"
//
	else if (istype(value, /list))
		var/list/L = value
		html += "[name] = /list ([L.len])"

		if (L.len > 0 && !(name == "underlays" || name == "overlays" || name == "vars" || L.len > 500))
			// not sure if this is completely right...
			if(0)   //(L.vars.len > 0)
				html += "<ol>"
				html += "</ol>"
			else
				html += "<ul>"
				var/index = 1
				for (var/entry in L)
					if(istext(entry))
						html += debug_variable(entry, L[entry], level + 1)
					//html += debug_variable("[index]", L[index], level + 1)
					else
						html += debug_variable(index, L[index], level + 1)
					index++
				html += "</ul>"

	else
		html += "[name] = <span class='value'>[value]</span>"

	html += "</li>"

	return html

/client/proc/view_var_Topic(href, href_list, hsrc)
	//This should all be moved over to datum/admins/Topic() or something ~Carn
	if( (usr.client != src))
		return
	if(href_list["Vars"])
		debug_variables(locate(href_list["Vars"]))

	else if(href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if(!istype(DAT, /datum))
			return
		src.debug_variables(DAT)

	else if(href_list["regenerateicons"])
		var/mob/M = locate(href_list["regenerateicons"])
		if(!ismob(M))
			usr << "This can only be done to instances of type /mob"
			return
		M:refreshIcon()

	//~CARN: for renaming mobs (updates their name, real_name, mind.name, their ID/PDA and datacore records).

	if(href_list["rename"])

		var/mob/M = locate(href_list["rename"])
		if(!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/new_name = input(usr,"What would you like to name this mob?","Input a name",M.name,36)
		if( !new_name || !M )	return

		messageSystemAll("Admin [usr.name] renamed [usr.name] to [new_name].")
		M.name = new_name
		href_list["datumrefresh"] = href_list["rename"]

	else if(href_list["varnameedit"] && href_list["datumedit"])
		var/D = locate(href_list["datumedit"])
		if(!istype(D,/datum) && !istype(D,/client))
			usr << "This can only be used on instances of types /client or /datum"
			return

		modify_variables(D, href_list["varnameedit"], 1)

	else if(href_list["varnamechange"] && href_list["datumchange"])

		var/D = locate(href_list["datumchange"])
		if(!istype(D,/datum) && !istype(D,/client))
			usr << "This can only be used on instances of types /client or /datum"
			return

		modify_variables(D, href_list["varnamechange"], 0)

	else if(href_list["delall"])
		var/obj/O = locate(href_list["delall"])
		if(!isobj(O))
			usr << "This can only be used on instances of type /obj"
			return

		var/action_type = alert("Strict type ([O.type]) or type and all subtypes?",,"Strict type","Type and subtypes","Cancel")
		if(action_type == "Cancel" || !action_type)
			return

		if(alert("Are you really sure you want to delete all objects of type [O.type]?",,"Yes","No") != "Yes")
			return

		if(alert("Second confirmation required. Delete?",,"Yes","No") != "Yes")
			return

		var/O_type = O.type
		switch(action_type)
			if("Strict type")
				var/i = 0
				for(var/obj/Obj in world)
					if(Obj.type == O_type)
						i++
						sdel(Obj)
				if(!i)
					usr << "No objects of this type exist"
					return
				messageSystemAll("[usr.name] deleted all objects of type [O_type] ([i] objects deleted) ")
				messageSystemAll("<span class='notice'>[usr.name] deleted all objects of type [O_type] ([i] objects deleted) </span>")
			if("Type and subtypes")
				var/i = 0
				for(var/obj/Obj in world)
					if(istype(Obj,O_type))
						i++
						sdel(Obj)
				if(!i)
					usr << "No objects of this type exist"
					return
				messageSystemAll("[usr.name] deleted all objects of type or subtype of [O_type] ([i] objects deleted) ")
				messageSystemAll("<span class='notice'>[usr.name] deleted all objects of type or subtype of [O_type] ([i] objects deleted) </span>")

	else if(href_list["rotatedatum"])
		var/atom/A = locate(href_list["rotatedatum"])
		if(!istype(A))
			usr << "This can only be done to instances of type /atom"
			return

		switch(href_list["rotatedir"])
			if("right")	A.dir = turn(A.dir, -45)
			if("left")	A.dir = turn(A.dir, 45)
		href_list["datumrefresh"] = href_list["rotatedatum"]

	return

var/list/forbidden_varedit_object_types = list()

var/list/VVlocked = list("vars", "client", "virus", "viruses", "cuffed", "last_eaten", "unlock_content", "step_x", "step_y")
var/list/VVicon_edit_lock = list("icon", "icon_state", "overlays", "underlays")
var/list/VVckey_edit = list("key", "ckey")

/*
/client/proc/cmd_modify_object_variables(obj/O as obj|mob|turf|area in world)
	set category = "Debug"
	set name = "Edit Variables"
	set desc="(target) Edit a target item's variables"
	src.modify_variables(O)
	feedback_add_details("admin_verb","EDITV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/
/client/proc/mod_list_add_ass() //haha

	var/class = "text"
	class = input("What kind of variable?","Variable Type") as null|anything in list("text",
		"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as null|text

		if("num")
			var_value = input("Enter new number:","Num") as null|num

		if("type")
			var_value = input("Enter type:","Type") as null|anything in typesof(/obj,/mob,/area,/turf)

		if("reference")
			var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in world

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

	if(!var_value) return

	return var_value


/client/proc/mod_list_add(var/list/L, atom/O, original_name, objectvar)

	var/class = "text"
	class = input("What kind of variable?","Variable Type") as null|anything in list("text",
		"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as text

		if("num")
			var_value = input("Enter new number:","Num") as num

		if("type")
			var_value = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

		if("reference")
			var_value = input("Select reference:","Reference") as mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as mob in world

		if("file")
			var_value = input("Pick file:","File") as file

		if("icon")
			var_value = input("Pick icon:","Icon") as icon

	if(!var_value) return

	switch(alert("Would you like to associate a var with the list entry?",,"Yes","No"))
		if("Yes")
			L += var_value
			L[var_value] = mod_list_add_ass() //haha
		if("No")
			L += var_value
	world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: ADDED=[var_value]"
	messageSystemAll("[usr.name] modified [original_name]'s [objectvar]: ADDED=[var_value]")
	messageSystemAll("[usr.name] modified [original_name]'s [objectvar]: ADDED=[var_value]")

/client/proc/mod_list(var/list/L, atom/O, original_name, objectvar)
	if(!istype(L,/list)) src << "Not a List."
	var/list/names = L

	var/variable = input("Which var?","Var") as null|anything in names + "(ADD VAR)"

	if(variable == "(ADD VAR)")
		mod_list_add(L, O, original_name, objectvar)
		return

	if(!variable)
		return

	var/default

	var/dir

	if(isnull(variable))
		usr << "Unable to determine variable type."

	else if(isnum(variable))
		usr << "Variable appears to be <b>NUM</b>."
		default = "num"
		dir = 1

	else if(istext(variable))
		usr << "Variable appears to be <b>TEXT</b>."
		default = "text"

	else if(isloc(variable))
		usr << "Variable appears to be <b>REFERENCE</b>."
		default = "reference"

	else if(isicon(variable))
		usr << "Variable appears to be <b>ICON</b>."
		variable = "\icon[variable]"
		default = "icon"

	else if(istype(variable,/atom) || istype(variable,/datum))
		usr << "Variable appears to be <b>TYPE</b>."
		default = "type"

	else if(istype(variable,/list))
		usr << "Variable appears to be <b>LIST</b>."
		default = "list"

	else if(istype(variable,/client))
		usr << "Variable appears to be <b>CLIENT</b>."
		default = "cancel"

	else
		usr << "Variable appears to be <b>FILE</b>."
		default = "file"

	usr << "Variable contains: [variable]"
	if(dir)
		switch(variable)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null

		if(dir)
			usr << "If a direction, direction is: [dir]"

	var/class = "text"
	class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
		"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default", "DELETE FROM LIST")

	if(!class)
		return

	var/original_var = L[L.Find(variable)]
	var/new_var
	switch(class) //Spits a runtime error if you try to modify an entry in the contents list. Dunno how to fix it, yet.

		if("list")
			mod_list(variable, O, original_name, objectvar)

		if("restore to default")
			new_var = initial(variable)
			L[L.Find(variable)] = new_var

		if("edit referenced object")
			modify_variables(variable)

		if("DELETE FROM LIST")
			world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: REMOVED=[html_encode("[variable]")]"
			messageSystemAll("[usr.name] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			messageSystemAll("[usr.name] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			L -= variable
			return

		if("text")
			new_var = input("Enter new text:","Text") as text
			L[L.Find(variable)] = new_var

		if("num")
			new_var = input("Enter new number:","Num") as num
			L[L.Find(variable)] = new_var

		if("type")
			new_var = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)
			L[L.Find(variable)] = new_var

		if("reference")
			new_var = input("Select reference:","Reference") as mob|obj|turf|area in world
			L[L.Find(variable)] = new_var

		if("mob reference")
			new_var = input("Select reference:","Reference") as mob in world
			L[L.Find(variable)] = new_var

		if("file")
			new_var = input("Pick file:","File") as file
			L[L.Find(variable)] = new_var

		if("icon")
			new_var = input("Pick icon:","Icon") as icon
			L[L.Find(variable)] = new_var

	world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: [original_var]=[new_var]"
	messageSystemAll("[usr.name] modified [original_name]'s [objectvar]: [original_var]=[new_var]")
	messageSystemAll("[usr.name] modified [original_name]'s varlist [objectvar]: [original_var]=[new_var]")

/client/proc/modify_variables(var/atom/O, var/param_var_name = null, var/autodetect_class = 0)

	for(var/p in forbidden_varedit_object_types)
		if( istype(O,p) )
			usr << "<span class='danger'>It is forbidden to edit this object's variables.</span>"
			return

	if(istype(O, /client) && (param_var_name == "ckey" || param_var_name == "key"))
		usr << "<span class='danger'>You cannot edit ckeys on client objects.</span>"
		return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!param_var_name in O.vars)
			src << "A variable with this name ([param_var_name]) doesn't exist in this atom ([O])"
			return

		variable = param_var_name

		var_value = O.vars[variable]

		if(autodetect_class)
			if(isnull(var_value))
				usr << "Unable to determine variable type."
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				usr << "Variable appears to be <b>NUM</b>."
				class = "num"
				dir = 1

			else if(istext(var_value))
				usr << "Variable appears to be <b>TEXT</b>."
				class = "text"

			else if(isloc(var_value))
				usr << "Variable appears to be <b>REFERENCE</b>."
				class = "reference"

			else if(isicon(var_value))
				usr << "Variable appears to be <b>ICON</b>."
				var_value = "\icon[var_value]"
				class = "icon"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				usr << "Variable appears to be <b>TYPE</b>."
				class = "type"

			else if(istype(var_value,/list))
				usr << "Variable appears to be <b>LIST</b>."
				class = "list"

			else if(istype(var_value,/client))
				usr << "Variable appears to be <b>CLIENT</b>."
				class = "cancel"

			else
				usr << "Variable appears to be <b>FILE</b>."
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names += V

		variable = input("Which var?","Var") as null|anything in names
		if(!variable)	return
		var_value = O.vars[variable]

	if(!autodetect_class)

		var/dir
		var/default
		if(isnull(var_value))
			usr << "Unable to determine variable type."

		else if(isnum(var_value))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
			dir = 1

		else if(istext(var_value))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"

		else if(isloc(var_value))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"

		else if(isicon(var_value))
			usr << "Variable appears to be <b>ICON</b>."
			var_value = "\icon[var_value]"
			default = "icon"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"

		else if(istype(var_value,/list))
			usr << "Variable appears to be <b>LIST</b>."
			default = "list"

		else if(istype(var_value,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			default = "cancel"

		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"

		usr << "Variable contains: [var_value]"
		if(dir)
			switch(var_value)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				usr << "If a direction, direction is: [dir]"

		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	switch(class)

		if("list")
			mod_list(O.vars[variable], O, original_name, variable)
			return

		if("restore to default")
			O.vars[variable] = initial(O.vars[variable])

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/var_new = input("Enter new text:","Text",O.vars[variable]) as null|text
			if(var_new==null) return
			O.vars[variable] = var_new

		if("num")
			var/var_new =  input("Enter new number:","Num",O.vars[variable]) as null|num
			if(var_new==null) return
			O.vars[variable] = var_new

		if("type")
			var/var_new = input("Enter type:","Type",O.vars[variable]) as null|anything in typesof(/obj,/mob,/area,/turf)
			if(var_new==null) return
			O.vars[variable] = var_new

		if("reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob|obj|turf|area in world
			if(var_new==null) return
			O.vars[variable] = var_new

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob in world
			if(var_new==null) return
			O.vars[variable] = var_new

		if("file")
			var/var_new = input("Pick file:","File",O.vars[variable]) as null|file
			if(var_new==null) return
			O.vars[variable] = var_new

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(var_new==null) return
			O.vars[variable] = var_new

	world.log << "### VarEdit by [src]: [O.type] [variable]=[html_encode("[O.vars[variable]]")]"
	messageSystemAll("[usr.name] modified [original_name]'s [variable] to [O.vars[variable]]")
	messageSystemAll("[usr.name] modified [original_name]'s [variable] to [O.vars[variable]]")