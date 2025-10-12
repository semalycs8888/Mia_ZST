-- 初始化Aurora全局表（如果不存在）
Aurora = Aurora or {}

-- 初始化TZList模块并添加到Aurora全局表
local TZList = Aurora.TZList or {}
Aurora.TZList = TZList

if not Aurora.Tool then
    require "Tool"
end
local Tool = Aurora.Tool or {}

-- 加载StdUi库
local StdUi = LibStub("AuroraStdUi")
-- 获取客户端语言
local clientLocale = GetLocale() or "enUS" -- 设置默认值以防获取失败
local isChineseClient = clientLocale == "zhCN" or clientLocale == "zhTW"

-- 多语言文本获取函数
local function getLocalizedText(zhText, enText)
    return isChineseClient and zhText or enText
end

-- GUI相关变量
TZList.configKey = ""
TZList.frame = nil
TZList.itemList = {}
TZList.selectedIndex = nil
TZList.inputBox = nil
TZList.listButtons = {}
TZList.listFrame = nil

-- 初始化GUI
function TZList:Initialize()
    if self.frame then
        self.frame:Show()
        return
    end

    -- 初始化变量
    self.itemList = {}
    self.selectedIndex = nil
    self.listButtons = {}

    self:CreateMainFrame()
    self:CreateInputArea()
    self:CreateListDisplay()
    self:CreateActionButtons()
    
    -- 尝试加载已保存的数据
    self:LoadData()
end

-- 创建主窗口
function TZList:CreateMainFrame()
    local frame = StdUi:Window(UIParent, 400, 400, "Mia List Manager")
    
    -- 应用Aurora的缩放设置
    local scale = Aurora.Config:Read('general.scale')
    if scale then
        frame:SetScale(scale / 100)
    else
        frame:SetScale(1)
    end
    
    -- 设置窗口位置
    if Aurora.configFrame then
        frame:SetPoint('TOPLEFT', Aurora.configFrame, 'TOPRIGHT', 10, 0)
    else
        frame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    end
    
    -- 设置窗口属性
    frame:SetMovable(false)
    frame:EnableMouse(true)
    frame:SetFrameStrata("DIALOG")
    
    self.frame = frame
end

-- 创建输入区域
function TZList:CreateInputArea()
    local frame = self.frame
    
    -- 输入标签
    local inputLabel = StdUi:Label(frame, getLocalizedText("输入ID", "Input ID"))
    inputLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)
    
    -- 输入框
    self.inputBox = StdUi:EditBox(frame, 200, 25, "")
    self.inputBox:SetPoint("LEFT", inputLabel, "RIGHT", 10, 0)
    self.inputBox:SetScript("OnEnterPressed", function() 
        self:AddItem() 
    end)
end

-- 创建列表显示区域
function TZList:CreateListDisplay()
    local frame = self.frame
    
    -- 列表容器
    local listContainer = StdUi:Frame(frame, 350, 220)
    listContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -80)
    -- listContainer:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    
    -- 可滚动列表
    self.listFrame = StdUi:ScrollFrame(listContainer, 340, 210)
    self.listFrame:SetPoint("TOPLEFT", listContainer, "TOPLEFT", 5, -5)
    
    self.listButtons = {}
end

-- 创建操作按钮
function TZList:CreateActionButtons()
    local frame = self.frame
    
    -- 添加按钮
    self.addButton = StdUi:Button(frame, 120, 30, getLocalizedText("添加", "Add"))
    self.addButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -320)
    self.addButton:SetScript("OnClick", function() self:AddItem() end)
    
    -- 删除按钮
    self.removeButton = StdUi:Button(frame, 120, 30, getLocalizedText("删除", "Remove"))
    self.removeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, -320)
    self.removeButton:SetScript("OnClick", function() self:RemoveItem() end)
end

-- 加载数据
function TZList:LoadData()
    -- 确保configKey是字符串类型并提供默认值
    local configKey = type(TZList.configKey) == "string" and TZList.configKey or tostring(TZList.configKey or "")
    
    -- 如果没有配置键或为空，则使用默认值
    if configKey == "" then
        configKey = "simpleList.default"
        print("使用默认配置键: simpleList.default")
    end
    
    local dataString = Aurora.Config:Read(configKey) or ""
    -- print("加载数据, configKey:", configKey, "dataString:", dataString)
    self.itemList = {}
    
    if dataString and dataString ~= "" then
        for item in string.gmatch(dataString, "([^;]+)") do
            table.insert(self.itemList, tonumber(item))
        end
    else
        -- 添加模拟数据

     
        -- 保存模拟数据
        self:SaveData()
    end
    
    self:UpdateListDisplay()
end

