if game.PlaceId == 6872265039 then
    local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
    local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
    local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

    local Window = Library:CreateWindow{
        Title = "Lobby hacks | Bedwars",
        SubTitle = "by syntaxical (no ingame just lobby)",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Darker",
        MinimizeKey = Enum.KeyCode.LeftControl
    }

    local Tabs = {
        Main = Window:CreateTab{
            Title = "Main",
            Icon = ""
        },
        Settings = Window:CreateTab{
            Title = "Settings",
            Icon = "settings"
        }
    }

    local Options = Library.Options

    Tabs.Main:CreateParagraph("Meanings", {
        Title = "Meanings",
        Content = "(C) = Visual (Client sided)\nL = People can see it (There may be limitations)"
    })

    Tabs.Main:CreateInput("LevelInput", {
        Title = "Level (C)",
        Default = game.Players.LocalPlayer:GetAttribute("PlayerLevel"),
        Numeric = true,
        Callback = function(Value)
            game.Players.LocalPlayer:SetAttribute("PlayerLevel", tonumber(Value))
        end
    })

    Tabs.Main:CreateInput("XPInput", {
        Title = "BattlePass Exp (C)",
        Default = game.Players.LocalPlayer:GetAttribute("BattlePassXP"),
        Numeric = true,
        Callback = function(Value)
            game.Players.LocalPlayer:SetAttribute("BattlePassXP", tonumber(Value))
        end
    })

    local BattlePassPaid = Tabs.Main:CreateToggle("BattlePassPaid", {
        Title = "BattlePass Owned (C)",
        Default = false
    })

    BattlePassPaid:OnChanged(function(v)
        game.Players.LocalPlayer:SetAttribute("BattlePassPaid", v)
    end)

    local ChatNameColor = Tabs.Main:CreateColorpicker("ChatNameColor", {
        Title = "ChatNameColor (C)",
        Default = game.Players.LocalPlayer:GetAttribute("ChatNameColor") or Color3.fromRGB(255,255,255)
    })

    ChatNameColor:OnChanged(function()
        game.Players.LocalPlayer:SetAttribute("ChatNameColor", ChatNameColor.Value)
    end)

    Tabs.Main:CreateInput("NES", {
        Title = "Nightmare_Emote slot (L)",
        Placeholder = "1 - 8",
        Numeric = true,
        Callback = function(Value)
            game.Players.LocalPlayer:SetAttribute("EmoteTypeSlot"..Value, "nightmare_1")
        end
    })

    Tabs.Main:CreateInput("Clantag", {
        Title = "Clan_Tag (C)",
        Placeholder = "Anything!",
        Callback = function(Value)
            game.Players.LocalPlayer:SetAttribute("ClanTag", Value)
        end
    })

    -- Managers
    SaveManager:SetLibrary(Library)
    InterfaceManager:SetLibrary(Library)

    SaveManager:IgnoreThemeSettings()

    InterfaceManager:SetFolder("FluentScriptHub")
    SaveManager:SetFolder("FluentScriptHub/bedwars-lobby")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    Library:Notify{
        Title = "Fluent",
        Content = "Loaded successfully.",
        Duration = 5
    }

else
    game.Players.LocalPlayer:Kick("This script is only for Bedwars lobby")
end
