--[[
Author @0Enum
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService('Players')
local Package = ReplicatedStorage:WaitForChild('RbxEnv')

local RbxEnv = require(Package.Env)

local myEnv = RbxEnv.new("ENV")

myEnv:Variable("Throttle").set(0)
myEnv:Variable("Speed").set(0)
myEnv:Variable("Acceleration").set(0)

myEnv:CreateNetwork("Stats")

Players.PlayerAdded:Connect(function(player : Player)
	myEnv:GetNetwork("Stats"):Fire(player, myEnv:fetch("Throttle"), myEnv:fetch("Speed"), myEnv:fetch("Acceleration"))
end)