-- 保存数据
function TZList:SaveData()
    -- 确保configKey是字符串类型并提供默认值
    local configKey = type(TZList.configKey) == "string" and TZList.configKey or tostring(TZList.configKey or "")
    
    -- 如果没有配置键或为空，则使用默认值
    if configKey == "" then
        configKey = "simpleList.default"
        print("使用默认配置键: simpleList.default")
    end
    
    local dataString = table.concat(self.itemList, ";")
    -- print("configKey:", configKey)
    -- print("dataString:", dataString)
    Aurora.Config:Write(configKey, dataString)
    if configKey == "jianshangyingdui" then
        Aurora.respondSpells = self.itemList
    elseif configKey == "fashufansheyingdui" then
        Aurora.reflectionSpells = self.itemList
    elseif configKey == "interveneList" then
        Aurora.interveneList = self.itemList
    elseif configKey == "controlSpellsList" then
        Aurora.controlSpells = self.itemList
    elseif configKey == "interruptSpellsblacklist" then
        Aurora.interruptSpellsblacklist = self.itemList
    elseif configKey == "interruptSpellswhitelist" then
        Aurora.interruptSpellswhitelist = self.itemList
    end
end

-- 更新列表显示
function TZList:UpdateListDisplay()
    -- 清除现有按钮
    if self.listButtons then
        for _, button in pairs(self.listButtons) do
            button:Hide()
        end
    end
    self.listButtons = {}
    
    -- 显示空列表消息
    if #self.itemList == 0 then
        local noEntriesLabel = StdUi:Label(self.listFrame.scrollChild, getLocalizedText("空列表", "No items in list"))
        noEntriesLabel:SetPoint("CENTER", self.listFrame.scrollChild, "CENTER", 0, 0)
        self.listButtons[1] = noEntriesLabel
        return
    end
    
    -- 创建新按钮
    for i, itemText in ipairs(self.itemList) do
        local spellname = Aurora.dungronSpell[tonumber(itemText)] or "未知"
        -- local spellname = Tool.GetSpellNameByID(itemText) or "未知"
        local button = StdUi:Button(self.listFrame.scrollChild, 320, 25, Aurora.texture(tonumber(itemText))..itemText .. "(" .. spellname .. ")")
        button:SetPoint("TOPLEFT", self.listFrame.scrollChild, "TOPLEFT", 5, -((i - 1) * 30))
        
        button:SetScript("OnClick", function()
            self:SelectItem(i)
        end)
        
        -- 如果是选中的项，设置不同的背景色
        if i == self.selectedIndex then
            button:SetBackdropColor(0.2, 0.4, 0.8, 0.8)
        else
            button:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
        end
        
        self.listButtons[i] = button
        button:Show()
    end
    
    -- 更新滚动区域高度
    if self.listFrame.SetContentHeight then
        self.listFrame:SetContentHeight(math.max(100, #self.itemList * 30))
    end
end

-- 选择项目
function TZList:SelectItem(index)
    self.selectedIndex = index
    self:UpdateListDisplay()
end

-- 添加项目
function TZList:AddItem()
    local itemText = self.inputBox:GetText()
    
    if itemText and itemText ~= "" then
        table.insert(self.itemList, tonumber(itemText))
        self.inputBox:SetText("") -- 清空输入框
        self:SaveData()
        self:UpdateListDisplay()
    else
        print("Please enter an item to add")
    end
end

-- 删除项目
function TZList:RemoveItem()
    if not self.selectedIndex then
        print("No item selected")
        return
    end
    
    table.remove(self.itemList, self.selectedIndex)
    self.selectedIndex = nil
    self:SaveData()
    self:UpdateListDisplay()
end

-- 创建列表（使用冒号语法定义方法，以支持TZList:createList()调用）
function TZList:createList(configKey)
    -- 打印参数的详细信息以调试类型问题
    -- print("createList configKey原始值:", configKey)
    -- print("createList configKey类型:", type(configKey))
    
    -- -- 如果是table，打印table的内容
    -- if type(configKey) == "table" then
    --     print("configKey是table，包含以下键值对:")
    --     for k, v in pairs(configKey) do
    --         print("  ", k, "=", v, "(类型:", type(v), ")")
    --     end
    -- end
    
    -- 确保configKey是字符串类型
    self.configKey = type(configKey) == "string" and configKey or tostring(configKey or "")
    
    -- print("转换后的configKey:", self.configKey)
    
    -- 如果没有提供configKey或为空，则使用默认值
    if self.configKey == "" then
        self.configKey = "simpleList.default"
        print("使用默认配置键: simpleList.default")
    end
    
    self:Initialize()
    -- 重要：确保每次调用createList时都重新加载数据，解决第二次点击按钮列表不刷新的问题
    self:LoadData()
    return self
end

-- 获取respondSpells列表（从Aurora全局表中）
function TZList:GetRespondSpells()
    return Aurora.respondSpells or {}
end

-- 使用respondSpells列表的示例方法
function TZList:UseRespondSpells()
    local spells = self:GetRespondSpells()
    if #spells > 0 then
        print("减伤应对列表包含 ", #spells, " 个法术ID")
        
        -- 示例：打印前5个法术ID
        print("前5个法术ID:")
        for i = 1, math.min(5, #spells) do
            print("  ", i, ": ", spells[i])
        end
    else
        print("减伤应对列表为空")
    end
    return spells
end

-- 同时添加到Mia_Warrior全局表（兼容Rotation.lua的访问方式）
Mia_Warrior = Mia_Warrior or {}
Mia_Warrior.TZList = TZList

-- 保持原有return语句以兼容require方式
return TZList
