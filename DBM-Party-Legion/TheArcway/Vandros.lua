local mod	= DBM:NewMod(1501, "DBM-Party-Legion", 6, 726)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17650 $"):sub(12, -3))
mod:SetCreatureID(98208)
mod:SetEncounterID(1829)
mod:SetZone()
mod:SetUsedIcons(8)
mod.noNormal = true

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 203957 220871",
	"SPELL_AURA_APPLIED_DOSE 203176",
	"SPELL_AURA_REMOVED 220871",
	"SPELL_CAST_START 202974 203882 203176",
	"SPELL_DAMAGE 203833",
	"SPELL_MISSED 203833",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_HEALTH boss1"
)

--TODO, it might be time to build an interrupt table ("hasInterrupt") for better option defaults for spammy interrupt warnings.
--Force bomb might be more consistent now, need more logs, last log was 35
local warnTimeLock					= mod:NewTargetAnnounce(203957, 4) --Временное ограничение
local warnUnstableMana				= mod:NewTargetAnnounce(220871, 4) --Нестабильная мана
local warnPhase						= mod:NewAnnounce("Phase1", 1, "Interface\\Icons\\Spell_Nature_WispSplode") --Скоро фаза 2
local warnPhase2					= mod:NewAnnounce("Phase2", 1, 220871) --Фаза 2

local specWarnTimeSplit				= mod:NewSpecialWarningMove(203833, nil, nil, nil, 1, 2) --Расщепление времени
local specWarnForceBomb				= mod:NewSpecialWarningDodge(202974, nil, nil, nil, 2, 5) --Силовая бомба
local specWarnBlast					= mod:NewSpecialWarningInterrupt(203176, "HasInterrupt", nil, 2, 1, 2) --Ускоряющий взрыв
local specWarnBlastStacks			= mod:NewSpecialWarningDispel(203176, "MagicDispeller", nil, nil, 1, 2) --Ускоряющий взрыв
local specWarnTimeLock				= mod:NewSpecialWarningInterrupt(203957, "HasInterrupt", nil, nil, 1, 2) --Временное ограничение
local specWarnUnstableMana			= mod:NewSpecialWarningYouMoveAway(220871, nil, nil, nil, 4, 5) --Нестабильная мана

local timerUnstableMana				= mod:NewTargetTimer(8, 220871, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON) --Нестабильная мана
local timerUnstableManaCD			= mod:NewCDTimer(35.5, 220871, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON..DBM_CORE_MYTHIC_ICON) --Нестабильная мана
local timerForceBombD				= mod:NewCDTimer(31.8, 202974, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON) --Силовая бомба
local timerEvent					= mod:NewCastTimer(124, 203914, nil, nil, nil, 6, nil, DBM_CORE_DEADLY_ICON) --Изгнание во времени

local yellUnstableMana				= mod:NewYell(220871, nil, nil, nil, "YELL") --Нестабильная мана
local yellUnstableMana2				= mod:NewFadesYell(220871, nil, nil, nil, "YELL") --Нестабильная мана

local countdownEvent				= mod:NewCountdownFades(124, 203914, nil, nil, 10) --Изгнание во времени

mod:AddSetIconOption("SetIconOnUnstableMana", 220871, true, false, {8}) --Нестабильная мана

mod.vb.phase = 1
mod.vb.interruptCount = 0
local warned_preP1 = false
local warned_preP2 = false

