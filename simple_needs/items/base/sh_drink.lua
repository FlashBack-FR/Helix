ITEM.name = "Drink"
ITEM.model = "models/props_junk/PopCan01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.food = 0
ITEM.drink = 20
ITEM.description = "Base for food and drink."
ITEM.category = "Drinks"

ITEM.functions.drink = {
    name = "Drink",
    OnRun = function(item)
        item.player:RestoreHunger(item.food) --See ReadMe.md
        item.player:RestoreThirst(item.drink)
        item.player:EmitSound("player/pl_scout_dodge_can_drink.wav", 50, 75)
        --When the player's thirst = 0 and the player's hunger = 0, gmod stop the timer so it won't waste ressources.
        --Need to call timerDrain again when drinking or eating
        timerDrain(item.player) 

        return true
    end,
}