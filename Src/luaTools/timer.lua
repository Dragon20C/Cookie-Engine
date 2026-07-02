Timer = {}
Timer.__index = Timer

function Timer.new()
	local self = setmetatable({
		wait_time = 0,
		elapsed_time = 0,
	}, Timer)
	return self
end

function Timer:setWaitTime(wait_time)
	self.wait_time = wait_time
end

function Timer:update(dt)
	self.elapsed_time = self.elapsed_time + dt
end

function Timer:hasElapsed()
	return self.elapsed_time >= self.wait_time
end
