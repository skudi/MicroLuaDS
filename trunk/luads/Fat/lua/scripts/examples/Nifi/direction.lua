-- Fichier: direction.lua
-- Auteur : Thomh@ck
-- Description : Script de démonstration d'utilisation Nifi:
--				 Ce script permet de controllez le stickman afficher par le fichier ' stickman.lua '



Nifi.init(10)  -- Initialisation du nifi sur la canal 10 ( le même canal que le fichier stickman.lua )

while not Keys.newPress.Start do
	Controls.read()
	
	if Keys.held.Up then
		Nifi.sendMessage("up")		-- Cette fonction envoie une chaîne de caractères ( ici " up " ) 
	end
	
	if Keys.held.Down then
		Nifi.sendMessage("down")
	end
	
	if Keys.held.Right then
		Nifi.sendMessage("right")
	end
	
	if Keys.held.Left then
		Nifi.sendMessage("left")
	end
	
	screen.print(SCREEN_DOWN, 10,10, "pressez + pour diriger le stickman.")
	
	render()
end 

Nifi.stop() -- Fonction terminant la connexion nifi.
