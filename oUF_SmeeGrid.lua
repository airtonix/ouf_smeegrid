local parent = debugstack():match[[\AddOns\(.-)\]]
local global = GetAddOnMetadata(parent, 'X-oUF_SmeeGrid')
assert(global, 'X-oUF_SmeeGrid needs to be defined in the parent add-on.')
oUF_SmeeGrid = {}
local _,playerClass = UnitClass("player")

---options----

oufsmeegrid = CreateFrame('Frame', 'oufsmeegrid', UIParent)
	oufsmeegrid:SetScript('OnEvent', function(self, event, ...) if(self[event]) then return self[event](self, event, ...) end end)
	oufsmeegrid:RegisterEvent('ADDON_LOADED')
	oufsmeegrid:RegisterEvent("PLAYER_LOGIN")
	oufsmeegrid:RegisterEvent("RAID_ROSTER_UPDATE")
	oufsmeegrid:RegisterEvent("PARTY_LEADER_CHANGED")
	oufsmeegrid:RegisterEvent("PARTY_MEMBER_CHANGED")


	function oufsmeegrid:PLAYER_LOGIN(event, addon)
		oufsmeegrid:toggleGroupLayout(self)
	end
	function oufsmeegrid:RAID_ROSTER_UPDATE(event, addon)
		oufsmeegrid:toggleGroupLayout(self)
	end
	function oufsmeegrid:PARTY_LEADER_CHANGED(event, addon)
		oufsmeegrid:toggleGroupLayout(self)
	end
	function oufsmeegrid:PARTY_MEMBER_CHANGED(event, addon)
		oufsmeegrid:toggleGroupLayout()
	end

	function oufsmeegrid:toggleGroupLayout()
		if(InCombatLockdown()) then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			if(GetNumRaidMembers() > 0) then
				oUF.units.party:Hide()
				for index,frame in pairs(oUF.units.raid)do
					frame:Show()
				end
			else
				oUF.units.party:Show()
				for index,frame in pairs(oUF.units.raid)do
					frame:Hide()
				end
			end
		end
	end
		  
	function oufsmeegrid:loadDB()
		oUFdB = oUFdB or {}
		local db = oUF_Settings["oUF_SmeeGrid"]
		oUFdB[db.layoutName] = oUFdB[db.layoutName] or {}
		if(db ~= nil) then 
			local layoutDB = oUFdB[db.layoutName]
			for k,v in pairs(db.defaults) do
				if(type(layoutDB[k]) == 'nil') then
					layoutDB[k] = v
				end
			end
			self.db = layoutDB
			print("Default Settings Table Loaded.")			
		else
			print("Error: No Defaults Settings Table.")
		end
		
	end

	function oufsmeegrid:saveDB()
		oUF.settings.profile[UnitName("player")] = self.db
	end


SlashCmdList['oufSmeeGrid'] = function(str)
	if(str:find('reset')) then
		oufsmeegrid.db = {}
		print('|cffff6000o|rUF_Smee: |cff0090ffSavedvariables is now reset.|r')
		oufsmeegrid:loadDB()
	elseif(str:find('refresh')) then
		Minimap:SetMaskTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
		print('|cffff6000o|rUF_Smee: |cff0090ffFrames refreshed.|r')
	else
		if(not IsAddOnLoaded('oUF_SmeeGrid_Config')) then
			LoadAddOn('oUF_SmeeGrid_Config')
		end	
		InterfaceOptionsFrame_OpenToCategory('oUF_SmeeGrid')
	end
end
SLASH_oufSmeeGrid1 = '/oufSmeeGrid'

local layoutName = "SmeeGrid"
local layoutPath = "Interface\\Addons\\oUF_"..layoutName
local mediaPath = layoutPath.."\\media\\"

local texture = mediaPath.."gradient"
local hightlight = mediaPath.."white"

local font,fontsize = mediaPath.."visitor.ttf",9
local height, width = 35, 35
local _,playerClass = UnitClass("player")

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

-- Vertical health?
local verticalhp = true
-- Debuff icon size
local iconsize = 20
-- Filter debuffs by your class?
local filterdebuff = false
local numberize = function(val)
	if(val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
	elseif (val >= 1e6) then
		return ("%.1fm"):format(val / 1e6)
	else
		return val
	end
end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], tile = true, tileSize = 16,
	insets = {top = -2, left = -2, bottom = -2, right = -2},
}

local function Hex(r, g, b)
	if type(r) == "table" then
		if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local GetClassColor = function(unit)
	return unpack(oufsmeegrid.db.colors.class[select(2, UnitClass(unit))])
