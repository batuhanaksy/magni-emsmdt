ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand(Config.Commandname, function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and xPlayer.job.name == Config.Jobname then
        TriggerClientEvent("magni-emsmdt:client:open", source)
    else
        xPlayer.showNotification("Wrong Job !")
    end
end)

RegisterServerEvent("magni-emsmdt:create")
AddEventHandler("magni-emsmdt:create", function(data)
    local ts = os.time()
    local date = os.date('%d-%m-%Y %H:%M', ts)
    if Config.Discordlog then
        Discordlog(data)
    end
    if Config.SQL == "oxmysql" then
        exports.oxmysql:execute("INSERT INTO magni_emsmdt (name, data, date) VALUES (@name, @data, @date)", {["@name"] = data.name, ["@data"] = data.data, ["@date"] = date})
    elseif Config.SQL == "ghmatti" then
        exports.ghmattimysql:execute("INSERT INTO magni_emsmdt (name, data, date) VALUES (@name, @data, @date)", {["@name"] = data.name, ["@data"] = data.data, ["@date"] = date})
    elseif Config.SQL == "mysql" then
        MySQL.Async.execute('INSERT INTO magni_emsmdt (name, data, date) VALUES (@name, @data, @date)', {
            ['@name'] = data.name,
            ['@data'] = data.data,
            ['@date'] = date
        })
    end
end)

RegisterServerEvent("magni-emsmdt:server:search")
AddEventHandler("magni-emsmdt:server:search", function(input)
    if Config.SQL == "oxmysql" then
        local src = source
        local result = exports.oxmysql:executeSync("SELECT * FROM magni_emsmdt WHERE name LIKE '%"..input.."%'")
        if result[1] then
            data = result
        end
        TriggerClientEvent("magni-emsmdt:client:search", src, data)
    elseif Config.SQL == "ghmatti" then
        local src = source
        local result = exports.ghmattimysql:executeSync("SELECT * FROM magni_emsmdt WHERE name LIKE '%"..input.."%'")
        if result[1] then
            data = result
        end
        TriggerClientEvent("magni-emsmdt:client:search", src, data)
    elseif Config.SQL == "mysql" then
        local src = source
        local result = MySQL.Sync.fetchAll("SELECT * FROM magni_emsmdt WHERE name LIKE '%"..input.."%'")
        if result[1] then
            data = result
        end
        TriggerClientEvent("magni-emsmdt:client:search", src, data)
    end
end)

function Discordlog(data)
    local ts = os.time()
    local time = os.date('%Y-%m-%d %H:%M:%S', ts)
    local connect = {
        {
            ["title"] = data.name,
            ["description"] = ""..data.data,
            ["footer"] = {
                ["text"] = ""..time,
            },
            
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.Botname, embeds = connect}), { ['Content-Type'] = 'application/json' })
end