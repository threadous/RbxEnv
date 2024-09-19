---
sidebar_position: 2
---

# Environment Mechanics

## The Basics

Let's start by creating a variable that would be shared by both the server and the client through the `GameConfig` module.

To add a constant `Gravity` to the environment `EnvironmentBasics` we can do:
```lua
["GameConstants"] = {
    ["EnvironmentBasics"] = {
        Gravity = 9.8,
    }
}
```

Doing this creates a variable in the `EnvironmentBasics` that will be carried over to the client. Changing this variable via a script will not replicate across the game. Once initialized, this value will stay be initialized to both the client and the server. In order to change this, you must add a method so that when the server changes this value, the client also does so. 

## Variable Mechanics

The previous code was aimed at creating variables shared across both the client and the server. Variables would only replicate if declared in the `GameConfig` file. 

But in cases where you wouldn't want variables replicated and want to create variables **AFTER** initializing the environment, you could create a variable directly:

Let's create a new environment called `coreEnvironment` and initialize a few variables in it.

**IMPORTANT**
**Make sure that your code yields for RbxEnv to first initialize then create any non-replicating environments**

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Package = ReplicatedStorage:WaitForChild('RbxEnv')

local RbxEnv = require(Package.Env)

-- // Creating a new environment
-- // Perhaps add a wait for 2 seconds before declaring the variable so the environment is not initialized along with RbxEnv

task.wait(2)
local coreEnvironment = RbxEnv.new("coreEnvironment")
```

Now that we have our code set-up, we can create a variable. For the example, it will be called `GameData`

The following code block initialized and declares a variable called `GameData` in the `coreEnvironment` and sets the value of the variable to `"Very Important Data"`.
```lua
--// Creating a variable

coreEnvironment:Variable("GameData").set("Very Important Global Data")
```

## Getting a variable value

To reference the same variable value in the same script, you would do:
```lua
coreEnvironment:fetch("GameData") -- // Returns the value "Very Important Global Data"
```

## Fetching a variable

To re-assign a value or change the value of a variable, you would use the `Get` method:
```lua
coreEnvironment:Get("GameData").set("Not so important anymore")
```

The `Get` method returns the `variable` structure which has the `set` method that allows you to set its value. 

## Loading an Environment

Accessing an environment is relatively simple. **You must always wait before getting the environment or check to make sure if the environment you are trying to access has already been defined**. 

In some cases, you might be declaring all your environments at the start of the script but add a `task.wait(1)` to make sure that any other scripts that are creating the environment have ran first. 

Now that we have `coreEnvironment` initialized, create a new script so we can access this environment:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Package = ReplicatedStorage:WaitForChild('RbxEnv')

local RbxEnv = require(Package.Env)

task.wait(1)
local coreEnvironment = RbxEnv.GetEnvironment("coreEnvironment") -- Get the coreEnvironment (environment class)
```

After defining `coreEnvironment` you can modify/change this environment as you would and fetch any of its variables. 

Environments go great with `Networks`; the next page will talk about how `RemoteEvents` and `BindableEvents` are embedded into `Environments` through a `Network`. 
