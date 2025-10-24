local player = Aurora.UnitManager:Get("player")
if player.spec == 2 then
if not Aurora.Tool then
    require "Tool"
end
local Tool = Aurora.Tool or {}

if not Aurora.TZList then
    require "tzList"
end
local TZList = Aurora.TZList or {}
local gui = Aurora.GuiBuilder:New()
Aurora.InterfaceItem = {
    mouseoverCR = true,-- 战复
    explosivePotionBindingBKB = true,-- 淬火药水绑定天神下凡
    trinket1Enabled = true,-- 饰品1
    trinket2Enabled = true,-- 饰品2
    trinket1Binding = "bkb",-- 饰品1绑定到
    trinket2Binding = "rough",-- 饰品2绑定到
    recoveryPotionThreshold = 30,-- 焕生治疗药水阈值
    bkbTTD = 30,-- 天神下凡TTD
    roughTTD = 30,-- 鲁莽TTD
    swordSlamTTD = 30,-- 剑刃风暴TTD
    impendingVictoryThreshold = 30,-- 胜利在望阈值
    enableRagingRecovery = true,-- 狂暴战恢复
    enableSpellReflection = true,-- 法术反射
    RagingRecoveryThreshold = 30,-- 狂暴回复阈值
    enableHealthDefense = true,-- 生命值防御
    enableImpendingVictory = true,-- 胜利在望
    boltCastingPercentage = 30,-- 风暴之锤控断百分比
    enableStormBolt = true,-- 风暴之锤
    enableShockwave = true,-- 震荡波
    shockwaveCastingPercentage = 30,-- 震荡波控断百分比
    enableIntimidatingShout = true,-- 破胆怒吼
    intimidatingShoutCastingPercentage = 30,-- 破胆怒吼控断百分比
    interruptstat = "all",-- 打断目标
    interruptthreshold = 50,-- 打断阈值
    drawFace = true,-- 绘制目标面
    drawConnection = true,-- 绘制目标连接线
    drawLineWidth = 2,-- 绘制线宽度
    onlyincombat = true,-- 仅在战斗中绘制
    isdraw = true,-- 是否绘制
    autoRaceSpells = true,-- 自动使用种族技能
    enableLucky = true,-- 自动关闭幸运开关
}
Aurora.Icon = {
    bkb =  Aurora.texture(107574),
    rough = Aurora.texture(1719),
    KUANGBAOHUIFU = Aurora.texture(184364),
    JIANRENFENGBAO = Aurora.texture(446035),
    LEIMINGZHIHOU = Aurora.texture(384318),
    ZHANDOUNUHOU = Aurora.texture(6673),
    SHENGLIZAIWANG = Aurora.texture(202168),
    FASHUFANSHE = Aurora.texture(23920),
    ZHENDANGBO = Aurora.texture(46968),
    QUANJI = Aurora.texture(6552),
    PODANNUHOU = Aurora.texture(5246),
    FENGBAOZHICHUI = Aurora.texture(107570),
    POLIETOUZHI = Aurora.texture(384110),
    SILIE = Aurora.texture(394062),
    YONGSHIZHIMAO = Aurora.texture(376079),
    DABAOFA = Aurora.texture(118038),



}
local function CreateSkillMacro()
    -- 先判断宏是否已满（角色宏18个，通用宏120个，这里以角色宏为例）
    local numGlobal,numPerChar = GetNumMacros()
    if numGlobal >= 109 then
        -- 抛出错误，会在聊天框显示提示
        Aurora.alert(Tool:getLocalizedText("Mia: 角色宏列表已满，无法创建新宏！", "Mia: Role macro list is full, cannot create new macro!"))
    else
        Aurora.Tool:CreateMacro(97462, "regular", false)
        Aurora.Tool:CreateMacro(384318, "regular", false)
        Aurora.Tool:CreateMacro(46968, "regular", false)
        Aurora.Tool:CreateMacro(107570, "regular", false)
        Aurora.Tool:CreateMacro(107570, "mouseover", false)
        Aurora.Tool:CreateMacro(446035, "regular", false)
        Aurora.Tool:CreateMacro(376079, "cursor", false)
        Aurora.Tool:CreateMacro(385059, "regular", false)


        CreateMacro(Tool:getLocalizedText("开关", "Toggle"), "INV_Misc_QuestionMark", "/"..Aurora.Macro.baseCommand.." toggle", nil)
    end 
