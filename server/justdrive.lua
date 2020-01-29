local plyvehs = {}



AddEvent("OnPlayerJoin", function(ply)
   SetPlayerSpawnLocation(ply, 125773.000000, 80246.000000, 1645.000000, 90.0)
end)

function spawnveh(ply,id,first)
   for i,v in ipairs(plyvehs) do
      if v.ply == ply then
         DestroyVehicle(v.vid)
         table.remove(plyvehs,i)
      end
   end
   local x,y,z = GetPlayerLocation(ply)
   local h = GetPlayerHeading(ply)
   local veh = CreateVehicle(id, x, y, z , h)
   SetVehicleLicensePlate(veh, "JUSTDRIVE")
   SetVehicleRespawnParams(veh, false)
   AttachVehicleNitro(veh,true)
   local tbin = {}
   tbin.ply = ply
   tbin.vid = veh
   table.insert(plyvehs,tbin)
   if first == true then
      local ping = GetPlayerPing(ply)
      if ping == 0 then
          ping = 50
      else
         ping=ping*6
      end
      Delay(ping,function()
         SetPlayerInVehicle(ply, veh)
      end)
   else
      SetPlayerInVehicle(ply, veh)
   end
end

AddEvent("OnPlayerSpawn", function(ply)
   if GetPlayerPropertyValue(ply, "selectedveh")==nil then
      SetPlayerPropertyValue(ply, "selectedveh", 1,false)
      spawnveh(ply,1,true)
   else
      spawnveh(ply,GetPlayerPropertyValue(ply, "selectedveh"),true)
   end
end)

AddEvent("OnPlayerLeaveVehicle",function(ply,veh,seat)
    spawnveh(ply,GetPlayerPropertyValue(ply, "selectedveh"))
end)

AddCommand("car",function(ply,id)
   id = tonumber(id)
   if (id ~= nil and id > 0 and id < 26) then
      SetPlayerPropertyValue(ply, "selectedveh", id,false)
      if GetPlayerVehicle(ply)~=0 then
           AddPlayerChat(ply,"Get out of your car to spawn the selected car")
      else
         spawnveh(ply,id)
      end
   else
      AddPlayerChat(ply,"/car <id (1-25)>")
   end
end)

AddEvent("OnGameTick",function()
    for i,v in ipairs(GetAllVehicles()) do
      SetVehicleHealth(v, 5000)
      SetVehicleDamage(v, 1, 0.0)
      SetVehicleDamage(v, 2, 0.0)
      SetVehicleDamage(v, 3, 0.0)
      SetVehicleDamage(v, 4, 0.0)
      SetVehicleDamage(v, 5, 0.0)
      SetVehicleDamage(v, 6, 0.0)
      SetVehicleDamage(v, 7, 0.0)
      SetVehicleDamage(v, 8, 0.0)
    end
end)
