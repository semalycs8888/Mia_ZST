local player = Aurora.UnitManager:Get("player")
if player.spec == 3 then
-- 初始化Aurora全局表（如果不存在）
Aurora = Aurora or {}

-- 初始化UpdateAlert模块并添加到Aurora全局表
local UpdateAlert = Aurora.UpdateAlert or {}
Aurora.UpdateAlert = UpdateAlert

-- 加载StdUi库
local StdUi = LibStub("AuroraStdUi")

-- GUI相关变量
UpdateAlert.frame = nil
UpdateAlert.messageLabel = nil
UpdateAlert.closeButton = nil

-- 获取客户端语言
local clientLocale = GetLocale() or "enUS" -- 设置默认值以防获取失败
local isChineseClient = clientLocale == "zhCN" or clientLocale == "zhTW"

-- 多语言文本获取函数
local function getLocalizedText(zhText, enText)
    return isChineseClient and zhText or enText
end
-- 初始化GUI
function UpdateAlert:Initialize()
    if self.frame then
        self.frame:Show()
        return
    end

    self:CreateMainFrame()
    self:CreateMessageLabel()
    self:CreateCloseButton()
end

-- 创建主窗口
function UpdateAlert:CreateMainFrame(title)
    -- 如果没有提供标题，使用默认标题
    title = title or "提示"
    
    local frame = StdUi:Window(UIParent, 400, 330, getLocalizedText("提示", "Alert"))
    
    -- 移除右上角关闭按钮
    if frame.closeBtn then
        frame.closeBtn:Hide()
    end
    
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
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetFrameStrata("DIALOG")
    
    self.frame = frame
end

-- 创建消息标签
function UpdateAlert:CreateMessageLabel()
    local frame = self.frame
    
    -- 消息标签
    self.messageLabel = StdUi:Label(frame, "这是一条更新提示信息。", 12)
    self.messageLabel:SetPoint("CENTER", frame, "CENTER", 0, 20)
    self.messageLabel:SetWidth(300)
    self.messageLabel:SetJustifyH("CENTER")
    self.messageLabel:SetJustifyV("MIDDLE")
    self.messageLabel:SetWordWrap(true)
    
    -- 设置文字颜色为绿色
    self.messageLabel:SetTextColor(0, 1, 0, 1)  -- RGBA格式：红色0，绿色1，蓝色0，透明度1
end

-- 创建关闭按钮
function UpdateAlert:CreateCloseButton()
    local frame = self.frame
    
    -- 关闭按钮
    self.closeButton = StdUi:Button(frame, 90, 25, getLocalizedText("确定", "Confirm"))
    self.closeButton:SetPoint("CENTER", frame, "CENTER", 0, -131)
    
    -- 设置按钮为红色
    if self.closeButton.texture then
        self.closeButton.texture:SetColorTexture(1, 0.2, 0.2, 1)
    end
    
    self.closeButton:SetScript("OnClick", function() 
        self:CloseWindow() 
    end)
end

-- 关闭窗口
function UpdateAlert:CloseWindow()
    if self.frame then
        self.frame:Hide()
    end
end

-- 显示窗口
function UpdateAlert:ShowWindow(messages)
    -- 准备窗口标题
    local windowTitle = "提示"
    
    -- 如果提供了消息并且是表类型，使用第一条消息作为窗口标题
    if messages and type(messages) == "table" and messages[1] then
        windowTitle = messages[1]
    elseif messages then
        -- 单条消息情况
        windowTitle = tostring(messages)
    end
    
    -- 初始化窗口（使用第一条消息作为标题）
    if not self.frame then
        self:CreateMainFrame(windowTitle)
        self:CreateMessageLabel()
        self:CreateCloseButton()
    else
        -- 如果窗口已存在，更新标题
        if self.frame.title then
            self.frame.title:SetText(windowTitle)
        end
    end
    
    -- 如果提供了消息，则更新标签内容
    if messages then
        local messageText = ""
        
        -- 检查messages是否为表（数组）
        if type(messages) == "table" then
            -- 处理多条消息，每条消息间隔5个单位（使用两个换行符增加间距）
            messageText = table.concat(messages, "\n\n")
        else
            -- 处理单条消息（向后兼容）
            messageText = tostring(messages)
        end
        
        self.messageLabel:SetText(messageText)
    end
    
    self.frame:Show()
end

-- 测试显示窗口（用于调试）
function UpdateAlert:TestShow()
    self:ShowWindow("这是一条测试更新消息。")
end