end

gui:Category(Tool:getLocalizedText("Mia_狂暴战", "Mia_Warrior"))
    :Tab(Tool:getLocalizedText("宏命令", "Macros"))
    :Header({ text = Tool:getLocalizedText("基础宏命令", "Basic Macros") })
    :Button({
        text = Tool:getLocalizedText("创建常用宏命令", "Create Common Macros"), 
        key = "marco",
        width = 100,
        height = 30,
        onClick = function()
            CreateSkillMacro()
    end})
    :Button({text = Tool:getLocalizedText("复制常用天赋字符串", "Copy Common Talent String"), key = "talent", width = 100, height = 30,onClick = function() CopyToClipboard("CkEArbixk/CgEArbixk/ZKwTdpZGVHeylmLAAAAAAAAAQjhxsxMMzygZWYmZGzwMMz22MjZGLDYmZGzMWGGmZmBAAAxYbbgFwEMDTgZYDA") end})
    :Header({ text = Tool:getLocalizedText("宏命令开关,点击复制", "Settings,Click to Copy") })
    :Button({text = Aurora.Icon.QUANJI..Tool:getLocalizedText("开关自动打断", "Toggle Automatic Interruption"), key = "automaticinterruption", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." interrupt") end})
    :Button({text = Aurora.Icon.bkb..Tool:getLocalizedText("开关天神下凡", "Toggle BKB"), key = "Togglebkb", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." bkb") end})
    :Button({text = Aurora.Icon.rough..Tool:getLocalizedText("开关鲁莽", "Toggle recklessness"), key = "Togglerough", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." recklessness") end})
    :Button({text = Aurora.Icon.JIANRENFENGBAO..Tool:getLocalizedText("开关剑刃风暴", "Toggle bladestorm"), key = "Togglebladestorm", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." bladestorm") end})
    :Button({text = Aurora.Icon.LEIMINGZHIHOU..Tool:getLocalizedText("开关雷鸣之吼", "Toggle thunderrousroar"), key = "Toggletunderrousroar", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." thunderrousroar") end})
    :Button({text = Aurora.Icon.ZHANDOUNUHOU..Tool:getLocalizedText("开关战斗怒吼", "Toggle Battle shout"), key = "Togglebattleshout", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." shout") end})
    :Button({text = Aurora.Icon.POLIETOUZHI..Tool:getLocalizedText("开关破裂投掷", "Toggle break the shield"), key = "Togglebreaktheshield", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." breaktheshield") end})
    :Button({text = Aurora.Icon.SILIE..Tool:getLocalizedText("开关强制单体", "Toggle force single target"), key = "Toggleforcesingletarget", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." forcesingletarget") end})
    :Button({text = Aurora.Icon.YONGSHIZHIMAO..Tool:getLocalizedText("开关勇士之矛", "Toggle warrior's spear"), key = "Togglewarriorspear", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." warriorspear") end})
    :Button({text = Aurora.Icon.DABAOFA..Tool:getLocalizedText("开关一键大爆发", "Toggle one-click big explode"), key = "Toggleoneclickbigexplode", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." cooldown") end})
    
    :Header({ text = Tool:getLocalizedText("提示:目标超出攻击范围会自动攻击附近的目标，不需要切换目标", "Auto Attack Nearby Target") })


    :Tab(Tool:getLocalizedText("物品", "Items"))
