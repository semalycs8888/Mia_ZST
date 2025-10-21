-- -*- coding: utf-8 -*-
Mia_Warrior = Mia_Warrior or {}

local NewSpell = Aurora.SpellHandler.NewSpell
local Macro = Aurora.Macro
-- 初始化TZList模块
if not Aurora.TZList then
    require "tzList"
end
local TZList = Aurora.TZList or {}
if not Aurora.UpdateAlert then
    require "UpdateAlert"
end
local UpdateAlert = Aurora.UpdateAlert or {}

if not Aurora.Tool then
    require "Tool"
end
local Tool = Aurora.Tool or {}

-- 获取客户端语言
local clientLocale = GetLocale() or "enUS" -- 设置默认值以防获取失败
local isChineseClient = clientLocale == "zhCN" or clientLocale == "zhTW"

-- 多语言文本获取函数
local function getLocalizedText(zhText, enText)
    return isChineseClient and zhText or enText
end

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
        POHUAIZHE = NewSpell(228920),
        --[援护]3411
        YUANHU = NewSpell(3411),
        BENGCUI = NewSpell(436358),
        REMIXNIUQU = NewSpell(1237711),
        REMIXSHENLIN = NewSpell(1233577),
        REMIXYUANPAN = NewSpell(1233775),
        REMIXFENGBAO = NewSpell(1233181),
        REMIXSHENPAN = NewSpell(1251045),
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
--自动嘲讽
local isChaofeng = false
--大技能开关
local iscds = false
--用户设置战斗时长阈值
local iscdsTime = 20

local mouseoverfuhuo = true
local baofayao = true
local shengmingyao = true
local shengmingyaoyuzhi = 20
local isuseTrinket = true
local isuseTrinket2 = true
local isuseTrinket1 = true
local trinket1state = "revenge"
local trinket2state = "revenge"
local useTrinkethp = 50
local isFbaoSp = true
--用户设置血量阈值
local healthDq = 20
local healthPf = 20
local fbzccontrol = true
local zdbcontrol = true
local pdcontrol = true
local autoyuanhu = true
--打断目标
local interruptstat = "all"
--打断阈值
local interruptthreshold = 50

