--Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Remotes
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local ServeCustomerRemote = Remotes:FindFirstChild("ServeCustomer")
local BurgerToPlate = Remotes:FindFirstChild("BurgerToPlate")

--Variables
local CustomersFolder = workspace:FindFirstChild("Customers")
local KitchenFolder = workspace:FindFirstChild("Kitchen")
local KitchenBurger = KitchenFolder:FindFirstChild("Burger")


--Script
ServeCustomerRemote.OnServerEvent:Connect(function(player)
	local Customer = workspace.Customers.Test
	if not Customer then
		print("No customer found")
		return
	end
	
	local RequestedItem = Customer:FindFirstChild("RequestedItem")
	if not RequestedItem then
		print("The customer has no requested item")
		return
	end
	
	
	local backpack = player:FindFirstChildOfClass("Backpack")
	player.Character.Humanoid:UnequipTools()
	backpack:ClearAllChildren()
	print("Served customer")
end)

BurgerToPlate.OnServerEvent:Connect(function(player, target)
    -- Check if the target is KitchenBurger
    if target.parent == KitchenBurger then
        -- Clear the player's backpack/hands
		local backpack = player:FindFirstChildOfClass("Backpack")
		player.Character.Humanoid:UnequipTools()
        backpack:ClearAllChildren()

        -- Give the player the Burger_Plated tool
        local burgerPlated = ServerStorage.Tools:FindFirstChild("Burger_Plated")
        if burgerPlated then
            local clonedBurgerPlated = burgerPlated:Clone()
            clonedBurgerPlated.Parent = backpack
        end
    end
end)