function mod:OnCombatStart(delay)
	self.vb.interruptCount = 0
	self.vb.phase = 1
	warned_preP1 = false
	warned_preP2 = false
	if self:IsHard() then
		timerForceBombD:Start(28-delay) --Силовая бомба +++
	else
		timerForceBombD:Start(23-delay) --Силовая бомба
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 203957 then
		--if people run different directions 2-3 of these can activate at once.
		--So combined show and anti spam measures used.
		warnTimeLock:Show(args.destName)
		if self:AntiSpam(3, 2) then
			specWarnTimeLock:Show(args.sourceName)
			specWarnTimeLock:Play("kickcast")
		end
	elseif spellId == 220871 then
		timerUnstableMana:Start(args.destName)
		if args:IsPlayer() then
			specWarnUnstableMana:Show()
			specWarnUnstableMana:Play("runout")
			specWarnUnstableMana:ScheduleVoice(1, "keepmove")
			yellUnstableMana:Yell()
			yellUnstableMana2:Countdown(8, 3)
		else
			warnUnstableMana:Show(args.destName)
		end
		if self.Options.SetIconOnUnstableMana then
			self:SetIcon(args.destName, 8, 8)
		end
		timerUnstableManaCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 203176 then
		if args.amount >= 4 then
			specWarnBlastStacks:Show(args.destName)
			specWarnBlastStacks:Play("dispelboss")
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 202974 then
		specWarnForceBomb:Show()
		specWarnForceBomb:Play("157349")
		if self:IsHard() then
			if self.vb.phase == 1 then
				timerForceBombD:Start(45)
			else
				timerForceBombD:Start(42.5)
			end
		else
			timerForceBombD:Start()
		end
	elseif spellId == 203882 then
		timerForceBombD:Cancel()
		timerEvent:Start()
		countdownEvent:Start()
	elseif spellId == 203176 then
		if self.vb.interruptCount == 3 then self.vb.interruptCount = 0 end
		self.vb.interruptCount = self.vb.interruptCount + 1
		local kickCount = self.vb.interruptCount
		specWarnBlast:Show()
		--Takes 3 to block all casts, it only takes 2 in a row to break his stacks though.
		--3 count still makes sense for 2 though because you know which cast to skip to maintain order. Kick 1-2, skip 3, easy
		--A group with only one interruptor won't be able to prevent his stacks and need to use dispels on boss instead
		if kickCount == 1 then
			specWarnBlast:Play("kick1r")
		elseif kickCount == 2 then
			specWarnBlast:Play("kick2r")
		elseif kickCount == 3 then
			specWarnBlast:Play("kick3r")
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 203833 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		if not self:IsNormal() then
			specWarnTimeSplit:Show()
			specWarnTimeSplit:Play("runaway")
		end
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, bfaSpellId, _, legacySpellId)
	local spellId = legacySpellId or bfaSpellId
	if spellId == 147995 then--Interrupt Channeling
		self.vb.interruptCount = 0
		timerEvent:Cancel()
		countdownEvent:Cancel()
		timerForceBombD:Start(20)--20-23
	end
end

function mod:UNIT_HEALTH(uId)
	if self:IsHard() then --миф и миф+
		if self.vb.phase == 1 and not warned_preP1 and self:GetUnitCreatureId(uId) == 98208 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.56 then
			warned_preP1 = true
			warnPhase:Show()
		elseif self.vb.phase == 1 and warned_preP1 and not warned_preP2 and self:GetUnitCreatureId(uId) == 98208 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.51 then
			self.vb.phase = 2
			warned_preP2 = true
		end
	else
		if self.vb.phase == 1 and not warned_preP1 and self:GetUnitCreatureId(uId) == 98208 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.56 then
			warned_preP1 = true
			warnPhase:Show()
		elseif self.vb.phase == 1 and warned_preP1 and not warned_preP2 and self:GetUnitCreatureId(uId) == 98208 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.51 then
			self.vb.phase = 2
			warned_preP2 = true
		end
	end
end

--[[function mod:OnSync(msg)
	if msg == "RPPhase2" then
		if self:IsHard() then
			if self.vb.phase == 2 and warned_preP2 then
				timerEvent:Cancel()
				timerForceBombD:Start(27)
				warnPhase2:Show()
				countdownEvent
			end
		else
			if self.vb.phase == 2 and warned_preP1 then
				timerEvent:Cancel()
				timerForceBombD:Start(27)
				warnPhase2:Show()
				
			end
		end
	end
end]]

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.RPVandros or msg:find(L.RPVandros) then
		self:SendSync("RPVandros")
	end
end

function mod:OnSync(msg, GUID)
	if msg == "RPVandros" then
		if self:IsHard() then
			timerEvent:Cancel()
			countdownEvent:Cancel()
			timerForceBombD:Start(27)
			warnPhase2:Show()
			timerUnstableManaCD:Start(5.5)
		else
			timerEvent:Cancel()
			countdownEvent:Cancel()
			timerForceBombD:Start(27)
			warnPhase2:Show()
		end
	end
end