local drawFace = true
-- local drawNotFacing = false
local drawConnection = true
local isdraw = true
local onlyincombat = true
local drawLineWidth = 2
local farDistance = false
local isguaji = false
local autoRemixYuanPan = false
local autoRemixShenPan = false
local autoRemixFengBao = false
local autoRemixShenLin = false
local autoRemixNiuQu = false
-- 将respondSpells添加到Aurora全局表，使其可以在其他文件中访问
Aurora.respondSpells = Aurora.respondSpells or {
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

Aurora.interruptSpellsblacklist = {
    326450, 
    338003, 
}

Aurora.interruptSpellswhitelist = {
    1229474,446657,221130,354297,427609,428086,468631,450756,434786,427357,465871,356843,323538,221483,1229510,1214780,356337,434792,357196,1248699,355641,325701,355642,452099,431303,1221532,465595,356407,1245669,353836,462771,1222815,356537,355934,424419,431309,347775,434802,424420,447439,427469,444743,350922,432520,423536,471733,1214468,338003,86813,357260,355225,352347,433841,424421,423051,326829,436322,448248,328322,431333,351119,442210,451113,326450,427356
}
Aurora.reflectionSpells = {
    1235368,--[奥术猛袭]
    1222815,--[奥术箭]
    1222341,--[幽暗之咬]

    338003,--[邪恶箭矢]
    328322,--[罪邪箭]
    323538,--[心能箭矢]
    326829,--[心能箭矢]
    323437,--[心能箭矢]
    328791,
    335338,
    335345,
    323414,
    

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
   -- 428086,

    448492,--[雷霆一击]
    427357,--[神圣惩击]
    427469,--[火球术]
    424421,--[火球术]
    448791,--[神圣鸣罪]
    435165,--[炽热打击]
    423536,--[神圣惩击]
    427470,--[神圣惩击]
    448515,--[神圣审判]
    427950,
    427951,
    
    423015,
    446649,--[隐修院 烈焰]

    469478,--[淤泥之爪]
    473351,--[电气重碾]
    465871,--[鲜血冲击]
    465666,--[火花猛击]
    466190,--[雷霆重拳]
    468631,
    1214468
}
Aurora.controlSpellsList = {
    427342,
    355640,
    353783,
    346980,
}

Aurora.interveneList = {
    462859
}
local cznhicon = Aurora.texture(1160)
local dqicon = Aurora.texture(871)
local pfczicon = Aurora.texture(12975)
local wskticon = Aurora.texture(190456)
local chysicon = Aurora.texture(212265)
local fbzcicon = Aurora.texture(107570)
local zlysicon = Aurora.texture(244839)
local zdbicon = Aurora.texture(46968)
local pdnhicon = Aurora.texture(5246)
local fsfsicon = Aurora.texture(23920)
local yuanhuicon = Aurora.texture(3411)


local function CreateSkillMacro()
    -- 先判断宏是否已满（角色宏18个，通用宏120个，这里以角色宏为例）
    local numGlobal,numPerChar = GetNumMacros()
    if numGlobal >= 109 then
        -- 抛出错误，会在聊天框显示提示
        Aurora.alert(getLocalizedText("Mia: 角色宏列表已满，无法创建新宏！", "Mia: Role macro list is full, cannot create new macro!"))
    else
        Aurora.Tool:CreateMacro(97462, "regular", false)
        Aurora.Tool:CreateMacro(6673, "regular", false)
        Aurora.Tool:CreateMacro(384318, "regular", false)
        Aurora.Tool:CreateMacro(107570, "mouseover", false)
        Aurora.Tool:CreateMacro(107570, "regular", false)
        Aurora.Tool:CreateMacro(228920, "cursor", false)
        Aurora.Tool:CreateMacro(385952, "regular", false)
        Aurora.Tool:CreateMacro(46968, "regular", false)
        Aurora.Tool:CreateMacro(57755, "mouseover", false)
        Aurora.Tool:CreateMacro(57755, "regular", false)
        Aurora.Tool:CreateMacro(1160, "regular", false)
        CreateMacro(getLocalizedText("开关", "Toggle"), "INV_Misc_QuestionMark", "/"..Aurora.Macro.baseCommand.." toggle", nil)
    end 
end

-- print(Tool:GetSpellNameByID(107574))
local gui = Aurora.GuiBuilder:New()
gui:Category("Mia_Warrior")
   :Tab(getLocalizedText("常用宏命令", "Common Macros"))
    :Button({text = getLocalizedText("生成常用宏命令", "Create Common Macros"), key = "marco", width = 100, height = 30,onClick = function() CreateSkillMacro() end})
   :Button({text = getLocalizedText("复制常用天赋字符串", "Copy Common Talent String"), key = "talent", width = 100, height = 30,onClick = function() CopyToClipboard("CkEArbixk/ZKwTdpZGVHeylmL0yAAAAwYGzMzMzMmNjZZwYMaMLjZYsMmZG2mZGzADDAAAAAAsMGAYGbAGYDWWMaMDgZJMbwMD") end})
    :Header({ text = getLocalizedText("功能开关宏(点击复制)", "Feature Toggle Macros(click to copy)") })
    :Button({text = Aurora.texture(6552)..getLocalizedText("开关自动打断", "Toggle Automatic Interruption"), key = "automaticinterruption", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." automaticinterruption") end})
    :Button({text = Aurora.texture(107574)..getLocalizedText("自动天神下凡", "auto "..Tool:GetSpellNameByID(107574)), key = "tianshenxiafan", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." bkb") end})
    :Button({text = Aurora.texture(355)..getLocalizedText("自动嘲讽", "auto "..Tool:GetSpellNameByID(355)), key = "automatictaunt", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." ridicule") end})
    :Button({text = Aurora.texture(385952)..getLocalizedText("自动盾牌冲锋", "auto "..Tool:GetSpellNameByID(385952)), key = "automatictaunt2", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." shieldcharge") end})
    :Button({text = Aurora.texture(1160)..getLocalizedText("挫志怒吼卡CD", "auto "..Tool:GetSpellNameByID(1160)), key = "autocuozhinuhou", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." shout") end})
    :Button({text = Aurora.texture(23920)..Aurora.Tool:GetSpellNameByID(23920), key = "autojingguang", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." spellreflection") end})
    :Button({text = Aurora.texture(384318)..getLocalizedText("自动雷鸣之吼", "auto "..Tool:GetSpellNameByID(384318)), key = "autoleinguohou", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." thunderousroar") end})
    :Button({text = Aurora.texture(76290)..getLocalizedText("自动选择目标", "auto select target"), key = "autoselecttarget", width = 100, height = 30,onClick = function() CopyToClipboard("/"..Aurora.Macro.baseCommand.." switchtarget") end})

    :Tab(getLocalizedText("减伤技能", "Damage Reduction Skills"))
   :Header({ text = getLocalizedText("前置减伤应对", "Pre-damage Reduction Response") })
   :Checkbox({
    text = dqicon..getLocalizedText("盾墙", "shield wall"),
    key = "feature.isDUNQIANG",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("盾墙应对", "Shield Wall Response"), -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        isDUNQIANG = not isDUNQIANG
    end
})
   :Checkbox({
    text = cznhicon..getLocalizedText("挫志怒吼", "demoralizing shout"),
    -- icon = "1160",
    key = "feature.isCUOZHINUHOU",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("挫志怒吼应对", "Demoralizing Shout Response"), -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        isCUOZHINUHOU = not isCUOZHINUHOU
    end
   })
    :Checkbox({
    text = pfczicon..getLocalizedText("破釜沉舟", "last stand"),
    key = "feature.isPOFUCHENZHOU",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("破釜沉舟应对", "Last Stand Response"), -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        isPOFUCHENZHOU = not isPOFUCHENZHOU
    end
   })
   :Button({
        text = getLocalizedText("减伤应对列表", "Damage Reduction Response List"),
        width = 120,      -- Optional
        height = 25,      -- Optional
        tooltip = getLocalizedText("减伤应对列表", "Damage Reduction Response List"), -- Optional tooltip
        key = "jianshangyingdui",
        onClick = function() 
            TZList:createList("jianshangyingdui")
        end
    })
    :Header({ text = fsfsicon..getLocalizedText("法术反射", "spell reflection") })
    :Button({
        text = getLocalizedText("法术反射应对列表", "Spell Reflection Response List"),
        width = 120,      -- Optional
        height = 25,      -- Optional
        tooltip = getLocalizedText("法术反射应对列表", "Spell Reflection Response List"), -- Optional tooltip
        key = "fashufansheyingdui",
        onClick = function() 
            TZList:createList("fashufansheyingdui")
        end
    })
   :Header({ text = wskticon..getLocalizedText("无视苦痛", "ignore pain") })
   :Dropdown({
        text = getLocalizedText("无视苦痛阈值", "ignore pain threshold"),
        key = "graphics.isIgnoringPain",
        options = {
            { text = getLocalizedText("一般", "average"), value = "average" },
            { text = getLocalizedText("中等", "moderate"), value = "moderate" },
            { text = getLocalizedText("极端", "extreme"), value = "extreme" }
        },
        default = "average",
        multi = false,           -- Set to true for multi-select
        width = 200,            -- Optional
        tooltip = getLocalizedText("无视苦痛吸收量", "ignore pain threshold"), -- Optional tooltip
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
     :Header({ text = getLocalizedText("剩余战斗时长", "Combat Duration Threshold") })
    :Slider({
        text = getLocalizedText("剩余战斗时长", "Remaining Combat Duration"),
        key = "graphics.viewDistance",
        min = 10,
        max = 60,
        default = 20,
        tooltip = getLocalizedText("战斗时长低于设置秒数,不开启爆发", "Combat Duration Threshold"), -- Optional tooltip
        onChange = function(self, value)
            -- print("战斗时长低于设置秒数,不开启:", value)
            iscdsTime = value
        end
   })
   :Header({ text = getLocalizedText("血量阈值", "Health Threshold") })
   :Slider({
        text = dqicon..getLocalizedText("盾墙血量阈值", "Shield Wall Health Threshold"),
        key = "graphics.healthDq",
        min = 0,
        max = 90,
        default = 40,
        tooltip = getLocalizedText("盾墙血量阈值", "Shield Wall Health Threshold"), -- Optional tooltip
        onChange = function(self, value)
            -- print("战斗时长低于设置秒数,不开启:", value)
            healthDq = value
        end
   })
   :Slider({
        text = pfczicon..getLocalizedText("破釜沉舟血量阈值", "Last Stand Health Threshold"),
        key = "graphics.healthPf",
        min = 0,
        max = 90,
        default = 20,
        tooltip = getLocalizedText("破釜沉舟血量阈值", "Last Stand Health Threshold"), -- Optional tooltip
        onChange = function(self, value)
            -- print("战斗时长低于设置秒数,不开启:", value)
            healthPf = value
        end
   })

   :Tab(getLocalizedText("物品", "Items"))
    :Checkbox({
    text = getLocalizedText("鼠标指向战复", "CR (mouseover)"),
    key = "feature.mouseoverfuhuo",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("开启后,指向会自动使用道具战复,只支持3星电缆", "Enable to use items on mouseover, only supports 3-star cables"), -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        mouseoverfuhuo = not mouseoverfuhuo
    end
   })
    :Checkbox({
    text = getLocalizedText("淬火药水绑定复仇", "Bind Avenging Wrath to Flasks of the Blazing Prowess"),
    key = "feature.baofayao",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("开启后会自动使用爆发药，需要有[淬火药水]", "Enable to use flasks of the blazing prowess, requires [quenched potion]"), -- Optional tooltip
    onChange = function(self, checked)
        -- print("Checkbox changed:", checked)
        baofayao = not baofayao
    end
   })
    :Header({ text = getLocalizedText("饰品", "Trinket") })
    :Checkbox({
    text = getLocalizedText("使用饰品", "Use Trinket"),
    key = "feature.useTrinket",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("是否使用饰品", "Enable to use trinket"), -- Optional tooltip
    onChange = function(self, checked)
        isuseTrinket = checked
    end
    })
    :Header({ text = " " })
    :Checkbox({
    text = getLocalizedText("使用饰品1", "Use Trinket 1"),
    key = "feature.useTrinket1",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("是否使用饰品1", "Enable to use trinket 1"), -- Optional tooltip
    onChange = function(self, checked)
        isuseTrinket1 = checked
    end
    })
    :Dropdown({
        text = getLocalizedText("饰品1", "Trinket 1"),
        key = "feature.trinket1",
        options = {
            { text = getLocalizedText("天神下凡", "BKB"), value = "revenge" },
            { text = getLocalizedText("低血量", "Low HP"), value = "lowhp" },
            { text = getLocalizedText("前置减伤", "Counter Ability"), value = "counterAbility" }
        },
        default = "revenge",
        multi = false,           -- Set to true for multi-select
        width = 200,            -- Optional
        tooltip = getLocalizedText("选择饰品1", "Select trinket 1"),
        onChange = function(self, value)
            -- print("trinket 1 changed:", value)
            trinket1state = value
        end
    })
    :Checkbox({
    text = getLocalizedText("使用饰品2", "Use Trinket 2"),
    key = "feature.useTrinket2",  -- Config key for saving
    default = true,          -- Default value
    tooltip = getLocalizedText("是否使用饰品2", "Enable to use trinket 2"), -- Optional tooltip
    onChange = function(self, checked)
        isuseTrinket2 = checked
    end
    })
    :Dropdown({
        text = getLocalizedText("饰品2", "Trinket 2"),
        key = "feature.trinket2",
        options = {
            { text = getLocalizedText("天神下凡", "BKB"), value = "revenge" },
            { text = getLocalizedText("低血量", "Low HP"), value = "lowhp" },
            { text = getLocalizedText("前置减伤", "Counter Ability"), value = "counterAbility" }
        },
        default = "revenge",
        multi = false,           -- Set to true for multi-select
        width = 200,            -- Optional
        tooltip = getLocalizedText("选择饰品2", "Select trinket 2"),
        onChange = function(self, value)
            -- print("trinket 2 changed:", value)
            trinket2state = value
        end
    })

    :Slider({
    text = getLocalizedText("使用饰品血量阈值", "Trinket Health Threshold"),
    key = "feature.trinketHP",  -- Config key for saving
    default = 50,          -- Default value
    tooltip = getLocalizedText("低于设定血量使用饰品", "Use trinket when the health value is lower than the set value"), -- Optional tooltip
    onChange = function(self, value)
        useTrinkethp = value
    end
    })
    :Header({ text = Aurora.texture(244021).. " " .. getLocalizedText("焕生治疗药水", "Resurgent Healing Potion") })
   :Slider({
        text = getLocalizedText("焕生治疗药水血量阈值", "Resurgent Healing Potion Health Threshold"),
        key = "feature.shengmingyaoyuzhi",
        min = 10,
        max = 100,
        default = 30,
        tooltip = "低于设定血量使用生命药水",
        onChange = function(self, value)
            -- print("使用生命药水阈值:", value)
            shengmingyaoyuzhi = value
        end
   })
   :Tab(getLocalizedText("控制技能", "Control Spells"))
    :Checkbox({
        text = fbzcicon..getLocalizedText("风暴之锤", "Storm Bolt"),
        key = "feature.fbzccontrol",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("风暴之锤", "Storm Bolt"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            fbzccontrol = not fbzccontrol
        end
    })
  
    :Checkbox({
        text = zdbicon..getLocalizedText("震荡波", "Shockwave"),
        key = "feature.zdbcontrol",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("震荡波", "Shockwave"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            zdbcontrol = not zdbcontrol
        end
    })
    :Checkbox({
        text = pdnhicon..getLocalizedText("破胆怒吼", "Intimidating Shout"),
        key = "feature.pdcontrol",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("破胆怒吼", "Intimidating Shout"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            pdcontrol = not pdcontrol
        end
    })
    :Button({
        text = getLocalizedText("控制技能应对列表", "Control Spells Countermeasures List"),
        key = "controlSpellsList",  -- Config key for saving
        -- default = true,          -- Default value
        tooltip = getLocalizedText("控制技能应对列表", "Control Spells Countermeasures List"), -- Optional tooltip
        onClick = function(self, checked)
           TZList:createList("controlSpellsList")
        end
    })
    :Header({ text = getLocalizedText("风暴之锤打断回响哨兵，天街打开牢笼，水闸装弹", "Special Response for Storm Bolt") })
    :Checkbox({
        text = fbzcicon..getLocalizedText("风暴之锤", "Storm Bolt"),
        key = "feature.isFbaoSp",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("风暴之锤", "Storm Bolt"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            isFbaoSp = not isFbaoSp
        end
   })
:Tab(getLocalizedText("打断", "Interrupt"))
:Dropdown({
    text = getLocalizedText("打断目标", "Interrupt Target"),
    key = "interruptstat",
    options = {
        { text = getLocalizedText("所有", "All"), value = "all" },
        { text = getLocalizedText("黑名单", "Blacklist"), value = "blacklist" },
        { text = getLocalizedText("白名单", "Whitelist"), value = "whitelist" }
    },
    default = "all",
    multi = false,           -- Set to true for multi-select
    width = 200,            -- Optional
    tooltip = getLocalizedText("打断目标", "Interrupt Target"), -- Optional tooltip
    onChange = function(self, value)
        interruptstat = value
    end
})

:Button({
    text = getLocalizedText("打断黑名单", "Interrupt Blacklist"),
    width = 120,      -- Optional
    height = 25,      -- Optional
    tooltip = getLocalizedText("打断黑名单", "Interrupt Blacklist"), -- Optional tooltip
    key = "interruptSpellsblacklist",
    onClick = function() 
        -- print("clicked") 
        TZList:createList("interruptSpellsblacklist")
    end
})
:Spacer() 
:Button({
    text = getLocalizedText("打断白名单", "Interrupt Whitelist"),
    width = 120,      -- Optional
    height = 25,      -- Optional
    tooltip = getLocalizedText("打断白名单", "Interrupt Whitelist"), -- Optional tooltip
    key = "interruptSpellswhitelist",
    onClick = function() 
        -- print("clicked") 
        TZList:createList("interruptSpellswhitelist")
    end
})
:Slider({
    text = getLocalizedText("打断阈值", "Interrupt Threshold"),
    key = "feature.interruptthreshold",
    min = 10,
    max = 90,
    step = 1,
    default = 50,
    tooltip = getLocalizedText("打断阈值", "Interrupt Threshold"), -- Optional tooltip
    onChange = function(self, value)
        interruptthreshold = value
    end
})
:Tab(getLocalizedText("绘制", "Draw"))
    :Checkbox({
        text = getLocalizedText("开启绘画", "Enable Drawing"),
        key = "feature.draw",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("开启绘画", "Enable Drawing"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            isdraw = checked
        end
    })
    :Header({ text = getLocalizedText("绘制设置", "Draw Settings") })
    :Checkbox({
        text = getLocalizedText("只在战斗中绘制", "Only Draw in Combat"),
        key = "feature.onlyincombat",  -- Config key for saving
        default = false,          -- Default value
        tooltip = getLocalizedText("只在战斗中绘制", "Only Draw in Combat"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            onlyincombat = checked
        end
    })
    :Slider({
        text = getLocalizedText("绘制线宽度", "Draw Line Width"),
        key = "feature.drawLineWidth",
        min = 1,
        max = 5,
        default = 2,
        tooltip = getLocalizedText("绘制线宽度", "Draw Line Width"), -- Optional tooltip
        onChange = function(self, value)
            -- print("使用生命药水阈值:", value)
            drawLineWidth = value
        end
    })
    :Header({ text = getLocalizedText("绘制函数", "Draw Function") })
    :Checkbox({
        text = getLocalizedText("玩家面向和是否丢失平砍", "Player facing and whether lost autoAttack"),
        key = "feature.autoAttack",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("玩家面向和是否丢失平砍", "Player facing and whether lost autoAttack"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            drawFace = checked
        end
    })
    :Checkbox({
        text = getLocalizedText("玩家和目标连线", "Draw Connection between player and target"),
        key = "feature.Connection",  -- Config key for saving
        default = true,          -- Default value
        tooltip = getLocalizedText("玩家和目标连线", "Draw Connection between player and target"), -- Optional tooltip
        onChange = function(self, checked)
            -- print("Checkbox changed:", checked)
            drawConnection = checked
        end
    })

   local function InitConfig()
    local jslb = Aurora.Config:Read("jianshangyingdui")
    if jslb then
        -- print("减伤应对列表:", jslb)
        Aurora.respondSpells = {}
        for item in string.gmatch(jslb, "([^;]+)") do
            table.insert(Aurora.respondSpells, item)
        end
    else
        -- print("未创建列表")
        local dataString = table.concat(Aurora.respondSpells, ";")
        Aurora.Config:Write("jianshangyingdui", dataString)
    end
    -- 法术反射应对列表
    local fsfslb = Aurora.Config:Read("fashufansheyingdui")
    if fsfslb then
        -- print("法术反射应对列表:", fsfslb)
        Aurora.reflectionSpells = {}
        for item in string.gmatch(fsfslb, "([^;]+)") do
            table.insert(Aurora.reflectionSpells, tonumber(item))
        end
    else
        -- print("未创建列表")
        local dataString = table.concat(Aurora.reflectionSpells, ";")
        Aurora.Config:Write("fashufansheyingdui", dataString)
    end

    -- 控制技能应对列表
    local cslString = Aurora.Config:Read("controlSpellsList")
    if cslString then
        -- print("控制技能应对列表:", controlSpellsList)
        Aurora.controlSpellsList = {}
        for item in string.gmatch(cslString, "([^;]+)") do
            table.insert(Aurora.controlSpellsList, item)
        end
    else
        -- print("未创建列表")
        local dataString = table.concat(Aurora.controlSpellsList, ";")
        Aurora.Config:Write("controlSpellsList", dataString)
    end
    --援护list
    -- local yuanhuString = Aurora.Config:Read("interveneList")
    -- if yuanhuString then
    --     -- print("援护应对列表:", controlSpellsList)
    --     Aurora.interveneList = {}
    --     for item in string.gmatch(yuanhuString, "([^;]+)") do
    --         table.insert(Aurora.interveneList, item)
    --     end
    -- else
    --     -- print("未创建列表")
    --     local dataString = table.concat(Aurora.interveneList, ";")
    --     Aurora.Config:Write("interveneList", dataString)
    -- end
    local interruptSpellsblackliststring = Aurora.Config:Read("interruptSpellsblacklist")
        if interruptSpellsblackliststring then
            -- print("控制应对列表:", farfromgroup)
            Aurora.interruptSpellsblacklist = {}
            for item in string.gmatch(interruptSpellsblackliststring, "([^;]+)") do
                table.insert(Aurora.interruptSpellsblacklist, tonumber(item))
            end
        else
            -- print("未创建列表")
            local dataString = table.concat(Aurora.interruptSpellsblacklist, ";")
            Aurora.Config:Write("interruptSpellsblacklist", dataString)
        end

        local interruptSpellswhiteliststring = Aurora.Config:Read("interruptSpellswhitelist")
        if interruptSpellswhiteliststring then
            -- print("控制应对列表:", farfromgroup)
            Aurora.interruptSpellswhitelist = {}
            for item in string.gmatch(interruptSpellswhiteliststring, "([^;]+)") do
                table.insert(Aurora.interruptSpellswhitelist, item)
            end
        else
            -- print("未创建列表")
            local dataString = table.concat(Aurora.interruptSpellswhitelist, ";")
            Aurora.Config:Write("interruptSpellswhitelist", dataString)
        end


    --用户设置血量阈值
    healthDq = Aurora.Config:Read("graphics.healthDq")
    healthPf = Aurora.Config:Read("graphics.healthPf")
    isFbaoSp = Aurora.Config:Read("feature.isFbaoSp")
    shengmingyaoyuzhi = Aurora.Config:Read("feature.shengmingyaoyuzhi")
    mouseoverfuhuo = Aurora.Config:Read("feature.mouseoverfuhuo")
    baofayao = Aurora.Config:Read("feature.baofayao")
    iscdsTime = Aurora.Config:Read("graphics.viewDistance")
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
    isuseTrinket = Aurora.Config:Read("feature.useTrinket")
    useTrinkethp = Aurora.Config:Read("feature.trinketHP")
    fbzccontrol = Aurora.Config:Read("feature.fbzccontrol")
    zdbcontrol = Aurora.Config:Read("feature.zdbcontrol")
    pdcontrol = Aurora.Config:Read("feature.pdcontrol")
    -- autoyuanhu = Aurora.Config:Read("feature.autoyuanhu")
    interruptstat = Aurora.Config:Read("interruptstat")
    interruptthreshold = Aurora.Config:Read("feature.interruptthreshold")
    isdraw = Aurora.Config:Read("feature.draw")
    drawConnection = Aurora.Config:Read("feature.Connection")
    drawFace = Aurora.Config:Read("feature.autoAttack")
    onlyincombat = Aurora.Config:Read("feature.onlyincombat")
    drawLineWidth = Aurora.Config:Read("feature.drawLineWidth")
    isuseTrinket2 = Aurora.Config:Read("feature.useTrinket2")
    isuseTrinket1 = Aurora.Config:Read("feature.useTrinket1")
    trinket1state = Aurora.Config:Read("feature.trinket1")
    trinket2state = Aurora.Config:Read("feature.trinket2")
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
-- local weaponEnhancement = Aurora.ItemHandler.NewItem(224107)
local fuwen = Aurora.ItemHandler.NewItem(243191)
-- local baofayaopostion = Aurora.ItemHandler.NewItem(212265)

local isLT = true
local autopohuaizhe = false
local autoyongshizhimao = false
local autoBenGCui = false



 --应对减伤



local reflectionSpellsAny = {
    427950,--[隐修院 烈焰]
    323414,
    423015,
    446649,
    427951,
    1235368,
    328791,
    335338,
    335345
}

local fbaoSpells = {
    461796,
    347721,
    432967
}

local function draw()

    local Draw = Aurora.Draw
-- Register a drawing callback
    -- Draw:SetWidth(drawLineWidth)
    Draw:RegisterCallback("myDrawing", function(canvas, unit)
        -- Drawing code here
        -- print(unit)
        canvas:SetWidth(drawLineWidth)
        if not isdraw then return end
        if onlyincombat and not player.combat then return end
        local target = Aurora.UnitManager:Get("target")
        if unit.name == player.name and target.exists then
            local r, g, b, a 
            
            if player.distanceto(target) <= 4.4 and target.playerfacing180 then
                 r, g, b, a = Draw:GetColor("Green", 150)
            else
                r, g, b, a = Draw:GetColor("Red", 150)
            end
            canvas:SetColor(r, g, b, a)
            -- canvas:Circle(unit.position.x, unit.position.y, unit.position.z,5.4)
            if drawFace then
                canvas:Arc(unit.position.x, unit.position.y, unit.position.z,5.4,180,player.rotation)
            end
            if drawConnection then
                canvas:LineRaw(unit.position.x, unit.position.y, unit.position.z,target.position.x, target.position.y, target.position.z)
            end
        end
        
        
    end, "units")
end

--使用饰品
local function isuseTinketabletoJS()
    local target = Aurora.UnitManager:Get("target")
    if player.aura(871) or player.aura(12975) or (target.exists and target.aura(1160)) then
        return false
    end

    if isDUNQIANG then
        if spellbooks.spells.DUNQIANG:ready() then
            return false
        end
    end
    if isCUOZHINUHOU then
        if spellbooks.spells.CUOZHINUHOU:getcd() == 0 then
            return false
        end
    end
    if isPOFUCHENZHOU then
        if spellbooks.spells.POFUCHENZHOU:ready() then
            return false
        end
    end
    return true
end
--使用饰品
local function useTrinket()
    local trinket1ID = GetInventoryItemID("player",13)
    local trinket2ID = GetInventoryItemID("player",14)
    local trinket1 = Aurora.ItemHandler.NewItem(trinket1ID)
    local trinket2 = Aurora.ItemHandler.NewItem(trinket2ID)
    target = Aurora.UnitManager:Get("target")
    if  isuseTrinket1 then
        if trinket1:ready() then
            if trinket1state == "revenge" then
                if player.aura(107574) then
                    if trinket1:usable(player) and trinket1:ready() then
                        return trinket1:use(player)
                    elseif trinket1:usable(target) and trinket1:ready() then
                        return trinket1:use(target)
                    end
                end
            elseif trinket1state == "lowhp" then
                if player.hp < useTrinkethp then
                    if trinket1:usable(player) and trinket1:ready() then
                        return trinket1:use(player)
                    elseif trinket1:usable(target) and trinket1:ready() then
                        return trinket1:use(target)
                    end
                end
            elseif trinket1state == "counterAbility" then
                if isuseTinketabletoJS() then
                      local activeenemies = Aurora.activeenemies
                        if activeenemies then
                            activeenemies:each(function(enemy, index, uptime)
                                local enemyCastingId = enemy.castingspellid
                                if enemyCastingId then
                                    -- print("正在施法",enemyCastingId)
                                    for k, v in pairs(Aurora.respondSpells) do
                                        if tonumber(v) == enemyCastingId then
                                            if trinket1:usable(player) and trinket1:ready() then
                                                return trinket1:use(player)
                                            elseif trinket1:usable(target) and trinket1:ready() then
                                                return trinket1:use(target)
                                                -- return true
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
        if isuseTrinket2 then
        if trinket2:ready() then
            if trinket2state == "revenge" then
                if player.aura(107574) then
                    if trinket2:usable(player) and trinket2:ready() then
                        return trinket2:use(player)
                    elseif trinket2:usable(target) and trinket2:ready() then
                        return trinket2:use(target)
                    end
                end
            elseif trinket2state == "lowhp" then
                -- print(player.hp,useTrinkethp)
                if player.hp < useTrinkethp then
                    -- print("使用饰品2",trinket2:usable(player),trinket2:ready())
                    if trinket2:usable(player) and trinket2:ready() then

                        return trinket2:use(player)
                    elseif trinket2:usable(target) and trinket2:ready() then
                        return trinket2:use(target)
                    end
                end
            elseif trinket2state == "counterAbility" then
                if isuseTinketabletoJS() then
                    
                      local activeenemies = Aurora.activeenemies
                        if activeenemies then
                            activeenemies:each(function(enemy, index, uptime)
                                local enemyCastingId = enemy.castingspellid
                                if enemyCastingId then
                                    -- print("正在施法",enemyCastingId)
                                    for k, v in pairs(Aurora.respondSpells) do
                                        if tonumber(v) == enemyCastingId then
                                            if trinket2:usable(player) and trinket2:ready() then
                                                return trinket2:use(player)
                                            elseif trinket2:usable(target) and trinket2:ready() then
                                                return trinket2:use(target)
                                                -- return true
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
    
local function controlexec(spell)
     local activeenemies = Aurora.activeenemies
        if activeenemies then
            activeenemies:each(function(enemy, index, uptime)
                if enemy.casting or enemy.channeling then
                local enemyCastingId = 0
                if enemy.casting then
                    enemyCastingId = enemy.castingspellid
                end
                if enemy.channeling then
                    enemyCastingId = enemy.channelingspellid
                end
                if enemyCastingId ~= 0 then
                    -- print("正在施法",enemyCastingId)
                    for _, v in pairs(Aurora.controlSpellsList) do
                        if tonumber(v) == enemyCastingId then
                            if spell == spellbooks.spells.FANGBAOZHICHUI then
                                if player.distanceto(enemy) <= 20 and player.haslos(enemy) and enemy.playerfacing180 then
                                   return spell:cast(enemy)
                                end
                            end
                            if spell == spellbooks.spells.ZHENDANGBO then
                                if player.distanceto(enemy) <= 8 and player.haslos(enemy) and enemy.playerfacing90 then
                                   return spell:cast(player)
                                end
                            end

                            if spell == spellbooks.spells.PODANNUHOU then
                                if player.distanceto(enemy) <= 8 and player.haslos(enemy) and enemy.playerfacing180 then
                                   return spell:cast(enemy)
                                end
                            end
                            
                        end
                    end
                end
            end
            end)
        end

    
end
--判断目标在不在面向内，如果不在选择面向内的目标施法
local function isTargetBehind(spell, distance)
    target = Aurora.UnitManager:Get("target")
    if target.exists then
        if not target.playerfacing180 or target.distanceto(player) > distance or not spell:castable(target) then
            Aurora.activeenemies:each(function(enemy, index, uptime)
                if enemy.playerfacing180 and enemy.distanceto(player) <= distance and spell:castable(enemy) then
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

local function isCooldown()
    local avgTTD = Aurora.groupttd()
    if avgTTD > iscdsTime then
        iscds = true
        return true
    else 
        iscds = false
        return false
    end
end

local baofayaoList = {
    baofayao1 = Aurora.ItemHandler.NewItem(212265),
    baofayao2 = Aurora.ItemHandler.NewItem(212264),
    baofayao3 = Aurora.ItemHandler.NewItem(212263)
}

local function isBaofayao()
    for k,v in pairs(baofayaoList) do
        if v:isknown() and v:ready() and v:usable(player) and player.aura(107574) and player.auraremains(107574) >= 8 and baofayao then
            return v:use(player)
        end
    end
end

local function injuryResponse()
    -- print("injuryResponse")
    if yingdui == nil then
        return
    end
      local activeenemies = Aurora.activeenemies
        if activeenemies then
            activeenemies:each(function(enemy, index, uptime)
                local enemyCastingId = enemy.castingspellid
                if enemyCastingId then
                    -- print("正在施法",enemyCastingId)
                    for k, v in pairs(Aurora.respondSpells) do
                        if tonumber(v) == enemyCastingId then
                                if yingdui:castable(player) then
                                   return yingdui:cast(player)
                                end
                                -- return true
                            
                        end
                    end
                end
            end)
        end
end

local function isJiaJian(spell)
    target = Aurora.UnitManager:Get("target")
    -- print(spell.name)
    if player.aura(871) or player.aura(12975) or (target.exists and target.aura(1160)) then

        return false
    end
    -- if isDUNQIANG and spellbooks.spells.DUNQIANG:charges() >= 1 and spellbooks.spells.DUNQIANG == spell then
    --     return true
    
    -- elseif isPOFUCHENZHOU and spellbooks.spells.POFUCHENZHOU:ready() and spellbooks.spells.POFUCHENZHOU == spell then
    --     return true
    --  elseif isCUOZHINUHOU and spellbooks.spells.CUOZHINUHOU:getcd() == 0 and spellbooks.spells.CUOZHINUHOU == spell then
    --     return true
    -- end
    return true
end
spellbooks.spells.REMIXFENGBAO:callback(function(spell,logic)
    if autoRemixFengBao then
        return Tool:Remix(spell)
    end
    return false
end)
spellbooks.spells.REMIXNIUQU:callback(function(spell,logic)
    if autoRemixNiuQu then
        return Tool:Remix(spell)
    end
    return false        
end)
spellbooks.spells.REMIXSHENLIN:callback(function(spell,logic)
    if autoRemixShenLin then
        return Tool:Remix(spell)
    end
    return false        
end)
spellbooks.spells.REMIXSHENPAN:callback(function(spell,logic)
    if autoRemixShenPan then
        return Tool:Remix(spell)
    end
    return false        
end)
spellbooks.spells.REMIXYUANPAN:callback(function(spell,logic)
    if autoRemixYuanPan then
        return Tool:Remix(spell)
    end 
    return false        
end)



spellbooks.spells.TIANSHENXIAFAN:callback(function(spell,logic)
    if autoTianshen and isCooldown() then
        if player.enemiesaround(8) >= 5 or player.speed == 0 then
            return spell:cast(player)
        end
    end
end)
spellbooks.spells.BENGCUI:callback(function(spell,logic)
    if autoBenGCui then
        target = Aurora.UnitManager:Get("target")
        return spell:cast(target)
    end
end)

spellbooks.spells.YUANHU:callback(function(spell,logic)
    -- print("援护")
    if autoyuanhu then
        -- local group = Aurora.group
        local activeenemies = Aurora.activeenemies
        if activeenemies then
            activeenemies:each(function(enemy, index, uptime)
                if enemy.casting then
                    -- print(enemy.castingspellid)
                    for _, v in pairs(Aurora.interveneList) do
                        if tonumber(v) == enemy.castingspellid and enemy.casttarget then
                            -- print("援护",enemy.castingspellid,enemy.casttarget.name)
                            if enemy.casttarget.name ~= player.name then
                                return spell:cast(enemy.casttarget)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

spellbooks.spells.CHAOFENG:callback(function(spell,logic)
    if isChaofeng then
        Aurora.activeenemies:each(function(enemy, index, uptime)
            if enemy.threat ~= nil and enemy.threat < 100 and enemy.distanceto(player) <= 30 and enemy.haslos(player) then
                return spell:cast(enemy)
            end
        end)
    end
end)

spellbooks.spells.AutoAttack:callback(function(spell,logic)
    
    if isSwitchTarget then
        target = Aurora.UnitManager:Get("target")
        if target.exists and target.distanceto(player) <= 4.3 and target.playerfacing180 then
            return spell:cast(target)
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
    -- if isDUNQIANG and yingdui == nil and spell:ready() then
    --     if isJiaJian(spell) then
    --         yingdui = spell
    --         injuryResponse(spell)
    --     end
    -- end

    if healthDq > 0 then
        if player.hp <= healthDq and not player.aura(871) then
            return spell:cast(player)
        end
    end

end)


spellbooks.spells.POFUCHENZHOU:callback(function(spell, logic)
    if isPOFUCHENZHOU and spell:ready() and yingdui == nil then
        yingdui = spell
        -- return true
    end
    if healthPf > 0 then
        if player.hp <= healthPf and not player.aura(871) then
            return spell:cast(player)
        end
    end
end)

spellbooks.spells.LEITINGYIJI:callback(function(spell, logic)
    if isguaji then
       return spell:cast(player)
    end
    -- print("雷霆一击",isLT)
    if player.enemiesaround(8) >= 1 and isLT then
        return spell:cast(player)
    end
    if not spellbooks.spells.DUNPAIMENGJI:ready() and player.enemiesaround(8) >= 1 then
        -- print("盾猛击cd中")
        return spell:cast(player)
    end
end)

spellbooks.spells.YINGYONGTOUZHI:callback(function(spell, logic)
    if addSpellStat == "英勇投掷" or addSpellStat == "57755" then
        addSpellStat = "57755"
        target = Aurora.UnitManager:Get("target")
        if target.exists and player.distanceto(target) > 8 and player.haslos(target) and player.distanceto(target) < 30 then
            return spell:cast(target)
        end
    elseif addSpellStat == "mouseover英勇投掷" or addSpellStat == "mouseover57755" then
        addSpellStat = "57755"
        mouseover = Aurora.UnitManager:Get("mouseover")
        if mouseover.exists and player.distanceto(mouseover) > 8 and player.haslos(mouseover) and player.distanceto(mouseover) < 30 then
            return spell:cast(mouseover)
        end
    end
        -- target = Aurora.UnitManager:Get("target")
        -- if target.exists and player.distanceto(target) > 8 and player.haslos(target) and player.distanceto(target) < 30 then
        --     return spell:cast(target)
        -- end
    
end)

spellbooks.spells.YONGSHIZHIMAO:callback(function(spell, logic)
    if addSpellStat == "cursor勇士之矛" or addSpellStat == "376079" then
        addSpellStat = "376079"
        if spell:isknown() and spell:ready() then
            return spell:castcursor()
        end
    -- elseif addSpellStat == "target勇士之矛" then
    --     return spell:cast(target)
    end
     if autoyongshizhimao then
        if spell:ready() and spell:isknown() and player.speed == 0 then
            return spell:smartaoe(target, {
                offsetMin = 0,         -- Minimum offset distance
                offsetMax = 8,         -- Maximum offset distance
                distanceSteps = 24,    -- Number of distance checks
                circleSteps = 48,      -- Number of circular positions to check
                filter = function(unit, distance, position) -- Optional filter function
                    return true -- Return true to count this unit
                end,
                ignoreEnemies = false, -- Ignore enemy units
                ignoreFriends = true,  -- Ignore friendly units
            })
        end
    end
end)
spellbooks.spells.POHUAIZHE:callback(function(spell, logic)
    if addSpellStat == "cursor破坏者" or addSpellStat == "cursor228920" then
        addSpellStat = "228920"
        if spell:ready() and spell:isknown() then
            return spell:castcursor()
        end
    end

    if autopohuaizhe then
        if spell:ready() and spell:isknown() and player.speed == 0 then
            return spell:smartaoe(target, {
                offsetMin = 0,         -- Minimum offset distance
                offsetMax = 8,         -- Maximum offset distance
                distanceSteps = 24,    -- Number of distance checks
                circleSteps = 48,      -- Number of circular positions to check
                filter = function(unit, distance, position) -- Optional filter function
                    return true -- Return true to count this unit
                end,
                ignoreEnemies = false, -- Ignore enemy units
                ignoreFriends = true,  -- Ignore friendly units
            })
        end
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
    if addSpellStat == "盾牌冲锋" or addSpellStat == "385952" then
        addSpellStat = "385952"
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
    if addSpellStat == "挫志怒吼" or addSpellStat == "1160" then
        addSpellStat = "1160"
        if spell:ready() then
            return spell:cast(player)
        end
    end
    if isCUOZHINUHOU and spell:ready() and yingdui == nil then
        yingdui = spell
        -- return true
    end

    -- if isCUOZHINUHOU and yingdui == nil and spell:ready() then
    --     if isJiaJian(spell) then
    --         yingdui = spell
    --         injuryResponse(spell)
    --     end
    -- end

    if isCZCD and player.enemiesaround(8) >= 1 and player.speed == 0 and isCooldown() then
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
    local enemyCount = player.enemiesaround(5)
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

spellbooks.spells.PODANNUHOU:callback(function (spell, logic)
    if addSpellStat == "破胆怒吼" or addSpellStat == "5246" then
        addSpellStat = "5246"
        target = Aurora.UnitManager:Get("target")
        if spell:ready() and spell:isknown() and player.distanceto(target) <= 8 then
            return spell:cast(target)
        end
    end
     if pdcontrol then
        if spell:isknown() and spell:ready() then
            controlexec(spell)
        end
    end
end)

spellbooks.spells.JIJIENAHAN:callback(function(spell, logic)
    -- print("集结呐喊")
    if addSpellStat == "集结呐喊" or addSpellStat == "97462" then
        addSpellStat = "97462"
        if spell:ready() then
            return spell:cast(player)
        -- else
        --     isLoop = true;
        end
    end
end)

spellbooks.spells.ZHENDANGBO:callback(function(spell, logic)
    -- print("震荡波")
    if addSpellStat == "震荡波" or addSpellStat == "46968" then
        addSpellStat = "46968"
        if spell:ready() and spell:isknown() then
            return spell:cast(player)
        -- else
        --     isLoop = true;
        end
    end
     if zdbcontrol then
        if spell:isknown() and spell:ready() then
            controlexec(spell)
        end
    end
end)

spellbooks.spells.FANGBAOZHICHUI:callback(function(spell, logic)
    if addSpellStat == "风暴之锤" or addSpellStat == "107570" then
        addSpellStat = "107570"
        target = Aurora.UnitManager:Get("target")
        if target.exists and target.enemy and player.distanceto(target) <= 20 and spell:ready() and spell:isknown() then
            return spell:cast(target)
        end
    elseif addSpellStat == "mouseover107570" or addSpellStat == "mouseover风暴之锤" then
        addSpellStat = "mouseover107570"
        mouseover = Aurora.UnitManager:Get("mouseover")
        if mouseover.exists and mouseover.enemy and player.haslos(mouseover) and player.distanceto(mouseover) <= 20 and spell:ready() and spell:isknown() then
            return spell:cast(mouseover)
        end
    end

    --回响哨兵，打开牢笼 347721  水闸炸弹461796
    if isFbaoSp then
         if spell:ready() then
            local activeenemies = Aurora.activeenemies
            if activeenemies then
                activeenemies:each(function(enemy, index, uptime)
                    if enemy.casting then
                        if enemy.castingremains <= 1.5 then
                            for k, v in pairs(fbaoSpells) do
                                if enemy.castingspellid == v and player.distanceto(enemy) <= 20 and player.haslos(enemy) and enemy.playerfacing180 then
                                    spell:cast(enemy)
                                return true
                            end
                        end
                    end
                end
                end)  
            end
        end
    end
    if fbzccontrol then
        if spell:isknown() and spell:ready() then
            controlexec(spell)
        end
    end

end)

spellbooks.spells.LEIMINGZHIHOU:callback(function(spell, logic)
    -- print("雷鸣之吼")
    if addSpellStat == "雷鸣之吼" or addSpellStat == "384318" then
        addSpellStat = "384318"
        if spell:isknown() and spell:ready() then
            return spell:cast(player)
        -- else
        --     isLoop = true
        end
    end
    --雷鸣之吼
    if isLonghou and spell:isknown() and spell:ready() and isCooldown() then
        if player.speed == 0 or player.enemiesaround(10) > 4 then
            return spell:cast(player)
        end
    end
end)

spellbooks.spells.ZHANDOUNUHOU:callback(function(spell, logic)
    -- print("战斗怒吼")
    if addSpellStat == "战斗怒吼" or addSpellStat == "6673" then
        addSpellStat = "6673"
        return spell:cast(player)
    end
    --自动战斗怒吼
    if isGongqiang and not player.combat then
        local fgroup = Aurora.fgroup
        fgroup:each(function(unit, i, uptime)
            if not unit.aura(6673) and unit.alive and unit.distanceto(player) <= 100 then
                return spell:cast(player) -- breaks the loop
            end
        end)
        -- return spell:cast(player)
    end
end)
local function hasInterruptSpell(spellid, interruptstat)
    if interruptstat == "blacklist" then
        for _, v in pairs(Aurora.interruptSpellsblacklist) do
            if tonumber(v) == spellid then
                return true
            end
        end
        return false
    elseif interruptstat == "whitelist" then
        for _, v in pairs(Aurora.interruptSpellswhitelist) do
            if tonumber(v) == spellid then
                return true
            end
        end
        return false
    end
  
end

local function interruptMethod(spell,unit,spellId)
    -- print("打断3",interruptstat)
    if interruptstat == "all" then
        return spell:cast(unit)
    end
    if interruptstat == "blacklist" then
        -- print("打断黑名单",hasInterruptSpell(spellId,"blacklist"))
        if not hasInterruptSpell(spellId,"blacklist") then
            return spell:cast(unit)
        end
    end
    if interruptstat == "whitelist" then
        if hasInterruptSpell(spellId,"whitelist") then
            return spell:cast(unit)
        end
    end
end


spellbooks.spells.QUANJI:callback(function(spell, logic)
    --  print("自动打断")
    local activeenemies = Aurora.activeenemies
    if autoQuanji and spell:ready() then
       
        target = Aurora.UnitManager:Get("target")
        focus = Aurora.UnitManager:Get("focus")
        if focus.exists and focus.distanceto(player) <= 4 and player.haslos(focus) and focus.enemy and focus.alive and focus.castinginterruptible and focus.playerfacing180 and focus.castingpct >= interruptthreshold then
            if isFSFS then
                    if table.contains(Aurora.reflectionSpells,focus.castingspellid) then
                        if focus.casttarget and focus.casttarget.name ~= player.name then
                            interruptMethod(spell,focus,focus.castingspellid)
                        end
                        if not spellbooks.spells.FASHUFANSHE:ready() and not player.aura(23920) then
                            interruptMethod(spell,focus,focus.castingspellid)
                        end
                    else
                        interruptMethod(spell,focus,focus.castingspellid)
                    end
            else
                interruptMethod(spell,focus,focus.castingspellid)
            end
            
        end
        if focus.exists and focus.distanceto(player) <= 4 and player.haslos(focus) and focus.enemy and focus.alive and focus.channelinginterruptible and focus.playerfacing180 and focus.channelingpct >= 10 then
            interruptMethod(spell,focus,focus.channelingspellid)
        end

        
        if activeenemies and not focus.exists then
        activeenemies:each(function(enemy, index, uptime)
            -- print("进战斗的怪",enemy.name)
            if enemy.castinginterruptible and enemy.exists and enemy.distanceto(player) <= 4 and player.haslos(enemy) and enemy.enemy and enemy.alive and enemy.playerfacing180 and enemy.castingpct >= interruptthreshold and enemy.castingspellid ~= 432031 then
                if isFSFS then
                    if table.contains(Aurora.reflectionSpells,enemy.castingspellid) then
                        if enemy.casttarget and enemy.casttarget.name ~= player.name then
                            interruptMethod(spell,enemy,enemy.castingspellid)
                        end
                        if not spellbooks.spells.FASHUFANSHE:ready() and not player.aura(23920) then
                            interruptMethod(spell,enemy,enemy.castingspellid)
                        end
                    else
                        interruptMethod(spell,enemy,enemy.castingspellid)
                    end

                else
                    interruptMethod(spell,enemy,enemy.castingspellid)
                end
            end
            if enemy.channelinginterruptible and enemy.exists and enemy.distanceto(player) <= 4 and player.haslos(enemy) and enemy.enemy and enemy.alive and enemy.playerfacing180 and enemy.channelingpct >= 10 and enemy.channelingspellid ~= 432031 then
                interruptMethod(spell,enemy,enemy.channelingspellid)
                return true -- break the loop
            end
            end)    
        end
    end
    --特殊处理终极失真
    if spell:ready() then
        if activeenemies then
            activeenemies:each(function(enemy, index, uptime)
                if enemy.castinginterruptible and enemy.castingspellid == 1214780 and enemy.exists and enemy.distanceto(player) <= 4 and player.haslos(enemy) and enemy.enemy and enemy.alive and enemy.playerfacing180 and enemy.castingpct >= 30  then
                    return spell:cast(enemy)
                end
                if enemy.channelinginterruptible and enemy.channelingspellid == 1214780 and enemy.exists and enemy.distanceto(player) <= 4 and player.haslos(enemy) and enemy.enemy and enemy.alive and enemy.playerfacing180 and enemy.channelingpct >= 10  then
                    return spell:cast(enemy)
                end
            end)
        end
    end

end)

spellbooks.spells.FASHUFANSHE:callback(function(spell, logic)
    
    if isFSFS then
        -- print("法术反射")
        if spell:ready() then
            local activeenemies = Aurora.activeenemies
            if activeenemies then
                activeenemies:each(function(enemy, index, uptime)
                    if enemy.casting then
                        if enemy.castingremains <= 1 and  enemy.casttarget and enemy.casttarget.name and enemy.casttarget.name == player.name then
                            for k, v in pairs(Aurora.reflectionSpells) do
                                --  print("反射",enemy.castingspellid,v)
                                if enemy.castingspellid == tonumber(v) then
                                --    print("反射",enemy.castingspellid,tonumber(v))
                                   return spell:cast(player)
                                end
                            end
                        elseif enemy.castingremains <= 1 then
                            for k, v in pairs(reflectionSpellsAny) do
                                if enemy.castingspellid == tonumber(v) then
                                   return spell:cast(player)
                                end
                            end 
                        end
                    end
                end)
            end
        -- else
        --     isLoop = true;
        end
    end
end)


local spellbook = Aurora.SpellHandler.Spellbooks.warrior["3"].Mia_Warrior
local spells = spellbook.spells


local function loop()

  injuryResponse()
--   if spells.YUANHU:execute() then return true end
  if spells.QUANJI:execute() then return true end
  if spells.YINGYONGTOUZHI:execute() then return true end
  if spells.CHAOFENG:execute() then return true end
  if spells.PODANNUHOU:execute() then return true end
  if spells.TIANSHENXIAFAN:execute() then return true end
  if spells.CUOZHINUHOU:execute() then return true end
  if spells.BENGCUI:execute() then return true end
  if spells.DUNQIANG:execute() then return true end
  if spells.POFUCHENZHOU:execute() then return true end
  if spells.YONGSHIZHIMAO:execute() then return true end
  if spells.DUNPAICHONGFENG:execute() then return true end
  if spells.POHUAIZHE:execute() then return true end
  if spells.YONGSHIZHIMAO:execute() then return true end

  if spells.REMIXFENGBAO:execute() then return true end
  if spells.REMIXNIUQU:execute() then return true end
  if spells.REMIXSHENLIN:execute() then return true end
  if spells.REMIXSHENPAN:execute() then return true end
  if spells.REMIXYUANPAN:execute() then return true end
  
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
    if mouseover.exists and mouseover.friend and mouseover.dead and player.distanceto(mouseover) <= 3 and battleResurrection:isknown() and battleResurrection:ready() and mouseoverfuhuo then
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

local healthItemList = {
    healthPotion1 = Aurora.ItemHandler.NewItem(244839),
    healthPotion2 = Aurora.ItemHandler.NewItem(244838),
    healthPotion3 = Aurora.ItemHandler.NewItem(244835),
    zhiliaoshi = Aurora.ItemHandler.NewItem(5512)
}

local function healthItem()
    for k, v in pairs(healthItemList) do
        if v:isknown() and v:ready() and v:usable(player) and player.hp < shengmingyaoyuzhi then
            v:use(player)
        end
    end
end
-- function CheckImportantTimer()
--     local timers = Aurora.BossMod:getactivetimers()
--     local pullString = Aurora.BossMod:getpullstring()
--     print(pullString)
--     for k, v in pairs(timers) do
--         print(k,v)
--     end

--     if Aurora.BossMod:hastimer("石拳") then
--         local remaining = Aurora.BossMod:gettimerremaining("石拳")
--         if remaining < 5 then
--             -- Prepare for ability
--             print("重要技能即将触发")
--         end
--     end
-- end

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
            -- CheckImportantTimer()
            healthItem()
            isBaofayao()
            if isuseTrinket then
                useTrinket()
            end
            loop()
        else
            -- print("脱战")
            battleReady()
            if spells.ZHANDOUNUHOU:execute() then return true end
            if isguaji then 
                if spells.LEITINGYIJI:execute() then return true end
            end
            
        end
    end
end, "WARRIOR", 3, "Mia_Warrior")




Aurora.EventHandler:RegisterEvent("SPELL_CAST_SUCCESS", function(eventData)
    if eventData.source.guid == UnitGUID("player") then
        local spellId, spellName = unpack(eventData.params)
        -- print("施法成功",spellName,castedCount)
        -- if  spellName ~= "盾牌格挡" and spellName ~= "法术反射" and spellName ~= "防御姿态" and spellName ~= "战斗姿态" and spellName ~= "拳击" and spellName ~= "英勇飞跃" and spellName ~= "挑战怒吼" and spellName ~= "盾墙" and spellName ~= "无视苦痛" and spellName ~= "破釜沉舟" and spellName ~= "嘲讽" and spellName ~= "冲锋" then
        --     castedCount = castedCount + 1
        --     --应对技能计数
        --     yingduicount = yingduicount + 1
        --     isLT = true
        -- end

        if spellId ~= 2565 and spellId ~= 23920 and spellId ~= 386208 and spellId ~= 386164 and spellId ~= 6552 and spellId ~= 6544 and spellId ~= 386071 and spellId ~= 871 and spellId ~= 190456 and spellId ~= 12975 and spellId ~= 355 and spellId ~= 100 then
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

        if spellId == 6343 or spellId == 435222 then
            isLT = false
        end
        
        if castedCount > 2  then
            addSpellStat = nil
            castedCount = 0
        end
        -- print(string.format("Cast %s (ID: %d)", spellName, spellId))
        if spellId == tonumber(addSpellStat) then
            -- isLoop = true
            -- print("相同技能")
            addSpellStat = nil
            castedCount = 0
        end
    end
end)

local autoQuanji_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动打断", "auto Interrupt"),              -- Display name (max 11 characters)
    var = "autoQuanji_toggle",       -- Unique identifier for saving state
    icon = 6552, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动打断", "auto Interrupt"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动打断:", value)
        autoQuanji = value
    end
})

local autoChaofeng_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动嘲讽", "auto taunt"),              -- Display name (max 11 characters)
    var = "autoChaofeng_toggle",       -- Unique identifier for saving state
    icon = 355, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动嘲讽", "auto taunt"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动打断:", value)
        isChaofeng = value
    end
})
local autoGongqiang_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动战斗怒吼", "battle shout"),              -- Display name (max 11 characters)
    var = "autoGongqiang_toggle",       -- Unique identifier for saving state
    icon = 6673, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动战斗怒吼", "battle shout"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isGongqiang = value
    end
})

local autoFS_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动法术反射", "spell reflection"),              -- Display name (max 11 characters)
    var = "autoFS_toggle",       -- Unique identifier for saving state
    icon = 23920, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动法术反射", "spell reflection"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动法术反射:", value)
        isFSFS = value
    end
})



local autoSwitchTarget_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动切换目标", "auto switch target"),              -- Display name (max 11 characters)
    var = "autoSwitchTarget_toggle",       -- Unique identifier for saving state
    icon = 76290, -- Icon texture or spell ID
    tooltip = getLocalizedText("丢失自动攻击切换目标,生效范围:4-8码", "lose auto-Attack,switch targets.effective range:4-8"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isSwitchTarget = value
    end
})
local autoDunpaichongfeng_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("盾牌冲锋", "should charge"),              -- Display name (max 11 characters)
    var = "autoDunpaichongfeng_toggle",       -- Unique identifier for saving state
    icon = 385952, -- Icon texture or spell ID
    tooltip = getLocalizedText("冲锋最近的,防止位移", "should charge"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isDunpaichongfeng = value
    end
})
local autoCZCD_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("挫志怒吼卡cd", "demoralizing shout on cooldown"),              -- Display name (max 11 characters)
    var = "autoCZCD_toggle",       -- Unique identifier for saving state
    icon = 1160, -- Icon texture or spell ID
    tooltip = getLocalizedText("挫志怒吼卡cd", "demoralizing shout on cooldown"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动打断:", value)
        isCZCD = value
    end
})
local autoLonghou_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("雷鸣之吼", "thunderous roar"),              -- Display name (max 11 characters)
    var = "autoLonghou_toggle",       -- Unique identifier for saving state
    icon = 384318, -- Icon texture or spell ID
    tooltip = getLocalizedText("站住不动或者周围4目标以上", "thunderous roar"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        isLonghou = value
    end
})

