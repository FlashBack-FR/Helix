ITEM.name = "Food"
ITEM.model = "models/props_junk/garbage_bag001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.food = 20
ITEM.drink = 0
ITEM.description = "Base for food and drink."
ITEM.category = "Food"

ITEM.functions.eat = {
    name = "Eat",
    OnRun = function(item)
        item.player:RestoreHunger(item.food) --See ReadMe.md
        item.player:RestoreThirst(item.drink)
        item.player:EmitSound("items/ammocrate_open.wav", 50)
        --When the player's thirst = 0 and the player's hunger = 0, gmod stop the timer so it won't waste ressources.
        --Need to call timerDrain again when drinking or eating
        timerDrain(item.player)

        return true
    end,
}