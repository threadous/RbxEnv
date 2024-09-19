--[[
Author @0Enum
]]

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')

local Network = require(ReplicatedStorage.RbxEnv.Network)
local Executor = require(ReplicatedStorage.RbxEnv.Executor)

local RbxEnv = {}
RbxEnv.__index = RbxEnv
RbxEnv._initialized = false
ServerEnv = {}
--[[

	@ RbxEnv.new(name : string)
	//Subject: RbxEnv
	//Return: Running environment
	//Differ: Creates new environment
	//Type: Changable
	
	@ Example
	// Defining new
	local ENV = RbxEnv.new("ENV") 
	
	@ GetEnvironment
	// Environment already exists
	local ENV = RbxEnv.GetEnvironment("ENV")
]]

function RbxEnv.new(envName : string)
	
	if ServerEnv[envName] ~= nil then
		return error(envName.." already exists!")
	end
	
	local env = {}
	env.Name = envName
	env.Children = {}
	env.VAR = {}
	env.Networks = {}
	setmetatable(env, RbxEnv)
	
	ServerEnv[envName] = env
	
	return env
end


function RbxEnv.GetEnvironment(name : string)
	if ServerEnv[name] then
		return ServerEnv[name]
	else
		return warn(name.." does not exist!")
	end
end

--[[

	@ RbxEnv: ConfigureCentralizedGameSettings
	//Subject:RbxEnv
	//Return: None
	//Differ: Creates all needed environments, networks, game wide constants ahead of time in bulk.
	//Type: Init
	
	//Warnings (!): Should only be called ONCE and configured only through the ServerScriptService/Testing/Core/Start.lua script. 

]]
function RbxEnv.ConfigureCentralizedGameSettings(Value, CoreFolder)
	if not Value then return end
	
	--> Creates environments from `GameConfig`
	local function CreateEnvironments(GameEnv)
		for _, EnvName in GameEnv do
			RbxEnv.new(EnvName)
		end
	end
	
	--> Creates Networks from `GameConfig` by fetching the Env name and bulk creating networks
	local function CreateNetworks(GameNet)
		for EnvName, EnvNet in GameNet do
			
			local EnvClass = RbxEnv.GetEnvironment(EnvName)
			EnvClass:BuildNetworks(EnvNet)
		end
	end
	
	--> Creates the game constants from `GameConfig`. Same logic as `CreateNetworks()`
	local function CreateConsts(GameConst)
		for EnvName, EnvCosnt in GameConst do

			local EnvClass = RbxEnv.GetEnvironment(EnvName)
			
			for constName, constValue in GameConst do
				EnvClass:Variable(constName).set(constValue)
			end
		end
	end
	
	local GameConfig = require(CoreFolder.GameConfig)
	
	--> Data
	local GameEnv = GameConfig.GameEnvironments
	local GameNet = GameConfig.GameNetworks
	local GameConst = GameConfig.GameConstants
	
	--> Execution Chain
	CreateEnvironments(GameEnv)
	CreateNetworks(GameNet)
	CreateConsts(GameConst)
	
end

--[[

	@ RbxEnv: LoadClient()
	//Subject:RbxEnv
	//Return: None
	//Differ: Transfers server framework data to client
	//Type: Init
	
	//Warnings (!): Should be called AFTER Initialize() [Scroll down for Initialize() api]

]]

function RbxEnv.LoadClient()
	if RunService:IsClient() then
		local ClientFolder = script:WaitForChild('ClientFolder')
		
		for i, v in pairs(ClientFolder:GetChildren()) do
			local newClientEnv = RbxEnv.new(v.Name)
			for _, ClientNetwork in pairs(v:GetChildren()) do
				local newClientNetwork = newClientEnv:CreateNetwork(ClientNetwork.Name)
			end
		end
	else
		return error("RbxEnv.LoadClient() can only be called on the client!")
	end
	
	return print("Client successfully loaded!")
end

--[[

	@ RbxEnv: Initalize()
	//Subject:RbxEnv
	//Return: None
	//Differ: Initializes server to allow for client transfer
	//Type: Init
	
	//Warnings: Should be called before LoadClient()

]]

