--[[
Author @0Enum
]]

-- Either use a centralized or decentralized arrangement. Do NOT use both (for the sake of your sanity)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("RbxEnv")

local CoreFolder = script.Parent

local RbxEnv = require(Packages.Env)

RbxEnv.ConfigureCentralizedGameSettings(true, CoreFolder) -- Change to false to decentralize environment creation
RbxEnv.Initialize()
