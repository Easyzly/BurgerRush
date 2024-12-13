--Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Remotes
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local ServeCustomerRemote = Remotes:FindFirstChild("ServeCustomer")
local BurgerToPlate = Remotes:FindFirstChild("BurgerToPlate")

--Variables
local CustomerModels = ServerStorage.Models.Customers
local CustomersFolder = workspace:FindFirstChild("Customers")
local CustomerAnchorPoint = workspace:FindFirstChild("CustomerAnchorPoint")

local KitchenFolder = workspace:FindFirstChild("Kitchen")
local KitchenBurger = KitchenFolder:FindFirstChild("Burger")

--Functions
function newCustomer()
    -- Clear all existing customers
    CustomersFolder:ClearAllChildren()
    
    -- Get a random customer model
    local customerModels = CustomerModels:GetChildren()
    local randomIndex = math.random(1, #customerModels)
    local randomCustomerModel = customerModels[randomIndex]
    
    -- Clone the random customer model
    local newCustomer = randomCustomerModel:Clone()
    
    -- Set the primary part of the new customer to the CustomerAnchorPoint
    newCustomer:SetPrimaryPartCFrame(CustomerAnchorPoint.CFrame)
    
    -- Parent the new customer to the CustomersFolder
    newCustomer.Parent = CustomersFolder
end
newCustomer()

--Script
ServeCustomerRemote.OnServerEvent:Connect(function(player)		
	local backpack = player:FindFirstChildOfClass("Backpack")
	player.Character.Humanoid:UnequipTools()
	backpack:ClearAllChildren()
	print("Served customer")
	newCustomer()
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