function RbxEnv.Initialize()
	
	if RunService:IsServer() then
		
		local ClientFolder = Instance.new("Folder")
		ClientFolder.Name = "ClientFolder"
		ClientFolder.Parent = script
		
		local function makeEnvFolder(envTable)
			local EnvFolder = Instance.new("Folder")
			EnvFolder.Name = envTable.Name
			EnvFolder.Parent = ClientFolder

			for i, v in pairs(envTable.Networks) do
				local ClientNetwork = Instance.new("StringValue")
				ClientNetwork.Parent = EnvFolder
				ClientNetwork.Name = v.Name
			end
		end
		
		for i, v in pairs(ServerEnv) do
			makeEnvFolder(v)
		end
		
		RbxEnv._initialized = true
	else
		return error("RbxEnv.Initialize() Function can only be called on the server!")
	end
		
end

--[[

	@ RbxEnv:Variable(name : string)
	//Subject: env
	//Return: Variable value
	//Differ: Creates new variable with corresponding name
	//Type: Changable
	
	// METHODS = .set(name : string)
	// PURPOSE = Set variable value
	
	@ Example
	ENV:Variable("Throttle").set(25)

]]


function RbxEnv:Variable(name : string)
	local var = {}
	var.Name = name
	var.__index = var
	var.parent = self
	var.Value = {}
	
	self.Children[name] = var
	
	var.Value.set = function(object)
		var.Value[var.Name] = object
		return var.Value
	end
	
	self.VAR[var.Name] = var
		
	return var.Value
end 

--[[

	@ RbxEnv:fetch(name : string)
	//Subject: env
	//Return: Variable value
	//Differ: Returns variable value
	//Type: READ ONLY

]]

function RbxEnv:fetch(name : string)
	if self.Children[name] then
		return self.Children[name].Value[name]
	end
	return "Value not assetted"
end

--[[

	@ RbxEnv:Get(name : string)
	//Subject: env
	//Return: Variable table
	//Differ: Returns variable to be set not value
	//Type: Changable
	
	//Purpose: Changing a variable value instead of creating a new variable with the same name
	
	@ Example:
		local SomeVariable = MyEnv:Variable("SomeVariable").set("Hello")
		
		@ WORKING:
		MyEnv:Get("SomeVariable").set("NewHello") -- Same variable but overriding with a new value

]]
function RbxEnv:Get(name : string)
	local VAR = self.VAR
	if VAR[name] then
		return VAR[name].Value
	else
		return warn(name.." does not eixst!")
	end
end

function RbxEnv:CreateNetwork(name : string)
	self:Variable(name).set(Network.create(name))
	self:fetch(name):SetEnv(self)
	
	print("Created!")
end

--[[
-- // Creating networks in bulk
 @Example:
	MyDataEnvironment:BuildNetworks({
		SavePlayerData,
		AddCoins,
		RemoveBoost,
	})

]]
function RbxEnv:BuildNetworks(packet)

	for _, name in packet do	
		self:Variable(name).set(Network.create(name))
		self:fetch(name):SetEnv(self)
	end

	print("Created!")
end

function RbxEnv:GetNetwork(name : string)
	return self:fetch(name)
end

--[[

	@ RbxEnv:GetExecutor(ID : string)
	//Subject: env
	//Return: Executor associated with the ID given if it exists in the env
	//Differ: Gives the executor component
	//Type: Variable

]]

function RbxEnv:GetExecutor(ID: string)

	local TargetExecutor = Executor.Executors[ID]
	if not TargetExecutor then return error("Executor with ID "..tostring(ID).." does not exist or may not be associated with the current environment!") end

	return TargetExecutor
end

--[[

	@ RbxEnv:AddExecutors(ID : string)
	//Subject: env
	//Return: Executor class (Table {})
	//Differ: Creates multiple executor classes [bindable alt]
	//Type: Fixed

]]

function RbxEnv:AddExecutors(...)
	
	local Breakdown = {...}
	local ProcessedExecutors = {}
	for Index, ID in Breakdown do
		ProcessedExecutors[Index] = Executor.new(ID)
	end
	
	return ProcessedExecutors
end

--[[

	@ RbxEnv:TagJob(ID : string)
	//Subject: env
	//Return: Processed function output
	//Differ: Fires the executor and sets the args (other way around)
	//Type: Fixed

]]

function RbxEnv:TagJob(ID, ...)
	
	local TargetExecutor = Executor.Executors[ID]
	if not TargetExecutor then return error("Executor with ID "..tostring(ID).." does not exist!") end
	
	TargetExecutor:SetArgs(...)
	return TargetExecutor:RunJob()
end

	
return RbxEnv
