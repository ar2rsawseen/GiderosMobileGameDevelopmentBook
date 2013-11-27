require "box2d"
sets = Settings.new()
gm = GameManager.new()

--background music
music = Music.new("sounds/main.mp3")
--when music gets enabled
music:addEventListener("musicOn", function()
	sets:set("music", true, true)
end)
--when music gets disabled
music:addEventListener("musicOff", function()
	sets:set("music", false, true)
end)

--play music if enabled
if sets:get("music") then
	music:on()
end

--sounds
sounds = Sounds.new()
--set up sound events
--when sounds turn on
sounds:addEventListener("soundsOn", function()
	sets:set("sounds", true, true)
end)
--when sounds turn off
sounds:addEventListener("soundsOff", function()
	sets:set("sounds", false, true)
end)

--enable sounds if setting enabled
if sets:get("sounds") then
	sounds:on()
end

--load all your sounds here
--after that you can simply play them as sounds:play("hit")
sounds:add("complete", "sounds/complete.wav")
sounds:add("hit", "sounds/hit0.wav")
sounds:add("hit", "sounds/hit1.wav")
sounds:add("hit", "sounds/hit2.wav") 
sounds:add("hit", "sounds/hit3.wav")


--define scenes
sceneManager = SceneManager.new({
	--start scene
	["start"] = StartScene,
	--about scene
	["about"] = AboutScene,
	--options scene
	["options"] = OptionsScene,
	--level scene
	["level"] = LevelScene,
	--level select scene
	["levelselect"] = LevelSelectScene,
})
--add manager to stage
stage:addChild(sceneManager)

--go to start scene
sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing)
