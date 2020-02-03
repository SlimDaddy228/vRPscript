local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","SKRUTIT-NOMERA")


  vRP.defInventoryItem("test","Отвёртка","На вид обычный инструмент", -- ДОБАВЬ ЭТО В cfg/markets , шоб люди могли покупать.
  function(args)
    local choices = {}
  
    choices["Скрутить номера"] = {function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        vRPclient._takePlate(player)
          vRP.closeMenu(player)
        end
    end,"Только давай без нелегала"}

    choices["Поставить номера"] = {function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        vRPclient._returnPlate(player)
          vRP.closeMenu(player)
        end
    end,"Делай это аккуратно"}
  
    return choices
  end,
  1.00)