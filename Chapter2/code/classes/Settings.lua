Settings = Core.class()

function Settings:init()
	--our initial settings
	local settings = {
		username = "Player",
	}
	
	--to check if settings have been changed
	self.isChanged = false

	--loading saved settings
	self.sets = dataSaver.load("|D|settings")
	
	if(not self.sets) then
		self.sets = {}
	end
	
	for key, val in pairs(settings) do
		if self.sets[key] == nil then
			self.sets[key] = val
			self.isChanged = true
		end
	end

end


--get value for specific setting
function Settings:get(key)
	return self.sets[key]
end

--set new value of specific setting
function Settings:set(key, value, autosave)
	if(self.sets[key] == nil or self.sets[key] ~= value) then
		self.sets[key] = value
		self.isChanged = true
	end
	if autosave then
		self:save()
	end
end

--save settings
function Settings:save()
	--check if anything was changed
	if(self.isChanged)then
		self.isChanged = false
		dataSaver.save("|D|settings", self.sets)
	end
end