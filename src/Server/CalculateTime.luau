--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TimeStartValue = Instance.new("NumberValue")
TimeStartValue.Name = "TimerStart"
TimeStartValue.Value = 0
TimeStartValue.Parent = ReplicatedStorage

local TimerPlayingValue = Instance.new("BoolValue")
TimerPlayingValue.Name = "IsPlaying"
TimerPlayingValue.Value = false
TimerPlayingValue.Parent = ReplicatedStorage

local SecondLength = Instance.new("NumberValue")
SecondLength.Name = "SecondsLength"
SecondLength.Value = 0.3
SecondLength.Parent = ReplicatedStorage

--- @class TimerModule
---
--- The module that handles starting, stopping and tracking the timer

local TimerModule = {
    Minutes = 0 :: number,
    Seconds = 0 :: number,

    HalfTimes = {45, 90, 105, 120}
}


--[=[
	This function sets the new time of the scoreboard. We usually use this for fixing the client time if the timer stops for a while and then restarts
    You might want to note that this automatically adjusts for overflows (e.g trying to set the time to 3:80 will adjust it to 4:20)

	@param Minutes number -- The minute you want to set the timer to
	@param Seconds number -- The second you want to set the timer to
]=]

function TimerModule:SetTimerTime(Minutes : number, Seconds : number)
	if Seconds > 59 then
		Minutes += math.floor(Seconds / 60)
		Seconds = math.floor(Seconds % 60)
	end

	local SecondDifference = (Minutes * 60) + Seconds

	local AdjustedServerTime = workspace:GetServerTimeNow() - (SecondDifference * SecondLength.Value)  

	TimeStartValue.Value = AdjustedServerTime

	TimerModule.Minutes = Minutes
	TimerModule.Seconds = Seconds
end


--[=[
	This starts the timer for the client to track
    
    NOTE: This doesn't account for extra time, you'll have to add that yourself
]=]

function TimerModule:StartTimer()
    TimerPlayingValue.Value = true
    TimerModule:SetTimerTime(TimerModule.Minutes, TimerModule.Seconds)

    task.spawn(function()
        while true do
            task.wait(0.05) --// We have to update quite frequently otherwise the server and client times desync so if the timer stops and starts again the timer will be wrong

            if TimerPlayingValue.Value == false then
				break
			end

			if table.find(TimerModule.HalfTimes, TimerModule.Minutes) then	
				break
			else
                local TotalSecondsPassed = math.floor((workspace:GetServerTimeNow() - TimeStartValue.Value) / SecondLength.Value)

                local MinutesPassed = math.floor(TotalSecondsPassed / 60)
                local SecondsPassed = math.floor(TotalSecondsPassed % 60)
    
				TimerModule.Minutes = MinutesPassed
				TimerModule.Seconds = SecondsPassed
			end
        end
    end)
end

--[=[
	Simply stops the timer
]=]

function TimerModule:StopTimer()
    TimerPlayingValue.Value = false
end

return TimerModule