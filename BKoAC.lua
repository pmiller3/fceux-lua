-- Bandit Kings of Ancient China script by pmiller3.
-- 2022 November 12
-- Displays Data for heroes, prefectures, notes key memory addresses
-- Using this, you could edit memory locations to affect your starting hero
-- give yourself the edict, edit hero and prefecture stats, monitor certain
-- data with provided functions, alter turns, or set the year to something
-- beyond the invasion date to allow the game to play indefinitely

----------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------

function text(x, y, text)
	if (x >= 0 and x <= 255 and y >= 0 and y <= 240) then
		gui.text(x, y, text);
	end;
end;

function heroAddress(heroIndex)
	return heroData + heroDataOffset + (totalHeroBytes * heroIndex);
end;

function prefectureAddress(prefectureIndex)
	return prefectureData + (totalPrefectureBytes * prefectureIndex);
end;

function displayHero(x, y, hero)
	index = hero[1];
	location = memory.readbyte(heroAddress(index) + locationOffset);
	text(x, y,
	hero[2].." is at prefecture "
	..(location + 1)
	.." with "
	..(memory.readbyte(heroAddress(index) + troopsOffset))
	.." soldiers.");
	return location;
end;

function displayPrefecture(x, y, index)
	text(x, y, "Prefecture "..(index + 1).." has "
	..memory.readbyte(prefectureAddress(index) + armsOffset).." arms and "
	..memory.readbyte(prefectureAddress(index) + trainingOffset).." skill.");
end;

function activateGoodFellow(index)
	if(memory.readbyte(playerSelectIndex) == 1) then
		emu.message("Setting new hero to slot 1");
		memory.writebyte(playerSelectIndex, index);
		memory.writebyte(heroAddress(index) + typeOffset, goodFellowValue);
		for i = 0, 6 do
			if(memory.readbyte(exileStart + i) == 255) then
				memory.writebyte(exileStart + i, index);
			end;
		end;
	end;
end;

-- This only works for scenario one
function gameHasStarted()
	if(memory.readbyte(yearData) <= 76) then
		return false;
	end;
	return true;
end;

----------------------------------------------------------------
-- Data objects
----------------------------------------------------------------

-- The 18 bytes that represent mutable player data
totalHeroBytes = 18;
listOffset = 0; -- this one appears to be two bytes
ageOffset = 2;
ownerOffset = 3; -- need to figure this one out
locationOffset = 4;
bodyOffset = 5;
maxBodyOffset = 6;
strengthOffset = 7;
dexterityOffset = 8;
wisdomOffset = 9;
subAttributeOffset = 3; -- just add this to the prior 3
loyaltyOffset = 13;
popularityOffset = 14; -- 16-bit number, lower bits first
troopsOffset = 16;
typeOffset = 17; -- Need to really figure this one out
-- certain value of type are obvious - x20 is dead, A3 is lady, etc.

-- The 24 bytes that represent mutable prefecture data
totalPrefectureBytes = 24;
heroesOffset = 0; -- 2 bytes
peopleOffset = 2; -- 2 bytes
exilesOffset = 4; -- 2 bytes
goldOffset = 6; -- 2 bytes
foodOffset = 8; -- 2 bytes
metalOffset = 10; -- 2 bytes
furOffset = 12; -- 2 bytes
marketRateOffset = 14;
floodOffset = 15;
farmOffset = 16;
wealthOffset = 17;
supportOffset = 18;
armsOffset = 19;
trainingOffset = 20;
statusOffset = 21; -- seems to set snowfall, wild beasts, etc
rulerOffset = 22; -- funky, 2 bytes?

----------------------------------------------------------------
-- Hero Indices
----------------------------------------------------------------

