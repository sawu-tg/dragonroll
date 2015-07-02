#define RESPONSE_GENERIC 1
#define RESPONSE_HAPPY 2
#define RESPONSE_MAD 3

/mob
	var/datum/chat/myChat
	var/mob/lastChatted

/mob/New()
	..()
	myChat = new/datum/chat

/mob/Topic(href,href_list[])
	..()
	if(href_list["newchat"] && href_list["curchat"])
		var/datum/chat/C = locate(href_list["curchat"])
		C.chatTo(src,href_list["newchat"])


/datum/chattree
	var/text = "ERROR! This wasn't filled in!" //the text of this chat tree
	var/list/responses = list("Error" = /datum/chattree) // the response choices and the datum they lead too
	var/responseHref // a custom href to execute
	var/responseType = RESPONSE_GENERIC

/datum/chat
	var/list/responsesGeneric = list("Alright.","Yes.","So you see.") // revert to one of these if no response found, "Alright Then,".
	var/list/responsesHappy = list("That's great!","I'm so elated about this!", "I couldn't be happier!") // happy responses, ie "That's great,"
	var/list/responsesMad = list("Eugh.","I've had about enough of it.","Leave.") //mad responses, ie "No way,"

	var/datum/chattree/start = /datum/chattree//the first chat tree presented

/datum/chat/proc/getResponse(var/oftype)
	switch(oftype)
		if(RESPONSE_GENERIC)
			return pick(responsesGeneric)
		if(RESPONSE_HAPPY)
			return pick(responsesHappy)
		if(RESPONSE_MAD)
			return pick(responsesMad)
	return null

/datum/chat/proc/chatTo(var/mob/player/P,var/CC)
	var/html = "<title>Chat Dialog</title><html><center><body style='background:grey'><br>"
	var/datum/chattree/CT
	if(!CC)
		CT = new start
	else
		CT = new CC
	html += "[CT.text], [getResponse(CT.responseType)]"
	for(var/A in CT.responses)
		var/CTYPE = CT.responses[A]
		var/datum/chattree/CTT = new CTYPE
		html += "<br><a href=?src=\ref[P];curchat=\ref[src];newchat=[CT.responses[A]][CTT.responseHref ? ";[CTT.responseHref]" : ""]>[A]</a>"
		del(CTT)
	P << browse(html,"window=chatdialog")


////
// CHAT TREES
////

/datum/chat/vendomat
	responsesGeneric = list("YES.","INDEED.","CORRECT.") // revert to one of these if no response found, "Alright Then,".
	responsesHappy = list("EMOTION: ELATED.","RESPONSE: HAPPY.", "EXCITEMENT IMMINENT.") // happy responses, ie "That's great,"
	responsesMad = list("EMOTION: DISGUST.","RESPONSE: UNHAPPY.","INITIATING MURDER PROTOCOL.") //mad responses, ie "No way,"

	start = /datum/chattree/vendomat/greet//the first chat tree presented

/datum/chattree/vendomat/greet
	text = "STATEMENT: HELLO MEATBAG"
	responses = list("Hello!" = /datum/chattree/vendomat/hello, "Let's trade!" = /datum/chattree/vendomat/trade)
	responseType = RESPONSE_GENERIC

/datum/chattree/vendomat/hello
	text = "QUERY: IS GREETING A UNIT TWICE COMMON FOR HUMANS? I ENJOY THIS"
	responses = list("No, not really." = /datum/chattree/vendomat/greet)
	responseType = RESPONSE_HAPPY

/datum/chattree/vendomat/trade
	text = "ASSERTION: THIS TRADE WILL BE USEFUL TO THIS UNIT"
	responses = list("Thanks." = /datum/chattree/vendomat/greet)
	responseHref = "opentrade=1"
	responseType = RESPONSE_HAPPY