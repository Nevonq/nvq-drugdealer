Config = {}
Config.Locale = 'en'
Config.DrugDealer = {
	vector3(-110.1522, -13.8656, 70.5196), -- To change the ped players heading go into client.lua and find this line: ped = CreatePed(4, Config.Ped, vectoras, 120.50, false, true) -- The 120.50 value is the player ped Heading
}

-- Ped 
Config.EnablePed = true -- Do you want to have a ped, false, true
Config.Ped = "g_m_y_ballaorig_01" -- Request a PED model. Ped models: https://docs.fivem.net/docs/game-references/ped-models/
-- Config.Heading = 150 -- What heading do you want for the ped.
-- Menu
Config.Align = "top" -- The position of the menu. Top, top-rigt, top-left, bottom, right, left etc.
Config.Wait = 1000 -- 1 second
-- Debug
Config.Debug = true -- Enables debugging.
-- Blip stuff
Config.EnableBlip = true -- Do you want to have a blip
Config.BlipSprite = 51 -- Blip sprite:  https://docs.fivem.net/docs/game-references/blips/
Config.BlipDisplay = 4 -- Blip display
Config.BlipScale = 0.65 -- Blip scale
Config.BlipColour = 5 -- Blip color
Config.BlipName = "Drug dealer" -- Name of the blip

Config.Enable3D = true -- Enables 3D Text instead of a marker. I personally recommend!
Config.HeightOfTheText = 1 -- Leave it at one, the higher the number the higher the text is going to be. It gets the z coordinate and adds extra height to it.
Config.EnableMarker = false -- Displays a marker. I personally do not recommend!
Config.MarkerId = 1 -- Marker id: https://docs.fivem.net/docs/game-references/markers/

-- Logs system
Config.Logs = true -- Enables discord logging.
Config.Webhook = 'https://discord.com/api/webhooks/' -- Discord Webhook

-- Notifications 
Config.EnableOkOk = true -- Enables OkOk notifications. You need to have the script.
Config.EnableESX = false -- Enables ESX notifications.

-- Drug shop pretty easy to understand
Config.Items = {
	{ itemName = 'bread', label = 'Bread', BuyInPawnShop = true, BuyPrice = 4500}, -- This is for buying

	{ itemName = 'water', label = 'Water', SellInPawnShop = true, SellPrice = 2500 } -- This is for selling 

}