-- Indices and names for certain heroes; here arrays in Lua are 1-based
---------------- The Bad Guy                -- IMC Sum, Scenarios
gaoQiu =         {0,   "Gao Qiu"};          -- 224, 1-4
---------------- Playable Good Fellows
tattooedPriest = {1,   "Tattoed Priest"};   -- 225, 1-4
nineDragons =    {2,   "Nine Dragons"};     -- 238, 1-4
welcomeRain =    {3,   "Welcome Rain"};     -- 243, 2, 4
leopardHeaded =  {4,   "Leopard Headed"};   -- 241, 1, 2
hairyPriest =    {5,   "Hairy Priest"};     -- 221, 1, 2
blueFaceBeast =  {6,   "Blue Face Beast"};  -- 234, 1, 2
blackWhirlwind = {7,   "Black Whirlwind"};  -- 183, 3
boldEagle =      {8,   "Bold Eagle"};       -- 210, 3*, 4
riverDragon =    {9,   "River Dragon"};     -- 203, 2*, 3
heavenlyKing =   {10,  "Heavenly King"};    -- 240, 2, 3
---------------- Non-playable Good Fellows
wilyWarrior =    {11,  "Wily Warrior"};     -- 166, 1
fiveHuedTiger =  {12,  "Five Hued Tiger"};  -- 147, 2
ironFaced =      {13,  "Iron Faced"};       -- 162, 3
woodDragon =     {14,  "Wood Dragon"};      -- 120, 3
demonLord =      {15,  "Demon Lord"};       -- 138, 4
robedScholar =   {16,  "Robed Scholar"};    -- 151, 1-2
rawIronPriest =  {17,  "Raw Iron Priest"};  -- 102, 1   -- Possibly the worst?
elderTiger =     {18,  "Elder Tiger"};      -- 210, 3-4
dragonZhu =      {19,  "Dragon Zhu"};       -- 181, 3
tigerFighter =   {20,  "Tiger Fighter"};    -- 148, 4
---------------- The Rest of the heroes, appear to be in the order
-- of the sum of their Integrity, Mercy, and Courage
littleLiGuang =  {21,  "Little Li Guang"};  -- 250
greatSword =     {22, "Great Sword"};       -- 248
thunderSpark =   {23, "Thunder Spark"};     -- 247
chiefAdvisor =   {24, "Chief Advisor"};     -- 243
arrowOfBeauty =   {25, "Arrow of Beauty"};  -- 242
taiMountain =   {26, "Tai Mountain"};       -- 242
sixRiceStalks =   {27, "Six Rice Stalks"};  -- 230
battleAx =   {28, "Battle Ax"};             -- 225
ironStaff =   {29, "Iron Staff"};           -- 223
stoneThrower =   {30, "Stone Thrower"};     -- 221
flightDemon =   {31, "Flight Demon"};       -- 220
heavensHammer =   {32, "Heaven's Hammer"};  -- 218
silverCloud =    {254, "Silver Cloud"};     -- 42  last hero, lowest IMC

----------------------------------------------------------------
-- Key Data Addresses
----------------------------------------------------------------
-- Start address of particular data
heroData = 0x6000; -- 254*18 byes
heroDataOffset = 5; -- 5 bytes of unused data?
playerSlots = 0x7231; -- 7*1 bytes, the index of the hero the player is
prefectureData = 0x733A; -- 49*24 bytes
turnData = 0x71FF; -- 49 bytes of turn order
welcomeRainEdict = 0x7263; -- flag that controls whether WR has the edict
-- Other player edicts are here but I haven't determined the order
yearData = 0x71F4; -- 2 bytes representing full 4 digit year
monthData = 0x71F6; -- 1 byte repesenting the month
playerSelectIndex = 0x059A; -- 7*1 byte representing the hero index the player select is
goodFellowValue = 0x83; -- hex value of good fellows
exileStart = 0x07238;

----------------------------------------------------------------
-- The actual script
----------------------------------------------------------------

-- Loop to read and display stats
while (true) do
	-- print player's stats
	location = displayHero(8, 216, gaoQiu);
	displayPrefecture(8, 224, location);
	-- Activate Good Fellow
	-- Somehow this works for Gao Qiu, but not Silver Cloud
	-- This might work for any established hero (e.g. one with a prefecture)
	-- Need to be on scenario one as its coded now
	if(arg == "activateHero" and not gameHasStarted()) then
		activateGoodFellow(gaoQiu[1]);
	end;
	FCEU.frameadvance();
end;