local _, class = UnitClass('player')
if class ~= 'MONK' then return end

-- config
local alpha = 0.4
local size = 32
local position = {'BOTTOM', UIParent, 'BOTTOM', -38, 192}

-- spell id
local lastId = 0
local comboId = 196741
local abilityList = {
	[100780] = true, -- Tiger Palm
	[100784] = true, -- Blackout Kick
	[107428] = true, -- Rising Sun Kick
	[101545] = true, -- Flying Serpent Kick
	[113656] = true, -- Fists of Fury
	[101546] = true, -- Spinning Crane Kick
	[116847] = true, -- Rushing Jade Wind
	[152175] = true, -- Whirling Dragon Punch
	[115098] = true, -- Chi Wave
	[123986] = true, -- Chi Burst
	[117952] = true, -- Crackling Jade Lightning
	[205320] = true, -- Strike of the Windlord
	[115080] = true, -- Touch of Death
}
local tex = [[Interface\ICONS\inv_inscription_parchmentvar02]]

-- base frame
local f = CreateFrame('Frame', 'LynMonk', UIParent)
f:SetSize(size, size)
f:SetPoint(unpack(position))
f:SetAlpha(alpha)

-- events
f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
f:RegisterEvent('PLAYER_REGEN_ENABLED')
f:RegisterEvent('PLAYER_REGEN_DISABLED')

-- icon
local i = f:CreateTexture(nil, 'OVERLAY')
i:SetTexture(tex)
i:SetTexCoord(.08, .92, .08, .92)
i:SetAllPoints(f)
f.icon = i

-- border
local bo = f:CreateTexture(nil, 'BORDER')
bo:SetColorTexture(0, 0, 0, 1)
bo:SetPoint('TOPLEFT', -1, 1)
bo:SetPoint('BOTTOMRIGHT', 1, -1)
bo:SetVertexColor(0, 0, 0, 1)

-- background
local bg = f:CreateTexture(nil, 'BACKGROUND')
bg:SetPoint('TOPLEFT', -3, 3)
bg:SetPoint('BOTTOMRIGHT', 3, -3)
bg:SetColorTexture(0, 0, 0, .5)

-- function
local OnEventHandler = function(self, event, _, message, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, spellId)
	if event == 'PLAYER_REGEN_DISABLED' then
		f:SetAlpha(1)
	elseif event == 'PLAYER_REGEN_ENABLED' then
		f:SetAlpha(alpha)
	elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' and message == 'SPELL_AURA_REMOVED' and sourceGUID == UnitGUID('player') and comboId == spellId then
		f.icon:SetTexture(tex)
	elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' and message == 'SPELL_CAST_SUCCESS' and sourceGUID == UnitGUID('player') and abilityList[spellId] == true then
		if spellId == lastId then
			f.icon:SetTexture(tex)
			lastId = 0
		else
			lastId = spellId
			f.icon:SetTexture(GetSpellTexture(spellId))
		end
	end
end

-- script
f:SetScript('OnEvent', OnEventHandler)
