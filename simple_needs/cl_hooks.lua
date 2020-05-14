
function PLUGIN:RenderScreenspaceEffects()
    local client = LocalPlayer()
    local check = ix.config.Get("bloomEffect")

    if (!check or !IsValid(client) or client:GetMoveType() == MOVETYPE_NOCLIP) then
        return
    else
        local value = math.min(client:GetHunger(), client:GetThirst())

        if (value <= 20) then
            local blur = 3 - math.Remap(value, 0, 20, 0, 3)
            ix.util.DrawBlurAt(0, 0, ScrW(), ScrH(), blur)
        end
    end
end

local barHunger = 100
local barThirst = 100

function PLUGIN:OnLocalVarSet(key, var)
    if (key == "v_hunger") then
        barHunger = var
    elseif (key == "v_thirst") then
        barThirst = var
    end
    return
end

ix.bar.Add(function()
    return barHunger / 100
end, Color(14, 151, 20), nil, "v_hunger")

ix.bar.Add(function()
    return barThirst / 100
end, Color(47, 144, 235), nil, "v_Thirst")