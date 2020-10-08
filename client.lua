ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread( function()
	while true do
		sleepThread = 10
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local trafoDiff = GetDistanceBetweenCoords(coords, 2883.47, 1519.42, 24.97, true)
    if trafoDiff < 3 then
      DrawText3Ds(2883.27, 1519.02, 24.97, "Elektrikleri Kes")  
    end
    Citizen.Wait(sleepThread)
  end
end)

RegisterNetEvent("ncs4-blackout:baslat")
AddEventHandler("ncs4-blackout:baslat", function()
	local coords = GetEntityCoords(GetPlayerPed(-1))
	
	if GetDistanceBetweenCoords(coords, 2883.47, 1519.42, 24.97, true) < 3 then	
		Gecis()
		SetEntityHeading(GetPlayerPed(-1), 163.73)
		SetEntityCoords(GetPlayerPed(-1), 2883.47, 1519.42, 24.0)
		exports['np-taskbar']:taskBar(5000, "Sisteme bağlanıyorsun..")
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE_UPRIGHT", 0, true)
		Citizen.Wait(5000)
		startGame()
	else
		exports['mythic_notify']:DoHudText('inform', 'Burada işlem yapamazsın')
	end
end)

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function Gecis()
  DoScreenFadeOut(1000)
  Citizen.Wait(500)
  DoScreenFadeIn(2000)
end

local Gec = false;

function startGame(dropAmount,letter,speed,inter)
  openGui()
  local dropAmount = 15
	local letter = 2
	local speed = 6
	local inter = 900
  play(dropAmount,letter,speed,inter)
  return Gec;
end
			   
local gui = false

function openGui()
    gui = true
    SetNuiFocus(true,true)
    SendNUIMessage({openPhone = true})
end

function play(dropAmount,letter,speed,inter) 
  SendNUIMessage({openSection = "playgame", amount = dropAmount,letterSet = letter,speed = speed,interval = inter})
end

function CloseGui()
    gui = false
    SetNuiFocus(false,false)
    SendNUIMessage({openPhone = false})
end

RegisterNUICallback('close', function(data, cb)
  CloseGui()
  ClearPedTasks(PlayerPedId())
  exports['mythic_notify']:DoHudText('error', 'Sisteme giremedin!')
  cb('ok')
end)

RegisterNUICallback('failure', function(data, cb)
  Gec = false
  CloseGui()
  ClearPedTasks(PlayerPedId())
  exports['mythic_notify']:DoHudText('error', 'Sistem girişi başarısız!')
  cb('ok')
end)

RegisterNUICallback('complete', function(data, cb)
  Gec = true
  CloseGui()
  ClearPedTasks(PlayerPedId())
  Citizen.Wait(2500)
  exports['mythic_notify']:DoHudText('inform', 'Sistem devredışı!')
  Elektrigikes()
  cb('ok')
end)


function Elektrigikes()
  local ped = PlayerPedId()
  local giveAnim = "anim@heists@ornate_bank@hostages@hit" --> Here is your animLib that u want use.
    
	RequestAnimDict(giveAnim)
    while not HasAnimDictLoaded(giveAnim) do
        Citizen.Wait(100)
    end

	TaskPlayAnim( ped, "anim@heists@ornate_bank@hostages@hit", "player_melee_long_rifle_kick_a", 8.0, 1.0, 1500, 2, 0, 0, 0, 0 )
	Citizen.Wait(600)
--	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'elektrik', 0.6)
  SetArtificialLightsState(true)
	Citizen.Wait(900000)
  SetArtificialLightsState(false)
end

RegisterNetEvent('ncs4-blackout:status')
AddEventHandler('ncs4-blackout:status', function(status)
  SetArtificialLightsState(status)
end)
