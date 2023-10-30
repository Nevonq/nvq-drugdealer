
local showText = false
local markerInRange = false
local playerPed = PlayerPedId()

if Config.NewESX then 
	ESX = exports["es_extended"]:getSharedObject()
else
		ESX = nil
		Citizen.CreateThread(function()
			while ESX == nil do
				TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
				Citizen.Wait(1200)
			end
		end)
end

if not Config.EnableOxLib then
	if Config.EnablePed then
		Citizen.CreateThread(function()
			RequestModel(Config.Ped)
			while not HasModelLoaded(Config.Ped) do
				Wait(550)
			end
			for k,v in pairs(Config.DrugDealer) do
				local vectoras = vector3(v.x,v.y,v.z-1.0)
				local ped = CreatePed(4, Config.Ped, vectoras, Config.Heading, false, true) 
				FreezeEntityPosition(ped, true)
				SetEntityInvincible(ped, true)
				SetBlockingOfNonTemporaryEvents(ped, true)
				TaskSetBlockingOfNonTemporaryEvents(ped, true)
			end
		end)
	else
		Citizen.Wait(1500)
	end
end




function OpenDrugDealerMenu()
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
    	end
	)
end

if not Config.EnableOxLib then
	Citizen.CreateThread(function()
		while true do
			local sleep_optimizations = 1500
			local coords = GetEntityCoords(playerPed)
			markerInRange = false

			for k, v in ipairs(Config.DrugDealer) do
				local distance = #(coords - v)
				if distance < 5 then
					sleep_optimizations = 0
					if Config.Enable3D then
						DrawText3D(v.x, v.y, v.z + Config.HeightOfTheText, '[E] Drug Dealer')
						if distance < 2.5 and IsControlJustPressed(0, 38) then
							OpenDrugDealerMenu()
						end
					end

					if Config.EnableMarker and not markerInRange then
						DrawMarker(Config.MarkerId, v.x, v.y, v.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.2, 255, 255, 255, 200, false, true, 2, nil, nil, false)
						if distance < 2.5 then
							markerInRange = true
						end
					end
				
				end
			end

			if markerInRange then
				ESX.ShowHelpNotification(_U('help'))
				if IsControlJustPressed(0, 38) then
					OpenDrugDealerMenu()
				end
			end
			Wait(sleep_optimizations)
		end
	end)
end

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
	local player = PlayerPedId()
	local elements = {}
			
	for k,v in pairs(Config.Items) do
		if v.BuyInPawnShop then
			table.insert(elements,
            {
                label = v.label .. " | "..('<span style="color:red;">%s</span>'):format(_U('currency')..v.BuyPrice..""), 
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
	end,
	function(data, menu)
	end
	)
end

function SellMenu()
	local player = PlayerPedId()
	local elements = {}

    for k,v in pairs(Config.Items) do
		if v.SellInPawnShop then
			table.insert(elements,
            {
                label = v.label .. " | "..('<span style="color:red;">%s</span>'):format(_U('currency')..v.SellPrice..""), 
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


-- OX LIB, OX TARGET STUFF.
if Config.EnableOxLib then
	local ped = PlayerPedId()
	local vehicle = cache.vehicle

	lib.onCache('ped', function(value) ped = value end)
	lib.onCache('vehicle', function(value) vehicle = value end)

	for k, v in pairs(Config.DrugDealerOx) do
		if v.coords then
			lib.points.new(v.coords.xyz, 100.0, {
				onEnter = function(self)
					if not self.npc then
						ESX.Streaming.RequestModel(Config.Ped)
						local npc = CreatePed(4, Config.Ped, v.coords, false, true)
						FreezeEntityPosition(npc, true)
						SetEntityInvincible(npc, true)
						SetBlockingOfNonTemporaryEvents(npc, true)
						SetModelAsNoLongerNeeded(Config.Ped)
						self.npc = npc
			
						exports.ox_target:addLocalEntity(npc, {
							{
								name = 'nvq-drugs:drugs_dealer',
								icon = 'fa-solid fa-tablets',
								label = _U('ox_interact'),
								distance = 2.0,
								canInteract = function(entity)
									return entity
								end,
								onSelect = function(entity)
									OpenDrugDealerMenu()
								end,
							}
						})
					end
				end,
				onExit = function(self)
					
				end
			})
		end
	end
end 



-- For fixing the bug when the ui is frozen when in menu restarting the resource
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)