local autoTianshen_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动天神下凡", "avenging wrath"),              -- Display name (max 11 characters)
    var = "autoTianshen_toggle",       -- Unique identifier for saving state
    icon = 107574, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动天神下凡,站住不动或者5目标以上", "avenging wrath"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        autoTianshen = value
    end
})
local autopohuaizhe_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动破坏者", "devastator"),              -- Display name (max 11 characters)
    var = "autopohuaizhe_toggle",       -- Unique identifier for saving state
    icon = 228920, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动破坏者", "devastator"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        autopohuaizhe = value
    end
})

local autoyongshizhimao_toggle = Aurora:AddGlobalToggle({
    label = getLocalizedText("自动勇士之矛", "warrior's spear"),              -- Display name (max 11 characters)
    var = "autoyongshizhimao_toggle",       -- Unique identifier for saving state
    icon = 376079, -- Icon texture or spell ID
    tooltip = getLocalizedText("自动勇士之矛", "warrior's spear"), -- Tooltip text
    onClick = function(value)    -- Optional callback when clicked
        -- print("自动切换目标:", value)
        autoyongshizhimao = value
    end
})
if spellbooks.spells.BENGCUI:isknown() then
    local autoBenGCui_toggle = Aurora:AddGlobalToggle({
        label = getLocalizedText("崩催", "devastator"),              -- Display name (max 11 characters)
        var = "autoBenGCui_toggle",       -- Unique identifier for saving state
        icon = 436358, -- Icon texture or spell ID
        tooltip = getLocalizedText("崩催", "devastator"), -- Tooltip text
        onClick = function(value)    -- Optional callback when clicked
            -- print("自动切换目标:", value)
            autoBenGCui = value
        end
    })
    if autoBenGCui_toggle:GetValue() then
        autoBenGCui = true
    end
