---
sidebar_position: 3
---

# Network Mechanics

## What is an env Network?

A `Network` class represents a **single remote event**. It is a table that contains other information including a direct path to your **remote event**. 

All the examples provided on this page are either through a `server-script` or the `GameConfig` file.

## Why use Network?

Env Networks were built to go hand in hand with environments. Developers often find it repetative to define the same `ReplicatedStorage/Framework/Remotes/Events` in almost every script. Networks work well with `Environments`. Any `Network` created is stored as a variable with the particular environment assigned to it so they can be accessed by any script by just defining the `Environment`.

Networks also simplify organization and save you time from having to handle remote events manually. It also offers additional features and control over remote events such.

## Basic Network Initialization

In the most basic form, a network can be created by:
```lua
coreNetwork:CreateNetwork("BuyCurrency")
```
The code creates a `Network` class with a `RemoteEvent` with the name `"BuyCurrency"

However, this was designed as an early functionality of RbxEnv is **not** recommended to be created this way. 

## Creating a Network

The best way to avoid any logical errors when creating a Network is to directly to type it in the `GameConfig` file. 

As seen earlier, the `GameConfig` module had 3 tables. Of the 3, one of them named `GameNetworks` stores all the networks with its corresponding environment.

**Why not create networks manually?**
- A `Network` is essentially a remote event and both the client and the server must have access to it in order for it to work. Though a remote event created on the server **will** replicate to the client, a `Network` **will not**. A `Network` is a class and is stored in an environment. So any changes to an environment after initialization **will not** carry over to the client. Creating a `Network` manually does not guarantee a successful replication, however following a centralized system and using the `GameConfig` module does.

For this example, the code will be creating a network called `BuyCurrency` for the environment `EnvironmentBasics`:

```lua
  ["GameNetworks"] = {

    ["EnvironmentBasics"] = { -- Environment
        "BuyCurrency", -- Network name
    },
  },
```

Typing the name of the network auto-creates a network for you under the environment assigned and can now be accessed by any part of your game (server/client) by accessing the environment. 

## Accessing a Network

Once a network is created, it is stored as a variable in the `Environment` it was assigned (in this case- `BuyCurrencyNetwork` was stored in `EnvironmentBasics`). The variable name is the same as the name of the network.

To get a network:
```lua
local buyCurrencyNetwork = EnvironmentBasics:GetNetwork("BuyCurrency")
```

## Connecting a Network (Server & Client)

Networks-just as remote events-are useless if they aren't connected to a function. You must first write the bootstrapping code for each network before firing them.

The bootstrapping code for a network is very similar to a `RemoteEvent.OnServerEvent:Connect(function())`, however a lot of the other text is skipped when using `Networks`. 

**There isn't a big difference of how `Networks` are grabbed on the server or the client. The same function can be used to write bootstrapping code to connect the events. However, keep in mind `Networks` follow the same convention remote events do. (player parameter comes first in a .OnServerEvent)**

In this example, the following code writes the functionality for when the `BuyCurrency` network is fired:

```lua
buyCurrencyNetwork:Grab(function(player, text) -- you may include any other parameters after the player parameter if you are firing the network with arguments on the client.
    
    -- Do something in the remote event
    print("Text from the player: "..text)
end)
```

## Firing a Network (Server & Client)

Firing a network is very similar to that of a remote event. 
```lua
buyCurrencyNetwork:Fire("My text argument goes here!") -- add player parameter if firing from the server
```

Rather than `:FireClient()` or `:FireServer()`, you can just call `:Fire()`. The Network will automatically call the correct remote event method based on the file from which you call it from (server or client). 

As stated before, the `Network` follows the same convention as a remote event. Meaning that the parameters for player or any other arguments will also follow the same way they do with a remote event. 

## Suspending a Network

`Network` offers an additional functionality which allows you to `suspend` your networks. Meaning that a network cannot be fired if it is suspended. This is a great functionality to safeguard your game from exploiters as a Network fired when suspended auto overwrites any of the bootstrapping code to avoid making the server code run. 

The syntax for it is as follows:
```lua
buyCurrencyNetwork:Suspend()

buyCurrencyNetwork:Unsuspend()
```

**Your network will remain suspended unless you unsuspend it.**

Keep in mind that network suspension is a functionality called after RbxEnv initialization. When suspending, you must suspend the network on both the client and the server (only server is required but client is also recommended) but you must unsuspend the network on both the server and client if you had suspended the network on the client. 

## Important Info

- A `Network` can only be accessed from the environment it was declared in. Code will not run if you try to access a network declared in `EnvironmentBasics` and try to access it from another environment.

- Creating a `Network` **after** RbxEnv initialization is not recommended (it will not work). Use the `GameConfig` module to setup all your environment instances. 

- Do **not** use the `:setEnvironment` method for the `Network` class. Doing so will change the the network parent to another environment on either the server or the client but not both and may result in an unorganized codebase. 

## Additional Info

`Networks` are remote events. The next page contains information about `Executors` which essentially act like bindable events. 