Mia_Warrior = Mia_Warrior or {}

local NewSpell = Aurora.SpellHandler.NewSpell
local Macro = Aurora.Macro

local spellbooks = {
    spells = {
        AutoAttack = NewSpell(6603),
        --冲锋
        CHONGFENG = NewSpell(100),
        --[英勇投掷]
        YINGYONGTOUZHI = NewSpell(57755),
        --[勇士之矛]
        YONGSHIZHIMAO = NewSpell(376079),
        --嘲讽
        CHAOFENG = NewSpell(355),
        --[法术反射]
        FASHUFANSHE = NewSpell(23920),
        --[防御姿态]
        FANGYUZITAI = NewSpell(386208),
        --[天神下凡] 107574
        TIANSHENXIAFAN = NewSpell(107574),

        --[狂暴之怒] 18499
        KUANGBAOZHINU = NewSpell(18499),
        --[集结呐喊] 97462
        JIJIENAHAN = NewSpell(97462),
        --[战斗姿态] 386164
        ZHANDOUZITAI = NewSpell(386164),
        --[雷霆一击] 6343
        LEITINGYIJI = NewSpell(6343),
        --[战斗怒吼] 6673
        ZHANDOUNUHOU = NewSpell(6673),
        --[盾牌格挡]2565
        DUNPAIGEDANG = NewSpell(2565),
        --[震荡波]46968
        ZHENDANGBO = NewSpell(46968),
        --[拳击]6552
        QUANJI = NewSpell(6552),
        --[盾牌猛击]23922
        DUNPAIMENGJI = NewSpell(23922),
        --[风暴之锤]107570
        FANGBAOZHICHUI = NewSpell(107570),
        --[斩杀]163201
        ZHANSHA = NewSpell(163201),
        --[斩杀2]163201
        ZHANSHA2 = NewSpell(163201),
        --[胜利在望]202168
        SHENGLIZAIWANG = NewSpell(202168),
        --[复仇]6572
        FUCHOU = NewSpell(6572),
        --[复仇]6572
        FUCHOU2 = NewSpell(6572),
        --[盾墙]871
        DUNQIANG = NewSpell(871),
        --[挑战怒吼]1161
        TIAOZHANNUHOU = NewSpell(1161),
        --[盾牌冲锋]385952
        DUNPAICHONGFENG = NewSpell(385952),
        --[挫志怒吼]1160
        CUOZHINUHOU = NewSpell(1160),
        --[破釜沉舟]12975
        POFUCHENZHOU = NewSpell(12975),
        --[撕裂]394062
        SILIE = NewSpell(394062),
        --[无视苦痛]190456
        WUSHITONGKU = NewSpell(190456),
        --[破胆怒吼]5246
        PODANNUHOU = NewSpell(5246),
        --[苦痛免疫]383762
        TONGKUMIANYI = NewSpell(383762),
        --[刺耳怒吼]12323
        CIERNUHOU = NewSpell(12323),
        --[雷鸣之吼]384318
        LEIMINGZHIHOU = NewSpell(384318),
        --[瓦解怒吼]386071
        WAJIENUHOU = NewSpell(386071),
        --[破坏者]228920
        POHUAIZHE = NewSpell(228920)
    },
    auras = {
        
    },
    talents = {
        CUISI = NewSpell(29725)
    }
}

Aurora.SpellHandler.PopulateSpellbook(spellbooks, "WARRIOR", 3, "Mia_Warrior")

--自动法术反射
local isFSFS = false
local isSwitchTarget = false
local isIgnoringPain = 0.28
local isCZCD = false
--自动打断
local autoQuanji = false
--盾墙应对
local isDUNQIANG = false
--挫志怒吼应对
local isCUOZHINUHOU = false
--破釜沉舟应对
local isPOFUCHENZHOU = false
--存放应对技能
local yingdui = nil
--应对技能计数
local yingduicount = 0
--自动盾牌冲锋和雷鸣之吼
local isDunpaichongfeng = false
local isLonghou = false

local isGongqiang = false
--自动天神下凡
local autoTianshen = false

