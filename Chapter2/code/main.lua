
sets = Settings.new()

--define scenes
sceneManager = SceneManager.new({
	--start scene
	["start"] = StartScene,
	--about scene
	["about"] = AboutScene,
	--options scene
	["options"] = OptionsScene,
})
--add manager to stage
stage:addChild(sceneManager)

--go to start scene
sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing)
