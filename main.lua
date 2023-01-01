local name = game.Players.LocalPlayer.Name
local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
local hb = game:GetService("RunService").Heartbeat
local UIS = game:GetService("UserInputService")
local movements = {}
local main = {}
local builds = {}
local ignore = {}
main.Detect = {}
_G.CanCall = true

local kc = { -- KeyCodes
    ["Shift"] = 0xA0,
    ["Control"] = 0xA2,
    ["Space"] = 0x20,
    ["S"] = 0x53,
    ["W"] = 0x57,
    ["L"] = 0x4C,
    ["R"] = 0x52,
    ["Q"] = 0x51,
    ["A"] = 0x41,
    ["D"] = 0x44,
    ["E"] = 0x45
}

local Keys = {
    ["Space"] = function()
        if workspace.Camera.CFrame.LookVector.y > 0.9 and _G.CanCall then
            movements.WallBoost()
        end
    end,
    ["Control"] = function()
        keypress(kc["Shift"])
        wait(.03)
        keypress(kc["Space"])
        hb:wait()
        keyrelease(kc["Space"])
        hb:wait()
        keyrelease(kc["Shift"])
    end,
    ["M1"] = function()
        if _G.left or _G.right then
            movements.Magdash(20)
        end
    end,
    ["M2"] = function()
    end,
    ["F"] = function()
        movements.SpeedVault()
    end
}

builds.SpeedVault = function()
    local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
    local lv = workspace.Camera.CFrame.LookVector

    local platform = Instance.new("Part")
    platform.Size = Vector3.new(10, 50, 10)
    platform.Transparency = 0
    platform.Anchored = true
    platform.Parent = workspace
    platform.Position = rootpart.Position - Vector3.new(0, 25, 0)
    platform.Orientation = Vector3.new(rootpart.CFrame.LookVector.x * 180, platform.Orientation.y, rootpart.CFrame.LookVector.z * 180) 
    platform.Name = "platform"

    wait(3)

    platform:Destroy()
end

movements.WallBoost = function()
    if main.ConfirmOnTable(main.DetectWalls(), 'front') then
        _G.CanCall = false
        keyrelease(kc["Space"])
        mousemoverel(1000, 0)
        wait(0.07)
        keypress(kc["Space"])
        hb:wait()
        keyrelease(kc["Space"])
        mousemoverel(-1000, 0)
        wait()
        _G.CanCall = true
    end
end

movements.GearlessDash = function()
    function dash(power)
        if rootpart.Velocity.y < -30 then
            keypress(kc["Shift"])
            main.SetVelY(-15)
        end
        main.Boost(power)

        hb:wait()

        keypress(kc["Control"])
        hb:wait()
        keyrelease(kc["Control"])

        keypress(kc["Space"])
        hb:wait()
        keyrelease(kc["Space"])
        hb:wait()
        keyrelease(kc["Shift"])
    end
    function iskey(key)
        if UIS:IsKeyDown(key) then
            return true
        else
            return false
        end
    end
    if _G.left and _G.right ~= true then
        if iskey(Enum.KeyCode.A) and iskey(Enum.KeyCode.W) then
                
            dash(80)

            keyrelease(kc["W"])

            mousemoverel(1000, 0)

            wait(.05)
            
            keypress(kc["A"])

            hb:wait()

            keypress(kc["Space"])
            wait()
            keyrelease(kc["Space"])

            wait()

            mousemoverel(-500, 0)

            keyrelease(kc["A"])
            keypress(kc["W"])
        elseif not iskey(Enum.KeyCode.A) and iskey(Enum.KeyCode.W) then
            dash(40)

            keyrelease(kc["W"])

            mousemoverel(1000, 0)

            wait()
            
            keypress(kc["S"])

            wait()

            keypress(kc["Space"])
            wait()
            keyrelease(kc["Space"])

            wait()

            mousemoverel(-1000, 0)

            keyrelease(kc["S"])
            keypress(kc["W"])
        end
    elseif _G.right and _G.left ~= true then
        if iskey(Enum.KeyCode.D) and iskey(Enum.KeyCode.W) then
            dash(80)

            keyrelease(kc["W"])

            mousemoverel(1000, 0)

            wait()
            
            keypress(kc["D"])

            wait()

            keypress(kc["Space"])
            wait()
            keyrelease(kc["Space"])

            wait()

            mousemoverel(-1000, 0)

            keyrelease(kc["D"])
            keypress(kc["W"])   
        elseif iskey(Enum.KeyCode.W) and not iskey(Enum.KeyCode.D) then
            dash(40)

            keyrelease(kc["W"])

            mousemoverel(1000, 0)

            wait()
            
            keypress(kc["S"])

            wait()

            keypress(kc["Space"])
            wait()
            keyrelease(kc["Space"])

            wait()

            mousemoverel(-1000, 0)

            keyrelease(kc["S"])
            keypress(kc["W"])
        end
    elseif _G.right and _G.left then
        dash(40)

        wait()

        keypress(kc["Space"])
        wait()
        keyrelease(kc["Space"])
    end

