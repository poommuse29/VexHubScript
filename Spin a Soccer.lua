local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "VexHub",
    SubTitle = "Version 1.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Remote 
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local plr = game.Players.LocalPlayer
local EquipRemote = Remote:WaitForChild("EquipCard")

-- ตัวแปร
local autoBuy = false
local autoOpen = false
local autoCollect = false

local selectedBuyPacks = {"Bronze"}
local selectedOpenPacks = {"Bronze"}

local packOptions = {
    "Bronze","Silver","Gold","Platinum","Diamond","Toxic","Shadow",
    "Infernal","Corrupted","Cosmic","Eclipse","Hades","Heaven","Chaos",
    "Ordain","Alpha","Omega","Genesis","Abyssal","Enigma","Oracle"
}

do
    Fluent:Notify({
        Title = "VexHub",
        Content = "Script Loading...",
        SubContent = "Spin A Soccer Card",
        Duration = 5
    })

    -- Dropdown Buy 
    local DropBuy = Tabs.Main:AddDropdown("BuyPacks", {
        Title = "Select Auto Buy",
        Values = packOptions,
        Multi = true,
        Default = {"Bronze"},
    })

    DropBuy:OnChanged(function(value)
        selectedBuyPacks = {}
        for packName, isSelected in pairs(value) do
            if isSelected then
                table.insert(selectedBuyPacks, packName)
            end
        end
    end)

    -- Toggle Buy 
    local ToggleBuy = Tabs.Main:AddToggle("AutoBuy", {
        Title = "Auto Buy",
        Default = false
    })

    ToggleBuy:OnChanged(function(value)
        autoBuy = value
    end)

    -- Dropdown Open 
    local DropOpen = Tabs.Main:AddDropdown("OpenPacks", {
        Title = "Select Auto Open",
        Values = packOptions,
        Multi = true,
        Default = {"Bronze"},
    })

    DropOpen:OnChanged(function(value)
        selectedOpenPacks = {}
        for packName, isSelected in pairs(value) do
            if isSelected then
                table.insert(selectedOpenPacks, packName)
            end
        end
    end)

    -- Toggle Open 
    local ToggleOpen = Tabs.Main:AddToggle("AutoOpen", {
        Title = "Auto Open",
        Default = false
    })

    ToggleOpen:OnChanged(function(value)
        autoOpen = value
    end)

    -- Toggle Collect
    local ToggleCollect = Tabs.Main:AddToggle("AutoCollect", {
        Title = "Auto Collect",
        Default = false
    })

    ToggleCollect:OnChanged(function(value)
        autoCollect = value
    end)

    -- Loop Auto Buy 
    task.spawn(function()
        while true do
            if autoBuy then
                for _, pack in ipairs(selectedBuyPacks) do
                    pcall(function()
                        Remote:WaitForChild("BuyPack"):FireServer(pack)
                    end)
                    task.wait(0.3)
                end
            end
            task.wait(1)
        end
    end)

    -- Loop Auto Open 
    task.spawn(function()
        while true do
            if autoOpen then
                for _, pack in ipairs(selectedOpenPacks) do
                    pcall(function()
                        Remote:WaitForChild("OpenPack"):FireServer(pack)
                    end)
                    task.wait(0.3)
                end
            end
            task.wait(0.1)
        end
    end)

    -- Loop Auto Collect 
    task.spawn(function()
        while true do
            if autoCollect then
                for i = 1, 24 do
                    pcall(function()
                        Remote:WaitForChild("CollectSlot"):FireServer(i)
                    end)
                    task.wait(0.2)
                end
            end
            task.wait(0.1)
        end
    end)

    -- ===== Settings =====
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("VexHub")
    SaveManager:SetFolder("VexHub/spin-a-soccer-card")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)
    SaveManager:LoadAutoloadConfig()
end