local gui = Aurora.GuiBuilder:New()
gui:Category("Mia_Warrior")
   :Tab("常规")
   :Header({ text = "减伤应对" })
   :Checkbox({
    text = "盾墙",
    key = "feature.isDUNQIANG",  -- Config key for saving
    default = true,          -- Default value
    tooltip = "盾墙应对", -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        isDUNQIANG = not isDUNQIANG
    end
})
   :Checkbox({
    text = "挫志怒吼",
    key = "feature.isCUOZHINUHOU",  -- Config key for saving
    default = true,          -- Default value
    tooltip = "挫志怒吼应对", -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        isCUOZHINUHOU = not isCUOZHINUHOU
    end
   })
    :Checkbox({
    text = "破釜沉舟",
    key = "feature.isPOFUCHENZHOU",  -- Config key for saving
    default = true,          -- Default value
    tooltip = "破釜沉舟应对", -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        isPOFUCHENZHOU = not isPOFUCHENZHOU
    end
   })
   :Header({ text = "无视苦痛" })
   :Dropdown({
    text = "无视苦痛阈值",
    key = "graphics.isIgnoringPain",
    options = {
        { text = "average", value = "average" },
        { text = "moderate", value = "moderate" },
        { text = "extreme", value = "extreme" }
    },
    default = "average",
    multi = false,           -- Set to true for multi-select
    width = 200,            -- Optional
    tooltip = "无视苦痛吸收量 (average/moderate/extreme, adjustable via macro command/Aurora IgnoringPain average/moderate/extreme)",
    onChange = function(self, value)
        if value == "average" then
            --一般
            isIgnoringPain = 0.28
            -- print("设置无视苦痛吸收量：一般")
        elseif value == "moderate" then
            --中等
            isIgnoringPain = 0.56
            -- print("设置无视苦痛吸收量：中等")
        elseif value == "extreme" then
            --极端
            isIgnoringPain = 0.8
            -- print("设置无视苦痛吸收量：极端")
        end
    end
})
--     :Checkbox({
--     text = "Demoralizing Shout",
--     key = "feature.isCZCD",  -- Config key for saving
--     default = false,          -- Default value
--     tooltip = "挫志怒吼卡cd /Aurora Shout", -- Optional tooltip
--     onChange = function(self, checked)
--         -- print("Checkbox changed:", checked)
--         isCZCD = not isCZCD
--     end
--    })

   local function InitConfig()
    -- isFSFS = Aurora.Config:Read("feature.isFSFS")
    -- isSwitchTarget = Aurora.Config:Read("feature.isSwitchTarget")
    -- isCZCD = Aurora.Config:Read("feature.isCZCD")
    isCUOZHINUHOU = Aurora.Config:Read("feature.isCUOZHINUHOU")
    isPOFUCHENZHOU = Aurora.Config:Read("feature.isPOFUCHENZHOU")
    isDUNQIANG = Aurora.Config:Read("feature.isDUNQIANG")
    local isIgnoringPainText = Aurora.Config:Read("graphics.isIgnoringPain")
    if isIgnoringPainText == "average" then
        isIgnoringPain = 0.28
    elseif isIgnoringPainText == "moderate" then
        isIgnoringPain = 0.56
    elseif isIgnoringPainText == "extreme" then
        isIgnoringPain = 0.8
    end
end
   


local player = Aurora.UnitManager:Get("player")
local target = nil
local focus = nil
local mouseover = nil
local castedCount = 0

local addSpellStat = nil
--预留怒气
local rageMin = 35

local isLoop = true

--电缆
local battleResurrection = Aurora.ItemHandler.NewItem(221955)
local weaponEnhancement = Aurora.ItemHandler.NewItem(224107)
local fuwen = Aurora.ItemHandler.NewItem(243191)


local isLT = true


 --应对减伤
local respondSpells = {
    1237071,--石拳
    438877,
    438471,
    438476,
    459799,--水闸1号尖刺
    469478,--水闸老2尖刺
    473351,--老大娘尖刺
    465666,--水闸火花猛击
    466190,--水闸尾王尖刺
    448485,--隐修院盾牌猛击
    427897,--隐修院 热浪
    427950,--隐修院 烈焰
    448515,--隐修院 神圣审判
    424414,--隐修院 贯穿护甲
    448791,--隐修院 敲钟
    435165,--隐修院 炽热打击
    431491,--破晨 流血
    453212,--破晨 老1
    427001,--破晨 老2
    451117,--破晨 第一个大怪尖刺
    355048,--宏图 破壳猛击
    356133,--宏图 激怒
    352796,--天街 代理打击
    349934,--天街 老2
    355477,--天街 脚踢
    1240912,--天街 穿刺
    350916,--天街 保安
    359028,--天街 老3
    322936,--赎罪 老1
    1235766,--赎罪 致死
    1235368,--圆顶 大怪
    1219482,--圆顶 老2
    1222341--圆顶 幽暗

}