end

movements.Magdash = function(pwr)
    if pwr ~= nil then
        main.Boost(pwr)
    end
    keypress(kc["E"])
    hb:wait()
    keyrelease(kc["E"])
    wait(.1)
    keypress(kc["Space"])
    hb:wait()
    keyrelease(kc["Space"])
end

movements.SpeedVault = function()
    local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
    if _G.pos == nil or _G.location == nil then
        _G.pos = main.MouseToPos()
        _G.location = rootpart.Position
    else
        if main.ConfirmOnTable(main.DetectWalls(), 'left') then
            print("Pass", unpack(main.DetectWalls()))
        end
    end
end

main.ConfirmOnTable = function(table, value)
    if table ~= nil and value ~= nil then
        for i,v in pairs(table) do
            if v == value then
                return v
            end
        end
    end
end

main.SetCollision = function()
    function cancol(obj)
        obj.CanCollide = false
        task.wait(.5)
        obj.CanCollide = true 
    end
    for i, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.CanCollide then
            if (v.Position - rootpart.Position).magnitude < 200 then
                coroutine.wrap(cancol)(v)
            end
        end
    end
end

main.Detect.Back = function(y)
    local name = game.Players.LocalPlayer.Name
    local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
    local position = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart").Position
    if y == nil then
        position = Vector3.new(rootpart.Position.x, rootpart.Position.y, rootpart.Position.z)
    else
        if y > 0 then
            position = Vector3.new(rootpart.Position.x, rootpart.Position.y + y, rootpart.Position.z)
        else
            position = Vector3.new(rootpart.Position.x, rootpart.Position.y - (y * -1), rootpart.Position.z)
        end
    end
    local ignore = {}
    local pov
    function ignorebody()
        for i,v in pairs(workspace[name]:GetDescendants()) do
            if v:IsA("Part") then
                table.insert(ignore, v)
            end
        end
    end
    local Player = game.Players.LocalPlayer.Name
    local Lenght = 8
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {ignore}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    pov = rootpart.CFrame * CFrame.Angles(0, math.rad(180), 0)
    local Back = workspace:Raycast(position, pov.LookVector*Lenght, params)
    if Back then -- If wall is in front of you
        return true
    else
        return false
    end
end

main.DetectWalls = function(value)
    local ignore = {}
    local result = {}
    function ignorebody()
        for i,v in pairs(workspace[name]:GetDescendants()) do
            if v:IsA("Part") then
                table.insert(ignore, v)
            end
        end
    end
    function ray(pov)
        ignorebody()
        local Player = game.Players.LocalPlayer.Name
        local Lenght = 8
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {ignore}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local Ray = Ray.new(rootpart.Position, pov*Lenght)
        local Wall = workspace:Raycast(rootpart.Position, pov*Lenght, params)
        if Wall then -- If wall is in front of you
            return true
        end
    end

    local frontpov = rootpart.CFrame + rootpart.CFrame.Position + Vector3.new(0, value, 0)
    frontpov = frontpov + (frontpov.Position + Vector3.new(0, value, 0))
    if value ~= nil then
        local frontpov = rootpart.CFrame + rootpart.CFrame.Position + Vector3.new(0, value, 0)
    else
        local frontpov = rootpart.CFrame
    end
    local rotation = math.rad(90)
    local rightpov = frontpov * CFrame.Angles(0, rotation * -1, 0)
    local leftpov = frontpov * CFrame.Angles(0, rotation, 0)
    if ray(frontpov.LookVector) then
        table.insert(result, 'front')
    end
    if ray(rightpov.LookVector) then 
        table.insert(result, 'right')
    end
    if ray(leftpov.LookVector) then
        table.insert(result, 'left')
    end
    if result[1] ~= nil then
        return result
    end
