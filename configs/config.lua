Config = {}
Config.Locale = 'en' 
Config.DrugDealer = {
	vector3(-110.2492, -13.3252, 70.5195), -- Drug Dealer Coords
}
Config.Heading = 350.0 -- Ped Heading
-- Ped 
Config.EnablePed = true -- Do you want to have a ped, false, true
Config.Ped = "g_m_y_ballaorig_01" -- Request a PED model. Ped models: https://docs.fivem.net/docs/game-references/ped-models/
-- Config.Heading = 150 -- What heading do you want for the ped.
-- Menu
Config.Align = "top" -- The position of the menu. Top, top-rigt, top-left, bottom, right, left etc.
-- Debug
Config.Debug = true -- Enables debugging.
-- Blip stuff
Config.EnableBlip = true -- Do you want to have a blip
Config.BlipSprite = 51 -- Blip sprite:  https://docs.fivem.net/docs/game-references/blips/
Config.BlipDisplay = 4 -- Blip display
Config.BlipScale = 0.65 -- Blip scale
Config.BlipColour = 5 -- Blip color
Config.BlipName = "Drug dealer" -- Name of the blip

Config.Enable3D = false -- Enables 3D Text instead of a marker. I personally recommend!
Config.HeightOfTheText = 1 -- Leave it at one, the higher the number the higher the text is going to be. It gets the z coordinate and adds extra height to it.
Config.EnableMarker = false -- Displays a marker. I personally do not recommend!
Config.MarkerId = 1 -- Marker id: https://docs.fivem.net/docs/game-references/markers/

-- Logs system
Config.Logs = true -- Enables discord logging.
Config.Webhook = 'https://discord.com/api/webhooks/' -- Discord Webhook

-- Notifications 
Config.EnableOkOk = true -- Enables OkOk notifications. You need to have the okokNotify script.
Config.EnableESX = false -- Enables ESX notifications.


-- ESX VERSION 
Config.NewESX = false -- Is the esx framework version youre using uses export to get the object ( ESX = exports["es_extended"]:getSharedObject() ). If false then it uses the old way
-- Money
Config.Money = 'money' -- Account Type ('black_money, 'money', 'bank') ESX.
-- Drug shop pretty easy to understand
Config.Items = {
	{ itemName = 'bread', label = 'Bread', BuyInPawnShop = true, BuyPrice = 4500}, -- This is for buying

	{ itemName = 'water', label = 'Water', SellInPawnShop = true, SellPrice = 2500 } -- This is for selling 

}


-- OX LIB, TARGET
Config.EnableOxLib = true -- If true this will disable the default ped spawning, markers, 3d text basically most of the other functions and will create everything with ox lib based.
-- ONLY ENABLE IF YOU HAVE ox_lib, ox_target. Otherwise it will break the code.
-- https://github.com/overextended/ox_lib -- OX_LIB
-- https://github.com/overextended/ox_target -- OX_TARGET

-- NEW if using OX LIB 
Config.DrugDealerOx = {
    {
        coords = vec(-110.2492, -13.3252, 69.5195, 350.0), -- FULL CORDS X,Y,Z HEADING
        
    },
}