-- 保持原有return语句以兼容require方式
return UpdateAlert
end
if player.spec == 2 then
-- 初始化Aurora全局表（如果不存在）
Aurora = Aurora or {}

-- 初始化UpdateAlert模块并添加到Aurora全局表
local UpdateAlert = Aurora.UpdateAlert or {}
Aurora.UpdateAlert = UpdateAlert

-- 加载StdUi库
local StdUi = LibStub("AuroraStdUi")

-- GUI相关变量
UpdateAlert.frame = nil
UpdateAlert.messageLabel = nil
UpdateAlert.closeButton = nil

-- 获取客户端语言
local clientLocale = GetLocale() or "enUS" -- 设置默认值以防获取失败
local isChineseClient = clientLocale == "zhCN" or clientLocale == "zhTW"

-- 多语言文本获取函数
local function getLocalizedText(zhText, enText)
    return isChineseClient and zhText or enText
end
-- 初始化GUI
function UpdateAlert:Initialize()
    if self.frame then
        self.frame:Show()
        return
    end

    self:CreateMainFrame()
    self:CreateMessageLabel()
    self:CreateCloseButton()
end

-- 创建主窗口
function UpdateAlert:CreateMainFrame(title)
    -- 如果没有提供标题，使用默认标题
    title = title or "提示"
    
    local frame = StdUi:Window(UIParent, 300, 330, getLocalizedText("提示", "Alert"))
    
    -- 移除右上角关闭按钮
    if frame.closeBtn then
        frame.closeBtn:Hide()
    end
    
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
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetFrameStrata("DIALOG")
    
    self.frame = frame
end

-- 创建消息标签
function UpdateAlert:CreateMessageLabel()
    local frame = self.frame
    
    -- 消息标签
    self.messageLabel = StdUi:Label(frame, "这是一条更新提示信息。", 12)
    self.messageLabel:SetPoint("CENTER", frame, "CENTER", 0, 20)
    self.messageLabel:SetWidth(300)
    self.messageLabel:SetJustifyH("CENTER")
    self.messageLabel:SetJustifyV("MIDDLE")
    self.messageLabel:SetWordWrap(true)
    
    -- 设置文字颜色为绿色
    self.messageLabel:SetTextColor(0, 1, 0, 1)  -- RGBA格式：红色0，绿色1，蓝色0，透明度1
end

-- 创建关闭按钮
function UpdateAlert:CreateCloseButton()
    local frame = self.frame
    
    -- 关闭按钮
    self.closeButton = StdUi:Button(frame, 90, 25, getLocalizedText("确定", "Confirm"))
    self.closeButton:SetPoint("CENTER", frame, "CENTER", 0, -131)
    
    -- 设置按钮为红色
    if self.closeButton.texture then
        self.closeButton.texture:SetColorTexture(1, 0.2, 0.2, 1)
    end
    
    self.closeButton:SetScript("OnClick", function() 
        self:CloseWindow() 
    end)
end

-- 关闭窗口
function UpdateAlert:CloseWindow()
    if self.frame then
        self.frame:Hide()
    end
end

-- 显示窗口
function UpdateAlert:ShowWindow(messages)
    -- 准备窗口标题
    local windowTitle = "提示"
    
    -- 如果提供了消息并且是表类型，使用第一条消息作为窗口标题
    if messages and type(messages) == "table" and messages[1] then
        windowTitle = messages[1]
    elseif messages then
        -- 单条消息情况
        windowTitle = tostring(messages)
    end
    
    -- 初始化窗口（使用第一条消息作为标题）
    if not self.frame then
        self:CreateMainFrame(windowTitle)
        self:CreateMessageLabel()
        self:CreateCloseButton()
    else
        -- 如果窗口已存在，更新标题
        if self.frame.title then
            self.frame.title:SetText(windowTitle)
        end
    end
    
    -- 如果提供了消息，则更新标签内容
    if messages then
        local messageText = ""
        
        -- 检查messages是否为表（数组）
        if type(messages) == "table" then
            -- 处理多条消息，每条消息间隔5个单位（使用两个换行符增加间距）
            messageText = table.concat(messages, "\n\n")
        else
            -- 处理单条消息（向后兼容）
            messageText = tostring(messages)
        end
        
        self.messageLabel:SetText(messageText)
    end
    
    self.frame:Show()
end

-- 测试显示窗口（用于调试）
function UpdateAlert:TestShow()
    self:ShowWindow("这是一条测试更新消息。")
end

-- 保持原有return语句以兼容require方式
return UpdateAlert
end