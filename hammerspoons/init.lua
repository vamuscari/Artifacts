hs.hotkey.bind("cmd", ".", function()
	hs.application.launchOrFocus("kitty")
end)

hs.hotkey.bind("cmd", ",", function()
	hs.application.launchOrFocus("Arc")
end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
-- 	hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
-- end)
