local Libary = loadstring(game:HttpGet("https://raw.githubusercontent.com/givoty-lang/RSM-UILibary/main/main.lua"))()

Libary.CreateWindow({
	Name = "RSM Window",

	Tabs = {
		Main = {
			Name = "Main",
			Icon = "rbxassetid://6031075938",

			LayoutOrder = 1,
		},

		Settings = {
			Name = "Settings",
			Icon = "rbxassetid://6031280882",

			LayoutOrder = 2,
		},
	}
})

Libary.Init()
