name = "zy'mod"
description = "服务器自用"
author = "zy"
version = "0.32"

forumthread = ""

api_version = 10
dst_compatible = true
priority = -10000000000000000000000
--priority = 1

dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = false
client_only_mod = false
server_only_mod = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {"萤火"}

configuration_options ={
    {
        name = "base",
        label = "原版修改",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "baseCombatCanAttackDeath",
        label = "即使怪物死亡也可以进行攻击",
        hover = "鞭尸",
        options = {
            {description = "禁止", data = false},
            {description = "不禁止", data = true},
        },
        default = false
    },
    {
        name = "baseRandomDamageLow",
        label = "随机伤害",
        hover = "怪物有一个随机减伤",
        options = {
            {description = "禁止", data = 0},
            {description = "0.9-1", data = 0.1},
            {description = "0.8-1", data = 0.2},
            {description = "0.4-1", data = 0.6},
            {description = "0.2-1", data = 0.8},
            {description = "0-1", data = 1},
        },
        default = 0
    },
    {
        name = "baseBossGrowth",
        label = "简单boss加强",
        hover = "给boss添加一些加强",
        options = {
            {description = "不加强", data = 0},
            {description = "稍微加强", data = 1},
            {description = "一般加强", data = 2},
            {description = "困难加强", data = 3},
        },
        default = 2
    },
    {
        name = "baseDropDisappear",
        label = "掉落物品一段时间消失",
        hover = "垃圾解决方案",
        options = {
            {description = "关闭", data = 0},
            {description = "60s后消失", data = 60},
            {description = "半天后消失", data = 4*60},
            {description = "1天后消失", data = 8*60},
            {description = "2天后消失", data = 2*8*60},
            {description = "5天后消失", data = 5*8*60},
        },
        default = 4*60
    },
    {
        name = "myth",
        label = "神话设置",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "mythBlackBearRockClearTime",
        label = "黑熊岩石清理",
        hover = "一定时间后清理黑熊出来的岩石",
        options =
        {
            {description = "不清理", data = -1},
            {description = "4分后清理", data = 4 * 60},
            {description = "8分后清理", data = 8 * 60},
            {description = "16分后清理", data = 16 * 60},
            {description = "32分后清理", data = 32 * 60},
        },
        default = 4*60,
    },
    {
        name = "mythFlyingSpeedMultiplier",
        label = "腾云术附带移动加成",
        hover = "腾云术附带部分移动速度加成",
        options =
        {
            {description = "不附带", data = 0},
            {description = "附带25%", data = 0.25},
            {description = "附带50%", data = 0.5},
            {description = "附带75%", data = 0.75},
            {description = "附带100%", data = 1},
            {description = "附带150%", data = 1.5},
            {description = "附带200%", data = 2},
        },
        default = 1,
    },
    {
        name = "achievementAndShop",
        label = "成就商店",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "canNotSellItemsBySora",
        label = "因为穹不能售卖一些东西",
        hover = "限制穹刷商店",
        options = {
            {description = "不禁止", data = false},
            {description = "禁止", data = true},
        },
        default = true
    },
    {
        name = "soraSellNotHalf",
        label = "穹25级卖东西不减半",
        hover = "稍微加强后期穹对商店的用法",
        options = {
            {description = "减半", data = false},
            {description = "不减半", data = true},
        },
        default = true
    },
    {
        name = "soraSellPriceByLevel",
        label = "穹卖东西有折扣",
        hover = "限制穹刷商店,随着等级上升（0.4-1）",
        options = {
            {description = "不限制", data = false},
            {description = "限制", data = true},
        },
        default = true
    },
    {
        name = "achievementGetMorePoints",
        label = "成就获得更多成就点",
        hover = "用来补偿一些阴间成就",
        options = {
            {description = "关闭", data = 0},
            {description = "稍微加强", data = 1},
            {description = "一般加强", data = 2},
            {description = "巨大加强", data = 4},
        },
        default = 2
    },
    {
        name = "achievementMaxBuy",
        label = "限制消费",
        hover = "避免购买过多东西,每天上限系数为设置值*（1+天数/100）",
        options = {
            {description = "关闭", data = 0},
            {description = "1000", data = 1},
            {description = "2000", data = 2},
            {description = "5000", data = 5},
            {description = "10000", data = 10},
            {description = "20000", data = 20},
            {description = "50000", data = 50},
        },
        default = 10
    },
    {
        name = "achievementMaxBuyMode",
        label = "限制消费模式",
        hover = "多种消费限制模式",
        options = {
            {description = "每日刷新上限", data = 0},
            {description = "根据生存天数积累", data = 1},
        },
        default = 0
    },
    {
        name = "totooria",
        label = "托托莉",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "totooriaMultipleStewer",
        label = "双倍收锅改为多倍收锅",
        hover = "根据人物三围总和计算收锅次数",
        options = {
            {description = "禁止", data = 0},
            {description = "每多200多收一个", data = 200},
            {description = "每多100多收一个", data = 100},
            {description = "每多75多收一个", data = 75},
            {description = "每多50多收一个", data = 50},
            {description = "每多25多收一个", data = 25},
        },
        default = 100
    },
    {
        name = "totooriaMultipleStewerWithHeadchefCertificate",
        label = "多倍收锅是否因为主厨勋章获得加成",
        hover = "装备主厨勋章获得食物会更加多",
        options = {
            {description = "禁止", data = 0},
            {description = "多20%", data = 0.2},
            {description = "多40%", data = 0.4},
            {description = "多50%", data = 0.5},
            {description = "多80%", data = 0.8},
            {description = "多100%", data = 1},
            {description = "多150%", data = 1.5},
            {description = "多200%", data = 2},
        },
        default = 1
    },
    {
        name = "totooriaMultipleStewerFur",
        label = "多倍收锅是否包括丹炉",
        hover = "丹炉只能获得1/3",
        options = {
            {description = "不包括", data = false},
            {description = "包括", data = true},
        },
        default = true
    },
    {
        name = "totooriaPhilosopherstoneEatLimit",
        label = "限制吃东西贤者之石经验获取",
        hover = "设置每次获得上限，托托莉为双倍",
        options = {
            {description = "不限制", data = 0},
            {description = "每次最多修1%", data = 1},
            {description = "每次最多修2%", data = 2},
            {description = "每次最多修4%", data = 4},
            {description = "每次最多修5%", data = 5},
            {description = "每次最多修10%", data = 10},
        },
        default = 1
    },
    {
        name = "totooriaPhilosopherstoneLimit",
        label = "限制一些机制回复贤者宝石的耐久",
        hover = "比如穹箱，成就",
        options = {
            {description = "不改变", data = false},
            {description = "限制", data = true},
        },
        default = true
    },
    {
        name = "totooriaPhilosopherstoneKJKLimit",
        label = "怠惰科技锟斤拷限制对贤者使用",
        options = {
            {description = "不限制", data = false},
            {description = "限制", data = true},
        },
        default = true
    },
    {
        name = "chogath",
        label = "大虫子（虚空恐惧）",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "chogathSkillOneDamageImprove",
        label = "吃附带更高的攻击倍率",
        hover = "比如神话丹药等",
        options = {
            {description = "不附带", data = false},
            {description = "附带", data = true},
        },
        default = true
    },
    {
        name = "chogathSkillOneCDImprove",
        label = "吃cd改善",
        hover = "吃没有杀死敌人cd会减少",
        options = {
            {description = "不改变", data = 1},
            {description = "减少为原来的一半", data = 0.5},
            {description = "减少为原来的30%", data = 0.3},
            {description = "减少为原来的20%", data = 0.2},
            {description = "减少为原来的10%", data = 0.1},
        },
        default = 0.1
    },
    {
        name = "chogathSkillOneGetMoreSoul",
        label = "获得更多灵魂",
        hover = "根据杀死怪物血量的开方获得更多灵魂，系数越大获得越少",
        options = {
            {description = "不改变", data = 0},
            {description = "系数10", data = 10},
            {description = "系数20", data = 20},
            {description = "系数30", data = 30},
            {description = "系数40", data = 40},
        },
        default = 10
    },
    {
        name = "sora",
        label = "穹",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "soraRemoveDeathExpByLevel",
        label = "减免死亡惩罚",
        hover = "穹一定等级后死亡不掉落经验",
        options = {
            {description = "不改变", data = -1},
            {description = "10级", data = 10},
            {description = "15级", data = 15},
            {description = "20级", data = 20},
            {description = "25级", data = 25},
            {description = "30级", data = 30},
        },
        default = 20
    },
    {
        name = "soraRemoveRollExpByLevel",
        label = "减免换人惩罚",
        hover = "穹一定等级后换人不掉落经验",
        options = {
            {description = "不改变", data = -1},
            {description = "10级", data = 10},
            {description = "15级", data = 15},
            {description = "20级", data = 20},
            {description = "25级", data = 25},
            {description = "30级", data = 30},
        },
        default = 20
    },
    {
        name = "soraHealDeath",
        label = "愈还原",
        hover = "鞭尸",
        options = {
            {description = "不改变", data = false},
            {description = "还原", data = true},
        },
        default = false
    },
    {
        name = "soraRepairerToPhilosopherStoneLimit",
        label = "限制缝纫包修贤者宝石",
        hover = "",
        options = {
            {description = "不改变", data = 0},
            {description = "修0.5%", data = 0.005},
            {description = "修1%", data = 0.01},
            {description = "修2%", data = 0.02},
            {description = "修5%", data = 0.05},
            {description = "修10%", data = 0.1},
            {description = "修20%", data = 0.2},
        },
        default = 0.01
    },
    {
        name = "soraFastMaker",
        label = "制作速度更快！",
        hover = "装备荣誉勋章或穹与巧手勋章可以提高制作速度！穹30级进一步提高。",
        options = {
            {description = "不改变", data = false},
            {description = "提高", data = true},
        },
        default = true
    },
    {
        name = "soraDoubleMaker",
        label = "一定等级解锁双倍制作",
        hover = "",
        options = {
            {description = "不改变", data = -1},
            {description = "一开始", data = 0},
            {description = "5级", data = 5},
            {description = "10级", data = 10},
            {description = "15级", data = 15},
            {description = "20级", data = 20},
            {description = "25级", data = 25},
            {description = "30级", data = 30},
        },
        default = 30
    },
    {
        name = "soraRemoveExpLimit",
        label = "穹黑名单互助会",
        hover = "不懂别开，小心上黑名单",
        options = {
            {description = "不改变", data = -1},
            {description = "75上限", data = 75},
            {description = "100上限", data = 100},
            {description = "120上限", data = 120},
        },
        default = -1
    },
    {
        name = "soraPackLimit",
        label = "限制打包",
        hover = "禁止穹打包一些独有的东西，比如猪王等。",
        options = {
            {description = "限制", data = true},
            {description = "不限制", data = false},
        },
        default = true
    },
    {
        name = "sora2swordEnhance",
        label = "武器加强",
        hover = "禁止穹打包一些独有的东西，比如猪王等。",
        options = {
            {description = "限制", data = true},
            {description = "不限制", data = false},
        },
        default = true
    },
    {
        name = "carney",
        label = "卡尼猫",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "carneyUseSetGold",
        label = "猫刀可以成组给予",
        hover = "简化磨刀过程，同时为后续修改的前置（其实是懒得分离代码）",
        options = {
            {description = "不可以", data = false},
            {description = "可以", data = true},
        },
        default = true
    },
    {
        name = "carneyWindyKnifeMaxDamage",
        label = "猫刀上限(必须打开成组给予)",
        options = {
            {description = "无", data = -1},
            {description = "90", data = 90},
            {description = "150", data = 150},
            {description = "200", data = 200},
            {description = "300", data = 300},
            {description = "500", data = 500},
            {description = "1000", data = 1000},
        },
        default = 300
    },
    {
        name = "carneyGoldPerDamage",
        label = "猫刀升级难度(必须打开成组给予)",
        options = {
            {description = "5金一攻", data = 5},
            {description = "10金一攻", data = 10},
            {description = "20金一攻", data = 20},
            {description = "40金一攻", data = 40},
        },
        default = 10
    },
    {
        name = "taizhen",
        label = "太真",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "taizhenImproveXX",
        label = "修仙加强",
        hover = "平方增强就是开始摇尾巴10级只有10*10的加强，后期是100*100，所以请务必定向修仙",
        options = {
            {description = "不加强", data = 0},
            {description = "线性加强（X2）", data = 2},
            {description = "线性加强（X3）", data = 3},
            {description = "线性加强（X5）", data = 5},
            {description = "线性加强（X8）", data = 8},
            {description = "线性加强（X10）", data = 10},
            {description = "平方增强（后期强）", data = 1},
        },
        default = 1
    },
    {
        name = "taizhenMaxPill",
        label = "进化药上限",
        hover = "主要是规避体型过大的问题",
        options = {
            {description = "没有", data = 0},
            {description = "10个", data = 10},
            {description = "20个", data = 20},
            {description = "30个", data = 30},
            {description = "50个", data = 50},
            {description = "100个", data = 100},
        },
        default = 10
    },
    {
        name = "huli",
        label = "大狐狸及衍生",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "huliShopFix",
        label = "大狐狸商店部分修正",
        hover = "关闭商店将不能购买物品",
        options = {
            {description = "不修正", data = false},
            {description = "修正", data = true},
        },
        default = true
    },
    {
        name = "lazyTech",
        label = "怠惰科技",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "lazyTechKJKLimit",
        label = "锟斤拷限制",
        hover = "进行进一步限制",
        options = {
            {description = "不限制", data = ""},
            {description = "仅对可装备的物品有效", data = "equipment"},
            {description = "仅对武器和衣物有效", data = "weaponAndClothing"},
            {description = "仅对衣物有效", data = "clothing"},
            {description = "仅对武器有效", data = "weapon"},
        },
        default = "weaponAndClothing"
    },
    {
        name = "randomSize",
        label = "随机生物大小",
        options = {{description = "", data = ""}},
        default = ""
    },
    {
        name = "randomSizeLimit",
        label = "限制生物",
        hover = "只对个别生物随机生物大小有效",
        options = {
            {description = "不限制", data = false},
            {description = "限制", data = true},
        },
        default = true
    },
    {
        name = "randomSizeEnhance",
        label = "生物加强",
        hover = "数据包情况下进一步进行加强",
        options = {
            {description = "加强", data = 0},
            {description = "简单加强", data = 2},
            {description = "一般加强", data = 3},
            {description = "bt加强", data = 5},
        },
        default = 2
    },
}