local reflectionSpell = {
    1231224,--[奥术猛袭]
    1222815,--[奥术箭]
    1222341,--[幽暗之咬]

    338003,--[邪恶箭矢]
    328322,--[罪邪箭]
    323538,--[心能箭矢]

    352796,--[代理打击]
    355641,--[闪烁]

    355225,--[水箭]
    356843,--[盐渍飞弹]
    354297,--[凌光箭]

    434786,--[蛛网箭]
    436322,--[毒液箭]
    1241693,--[虫群风暴]

    431303,--[暗夜箭]
    453212,--[黑曜光束]
    451113,--[蛛网箭]
    451117,--[恐惧猛击]
    427001,--[恐惧猛击]

    448492,--[雷霆一击]
    427357,--[神圣惩击]
    427469,--[火球术]
    424421,--[火球术]
    448791,--[神圣鸣罪]
    435165,--[炽热打击]
    423536,--[神圣惩击]
    427470,--[神圣惩击]

    469478,--[淤泥之爪]
    473351,--[电气重碾]
    465871,--[鲜血冲击]
    465666,--[火花猛击]
    466190,--[雷霆重拳]
    468631,
    1214468
}


--判断目标在不在面向内，如果不在选择面向内的目标施法
local function isTargetBehind(spell, distance)
    target = Aurora.UnitManager:Get("target")
    if target.exists then
        if not target.playerfacing180 or target.distanceto(player) > distance or spell:castable(target) then
            Aurora.activeenemies:each(function(enemy, index, uptime)
                if enemy.playerfacing180 and enemy.distanceto(player) <= distance and spell:castable(enemy) then
                    -- isJiaJian = false
                    -- print("切目标斩杀")
                    return spell:cast(enemy)
                end
            end)
        else
            -- isJiaJian = false
            return spell:cast(target)
        end
    end
end

local function injuryResponse()
      local activeenemies = Aurora.activeenemies
        if activeenemies then
            activeenemies:each(function(enemy, index, uptime)
                local enemyCastingId = enemy.castingspellid
                if enemyCastingId then
                    -- print("正在施法",enemyCastingId)
                    for k, v in pairs(respondSpells) do
                        if v == enemyCastingId then
                            
                                if yingdui then
                                    yingdui:cast(player)
                                end
                                return true
                            
                        end
                    end
                end
            end)
        end
end

spellbooks.spells.TIANSHENXIAFAN:callback(function(spell,logic)
    if autoTianshen then
        if player.enemiesaround(8) >= 5 or player.speed == 0 then
            return spell:cast(player)
        end
    end
end)

spellbooks.spells.AutoAttack:callback(function(spell,logic)
    
    if isSwitchTarget then
        target = Aurora.UnitManager:Get("target")
        if target.exists and target.distanceto(player) <= 4.3 and target.playerfacing180 then
            player.settarget(target)
        elseif target.exists and target.distanceto(player) > 4.3 and target.distanceto(player) <= 8 then
            Aurora.activeenemies:each(function(enemy, index, uptime)
                if enemy.playerfacing180 and enemy.distanceto(player) <= 4.3 then
                    player.settarget(enemy)
                    
                end
            end)
        end
    end
    return spell:cast(target)
end)

spellbooks.spells.DUNQIANG:callback(function(spell, logic)
    if isDUNQIANG and spell:ready() and yingdui == nil then
        yingdui = spell
        -- return true
    end
end)

spellbooks.spells.POFUCHENZHOU:callback(function(spell, logic)
    if isPOFUCHENZHOU and spell:ready() and yingdui == nil then
        yingdui = spell
        -- return true
    end
end)

spellbooks.spells.LEITINGYIJI:callback(function(spell, logic)
    -- print("雷霆一击",isLT)
    if player.enemiesaround(10) >= 1 and isLT then
        return spell:cast(player)
    end
    if not spellbooks.spells.DUNPAIMENGJI:ready() and player.enemiesaround(10) >= 1 then
        -- print("盾猛击cd中")
        return spell:cast(player)
    end
end)