end
if spellbooks.spells.REMIXFENGBAO:isknown() then
    local autoRemixFengBao_toggle = Aurora:AddGlobalToggle({
        label = getLocalizedText("remix", "remix"),              -- Display name (max 11 characters)
        var = "autoRemixFengBao_toggle",       -- Unique identifier for saving state
        icon = spellbooks.spells.REMIXFENGBAO.id, -- Icon texture or spell ID
        tooltip = getLocalizedText("remix", "remix"), -- Tooltip text
        onClick = function(value)    -- Optional callback when clicked
            -- print("自动切换目标:", value)
            autoRemixFengBao = value
        end
    })
    if autoRemixFengBao_toggle:GetValue() then
        autoRemixFengBao = true
    end
end
if spellbooks.spells.REMIXNIUQU:isknown() then
    local autoRemixNiuQu_toggle = Aurora:AddGlobalToggle({
        label = getLocalizedText("remix", "remix"),              -- Display name (max 11 characters)
        var = "autoRemixNiuQu_toggle",       -- Unique identifier for saving state
        icon = spellbooks.spells.REMIXNIUQU.id, -- Icon texture or spell ID
        tooltip = getLocalizedText("remix", "remix"), -- Tooltip text
        onClick = function(value)    -- Optional callback when clicked
            -- print("自动切换目标:", value)
            autoRemixNiuQu = value
        end
    })
    if autoRemixNiuQu_toggle:GetValue() then
        autoRemixNiuQu = true
    end
