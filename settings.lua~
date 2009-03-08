oUF_Settings = oUF_Settings or {}

local layout = {
	layoutName = "oUF_SmeeGrid",
	layoutPath = "Interface\\Addons\\oUF_SmeeGrid",
	mediaPath = "Interface\\Addons\\oUF_SmeeGrid\\media\\",
	minimap = {
		hide = false,
	}
}
layout.defaults = {
	colors = {
		class ={
			["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
			["DRUID"] = { 1.0 , 0.49, 0.04 },
			["HUNTER"] = { 0.67, 0.83, 0.45 },
			["MAGE"] = { 0.41, 0.8 , 0.94 },
			["PALADIN"] = { 0.96, 0.55, 0.73 },
			["PRIEST"] = { 1.0 , 1.0 , 1.0 },
			["ROGUE"] = { 1.0 , 0.96, 0.41 },
			["SHAMAN"] = { 0,0.86,0.73 },
			["WARLOCK"] = { 0.58, 0.51, 0.7 },
			["WARRIOR"] = { 0.78, 0.61, 0.43 },
		},
	},
	timers = {
		UsingMMSS = false,
		enabled = true,
		useEnlargedFonts = true,
		values = {
			DAY = 86400,
			HOUR = 3600,
			MINUTE = 60,
			SHORT = 5
		},
		cooldownTimerStyle = {
			short = {r = 1, g = 0, b = 0, s = .98}, -- <= 5 seconds
			secs = {r = 1, g = 1, b = 0.4, s = 1}, -- < 1 minute
			mins = {r = 0.8, g = 0.8, b = 0.9, s = 1}, -- >= 1 minute
			hrs = {r = 0.8, g = 0.8, b = 0.9, s = 1}, -- >= 1 hr
			days = {r = 0.8, g = 0.8, b = 0.9, s = 1}, -- >= 1 day
		},
	},
	disallowVehicleSwap = false,
	backdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = -1.5, right = -1.5, top = -1.5, bottom = -1.5},
	},
	backdropColors = {0,0,0},
	castbars = {
		bgColor = {1,1,1,1},
		StatusBarColor = {1,1,1,.8},
		BackdropColor = {.2,.2,0,1},
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
			insets = {left = -1.5, right = -1.5, top = -1.5, bottom = -1.5},
		},
		height = 3,
		safezoneColor = {1, .2, .2, .5}
	},
	font ={
		size = 11,
		name = layout.mediaPath.."visitor.ttf",
		outline = "OUTLINE",
	},
	indicatorFont = {
		size = 10,
		name = layout.mediaPath.."visitor.ttf",
		outline = "OUTLINE",			
	},
	statusbar = layout.mediaPath.."statusbar",
	border = layout.mediaPath.."border",		
	classification = {
		worldboss = '%s |cffD7BEA5Boss|r',
		rareelite = '%s |cff%02x%02x%02x%s|r|cffD7BEA5+ R|r',
		elite = '%s |cff%02x%02x%02x%s|r|cffD7BEA5+|r',
		rare = '%s |cff%02x%02x%02x%s|r |cffD7BEA5R|r',
		normal = '%s |cff%02x%02x%02x%s|r',
		trivial = '%s |cff%02x%02x%02x%s|r',
	},
	frames = {
		unlocked = true,
		scale = 1,
		units ={
			raid = {
				point = "LEFT",
				xOffset = 3,
				yOffset = 5,
				showRaid = true,
				anchorFromPoint = "BOTTOM",
				anchorTo = "UIParent",
				anchorToPoint = "BOTTOM",
				anchorX = 0,
				anchorY = 205,
				width = 35,
				height = 35,
				scale = 1,
				barFading = false,
				castbars = true,
				colorDisconnected = true,
				colorTapping = true,
				colorClass = true,
				colorReaction = true,
				DebuffHighlightBackdrop = true,
				disallowVehicleSwap = true,               
				texture = layout.mediaPath.."raidGradient",
				font = {
					size = 11,
					name = layout.mediaPath.."visitor.ttf",
					outline = "OUTLINE",
				},
				filterdebuff = false,
				orientation = "VERTICAL"
			},
			party = {
				point = "LEFT",
				xOffset = 3,
				yOffset = 5,
				showRaid = true,
				anchorFromPoint = "BOTTOM",
				anchorTo = "UIParent",
				anchorToPoint = "BOTTOM",
				anchorX = 0,
				anchorY = 225,
				width = 35,
				height = 35,
				scale = 1,
				barFading = false,
				castbars = true,
				colorDisconnected = true,
				colorTapping = true,
				colorClass = true,
				colorReaction = true,
				DebuffHighlightBackdrop = true,
				disallowVehicleSwap = true,               
				texture = layout.mediaPath.."raidGradient",
				font = {
					size = 11,
					name = layout.mediaPath.."visitor.ttf",
					outline = "OUTLINE",
				},
				filterdebuff = false,
				orientation = "VERTICAL"
			},
		},
	}
}


setmetatable(layout.defaults.colors.class, {
	__index = function(self, key)
		return { 0.78, 0.61, 0.43 }
	end
})

oUF_Settings["oUF_SmeeGrid"] = layout