spellbooks.spells.YINGYONGTOUZHI:callback(function(spell, logic)
    if addSpellStat == "英勇投掷" then
        target = Aurora.UnitManager:Get("target")
        if target.exists and player.distanceto(target) > 8 and player.haslos(target) and player.distanceto(target) < 30 then
            return spell:cast(target)
        end
    end
end)

spellbooks.spells.YONGSHIZHIMAO:callback(function(spell, logic)
    if addSpellStat == "cursor勇士之矛" then
        if spell:isknown() and spell:ready() then
            return spell:castcursor()
        end
    -- elseif addSpellStat == "target勇士之矛" then
    --     return spell:cast(target)
    end
end)

spellbooks.spells.DUNPAIGEDANG:callback(function(spell, logic)
    -- print("盾牌格挡:",spell:charges())
    if player.enemiesaround(12) >= 1 and player.rage >= 30 then
        if not player.aura(132404) or player.auraremains(132404) <= 5 or spell:charges() == 2 then
            return spell:cast(player)
        end
    end
end)

spellbooks.spells.DUNPAIMENGJI:callback(function(spell, logic)
    -- print("盾牌猛击")
    isTargetBehind(spell, 5)
end)



spellbooks.spells.SHENGLIZAIWANG:callback(function(spell, logic)
    -- print("胜利在望")
    if player.hp < 75 then
        -- print("胜利在望")
        isTargetBehind(spell, 5)
    end
    
end)

spellbooks.spells.WUSHITONGKU:callback(function(spell, logic)
    -- print("无视苦痛")
    if player.rage >= 40 then
        local auras = player.aura(190456)
        -- print("无视苦痛",player.shieldamount)
        local shiedMax = player.healthmax * 0.3
        -- print("无视苦痛",player.auraremains(190456),player.shieldamount,shiedMax * isIgnoringPain,auras)
        if  not auras  or player.auraremains(190456) <= 2 or player.shieldamount < shiedMax * isIgnoringPain then
            -- print("无视苦痛cd",auras.charges)
            return spell:cast(player)
        end
    end

    if player.rage >= 90 then
        return spell:cast(player)
    end

    
end)

spellbooks.spells.DUNPAICHONGFENG:callback(function(spell, logic)
    -- print("盾牌冲锋")
    if addSpellStat == "盾牌冲锋" then
        target = Aurora.UnitManager:Get("target")
        if target.exists and target.enemy and player.distanceto(target) <= 25 and spell:ready() and spell:isknown() then
            return spell:cast(target)
        end
    elseif isDunpaichongfeng and spell:ready() and spell:isknown() then
        isTargetBehind(spell, 3)
    end
    -- isTargetBehind(spell, 5)
end)

spellbooks.spells.CUOZHINUHOU:callback(function(spell, logic)
    -- print("挫志怒吼")
    if addSpellStat == "挫志怒吼" then
        if spell:ready() then
            return spell:cast(player)
        end
    end

    if isCUOZHINUHOU and spell:isknown() and spell:ready() and yingdui == nil then
        yingdui = spell
    end

    if isCZCD and player.enemiesaround(8) >= 1 and player.speed == 0 then
        return spell:cast(player)
    end

end)

spellbooks.spells.ZHANSHA2:callback(function(spell, logic)
        -- print("斩杀2")
        if spellbooks.talents.CUISI:isknown() then
        if player.aura(52437) then
            isTargetBehind(spell, 5)
        end
    end
end)

spellbooks.spells.ZHANSHA:callback(function(spell, logic)
    -- print("斩杀")
    local enemyCount = player.enemiesaround(5)
    -- local shiedMax = player.healthmax * 0.3
    --     if enemyCount <= 3 and player.rage >= 40 and player.aura(132404).duration > 4 and player.shieldamount > shiedMax * 0.8 and player.aura(190456).duration > 5  then
    --         isTargetBehind(spell, 5)
    --     end
    -- target = Aurora.UnitManager:Get("target")
    -- if spellbooks.talents.CUISI:isknown() then
    --     if player.aura(52437) then
    --         isTargetBehind(spell, 5)
    --     elseif player.rage >= 40  then
    --         isTargetBehind(spell, 5)
    --     end
    

    if player.rage >= 40 and enemyCount <= 3 then
        isTargetBehind(spell, 5)
    end
end)