end

main.DetectGround = function()
    function ignorebody()
        for i,v in pairs(workspace[name]:GetDescendants()) do
            if v:IsA("Part") then
                table.insert(ignore, v)
            end
        end
    end
    ignorebody()
    local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
    local Player = game.Players.LocalPlayer.Name
    local Lenght = 8
    local pov = rootpart.CFrame
    local rotation = math.rad(-90)
    local downpov = pov * CFrame.Angles(rotation, 0, 0)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {ignore}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local Ground = workspace:Raycast(rootpart.Position, downpov.LookVector*Lenght, params)
    if Ground ~= nil then -- If ground is below you
        return true
    else
        return false
    end
end

main.teleport = function(y)
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
    Character:SetPrimaryPartCFrame(CFrame.new(rootpart.Position.x, y - 2, rootpart.Position.z))
end

main.MouseToPos = function()
    local mouse = game.Players.LocalPlayer:GetMouse()
    local pos = mouse.hit.p
    return pos
end

main.AimOnPos = function(pos)
    local diff = 1000
    while diff > 10 do
        local Mouse = game:GetService("UserInputService"):GetMouseLocation()
        local vector, OnScreen = workspace.Camera:WorldToScreenPoint(_G.pos)
        local xy = Vector2.new(vector.x, vector.y)
        local dif = (xy.x - Mouse.x)


        mousemoverel(dif, 0)
        if dif < 0 then
            diff = dif * -1
        else
            diff = dif
        end
        hb:wait()
    end
end

main.MoveScreen = function(pixels, move)
    local number = pixels / move
    for i=1, number do
        mousemoverel(move, 0)
        hb:wait()
    end
end

main.log = function()
    _G.con = UIS.InputBegan:Connect(function(key, gameProcessedEvent)
        main.DetectWalls()
        if gameProcessedEvent then
            return
        end
        if key.KeyCode == Enum.KeyCode.Space then
            Keys["Space"]()      
        end
        if key.KeyCode == Enum.KeyCode.LeftControl then
            Keys["Control"]()
        end
        if key.UserInputType == Enum.UserInputType.MouseButton1 then
            Keys["M1"]()
        end
        if key.UserInputType == Enum.UserInputType.MouseButton2 then
            Keys["M2"]()
        end
        if key.KeyCode == Enum.KeyCode.F then
            Keys["F"]()
        end
    end)
end

main.Boost = function(mult, useY)
    local LV = workspace.Camera.CFrame.LookVector
    for i,v in pairs(workspace:WaitForChild(name):GetDescendants()) do
        if v:IsA("Part") then
            if mult ~= 0 then
                if useY then
                    v.Velocity = v.Velocity + LV * mult
                else
                    local y = v.Velocity.y
                    v.Velocity = v.Velocity + LV * mult
                    v.Velocity = Vector3.new(v.Velocity.x, y, v.Velocity.z)
                end
            else
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

main.SetVelY = function(value)
    for i,v in pairs(workspace:WaitForChild(name):GetDescendants()) do
        if v:IsA("Part") then
            v.Velocity = Vector3.new(v.Velocity.x, value, v.Velocity.z)
        end
    end
end

main.SetVel = function(value)
    for i,v in pairs(workspace:WaitForChild(name):GetDescendants()) do
        if v:IsA("Part") then v.Velocity = value end
    end
end

main.loop = function()
    function autoRoll()
        rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart")
        if rootpart.Velocity.y < -26 then
            if main.DetectGround() then
                keypress(kc["Shift"])
                wait(.1)
                keyrelease(kc["Shift"])
            end
        end
    end
    while wait(.01) do
        autoRoll()
    end
end

if _G.Loaded then
    _G.con:Disconnect()
    wait()
    main.log()
else
    _G.Loaded = true
    main.log()
    main.loop()
end