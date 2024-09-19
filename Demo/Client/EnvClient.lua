--[[
Author @0Enum
]]

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Package = ReplicatedStorage:WaitForChild('RbxEnv')

local RbxEnv = require(Package.Env)
task.wait(1)
RbxEnv.LoadClient()

local NetworkEnvironment = RbxEnv.GetEnvironment("NetworkEnv")
local Env = RbxEnv.GetEnvironment('ENV')

local CoreNetwork = NetworkEnvironment:GetNetwork("CoreNetwork")

local statNetwork = Env:GetNetwork("Stats")

CoreNetwork:Grab(function(...)
	print(...)
end)

statNetwork:Grab(function(throttle, speed, acceleration)
	print("Throttle: "..tostring(throttle))
end)

