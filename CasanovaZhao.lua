--____________________________________________________________--
-- CasanovaZhao Changelog                                     --
-- 0.99 - AA -> Q Fixed, Items Support added                  --
-- 0.89 - AA -> Q Disable (Need to fix it)                    --
-- 0.79 - Auto Ignite Added with Set Range (Prevent overkill) --
-- 0.69 - Initial Release                                     --
--____________________________________________________________--

if myHero.charName ~= "XinZhao" then return end

--|Auto Updater|--
local AUTOUPDATE = true
local version = 0.99
local SCRIPT_NAME = "CasanovaZhao"
local SOURCELIB_URL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"
if FileExist(SOURCELIB_PATH) then
	require("SourceLib")
else
	DOWNLOADING_SOURCELIB = true
	DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end

if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end

if AUTOUPDATE then
	SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/AlfonsCasanova/BoL/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/AlfonsCasanova/BoL/master/ver/"..SCRIPT_NAME..".version"):CheckUpdate()
end

local RequireI = Require("SourceLib")
RequireI:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
RequireI:Check()

if RequireI.downloadNeeded == true then return end

--|BoL Tracker|--
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
id = 47
ScriptName = "CasanovaZhao"

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


--|Menu|--
function setupMenu()
	
	Menu = scriptConfig("CasanovaZhao", "CasanovaZhao")
	
	Menu:addSubMenu("Script Information","Script")
	Menu.Script:addParam("Author","Author: Alfons Casanova",SCRIPT_PARAM_INFO,"")
	Menu.Script:addParam("Version","Version: " .. version,SCRIPT_PARAM_INFO,"")
	
	Menu:addSubMenu("Orbwalking", "orbwalking")
	OW:LoadToMenu(Menu.orbwalking)

	Menu:addSubMenu("Combo", "combo")
	Menu.combo:addParam("active","Combo active",SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Menu.combo:addParam("sep", "", SCRIPT_PARAM_INFO, "")
	Menu.combo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("useIgnite", "Use Ignite if Killable", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("igniteRange", "Set Ignite Range", SCRIPT_PARAM_SLICE, 470, 0, 599, 0)
	
  Menu:addSubMenu("Item Settings", "ISettings")
  Menu.ISettings:addParam("IuseC", "Use items in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.ISettings:addParam("BOTRK", "Use Ruined king", SCRIPT_PARAM_ONOFF, true)
  Menu.ISettings:addParam("BWC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
  Menu.ISettings:addParam("DFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, true)
	Menu.ISettings:addParam("HEX", "Use Hextech Revolver", SCRIPT_PARAM_ONOFF, true)
	Menu.ISettings:addParam("FQC", "Use Frost Queen's Claim", SCRIPT_PARAM_ONOFF, true)
	Menu.ISettings:addParam("SOTD", "Use Sword of the Divine", SCRIPT_PARAM_ONOFF, true)
	Menu.ISettings:addParam("YGB", "Use Yomuu's Ghost Blade", SCRIPT_PARAM_ONOFF, true)

	Menu:addSubMenu("Drawings", "Draw")
	Menu.Draw:addParam("DrawE", "Draw E", SCRIPT_PARAM_ONOFF, true)
	Menu.Draw:addParam("DrawR", "Draw R", SCRIPT_PARAM_ONOFF, true)
  Menu.Draw:addParam("DrawAA", "Draw AA", SCRIPT_PARAM_ONOFF, true)
	
	Menu.Script:permaShow("Author")
	Menu.combo:permaShow("active")
	Menu.combo:permaShow("useIgnite")
	Menu.ISettings:permaShow("IuseC")
end

local ignite, igniteReady = nil, nil
local SpellAA = {Range = 175 + 75}
local SpellE = {Range = 650}
local SpellR = {Range = 500}
local VP = nil
local menu = nil
local target = nil
local QReady,WReady,EReady,RReady = nil,nil,nil,nil


function OnLoad()
  Variables()
	VP = VPrediction()
	OW = SOW(VP)
  OW.AttackResetTable = {}
	setupMenu()
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,600,DAMAGE_MAGIC)
	ts.name = "XinZhao"
	Menu:addTS(ts)
  UpdateWeb(true, ScriptName, id, HWID)
	print("<font color='#FF8000'>Casanova </font><font color='#FF8000'>Zhao</font><font color='#FF0000'> v" .. version .."</font>")
	--}
end

function OnBugsplat()
	UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
	UpdateWeb(false, ScriptName, id, HWID)
end


function Variables()
		SkillQ =	{range = 250, name = "Three Talon Strike",			ready = false,																			color = ARGB(255, 32,178,170)	}
		SkillE =	{range = 650, name = "Audacious Charge",			ready = false,																			color = ARGB(255,128, 0 ,128)	}
		SkillR =	{range = 500, name = "Crescent Sweep",		ready = false,																			color = ARGB(255, 32,178,170) }
end
		
function OnTick()
		Target = GetTarget()
		OW:ForceTarget(Target)
		ts:update()
		Checks()
		if Menu.combo.active then combo() end
		KillSteal()
		checkItems()
		end
		
		function PassiveActive(Target)
    for i = 1, ts.target.buffCount do
        local tBuff = ts.target:getBuff(i)
        if BuffIsValid(tBuff) and (tBuff.name == "xenzhaointimidate") then
            return true
        end
    end 
    return false
		end
	
		
		if GetGame().isOver then
	UpdateWeb(false, ScriptName, id, HWID)
	-- This is a var where I stop executing what is in my OnTick()
	startUp = false;
end

function checkItems()
	HexTech = GetInventorySlotItem(3146)
	HexTechR = (HexTech ~= nil and myHero:CanUseSpell(HexTech))
	BilgeWaterCutlass = GetInventorySlotItem(3144)
    BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
	DFG = GetInventorySlotItem(3128)
	DFGR = (DFG ~= nil and myHero:CanUseSpell(DFG) == READY)
	FQC = GetInventorySlotItem(3092)
	FQCR = (FQC ~= nil and myHero:CanUseSpell(FQC) == READY)
	YGB = GetInventorySlotItem(3142)
	YGBR = (YGB ~= nil and myHero:CanUseSpell(YGB) == READY)
	BotRK = GetInventorySlotItem(3153)
	BotRKR = (BotRK ~= nil and myHero:CanUseSpell(BotRK) == READY)
	SotD = GetInventorySlotItem(3131)
	SotDR = (SotD ~= nil and myHero:CanUseSpell(YGB) == READY)
	
	function getTrange()
	return myHero.range + 150
end
end

function GetTarget()

ts:update()

 if ts.target and not ts.target.dead and ts.target.type  == myHero.type then

    return ts.target

    end

end

--|Combo|--
function combo(target)
	if ts.target ~= nil then
	if Menu.ISettings.IuseC then
		if Menu.ISettings.BOTRK and BotRKR and GetDistance(Target, myHero) < 450 then
			CastSpell(BotRK, Target)
		end
		if Menu.ISettings.DFG and DFGR and GetDistance(Target, myHero) < 500 then
			CastSpell(DFG, Target)
		end
		if Menu.ISettings.HEX and HexTechR and GetDistance(Target, myHero) < 500 then
			CastSpell(HexTech, Target)
		end
		if Menu.ISettings.FQC and FQCR and GetDistance(Target, myHero) < 850 then
			CastSpell(FQC, Target)
		end
		if Menu.ISettings.YGB and YGBR and GetDistance(Target, myHero) < getTrange() then
			CastSpell(YGB)
		end
		if Menu.ISettings.SOTD and SotDR and GetDistance(Target, myHero) < getTrange() then
			CastSpell(SotD)
		end
		if Menu.ISettings.BWC and BilgeWaterCutlassR and GetDistance(Target, myHero) < 500 then
			CastSpell(BilgeWaterCutlass)
		end
	end
		if myHero:CanUseSpell(_E) == READY and GetDistance(ts.target) <= 600 then
			CastSpell(_E, ts.target)
		end
		if myHero:CanUseSpell(_R) and Menu.combo.useR and PassiveActive(Target) and GetDistance(ts.target) <= 500 then
			CastSpell(_R)
		end
		if myHero:CanUseSpell(_W) and Menu.combo.useW then
			CastSpell(_W)
		end
if myHero:CanUseSpell(_Q) then 
    OW:RegisterAfterAttackCallback(function() 
      if ts.target ~= nil and ts.target.type == myHero.type and Menu.combo.active then
         CastSpell(_Q) 
      end
    end)
end
end
end

	
	function KillSteal()
	if Menu.combo.useIgnite then
		useIgnite()
	end
end



function useIgnite()
	if igniteReady then
		local Enemies = GetEnemyHeroes()
		for i, val in ipairs(Enemies) do
			if ValidTarget(val, 600) then
				if getDmg("IGNITE", val, myHero) > val.health and GetDistance(val) >= Menu.combo.igniteRange then
					CastSpell(ignite, val)
				end
			end
		end
	end
end

function HealthCheck(unit, HealthValue)
	if unit.health > (unit.maxHealth * (HealthValue/100)) then 
		return true
	else
		return false
	end
end

--|CD Checks|--
function Checks()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		ignite = SUMMONER_2
	end
	igniteReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end

--|Spell Ranges|--
function OnDraw()
		if not myHero.dead then
				if Menu.Draw.DrawAA then
					DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, SkillQ.color)
					end
				if EReady and Menu.Draw.DrawE then 
					DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, SkillE.color)
				end
				if RReady and Menu.Draw.DrawR then
					DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, SkillR.color)

				end
			end
		end
