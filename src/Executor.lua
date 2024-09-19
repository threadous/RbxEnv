--[[
Author @0Enum
]]

local Executor = {}
Executor.__index = Executor
Executor.Executors = {}

-- // Initializes the executor (:TagJob() through env)
function Executor.new(ID)
	
	local self = {}
	self.Args = nil
	self.ID = ID
	
	Executor.Executors[ID] = self
	
	return setmetatable(self, Executor)
end

-- // Sets the arguments
function Executor:SetArgs(...)
	self.Args = ...
end

-- // Bootstrapping code for the connecting function
function Executor:CatchJob(...)
	
	local Breakdown = ({...})
	local Method = Breakdown[1]
	self.Method = Method
end

-- // Run the function, called ONLY by env
function Executor:RunJob()
	return self.Method(self.Args)
end

return Executor
