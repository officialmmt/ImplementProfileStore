local Players = game:GetService("Players")

local DataService = require(script.Parent.DataService)

Players.PlayerAdded:Connect(function(player)

    repeat
        task.wait()
    until DataService:GetProfile(player)

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local Coins = Instance.new("IntValue")
    Coins.Name = "Coins"
    Coins.Parent = leaderstats

    Coins.Value =
        DataService:Get(player, "Coins")

    Coins.Changed:Connect(function(value)

        DataService:Set(player, "Coins", value)

    end)

end)
