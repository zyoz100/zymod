local _G = GLOBAL;
local randomSizeLimit = GetModConfigData("randomSizeLimit") or false;
local randomSizeEnhance = GetModConfigData("randomSizeEnhance") or 0;
if randomSizeEnhance < 2 then
    randomSizeEnhance = 2
end
if randomSizeLimit then
    --小型生物列表
    local a = {
        "spider", --蜘蛛
        "spider_warrior", --蜘蛛战士
        "spider_moon", --破碎蜘蛛
        "spider_hider", --洞穴蜘蛛
        "spider_spitter", --喷射蜘蛛
        "spider_dropper", --穴居悬蛛
        "tentacle_pillar_arm", --小触手
        "spider_healer", --护士蜘蛛
        "knight", --发条骑士
        "bishop", --发条主教
        "rook", --发条战车
        "eyeturret", --眼睛炮塔
        "eyeturret_item", --眼睛炮塔
        "deer_red", --
        "deer_blue", --
        "birdcage", --鸟笼
        "mandrake_planted", --曼德拉草
        "ghost", --幽灵
        "woodpecker", --
        "penguin", --企鸥
        "mutated_penguin", --月岩企鸥
        "balloons", --
        "deerclops_eyeball", --独眼巨鹿眼球
        "gift", --礼物
        "bundle", --捆绑物资
        "stalker_minion1", --
        "mandrake_active", --曼德拉草
        "gingerbreadpig", --姜饼猪
        "killerbee", --杀人蜂
        "mossling", --麋鹿鹅幼崽
        "bat", --洞穴蝙蝠
        "slurtle", --蛞蝓龟
        "tentacle", --触手
        "butter", --黄油
        "messagebottle", --瓶中信
        "messagebottle_throwable", --
        "stalker_minion2", --
        "stafflight", --矮星
        "gingerdeadpig", --姜饼猪
        "smallbird", --小鸟
        "pigman", --猪人
        "smallbird", --小鸟
        "teenbird", --小高脚鸟
        "dustmoth", --尘蛾
        "scarecrow", --友善的稻草人
        "messagebottleempty", --空瓶子
        "stalker_minion", --编织暗影
        "moonpig", --
        "mandrake", --曼德拉草
        "staffcoldlight", --极光
        "moonbutterfly", --月蛾
        "wobster_sheller_dead_cooked", --美味的龙虾
        "wobster_sheller_dead", --死龙虾
        "houndbone", --犬骨
        "trap_starfish", --海星
        "dug_trap_starfish", --海星陷阱
        "moonhound", --
        "thurible", --暗影香炉
        "robin_winter", --雪雀
        "crow", --乌鸦
        "canary", --金丝雀
        "buzzard", --秃鹫
        "bunnyman", --兔人
        "worm", --洞穴蠕虫
        "pondfish", --淡水鱼
        "cookiecutter_spawner", --
        "oceanfish_shoalspawner", --
        "houndfire", --火
        "krampus_sack", --坎普斯背包
        "oceanfish_small_1_inv", --小孔雀鱼
        "oceanfish_small_1", --小孔雀鱼
        "oceanfish_small_2_inv", --针鼻喷墨鱼
        "oceanfish_small_2", --针鼻喷墨鱼
        "oceanfish_small_3_inv", --小饵鱼
        "oceanfish_small_3", --小饵鱼
        "nightlight", --魂灯
        "oceanfish_small_4_inv", --三文鱼苗
        "oceanfish_small_4", --三文鱼苗
        "oceanfish_small_5_inv", --爆米花鱼
        "oceanfish_small_5", --爆米花鱼
        "oceanfish_small_6_inv", --落叶比目鱼
        "oceanfish_small_6", --落叶比目鱼
        "tornado", --龙卷风
        "oceanfish_small_7_inv", --花朵金枪鱼
        "oceanfish_small_7", --花朵金枪鱼
        "oceanfish_small_8_inv", --炽热太阳鱼
        "oceanfish_small_8", --炽热太阳鱼
        "oceanfish_small_9_inv", --口水鱼
        "oceanfish_small_9", --口水鱼
        "lightning", --闪电
        "oceanfish_medium_1_inv", --泥鱼
        "oceanfish_medium_1", --泥鱼
        "oceanfish_medium_2_inv", --斑鱼
        "oceanfish_medium_2", --斑鱼
        "oceanfish_medium_3_inv", --浮夸狮子鱼
        "oceanfish_medium_3", --浮夸狮子鱼
        "eel", --鳗鱼
        "oceanfish_medium_4_inv", --黑鲶鱼
        "oceanfish_medium_4", --黑鲶鱼
        "oceanfish_medium_5_inv", --玉米鳕鱼
        "oceanfish_medium_5", --玉米鳕鱼
        "oceanfish_medium_6_inv", --花锦鲤
        "oceanfish_medium_6", --花锦鲤
        "fireflies", --萤火虫
        "oceanfish_medium_7_inv", --金锦鲤
        "oceanfish_medium_7", --金锦鲤
        "oceanfish_medium_8_inv", --冰鲷鱼
        "oceanfish_medium_8", --冰鲷鱼
        "oceanfish_medium_9_inv", --甜味鱼
        "oceanfish_medium_9", --甜味鱼
        "lavae_egg", --岩浆虫卵
        "lavae_egg_cracked", --岩浆虫卵
        "lavae_tooth", --岩浆虫尖牙
        "lavae_cocoon", --冷冻虫卵
        "spoiled_fish", --变质的鱼
        "spoiled_fish_small", --坏掉的小鱼
        "friendlyfruitfly", --友好果蝇
        "fruitfly", --果蝇
        "lordfruitfly", --果蝇王
        "merm", --鱼人
        "mermguard", --忠诚鱼人守卫
        "mermthrone", --皇家地毯
        "mermthrone_construction", --皇家手工套装
        "shadowmeteor", --流星
        "archive_cookpot", --远古窑
        "winter_twiggytree", --
        "winter_deciduoustree", --
        "snurtle", --蜗牛龟
        "rocky", --石虾
        "slurper", --啜食者
        "deer", --无眼鹿
        "bee", --蜜蜂
        "butterfly", --蝴蝶
        "mosquito", --蚊子
        "rabbit", --兔子
        "wobster_sheller_land", --龙虾
        "wobster_sheller", --龙虾
        "wobster_moonglass", --月光龙虾
        "wobster_moonglass_land", --
        "robin", --红雀
        "puffin", --海鹦鹉
        "squid", --鱿鱼
        "gnarwail", --一角鲸
        "cookiecutter", --饼干切割机
        "chester", --切斯特
        "hutch", --哈奇
        "glommer", --格罗姆
        "mutated_hound", --
        "fruitdrugon", --
        "shark", --岩石大白鲨
        "waterplant", --海草
        "canary_poisoned", --金丝雀（中毒）
        "spore_moon", --月亮孢子
        "spore_medium", --红色孢子
        "spore_small", --绿色孢子
        "spore_tall", --蓝色孢子
        "carrot", --胡萝卜
        "carrot_planted", --胡萝卜
        "moonrock_pieces", --月亮石碎块
        "winter_tree", --冬季圣诞树
        "dead_sea_bones", --海骨
        "asparagus_oversized", --巨型芦笋
        "asparagus_oversized_rotten", --巨型腐烂芦笋
        "carrot_oversized", --巨型胡萝卜
        "carrot_oversized_rotten", --巨型腐烂胡萝卜
        "corn_oversized", --巨型玉米
        "corn_oversized_rotten", --巨型腐烂玉米
        "asparagus_oversized_waxed", --
        "carrot_oversized_waxed", --
        "corn_oversized_waxed", --
        "rock_ice", --迷你冰川
        "dragonfruit_oversized_waxed", --
        "durian_oversized_waxed", --
        "eggplant_oversized_waxed", --
        "garlic_oversized_waxed", --
        "onion_oversized_waxed", --
        "pepper_oversized_waxed", --
        "pomegranate_oversized_waxed", --
        "potato_oversized_waxed", --
        "pumpkin_oversized_waxed", --
        "dirtpile", --可疑的土堆
        "animal_track", --动物足迹
        "moonrockseed", --天体宝球
        "chester_eyebone", --眼骨
        "hutch_fishbowl", --星空
        "magmafire", --
        "hound_lightning", --
        "lavalight", --
        "shadow_telport_out", --
        "shadow_shield1", --
        "shadow_shield2", --
        "shadow_shield3", --
        "shadow_shield4", --
        "shadow_shield5", --
        "shadow_shield6", --
        "shadowhand", --
        "shadowhand_arm", --
        "creepyeyes", --
        "shadowwatcher", --
        "shadowskittish", --
        "shadowchanneler        ", --
        "tomato_oversized_waxed", --
        "watermelon_oversized_waxed", --
        "trophyscale_oversized_waxedveggies", --
        "wicker_tentacle", --
        "cinnamon_tree", --
        "eyeplant", --眼球草
        "shadow_teleporter", --
        "waterstreak_burst", --
        "raindrop", --
        "dragonfruit_oversized", --巨型火龙果
        "dragonfruit_oversized_rotten", --巨型腐烂火龙果
        "durian_oversized", --巨型榴莲
        "durian_oversized_rotten", --巨型腐烂榴莲
        "eggplant_oversized", --巨型茄子
        "eggplant_oversized_rotten", --巨型腐烂茄子
        "garlic_oversized", --巨型大蒜
        "garlic_oversized_rotten", --巨型腐烂大蒜
        "onion_oversized", --巨型洋葱
        "onion_oversized_rotten", --巨型腐烂洋葱
        "pepper_oversized", --巨型辣椒
        "pepper_oversized_rotten", --巨型腐烂辣椒
        "pomegranate_oversized", --巨型石榴
        "pomegranate_oversized_rotten", --巨型腐烂石榴
        "potato_oversized", --巨型土豆
        "potato_oversized_rotten", --巨型腐烂土豆
        "pumpkin_oversized", --巨型南瓜
        "pumpkin_oversized_rotten", --巨型腐烂南瓜
        "tomato_oversized", --巨型番茄
        "tomato_oversized_rotten", --巨型腐烂番茄
        "watermelon_oversized", --巨型西瓜
        "watermelon_oversized_rotten", --巨型腐烂西瓜
        "trophyscale_oversizedveggies", --农产品秤
        "grassgekko", --草壁虎
        "pigguard", --猪人守卫
        "carrat", --胡萝卜鼠
        "birchnutdrake", --桦栗果精
        "mole", --鼹鼠
        "moonbytterfly", --
        "lavae_pet", --超级可爱岩浆虫
        "lavae", --岩浆虫
        "clayhound", --黏土猎犬
        "coontail", --猫尾
        "carnivaldecor_figure", --
        "carnivaldecor_plant", --微型树
        "carnivalcannon_confetti", --彩纸大炮
        "carnivalcannon_sparkle", --亮片大炮
        "carnivalcannon_streamer", --彩带大炮
        "carnivaldecor_eggride1", --迷你摩天轮
        "carnivaldecor_eggride2", --迷你旋转秋千
        "carnivaldecor_eggride3", --迷你摆锤
        "carnivaldecor_lamp", --盛夏夜灯
        "bird_mutant", --月盲乌鸦
        "stumpling", --
        "fruitbat", --
        "glacialhound", --
        "sporehound", --
        "spider_water", --海黾
        "watertree_pillar", --大树干
        "watertree_root", --大树根
        "grassgator", --草鳄鱼
        "oceanvine", --苔藓藤条
        "coeantree_pillar", --
        "oceantree", --疙瘩树
        "oceantree_cocoon", --
    }
    --合法的列表
    local smallList = {
        "spider", --蜘蛛
        "spider_warrior", --蜘蛛战士
        "spider_moon", --破碎蜘蛛
        "spider_hider", --洞穴蜘蛛
        "spider_spitter", --喷射蜘蛛
        "spider_dropper", --穴居悬蛛
        "tentacle_pillar_arm", --小触手
        "spider_healer", --护士蜘蛛
        "knight", --发条骑士
        "bishop", --发条主教
        "rook", --发条战车
        "ghost", --幽灵
        "woodpecker", --
        "penguin", --企鸥
        "mutated_penguin", --月岩企鸥
        "killerbee", --杀人蜂
        "mossling", --麋鹿鹅幼崽
        "bat", --洞穴蝙蝠
        "slurtle", --蛞蝓龟
        "tentacle", --触手
        "pigman", --猪人
        "teenbird", --小高脚鸟
        "stalker_minion", --编织暗影
        "buzzard", --秃鹫
        "bunnyman", --兔人
        "worm", --洞穴蠕虫
        "fruitfly", --果蝇
        "lordfruitfly", --果蝇王
        "merm", --鱼人
        "mermguard", --忠诚鱼人守卫
        "snurtle", --蜗牛龟
        "rocky", --石虾
        "slurper", --啜食者
        "deer", --无眼鹿
        "rabbit", --兔子
        "pigguard", --猪人守卫
        "birchnutdrake", --桦栗果精
        "clayhound", --黏土猎犬
        "grassgator", --草鳄鱼
    }
    --低倍率
    local b = {
        "beefalo", --皮弗娄牛
        "tallbird", --高脚鸟
        "gingerbreadhouse", --姜饼猪屋
        "mushroomsprout", --孢子帽
        "mushroomsprout_dark", --悲惨的孢子帽
        "koalefant_summer", --考拉象
        "koalefant_winter", --考拉象
        "lightninggoat", --伏特羊
        --"spat", --钢羊
        "perd", --火鸡
        "eyeplant", --眼球草
        "nightmarebeak", --梦魇尖喙
        "crawlingnightmare", --爬行梦魇
        "krampus", --坎普斯
        "monkey", --穴居猴
        "knight_nightmare", --损坏的发条骑士
        "mushgnome", --蘑菇地精
        "archive_centipede", --远古哨兵蜈蚣
        "archive_centipede_husk", --哨兵蜈蚣壳
        "mutatedhound", --恐怖猎犬
        "firehound", --红色猎犬
        "hound", --猎犬
        "houndcorpse", --猎犬
        "icehound", --蓝色猎犬
        "frog", --青蛙
        "gingerbreadwarg", --姜饼座狼
        "malbatross", --邪天翁
        "molebat", --裸鼹鼠蝙蝠
        "pigking", --猪王
        "mermking", --鱼人之王
        "beeguard", --嗡嗡蜜蜂
        "tentacle_pillar", --大触手
        "claywarg", --黏土座狼
        --"warg", --座狼
        --"spiderqueen", --蜘蛛女王
        "vampirebat", --
        "uncompromising_rat", --
        "swilson", --
        "magmahound", --
        "shockworm", --
        "mushroombomb", --炸弹蘑菇
        "mushroombomb_dark", --悲惨的炸弹蘑菇
        "lightninghound", --
        "viperworm", --
        "viperling", --
        "hoodedwidow", --
        "viperlingfriend", --
        "shadow_teleporter_light", --
        "spider_trapdoor", --
        "chimp", --
        "antchovies_group", --
        "aphid", --
        "antlion_sinkhole_lava", --
        "blueberryplant", --
        "bushcrab", --
        "cave_banana_tree", --洞穴香蕉树
        "mushtree_tall", --蓝蘑菇树
        "hooded_mushtree_medium", --
        "hooded_mushtree_small", --
        "hooded_mushtree_tall", --
        "mushtree_medium", --红蘑菇树
        "mushtree_small", --绿蘑菇树
        "snowmong", --
        "snapdragon", --
        "scorpion", --
        "sporecloud", --孢子云
        "pollenmites", --
        "fruitbat", --
        "mock_dragonfly", --
        "mushtree_moon", --月亮蘑菇树
        "gestalt", --虚影
        "gestalt_guard", --大虚影
        "deciduous_root", --桦栗树
        "bishop_nightmare", --损坏的发条主教
        "rook_nightmare", --损坏的发条战车
        "catcoon", --浣猫
        "balloon", --气球
        "bernie_big", --伯尼！
        "lightflier", --球状光虫
        "beehive", --蜂窝
        "critterlab", --岩石巢穴
        "slurtlehole", --蛞蝓龟窝
        "spiderden", --蜘蛛巢
        "spiderden_2", --
        "spiderden_3", --
        "carnival_plaza", --鸦年华树
        "carnivalgame_herding_chick", --追蛋
    }
    --低倍率
    local lowList = {
        "beefalo", --皮弗娄牛
        "tallbird", --高脚鸟
        "mushroomsprout_dark", --悲惨的孢子帽
        "koalefant_summer", --考拉象
        "koalefant_winter", --考拉象
        "lightninggoat", --伏特羊
        --"spat", --钢羊
        "perd", --火鸡
        "krampus", --坎普斯
        "monkey", --穴居猴
        "knight_nightmare", --损坏的发条骑士
        "archive_centipede", --远古哨兵蜈蚣
        "archive_centipede_husk", --哨兵蜈蚣壳
        "mutatedhound", --恐怖猎犬
        "firehound", --红色猎犬
        "hound", --猎犬
        "houndcorpse", --猎犬
        "icehound", --蓝色猎犬
        "frog", --青蛙
        "gingerbreadwarg", --姜饼座狼
        "malbatross", --邪天翁
        "molebat", --裸鼹鼠蝙蝠
        "beeguard", --嗡嗡蜜蜂
        "claywarg", --黏土座狼
        --"warg", --座狼
        --"spiderqueen", --蜘蛛女王
        "bishop_nightmare", --损坏的发条主教
        "rook_nightmare", --损坏的发条战车
        "catcoon", --浣猫
    }
    --特殊
    local c = {
        "critter_dragonling", --小龙蝇
        "critter_glomling", --小格罗姆
        "critter_puppy", --小座狼
        "critter_kitten", --小浣猫
        "klaussackkey", --麋鹿茸
        "pumpkin", --南瓜
        "flower_cave", --荧光花
        "flower_cave_double", --
        "flower_cave_triple", --
        "critter_lamb", --小钢羊
        "critter_kitten", --小浣猫
        "critter_lamb", --小钢羊
        "critter_lunarmothling", --小蛾子
        "molebathill", --裸鼹鼠蝙蝠山丘
        "resurrectionstone", --试金石
        "rabbithole", --兔洞
        "glommerflower", --格罗姆花
        "molehill", --鼹鼠洞
        "critter_perdling", --小火鸡
        "trinket_4", --地精爷爷
        "trinket_13", --地精奶奶
        "trinket_10", --二手假牙
        "trinket_11", --机器人玩偶
        "trinket_12", --干瘪的触手
        "klaus_sack", --赃物袋
        "smallghost", --小惊吓
        "rock_moon", --岩石
        "minotaurhorn", --守护者之角
        "bullkelp_plant", --公牛海带
        "winter_ornament_light1", --
        "winter_ornament_light2", --
        "winter_ornament_light3", --
        "winter_ornament_light4", --
        "winter_ornament_light5", --
        "shadowheart", --暗影心房
        "carrat_ghostracer", --查理的胡萝卜鼠
        "winter_ornament_light6", --
        "winter_ornament_light7", --
        "winter_ornament_light8", --
        "pumpkin_lantern", --南瓜灯
        "cactus", --仙人掌
        "oasis_cactus", --
        "mound", --坟墓
        "marsh_tree", --针刺树
        "antlion_sinkhole", --坑
        "blue_mushroom", --蓝蘑菇
        "green_mushroom", --绿蘑菇
        "red_mushroom", --红蘑菇
        "wasphive", --杀人蜂蜂窝
        "watermelon", --西瓜
        "scorched_skeleton", --易碎骨骼
        "marsh_bush", --尖刺灌木
        "burnt_marsh_bush", --尖刺灌木
        "tallbirdnest", --高脚鸟巢
        "dragon_scales", --鳞片
        "grotto_pool_big", --玻璃绿洲
        "grotto_pool_small", --小玻璃绿洲
        "lightflier_flower", --
        "hermit_pearl", --珍珠的珍珠
        "hermit_cracked_pearl", --开裂珍珠
        "tallbirdegg", --高脚鸟蛋
        "beequeenhivegrown", --巨大蜂窝
        "beequeenhive", --蜂蜜地块
        "dragonflyfurnace", --龙鳞火炉
        "trinket_18", --玩具木马
        "trinket_5", --迷你火箭
        "moonbase", --月亮石
        "oasislake", --湖泊
        "livingtree", --完全正常的树
        "hotspring", --温泉
        "redpouch", --红袋子
        "redpouch_yotc", --
        "redpouch_yotp", --
        "wentacle_pillar_hole", --
        "gargoyle_houndatk", --
        "gargoyle_hounddeath", --
        "gargoyle_werepigatk", --
        "redlantern", --红灯笼
        "wintersfeastfuel", --节日欢愉
        "houndmound", --猎犬丘
        "bird_egg", --鸟蛋
        "trophyscale_fish", --鱼类计重器
        "cave_fern", --蕨类植物
        "marsh_plant", --植物
        "succulent_picked", --多肉植物
        "succulent_plant", --多肉植物
        "pond_algae", --水藻
        "cavein_boulder", --岩石
        "rock1", --岩石
        "rock2", --岩石
        "rock_flintless", --岩石
        "rock_flintless_low", --岩石
        "rock_flintless_med", --岩石
        "rock_moon_shell", --可疑的巨石
        "stalagmite", --石笋
        "stalagmite_tall", --石笋
        "rock_petrified_tree", --石化树
        "lava_pond_rock", --岩石
        "rubble", --碎石
        "statueharp", --竖琴雕像
        "driftwood", --
        "stalagmite_full", --
        "stalagmite_low", --
        "stalagmite_med", --
        "stalagmite_tall_full", --
        "stalagmite_tall_low", --
        "stalagmite_tall_med", --
        "arom", --
        "arong", --
        "arong", --
        "asparagus", --芦笋
        "carrit", --
        "corn", --玉米
        "dragonfruit", --火龙果
        "durian", --榴莲
        "eggplant", --茄子
        "garlic", --大蒜
        "onion", --洋葱
        "pepper", --辣椒
        "pomegranate", --石榴
        "potato", --土豆
        "pumpkin", --南瓜
        "tomato", --番茄
        "driftwood_small1", --
        "driftwood_small2", --
        "driftwood_tall", --
        "driftwood_log", --浮木桩
        "flower_rose", --
        "gravestone", --墓碑
        "meatrack_hermit", --晾肉架
        "monkeybarrel", --穴居猴桶
        "moose_nesting_ground", --
        "gargoyle_werepigdeath", --
        "gargoyle_werepighowl", --
        "livingtree_sapling", --完全正常的树苗
        "livingtree_halloween", --
        "walrus_tusk", --海象牙
        "tumbleweed", --风滚草
        "statueglommer", --格罗姆雕像
        "mooseegg", --
        "saltstack", --盐堆
        "pighead", --猪头
        "pigtorch", --猪火炬
        "mermhead", --鱼人头
        "wormlight_plant", --神秘植物
        "stalker_berry", --
        "statue_marble", --大理石雕像
        "reeds", --芦苇
        "walrus_tusk", --海象牙
        "stagehand", --舞台之手
        "batcave", --蝙蝠洞
        "wortox_soul", --灵魂
        "wortox_soul_spawn", --
    }

    --特殊的建筑 碰撞体积不会跟随大小变化
    local teshujianzhu = {
        "mock_dragonfly", "bird_mutant_spitter", "bird_mutant", "woodpecker", "carnivalgame_herding_chick", "peachtree_myth", "mk_jgb_pillar", "peach", "myth_coin", "myth_cash_tree_ground", "bigpeach", "myth_small_goldfrog", "myth_goldfrog_base", "oasislake", "pigking", "goldnugget", "stalker_minion", "stalker_minion1", "stalker_minion2", "rock1", "pigman", "pigguard", "rocky", "dirtpile", "animal_track", "moonrockseed", "chester_eyebone", "hutch_fishbowl", "krampus_sack", "redpouch_yotp", "redpouch_yotc",
    }

    local shss = {
        "peachtree_myth", "mk_jgb_pillar", "peach", "myth_coin", "myth_cash_tree_ground", "bigpeach", "myth_small_goldfrog", "myth_goldfrog_base",
    }

    local function qianghuaOverride(inst)
        inst.myscale = 1;
        if inst.components.health ~= nil then
            local percent = inst.components.health:GetPercent()
            inst.components.health:SetMaxHealth(math.ceil(inst.components.health.maxhealth * randomSizeEnhance * 2))
            inst.components.health:SetPercent(percent)
        end
        if inst.components.combat then
            inst.components.combat.defaultdamage = math.ceil(inst.components.combat.defaultdamage * randomSizeEnhance * 2)
        end
    end

    for k, v in pairs(a) do
        AddPrefabPostInit(v, function(inst)
            if not _G.TheWorld.ismastersim then
                return inst
            end
            if table.contains(smallList, v) then
                qianghuaOverride(inst, 15)
            else
                inst.myscale = 1;
            end

        end)
    end

    for k, v in pairs(b) do
        AddPrefabPostInit(v, function(inst)
            if not _G.TheWorld.ismastersim then
                return inst
            end
            if table.contains(lowList, v) then
                qianghuaOverride(inst, 15)
            else
                inst.myscale = 1;
            end
        end)
    end

    for k, v in pairs(c) do
        AddPrefabPostInit(v, function(inst)
            if not _G.TheWorld.ismastersim then
                return inst
            end
            inst.myscale = 1;
        end)
    end

    for k, v in pairs(shss) do
        AddPrefabPostInit(v, function(inst)
            if not _G.TheWorld.ismastersim then
                return inst
            end
            inst.myscale = 1;
        end)
    end


end