end
if spellbooks.spells.REMIXSHENLIN:isknown() then
    local autoRemixShenLin_toggle = Aurora:AddGlobalToggle({
        label = getLocalizedText("remix", "remix"),              -- Display name (max 11 characters)
        var = "autoRemixShenLin_toggle",       -- Unique identifier for saving state
        icon = spellbooks.spells.REMIXSHENLIN.id, -- Icon texture or spell ID
        tooltip = getLocalizedText("remix", "remix"), -- Tooltip text
        onClick = function(value)    -- Optional callback when clicked
            -- print("自动切换目标:", value)
            autoRemixShenLin = value
        end
    })
    if autoRemixShenLin_toggle:GetValue() then
        autoRemixShenLin = true
    end
end
if spellbooks.spells.REMIXSHENPAN:isknown() then
    local autoRemixShenPan_toggle = Aurora:AddGlobalToggle({
        label = getLocalizedText("remix", "remix"),              -- Display name (max 11 characters)
        var = "autoRemixShenPan_toggle",       -- Unique identifier for saving state
        icon = spellbooks.spells.REMIXSHENPAN.id, -- Icon texture or spell ID
        tooltip = getLocalizedText("remix", "remix"), -- Tooltip text
        onClick = function(value)    -- Optional callback when clicked
            -- print("自动切换目标:", value)
            autoRemixShenPan = value
        end
    })
    if autoRemixShenPan_toggle:GetValue() then
        autoRemixShenPan = true
    end
