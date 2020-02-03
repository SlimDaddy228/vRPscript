local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPserver = Tunnel.getInterface("vRP")
tvRP = Proxy.getInterface("vRP")

local LastVehicle = nil
local LicencePlate = {}
LicencePlate.Index = false
LicencePlate.Number = false
--Code by Slim (Все что выше, не трогать.)


function tvRP.takePlate()
	RequestAnimDict("mini")
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do
		Citizen.Wait(10)
	end
	if not LicencePlate.Index and not LicencePlate.Number then
        local PlayerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPed)
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        local VehicleCoords = GetEntityCoords(Vehicle)
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        if Distance < 3.5 and not IsPedInAnyVehicle(PlayerPed, false) then -- <3.5 это дистания расстояния от машины
			LastVehicle = Vehicle
			TaskPlayAnim(GetPlayerPed(-1),"mini@repair","fixing_a_player",1.0,-1.0, 30000, 0, 1, false, false, false)
			notify("Идёт скручивание номеров...")
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
			Citizen.Wait(14000)
			notify("~g~Ты скрутил номера с автомобиля")
            LicencePlate.Index = GetVehicleNumberPlateTextIndex(Vehicle)
            LicencePlate.Number = GetVehicleNumberPlateText(Vehicle)
            SetVehicleNumberPlateText(Vehicle, "") -- Устанавливает номера автомобилю
        else
			notify("~r~Рядом нету автомобиля")
        end
    else
		notify("~r~Ты решил скрутить номера со всех автомобилей?")
    end
  end


function tvRP.returnPlate()
	RequestAnimDict("mini")
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do
		Citizen.Wait(10) 
	end
	if LicencePlate.Index and LicencePlate.Number then
        local PlayerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPed)
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        local VehicleCoords = GetEntityCoords(Vehicle)
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        if ( (Distance < 3.5) and not IsPedInAnyVehicle(PlayerPed, false) ) then
		if (Vehicle == LastVehicle) then
				LastVehicle = nil
				TaskPlayAnim(GetPlayerPed(-1),"mini@repair","fixing_a_player",1.0,-1.0, 30000, 0, 1, false, false, false)
				notify("Возвращаем номера...")
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
			Citizen.Wait(14000)
			SetVehicleNumberPlateTextIndex(Vehicle, LicencePlate.Index)
			SetVehicleNumberPlateText(Vehicle, LicencePlate.Number)
			LicencePlate.Index = false
			LicencePlate.Number = false
		else
			notify("~r~Ты решил поставить свои номера на чужое авто?")
		end
        else
			notify("~r~Рядом нету Вашего автомобиля.")
        end
    end
end

function notify(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(true, false)
  end