end

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(unit == "party" or unit == "partypet" or self.id == nil) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

-- Threat Function
function UpdateThreat(self, event, unit)
	local unitTarget = (unit =='player' and "target" or unit.."target")
	local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation(unit, unitTarget);
	if not(rawthreatpct == nil) then 
		self.Threat:SetText( Hex(GetThreatStatusColor(status)) .. string.format("%.0f", rawthreatpct ) .. "|r" )
	else
		self.Threat:SetText('')
	end
end

-- Health Function
local updateHealth = function(self, event, unit, bar, min, max)
	if(max ~= 0)then
	  r,g,b = self.ColorGradient((min/max), .9,.1,.1, .8,.8,.1, 1,1,1)
	end
	bar.text:SetTextColor(r,g,b)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		bar.bg:SetVertexColor(0.3, 0.3, 0.3)
	else
		bar.bg:SetVertexColor(GetClassColor(unit))
	end
	
end
function combatFeedbackText(self)
	self.CombatFeedbackText = self.Health:CreateFontString(nil, "OVERLAY")
	self.CombatFeedbackText:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
	self.CombatFeedbackText:SetFont(font, fontsize, "OUTLINE")
	self.CombatFeedbackText.maxAlpha = .8

end

local OnEnter = function(self)
	UnitFrame_OnEnter(self)
--	self.Highlight:Show()
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
--	self.Highlight:Hide()
end
local function updateBanzai(self, unit, aggro)
	if self.unit ~= unit then return end
	if aggro == 1 then
		self.BanzaiIndicator:Show()
	else
		self.BanzaiIndicator:Hide()
	end
end

-- Style
local func = function(self, unit)
	self.menu = menu
	self:EnableMouse(true)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")

--==========--
--	HEALTH	--
--==========--
	self.Health = CreateFrame"StatusBar"
	self.Health:SetHeight(height)
	self.Health:SetStatusBarTexture(texture)
	self.Health:SetOrientation("VERTICAL")

	self.Health:SetStatusBarColor(0, 0, 0)
	self.Health:SetAlpha(0.6)
	self.Health.frequentUpdates = true

	self.Health:SetParent(self)
	self.Health:SetPoint"TOPLEFT"
	self.Health:SetPoint"BOTTOMRIGHT"

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(texture)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, .8)

	-- Health Text
	self.Health.text = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.text:SetFont(font, fontsize)
	self.Health.text:SetShadowOffset(1,-1)
	self.Health.text:SetPoint("CENTER")
	self.Health.text:SetJustifyH("CENTER")
	self:Tag(self.Health.text, "[raidhp]")

	self.OverrideUpdateHealth = updateHealth

--==========--
--	ICONS	--
--==========--
--Leader Icon
	self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
	self.Leader:SetPoint("TOPLEFT", self, 0, 8)
	self.Leader:SetHeight(16)
	self.Leader:SetWidth(16)

-- Raid Icon
	self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetPoint("TOP", self, 0, 8)
	self.RaidIcon:SetHeight(16)
	self.RaidIcon:SetWidth(16)
	
-- DebuffHidghtlight
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightAlpha = .5

	if(filterdebuff)then
	  self.DebuffHighlightFilter = true
	end

	if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .4
	end

	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetPoint("TOPRIGHT", self, 0, 8)
	self.ReadyCheck:SetHeight(16)
	self.ReadyCheck:SetWidth(16)
	
	self.Threat = self.Health:CreateFontString(nil, "OVERLAY")
	self.Threat:SetFont(font, fontsize, "OUTLINE")
	self.Threat:SetPoint('BOTTOM',self, 0, 0)
	self.Threat:SetJustifyH("CENTER")
	self.PostUpdateThreat = UpdateThreat			

	self.AuraIndicator = true
	
	self:SetAttribute('initial-height', height)
	self:SetAttribute('initial-width', width)
---Aggro Indicator
	self.Banzai = updateBanzai
	self.BanzaiIndicator = self.Health:CreateTexture(nil, "OVERLAY")
	self.BanzaiIndicator:SetPoint("TOPRIGHT", self, 0, 0)
	self.BanzaiIndicator:SetHeight(4)
	self.BanzaiIndicator:SetWidth(4)
	self.BanzaiIndicator:SetTexture(1, .25, .25)
	self.BanzaiIndicator:Hide()

	self.FontObjects={
		self.Health.text,
		self.Threat,	
	}

	return self
end