end
if spellbooks.spells.REMIXYUANPAN:isknown() then
    local autoRemixYuanPan_toggle = Aurora:AddGlobalToggle({
        label = getLocalizedText("remix", "remix"),              -- Display name (max 11 characters)
        var = "autoRemixYuanPan_toggle",       -- Unique identifier for saving state
        icon = spellbooks.spells.REMIXYUANPAN.id, -- Icon texture or spell ID
        tooltip = getLocalizedText("remix", "remix"), -- Tooltip text
        onClick = function(value)    -- Optional callback when clicked
            -- print("自动切换目标:", value)
            autoRemixYuanPan = value
        end
    })
    if autoRemixYuanPan_toggle:GetValue() then
        autoRemixYuanPan = true
    end
end

if autoyongshizhimao_toggle:GetValue() then
    autoyongshizhimao = true
end

if autopohuaizhe_toggle:GetValue() then
    autopohuaizhe = true
end

if autoLonghou_toggle:GetValue() then
    isLonghou = true
end

if autoChaofeng_toggle:GetValue() then
    isChaofeng = true
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
    Aurora.Config:Write("graphics.isIgnoringPain", value)
end, "Casts the specified spell")

Macro:RegisterCommand("SwitchTarget", function()
    isSwitchTarget = not isSwitchTarget
    -- Aurora.Config:Write("feature.isSwitchTarget", isSwitchTarget)
    autoSwitchTarget_toggle:SetValue(isSwitchTarget)
    -- print("切换目标：",isSwitchTarget)
end, "切换目标(Switch Target)")

