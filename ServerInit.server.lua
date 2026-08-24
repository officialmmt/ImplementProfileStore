local Players = game:GetService("Players")

local DataService =
    require(game.ServerScriptService.Data.DataService)

Players.PlayerAdded:Connect(function(player)

    DataService:LoadProfile(player)

end)