spellbooks.spells.FUCHOU:callback(function(spell, logic)
    -- print("复仇")
    local enemyCount = player.enemiesaround(8)
    target = Aurora.UnitManager:Get("target")
    --免费复仇逻辑
    if player.aura(5302) then
        target = Aurora.UnitManager:Get("target")
        if target.exists and target.enemy and enemyCount >= 1 then
            return spell:cast(player)
        else
            isLoop = true;
        end
    end
    --付费复仇逻辑
    -- local shiedMax = player.healthmax * 0.3
    if player.rage >= 30 and enemyCount >= 1 then
        return spell:cast(player)
    end
end)
--补重伤
spellbooks.spells.FUCHOU2:callback(function(spell, logic)
    -- print("复仇2")
    target = Aurora.UnitManager:Get("target")
   if target.exists and target.enemy and not target.aura(115767) and player.rage >= 30 and player.distanceto(target) < 5 then
        return spell:cast(player)
    end
end)


spellbooks.spells.JIJIENAHAN:callback(function(spell, logic)
    -- print("集结呐喊")
    if addSpellStat == "集结呐喊" then
        if spell:ready() then
            return spell:cast(player)
        else
            isLoop = true;
        end
    end
end)

spellbooks.spells.ZHENDANGBO:callback(function(spell, logic)
    -- print("震荡波")
    if addSpellStat == "震荡波" then
        if spell:ready() and spell:isknown() then
            return spell:cast(player)
        else
            isLoop = true;
        end
    end
end)

spellbooks.spells.FANGBAOZHICHUI:callback(function(spell, logic)
    -- print("风暴之锤")
    if addSpellStat == "风暴之锤" then
        target = Aurora.UnitManager:Get("target")
        if target.exists and target.enemy and player.distanceto(target) <= 20 and spell:ready() and spell:isknown() then
            return spell:cast(target)
        else
            isLoop = true;
        end
        -- return spell:cast(player)
    end
end)

spellbooks.spells.LEIMINGZHIHOU:callback(function(spell, logic)
    -- print("雷鸣之吼")
    if addSpellStat == "雷鸣之吼" then
        if spell:isknown() and spell:ready() then
            return spell:cast(player)
        else
            isLoop = true;
        end
    end
    --雷鸣之吼
    if isLonghou and spell:isknown() and spell:ready() then
        if player.speed == 0 or player.enemiesaround(10) > 4 then
            return spell:cast(player)
        end
    end
end)

spellbooks.spells.ZHANDOUNUHOU:callback(function(spell, logic)
    -- print("战斗怒吼")
    if addSpellStat == "战斗怒吼" then
        return spell:cast(player)
    end
    --自动战斗怒吼
    if isGongqiang and not player.combat then
        local fgroup = Aurora.fgroup
        fgroup:each(function(unit, i, uptime)
            if not unit.aura(6673) and unit.alive then
                return spell:cast(player) -- breaks the loop
            end
        end)
        -- return spell:cast(player)
    end
end)

spellbooks.spells.QUANJI:callback(function(spell, logic)
    --  print("自动打断")
    if autoQuanji and spellbooks.spells.QUANJI:ready() then
       
        target = Aurora.UnitManager:Get("target")
        focus = Aurora.UnitManager:Get("focus")
        if focus.exists and focus.distanceto(player) <= 4 and player.haslos(focus) and focus.enemy and focus.alive and focus.castinginterruptible and focus.playerfacing180 and focus.castingpct >= 50 then
            return spell:cast(focus)
        end
        if focus.exists and focus.distanceto(player) <= 4 and player.haslos(focus) and focus.enemy and focus.alive and focus.channelinginterruptible and focus.playerfacing180 and focus.channelingpct >= 50 then
            return spell:cast(focus)
        end

        local activeenemies = Aurora.activeenemies
        if activeenemies and not focus.exists then
        activeenemies:each(function(enemy, index, uptime)
            -- print("进战斗的怪",enemy.name)
            if enemy.castinginterruptible and enemy.exists and enemy.distanceto(player) <= 4 and player.haslos(enemy) and enemy.enemy and enemy.alive and enemy.playerfacing180 and enemy.castingpct >= 50 then
                spell:cast(enemy)
                return true -- break the loop
            end
            if enemy.channelinginterruptible and enemy.exists and enemy.distanceto(player) <= 4 and player.haslos(enemy) and enemy.enemy and enemy.alive and enemy.playerfacing180 and enemy.channelingpct >= 50 then
                spell:cast(enemy)
                return true -- break the loop
            end
            end)    
        end
    end
end)

