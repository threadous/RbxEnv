return {
	
	["GameEnvironments"] = {
		-- Add the names of all the environments you will be using here
		--[[
			@ Example:
				"PlayerDataEnvironment",
				"CashEnvironment",
		]]
		
		"EnvironmentBasics", -- Delete. Used as an example
	},
	
	["GameNetworks"] = {
		-- Add the names of all the networks you will be using under the designated environment here
		--[[
			@ Example:
				PlayerDataEnvironment = {
					"SaveData",
					"SetData",
					"UpdateData",
				},
		]]
		
		["EnvironmentBasics"] = { -- Delete. Used as an example
			"SaveData",
			"SetData",
			"UpdateData",
		},
	},
	
	["GameConstants"] = {
		-- Constants that are shared by both the server and the client. Define them here as well
		--[[
		
			@ Example:
				EnvironmentBasics = {
					Gravity = 9.8,
				},
		]]
		
		["EnvironmentBasics"] = { -- Delete. Used as an example
			Gravity = 9.8,
		},
		
	}
}
