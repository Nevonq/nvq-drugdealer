local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("nvq-drugdealer:drugfunction")
AddEventHandler("nvq-drugdealer:drugfunction", function(input, itemas, kaina, sumabendra)
	if Config.Debug then
		print(input)
	end
	local xPlayer = ESX.GetPlayerFromId(source)
	local cena = (kaina * sumabendra)
	local name     = GetPlayerName(source)
	local discord = 'nezinomas'
    for k,v in ipairs(GetPlayerIdentifiers(source)) do
    if v:match('discord') then
        discord = v:gsub('discord:','')
        end
     end
	local DATE = os.date("%Y-%m-%d `\nDate:` %H:%M:%S")

	if input == 'buy' then
		if xPlayer.getAccount('black_money').money >= cena then
			xPlayer.removeAccountMoney('black_money', cena)
			xPlayer.addInventoryItem(itemas, sumabendra)

			-- Notifications

			if Config.EnableOkOk then
				TriggerClientEvent('okokNotify:Alert', source, _('drugdealer'), "You bought: "..itemas .. ' | ' .. cena .. ' € | ' .. sumabendra .. ' x.', 5000, 'success')
			end

			if Config.EnableESX then
				xPlayer.showNotification(_U('buy'))
			end

			-- Logs

			if Config.Logs then
				DrugDealer("💊Drug dealer", 'Username: `' .. name .. '` \nDiscord: <@' .. discord .. '> \nBought: `' .. itemas .. '` \nAmount: `' .. sumabendra .. '` \nDate: `' .. DATE .. '` ', "nvq-drugdealer")
			end


		else
			if Config.EnableOkOk then
				TriggerClientEvent('okokNotify:Alert', source,  _U('drugdealer'), _U('not_enough'), 5000, 'error')
			end

			if Config.EnableESX then
				xPlayer.showNotification(_U('shownotifyesx'))
			end
		end

	elseif input == 'sell' then
		if xPlayer.getInventoryItem(itemas).count >= sumabendra then
			xPlayer.addAccountMoney('black_money', cena)
			xPlayer.removeInventoryItem(itemas, sumabendra)

			-- Notifications
			if Config.EnableOkOk then
				TriggerClientEvent('okokNotify:Alert', source, _('drugdealer'), "You sold: " .. itemas .. ' | ' .. cena .. ' € | ' .. sumabendra .. ' x.', 5000, 'success')
			end

			if Config.EnableESX then
				xPlayer.showNotification(_U('sold'), cena)
			end


			-- Logs
			if Config.Logs then 
				DrugDealer("💊Drug dealer", 'Username: `' .. name .. '` \nDiscord: <@' .. discord .. '> \nSold: `' .. itemas .. '` \nAmount: `' .. sumabendra .. '` \nDate:  `' .. DATE ..  '` \nHow much money he got: ' .. cena .. ' ',  "nvq-drugdealer")

			end
		else
			if Config.EnableOkOk then
				TriggerClientEvent('okokNotify:Alert', source,  _U('drugdealer'), _U('not_enoughs'), 5000, 'error')
			end
	
			if Config.EnableESX then
				xPlayer.showNotification(_U('shownotifyesx'))
			end
		end
	end
end)

-- Logs functions

function DrugDealer(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 16711680, 
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}

	PerformHttpRequest(Config.Webhook, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end



