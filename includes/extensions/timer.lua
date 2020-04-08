if not timer then
	timer = {}
end

local TIMERS_THINK = 0.01

function timer.Create(identifier, delay, repetitions, func)
	timer.timers[identifier] = {
		delay = delay,
		repetitions = repetitions,
		func = func,
		end_time = GameRules:GetGameTime() + delay
	}
end

function timer.Simple(delay, func)
	timer.Create(UniqueString("timer"), delay, 1, func)
end

function timer.Exists(identifier)
	return timer.timers[identifier]
end

function timer.Remove(identifier)
	timer.timers[identifier] = nil
end

function timer:Init()
	self.timers = {}

	local ent = SpawnEntityFromTableSynchronous("info_target", {targetname="timers_lua_thinker"})
	ent:SetThink("OnThink", self, "timers", TIMERS_THINK)
end

function timer:OnThink()
	for k, v in pairs(timer.timers) do
		if CurTime() >= v.end_time then
			local success, error_message = pcall(v.func)
			
			if success then
				if v.repetitions >= 1 then
					v.repetitions = math.max(0, v.repetitions - 1)
					
					if v.repetitions == 0 then
						timer.Remove(k)
						
						if not timer.Exists(k) then
							return TIMERS_THINK
						end
					end
				end
				
				v.end_time = CurTime() + v.delay
			else
				timer.Remove(k)
				error_with_traceback(error_message)
			end
		end
	end
	
	return TIMERS_THINK
end

if not timer.timers then timer:Init() end
GameRules.timer = timer