spellbooks.spells.FASHUFANSHE:callback(function(spell, logic)
    -- print("法术反射")
    if isFSFS then
        if spell:ready() then
            local activeenemies = Aurora.activeenemies
            if activeenemies then
                activeenemies:each(function(enemy, index, uptime)
                    -- print("读条怪，目标：",enemy.name,enemy.casttarget,player)
                    if enemy.casting then
                        -- print("here")
                        if enemy.castingremains <= 1 and enemy.casttarget.name == player.name then
                            -- print("读条时间：",enemy.castingremains,enemy.castingspellid,enemy.casttarget.name)
                            -- print("玩家名字：",player.name)
                            for k, v in pairs(reflectionSpell) do
                                if enemy.castingspellid == v then
                                    spell:cast(player)
                                return true
                            end
                        end
                    end
                end
                end)    
                -- return spell:cast(player)
            end
        else
            isLoop = true;
        end
    end
end)


local spellbook = Aurora.SpellHandler.Spellbooks.warrior["3"].Mia_Warrior
local spells = spellbook.spells
local healthPotion = Aurora.ItemHandler.NewItem(244839)

local function loop()

  injuryResponse()
  if spells.QUANJI:execute() then return true end
  if spells.TIANSHENXIAFAN:execute() then return true end
  if spells.CUOZHINUHOU:execute() then return true end
  if spells.DUNQIANG:execute() then return true end
  if spells.POFUCHENZHOU:execute() then return true end
  if spells.YONGSHIZHIMAO:execute() then return true end
  if spells.DUNPAICHONGFENG:execute() then return true end
  
  if spells.JIJIENAHAN:execute() then return true end
  if spells.ZHENDANGBO:execute() then return true end
  if spells.FANGBAOZHICHUI:execute() then return true end
  if spells.LEIMINGZHIHOU:execute() then return true end
  if spells.ZHANDOUNUHOU:execute() then return true end
  if spells.FASHUFANSHE:execute() then return true end
--   print("反射执行了吗",spells.FASHUFANSHE:execute())

  if spells.DUNPAIGEDANG:execute() then return true end
  if spells.SHENGLIZAIWANG:execute() then return true end
  if spells.WUSHITONGKU:execute() then return true end
  
 
  if spells.ZHANSHA2:execute() then return true end
  
  if spells.LEITINGYIJI:execute() then return true end
  if spells.DUNPAIMENGJI:execute() then return true end
  
--   if spells.FUCHOU2:execute() then return true end
  if spells.ZHANSHA:execute() then return true end
  if spells.FUCHOU:execute() then return true end
  if spells.AutoAttack:execute() then return true end
  return false
end
--鼠标指向战复（道具）
local function resurrectionInBattle()
    mouseover = Aurora.UnitManager:Get("mouseover")
    -- print("鼠标指向战复（道具）",battleResurrection:isknown(),battleResurrection:ready())
    if mouseover.exists and mouseover.friend and mouseover.dead and player.distanceto(mouseover) <= 3 and battleResurrection:isknown() and battleResurrection:ready() then
        isLoop = false
        battleResurrection:use(mouseover,function ()
            isLoop = true
        end)
    else
        isLoop = true
    end
end


local function battleReady()
    if fuwen:isknown() and fuwen:ready() and not player.aura(1234969) then
        fuwen:use(player)
    end
end

Aurora:RegisterRoutine(function()
    -- print("战斗外逻辑")
    -- Run appropriate function based on combat status
    if player.dead or player.iseating or player.isdrinking or player.issummoning or player.casting or player.mounted then return end
    -- print("玩家名字",player.name)
    resurrectionInBattle()
    -- target = Aurora.UnitManager:Get("target")
    -- print(target.distanceto(player))
    if isLoop then
        if player.combat then
            if healthPotion:ready() and healthPotion:usable(player) and player.hp < 40 then
                    healthPotion:use(player)
                end
            loop()
        else
            -- print("脱战")
            battleReady()
            if spells.ZHANDOUNUHOU:execute() then return true end
            
        end
    end
end, "WARRIOR", 3, "Mia_Warrior")


