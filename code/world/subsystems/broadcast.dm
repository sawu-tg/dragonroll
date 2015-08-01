var/list/tips = list("Right clicking an object will allow you to examine it, providing some useful information!",
"Your Intent button allows you to do a variety of different things. Try them all!",
"Food provides more healing when cooked, so remember to cook everything over a campfire!",
"Weapons can be enchanted with magical powers by using them on Fonts, which spawn in the world",
"Trains and other vehicles require a constant input to function, try wiring them to a constant crystal!",
"Almost any source of water can be used to fish in.",
"Constructing a forge will allow you to cast weapon parts, to create your own unique weapon!",
"Dual wielding provides a significant boost over a single weapon, but make sure you have enough dexterity and strength!",
"Mana and Health restores naturally over time. If you're weak, take some time out of combat to restore!",
"Every class has a movement ability, which allows you rapidly cross large amounts of land.",
"Some terrain is dangerous, be careful when crossing it!",
"Some monsters like to hide in the ground, be careful about disturbing them!",
"A Hoe can be used on a variety of turfs to produce farmland!",
"A Shovel can be used to dig a trench, which will transfer water from adjacent tiles.",
"Many natural resources provide objects you can craft, try harvesting them all!",
"Some foods can be made into better, more filling foods by combining them with one another",
"Many objects have special functions when used with another. Click on an object with one in your active hand to do this.",
"The Player Sheet contains three seperate windows, click the \"Skills\" button to cycle through them",
"You can click any player's name after examining them to view their Player Sheet",
"Boats (made from logs) can provide an easy, mana-free way to cross oceans.",
"If something is too heavy to carry, try using the Kick/throw button to move it!",
"If you see a large name pop up, then you have encountered a boss. Be careful!",
"Every faction can have it's own unique currency. Ensure you're using the right currency to trade!",
"If you're physically stuck, try using your movement ability! It will pass through most solid objects",
"Unsure of what to press? Click <a href=\"https://github.com/sawu-tg/dragonroll/wiki/Game-Controls\">Here</a>",
 "Some trees can't be harvested without a proper axe and skill-level. Goofy."
)

/datum/controller/broadcast
	name = "Game Tip"
	execTime = 512

/datum/controller/broadcast/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [playerList.len])")

/datum/controller/broadcast/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [playerList.len])"

/datum/controller/broadcast/doProcess()
	if(playerList.len)
		var/chosenTip = pick(tips)
		shuffle(tips)
		for(var/mob/player/P in playerList)
			if(P.client)
				messageInfo(chosenTip,P,src)
	scheck()