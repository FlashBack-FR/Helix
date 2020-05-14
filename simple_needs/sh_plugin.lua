PLUGIN.name = "Simple Needs"
PLUGIN.author = "FlashBack"
PLUGIN.description = "Adds simple hunger and thirst system."

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_commands.lua")

-- IG config
ix.config.Add("hungerDrain", 1, "How much hunger to drain every minute (1/10)", nil, {
    data = {min = 0, max = 20, decimals = 1},
    category = "needs"
})

ix.config.Add("thirstDrain", 3, "How much thirst to drain every minute (1/10)", nil, {
    data = {min = 0, max = 20, decimals = 1},
    category = "needs"
})

ix.config.Add("starvation", false, "Whether or not to kill the player when he's starving.", nil, {
    category = "needs"
})

ix.config.Add("dehydration", false, "Whether or not to kill the player when he's dehydrated.", nil, {
    category = "needs"
})

ix.config.Add("bloomEffect", true, "Whether or not to have a bloom effect while being more and more hungry or thirsty.", nil, {
    category = "needs"
})

ix.config.Add("tickTime", 60, "How many seconds between each time player's needs are drained.", function(newValue)
    for _, v in ipairs(player.GetAll()) do
        local ID = "ixNeed" .. v:SteamID()
        local tickTime  = newValue

        if  (timer.Exists(ID)) then
            timer.Remove(ID)
        end

        timerDrain(v)
        
    end
end, {
    data = {min = 1, max = 500},
    category = "needs"
})


-- functions
local function DrainHungerThirst(client)
    local character = client:GetCharacter()

    if (!character or client:GetMoveType() == MOVETYPE_NOCLIP) then
        return 0
    end

    local drainthirst = ix.config.Get("thirstDrain")/10
    local drainhunger = ix.config.Get("hungerDrain")/10

    if (CLIENT) then
        return drainhunger and drainthirst
    else
        local currenthunger = client:GetLocalVar("v_hunger", 0)
        local valueh = math.Clamp(currenthunger - drainhunger, 0, 100)
        local currentthirst = client:GetLocalVar("v_thirst", 0)
        local valuet = math.Clamp(currentthirst - drainthirst, 0, 100)

        client:SetLocalVar("v_thirst", valuet)
        client:SetLocalVar("v_hunger", valueh)
        hook.Run("OnDrain", client)
    end
end

--Timer drain
function timerDrain(client)
    local ID = "ixNeed" .. client:SteamID()
    local tickTime  = ix.config.Get("tickTime")

    if  (!timer.Exists(ID)) then
    timer.Create(ID, tickTime, 0, function()
            if (!IsValid(client)) then
                timer.Remove(ID)
                return
            end   
            DrainHungerThirst(client)
        end)
    end
end

--OnDrain
function PLUGIN:OnDrain(client)
    --If hunger = 0 and thirst = 0, remove timer
    if (client:GetHunger() == 0 and client:GetThirst() == 0) then
        local ID2 = "ixNeed" .. client:SteamID()
        timer.Remove(ID2)
    end
    
    --Death
    local checkStarv = ix.config.Get("starvation")
    local checkDehy = ix.config.Get("dehydration")

    if (checkStarv and client:GetHunger() == 0) then
        local ID = "ixDying" .. client:SteamID()
            
        if (!timer.Exists(ID)) then
            timer.Create(ID, 30, 0, function()
                if (client:GetHunger() != 0 and client:GetThirst() != 0) then
                    timer.Remove(ID)
                    return
                end
                client:SetHealth(math.max(client:Health() - 2, 0)) 
                if (client:Health() == 0) then
                    client:Kill()
                    client:RestoreHunger(100)
                    client:RestoreThirst(100)
                end
            end)
        end

    end

    if (checkDehy and client:GetThirst() == 0) then
        local ID = "ixDying" .. client:SteamID()

        if (!timer.Exists(ID)) then
            timer.Create(ID, 30, 0, function()
                if (client:GetHunger() != 0 and client:GetThirst() != 0) then
                    timer.Remove(ID)
                    return
                end
                client:SetHealth(math.max(client:Health() - 2, 0)) 
                if (client:Health() == 0) then
                    client:Kill()
                    client:RestoreHunger(100)
                    client:RestoreThirst(100)
                end
            end)
        end
    end


end


--Util functions
local playerMeta = FindMetaTable("Player")

function playerMeta:RestoreHunger(amount)
    local current = self:GetLocalVar("v_hunger", 0)
    local value = math.Clamp(current + amount, 0, 100)

    self:SetLocalVar("v_hunger", value)
end

function playerMeta:RestoreThirst(amount)
    local current = self:GetLocalVar("v_thirst", 0)
    local value = math.Clamp(current + amount, 0, 100)

    self:SetLocalVar("v_thirst", value)
end

function playerMeta:RemoveHunger(amount)
    local current = self:GetLocalVar("v_hunger", 0)
    local value = math.Clamp(current - amount, 0, 100)

    self:SetLocalVar("v_hunger", value)
end

function playerMeta:RemoveThirst(amount)
    local current = self:GetLocalVar("v_thirst", 0)
    local value = math.Clamp(current - amount, 0, 100)

    self:SetLocalVar("v_thirst", value)
end

function playerMeta:GetHunger()
    return self:GetLocalVar("v_hunger", 0)
end

function playerMeta:GetThirst()
    return self:GetLocalVar("v_thirst", 0)
end

function playerMeta:SetHunger(value)
    return self:SetLocalVar("v_hunger", value)
end

function playerMeta:SetThirst(value)
    return self:SetLocalVar("v_thirst", value)
end