Macro:RegisterCommand("SpellReflection", function()
    isFSFS = not isFSFS
    autoFS_toggle:SetValue(isFSFS)
    -- print("法术反射：",isFSFS)
end, "法术反射(Spell Reflection)")
Macro:RegisterCommand("ridicule", function()
    isChaofeng = not isChaofeng
    -- Aurora.Config:Write("feature.isCZCD", isCZCD)
    autoChaofeng_toggle:SetValue(isChaofeng)
    -- print("自动嘲讽：",isChaofeng)
end, "自动嘲讽(auto taunt)")

Macro:RegisterCommand("Shout", function()
    isCZCD = not isCZCD
    -- Aurora.Config:Write("feature.isCZCD", isCZCD)
    autoCZCD_toggle:SetValue(isCZCD)
    -- print("挫志怒吼卡cd：",isCZCD)
end, "挫志怒吼卡cd(demoralizing shout on cooldown)")
Macro:RegisterCommand("AutomaticInterruption", function()
    autoQuanji = not autoQuanji
    -- Aurora.Config:Write("feature.isCZCD", isCZCD)
    autoQuanji_toggle:SetValue(autoQuanji)
    -- print("自动打断：",autoQuanji)
end, "自动打断(Automatic Interruption)")
Macro:RegisterCommand("ShieldCharge", function()
    isDunpaichongfeng = not isDunpaichongfeng
    -- Aurora.Config:Write("feature.isDunpaichongfeng", isDunpaichongfeng)
    autoDunpaichongfeng_toggle:SetValue(isDunpaichongfeng)
    -- print("盾牌冲锋：",isDunpaichongfeng)
end, "盾牌冲锋(Shield Charge)")
Macro:RegisterCommand("ThunderousRoar", function()
    isLonghou = not isLonghou
    -- Aurora.Config:Write("feature.isLonghou", isLonghou)
    autoLonghou_toggle:SetValue(isLonghou)
    -- print("雷鸣之吼：",isLonghou)
end, "雷鸣之吼(Thunderous Roar)")
Macro:RegisterCommand("BKB", function()
    autoTianshen = not autoTianshen
    -- Aurora.Config:Write("feature.isLonghou", isLonghou)
    autoTianshen_toggle:SetValue(autoTianshen)
    -- print("天神下凡：",autoTianshen)
end, "天神下凡(avenging wrath)")