-- /Aurora Feidun 


Aurora.EventHandler:RegisterEvent("SPELL_CAST_SUCCESS", function(eventData)
    if eventData.source.guid == UnitGUID("player") then
        local spellId, spellName = unpack(eventData.params)
        -- print("施法成功",spellName,castedCount)
        if  spellName ~= "盾牌格挡" and spellName ~= "法术反射" and spellName ~= "防御姿态" and spellName ~= "战斗姿态" and spellName ~= "拳击" and spellName ~= "英勇飞跃" and spellName ~= "挑战怒吼" and spellName ~= "盾墙" and spellName ~= "无视苦痛" and spellName ~= "破釜沉舟" and spellName ~= "嘲讽" and spellName ~= "冲锋" then
            castedCount = castedCount + 1
            --应对技能计数
            yingduicount = yingduicount + 1
            isLT = true
        end

        if spellId == 1160 or spellId == 12975 or spellId == 871 then
            yingduicount = 0
        end

        if yingduicount > 5 then
            yingduicount = 0
            yingdui = nil
        end

        if spellName == "雷霆一击" or spellName == "雷霆轰击" then
            isLT = false
        end
        
        if castedCount > 2  then
            addSpellStat = nil
            castedCount = 0
        end
        -- print(string.format("Cast %s (ID: %d)", spellName, spellId))
        if spellName == addSpellStat then
            -- isLoop = true
            addSpellStat = nil
            castedCount = 0
        end
    end
end)

local autoQuanji_toggle = Aurora:AddGlobalToggle({
    label = "自动打断",              -- Display name (max 11 characters)
    var = "autoQuanji_toggle",       -- Unique identifier for saving state
    icon = 6552, -- Icon texture or spell ID
    tooltip = "自动打断", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动打断:", value)
        autoQuanji = value
    end
})

local autoFS_toggle = Aurora:AddGlobalToggle({
    label = "自动法术反射",              -- Display name (max 11 characters)
    var = "autoFS_toggle",       -- Unique identifier for saving state
    icon = 23920, -- Icon texture or spell ID
    tooltip = "自动法术反射", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动打断:", value)
        isFSFS = value
    end
})

local autoCZCD_toggle = Aurora:AddGlobalToggle({
    label = "挫志怒吼卡cd",              -- Display name (max 11 characters)
    var = "autoCZCD_toggle",       -- Unique identifier for saving state
    icon = 1160, -- Icon texture or spell ID
    tooltip = "挫志怒吼卡cd", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动打断:", value)
        isCZCD = value
    end
})

local autoSwitchTarget_toggle = Aurora:AddGlobalToggle({
    label = "自动切换目标",              -- Display name (max 11 characters)
    var = "autoSwitchTarget_toggle",       -- Unique identifier for saving state
    icon = 76290, -- Icon texture or spell ID
    tooltip = "丢失自动攻击切换目标,生效范围:4-8码", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isSwitchTarget = value
    end
})
local autoDunpaichongfeng_toggle = Aurora:AddGlobalToggle({
    label = "盾牌冲锋",              -- Display name (max 11 characters)
    var = "autoDunpaichongfeng_toggle",       -- Unique identifier for saving state
    icon = 385952, -- Icon texture or spell ID
    tooltip = "冲锋最近的,防止位移", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isDunpaichongfeng = value
    end
})
local autoLonghou_toggle = Aurora:AddGlobalToggle({
    label = "雷鸣之吼",              -- Display name (max 11 characters)
    var = "autoLonghou_toggle",       -- Unique identifier for saving state
    icon = 384318, -- Icon texture or spell ID
    tooltip = "站住不动或者周围4目标以上", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isLonghou = value
    end
})

local autoTianshen_toggle = Aurora:AddGlobalToggle({
    label = "天神下凡",              -- Display name (max 11 characters)
    var = "autoTianshen_toggle",       -- Unique identifier for saving state
    icon = 107574, -- Icon texture or spell ID
    tooltip = "自动天神下凡,站住不动或者5目标以上", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        autoTianshen = value
    end
})

