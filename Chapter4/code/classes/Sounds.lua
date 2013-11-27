Sounds = Core.class(EventDispatcher)

function Sounds:init()
	self.isOn = false
	self.sounds = {}
	self.eventOn = Event.new("soundsOn")
	self.eventOff = Event.new("soundsOff")
end

function Sounds:add(name, sound)
	if self.sounds[name] == nil then
		self.sounds[name] = {}
	end
	self.sounds[name][#self.sounds[name]+1] = Sound.new(sound)
end

--turn sounds on
function Sounds:on()
	if not self.isOn then
		self.isOn = true
		self:dispatchEvent(self.eventOn)
	end
end

--turn sounds off
function Sounds:off()
	if self.isOn then
		self.isOn = false
		self:dispatchEvent(self.eventOff)
	end
end

function Sounds:play(name)
	if self.isOn and self.sounds[name] then
		self.sounds[name][math.random(1, #self.sounds[name])]:play()
	end
end
