/*
	Written by: FIREking
*/

datum/proc/key_down(k, client/c)
datum/proc/key_up(k, client/c)
datum/proc/key_repeat(k, client/c)
datum/proc/focus_lost(client/c)
datum/proc/focus_gained(client/c)

client/proc/key_down(k, client/c)
client/proc/key_up(k, client/c)
client/proc/key_repeat(k, client/c)
client/proc/focus_lost(client/c)
client/proc/focus_gained(client/c)

var/list/keys_list = list(\
	"w",
	"a",
	"s",
	"d",
	"q",
	"e",
	"f",
	"space",
	"escape",
	"tab",
	"shift",
	"y", "add", "subtract", "return"
)

client
	var/tmp
		focus = null
		last_focus = null
		input_locked = 0
		list/keys = list()

	North()
	South()
	East()
	West()
	Northeast()
	Northwest()
	Southeast()
	Southwest()

	verb/KeyDown(k as text)
		set hidden = 1
		set instant = 1
		if(input_locked) return
		keys[k] = 1
		if(focus) if(hascall(focus, "key_down")) focus:key_down(k, src)

	verb/KeyUp(k as text)
		set hidden = 1
		set instant = 1
		keys[k] = 0
		if(input_locked) return
		if(focus) if(hascall(focus, "key_up")) focus:key_up(k, src)

	verb/KeyRepeat(k as text)
		set hidden = 1
		set instant = 1
		if(input_locked) return
		if(focus) if(hascall(focus, "key_repeat")) focus:key_repeat(k, src)

	proc/add_key(k)
		winset(src, "macro[k]Down", "parent=macro;name=[k];command=KeyDown+[k]")
		winset(src, "macro[k]Up", "parent=macro;name=[k]+UP;command=KeyUp+[k]")
		winset(src, "macro[k]Repeat", "parent=macro;name=[k]+REP;command=KeyRepeat+[k]")
		keys[k] = 0

	proc/add_keys()
		for(var/k in keys_list)
			add_key(k)

	proc/lock_input()
		input_locked = 1

	proc/unlock_input()
		input_locked = 0

	proc/clear_input()
		unlock_input()
		for(var/v in keys)
			keys[v] = 0

	proc/set_focus(x)
		clear_input()
		last_focus = focus
		if(hascall(focus, "focus_lost")) focus:focus_lost(src)
		focus = x
		if(hascall(focus, "focus_gained")) focus:focus_gained(src)

	proc/return_focus()
		set_focus(last_focus)