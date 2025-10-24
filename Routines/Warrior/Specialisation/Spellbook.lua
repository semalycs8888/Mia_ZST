local player = Aurora.UnitManager:Get("player")
if player.spec == 2 then
-- Create your spells
local NewSpell = Aurora.SpellHandler.NewSpell
Aurora.SpellHandler.PopulateSpellbook({
    spells = {
        AutoAttack = NewSpell(6603),
        CHONGFENG = NewSpell(100),
        DUANJIN = NewSpell(1715),
        XUANFENGZHAN = NewSpell(190411),
        XUANFENGZHAN2 = NewSpell(190411),
        FANGYUZITAI = NewSpell(386208),
        TIANSHENXIAFAN = NewSpell(107574),
        FASHUFANSHE = NewSpell(23920),
        JIJIENAHAN = NewSpell(97462),
        ZHANDOUNUHOU = NewSpell(6673),
        KUANGBAOZHINU = NewSpell(18499),
        LEIMINGZHIHOU = NewSpell(384318),
        QUANJI = NewSpell(6552),
        KUANGBAOZITAI = NewSpell(386196),
        ZHENDANGBO = NewSpell(46968),
        FENGBAOZHICHUI = NewSpell(107570),
        ZHANSHA = NewSpell(5308),
        ZHANSHA2 = NewSpell(280735),
        MENGJI = NewSpell(1464),
        JIANRENFENGBAO = NewSpell(446035),
        SHIXUE = NewSpell(23881),
        NUJI = NewSpell(85288),
        BAONU = NewSpell(184367),
        BAONU2 = NewSpell(184367),
        BAONU3 = NewSpell(184367),
        LUMANG = NewSpell(1719),
        YUANHU = NewSpell(3411),
        PODANNUHOU = NewSpell(5246),
        LEITINGYIJI = NewSpell(6343),
        TONGKUMIANYI = NewSpell(383762),
        KUANGBAOZHIHOU = NewSpell(384100),
        CIERNUHOU = NewSpell(12323),
        YONGSHIZHIMAO = NewSpell(376079),
        QIANGGONG = NewSpell(315720),
        AODINGZHINU = NewSpell(385059),
        SHENGLIZAIWANG = NewSpell(202168),
        YINGYONGTOUZHI = NewSpell(57755),
        KUANGBAOHUIFU = NewSpell(184364),
        POLIETOUZHI = NewSpell(384110),
        XIANZUZHAOHUAN = NewSpell(274738),
        -- KUANGBAO = NewSpell(20554),
        XUEXING = NewSpell(20572),
        HEITIE = NewSpell(265221),
        POHUAIZHE = NewSpell(228920),
        QIANGHUAXUANFENGZHAN = NewSpell(12950),

    },
    auras = {
        --Add Auras here
    },
    talents = {
        --Add Talents here
    },
}, "WARRIOR",2,"Mia_Warrior")

end