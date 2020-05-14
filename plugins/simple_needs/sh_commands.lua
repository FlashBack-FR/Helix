ix.command.Add("SetHunger", {
    description = "@cmdSetHunger",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.number
    },
    OnRun = function(self, client, target, amount)
        amount = math.Round(amount) or 100

        if (amount <= 0) then
            amount = 0
        end

        target:GetPlayer():SetHunger(amount)
        client:NotifyLocalized("setHunger", target:GetName(), amount)
    end
})

ix.command.Add("SetThirst", {
    description = "@cmdSetThirst",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.number
    },
    OnRun = function(self, client, target, amount)
        amount = math.Round(amount) or 100

        if (amount <= 0) then
            amount = 0
        end

        target:GetPlayer():SetThirst(amount)
        client:NotifyLocalized("setThirst", target:GetName(), amount)
    end
})

ix.command.Add("Drink", {
    description = "@cmdDrink",
    OnRun = function(self, client)
        if (client:WaterLevel() > 0) then
            client:EmitSound("player/pl_scout_dodge_can_drink.wav", 50, 75)
            client:RestoreThirst(100)
        else
            return "@notInWater"
        end
    end
})