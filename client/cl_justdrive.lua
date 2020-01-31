local lastgroundz = nil

local respawnx = nil
local respawny = nil

AddEvent("OnRenderHUD",function()
    local veh = GetPlayerVehicle(GetPlayerId())
    if veh~=0 then
        local x,y,z = GetVehicleLocation(veh)
        local ScreenX, ScreenY = GetScreenSize()
        DrawText(ScreenX-75,ScreenY-25,"Speed : " .. math.floor(GetVehicleForwardSpeed(veh)+0.5))
        if lastgroundz==nil then
           if not IsVehicleInAir(veh) then
               lastgroundz = z
           end
        else
            if not IsVehicleInAir(veh) then
                lastgroundz = z
            else
                DrawText(ScreenX-175,ScreenY-75,"Distance from ground : " .. math.floor(z-lastgroundz+0.5))
            end
        end
        if respawnx~=nil and respawny~=nil then
            DrawText(ScreenX-210,ScreenY-125,"Distance from respawn : " .. math.floor(GetDistance2D(x, y, respawnx, respawny)+0.5))
        end
    end
    DrawText(0,350,"/car (id 1-25)")
    DrawText(0,365,"/locations")
    DrawText(0,380,"/setrespawn")
    DrawText(0,395,"/removerespawn")

    DrawText(0,430,"Y = /setrespawn")
    DrawText(0,445,"U = /removerespawn")
    DrawText(0,460,"G = teleport to gas")
    DrawText(0,475,"R = return your car")
end)

AddEvent("OnKeyPress",function(key)
    local veh = GetPlayerVehicle(GetPlayerId()) 
    if veh~=0 then
        if key == "Y" then
            local x,y,z = GetVehicleLocation(veh)
            respawnx=x
            respawny=y
           CallRemoteEvent("cl_setrespawn")
        end
        if key == "U" then
            respawnx=nil
            respawny=nil
            CallRemoteEvent("cl_removerespawn")
         end
         if key == "G" then
            CallRemoteEvent("gastp")
         end
         if key == "R" then
            CallRemoteEvent("returncar")
         end
    end
end)

AddRemoteEvent("setrespawnpos",function(x,y)
    respawnx=x
    respawny=y
end)