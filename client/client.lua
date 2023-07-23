ESX = nil
isinalr = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1200)
	end
end)
if Config.EnablePed then
	Citizen.CreateThread(function()
		RequestModel(Config.Ped)
		while not HasModelLoaded(Config.Ped) do
			Wait(550)
		end
		for k,v in pairs(Config.DrugDealer) do
			local vectoras = vector3(v.x,v.y,v.z-1.0)
			ped = CreatePed(4, Config.Ped, vectoras, 330.50, false, true) -- The 120.50 value is the player ped Heading
		FreezeEntityPosition(ped, true)
			SetEntityInvincible(ped, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
			TaskSetBlockingOfNonTemporaryEvents(ped, true)
		end
	end)
else
	Citizen.Wait(Config.Wait)
end




function OpenDrugDealerMenu()
	isinalr = true
    ESX.UI.Menu.Open(
    	'default', GetCurrentResourceName(), 'drug_main',
    	{
        	title = _U('drugdealer'),
			align = Config.Align,
        	elements = {
				{ label = "<span style='color:green;'>Buy</span>", value = "buy" },
				{ label = "<span style='color:red;'>Sell</span>", value = "sell" },
        	}
    	},
    	function(data, menu)
        	local action = data.current.value

			if action == "buy" then
				BuyMenu()
			elseif action == "sell" then
				SellMenu()
			end
    	end,
    	function(data, menu)
        	menu.close()
			isinalr = false
    	end
	)
end


local showText = false
local markerInRange = false
local playerPed = PlayerPedId()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local coords = GetEntityCoords(playerPed)
        showText = false
        markerInRange = false

        for k, v in ipairs(Config.DrugDealer) do
            local distance = #(coords - v)

            if Config.Enable3D and distance < 5 and not showText then
                showText = true
                DrawText3D(v.x, v.y, v.z + Config.HeightOfTheText, '[E] Drug Dealer')
                if distance < 2.5 and IsControlJustPressed(0, 38) then
                    OpenDrugDealerMenu()
                end
            end

            if Config.EnableMarker and distance < 5 and not markerInRange then
                DrawMarker(Config.MarkerId, v.x, v.y, v.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.2, 255, 255, 255, 200, false, true, 2, nil, nil, false)
                if distance < 1.1 then
                    markerInRange = true
                end
            end
        end

        if markerInRange then
            ESX.ShowHelpNotification(_U('help'))
            if IsControlJustPressed(0, 38) then
                OpenDrugDealerMenu()
            end
        end
    end
end)


function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)

	SetTextScale(0.25, 0.25)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 350
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end


function BuyMenu()
	isinalr = true
	local player = PlayerPedId()
	local elements = {}
			
	for k,v in pairs(Config.Items) do
		if v.BuyInPawnShop then
			table.insert(elements,
            {
                label = v.label .. " | "..('<span style="color:red;">%s</span>'):format("â‚¬"..v.BuyPrice..""), 
                itemName = v.itemName, 
                BuyInPawnShop = v.BuyInPawnShop, 
                BuyPrice = v.BuyPrice
            })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "drug_buy_menu",
	{
		title = _U('drugdealer'),
		align    = Config.Align,
		elements = elements
	},
	function(data, menu)
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'buy_quantity', {
			title = _U('amount'),
		}, function(qdata, qmenu)
			local quantity = tonumber(qdata.value)
			if quantity ~= nil and quantity > 0 then
				TriggerServerEvent('nvq-drugdealer:drugfunction', "buy", data.current.itemName, data.current.BuyPrice, quantity)
				qmenu.close()
				menu.close()
			else
				if Config.EnableOkOk then
				exports['okokNotify']:Alert(_U('drugdealer'), _('incorrect'), 5000, 'error')
				end

				if Config.EnableESX then
					xPlayer.showNotification(_U('incs'))
				end
			end
		end, function(qdata, qmenu)
			qmenu.close()
		end)
	end,
	function(data, menu)
		menu.close()
		isinalr = false
	end,
	function(data, menu)
	end
	)
end

function SellMenu()
	isinalr = true
	local player = PlayerPedId()
	local elements = {}

    for k,v in pairs(Config.Items) do
		if v.SellInPawnShop then
			table.insert(elements,
            {
                label = v.label .. " | "..('<span style="color:red;">%s</span>'):format("â‚¬"..v.SellPrice..""), 
                itemName = v.itemName, 
                SellInPawnShop = v.SellInPawnShop,
                SellPrice = v.SellPrice
            })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "drug_sell_menu",
	{
		title = _U('drugdealer'),
		align    = Config.Align,
		elements = elements
	},
	function(data, menu)
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_quantity', {
			title = _U('amount'),
		}, function(qdata, qmenu)
			local quantity = tonumber(qdata.value)
			if quantity ~= nil and quantity > 0 then
				TriggerServerEvent('nvq-drugdealer:drugfunction', "sell", data.current.itemName, data.current.SellPrice, quantity)
				qmenu.close()
				menu.close()
			else
				if Config.EnableOkOk then
				exports['okokNotify']:Alert(_U('drugdealer'), _('incorrect'), 5000, 'error')
				end

				if Config.EnableESX then
					xPlayer.showNotification(_U('incs'))
				end
			end
		end, function(qdata, qmenu)
			qmenu.close()
		end)
	end,
	function(data, menu)
		menu.close()
		isinalr = false
	end,
	function(data, menu)
	end
	)
end





-- BLIP START


if Config.EnableBlip then
    Citizen.CreateThread(function()
        for k,v in pairs(Config.DrugDealer) do
            local blip = AddBlipForCoord(v)
            SetBlipSprite(blip, Config.BlipSprite)
            SetBlipDisplay(blip, Config.BlipDisplay)
            SetBlipScale  (blip, Config.BlipScale)
            SetBlipColour (blip, Config.BlipColour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.BlipName)
            EndTextCommandSetBlipName(blip)
        end
    end)
end

-- BLIP END
