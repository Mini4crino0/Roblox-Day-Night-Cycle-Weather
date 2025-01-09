-- Day-Night Cycle and Weather Effects Script for Roblox

local lighting = game:GetService("Lighting")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Variables for the Day-Night Cycle
local dayDuration = 300  -- Duration of a full day (in seconds)
local nightDuration = 180 -- Duration of a full night (in seconds)
local timeOfDay = 0
local weatherState = "Clear" -- Initial weather state

-- Skybox Settings
local skyboxDay = "rbxassetid://1234567890"  -- Replace with your skybox asset ID
local skyboxNight = "rbxassetid://0987654321"  -- Replace with your skybox asset ID

-- Lighting Settings for Day and Night
local dayLighting = Color3.fromRGB(255, 255, 255)  -- Bright daylight
local nightLighting = Color3.fromRGB(100, 100, 120)  -- Dim night lighting
local rainEffect = "rbxassetid://8765432109"  -- Rain particle effect
local stormEffect = "rbxassetid://1029384756"  -- Storm particle effect

-- Function to Update the Time of Day
local function updateTimeOfDay(deltaTime)
    timeOfDay = (timeOfDay + deltaTime) % (dayDuration + nightDuration)

    if timeOfDay < dayDuration then
        -- Daytime logic
        lighting.TimeOfDay = "14:00:00"  -- Set to noon time for day
        lighting.Skybox = game:GetService("ReplicatedStorage"):WaitForChild("DaySkybox")
        lighting.Ambient = dayLighting
    else
        -- Nighttime logic
        lighting.TimeOfDay = "02:00:00"  -- Set to late-night time for night
        lighting.Skybox = game:GetService("ReplicatedStorage"):WaitForChild("NightSkybox")
        lighting.Ambient = nightLighting
    end
end

-- Function to Update the Weather
local function updateWeather()
    local randWeather = math.random(1, 3)
    
    if randWeather == 1 then
        weatherState = "Clear"
        -- Clear weather
        game:GetService("ReplicatedStorage").RainEffect:Destroy()
        game:GetService("ReplicatedStorage").StormEffect:Destroy()
    elseif randWeather == 2 then
        weatherState = "Rain"
        -- Rainy weather
        if not game:GetService("ReplicatedStorage"):FindFirstChild("RainEffect") then
            local rain = Instance.new("ParticleEmitter")
            rain.Name = "RainEffect"
            rain.Texture = rainEffect
            rain.Parent = workspace.Terrain
        end
    elseif randWeather == 3 then
        weatherState = "Storm"
        -- Stormy weather
        if not game:GetService("ReplicatedStorage"):FindFirstChild("StormEffect") then
            local storm = Instance.new("ParticleEmitter")
            storm.Name = "StormEffect"
            storm.Texture = stormEffect
            storm.Parent = workspace.Terrain
        end
    end
end

-- Main Loop for Day-Night Cycle and Weather Changes
local function mainLoop()
    local lastUpdate = tick()
    local weatherChangeInterval = math.random(60, 300)  -- Random interval for weather change (1 to 5 minutes)

    while true do
        local deltaTime = tick() - lastUpdate
        lastUpdate = tick()

        -- Update the time of day based on elapsed time
        updateTimeOfDay(deltaTime)

        -- Update the weather periodically
        if tick() % weatherChangeInterval == 0 then
            updateWeather()
            weatherChangeInterval = math.random(60, 300)  -- Set next weather change interval
        end
        
        -- Yield the loop to wait for the next frame
        runService.RenderStepped:Wait()
    end
end

-- Start the main loop for the Day-Night Cycle and Weather Effects
mainLoop()

