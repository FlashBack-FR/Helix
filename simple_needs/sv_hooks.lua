
function PLUGIN:PostPlayerLoadout(client)
    timerDrain(client)
end
    
function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
        
    if (IsValid(client)) then
        character:SetData("hunger", client:GetLocalVar("v_hunger",100))
        character:SetData("thirst", client:GetLocalVar("v_thirst",100))
    end
end
    
function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("v_hunger", character:GetData("hunger", 100))
        client:SetLocalVar("v_thirst", character:GetData("thirst", 100))
    end)
end