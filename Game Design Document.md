# Introduction to Lawless Shade

## Game Summary Pitch
Lawless Shade is an action-platformer where you throw potions in self defense at monsters trying to push you out of the dark. 
## Inspiration
***Noita*** - I was watching Thor's stream prior to the start of the game jam, and he was playing Noita. I really liked how the wands worked, and how there were so many particles. It reminded me of fluids, and then, potions.

***Minecraft*** - While not a heavy inspiration by any means, I got the idea of splash potions from it. I really like the idea of being able to throw down a potion, and it break but you get the effect. I personally think the lingering potions will work best, but splash potions for some quick throwing will work just fine

***SCP-001, S.D. Locke's Proposal (When Day Breaks)*** - This is the main inspiration for the "Shadow" portion of the theme. I won't go into too much depth for this, but essentially the paraphrased version of this SCP is that the sun has gone rogue, and any ounce of sunlight you get will melt you into a blob, which will then try to get other people to join them in the sun. The blobs join together to create a huge mass, and this is the one of the only Apollyon SCPs, Apollyon being deemed "uncontainable". The only way you can go outside is if you wear enough clothes to where no sunlight makes contact with you. While the enemies in the game aren't blobs, they are monsters, and they do want to drag you into the sunlight, while you hide in the dark, so I'd say it works. 
# Player Experience

## Platform 
It will be released on the web for desktop platforms. I might make a mobile version to put on https://poki.com in the future but for the jam, desktop web works fine.
## Development Software
I will be using Godot for this project, since it's simple, easy to use, and very efficient.
My art software will likely be Piskel, but if I need to edit something large (i.e. a tilesheet), then I'll use GIMP for that. Lastly, sound effects will likely come from JSFXR and music will either be found online or made with LMMS.
## Genre
I was debating between calling it a metroidvania or an action-platformer, but metroidvanias normally have very spacious levels, and my game doesn't really have the biggest levels, so I can't call it that, so I'm calling it an action-platformer.
## Target Audience
Going off the ESRB model for simplicity sake, this game would probably be an E10+ game, which is what I was going for anyway.
# Concept

## Gameplay overview
You start at the beginning of an old caste, to which you'll need to navigate through and find Potions throughout. After 15 seconds, a horde of enemies shows up in the front door, and they will try to pull the player outside, rather than damaging them. The player, on the other hand, will be able to gather potions, both good and bad, that not only work on the player, but also on the enemies. You'll have to figure out how you'll use the potions you have, as you can only get 3 potions at a time, to defeat as many enemies as you can before you inevitably get pulled out the door and into the sunlight. 
## Theme Interpretation (Shadows and Alchemy)
I took the theme more so at face value. Shadows reminded me of SCP-001, S.D. Locke's proposal (see above for more details), and so while I think many people will do something like "dark good, light bad", I think my implementation of it is unique. Alchemy reminded me of how the wands in Noita worked and how splash potions and lingering potions work in Minecraft. I decided to combine the platforming of Noita and the functionality potions of Minecraft to create the Alchemy portion of the theme.
## Primary Mechanics
- **Potions**
	- Potions are the weapons you use against the enemies. You can also use the potions on yourself, so be careful!
- **Enemies**
	- Enemies do not hurt you. Instead, they drag you into the light, which is dangerous.
	- Enemy Types:
		- Walkers
			- Walks toward you, and pulls you into the light
		- Impulsives
			- Spits at you in the direction you're running
		- Paras 
			- Will run up to you, but instead of dragging you, they stun you and die, making you much more vulnerable
		- 
- **Windows**
	- Initially, they're all blocked to make sure no light can get in. Enemies can destroy the barricade and let light in, making it more difficult to navigate for the player

## Secondary Mechanics

# Art

## Design
A dark approach will be taken for the art, since you're hiding in a dark facility (duh), and it's made to provide a sense of uncertainty when entering into the map. The art style will be made with pixel art, using Piskel to make the sprites, and GIMP to design the levels.
# Audio

## Music
The music will be upbeat, but in a darker tone, probably with a lot of synth in the track(s). The reason for this style is because the game is very action packed, but the art is also in a somewhat horror style, so I think it would make sense. 
## Sound Effects
Sound effects will be generated with JSFXR to complement the pixel art style of the game. There might be a few sounds (ex: a heartbeat sound) for when you get close to losing the game.
# Game Experience

## UI

## Controls

# Development Timeline
***7/19/2024 - 7/31/2024***
- 7/19:
	- [x] Create a functional player, with movement on a floor
	- [x] Start making an inventory system 
- 7/20: 
	- [x] Fix UI
	- [ ] Start making potions
	- [ ] Enemies?
