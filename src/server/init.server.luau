--Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Remotes
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local ServeCustomerRemote = Remotes:FindFirstChild("ServeCustomer")
local BurgerToPlate = Remotes:FindFirstChild("BurgerToPlate")
local StartGameRemote = Remotes:FindFirstChild("StartGame")

--Variables
local CustomerModels = ServerStorage.Models.Customers
local CustomersFolder = workspace:FindFirstChild("Customers")
local CustomerAnchorPoint = workspace:FindFirstChild("CustomerAnchorPoint")

local KitchenFolder = workspace:FindFirstChild("Kitchen")
local KitchenBurger = KitchenFolder:FindFirstChild("Burger")
local KitchenSpawn = KitchenFolder:FindFirstChild("KitchenSpawn")
local DeliveredCounter = 0

local timer
local timerRunning = false
local countdownTimer

--Functions
local function startTimer(player)
    if timerRunning then
        timer:Disconnect()
    end

    timerRunning = true
    countdownTimer = 10
    local timerLabel = player.PlayerGui.GameScreen.TimerFrame.TimerLabel

    timer = game:GetService("RunService").Stepped:Connect(function(_, dt)
        countdownTimer = countdownTimer - dt
        timerLabel.Text = string.format("Time left: %d", math.ceil(countdownTimer))
        if countdownTimer <= 0 then
            timerRunning = false
            endGame()
        end
    end)
end

local function stopTimer()
    if timerRunning then
        timer:Disconnect()
        timerRunning = false
    end
end

local function newCustomer(player)
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

    -- Start the timer
    startTimer(player)
end

-- Kill the player and enable the StartScreenUI
local function resetPlayer(player)
    -- Kill the player
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = 0
    end

    -- Enable the StartScreenUI
    if player.PlayerGui:FindFirstChild("StartScreen") then
        player.PlayerGui.StartScreen.Enabled = true
	end
	
	-- Disable the GameScreenUI
	if player.PlayerGui:FindFirstChild("GameScreen") then
		player.PlayerGui.GameScreen.Enabled = false
	end
end

local function burgerMade()
    -- Call this function when a burger is made
    stopTimer()
end

function endGame()
    -- Clear all existing customers
    CustomersFolder:ClearAllChildren()
    
    DeliveredCounter = 0
        
    local playerService = game:GetService("Players")
    local players = playerService:GetPlayers()
    
    for _, player in pairs(players) do
        resetPlayer(player)
    end

    -- Stop the timer if the game ends
    stopTimer()
end



--Script
ServeCustomerRemote.OnServerEvent:Connect(function(player)		
	local backpack = player:FindFirstChildOfClass("Backpack")
	player.Character.Humanoid:UnequipTools()
	backpack:ClearAllChildren()
	print("Served customer")
	DeliveredCounter += 1
	if DeliveredCounter >= 10 then
		endGame()
		return
	end
	
	newCustomer(player)
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

        -- Call burgerMade function
        burgerMade()
    end
end)

StartGameRemote.OnServerEvent:Connect(function(player)		
	player.PlayerGui.StartScreen.Enabled = false
	player.PlayerGui.GameScreen.Enabled = true
    
	player.Character:MoveTo(KitchenSpawn.Position)
    
    newCustomer(player)
end)