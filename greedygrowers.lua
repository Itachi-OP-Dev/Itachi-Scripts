local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Greedy Growers Script",
    LoadingTitle = "Automation",
    LoadingSubtitle = "By itachi",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Automation", 4483362458)

local autoGiveEggs = false
local autoSpinWheel = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = ReplicatedStorage.Packages
    ._Index["sleitnick_knit@1.6.0"].knit

local PlayerPlotService = Knit.Services.PlayerPlotService
local StorkService = Knit.Services.StorkService
local ToolService = Knit.Services.ToolService
local SpinWheelService = Knit.Services.SpinWheelService


--------------------------------------------------
-- STORK
--------------------------------------------------

local function giveEggsToStorks()

    local pets = PlayerPlotService.RF.GetPlacedPets:InvokeServer()
    local ids = {}

    for _, pet in pairs(pets) do
        if pet.petType == "Stork" then
            table.insert(ids, pet.id)
        end
    end

    for _, id in ipairs(ids) do

        if not autoGiveEggs then
            break
        end

        ToolService.RE.ToggleEquip:FireServer(false, 928)
        task.wait(0.3)

        StorkService.RF.GivePet:InvokeServer(id)
        task.wait(0.3)

        ToolService.RE.ToggleEquip:FireServer(false, 928)
    end
end


--------------------------------------------------
-- AUTO GIVE EGGS TO STORK
--------------------------------------------------

Tab:CreateToggle({
    Name = "Auto Give Eggs to Stork",
    CurrentValue = false,
    Flag = "AutoGiveEggs",

    Callback = function(Value)

        autoGiveEggs = Value

        if Value then

            task.spawn(function()

                while autoGiveEggs do

                    giveEggsToStorks()

                    -- Wait 15 seconds for Storks to return
                    for i = 1, 15 do

                        if not autoGiveEggs then
                            break
                        end

                        task.wait(1)
                    end

                end

            end)

        end
    end
})


--------------------------------------------------
-- AUTO SPIN WHEEL
--------------------------------------------------

Tab:CreateToggle({
    Name = "Auto Spin Wheel",
    CurrentValue = false,
    Flag = "AutoSpinWheel",

    Callback = function(Value)

        autoSpinWheel = Value

        if Value then

            task.spawn(function()

                while autoSpinWheel do

                    -- Normal daily wheel spin
                    SpinWheelService.RE.clientSpinWheelRequest:FireServer("DAILY")

                    -- Wait between spins
                    -- This prevents rapid-fire requests
                    for i = 1, 5 do

                        if not autoSpinWheel then
                            break
                        end

                        task.wait(1)
                    end

                end

            end)

        end
    end
})


--------------------------------------------------
-- NOTIFICATION
--------------------------------------------------

Rayfield:Notify({
    Title = "Automation",
    Content = "Stork and Spin Wheel automation loaded!",
    Duration = 4
})
