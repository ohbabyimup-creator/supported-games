-- Simple Hub Movement Script (Owl Hub Style)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Movement Hub", "DarkTheme")

-- Main Variables
local PLayers = game:GetService("Players")
local LocalPlayer = PLayers.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local WalkSpeedVal = 16
local JumpPowerVal = 50
local FlySpeed = 50

local Flying = false
local Noclipping = false
local InfiniteJump = false

-- Tabs
local MovementTab = Window:NewTab("Movement")
local Section = MovementTab:NewSection("Controls")

-- WalkSpeed
Section:NewTextBox("WalkSpeed", "Changes your speed", function(txt)
    WalkSpeedVal = tonumber(txt) or 16
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = WalkSpeedVal
    end
end)

-- JumpPower
Section:NewTextBox("JumpPower", "Changes your jump height", function(txt)
    JumpPowerVal = tonumber(txt) or 50
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = JumpPowerVal
    end
end)

-- Infinite Jump
Section:NewToggle("Infinite Jump", "Jump forever in the air", function(state)
    InfiniteJump = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- Noclip
Section:NewToggle("Noclip", "Walk through walls", function(state)
    Noclipping = state
end)

RunService.Stepped:Connect(function()
    if Noclipping and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
Section:NewToggle("Fly", "Fly around (Uses E to toggle / WASD to move)", function(state)
    Flying = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if Flying then
        local hrp = char.HumanoidRootPart
        local bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while Flying and task.wait() do
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new(0,0,0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                
                bv.velocity = moveDir.Unit * FlySpeed
                bg.cframe = cam.CFrame
                
                if moveDir == Vector3.new(0,0,0) then
                    bv.velocity = Vector3.new(0, 0.1, 0)
                end
            end
            bg:Destroy()
            bv:Destroy()
        end)
    end
end)

-- Loop to maintain speeds when respawning
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum.WalkSpeed ~= WalkSpeedVal and not Flying then
            hum.WalkSpeed = WalkSpeedVal
        end
    end
end)
