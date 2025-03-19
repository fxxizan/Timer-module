--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[=[
	@class TimerCalculator

	The module that calculates the current in game time
]=]

local TimerStartValue = ReplicatedStorage:WaitForChild("TimerStart") :: NumberValue
local SecondsLength = ReplicatedStorage:WaitForChild("SecondsLength") :: NumberValue

local TimerCalculator = {}

--[=[
	Just adds a 0 in front of the number if needed for the scoreboard text

	@param Time -- The time increment you want to pass
	@return string -- The converted format
	@within TimerCalculator
]=]

local function ConvertToDisplayableFormat(Time : number) : string
	if Time < 10 then
		return "0"..tostring(Time)
	else
		return tostring(Time)
	end
end

--[=[
	Calculates the time and returns it as a text format straight for your timer text

	@error "Potential overflow" -- You shouldn't call this when the timer playing value is false otherwise the timer will continue to run
	@return string -- The current in-game time
	@within TimerCalculator
]=]

function TimerCalculator:CalculateTime() : string
	if TimerStartValue.Value == 0 then
		return "00:00"
	end

	local TotalSeconds = (workspace:GetServerTimeNow() - TimerStartValue.Value) / SecondsLength.Value

	local MinutesToDisplay = math.floor(TotalSeconds / 60) --// A minute is still 60 seconds in game or IRL
	local SecondsToDisplay = math.floor(TotalSeconds % 60)

	MinutesToDisplay = ConvertToDisplayableFormat(MinutesToDisplay)
	SecondsToDisplay = ConvertToDisplayableFormat(SecondsToDisplay)
	
	return MinutesToDisplay.. ":" ..SecondsToDisplay
end

return TimerCalculator
