-- Load soundbank
Sound.loadBank("soundbank.bin")
-- Load all mods and sfx in ram
Sound.loadMod(0)
Sound.loadMod(1)
Sound.loadMod(2)
Sound.loadSFX(0)
Sound.loadSFX(1)

Sound.setModVolume(600)

pan = 255

while not Keys.held.Start do

	Controls.read()	
	
	-- Stop all
	if Keys.newPress.X then
		Sound.stop()
	end	
	-- Play mods
	if Keys.newPress.A then
		Sound.startMod(0, PLAY_ONCE)
	end
	if Keys.newPress.B then
		Sound.startMod(1, PLAY_ONCE)
	end
	if Keys.newPress.Y then
		Sound.startMod(2, PLAY_ONCE)
	end
	-- Play SFX
	if Keys.newPress.L then		
		Sound.startSFX(1)
	end
	if Keys.newPress.R then
		pan = 0
		handle = Sound.startSFX(0)
	end
	-- Panning mangement
	if pan < 255 then pan = pan + 1 end	
	if pan ~= 255 then
		Sound.setSFXPanning(handle, pan)
	end	
	if pan == 255 and handle ~= nil then
		Sound.setSFXVolume(handle, 0)
	end

	screen.print(SCREEN_UP, 0, 0, "Press Start to quit")
	
	screen.print(SCREEN_DOWN, 0, 0, "### SOUND TEST ###")
	screen.print(SCREEN_DOWN, 0, 24, "A: play Mod 0, Keyg-Subtonal")
	screen.print(SCREEN_DOWN, 0, 32, "B: play Mod 1, Purple Motion Inspiration")
	screen.print(SCREEN_DOWN, 0, 40, "Y: play Mod 2, Rez Monday")
	screen.print(SCREEN_DOWN, 0, 62, "R: play SFX 0, Ambulance (panning effect)")	
	screen.print(SCREEN_DOWN, 0, 70, "L: play SFX 1, Boom (without effect)")	
	screen.print(SCREEN_DOWN, 0, 86, "X: stop mod playing")
	
	render()

end

-- unload all mods
Sound.unloadMod(0)
Sound.unloadMod(1)
Sound.unloadMod(2)
-- unload all sfx
Sound.unloadSFX(0)
Sound.unloadSFX(1)
-- unload sound bank
Sound.unloadBank()
