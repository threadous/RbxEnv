--[[
Author @0Enum
]]

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local RbxEnv = ReplicatedStorage:WaitForChild('RbxEnv')

local Shared = RbxEnv.Shared
	
local NetworkModule = {}
NetworkModule.__index = NetworkModule

--[[
		
	@ Heirachy:
		
		@ NetworkModule [
			@ Network [
				-> Name : Network name/Remote event name
				-> Environment : Network Environment
				-> Core : Remote event
			]
		]

]]

--[[

	@ NetworkModule.create(name: string)
	//Subject: Network
	//Args: Network Name
	
	Follows heirarchy
]]


function NetworkModule.create(name : string)
	local Network = {}
	Network.Name = name
	Network.Suspended = false
	Network.Environment = {}
	
	if not Shared:FindFirstChild(name) then	
		local RemoteEvent = Instance.new('RemoteEvent', RbxEnv)
		RemoteEvent.Name = name
		RemoteEvent.Parent = Shared
		
		Network["Core"] = RemoteEvent
	else
		Network["Core"] = Shared:FindFirstChild(name)
	end
	
	setmetatable(Network, NetworkModule)
	return Network
end

--[[

	@ NetworkModule:SetEnv(Environment: EnvironmentClass)
	//Subject: Network
	//Args: Environment @ Environment Class
	//Differ: Associates the `Network` with the given `Environment`
	
	//Warning: Do NOT use this method in your code
	
]]

function NetworkModule:SetEnv(Environment)
	Environment["Networks"][self.Name] = self
end

--[[

	@ NetworkModule:Suspend()
	//Subject: Network
	//Args: None
	//Differ: Suspends the remote event/network. Event will not be fired even if you attempt to fire it.
	
]]

function NetworkModule:Suspend()
	self.Suspended = true
end

--[[

	@ NetworkModule:Unsuspend()
	//Subject: Network
	//Args: None
	//Differ: Unsuspends the network. Opposite of @ NetworkModule:Suspend()
	
]]

function NetworkModule:Unsuspend()
	self.Suspended = false
end

--[[

	@ NetworkModule:Fire(player: Player, ...)
	//Subject: Network
	//Args: player @ Player (NEEDED on the server, OPTIONAL on the client), ... @ any --> All other args
	//Differ: Fires the remote event depending on whether `Fire()` was called from the server/client. 
	
	@ Example:
	
		@ SERVER:
			GameNetwork:Fire(player, Gamekey)
			
		@ CLIENT:
			GameNetwork:Fire(Gamekey)
]]

function NetworkModule:Fire(player, ...)
	player = player or 0
	
	if self["Core"]:IsA('RemoteEvent') and not self.Suspended then
		if RunService:IsServer() then
			if player:IsA("Player") then
				self["Core"]:FireClient(player, ...)
			else
				return warn("Player parameter is missing!")
			end
		elseif RunService:IsClient() then
			
			if player == 0 then
				self["Core"]:FireServer(...)
			else
				self["Core"]:FireServer(player, ...)
			end
		end
	elseif self.Suspended then
		return warn(self.Name.." Network is currently suspended, any events will not register!")
	elseif self['Core']:IsA('RemoteEvent') == false then
		return warn(self.Name.." Unable to find remote event!")
	end
		
end

--[[

	@ NetworkModule:Grab(...)
	//Subject: Network
	//Args: Function AND local function arguments
	//Differ: Method for bootstrapping code to connect and recognize when the Network is fired.
	
	@ Example:
		GameNetwork:Grab(function(GameKey)
			print(GameKey)
		end)
	
]]

function NetworkModule:Grab(...)
	local method = ({...})
	if RunService:IsClient() then
		self["Core"].OnClientEvent:Connect(function(...)
			method[1](...)
		end)
	elseif RunService:IsServer() then
		self["Core"].OnServerEvent:Connect(function(...)
			if not self.Suspended then
				method[1](...)
			end
		end)
	end
end


return NetworkModule
