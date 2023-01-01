function back(y)
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name == 'Clone' then
			v:Destroy()
		end
	end
	local name = game.Players.LocalPlayer.Name
	local rootpart = workspace:WaitForChild(name):WaitForChild("HumanoidRootPart"):Clone()
	rootpart.Parent = workspace
	rootpart.Name = 'Clone'
	if y == nil then
		rootpart.Position = Vector3.new(rootpart.Position.x, rootpart.Position.y, rootpart.Position.z)
	else
		if y > 0 then
			rootpart.Position = Vector3.new(rootpart.Position.x, rootpart.Position.y + y, rootpart.Position.z)
		else
			rootpart.Position = Vector3.new(rootpart.Position.x, rootpart.Position.y - (y * -1), rootpart.Position.z)
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
    local Back = workspace:Raycast(rootpart.Position, pov.LookVector*Lenght, params)
    if Back then -- If wall is in front of you
        return 'yes'
    else
        return 'no'
    end
end