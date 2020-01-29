local plyvehs = {}
local savedrespawn = {}

local tpcommands = {}
tpcommands["gas"] = {
   posx = 125773.000000,
   posy = 80246.000000,
   posz = 1645.000000,
   roty = 90.0,
}
tpcommands["town"] = {
   posx = 172955.000000,
   posy = 183155.000000,
   posz = 2142.000000,
   roty = 0.0,
}
tpcommands["harbor"] = {
   posx = 60934.000000,
   posy = 183517.000000,
   posz = 756.000000,
   roty = 0.0,
}
tpcommands["smalltown"] = {
   posx = 41456.000000,
   posy = 134472.000000,
   posz = 1726.000000,
   roty = 0.0,
}
tpcommands["track"] = {
   posx = -93491.000000,
   posy = 42139.000000,
   posz = 4968.000000,
   roty = 0.0,
}
tpcommands["smalltown2"] = {
   posx = -17583.000000,
   posy = -234.000000,
   posz = 2283.000000,
   roty = 0.0,
}
tpcommands["antenna"] = {
   posx = 40933.000000,
   posy = 43.000000,
   posz = 10243.000000,
   roty = 0.0,
}
tpcommands["solar"] = {
   posx = 100448.000000,
   posy = -11312.000000,
   posz = 1419.000000,
   roty = 0.0,
}
tpcommands["antenna2"] = {
   posx = 179713.000000,
   posy = 13022.000000,
   posz = 10553.000000,
   roty = 0.0,
}
tpcommands["military"] = {
   posx = 153582.000000,
   posy = -148690.000000,
   posz = 1435.000000,
   roty = 0.0,
}

AddEvent("OnPlayerJoin", function(ply)
   SetPlayerSpawnLocation(ply, 125773.000000, 80246.000000, 1645.000000, 90.0)
   SetPlayerRespawnTime(ply, 500)
end)

function spawnveh(ply,id,first,custompos,x,y,z,rx,ry,rz)
   for i,v in ipairs(plyvehs) do
      if v.ply == ply then
         DestroyVehicle(v.vid)
         table.remove(plyvehs,i)
      end
   end
   local px,py,pz = GetPlayerLocation(ply)
   local h = GetPlayerHeading(ply)
   local veh = nil
   if custompos then
      veh = CreateVehicle(id, x, y, z)
      SetVehicleRotation(veh, rx, ry, rz)
   else
       veh = CreateVehicle(id, px, py, pz , h)
   end
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
      spawnveh(ply,GetPlayerPropertyValue(ply, "selectedveh"))
   end
end)

AddEvent("OnPlayerLeaveVehicle",function(ply,veh,seat)
   if GetPlayerPropertyValue(ply, "leaving")==nil then
   local respawnpos = false
   local index = 0
      for i,v in ipairs(savedrespawn) do
         if v.ply == ply then
            respawnpos=true
            index = i
         end
      end
   if respawnpos then
      local tbl = savedrespawn[index]
      spawnveh(ply,GetPlayerPropertyValue(ply, "selectedveh"),false,true,tbl.x,tbl.y,tbl.z,tbl.rx,tbl.ry,tbl.rz)
   else
    spawnveh(ply,GetPlayerPropertyValue(ply, "selectedveh"))
   end
   end
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

AddEvent("OnPlayerQuit",function(ply)
   for i,v in ipairs(plyvehs) do
      if v.ply == ply then
         SetPlayerPropertyValue(ply,"leaving",true,false)
         DestroyVehicle(v.vid)
         table.remove(plyvehs,i)
      end
   end
   for i,v in ipairs(savedrespawn) do
      if v.ply == ply then
         table.remove(savedrespawn,i)
      end
   end
end)


for k,v in pairs(tpcommands) do
AddCommand(k,function(ply)
   SetPlayerSpawnLocation(ply, v.posx, v.posy, v.posz, v.roty)
   SetPlayerHealth(ply, 0)
end)
end

AddCommand("locations",function(ply)
   for k,v in pairs(tpcommands) do
      AddPlayerChat(ply,"/"..k)
   end
end)

AddCommand("setrespawn",function(ply)
   local veh = GetPlayerVehicle(ply)
    for i,v in ipairs(savedrespawn) do
       if v.ply == ply then
          table.remove(savedrespawn,i)
       end
    end
    local x,y,z = GetVehicleLocation(veh)
    z=z+5
    local rx, ry, rz = GetVehicleRotation(veh)
    local tbl = {}
    tbl.ply = ply
    tbl.x = x
    tbl.y = y
    tbl.z = z
    tbl.rx = rx
    tbl.ry = ry
    tbl.rz = rz
    table.insert(savedrespawn,tbl)
    AddPlayerChat(ply,"Respawn added , exit the car to go to the saved location")
end)

AddCommand("removerespawn",function(ply)
    for i,v in ipairs(savedrespawn) do
       if v.ply == ply then
         AddPlayerChat(ply,"Respawn Location Removed")
          table.remove(savedrespawn,i)
       end
    end
end)