local function MainTanks(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('initial-height', 20)
	self:SetAttribute('initial-width', 120)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture(texture)
	self.Health.colorDisconnected = true
	self.Health.colorClass = true

	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
	self.Health.bg.multiplier = 0.3

	self.Health.text = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallRight')
	self.Health.text:SetPoint('LEFT', 3, 0)
	self:Tag(self.Health.text, '[raidhp]')
	
	self.Name = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
	self.Name:SetPoint('LEFT', self, 'RIGHT', 5, 0)
	self:Tag(self.Name, '[name] |cff00ffff[raidtargetname] [raidtargeticon]')

	self.Threat = self.Health:CreateFontString(nil, "OVERLAY")
	self.Threat:SetFont(font, 11, "OUTLINE")
	self.Threat:SetPoint('RIGHT',self, 0, 0)
	self.Threat:SetJustifyH("RIGHT")
	self.PostUpdateThreat = UpdateThreat			

	self.AuraIndicators = true

	self.disallowVehicleSwap = true
	if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .4
	end
	self.FontObjects={
		self.Name,
		self.Health.text,
		self.Threat,	
	}
end

function oufsmeegrid:ADDON_LOADED(event, addon)
	if(addon ~= 'oUF_SmeeGrid') then return end
	print("setting up oufsmeegrid.db")
	self:UnregisterEvent(event)	

	oufsmeegrid:loadDB()
	oufsmeegrid.loaded = true
	oufsmeegrid.db.frames.unlocked = false

    oUF:RegisterStyle("group", func)
    oUF:SetActiveStyle"group"

    oUF.indicatorFont = oUF.indicatorFont or oufsmeegrid.db.indicatorFont
    
    oUF.units.raid = {}
    for i = 1, 5 do
    	local group = oUF:Spawn('header', 'oUF_Raid'..i)
    	group:SetManyAttributes(
    		"groupFilter", tostring(i),
    		"showRaid", oufsmeegrid.db.frames.units.raid.showRaid,
    		"yOffSet", oufsmeegrid.db.frames.units.raid.yOffset,
    		"xOffSet", oufsmeegrid.db.frames.units.raid.xOffset,		
    	    "point", oufsmeegrid.db.frames.units.raid.point,
    	    "initial-height",  oufsmeegrid.db.frames.units.raid.height,
    	    "initial-width", oufsmeegrid.db.frames.units.raid.width
    	)
    	
    	table.insert(oUF.units.raid, group)
    	if(i == 1) then
    		group:SetManyAttributes('showParty', true, 'showPlayer', true)
  			group:SetPoint(oufsmeegrid.db.frames.units.raid.anchorFromPoint,
        		oUF.units[oufsmeegrid.db.frames.units.raid.anchorTo] or UIParent,
        		oufsmeegrid.db.frames.units.raid.anchorToPoint,
        		oufsmeegrid.db.frames.units.raid.anchorX,
        		oufsmeegrid.db.frames.units.raid.anchorY)
			
    	else
    		group:SetPoint('BOTTOMLEFT', oUF.units.raid[i-1], 'TOPLEFT', 0, oufsmeegrid.db.frames.units.raid.yOffset)
    	end
    	group:Hide()
    end
    
    oUF.units.party = oUF:Spawn("header", "oUF_Party")
	local anchorFrame = oufsmeegrid.db.frames.units.party.anchorTo
	local partySettings = oufsmeegrid.db.frames.units.party
	
		oUF.units.party:SetPoint(
				partySettings.anchorFromPoint,
				((anchorFrame == "UIparent") and UIParent or oUF.units[anchorFrame]),
        		partySettings.anchorToPoint,
        		partySettings.anchorX,
        		partySettings.anchorY)
	
	oUF.units.party:Show()
	oUF.units.party:SetManyAttributes(
		"template", "oUF_Party",
		"yOffset", 3,
		"xOffSet", 3,
		"point", "left",
		"showParty", true,
		"showPlayer", true
	)

--[[
	oUF:RegisterStyle('PerfectM', MainTanks)
	oUF:SetActiveStyle('PerfectM')

	local tank = oUF:Spawn('header', 'oUF_MainTank')
	tank:SetManyAttributes('showRaid', true, 'groupFilter', 'MAINTANK', 'yOffset', -5)
	tank:SetPoint('BOTTOM', UIParent, 'BOTTOM',180, 255)
	tank:Show()

	local assist = oUF:Spawn('header', 'oUF_MainAssist')
	assist:SetManyAttributes('showRaid', true, 'groupFilter', 'MAINASSIST', 'yOffset', -5)
	assist:SetPoint('BOTTOM', tank, 'TOP', 0, 10)
	assist:Show()
--]]

end