local autoGongqiang_toggle = Aurora:AddGlobalToggle({
    label = "战斗怒吼",              -- Display name (max 11 characters)
    var = "autoGongqiang_toggle",       -- Unique identifier for saving state
    icon = 6673, -- Icon texture or spell ID
    tooltip = "脱战生效,战斗中用宏插入", -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isGongqiang = value
    end
})
if autoLonghou_toggle:GetValue() then
    isLonghou = true
end

if autoTianshen_toggle:GetValue() then
    autoTianshen = true
end

if autoGongqiang_toggle:GetValue() then
    isGongqiang = true
end

if autoDunpaichongfeng_toggle:GetValue() then
    isDunpaichongfeng = true
end

if autoSwitchTarget_toggle:GetValue() then
    isSwitchTarget = true
end

if autoCZCD_toggle:GetValue() then
    isCZCD = true
end

if autoFS_toggle:GetValue() then
    -- print("自动法术反射：",autoFS_toggle:GetValue())
    isFSFS = true
end

-- Later you can check the toggle state
if autoQuanji_toggle:GetValue() then
    -- AoE mode is enabled
    -- print("卡CD飞盾")
    -- autoQuanji_toggle:SetValue(true)
    autoQuanji = true
end
Macro:RegisterCommand("IgnoringPain", function(value)
    -- print(isFeidun)
    if value == "average" then
        --一般
        isIgnoringPain = 0.28
        print("设置无视苦痛吸收量：一般")
    elseif value == "moderate" then
        --中等
        isIgnoringPain = 0.56
        print("设置无视苦痛吸收量：中等")
    elseif value == "extreme" then
        --极端
        isIgnoringPain = 0.8
        print("设置无视苦痛吸收量：极端")
    end
    Aurora.Config:Write("graphics.isIgnoringPain", value)
end, "Casts the specified spell")

Macro:RegisterCommand("SwitchTarget", function()
    isSwitchTarget = not isSwitchTarget
    -- Aurora.Config:Write("feature.isSwitchTarget", isSwitchTarget)
    autoSwitchTarget_toggle:SetValue(isSwitchTarget)
    -- print("切换目标：",isSwitchTarget)
end, "切换目标")

Macro:RegisterCommand("SpellReflection", function()
    isFSFS = not isFSFS
    autoFS_toggle:SetValue(isFSFS)
    -- print("法术反射：",isFSFS)
end, "法术反射")

Macro:RegisterCommand("Shout", function()
    isCZCD = not isCZCD
    -- Aurora.Config:Write("feature.isCZCD", isCZCD)
    autoCZCD_toggle:SetValue(isCZCD)
    -- print("挫志怒吼卡cd：",isCZCD)
end, "挫志怒吼卡cd")
Macro:RegisterCommand("AutomaticInterruption", function()
    autoQuanji = not autoQuanji
    -- Aurora.Config:Write("feature.isCZCD", isCZCD)
    autoQuanji_toggle:SetValue(autoQuanji)
    -- print("自动打断：",autoQuanji)
end, "自动打断")
Macro:RegisterCommand("ShieldCharge", function()
    isDunpaichongfeng = not isDunpaichongfeng
    -- Aurora.Config:Write("feature.isDunpaichongfeng", isDunpaichongfeng)
    autoDunpaichongfeng_toggle:SetValue(isDunpaichongfeng)
    -- print("盾牌冲锋：",isDunpaichongfeng)
end, "盾牌冲锋")
Macro:RegisterCommand("ThunderousRoar", function()
    isLonghou = not isLonghou
    -- Aurora.Config:Write("feature.isLonghou", isLonghou)
    autoLonghou_toggle:SetValue(isLonghou)
    -- print("雷鸣之吼：",isLonghou)
end, "雷鸣之吼")
Macro:RegisterCommand("BKB", function()
    autoTianshen = not autoTianshen
    -- Aurora.Config:Write("feature.isLonghou", isLonghou)
    autoTianshen_toggle:SetValue(autoTianshen)
    -- print("天神下凡：",autoTianshen)
end, "天神下凡")


Aurora.Macro:RegisterCommand("cast", function(spell)
    print("插入技能:",spell)
    if spell then
        addSpellStat = spell
        castedCount = 0
    end
end, "Casts the specified spell")


InitConfig()
Aurora:RemoveGlobalToggle("rotation_interrupt")
Aurora:RemoveGlobalToggle("rotation_cooldown")
return Mia_Warrior
