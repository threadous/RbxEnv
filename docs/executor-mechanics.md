---
sidebar_position: 4
---

# Executor Mechanics

## What are Executors?

Executors act like `BindableEvents` (server-server communication). Unlike a `Network`, an `Executor` does not contain a literal `BindableEvent`. Executors are not environment restricted variables (like Networks); they can be accessed through any environment (explained more later on this page - executor utilization)

## Why use Executors?

Similar to a `Network`, an executor saves developers the trouble of manually creating bindable events and defining them. Executors were built compatible to RbxEnv to provide a smoother workflow. 

## Creating An Executor

Unlike a `Network` or a `GameConstant`, an `Executor` is either **server only** or **client only** as they are used for communication between server-to-server or client-to-client, which implies that executors need not be replicated so they need not be defined in the `GameConfig` module. 

The following code creates an executor of the name *StatCounter*:
```lua
RbxEnv:AddExecutors("StatCounter")

local statCounter = RbxEnv:GetExecutor("StatCounter")
```

Instead of adding only 1, you can chose to initialize multiple executors at once:
```lua
RbxEnv:AddExecutors("StatCounter", "GameCounter", "PlayerData")
```

To get an executor from another script:
```lua
local statCounter = RbxEnv:GetExecutor("StatCounter")
local gameCounter = RbxEnv:GetExecutor("GameCounter")
```

**Keep in mind that though you won't have to wait for an environment to be initialized to create/fetch executors, you must still wait to check if the executor itself has been initialized**

## Utilizing an Executor

Similar to a `Network`, you must first write bootstrapping code for your `Executor` before firing it.

You can use the `CatchJob` method to connect the executor to your own function:
```lua
local statCounter = RbxEnv:GetExecutor("StatCounter")

statCounter:CatchJob(function(someVariablePassed)
    print(someVariablePassed)
end)
```

`someVariablePassed` is the variable being passed through the `statCounter` executor in this case. 

The following code shows how you would fire an executor (**NOTE: Bootstrapping code must already have been written and compiled to run prior to firing an executor**)
```lua
RbxEnv:TagJob("StatCounter", "The variable I Passed!")
```
The code above fires the `Executor` called `StatCounter` and passes the string `"The variable I Passed"` as an argument.

You can add as many variables to pass through the Executor as you wish:
```lua
RbxEnv:TagJob("StatCounter", num1, num2, num3, num4)
```
And you can include this in your bootstrapping code
```lua
statCounter:CatchJob(function(num1, num2, num3, num4)
    print(num1 + num2 + num3 + num4)
end)
```