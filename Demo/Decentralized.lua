--[[
Author: @0Enum
Example of decentralized environment creation. 
]]


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Package = ReplicatedStorage:WaitForChild("RbxEnv")

local RbxEnv = require(Package.Env)

local DataEnvironment = RbxEnv.new("DataEnvironment")
local DataExecutors = RbxEnv:AddExecutors("SaveData", "UpdateData")

local GameKey = "NineTwo"
local SaveDataExecutor = RbxEnv:GetExecutor("SaveData")

--> Bootstrapping code before firing [MUST BE DEFINED BEFORE TAGGING A JOB (firing the executor)]
SaveDataExecutor:CatchJob(function(GameKey)
	print(GameKey)
end)

task.wait(3)


--> INFO:
--[[

	-- OLDER version comments. Developers may just use RbxEnv to access any executor. You need not use an environment class to access it.

	--> Executors don't need to be associated with an environment. 
	--> You can access ANY executor through ANY environment.
	--> DataEnvironment:TagJob("SaveData", args) = RandomEnvironment:TagJob("SaveData", args)
	--> This also applies for DataEnvironment:GetExecutor(ID) = RandomEnvironment:GetExecutor(ID)
	--> DataEnvironment:AddExecutors(ID1, ID2) will NOT carry any associations with the `DataEnvironment`, you can acccess it via ALL environments. 
	--> The `environment` class acts as a gateway to access any executor; to create or use. 
	--> Executors can be handled independent to environments if the executor module is access directly via the script. This is NOT recommended as executors were built to be synced with the `environment` class but not a specific environment.
]]

RbxEnv:TagJob("SaveData", GameKey)
