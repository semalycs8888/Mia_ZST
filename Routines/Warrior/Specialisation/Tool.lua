-- 初始化Aurora全局表（如果不存在）
Aurora = Aurora or {}

-- 初始化Tool模块并添加到Aurora全局表
local Tool = Aurora.Tool or {}
Aurora.Tool = Tool

-- 获取客户端语言
local clientLocale = GetLocale() or "enUS" -- 设置默认值以防获取失败
local isChineseClient = clientLocale == "zhCN" or clientLocale == "zhTW"

-- 多语言文本获取函数
function Tool:getLocalizedText(zhText, enText)
    return isChineseClient and zhText or enText
end

-- 创建宏
-- @param spellId 法术ID
-- @param type 宏类型（regular, mouseover, cursor）
-- @param friend 是否为友方增益技能
function Tool:CreateMacro(spellId, type, friend)
    local spellinfo = C_Spell.GetSpellInfo(spellId)
    local spellName = spellinfo and spellinfo.name or "未知法术"
    local body = "/"..Aurora.Macro.baseCommand.." cast "..spellId.."\n/cast "..spellName
    local icon = "INV_Misc_QuestionMark"

    if type == "regular" then
        body = "/"..Aurora.Macro.baseCommand.." cast "..spellName.."\n/cast "..spellName
    elseif type == "mouseover" then
        if friend then
            body = "/"..Aurora.Macro.baseCommand.." cast mouseover"..spellName.."\n/cast [@mouseover,exists,help,nodead] "..spellName..":"..spellName
        else
            body = "/"..Aurora.Macro.baseCommand.." cast mouseover"..spellName.."\n/cast [@mouseover] "..spellName
        end
    elseif type == "cursor" then
        body = "/"..Aurora.Macro.baseCommand.." cast cursor"..spellName.."\n/cast [@cursor] "..spellName
    end
    CreateMacro(spellName, icon, body, nil)
end
-- 根据法术ID获取法术名称
-- @param spellId 法术ID
-- @return 法术名称
function Tool:GetSpellNameByID(spellId)
    local spellinfo = C_Spell.GetSpellInfo(spellId)
    return spellinfo and spellinfo.name or "未知法术"
end
-- 获取饰品
-- @param value 饰品位置（13或14）
-- @return 饰品对象
function Tool:GetTrinket(value)
    local trinketID = GetInventoryItemID("player",value)
    local trinket = Aurora.ItemHandler.NewItem(trinketID)
    return trinket
end
-- 检查单位距离和朝向
-- @param unit 单位对象
-- @param distance 最大距离
-- @return 是否在距离内且朝向玩家
function Tool:CheckUnitDistanceFacing(unit,distance)
    local player = Aurora.UnitManager:Get("player")
    return unit.distanceto(player) <= distance and unit.playerfacing180
end

-- return 平均TTD
function Tool:TTD()
    return Aurora.groupttd()
end

function Tool:Remix(spell)
    local player = Aurora.UnitManager:Get("player")
    local target = Aurora.UnitManager:Get("target")
    if spell:isknown() then
       if spell:castable(player) then
           return spell:cast(player)
       elseif spell:castable(target) then
           return spell:cast(target)
       else 
           return spell:smartaoe(target, {
                offsetMin = 0,       
                offsetMax = 20,     
                filter = function(unit, distance, position)
                    return true
                end,
                ignoreEnemies = false,
                ignoreFriends = true
            })
       end
    end
    return false
end

