--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

type Teams = "Home" | "Away"
type EligibleValueType = "Name" | "Score"
type NewValues = string | number

--[=[
	@class VisualHandler

	The module that handles changing the visual stuff of the scoreboard
]=]

local ScoreboardVisuals = {}

-- I hate this sigh

local HomeScore = Instance.new("IntValue")
HomeScore.Name = "HomeScore"
HomeScore.Value = 0
HomeScore.Parent = ReplicatedStorage

local AwayScore = Instance.new("IntValue")
AwayScore.Name = "AwayScore"
AwayScore.Value = 0
AwayScore.Parent = ReplicatedStorage

local HomeName = Instance.new("StringValue")
HomeName.Name = "HomeName"
HomeName.Value = "HOME"
HomeName.Parent = ReplicatedStorage

local AwayName = Instance.new("StringValue")
AwayName.Name = "AwayName"
AwayName.Value = "AWAY"
AwayName.Parent = ReplicatedStorage

local TimerModule = require("./CalculateTime")

--[=[
	This function just sets the new value of a certain value of the team you specify.

	@param Team The team you want to change the value of
	@param ValueType The type of value you want to change
	@param NewValue The new value
	@within VisualHandler
]=]

function ScoreboardVisuals:UpdateValue(Team : Teams, ValueType : EligibleValueType, NewValue : string | number)
	local ValueToChange = ReplicatedStorage:FindFirstChild(Team..ValueType) :: (StringValue | IntValue)?

	if ValueToChange ~= nil then
		ValueToChange.Value = NewValue
	end
end

function ScoreboardVisuals:StartTimer()
	TimerModule:StartTimer()
end

function ScoreboardVisuals:StopTimer()
	TimerModule:StopTimer()
end

return ScoreboardVisuals