-- Crystalis script by pmiller3.
-- 2022 November 16
-- This script currently doesn't do anything, but I'm finding key
-- addresses for certain things in the game.

----------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------

function text(x, y, text)
	if (x >= 0 and x <= 255 and y >= 0 and y <= 240) then
		gui.text(x, y, text);
	end;
end;

----------------------------------------------------------------
-- Key Data Addresses
----------------------------------------------------------------
-- Start address of particular data
maxHealth = 0x03C0;
health = 0x03C1;
power = 0x3E1;
shield = 0x0400;
armor = 0x0401;
level = 0x0421;
gold = 0x0702; -- 2 bytes
currentExperience = 0x0704; -- 2 bytes
experienceRequirement = 0x0706; -- 2 bytes
magic = 0x0708;
maxMagic = 0x0709;
equippedSword = 0x6428; -- holds index in inventory, 0-based, 8x indicates unequipped
equippedArmor = 0x6429;
equippedShield = 0x642A;
equippedPower = 0x642B;
equippedConsumable = 0x642C;
equippedAccessory = 0x642D;
equippedKeyItem = 0x642E;
equippedMagic = 0x642F;
swordSlots = 0x6430; -- 4 bytes, x00 for water, fire 01, 02, 03, 04 is Crystalis
armorSlots = 0x6434; -- 4 bytes, xFF is off
shieldSlots = 0x6438; -- 4 bytes
powerSlots = 0x643C; -- 4 bytes
consumableSlots = 0x6440; -- 8 bytes
accessorySlots = 0x6448; -- 8 bytes, x29-30
keyItemSlots = 0x6450;  -- 8 bytes, x3
magicSlots = 0x6458; -- 8 bytes, x41-48
weaponChargeLevel = 0x06C0; -- 08 for level 1, 10 for level 2, 18 for level 3
statTable = 0x8B80; -- 16 bytes health, 16 bytes MP, 32 bytes max XP
-- The stat table is constantly being written to, so it's not clear
-- if this can be affected.

-- C390 holds A005 XP from scorpion?
-- 1920 400 XP and Gold from tomb guardian
-- 0x8007 is at memory location CBD4.
-- I suppose enemies might be stored around here

----------------------------------------------------------------
-- The actual script
----------------------------------------------------------------

while (true) do
    FCEU.frameadvance();
end;