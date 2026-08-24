local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.Packages.ProfileStore)

local DefaultData = require(script.Parent.DataTemplate)

local PlayerStore =
    ProfileStore.New("PlayerData", DefaultData)

local Profiles = {}

local DataService = {}

-------------------------------------------------

function DataService:GetProfile(player)

    return Profiles[player]

end

-------------------------------------------------

function DataService:GetData(player)

    local profile = Profiles[player]

    if not profile then
        return nil
    end

    return profile.Data

end

-------------------------------------------------

function DataService:LoadProfile(player)

    local profile =
        PlayerStore:StartSessionAsync(
            tostring(player.UserId)
        )

    if not profile then

        player:Kick("Failed to load your data.")

        return

    end

    profile:AddUserId(player.UserId)

    profile:Reconcile()

    profile.OnSessionEnd:Connect(function()

        Profiles[player] = nil

        if player.Parent then
            player:Kick("Your data session ended.")
        end

    end)

    Profiles[player] = profile

end

-------------------------------------------------

function DataService:ReleaseProfile(player)

    local profile = Profiles[player]

    if not profile then
        return
    end

    profile:EndSession()

    Profiles[player] = nil

end

-------------------------------------------------

function DataService:Get(player, key)

    local data = self:GetData(player)

    if not data then
        return nil
    end

    return data[key]

end

-------------------------------------------------

function DataService:Set(player, key, value)

    local data = self:GetData(player)

    if not data then
        return
    end

    data[key] = value

end

-------------------------------------------------

function DataService:Increment(player, key, amount)

    local data = self:GetData(player)

    if not data then
        return
    end

    data[key] += amount

end

-------------------------------------------------

Players.PlayerRemoving:Connect(function(player)

    DataService:ReleaseProfile(player)

end)

game:BindToClose(function()

    for player in pairs(Profiles) do

        DataService:ReleaseProfile(player)

    end

end)

return DataService
