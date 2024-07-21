-- hs.loadSpoon("EmmyLua")

hs.hotkey.bind("cmd", ".", function()
	AppToggle("kitty")
end)

-- Arc Auto Hide
hs.hotkey.bind("cmd", ",", function()
	AppToggle("Arc")
end)

function HideApp(app)
	if app == nil then
		return
	end
	app:hide()
end

-- Open or close app. If anothor app is in front hide that instead
function AppToggle(appName)
	local focused = hs.application.frontmostApplication()

	HideApp(focused)

	if appName == focused:title() then
		return
	end

	local app = hs.application.find(appName)
	if app then
		app:unhide()
		app:activate(true)
	else
		hs.application.launchOrFocus(appName)
	end
end

function AppStatusAlert(app)
	if hs.application.find(app) then
		hs.alert.show("App running")
	else
		hs.alert.show("App not running")
	end
end

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
-- 	hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
-- end)

function CountVisibleWindows(app)
	hs.alert.show(string.format("%s has %d visible windows", app:title(), #app:visibleWindows()))
end

function list_iter(t)
	local i = 0
	local n = #t
	return function()
		i = i + 1
		if i <= n then
			return t[i]
		end
	end
end
