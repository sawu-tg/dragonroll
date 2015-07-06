#define RESPONSE_GENERIC 1
#define RESPONSE_HAPPY 2
#define RESPONSE_MAD 3

/mob
	var/datum/chatTree/myChat
	var/mob/lastChatted

/mob/New()
	..()
	myChat = new/datum/chatTree

/mob/Topic(href,href_list[])
	..()
	if(href_list["newchat"] && href_list["curchat"])
		var/datum/chatTree/C = locate(href_list["curchat"])
		C.chatTo(src,href_list["newchat"])


/datum/chatBranch
	var/text = "ERROR! This wasn't filled in!" //the text of this chat tree
	var/list/responses = list("Error" = /datum/chatBranch) // the response choices and the datum they lead too
	var/responseHref // a custom href to execute
	var/responseType = RESPONSE_GENERIC

/datum/chatTree
	var/list/responsesGeneric = list("Alright.","Yes.","So you see.") // revert to one of these if no response found, "Alright Then,".
	var/list/responsesHappy = list("That's great!","I'm so elated about this!", "I couldn't be happier!") // happy responses, ie "That's great,"
	var/list/responsesMad = list("Eugh.","I've had about enough of it.","Leave.") //mad responses, ie "No way,"

	var/datum/chatBranch/start = /datum/chatBranch//the first chat tree presented

/datum/chatTree/proc/getResponse(var/oftype)
	switch(oftype)
		if(RESPONSE_GENERIC)
			return pick(responsesGeneric)
		if(RESPONSE_HAPPY)
			return pick(responsesHappy)
		if(RESPONSE_MAD)
			return pick(responsesMad)
	return null

/datum/chatTree/proc/chatTo(var/mob/player/P,var/CC)
	var/html = "<title>Chat Dialog</title><html><center><body style='background:grey'><br>"
	var/datum/chatBranch/CT
	if(!CC)
		CT = new start
	else
		CT = new CC
	html += "[CT.text], [getResponse(CT.responseType)]"
	for(var/A in CT.responses)
		var/CTYPE = CT.responses[A]
		var/datum/chatBranch/CTT = new CTYPE
		html += "<br><a href=?src=\ref[P];curchat=\ref[src];newchat=[CT.responses[A]][CTT.responseHref ? ";[CTT.responseHref]" : ""]>[A]</a>"
		del(CTT)
	var/datum/browser/popup = new(P, "chatdialog", "Conversation")
	popup.set_content(html)
	popup.open()


////
// CHAT TREES
////

/datum/chatTree/vendomat
	responsesGeneric = list("YES.","INDEED.","CORRECT.") // revert to one of these if no response found, "Alright Then,".
	responsesHappy = list("EMOTION: ELATED.","RESPONSE: HAPPY.", "EXCITEMENT IMMINENT.") // happy responses, ie "That's great,"
	responsesMad = list("EMOTION: DISGUST.","RESPONSE: UNHAPPY.","INITIATING MURDER PROTOCOL.") //mad responses, ie "No way,"

	start = /datum/chatBranch/vendomat/greet//the first chat tree presented

/datum/chatBranch/vendomat/greet
	text = "STATEMENT: HELLO MEATBAG"
	responses = list("Hello!" = /datum/chatBranch/vendomat/hello, "Let's trade!" = /datum/chatBranch/vendomat/trade)
	responseType = RESPONSE_GENERIC

/datum/chatBranch/vendomat/hello
	text = "QUERY: IS GREETING A UNIT TWICE COMMON FOR HUMANS? I ENJOY THIS"
	responses = list("No, not really." = /datum/chatBranch/vendomat/greet)
	responseType = RESPONSE_HAPPY

/datum/chatBranch/vendomat/trade
	text = "ASSERTION: THIS TRADE WILL BE USEFUL TO THIS UNIT"
	responses = list("Thanks." = /datum/chatBranch/vendomat/greet)
	responseHref = "opentrade=1"
	responseType = RESPONSE_HAPPY