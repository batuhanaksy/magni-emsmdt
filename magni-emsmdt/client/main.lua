RegisterNetEvent("magni-emsmdt:client:open")
AddEventHandler("magni-emsmdt:client:open", function()
    SendNUIMessage({type = "open"})
    SetNuiFocus(true, true)
end)

RegisterNUICallback("create", function(data)
    TriggerServerEvent("magni-emsmdt:create", data)
end)

RegisterNetEvent("magni-emsmdt:client:search")
AddEventHandler("magni-emsmdt:client:search", function(data)
    SendNUIMessage({type = "search", result = data})
end)

RegisterNUICallback("search", function(data)
    TriggerServerEvent("magni-emsmdt:server:search", data.input)
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)