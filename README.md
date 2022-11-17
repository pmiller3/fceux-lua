# fceux-lua
Contains Lua scripts for execution in fceux

## BKoAC.lua
Has many important memory locations for mutable attributes in the game.  It also takes a parameter, `activateHero` which will allow you to be a hero if you select Scenario 1 (it will replace the first choice).

If you choose `gaoQiu` it will eventually crash.  However, I believe the other 10 Good Fellows (e.g. `robedScholar`) will work just fine.

It will also display Gao Qiu's current whereabouts, his troops and their skills and arms.

You can also use the memory locations in the file to determine certain things, like where the year data is stored.  If you set it to beyond 1127 (it's stored as two bytes in a little-endian manner) you can bypass the game ending event.