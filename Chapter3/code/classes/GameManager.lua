GameManager = Core.class()

function GameManager:init()
	self.packs = {}
end

function GameManager:loadPack(pack)
	if self.packs[pack] == nil then
		self.packs[pack] = dataSaver.load("|D|scores"..pack)
	end
	if not self.packs[pack] then
		self.packs[pack] = {}
	end
end

function GameManager:save(pack)
	dataSaver.save("|D|scores"..pack, self.packs[pack])
end

function GameManager:createLevel(pack, level)
	self.packs[pack][level] = {}
	self.packs[pack][level].score = 0
	self.packs[pack][level].time = nil
	self.packs[pack][level].unlocked = false
	self:save(pack)
end


function GameManager:isUnlocked(pack, level)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	return self.packs[pack][level].unlocked
end

function GameManager:unlockLevel(pack, level)
	self:loadPack(pack)
	if(self.packs[pack][level] == nil) then
		self:createLevel(pack, level)
	end
	if not self.packs[pack][level].unlocked then
		self.packs[pack][level].unlocked = true
		self:save(pack)
	end
end

function GameManager:getNextLevel(pack, level, unlock)
	self:loadPack(pack)
	level = level + 1
	if packs[pack].levels < level then
		level = 1
		pack = pack + 1
	end
	if packs[pack] and packs[pack].levels >= level then
		if unlock then
			self:unlockLevel(pack, level)
		end
		return pack, level
	else
		return nil, nil
	end
end