--    :Header({ text = Tool:getLocalizedText("设置", "Settings") })
    :Checkbox({
        text = Tool:getLocalizedText("指向战复", "Battle Resurrection"),
        key = "battleResurrection.enabled",  -- Config key for saving
        default = true,          -- Default value
        tooltip = Tool:getLocalizedText("启用战复功能", "Enable Battle Resurrection"), -- Optional tooltip
        onChange = function(self, checked)
            Aurora.InterfaceItem.mouseoverCR = checked
        end
    })
    :Checkbox({
        text = Tool:getLocalizedText("淬火药水绑定天神下凡", "Explosive Potion Binding BKB"),
        key = "explosivePotionBindingBKB.enabled",  -- Config key for saving
        default = true,          -- Default value
        tooltip = Tool:getLocalizedText("启用淬火药水绑定天神下凡", "Enable Explosive Potion Binding BKB"), -- Optional tooltip
        onChange = function(self, checked)
            Aurora.InterfaceItem.explosivePotionBindingBKB = checked
        end
    })
    :Header({ text = Tool:getLocalizedText("饰品", "Trinkets") })
    :Checkbox({
        text = Tool:getLocalizedText("饰品1", "Enable Trinket 1"),
        key = "trinket1.enabled",  -- Config key for saving
        default = true,          -- Default value
        tooltip = Tool:getLocalizedText("启用饰品1功能", "Enable Trinket 1"), -- Optional tooltip
        onChange = function(self, checked)
            Aurora.InterfaceItem.trinket1Enabled = checked
        end
    })
    :Checkbox({
        text = Tool:getLocalizedText("饰品2", "Enable Trinket 2"),
        key = "trinket2.enabled",  -- Config key for saving
        default = true,          -- Default value
        tooltip = Tool:getLocalizedText("启用饰品2功能", "Enable Trinket 2"), -- Optional tooltip
        onChange = function(self, checked)
            Aurora.InterfaceItem.trinket2Enabled = checked
        end
    })
    :Dropdown({
        text = Tool:getLocalizedText("饰品1绑定到", "Trinket 1 Binding"),
        key = "trinket1.binding",
        options = {
            { text = Aurora.Icon.bkb .. " " .. Tool:getLocalizedText("天神下凡", "BKB"), value = "bkb" },
            { text = Aurora.Icon.rough .. " " .. Tool:getLocalizedText("鲁莽", "recklessness"), value = "rough" },
        },
        default = "bkb",
        multi = false,           -- Set to true for multi-select
        width = 200,            -- Optional
        tooltip = Tool:getLocalizedText("选择饰品1绑定到", "Select Trinket 1 Binding"),
        onChange = function(self, value)
            Aurora.InterfaceItem.trinket1Binding = value
        end
    })
    :Dropdown({
        text = Tool:getLocalizedText("饰品2绑定到", "Trinket 2 Binding"),
        key = "trinket2.binding",
        options = {
            { text = Aurora.Icon.bkb .. " " .. Tool:getLocalizedText("天神下凡", "BKB"), value = "bkb" },
            { text = Aurora.Icon.rough .. " " .. Tool:getLocalizedText("鲁莽", "recklessness"), value = "rough" },
        },
        default = "rough",
        multi = false,           -- Set to true for multi-select
        width = 200,            -- Optional
        tooltip = Tool:getLocalizedText("选择饰品2绑定到", "Select Trinket 2 Binding"),
        onChange = function(self, value)
            Aurora.InterfaceItem.trinket2Binding = value
        end
    })
    :Header({ text = Tool:getLocalizedText("焕生治疗药水/治疗之石", "Recovery potion") })
    :Slider({
        text = " ",
        key = "recoveryPotionThreshold",
        default = 30,
        min = 10,
        max = 90,
        step = 10,
        tooltip = Tool:getLocalizedText("设置焕生治疗药水/治疗之石的阈值", "Set the threshold for using recovery potions/Healing Stones"),
        onChange = function(self, value)
            Aurora.InterfaceItem.recoveryPotionThreshold = value
        end
    })
    :Tab(Tool:getLocalizedText("进攻", "Attacks"))
    :Text({
        text = Aurora.Icon.bkb .. " " .. Tool:getLocalizedText("天神下凡TTD", "BKB TTD"),
        size = 12,               -- Optional font size (default: 12)
        color = "normal",        -- Optional: "normal", "header", or {r = 1, g = 0, b = 0, a = 1}
        width = 300,             -- Optional width (default: 300)
        height = 20,             -- Optional height (default: 20)
        inherit = "GameFontNormalLarge" -- Optional font inheritance
    })
    :Slider({
        text = " ",
        key = "bkbTTD",
        default = 30,
        min = 0,
        max = 90,
        step = 5,
        tooltip = Tool:getLocalizedText("设置天神下凡TTD", "Set the TTD for BKB"),
        onChange = function(self, value)
            Aurora.InterfaceItem.bkbTTD = value
        end
    })
    :Text({
        text = Aurora.Icon.rough .. " " .. Tool:getLocalizedText("鲁莽TTD", "recklessness TTD"),
        size = 12,               -- Optional font size (default: 12)
        color = "normal",        -- Optional: "normal", "header", or {r = 1, g = 0, b = 0, a = 1}
        width = 300,             -- Optional width (default: 300)
        height = 20,             -- Optional height (default: 20)
        inherit = "GameFontNormalLarge" -- Optional font inheritance
    })
    :Slider({
        text = " ",
        key = "roughTTD",
        default = 50,
        min = 0,
        max = 90,
        step = 5,
        tooltip = Tool:getLocalizedText("设置鲁莽TTD", "Set the TTD for recklessness"),
        onChange = function(self, value)
            Aurora.InterfaceItem.roughTTD = value
        end
    })
    :Text({
        text = Aurora.Icon.JIANRENFENGBAO .. " " .. Tool:getLocalizedText("剑刃风暴TTD", "Sword Slam TTD"),
        size = 12,               -- Optional font size (default: 12)
        color = "normal",        -- Optional: "normal", "header", or {r = 1, g = 0, b = 0, a = 1}
        width = 300,             -- Optional width (default: 300)
        height = 20,             -- Optional height (default: 20)
        inherit = "GameFontNormalLarge" -- Optional font inheritance
    })
    :Slider({
        text = " ",
        key = "swordSlamTTD",
        default = 30,
        min = 0,
        max = 90,
        step = 5,
        tooltip = Tool:getLocalizedText("设置剑刃风暴TTD", "Set the TTD for Sword Slam"),
        onChange = function(self, value)
            Aurora.InterfaceItem.swordSlamTTD = value
        end
    })
    :Header({ text = Tool:getLocalizedText("种族技能", "Race Spells") })
    :Checkbox({
        text =Tool:getLocalizedText("爆发自动使用种族技能", "auto use of race spells"),
        key = "autoRaceSpells",
        default = true,
        tooltip = Tool:getLocalizedText("启用自动使用种族技能", "Enable auto use of race spells"),
        onChange = function(self, value)
            Aurora.InterfaceItem.autoRaceSpells = value
        end
    })
    :Checkbox({
        text = Tool:getLocalizedText("爆发技能释放后自动关闭开关", "auto close switch after using lucky"),
        key = "enableLucky",
        default = true,
        tooltip = Tool:getLocalizedText("爆发技能释放后自动关闭开关", "auto close switch after using lucky"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableLucky = value
        end
    })

    :Tab(Tool:getLocalizedText("防御", "Defenses"))
    :Header({ text = Tool:getLocalizedText("减伤应对", "Reduction Spells") })
    -- :Checkbox({
    --     text = Tool:getLocalizedText("狂暴恢复", "raging recovery"),
    --     key = "enableRagingRecovery",
    --     default = false,
    --     tooltip = Tool:getLocalizedText("启用狂暴恢复", "Enable Raging Recovery"),
    --     onChange = function(self, value)
    --         Aurora.InterfaceItem.enableRagingRecovery = value
    --     end
    -- })
    -- :Button({
    --     text = Tool:getLocalizedText("狂暴恢复应对列表", "Raging Recovery List"),
    --     key = "refreshRagingRecoveryList",
    --     default = false,
    --     tooltip = Tool:getLocalizedText("狂暴恢复应对列表", "Raging Recovery List"),
    --     onClick = function(self, value)
    --         TZList:createList("refreshRagingRecoveryList")
    --     end
    -- })
    :Checkbox({
        text = Aurora.Icon.FASHUFANSHE .. " " .. Tool:getLocalizedText("法术反射", "Spell Reflection"),
        key = "enableSpellReflection",
        default = true,
        tooltip = Tool:getLocalizedText("启用法术反射", "Enable Spell Reflection"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableSpellReflection = value
        end
    })
    :Button({
        text = Aurora.Icon.FASHUFANSHE .. " " .. Tool:getLocalizedText("法术反射列表", "Spell Reflection List"),
        key = "refreshSpellReflectionList",
        default = false,
        tooltip = Tool:getLocalizedText("法术反射列表", "Spell Reflection List"),
        onClick = function(self, value)
            TZList:createList("refreshSpellReflectionList")
        end
    })
    :Header({ text = Tool:getLocalizedText("血量应对", "Health Defense") })
    :Checkbox({
        text = Aurora.Icon.KUANGBAOHUIFU .. " " .. Tool:getLocalizedText("狂暴回复", "Raging Recovery"),
        key = "enableHealthDefense",
        default = true,
        tooltip = Tool:getLocalizedText("启用血量应对", "Enable Health Defense"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableHealthDefense = value
        end
    })
    :Slider({
        text = " ",
        key = "RagingRecoveryThreshold",
        default = 60,
        min = 0,
        max = 90,
        step = 10,
        tooltip = Tool:getLocalizedText("设置狂暴回复阈值", "Set the threshold for Raging Recovery"), 
        onChange = function(self, value)
            Aurora.InterfaceItem.RagingRecoveryThreshold = value
        end
    })
    :Checkbox({
        text = Aurora.Icon.SHENGLIZAIWANG .. " " .. Tool:getLocalizedText("胜利在望", "Impending Victory"),
        key = "enableImpendingVictory",
        default = true,
        tooltip = Tool:getLocalizedText("启用胜利在望", "Enable Impending Victory"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableImpendingVictory = value
        end
    })
    :Slider({
        text = " ",
        key = "impendingVictoryThreshold",
        default = 75,
        min = 0,
        max = 90,
        step = 5,
        tooltip = Tool:getLocalizedText("设置胜利在望阈值", "Set the threshold for Impending Victory"), 
        onChange = function(self, value)
            Aurora.InterfaceItem.impendingVictoryThreshold = value
        end
    })
    :Tab(Tool:getLocalizedText("控制", "CC"))
    :Header({ text = Aurora.Icon.FENGBAOZHICHUI .. " " .. Tool:getLocalizedText("风暴之锤", "storm bolt") })
    :Checkbox({
        text = Aurora.Icon.FENGBAOZHICHUI .. " " .. Tool:getLocalizedText("开启风暴之锤", "Enable Storm Bolt"),
        key = "enableStormBolt",
        default = true,
        tooltip = Tool:getLocalizedText("启用风暴之锤", "Enable Storm Bolt"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableStormBolt = value
        end
    })
    :Button({
        text = Aurora.Icon.FENGBAOZHICHUI .. " " .. Tool:getLocalizedText("风暴之锤列表", "Storm Bolt List"),
        key = "StormBoltList",
        default = false,
        tooltip = Tool:getLocalizedText("风暴之锤列表", "Storm Bolt List"),
        onClick = function(self, value)
            TZList:createList("StormBoltList")
        end
    })
    :Slider({
        text = Aurora.Icon.FENGBAOZHICHUI .. " " .. Tool:getLocalizedText("控断百分比", "casting Percentage"),
        key = "castingPercentage",
        default = 30,
        min = 10,
        max = 90,
        step = 10,
        tooltip = Tool:getLocalizedText("设置风暴之锤控断百分比", "Set the casting Percentage for Storm Bolt"), 
        onChange = function(self, value)
            Aurora.InterfaceItem.boltCastingPercentage = value
        end
    })
    :Header({ text = Aurora.Icon.ZHENDANGBO .. " " .. Tool:getLocalizedText("震荡波列表", "shockwave") })
    :Checkbox({
        text = Aurora.Icon.ZHENDANGBO .. " " .. Tool:getLocalizedText("开启震荡波", "Enable Shockwave"),
        key = "enableShockwave",
        default = true,
        tooltip = Tool:getLocalizedText("启用震荡波", "Enable Shockwave"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableShockwave = value
        end
    })
    :Button({
        text = Aurora.Icon.ZHENDANGBO .. " " .. Tool:getLocalizedText("震荡波列表", "Shockwave List"),
        key = "shockwaveList",
        default = false,
        tooltip = Tool:getLocalizedText("震荡波列表", "Shockwave List"),
        onClick = function(self, value)
            TZList:createList("shockwaveList")
        end
    })
    :Slider({
        text = Aurora.Icon.ZHENDANGBO .. " " .. Tool:getLocalizedText("控断百分比", "casting Percentage"),
        key = "shockwaveCastingPercentage",
        default = 30,
        min = 10,
        max = 90,
        step = 10,
        tooltip = Tool:getLocalizedText("设置震荡波控断百分比", "Set the casting Percentage for Shockwave"), 
        onChange = function(self, value)
            Aurora.InterfaceItem.shockwaveCastingPercentage = value
        end
    })
    :Header({ text = Aurora.Icon.PODANNUHOU .. " " .. Tool:getLocalizedText("破胆怒吼", "intimidating shout") })
    :Checkbox({
        text = Aurora.Icon.PODANNUHOU .. " " .. Tool:getLocalizedText("开启破胆怒吼", "Enable Intimidating Shout"),
        key = "enableIntimidatingShout",
        default = true,
        tooltip = Tool:getLocalizedText("启用破胆怒吼", "Enable Intimidating Shout"),
        onChange = function(self, value)
            Aurora.InterfaceItem.enableIntimidatingShout = value
        end
    })
    :Button({
        text = Aurora.Icon.PODANNUHOU .. " " .. Tool:getLocalizedText("破胆怒吼列表", "Intimidating Shout List"),
        key = "intimidatingShoutList",
        default = false,
        tooltip = Tool:getLocalizedText("破胆怒吼列表", "Intimidating Shout List"),
        onClick = function(self, value)
            TZList:createList("intimidatingShoutList")
        end
    })
    :Slider({
        text = Aurora.Icon.PODANNUHOU .. " " .. Tool:getLocalizedText("控断百分比", "casting Percentage"),
        key = "intimidatingShoutCastingPercentage",
        default = 30,
        min = 10,
        max = 90,
        step = 10,
        tooltip = Tool:getLocalizedText("设置破胆怒吼控断百分比", "Set the casting Percentage for Intimidating Shout"), 
        onChange = function(self, value)
            Aurora.InterfaceItem.intimidatingShoutCastingPercentage = value
        end
    })
    :Tab(Tool:getLocalizedText("打断", "Interrupt"))
    :Dropdown({
        text = Aurora.Icon.QUANJI .. " " .. Tool:getLocalizedText("打断目标", "Interrupt Target"),
        key = "interruptstat",
        options = {
            { text = Tool:getLocalizedText("所有", "All"), value = "all" },
            { text = Tool:getLocalizedText("黑名单", "Blacklist"), value = "blacklist" },
            { text = Tool:getLocalizedText("白名单", "Whitelist"), value = "whitelist" }
        },
        default = "all",
        multi = false,           -- Set to true for multi-select
        width = 200,            -- Optional
        tooltip = Tool:getLocalizedText("打断目标", "Interrupt Target"), -- Optional tooltip
        onChange = function(self, value)
            Aurora.InterfaceItem.interruptstat = value
        end
    })

    :Button({
        text = Tool:getLocalizedText("打断黑名单", "Interrupt Blacklist"),
        width = 120,      -- Optional
        height = 25,      -- Optional
        tooltip = Tool:getLocalizedText("打断黑名单", "Interrupt Blacklist"), -- Optional tooltip
        key = "interruptSpellsblacklist",
        onClick = function() 
            -- print("clicked") 
            TZList:createList("interruptSpellsblacklist")
        end
    })
    :Spacer() 
    :Button({
        text = Tool:getLocalizedText("打断白名单", "Interrupt Whitelist"),
        width = 120,      -- Optional
        height = 25,      -- Optional
        tooltip = Tool:getLocalizedText("打断白名单", "Interrupt Whitelist"), -- Optional tooltip
        key = "interruptSpellswhitelist",
        onClick = function() 
            -- print("clicked") 
            TZList:createList("interruptSpellswhitelist")
        end
    })
    :Slider({
        text = Tool:getLocalizedText("打断阈值", "Interrupt Threshold"),
        key = "interruptthreshold",
        min = 10,
        max = 90,
        step = 1,
        default = 50,
        tooltip = Tool:getLocalizedText("打断阈值", "Interrupt Threshold"), -- Optional tooltip
        onChange = function(self, value)
            Aurora.InterfaceItem.interruptthreshold = value
        end
    })
    :Tab(Tool:getLocalizedText("绘制", "Draw"))
    :Checkbox({
        text = Tool:getLocalizedText("开启绘画", "Enable Drawing"),
        key = "feature.draw",  -- Config key for saving
        default = true,          -- Default value
        tooltip = Tool:getLocalizedText("开启绘画", "Enable Drawing"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            Aurora.InterfaceItem.isdraw = checked
        end
    })
    :Header({ text = Tool:getLocalizedText("绘制设置", "Draw Settings") })
    :Checkbox({
        text = Tool:getLocalizedText("只在战斗中绘制", "Only Draw in Combat"),
        key = "onlyincombat",  -- Config key for saving
        default = false,          -- Default value
        tooltip = Tool:getLocalizedText("只在战斗中绘制", "Only Draw in Combat"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            Aurora.InterfaceItem.onlyincombat = checked
        end
    })
    :Slider({
        text = Tool:getLocalizedText("绘制线宽度", "Draw Line Width"),
        key = "drawLineWidth",
        min = 1,
        max = 5,
        default = 2,
        tooltip = Tool:getLocalizedText("绘制线宽度", "Draw Line Width"), -- Optional tooltip
        onChange = function(self, value)
            -- print("使用生命药水阈值:", value)
            Aurora.InterfaceItem.drawLineWidth = value
        end
    })
    :Header({ text = Tool:getLocalizedText("绘制函数", "Draw Function") })
    :Checkbox({
        text = Tool:getLocalizedText("玩家面向和是否丢失平砍", "Player facing and whether lost autoAttack"),
        key = "drawFace",  -- Config key for saving
        default = false,          -- Default value
        tooltip = Tool:getLocalizedText("玩家面向和是否丢失平砍", "Player facing and whether lost autoAttack"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            Aurora.InterfaceItem.drawFace = checked
        end
    })
    :Checkbox({
        text = Tool:getLocalizedText("玩家和目标连线", "Draw Connection between player and target"),
        key = "drawConnection",  -- Config key for saving
        default = true,          -- Default value
        tooltip = Tool:getLocalizedText("玩家和目标连线", "Draw Connection between player and target"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            Aurora.InterfaceItem.drawConnection = checked
        end
    })



function Aurora:OnInterfaceLoad()
    -- print("Aurora:OnInterfaceLoad")
    local refreshSpellReflectionListString = Aurora.Config:Read("refreshSpellReflectionList")
    if refreshSpellReflectionListString then
        Aurora.spellReflectionSpellsList = {}
        for item in string.gmatch(refreshSpellReflectionListString, "([^;]+)") do
            table.insert(Aurora.spellReflectionSpellsList, item)
        end
    else
        
        local dataString = table.concat(Aurora.spellReflectionSpellsList, ";")
        -- print("refreshSpellReflectionListString is nil",dataString)
        Aurora.Config:Write("refreshSpellReflectionList", dataString)
    end

    local StormBoltListString = Aurora.Config:Read("StormBoltList")
    if StormBoltListString then
        Aurora.StormBoltSpellsList = {}
        for item in string.gmatch(StormBoltListString, "([^;]+)") do
            table.insert(Aurora.StormBoltSpellsList, item)
        end
    else
        local dataString = table.concat(Aurora.StormBoltSpellsList, ";")
        Aurora.Config:Write("StormBoltList", dataString)
    end

    local shockwaveListString = Aurora.Config:Read("shockwaveList")
    if shockwaveListString then
        Aurora.shockwaveSpellsList = {}
        for item in string.gmatch(shockwaveListString, "([^;]+)") do
            table.insert(Aurora.shockwaveSpellsList, item)
        end
    else
        local dataString = table.concat(Aurora.shockwaveSpellsList, ";")
        Aurora.Config:Write("shockwaveList", dataString)
    end
    local intimidatingShoutListString = Aurora.Config:Read("intimidatingShoutList")
    if intimidatingShoutListString then
        Aurora.intimidatingShoutSpellsList = {}
        for item in string.gmatch(intimidatingShoutListString, "([^;]+)") do
            table.insert(Aurora.intimidatingShoutSpellsList, item)
        end
    else
        local dataString = table.concat(Aurora.intimidatingShoutSpellsList, ";")
        Aurora.Config:Write("intimidatingShoutList", dataString)
    end
    local interruptSpellswhitelistString = Aurora.Config:Read("interruptSpellswhitelist")
    if interruptSpellswhitelistString then
        Aurora.interruptSpellswhitelist = {}
        for item in string.gmatch(interruptSpellswhitelistString, "([^;]+)") do
            table.insert(Aurora.interruptSpellswhitelist, item)
        end
    else
        local dataString = table.concat(Aurora.interruptSpellswhitelist, ";")
        Aurora.Config:Write("interruptSpellswhitelist", dataString)
    end
    local interruptSpellsblacklistString = Aurora.Config:Read("interruptSpellsblacklist")
    if interruptSpellsblacklistString then
        Aurora.interruptSpellsblacklist = {}
        for item in string.gmatch(interruptSpellsblacklistString, "([^;]+)") do
            table.insert(Aurora.interruptSpellsblacklist, item)
        end
    else
        local dataString = table.concat(Aurora.interruptSpellsblacklist, ";")
        Aurora.Config:Write("interruptSpellsblacklist", dataString)
    end



    Aurora.InterfaceItem.mouseoverCR = Aurora.Config:Read("battleResurrection.enabled") 
    Aurora.InterfaceItem.explosivePotionBindingBKB = Aurora.Config:Read("explosivePotionBindingBKB.enabled")
    Aurora.InterfaceItem.trinket1Enabled = Aurora.Config:Read("trinket1.enabled") 
    Aurora.InterfaceItem.trinket2Enabled = Aurora.Config:Read("trinket2.enabled")
    Aurora.InterfaceItem.trinket1Binding = Aurora.Config:Read("trinket1.binding") 
    Aurora.InterfaceItem.trinket2Binding = Aurora.Config:Read("trinket2.binding") 
    Aurora.InterfaceItem.recoveryPotionThreshold = Aurora.Config:Read("recoveryPotionThreshold") 
    Aurora.InterfaceItem.bkbTTD = Aurora.Config:Read("bkbTTD") 
    Aurora.InterfaceItem.roughTTD = Aurora.Config:Read("roughTTD") 
    Aurora.InterfaceItem.swordSlamTTD = Aurora.Config:Read("swordSlamTTD")
    Aurora.InterfaceItem.impendingVictoryThreshold = Aurora.Config:Read("impendingVictoryThreshold") 
    Aurora.InterfaceItem.enableRagingRecovery = Aurora.Config:Read("enableRagingRecovery") 
    Aurora.InterfaceItem.enableSpellReflection = Aurora.Config:Read("enableSpellReflection") 
    Aurora.InterfaceItem.RagingRecoveryThreshold = Aurora.Config:Read("RagingRecoveryThreshold") 
    Aurora.InterfaceItem.enableHealthDefense = Aurora.Config:Read("enableHealthDefense") 
    Aurora.InterfaceItem.enableImpendingVictory = Aurora.Config:Read("enableImpendingVictory") 
    Aurora.InterfaceItem.boltCastingPercentage = Aurora.Config:Read("boltCastingPercentage")
    Aurora.InterfaceItem.enableStormBolt = Aurora.Config:Read("enableStormBolt") 
    Aurora.InterfaceItem.enableShockwave = Aurora.Config:Read("enableShockwave") 
    Aurora.InterfaceItem.shockwaveCastingPercentage = Aurora.Config:Read("shockwaveCastingPercentage") 
    Aurora.InterfaceItem.enableIntimidatingShout = Aurora.Config:Read("enableIntimidatingShout") 
    Aurora.InterfaceItem.intimidatingShoutCastingPercentage = Aurora.Config:Read("intimidatingShoutCastingPercentage") 
    Aurora.InterfaceItem.interruptstat = Aurora.Config:Read("interruptstat") 
    Aurora.InterfaceItem.interruptthreshold = Aurora.Config:Read("interruptthreshold") 
    Aurora.InterfaceItem.drawFace = Aurora.Config:Read("drawFace") 
    Aurora.InterfaceItem.drawConnection = Aurora.Config:Read("drawConnection") 
    Aurora.InterfaceItem.drawLineWidth = Aurora.Config:Read("drawLineWidth") 
    Aurora.InterfaceItem.onlyincombat = Aurora.Config:Read("onlyincombat") 
    Aurora.InterfaceItem.isdraw = Aurora.Config:Read("feature.draw") 
    Aurora.InterfaceItem.autoRaceSpells = Aurora.Config:Read("autoRaceSpells") 
    Aurora.InterfaceItem.enableLucky = Aurora.Config:Read("enableLucky") 
end

Aurora:OnInterfaceLoad()
end