-- 修复命令解析问题：将cast命令改为使用Macro:RegisterCommand以确保正确解析参数
Macro:RegisterCommand("cast", function(spell)
    
    if spell and player.combat then
        -- 确保正确处理法术ID参数
        local trimmedSpell = tostring(spell):trim()
        addSpellStat = trimmedSpell
        castedCount = 0
    end
end, "insert spell into queue")

Macro:RegisterCommand("cast97462", function()
    if player.combat then
        addSpellStat = "97462"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast6673", function()
    if player.combat then
        addSpellStat = "6673"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast384318", function()
    if player.combat then
        addSpellStat = "384318"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast46968", function()
    if player.combat then
        addSpellStat = "46968"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast107570", function()
    if player.combat then
        addSpellStat = "107570"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast57755", function()
    if player.combat then
        addSpellStat = "57755"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast385952", function()
    if player.combat then
        addSpellStat = "385952"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast1160", function()
    if player.combat then
        addSpellStat = "1160"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast5246", function()
    if player.combat then
        addSpellStat = "5246"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast376079", function()
    if player.combat then
        addSpellStat = "cursor376079"
        castedCount = 0
    end
end)
Macro:RegisterCommand("cast228920", function()
    if player.combat then
        addSpellStat = "cursor228920"
        castedCount = 0
    end
end)
Macro:RegisterCommand("castmouseover57755", function()
    if player.combat then
        addSpellStat = "mouseover57755"
        castedCount = 0
    end
end)
Macro:RegisterCommand("castmouseover107570", function()
    if player.combat then
        addSpellStat = "mouseover107570"
        castedCount = 0
    end
end)
Macro:RegisterCommand("GJ", function()
    isguaji = not isguaji
end)



local function ShowUpdateAlert()
    local updateMessages = {
        -- "时间:10月7日 13:23",
        "支持 巨神兵天赋",
        "支持 Remix",
        "*** 有问题及时联系作者(秒改) ***"
    }

    local updateTips = Aurora.Config:Read('UpdateTips')
    if updateTips then
        local dataString = table.concat(updateMessages, ";")
        if updateTips ~= dataString then
            UpdateAlert:ShowWindow(updateMessages)
            Aurora.Config:Write('UpdateTips', dataString)
        end
    else
        UpdateAlert:ShowWindow(updateMessages)
        Aurora.Config:Write('UpdateTips', table.concat(updateMessages, ";"))
    end
end



InitConfig()
draw()
ShowUpdateAlert()
Aurora:RemoveGlobalToggle("rotation_interrupt")
Aurora:RemoveGlobalToggle("rotation_cooldown")
return Mia_Warrior
