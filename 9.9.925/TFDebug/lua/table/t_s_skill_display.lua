 
-- 	id = 1, 			
-- 	remote = 0,			是否远程：0近程 1远程
--  zoomIn= 0,          是否拉近镜头：0否 1是
-- 	attackEff = {0},		攻击特效id
-- 	attackEffTime = {0}, 	攻击特效开始时间(毫秒),相对于攻击动作起始点
-- 	attackEffType = {0},  攻击特效类型 0攻击者身上播放 1屏幕中心播放 2打横排 3直线飞行单体 4直线飞行竖排 5攻击者脚下播放 6我方阵容中心播放 7敌方阵容中心播放 8屏幕中心置顶  9我方阵容中心置顶播放 10敌方阵容中心置顶播放  11敌方阵容当前排中心脚下播放 12敌方阵容当前排中心置顶播放
--  hitEffType = {0},  攻击特效类型 0攻击者身上播放 1屏幕中心播放 2打横排 3直线飞行单体 4直线飞行竖排 5攻击者脚下播放 6我方阵容中心播放 7敌方阵容中心播放 8屏幕中心置顶  9我方阵容中心置顶播放 10敌方阵容中心置顶播放 11敌方阵容当前排中心脚下播放 12敌方阵容当前排中心置顶播放
-- 	hitAnimTime1 = 100, 受击动作播放时间(毫秒),相对于攻击动作起始点
-- 	hitEff = { 0}, 		受击特效id 所有受击特效在受击者身上播放
--<---------------------------以上是必填项-------------------------------------->
--<---------------------------以下是选填项-------------------------------------->
--  moveDistance = 0,	当remote = 0,zoomIn= 0 需要移动时,攻击者距离目标的距离 不填默认30
--  movePathType = 0,	当remote = 0,zoomIn= 0 需要移动时,攻击者的移动路径 0直线 1曲线 不填默认直线
--  backPathType = 0,	当remote = 0,zoomIn= 0 需要移动时,攻击者的返回路径 0直线 1曲线 不填默认直线
--  needMoveCenter = 0,	移动到屏幕中心释放 默认0
--  xuliEff = 10101, 	蓄力特效id 不填默认0
--  xuliEffTime = 50,   蓄力特效开始时间(毫秒),相对于攻击动作起始点 不填默认0
--  xuliEffOffsetX= 0,  蓄力特效X偏移量，不填默认0
--  xuliEffOffsetY= 0,  蓄力特效Y偏移量，不填默认0
--  attackEffOffsetX= {0},攻击特效X偏移量，不填默认0
--  attackEffOffsetY= {0},攻击特效Y偏移量，不填默认0
--  flyEffRotate= 0,    飞行特效是否旋转，0不旋转 1旋转 不填默认0
-- 	hitAnimTime2 = 200, 多段攻击时第2次受击动作播放时间(毫秒),相对于攻击动作起始点 最多可配置到hitAnimTime10
-- 	hitAnimTime3 = 300, 多段攻击时第3次受击动作播放时间(毫秒),相对于攻击动作起始点 注意后面的时间一定要比前面大 
--  hitEffOffsetX={ 0},   受击特效X偏移量，不填默认0
--  hitEffOffsetY={ 0},   受击特效Y偏移量，不填默认0
-- 	hitEffTime = {0},		受击特效开始时间(毫秒),相对于受击动作起始点	不填默认0
-- 	hitEffShowOnce = 0,	多次受击时是否只显示一次受击特效 默认0
-- 	attackAnimMove = 1,	攻击动作是否带位移，带位移隐藏血条 默认0
--  attackSound = 1000, 攻击音效，文件夹为Resource\sound\effect
--  attackSoundTime = 100, 攻击音效开始时间(毫秒),相对于攻击动作起始点 不填默认0
--  hitSound = 1001, 	受击音效，文件夹为Resource\sound\effect
--  hitSoundTime = 100, 受击音效开始时间(毫秒),相对于受击动作起始点 不填默认0
--  attackAnim = "attack", 攻击动作名称，不填普攻调用attack 技能调用skill
--  needMoveSameRow = 1,移动到目标同一排释放 默认0
--  beforeMoveAnim = "drink" 移动前播放的动作
--  shake = 10 屏幕抖动值，未填远程默认6，近战默认3
--  extraShowHit = true 额外buff动画是否显示被击打动画
--  extraEff  额外动画参数 类似 hitEff 改成extraEff就好了
--  attackRotation  敌方播放特效是否需要翻转
--  hitRotation  敌方播放特效是否需要翻转
--  showBuffDelayTime 主动Buff延迟时间
--  hitXuliEffType 蓄力特效目标，和普通特效目标类似。新增：13受击目标脚下播放（排除己方，当技能有2种目标时可以使用此类型。例：攻击敌方并给自己加buff）

local mapArray = MEMapArray:new()
--普通攻击
mapArray:push({ id = 9999, remote = 0,zoomIn= 0, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = { 90001},attackAnim = "attack",attackSound = 101,hitSound = 1001})
mapArray:push({ id = 1, remote = 0,zoomIn= 0, moveDistance = 70,attackEff = {100011}, attackEffTime = {0}, moveDistance = 200,attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 500,attackAnim = "attack",attackSound = 101,hitSound = 41})
mapArray:push({ id = 2, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100021}, attackEffTime = {100}, attackEffType = {0},hitAnimTime1 = 350,hitAnimTime2 = 650,hitEff = { 100022},attackAnim = "attack",attackSound = 201,hitSound = 41})
mapArray:push({ id = 3, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100031}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 350,attackAnim = "attack",attackSound = 301,hitSound = 41})
mapArray:push({ id = 4, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100041},attackEffTime = {300}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 300, attackAnim = "attack",attackSound = 401,hitSound = 22})
mapArray:push({ id = 5, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {100051}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 450, hitEff = { 100052},attackSound = 501,hitSound = 32})
mapArray:push({ id = 6, remote = 0,zoomIn= 0, moveDistance = 30,attackEff = {100061}, attackEffTime = {0}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 250,moveDistance = 170,attackAnim = "attack", attackSound = 601,hitSound = 43})
mapArray:push({ id = 7, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100071}, attackEffTime = {30}, attackEffType = {0},hitAnimTime1 = 200, hitEff = { 702},attackAnim = "attack",attackSound = 701,hitSound = 41})
mapArray:push({ id = 8, remote = 0,zoomIn= 0, moveDistance = 140,attackEff = {100081}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 200, attackAnim = "attack",attackSound = 801,hitSound = 21})
mapArray:push({ id = 9, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {100091}, attackEffTime = {700}, attackEffType = {0}, hitEff = { 101022},hitAnimTime1 = 800, attackAnim = "attack",attackSound = 901,hitSound = 42})
mapArray:push({ id = 10, remote = 0,zoomIn= 0, attackEff = {100101}, attackEffTime = {0}, attackEffType = {0}, hitEff = { 101022},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 1001,hitSound = 23})
mapArray:push({ id = 11, remote = 0,zoomIn= 0, moveDistance = 200, attackEff = {100111}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 101022},attackAnim = "attack",attackSound = 1101,hitSound = 21})
mapArray:push({ id = 12, remote = 0,zoomIn= 0, moveDistance = 200, attackEff = {100121}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 101077},attackAnim = "attack",attackSound = 1201,hitSound = 41})
mapArray:push({ id = 13, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100131}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300,hitAnimTime2 = 800,hitAnimTime3 = 1000, hitAnimTime4 = 1300,hitEff = { 101022},attackAnim = "attack",attackSound = 1301,hitSound = 22})
mapArray:push({ id = 14, remote = 0,zoomIn= 0, moveDistance = 250, attackEff = {100141}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = {101044},attackAnim = "attack",attackSound = 1401,hitSound = 32})
mapArray:push({ id = 15, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100151}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 200, hitEff = { 101088},hitEffOffsetX={ 0},hitEffOffsetY={ 0},attackAnim = "attack",attackSound = 1501,hitSound = 21})
mapArray:push({ id = 16, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100161}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250, hitEff = { 101044},attackAnim = "attack",attackSound = 1601,hitSound = 23})
mapArray:push({ id = 17, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100171}, attackEffTime = {180}, attackEffType = {0},hitAnimTime1 = 200, hitEff = { 101022},attackAnim = "attack",attackSound = 1701,hitSound = 42})
mapArray:push({ id = 18, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100181}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 200, hitEff = { 1802},attackAnim = "attack",attackSound = 1801,hitSound = 43})
mapArray:push({ id = 19, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100191}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 200,hitAnimTime2 = 500,hitAnimTime3 = 900, hitEff = { 101055},attackAnim = "attack",attackSound = 1901,hitSound = 23})
mapArray:push({ id = 20, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100201}, attackEffTime = {220}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 2001,hitSound = 32})
mapArray:push({ id = 21, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100211}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 100212},attackAnim = "attack",attackSound = 2101,hitSound = 21})
mapArray:push({ id = 22, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {100221}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 2201,hitSound = 22})
mapArray:push({ id = 23, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100231}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,hitAnimTime2 = 600,attackAnim = "attack",attackSound = 2301,hitSound = 42})
mapArray:push({ id = 24, remote = 0,zoomIn= 0, moveDistance = 170,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 250,hitEff = { 101088},attackAnim = "attack",attackSound = 2401,hitSound = 33})
mapArray:push({ id = 25, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100251}, attackEffTime = {350}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 400,attackAnim = "attack",attackAnim = "attack",attackSound = 2501,hitSound = 23})
mapArray:push({ id = 26, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {100261}, attackEffTime = {200}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 2601,hitSound = 21})
mapArray:push({ id = 27, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100271}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 2701,hitSound = 31})

mapArray:push({ id = 28, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100281}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 2801,hitSound = 42})
mapArray:push({ id = 29, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {100291}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 350,attackAnim = "attack",attackSound = 2901,hitSound = 33})
mapArray:push({ id = 30, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101361}, attackEffTime = {20}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 500,attackAnim = "attack",attackSound = 3001,hitSound = 23})
mapArray:push({ id = 31, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100311}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 3101,hitSound = 42})

mapArray:push({ id = 32, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100321}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 100,attackAnim = "attack",attackSound = 3201,hitSound = 23})
mapArray:push({ id = 33, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100331}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 500,attackAnim = "attack",attackSound = 3301,hitSound = 43})
mapArray:push({ id = 34, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100341}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 3401,hitSound = 33})
mapArray:push({ id = 35, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100351}, attackEffTime = {0}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 150,hitAnimTime2 = 250,attackAnim = "attack",attackSound = 3501,hitSound = 23})

mapArray:push({ id = 36, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {100361}, attackEffTime = {200}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 350,attackAnim = "attack",attackSound = 3601,hitSound = 22})
mapArray:push({ id = 37, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100371}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 350,hitEff = { 3702},attackAnim = "attack",attackSound = 3701,hitSound = 42})
mapArray:push({ id = 38, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {100381}, attackEffTime = {100}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 3801,hitSound = 23})
mapArray:push({ id = 39, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100391}, attackEffTime = {0}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 3901,hitSound = 22})
mapArray:push({ id = 40, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100401}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 150,hitEff = { 4002},attackAnim = "attack",attackSound = 4001,hitSound = 21})
mapArray:push({ id = 41, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100401}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 4002},attackAnim = "attack",attackSound = 4301,hitSound = 21})
mapArray:push({ id = 42, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100431}, attackEffTime = {50}, attackEffType = {0},hitAnimTime1 = 150,hitEff = { 4002},attackAnim = "attack",attackSound = 4301,hitSound = 22})
mapArray:push({ id = 43, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100431}, attackEffTime = {50}, attackEffType = {0},hitAnimTime1 = 150,hitEff = { 4002},attackAnim = "attack",attackSound = 4301,hitSound = 23})

mapArray:push({ id = 44, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100441}, attackEffTime = {0}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 4401,hitSound = 42})
mapArray:push({ id = 45, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100451}, attackEffTime = {330}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 4501,hitSound = 21})
mapArray:push({ id = 46, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100451}, attackEffTime = {330}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 4801,hitSound = 22})
mapArray:push({ id = 47, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100451}, attackEffTime = {330}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 4801,hitSound = 23})
mapArray:push({ id = 48, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100451}, attackEffTime = {330}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 4801,hitSound = 22})
mapArray:push({ id = 49, remote = 0,zoomIn= 0, moveDistance = 90,attackEff = {100041},attackEffTime = {500}, attackEffType = {0},hitAnimTime1 = 350, hitEff = { 100042},attackAnim = "attack",attackSound = 1,hitSound = 21})
mapArray:push({ id = 50, remote = 0,zoomIn= 0, moveDistance = 220,attackEff = {100221}, attackEffTime = {0}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 2201,hitSound = 22})

mapArray:push({ id = 51, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100511}, attackEffTime = {180}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 1701,hitSound = 41})
mapArray:push({ id = 52, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100511}, attackEffTime = {180}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 1701,hitSound = 42})
mapArray:push({ id = 53, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100511}, attackEffTime = {180}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 1701,hitSound = 43})
mapArray:push({ id = 54, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100511}, attackEffTime = {180}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 1701,hitSound = 42})

mapArray:push({ id = 55, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0},attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 100, hitEff = { 402},attackAnim = "attack",attackSound = 5501,hitSound = 21})
mapArray:push({ id = 56, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0},attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 60, hitEff = { 402},attackAnim = "attack",attackSound = 5501,hitSound = 22})
mapArray:push({ id = 57, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0},attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 60, hitEff = { 402},attackAnim = "attack",attackSound = 5501,hitSound = 23})

mapArray:push({ id = 58, remote = 0,zoomIn= 0, moveDistance = 190,attackEff = {100581}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 5501,hitSound = 31})
mapArray:push({ id = 59, remote = 0,zoomIn= 0, moveDistance = 190,attackEff = {100581}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 5501,hitSound = 32})
mapArray:push({ id = 60, remote = 0,zoomIn= 0, moveDistance = 190,attackEff = {100581}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 5501,hitSound = 33})

mapArray:push({ id = 61, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100201}, attackEffTime = {300}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 17701,hitSound = 32})

mapArray:push({ id = 62, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100621}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 20501,hitSound = 42})
mapArray:push({ id = 63, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100621}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 20501,hitSound = 42})
mapArray:push({ id = 64, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100621}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 20501,hitSound = 42})
mapArray:push({ id = 65, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100621}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 20501,hitSound = 42})
mapArray:push({ id = 66, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100621}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 20501,hitSound = 42})

mapArray:push({ id = 68, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 8002},attackAnim = "attack",attackSound = 6801,hitSound = 23})
mapArray:push({ id = 69, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 7002},attackAnim = "attack",attackSound = 6901,hitSound = 23})
mapArray:push({ id = 70, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 150,hitEff = { 8002},attackAnim = "attack",attackSound = 7001,hitSound = 32})

mapArray:push({ id = 71, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 7002},attackAnim = "attack",attackSound = 6801,hitSound = 23})
mapArray:push({ id = 72, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 8002},attackAnim = "attack",attackSound = 6901,hitSound = 23})
mapArray:push({ id = 73, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 150,hitEff = { 7002},attackAnim = "attack",attackSound = 7001,hitSound = 33})
mapArray:push({ id = 74, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 8002},attackAnim = "attack",attackSound = 6801,hitSound = 22})
mapArray:push({ id = 75, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 7002},attackAnim = "attack",attackSound = 6901,hitSound = 22})
mapArray:push({ id = 76, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100711}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 150,hitEff = { 8002},attackAnim = "attack",attackSound = 7001,hitSound = 33})

mapArray:push({ id = 77, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100771}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 230,attackAnim = "attack",hitEff = { 3702},attackAnim = "attack",attackSound = 7701,hitSound = 21})
mapArray:push({ id = 78, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100781}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 230,hitAnimTime2 = 700,hitEff = { 101088},attackAnim = "attack",attackSound = 7801,hitSound = 42})
mapArray:push({ id = 79, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100791}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 250,attackSound = 7901,hitSound = 23})
mapArray:push({ id = 80, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100801}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,hitAnimTime2 = 800, hitEff = { 8002},attackAnim = "attack",attackSound = 8001,hitSound = 32})

mapArray:push({ id = 81, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100811}, attackEffTime = {100}, attackEffType = {0},hitAnimTime1 = 600, hitEff = { 101088},attackAnim = "attack",attackSound = 8101,hitSound = 23})
mapArray:push({ id = 82, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100821}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 300,hitEff = { 8002},attackAnim = "attack",attackSound = 8201,hitSound = 21})
mapArray:push({ id = 83, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100831}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200, hitEff = { 3702},attackAnim = "attack",attackSound = 8301,hitSound = 22})
mapArray:push({ id = 84, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {100841}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 250, hitEff = { 402},attackAnim = "attack",attackSound = 8401,hitSound = 31})
mapArray:push({ id = 85, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100851}, attackEffTime = {150}, attackEffType = {0},hitAnimTime1 = 350, hitEff = {101022},attackAnim = "attack",attackSound = 8501,hitSound = 22})
mapArray:push({ id = 86, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {100861}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 8601,hitSound = 32})
mapArray:push({ id = 87, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100871}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 420,attackAnim = "attack",attackSound = 8701,hitSound = 31})
mapArray:push({ id = 88, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {100881}, attackEffTime = {0}, attackEffType = {0},hitEff = { 402},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 12701,hitSound = 23})
mapArray:push({ id = 89, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100891}, attackEffTime = {200}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 200,hitAnimTime2 = 600,attackAnim = "attack",attackSound = 8901,hitSound = 23})
mapArray:push({ id = 90, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100901}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,hitAnimTime2 = 500,attackAnim = "attack",attackSound = 9001,hitSound = 22})
mapArray:push({ id = 91, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100911}, attackEffTime = {300}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 9101,hitSound = 21})
mapArray:push({ id = 92, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100921}, attackEffTime = {50}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 50,attackAnim = "attack",attackSound = 9201,hitSound = 22})
mapArray:push({ id = 93, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100931}, attackEffTime = {50}, attackEffType = {0},hitEff = {3702},hitAnimTime1 = 130,attackAnim = "attack",attackSound = 9301,hitSound = 23})
mapArray:push({ id = 94, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100941}, attackEffTime = {50}, attackEffType = {0},hitEff = { 402},hitAnimTime1 = 450,attackAnim = "attack",attackSound = 9401,hitSound = 21})
mapArray:push({ id = 95, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {100951}, attackEffTime = {50}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 9501,hitSound = 21})
mapArray:push({ id = 96, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100961}, attackEffTime = {50}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 270,attackAnim = "attack",attackSound = 101,hitSound = 22})
mapArray:push({ id = 97, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {100971}, attackEffTime = {120}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 9701,hitSound = 23})
mapArray:push({ id = 98, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100981}, attackEffTime = {50}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 270,attackAnim = "attack",attackSound = 9801,hitSound = 23})
mapArray:push({ id = 99, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100991}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 200,hitAnimTime2 = 500,attackAnim = "attack",attackSound = 9901,hitSound = 41})

mapArray:push({ id = 100, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101001}, attackEffTime = {120}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 10001,hitSound = 43})
mapArray:push({ id = 101, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101011}, attackEffTime = {50}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 300,hitAnimTime2 = 700,attackAnim = "attack",attackSound = 10101,hitSound = 43})

mapArray:push({ id = 102, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101021}, attackEffTime = {50}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 10201,hitSound = 22})
mapArray:push({ id = 103, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101031}, attackEffTime = {80}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 10301,hitSound = 43})
mapArray:push({ id = 104, remote = 0,zoomIn= 0, moveDistance = 70,attackEff = {101041}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 200,hitAnimTime2 = 700,attackAnim = "attack",attackSound = 10401,hitSound = 21})
mapArray:push({ id = 105, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100921}, attackEffTime = {50}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 1,hitSound = 23})
mapArray:push({ id = 106, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101061}, attackEffTime = {50}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,hitAnimTime2 = 600,attackAnim = "attack",attackSound = 10601,hitSound = 22})
mapArray:push({ id = 107, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101071}, attackEffTime = {200}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 10701,hitSound = 21})
mapArray:push({ id = 108, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101081}, attackEffTime = {0}, attackEffType = {0},hitEff = { 402},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 10801,hitSound = 22})
mapArray:push({ id = 109, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101091}, attackEffTime = {50}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 10901,hitSound = 23})
mapArray:push({ id = 110, remote = 0,zoomIn= 0, moveDistance = 140,attackEff = {101101}, attackEffTime = {50}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 400,hitAnimTime2 = 650,attackAnim = "attack",attackSound = 11001,hitSound = 21})
mapArray:push({ id = 111, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101111}, attackEffTime = {20}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 550,attackAnim = "attack",attackSound = 11101,hitSound = 42})
mapArray:push({ id = 112, remote = 0,zoomIn= 0, moveDistance = 30,attackEff = {100921}, attackEffTime = {50}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 1,hitSound = 21})
mapArray:push({ id = 113, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101131}, attackEffTime = {400}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 11301,hitSound = 42})
mapArray:push({ id = 114, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101141}, attackEffTime = {400}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 11401,hitSound = 21})
mapArray:push({ id = 115, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101151}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 11501,hitSound = 11})
mapArray:push({ id = 116, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101161},  attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 350,attackAnim = "attack",attackSound = 11601,hitSound = 23})
mapArray:push({ id = 117, remote = 0,zoomIn= 0, moveDistance = 250,attackEff = {101171},  attackEffTime = {300}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 11701,hitSound = 23})
mapArray:push({ id = 118, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101181},  attackEffTime = {250}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 350,attackAnim = "attack",attackSound = 11801,hitSound = 22})
mapArray:push({ id = 119, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101131}, attackEffTime = {400}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 11301,hitSound = 41})
mapArray:push({ id = 120, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101231},  attackEffTime = {200}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,hitAnimTime2 = 600,attackAnim = "attack",attackSound = 12001,hitSound = 42})

mapArray:push({ id = 121, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101211}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 12101,hitSound = 23})
mapArray:push({ id = 122, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101221}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 12201,hitSound = 22})

mapArray:push({ id = 123, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {10121}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 100,hitAnimTime2 = 400,attackAnim = "attack",attackSound = 12301,hitSound = 43})

mapArray:push({ id = 124, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101241}, attackEffTime = {150}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 200,hitAnimTime2 = 400,attackAnim = "attack",attackSound = 12401,hitSound = 43})
mapArray:push({ id = 125, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100391}, attackEffTime = {0}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 3901,hitSound = 23})
mapArray:push({ id = 126, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101261}, attackEffTime = {100}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 450,attackAnim = "attack",attackSound = 12601,hitSound = 41})
mapArray:push({ id = 127, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101271}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 12701,hitSound = 22})
mapArray:push({ id = 128, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101281}, attackEffTime = {300}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 13001,hitSound = 11})
mapArray:push({ id = 129, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101281}, attackEffTime = {300}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 13001,hitSound = 12})
mapArray:push({ id = 130, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101301}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 13001,hitSound = 43})

mapArray:push({ id = 131, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101311}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 50,attackAnim = "attack",attackSound = 13101,hitSound = 32})
mapArray:push({ id = 132, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101321}, attackEffTime = {350}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 13201,hitSound = 41})
mapArray:push({ id = 133, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101331}, attackEffTime = {100}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 101,hitSound = 32})
mapArray:push({ id = 134, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101341}, attackEffTime = {100}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,hitAnimTime2 = 500,attackAnim = "attack",attackSound = 13401,hitSound = 43})
mapArray:push({ id = 135, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101351}, attackEffTime = {10}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 150,attackAnim = "attack",attackSound = 1,hitSound = 21})
mapArray:push({ id = 136, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101361}, attackEffTime = {20}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 500,attackAnim = "attack",attackSound = 13601,hitSound = 43})

mapArray:push({ id = 137, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101371}, attackEffTime = {200}, attackEffType = {0},hitEff = { 1802},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 13701,hitSound = 23})
mapArray:push({ id = 138, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101381}, attackEffTime = {100}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 13801,hitSound = 23})
mapArray:push({ id = 139, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101391}, attackEffTime = {200}, attackEffType = {0},hitEff = { 402},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 13901,hitSound = 31})
mapArray:push({ id = 140, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101401}, attackEffTime = {200}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 14001,hitSound = 21})
mapArray:push({ id = 141, remote = 0,zoomIn= 0, moveDistance = 250,attackEff = {101411}, attackEffTime = {200}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 14101,hitSound = 32})
mapArray:push({ id = 142, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100931}, attackEffTime = {50}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 100,attackAnim = "attack",attackSound = 9301,hitSound = 21})

mapArray:push({ id = 143, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101431}, attackEffTime = {150}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 14301,hitSound = 21})
mapArray:push({ id = 144, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101441}, attackEffTime = {300}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 14401,hitSound = 32})
mapArray:push({ id = 145, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101451}, attackEffTime = {50}, attackEffType = {0},hitEff = { 101088},hitAnimTime1 = 100,hitAnimTime2 = 700,attackAnim = "attack",attackSound = 14501,hitSound = 21})
mapArray:push({ id = 146, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101461}, attackEffTime = {100}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,hitAnimTime2 = 500,attackAnim = "attack",attackSound = 14601,hitSound = 22})
mapArray:push({ id = 147, remote = 0,zoomIn= 0, moveDistance = 70,attackEff = {101471}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 14701,hitSound = 23})
mapArray:push({ id = 148, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101471}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 14701,hitSound = 23})
mapArray:push({ id = 149, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101491}, attackEffTime = {250}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 14901,hitSound = 33})
mapArray:push({ id = 150, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101501}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 15001,hitSound = 22})
mapArray:push({ id = 151, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101511}, attackEffTime = {120}, attackEffType = {0},hitEff = { 101055},hitAnimTime1 = 200,hitAnimTime2 = 500,hitAnimTime3 = 800,attackAnim = "attack",attackSound = 15101,hitSound = 23})

mapArray:push({ id = 152, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {102051}, attackEffTime = {0}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101,hitSound = 33})
mapArray:push({ id = 153, remote = 0,zoomIn= 0, moveDistance = 160,attackEff = {102051}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101,hitSound = 33})
mapArray:push({ id = 154, remote = 0,zoomIn= 0, moveDistance = 140,attackEff = {102051}, attackEffTime = {0}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101,hitSound = 33})
mapArray:push({ id = 155, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {100231}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,hitAnimTime2 = 600,attackAnim = "attack",attackSound = 3001,hitSound = 43})
mapArray:push({ id = 156, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101561}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 600,attackAnim = "attack",hitEff = { 101564},attackSound = 101,hitSound = 43})
mapArray:push({ id = 157, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {101571}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,hitAnimTime2 = 500,hitAnimTime3 = 900,attackAnim = "attack",attackSound = 15701,hitSound = 41})
mapArray:push({ id = 158, remote = 0,zoomIn= 0, moveDistance = 170,attackEff = {101581}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 15801,hitSound = 42})
mapArray:push({ id = 159, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101591}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 300,hitAnimTime2 =500,attackAnim = "attack",attackSound = 15901,hitSound = 42})
mapArray:push({ id = 160, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101601}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 16001,hitSound = 23})
mapArray:push({ id = 161, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101611}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 100,hitAnimTime2 = 800,attackAnim = "attack",attackSound = 16101,hitSound = 23})
mapArray:push({ id = 162, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101641}, attackEffTime = {15}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 16301,hitSound = 23})
mapArray:push({ id = 163, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101631}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 16301,hitSound = 33})
mapArray:push({ id = 164, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101641}, attackEffTime = {15}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,hitAnimTime2 = 1000,attackAnim = "attack",attackSound = 16401,hitSound = 33})
mapArray:push({ id = 165, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101651}, attackEffTime = {60}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 100,attackAnim = "attack",attackSound = 16501,hitSound = 32})
mapArray:push({ id = 166, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101661}, attackEffTime = {0}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 16601,hitSound = 23})
mapArray:push({ id = 167, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101661}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 16601,hitSound = 31})
mapArray:push({ id = 168, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101681}, attackEffTime = {0}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 250,attackAnim = "attack",attackSound = 16801,hitSound = 23})
mapArray:push({ id = 169, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101471}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 14701,hitSound = 23})
mapArray:push({ id = 170, remote = 0,zoomIn= 0, moveDistance = 40,attackEff = {101471}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 14701,hitSound = 43})
mapArray:push({ id = 171, remote = 0,zoomIn= 0, moveDistance = 40,attackEff = {101471}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 14701,hitSound = 23})
mapArray:push({ id = 172, remote = 0,zoomIn= 0, moveDistance = 40,attackEff = {101471}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 400,attackAnim = "attack",attackSound = 14701,hitSound = 23})
mapArray:push({ id = 173, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101651}, attackEffTime = {300}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 8701,hitSound = 42})
mapArray:push({ id = 174, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {100401}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 200,hitEff = { 4002},attackAnim = "attack",attackSound = 4301,hitSound = 23})
mapArray:push({ id = 175, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101211}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101,hitSound = 23})
mapArray:push({ id = 176, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101311}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 50,hitAnimTime2 = 300,attackAnim = "attack",attackSound = 101,hitSound = 42})
mapArray:push({ id = 177, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100201}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 17701,hitSound = 32})
mapArray:push({ id = 178, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101783}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 17801,hitSound = 23})
mapArray:push({ id = 179, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101791}, attackEffTime = {150}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 17901,hitSound = 23})
mapArray:push({ id = 180, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101791}, attackEffTime = {150}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 17901,hitSound = 21})
mapArray:push({ id = 181, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101811}, attackEffTime = {0}, attackEffType = {0},hitEff = { 3702},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 18101,hitSound = 21})
mapArray:push({ id = 182, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101821}, attackEffTime = {400}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 18201,hitSound = 23})
mapArray:push({ id = 183, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101821}, attackEffTime = {400}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 18201})
mapArray:push({ id = 184, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {101821}, attackEffTime = {400}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 18201})
mapArray:push({ id = 185, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101221}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 186, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101221}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 187, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101221}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 188, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101221}, attackEffTime = {300}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 189, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {4001}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 100,hitAnimTime2 = 400,hitEff = { 101892},attackAnim = "attack",attackSound = 18901,hitSound = 23})
mapArray:push({ id = 190, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 191, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 192, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 193, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 194, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 195, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 196, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 197, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 198, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 199, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 200, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 16601,hitSound = 23})
mapArray:push({ id = 201, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 202, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 203, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 204, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 205, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102051}, attackEffTime = {0}, attackEffType = {0},hitEff = { 7002},hitAnimTime1 = 300,attackAnim = "attack",attackAnim = "attack",attackSound = 20501,hitSound = 31})
mapArray:push({ id = 206, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102051}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackAnim = "attack",attackSound = 20501,hitSound = 31})
mapArray:push({ id = 207, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102051}, attackEffTime = {0}, attackEffType = {0},hitEff = { 8002},hitAnimTime1 = 300,attackAnim = "attack",attackAnim = "attack",attackSound = 20501,hitSound = 31})
mapArray:push({ id = 208, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 209, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 210, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 211, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 212, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})
mapArray:push({ id = 213, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",attackSound = 101})

mapArray:push({ id = 252, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {25200}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 500,hitAnimTime2 = 1000,attackAnim = "attack",hitSound = 31})
mapArray:push({ id = 258, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {25200}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 500,hitAnimTime2 = 1000,attackAnim = "attack",hitSound = 31})


mapArray:push({ id = 274, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {102741}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 200,hitAnimTime2 = 1000,attackAnim = "attack",hitEff = { 8002},hitSound = 2401})
mapArray:push({ id = 275, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102751}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 500,hitAnimTime2 = 1000,attackAnim = "attack",hitEff = { 101055},attackSound = 2751})
mapArray:push({ id = 276, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102761}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 400,hitAnimTime2 = 1100,attackAnim = "attack",hitEff = { 8002},attackSound = 2761})
mapArray:push({ id = 277, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102771}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 450,hitAnimTime2 = 860,attackAnim = "attack",hitSound = 32,attackSound = 2701})

mapArray:push({ id = 278, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102781}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 450,hitAnimTime2 = 1000,attackAnim = "attack",hitEffShowOnce =1,hitEff = { 102782},hitSound = 31})

mapArray:push({ id = 273, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {102731}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 300,attackAnim = "attack",hitEff = { 102732},hitEffOffsetY = {70},hitEffOffsetX = {-40},attackSound = 8003})
mapArray:push({ id = 279, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102791}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 400,attackAnim = "attack",hitEff = { 102792},hitEffTime = {100},attackSound = 2791})--, hitSound = 21
mapArray:push({ id = 289, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {102891}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 400,attackAnim = "attack",hitEffOffsetY = {-20},hitEff = { 102892},hitEffTime = {0},attackSoundTime = 0,hitSound = 22, attackSound = 2891})
mapArray:push({ id = 290, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {102901}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 400,hitAnimTime2 = 650,attackAnim = "attack",hitEffOffsetY = {0},hitEff = { 0},hitEffTime = {0},attackSoundTime = 0,hitSound = 21, attackSound = 2401})--


--技能
mapArray:push({ id = 10100, remote = 1,zoomIn= 1, attackEff = {100013}, attackEffTime = {100}, attackEffType = {0}, hitEff = { 101022},hitAnimTime1 = 2500,hitAnimTime2 = 2700,hitAnimTime3 = 2900, attackSound = 102,hitSound = 12})
mapArray:push({ id = 10102, remote = 0,zoomIn= 0, moveDistance = 70,attackEff = {100011}, attackEffTime = {0}, moveDistance = 200,attackEffType = {0},hitAnimTime1 = 500,beforeMoveAnim = "drink",attackSound = 101,hitSound = 41})
mapArray:push({ id = 20100, remote = 1,zoomIn= 1, attackEff = {100023}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1200, hitAnimTime2 = 1500,hitAnimTime3 = 1700,hitEff = { 100024}, attackSound = 202,hitSound = 13})
mapArray:push({ id = 30100, remote = 1,zoomIn= 1, attackEff = {100033}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 550, hitEff = { 100034}, attackSound = 302})
mapArray:push({ id = 40100, remote = 1,zoomIn= 1, xuliEff = 100043, attackEff = {0},attackEffTime = {500}, attackEffType = {4}, hitAnimTime1 = 1000, hitEff = { 1000021}, attackSound = 402})
mapArray:push({ id = 50100, remote = 1,zoomIn= 1, xuliEff = 100056, attackEff = {100053}, flyEffRotate = 0,attackEffTime = {600}, attackEffType = {4}, hitAnimTime1 = 800,  hitAnimTime2 = 1000,  hitAnimTime3 = 1200, hitEffShowOnce = 1,hitEff = { 100054},attackSound = 502,hitSound = 11})
mapArray:push({ id = 60100, remote = 1,zoomIn= 1, attackEff = {100063}, attackEffTime = {200}, attackEffType = {0}, hitEff = { 101044},hitAnimTime1 = 1000,attackSound = 602,hitSound = 12})
mapArray:push({ id = 70100, remote = 1,zoomIn= 1, moveDistance = 0,attackEff = {100073}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill", hitAnimTime1 = 0, hitEff = { 0},attackSound = 702,hitSound = 0})
mapArray:push({ id = 70102, remote = 0,zoomIn= 0, moveDistance = 170,attackEff = {110073}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill2", hitAnimTime1 = 400, hitEff = { 101022},attackSound = 703,hitSound = 13})
mapArray:push({ id = 80100, remote = 1,zoomIn= 1, attackEff = {100083},  attackEffTime = {0}, attackEffType = {2}, hitAnimTime1 = 600, hitAnimTime2 = 900,hitEff = { 100084},attackSound = 802,hitSound = 14})
mapArray:push({ id = 90100, remote = 1,zoomIn= 1, attackEff = {100093}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1100, hitEff = { 100094},attackSound = 902,hitSound = 12})
mapArray:push({ id = 100100, remote = 1,zoomIn= 1, attackEff = {100103}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1800, hitAnimTime2 = 1900,hitAnimTime3 = 2100,hitEff = { 101088},attackSound = 1002,hitSound = 33})
mapArray:push({ id = 100102, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {110103},  needMoveSameRow = 1,attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 101055},attackAnim = "skill2",attackSound = 1002,hitSound = 13})

mapArray:push({ id = 110100, remote = 0,zoomIn= 0,moveDistance = 180,attackEff = {100113}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitAnimTime2 = 1200,hitAnimTime3 = 1600, hitEff = { 101077}, attackAnim = "skill", attackSound = 1102, hitSound = 22})

mapArray:push({ id = 120100, remote = 0,zoomIn= 0,moveDistance = 210,attackEff = {100123}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitAnimTime2 = 1800,hitAnimTime3 = 2000,hitAnimTime4 = 2700,hitEff = { 101077},attackSound = 1202,hitSound = 42})
mapArray:push({ id = 120101, remote = 0,zoomIn= 0,moveDistance = 210,attackEff = {100125}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitEffShowOnce = 1, hitEff = { 100124},attackSound = 1202,hitSound = 42})
mapArray:push({ id = 120102, remote = 0,zoomIn= 0,moveDistance = 210,attackEff = {100125}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1= 1400, hitAnimTime2 = 1700,hitAnimTime3= 1900, hitAnimTime4= 2600, hitEffShowOnce = 1, hitEff = {0},hitEffType={0},hitEff = { 100124 },attackSound = 1202,hitSound = 42})--, hitAnimTime2 = 2200,hitAnimTime3 = 2500

mapArray:push({ id = 130100, remote = 1,zoomIn= 1,moveDistance = 250,attackEff = {100133}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 0},attackSound = 1302,hitSound = 23})
mapArray:push({ id = 140100, remote = 1,zoomIn= 1,attackEff = {100143}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000,hitEff = { 1802},attackSound = 1402,hitSound = 14})
mapArray:push({ id = 140102, remote = 1,zoomIn= 1,xuliEff = 140110,attackEff = {140111}, attackEffTime = {0}, needMoveSameRow = 1,attackEffType = {3}, hitAnimTime1 = 500,hitEff = { 140112},attackSound = 1402,hitSound = 14})
mapArray:push({ id = 140102, remote = 1,zoomIn= 1,xuliEff = 140110,attackEff = {140111}, attackEffTime = {0}, needMoveSameRow = 1,attackEffType = {3}, hitAnimTime1 = 500,hitEff = { 140112},attackSound = 1402,hitSound = 14})

mapArray:push({ id = 150100, remote = 1,zoomIn= 1, xuliEff = 100156, attackEff = {100153},flyEffRotate = 1,attackEffTime = {600},attackEffOffsetY= {0}, attackEffType = {3}, hitAnimTime1 = 800, hitEff = {101088},attackSound = 1502,hitSound = 23})
mapArray:push({ id = 160100, remote = 1,zoomIn= 1,xuliEff = 100166,attackEff = {100163}, flyEffRotate = 3,attackEffType = {4},attackEffTime = {1000}, hitAnimTime1 = 1200, hitEff = { 100164},attackSound = 1702,hitSound = 21})
mapArray:push({ id = 170100, remote = 1,zoomIn= 1,attackEff = {100173}, attackEffTime = {10}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 101088},attackSound = 1702,hitSound = 12})
mapArray:push({ id = 180100, remote = 1,zoomIn= 1, moveDistance = 180,attackEff = {180101}, attackEffTime = {0}, attackEffType = {0},hitEff = {0},hitAnimTime1 = 900,attackSound = 1802,hitSound = 13})
mapArray:push({ id = 190100, remote = 1,zoomIn= 1,xuliEff = 100196, moveDistance = 180,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 1500,hitAnimTime2 = 1800,hitAnimTime3 = 2200,hitEff = { 100194},attackSound = 1902,hitSound = 15})
mapArray:push({ id = 200100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100203}, attackEffTime = {500}, attackEffType = {0}, hitAnimTime1 = 300, hitAnimTime2 = 500,hitAnimTime3 = 850,hitEff = { 200102}, attackSound = 2002,hitSound = 31})

mapArray:push({ id = 210100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {110213}, needMoveSameRow = 1,attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 101055}, attackAnimMove = 1, attackSound = 2102,hitSound = 21})
mapArray:push({ id = 210102, remote = 1,zoomIn= 1,moveDistance = 0,needMoveCenter = 1,attackEff = {100213}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300,hitEff = { 101055}, hitAnimTime2 = 900, hitAnimTime3 = 1400, attackAnim = "skill2",attackAnimMove = 1, attackSound = 2102,hitSound = 23})

mapArray:push({ id = 220100, remote = 1,zoomIn= 1,attackEff = {100223}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 2202,hitSound = 14})
mapArray:push({ id = 220102, remote = 1,zoomIn= 1,attackEff = {110223}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600,hitEff = { 0},attackAnim = "skill2",hitEff = { 110224},attackSound = 2202})

mapArray:push({ id = 230100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100233}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 1000, hitAnimTime3 = 1500,  hitEff = { 0},attackAnim = "skill2",attackSound = 2302,hitSound = 43})
mapArray:push({ id = 230102, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100234}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 1000, hitAnimTime3 = 1500,  hitEff = { 101022},attackAnim = "skill1",attackSound = 2303,hitSound = 43})
mapArray:push({ id = 240100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100243}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 700,hitAnimTime2 = 1200,hitAnimTime3 = 1700,hitEff = { 100244},attackSound = 2402,hitSound = 21})
mapArray:push({ id = 240102, remote = 1,zoomIn= 1,xuliEff = 110246,xuliEffTime = 200,attackEff = {110243}, attackEffType = {3},attackEffTime = {550}, attackEffOffsetX= {0},attackEffOffsetY= {0},hitAnimTime1 = 650,hitEff = { 110244},attackAnim = "skill2",hitEffOffsetX ={ 0},attackSound = 2402,hitSound = 32})
mapArray:push({ id = 250100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100294}, attackEffTime = {200}, attackEffType = {0}, hitAnimTime1 = 700, hitAnimTime2 = 900,hitAnimTime3 = 1200,hitEff = { 1000021},attackSound = 2502})
mapArray:push({ id = 260100, remote = 1,zoomIn= 1,xuliEff = 100265, attackEff = {100263},attackEffTime ={850}, attackEffType = {3}, hitAnimTime1 = 1000, hitEff = { 260103},attackSound = 2602,hitSound = 42})
mapArray:push({ id = 270100, remote = 1,zoomIn= 1,attackEff = {100273}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900, attackSound = 2702,hitSound = 15,attackAnim = "skill2"})
mapArray:push({ id = 280100, remote = 1,zoomIn= 1,attackEff = {100283}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 550, hitEff = {101088},attackSound = 2802,hitSound = 12})
mapArray:push({ id = 290100, remote = 1,zoomIn= 1,attackEff = {100293}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitAnimTime2 = 700,hitAnimTime3 = 1100,hitEff = { 1000021},attackSound = 2902})
mapArray:push({ id = 290102, remote = 1,zoomIn= 1,attackEff = {100294}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, attackAnim = "skill2",hitEff = { 1000021},attackSound = 2902})
mapArray:push({ id = 300100, remote = 1,zoomIn= 1,attackEff = {100303}, attackEffTime = {120}, attackEffType = {0}, hitAnimTime1 = 1500, hitEff = { 101088},attackSound = 3002,hitSound = 11})
mapArray:push({ id = 310100, remote = 1,zoomIn= 1,attackEff = {100313}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 1000021},attackSound = 3102})
mapArray:push({ id = 310102, remote = 1,zoomIn= 1,attackEff = {100294}, attackEffTime = {0}, attackEffType = {0}, attackAnim = "skill2",hitAnimTime1 = 600, hitEff = { 1000021},attackSound = 3103})
mapArray:push({ id = 320100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100323}, attackEffTime = {0},attackEffType = {0}, hitAnimTime1 = 200,hitAnimTime2 = 400,hitAnimTime3 = 800,hitAnimTime4 = 1200, hitEff = {1802},attackSound = 3202,hitSound = 23})
mapArray:push({ id = 330100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100333}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900, hitEff = { 101044},attackSound = 3302,hitSound = 42})
mapArray:push({ id = 340100, remote = 1,zoomIn= 1,attackEff = {100343}, attackEffTime = {200}, attackEffType = {0}, hitAnimTime1 = 1500, hitEff = { 8002},attackSound = 3402,hitSound = 32})
mapArray:push({ id = 350100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100353}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitAnimTime2 = 900, hitEff = { 101088},attackSound = 3502,hitSound = 41})
mapArray:push({ id = 360100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100363}, attackEffTime = {300}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 402},attackSound = 3602,hitSound = 12})
mapArray:push({ id = 370100, remote = 1,zoomIn= 1,xuliEff = 100375,attackEff = {100373}, attackEffOffsetX = {80},attackEffOffsetY = {220},attackEffTime = {1000}, attackEffType = {4}, hitAnimTime1 = 1300, hitEff = { 3702},attackSound = 3702,hitSound = 11})
mapArray:push({ id = 380100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100383}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 101044},attackSound = 3802,hitSound = 21})
mapArray:push({ id = 390100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100393}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = {3702},attackSound = 3902,hitSound = 21})
mapArray:push({ id = 400100, remote = 0,zoomIn= 0,moveDistance = 80, attackEff = {100403}, attackEffTime = {200}, attackEffType = {0},hitAnimTime1 = 200,hitEff = {4002},hitAnimTime2= 500,hitAnimTime3 = 700,attackSound = 4002,hitSound = 12})
mapArray:push({ id = 410100, remote = 0,zoomIn= 0,moveDistance = 100, attackEff = {100433}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 300,hitAnimTime2= 500,hitAnimTime3 = 900,attackSound = 4302,hitSound = 12})
mapArray:push({ id = 420100, remote = 0,zoomIn= 0,moveDistance = 100, attackEff = {100433}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 300,hitAnimTime2= 500,hitAnimTime3 = 900,attackSound = 4302,hitSound = 12})
mapArray:push({ id = 430100, remote = 0,zoomIn= 0,moveDistance = 100, attackEff = {100433}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101044},hitAnimTime1 = 300,hitAnimTime2= 500,hitAnimTime3 = 900,attackSound = 4302,hitSound = 12})
mapArray:push({ id = 440100, remote = 1,zoomIn= 1,moveDistance = 80, attackEff = {100443}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitAnimTime2 = 1200,hitEff = { 1000021},attackSound = 4402})
mapArray:push({ id = 440102, remote = 1,zoomIn= 1,moveDistance = 80, attackEff = {100294}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 700, hitAnimTime2 = 900, hitAnimTime3 = 1200,hitEff = { 1000021},attackSound = 4403})
mapArray:push({ id = 450100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100453}, attackEffTime = {270}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 4502,hitSound = 22})
mapArray:push({ id = 460100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100453}, attackEffTime = {270}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 4802,hitSound = 22})
mapArray:push({ id = 470100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100453}, attackEffTime = {270}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 4802,hitSound = 22})
mapArray:push({ id = 480100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100453}, attackEffTime = {270}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 4802,hitSound = 22})
mapArray:push({ id = 490100, remote = 1,zoomIn= 1, xuliEff = 40101, attackEff = {40103},flyEffRotate =0,attackEffTime = {400}, attackEffType = {4}, hitAnimTime1 = 800, hitEff = {402},attackSound = 2,hitSound = 13})

mapArray:push({ id = 500100, remote = 1,zoomIn= 1,attackEff = {100223}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 3702},attackSound = 2202,hitSound = 23})
mapArray:push({ id = 510100, remote = 1,zoomIn= 1,attackEff = {100173}, attackEffTime = {400}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 1702,hitSound = 13})
mapArray:push({ id = 520100, remote = 1,zoomIn= 1,attackEff = {100173}, attackEffTime = {400}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 1702,hitSound = 13})
mapArray:push({ id = 530100, remote = 1,zoomIn= 1,attackEff = {100173}, attackEffTime = {400}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 1702,hitSound = 13})
mapArray:push({ id = 540100, remote = 1,zoomIn= 1,attackEff = {100173}, attackEffTime = {400}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 1702,hitSound = 13})

mapArray:push({ id = 550100, remote = 1,zoomIn= 1, xuliEff = 40101, attackEff = {40103},flyEffRotate =0,attackEffTime = {500}, attackEffType = {4}, hitAnimTime1 = 800, hitEff = { 402},attackSound = 5502,hitSound = 23})
mapArray:push({ id = 560100, remote = 1,zoomIn= 1, xuliEff = 40101, attackEff = {40103},flyEffRotate =0,attackEffTime = {500}, attackEffType = {4}, hitAnimTime1 = 800, hitEff = { 402},attackSound = 5502,hitSound = 23})
mapArray:push({ id = 570100, remote = 1,zoomIn= 1, xuliEff = 40101, attackEff = {40103},flyEffRotate =0,attackEffTime = {500}, attackEffType = {4}, hitAnimTime1 = 800, hitEff = { 402},attackSound = 5502,hitSound = 23})

mapArray:push({ id = 580100, remote = 0,zoomIn= 0, moveDistance = 250,attackEff = {100583},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 101088},attackSound = 5502,hitSound = 31})
mapArray:push({ id = 590100, remote = 0,zoomIn= 0, moveDistance = 250,attackEff = {100583},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 101088},attackSound = 5502,hitSound = 31})
mapArray:push({ id = 600100, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {100583},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 101088},attackSound = 5502,hitSound = 31})

mapArray:push({ id = 610100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100613}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 402},attackSound = 17702,hitSound = 22})
mapArray:push({ id = 620100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100623}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 650, hitEff = { 101044},attackSound = 20502,hitSound = 13})
mapArray:push({ id = 630100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100623}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 650, hitEff = { 101044},attackSound = 20502,hitSound = 13})
mapArray:push({ id = 640100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100623}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 650, hitEff = { 101044},attackSound = 20502,hitSound = 13})
mapArray:push({ id = 650100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100623}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 650, hitEff = { 101044},attackSound = 20502,hitSound = 13})
mapArray:push({ id = 660100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100623}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 650, hitEff = { 101044},attackSound = 20502,hitSound = 13})
mapArray:push({ id = 670100, remote = 0,zoomIn= 0,moveDistance = 20,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 0},attackSound = 202,hitSound = 11})
mapArray:push({ id = 680100, remote = 0,zoomIn= 0,moveDistance = 70,attackEff = {100713}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 8002},attackSound = 6802,hitSound = 11})
mapArray:push({ id = 690100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100723}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 402},attackSound = 6902,hitSound = 11})
mapArray:push({ id = 700100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {100733}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 101022},attackSound = 7002,hitSound = 11})
mapArray:push({ id = 710100, remote = 0,zoomIn= 0,moveDistance = 70,attackEff = {100713}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 8002},attackSound = 6802,hitSound = 11})
mapArray:push({ id = 720100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100723}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 402},attackSound = 6902,hitSound = 11})
mapArray:push({ id = 730100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100733}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 101022},attackSound = 7002,hitSound = 11})
mapArray:push({ id = 740100, remote = 0,zoomIn= 0,moveDistance = 70,attackEff = {100713}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 8002},attackSound = 6802,hitSound = 11})
mapArray:push({ id = 750100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100723}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 402},attackSound = 6902,hitSound = 11})
mapArray:push({ id = 760100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {100733}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 101022},attackSound = 7002,hitSound = 11})

mapArray:push({ id = 770100, remote = 0,zoomIn= 0, moveDistance = 170,attackEff = {100773}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 1200,hitEff = { 101088},attackAnim = "skill",attackSound = 7702,hitSound = 21})
mapArray:push({ id = 770102, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {110773}, attackEffTime = {50}, attackEffType = {0},hitAnimTime1 = 900,hitEff = { 101022},attackAnim = "skill2",attackSound = 7703,hitSound = 11})
mapArray:push({ id = 770103, remote = 1,zoomIn= 1, moveDistance = 200,attackEff = {120773}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 800,hitAnimTime2 = 1000,hitEff = { 101088},attackAnim = "skill3",attackSound = 7704,hitSound = 21})
mapArray:push({ id = 770104, remote = 1,zoomIn= 1, moveDistance = 0,needMoveCenter = 1,attackEff = {130773}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200,hitAnimTime2 = 500,hitAnimTime3 = 700,hitAnimTime4 = 1200,hitEff = { 101022},attackAnim = "skill4",attackSound = 7705,hitSound = 22})


mapArray:push({ id = 780100, remote = 0,zoomIn= 0, moveDistance = 170,attackEff = {100783}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 500,hitEff = { 101022},attackAnim = "skill",attackSound = 7802,hitSound = 42})
mapArray:push({ id = 780102, remote = 1,zoomIn= 1, moveDistance = 120,attackEff = {110783}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 1100,hitEff = { 1000021},attackAnim = "skill2",attackSound = 7803})
mapArray:push({ id = 780103, remote = 1,zoomIn= 1, moveDistance = 120,attackEff = {120783}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 800,hitAnimTime2 = 1000,hitAnimTime3 = 1200,hitEff = { 8002},attackAnim = "skill3",attackSound = 7804,hitSound = 41})

mapArray:push({ id = 790100, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {100793}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 500,hitAnimTime2 = 800,hitAnimTime3 = 1100,hitEff = { 8002},attackAnim = "skill",attackSound = 7902,hitSound = 21})
mapArray:push({ id = 790102, remote = 1,zoomIn= 1, moveDistance = 300,attackEff = {110793}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 1400,hitEff = { 101055},attackAnim = "skill2",attackSound = 7903,hitSound = 41})
mapArray:push({ id = 790103, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {120793}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 500,hitAnimTime2 = 800,hitAnimTime3 = 1200,hitEff = { 101055},attackAnim = "skill3",attackSound = 7904,hitSound = 22})

mapArray:push({ id = 800100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100803}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300,hitAnimTime2 = 700, hitAnimTime3 = 1100,hitAnimTime4 = 1500,hitEff = { 8002},attackAnim = "skill",attackSound = 8002,hitSound = 31})
mapArray:push({ id = 800102, remote = 0,zoomIn= 0,moveDistance = 70,attackEff = {110803}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300,hitAnimTime2 = 500, hitAnimTime3 = 900,hitEff = { 8002},attackAnim = "skill2",attackSound = 8003,hitSound = 31})
mapArray:push({ id = 800103, remote = 0,zoomIn= 0,moveDistance = 90,attackEff = {120803}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 700,hitEff = { 8002},attackAnim = "skill3",attackSound = 8004,hitSound = 33})
mapArray:push({ id = 800104, remote = 1,zoomIn= 1,moveDistance = 150,attackEff = {130803}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400,hitAnimTime2 = 600, hitAnimTime3 = 900,hitEff = { 8002},attackAnim = "skill4",attackSound = 8005,hitSound = 33})

mapArray:push({ id = 810100, remote = 1,zoomIn= 1,attackEff = {100813}, attackEffTime = {90}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 1500, hitEff = { 8002},attackSound = 8102,hitSound = 14})
mapArray:push({ id = 820100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {100823}, attackEffTime = {250}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 800, hitAnimTime3 = 1200,hitEff = {8002},attackSound = 8202,hitSound = 21})
mapArray:push({ id = 830100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100833}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300, hitAnimTime2 = 800,hitAnimTime3 = 1200,hitEff = { 3702},attackSound = 8302,hitSound = 21})
mapArray:push({ id = 840100, remote = 1,zoomIn= 1,xuliEff = 100846,attackEff = {100843}, attackEffTime = {0},attackEffType = {1}, hitAnimTime1 = 800, hitAnimTime2 = 1200,hitAnimTime3 = 1500,hitEff = { 101044},attackSound = 8402,hitSound = 22})
mapArray:push({ id = 850100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100853}, attackEffTime = {0}, attackEffType = {0},hitEff = { 100854},hitAnimTime1 = 100,attackSound = 8502,hitSound = 21})
mapArray:push({ id = 860100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100863}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800,hitEff = { 101022},attackSound = 8602,hitSound = 11})
mapArray:push({ id = 870100, remote = 0,zoomIn= 0,moveDistance = 170,attackEff = {100873}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1300,hitEff = { 3702},attackSound = 8702,hitSound = 34})
mapArray:push({ id = 880100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100883}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 700, hitAnimTime3 = 1200,  hitEff = { 1000021},attackSound = 12702})
mapArray:push({ id = 890100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100893}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 800,hitAnimTime3 = 1300,hitEff = { 101088},attackSound = 8902,hitSound = 22})

mapArray:push({ id = 900100, remote = 1,zoomIn= 1,xuliEff = 100906,moveDistance = 100,flyEffRotate = 1,attackEff = {100903}, attackEffTime = {430}, attackEffType = {4}, hitAnimTime1 = 600, hitEff = { 101088},attackAnim = "skill2",attackSound = 9002,hitSound = 23})
mapArray:push({ id = 900102, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {110903}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 950, hitAnimTime2 = 1100,hitAnimTime3 = 1500,hitEff = { 8002},attackAnim = "skill",attackSound = 9002,hitSound = 23})

mapArray:push({ id = 910100, remote = 1,zoomIn= 1,xuliEff = 100916,moveDistance = 250,attackEff = {100914}, attackEffType = {1},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitAnimTime2 = 1300,hitEff = { 8002},attackSound = 9102,hitSound = 12})
mapArray:push({ id = 920100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100923}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 400,hitAnimTime3 = 1200,hitEff = { 101044},attackSound = 9202,hitSound = 23})
mapArray:push({ id = 930100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100933}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 800,hitEff = {3702},attackSound = 9302,hitSound = 12})
mapArray:push({ id = 940100, remote = 1,zoomIn= 1,moveDistance = 250,attackEff = {100943}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitEff = { 0},attackSound = 9402,hitSound = 13})
mapArray:push({ id = 950100, remote = 0,zoomIn= 0,moveDistance = 250,attackEff = {100953}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitEff = { 100955},attackSound = 9502,hitSound = 14})

mapArray:push({ id = 960100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100963}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600,attackAnim = "skill2",hitEff = { 101044},attackSound = 9602,hitSound = 31})
mapArray:push({ id = 960102, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {110963}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200,hitAnimTime2 = 500,hitAnimTime3 = 1000,hitEffShowOnce = 1,attackAnim = "skill",hitEff = {110964},attackSound = 9603,hitSound = 23})

mapArray:push({ id = 970100, remote = 1,zoomIn= 1,moveDistance = 150,attackEff = {100973}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800,hitEff = { 1000021},attackSound = 9702})
mapArray:push({ id = 970102, remote = 1,zoomIn= 1,moveDistance = 150,attackEff = {100294}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 800,hitAnimTime3 = 1000,hitEff = { 1000021},attackSound = 9702})
mapArray:push({ id = 980100, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {100983}, attackEffTime = {100}, attackEffType = {0}, hitAnimTime1 = 1300,hitAnimTime2 = 1600, hitEff = { 101055},attackSound = 9802,hitSound = 22})
mapArray:push({ id = 990100, remote = 1,zoomIn= 1,moveDistance = 0,xuliEff = 100996,needMoveCenter = 1,attackEff = {100993}, attackEffTime = {1}, attackEffType = {1}, hitAnimTime1 = 800,hitEff = { 0},attackSound = 9902,hitSound = 14})
mapArray:push({ id = 1000100, remote = 1,zoomIn= 1,moveDistance = 150,attackEff = {101003}, attackEffTime = {100}, attackEffType = {0}, hitAnimTime1 = 1500, hitAnimTime2 = 2000,hitAnimTime3 = 2500,hitEff = { 8002},attackSound = 10002,hitSound = 14})
mapArray:push({ id = 1010100, remote = 1,zoomIn= 1,moveDistance = 150,attackEff = {101013}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitAnimTime2 = 2000,hitAnimTime3 = 2500,hitEff = { 1802},attackSound = 10102,hitSound = 15})
mapArray:push({ id = 1020100, remote = 0,zoomIn= 0,moveDistance = 250,attackEff = {101023}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitAnimTime2 = 1100,hitEff = { 3702},attackSound = 10202,hitSound = 13})
mapArray:push({ id = 1030100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {101033}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 500,hitAnimTime3 = 1200,hitEff = {101055},attackSound = 10302,hitSound = 42})

mapArray:push({ id = 1040100, remote = 1,zoomIn= 1,xuliEff = 101046,attackEff = {101043}, attackEffTime = {350}, attackEffType = {3},attackEffType = {4}, hitAnimTime1 = 600, hitEff = { 101055},attackSound = 10402,hitSound = 21})

mapArray:push({ id = 1050100, remote = 1,zoomIn= 1,moveDistance = 150,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitEff = { 101055},attackSound = 2})
mapArray:push({ id = 1060100, remote = 1,zoomIn= 1,moveDistance = 250,attackEff = {101063}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = { 0},attackSound = 10602,hitSound = 22})
mapArray:push({ id = 1060102, remote = 0,zoomIn= 0,moveDistance = 250,attackEff = {101064}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 800,hitEff = { 101088},attackSound = 10603,hitSound = 22})
mapArray:push({ id = 1070100, remote = 1,zoomIn= 1,moveDistance = 150,xuliEff = 101076,attackEff = {101073}, attackEffTime = {3}, attackEffType = {0}, hitAnimTime1 = 500,hitEff = { 3702},attackSound = 10702,hitSound = 12})
mapArray:push({ id = 1080100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {101083}, attackEffTime = {250}, attackEffType = {0}, hitAnimTime1 = 1700, hitAnimTime2 = 2000,hitEff = { 101044},attackSound = 10802,hitSound = 41})
mapArray:push({ id = 1090100, remote = 0,zoomIn= 0,moveDistance = 250,attackEff = {101093}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000,hitEff = { 101022},attackSound = 800,hitSound = 11})
mapArray:push({ id = 1100100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {101103}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 500,hitAnimTime3 = 1000,hitEff = { 101088},attackSound = 11002,hitSound = 11})
mapArray:push({ id = 1110100, remote = 1,zoomIn= 1,moveDistance = 130,attackEff = {101113}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitAnimTime2 = 1700,hitAnimTime3 = 1900,hitEff = { 0},attackSound = 11102,hitSound = 43})
mapArray:push({ id = 1120100, remote = 0,zoomIn= 0,moveDistance = 130,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 500,hitAnimTime3 = 800,hitEff = { 0},attackSound = 2})
mapArray:push({ id = 1130100, remote = 0,zoomIn= 0,moveDistance = 130,attackEff = {101133}, attackEffTime = {500}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 1200,hitAnimTime3 = 1600,hitEff = { 101022},attackSound = 11302,hitSound = 41})
mapArray:push({ id = 1140100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101143}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600,hitEff = { 3702},attackSound = 11402,hitSound = 23})
mapArray:push({ id = 1150100, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101153}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200,hitAnimTime2 = 500,hitAnimTime3 = 1300,hitEff = { 101055},attackSound = 11502,hitSound = 12})
mapArray:push({ id = 1160100, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {101163}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 550,hitEff = { 7002},attackSound = 11602,hitSound = 13,hitSound = 23})
mapArray:push({ id = 1170100, remote = 0,zoomIn= 0, moveDistance = 250,attackEff = {101173}, attackEffTime = {500}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 3702},attackSound = 11702,hitSound = 22})
mapArray:push({ id = 1180100, remote = 0,zoomIn= 0, moveDistance = 230,attackEff = {101183}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1300, hitEff = { 402},attackSound = 11802,hitSound = 12})
mapArray:push({ id = 1190100, remote = 0,zoomIn= 0,moveDistance = 130,attackEff = {101133}, attackEffTime = {500}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 1200,hitAnimTime3 = 1600,hitEff = { 101022},attackSound = 11402,hitSound = 12})
mapArray:push({ id = 1200100, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {101203}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 1000,hitEff = { 101022},attackSound = 12002,hitSound = 14})
mapArray:push({ id = 1210100, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101213}, attackEffTime = {150}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 3702},attackSound = 12102,hitSound = 21})
mapArray:push({ id = 1220100, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101223}, attackEffTime = {700}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 8002},attackSound = 12202,hitSound = 22})
mapArray:push({ id = 1230100, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101233}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300, hitAnimTime2 = 600,hitAnimTime3 = 900,hitAnimTime4 = 1500,hitEff = { 101022},attackSound = 12302,hitSound = 43})
mapArray:push({ id = 1240100, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101243}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 500,hitAnimTime3 = 800,hitAnimTime4 = 1200,hitEff = { 1802},attackSound = 12402,hitSound = 41})
mapArray:push({ id = 1250100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {100393}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 3702},attackSound = 3902,hitSound = 15})
mapArray:push({ id = 1260100, remote = 1,zoomIn= 1, moveDistance = 80,attackEff = {101263}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900,hitEff = { 0},attackSound = 12602})
mapArray:push({ id = 1260102, remote = 1,zoomIn= 1, moveDistance = 80,attackEff = {101264}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 700,hitEff = { 101055},attackAnim = "skill2",attackSound = 12603,hitSound = 11})


mapArray:push({ id = 1270100, remote = 1,zoomIn= 1, moveDistance = 30,attackEff = {101273}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitEff = { 3702},attackSound = 12702})


mapArray:push({ id = 1280100, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101303}, attackEffTime = {500},attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 7002},attackSound = 13002,hitSound = 13})
mapArray:push({ id = 1290100, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101303}, attackEffTime = {500},attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 8002},attackSound = 13002,hitSound = 13})
mapArray:push({ id = 1300100, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101303}, attackEffTime = {500}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 7002},attackSound = 13002,hitSound = 43})
mapArray:push({ id = 1310100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101313},attackEffTime = {700}, attackEffType = {0}, hitAnimTime1 = 750, hitEff = { 101055},attackSound = 13102,hitSound = 31})
mapArray:push({ id = 1320100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101323},attackEffTime = {390}, attackEffType = {0}, hitAnimTime1 = 500,hitEff = { 8002},attackSound = 13202,hitSound = 42})
mapArray:push({ id = 1330100, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101333},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 700, hitEff = { 8002},attackSound = 202,hitSound = 14})
mapArray:push({ id = 1340100, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101343},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitEff = { 8002},attackSound = 13402,hitSound = 42})
mapArray:push({ id = 1340102, remote = 0,zoomIn= 0, moveDistance = 280,attackEff = {111343},attackEffTime = {550}, attackEffType = {0},needMoveSameRow = 1, hitAnimTime1 =800, hitEff = { 111345},attackAnim = "skill2",attackSound = 13402,hitSound = 12})

mapArray:push({ id = 1350100, remote = 1,zoomIn= 1, moveDistance = 250,attackEff = {111353},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 111354},attackSound = 13502,hitSound = 14})
mapArray:push({ id = 1360100, remote = 1,zoomIn= 1,moveDistance = 300,needMoveCenter = 1,attackEff = {100303}, attackEffTime = {120}, attackEffType = {0}, hitAnimTime1 = 1500, hitEff = { 101022},attackSound = 13602,hitSound = 14})
mapArray:push({ id = 1365100, remote = 1,zoomIn= 1,moveDistance = 300,needMoveCenter = 1,attackEff = {100303}, attackEffTime = {120}, attackEffType = {0}, hitAnimTime1 = 1500, hitEff = { 101022},attackSound = 13602,hitSound = 14})

mapArray:push({ id = 1370100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101373},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 1802},attackSound = 13702,hitSound = 14})
mapArray:push({ id = 1380100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101383},attackEffTime = {5}, attackEffType = {0},  hitAnimTime1 = 400,hitAnimTime2 = 1000,hitEff = { 101088},attackSound = 13802,hitSound = 22})
mapArray:push({ id = 1390100, remote =1, moveDistance = 150,attackEff = {101393},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 800, hitAnimTime2 = 900,hitAnimTime3 = 1100,hitEff = {101044},attackSound = 13902,hitSound = 32})
mapArray:push({ id = 1400100, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {101403},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 400,hitEff = {3702},attackSound = 14002,hitSound = 22})
mapArray:push({ id = 1410100, remote = 0,zoomIn= 0, moveDistance = 180,attackEff = {101413},attackEffTime = {200}, attackEffType = {0}, hitAnimTime1 = 450, hitAnimTime2 = 750,hitEff = { 8002},attackSound = 14102,hitSound = 32})
mapArray:push({ id = 1420100, remote = 0,zoomIn= 0, moveDistance = 250,attackEff = {100933}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 700,hitAnimTime3 = 900,hitEff = { 101022},attackSound = 9302,hitSound = 14})
mapArray:push({ id = 1430100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101433},attackEffTime = {80}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 1802},attackSound = 14302,hitSound = 41})
mapArray:push({ id = 1440100, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {101443},attackEffTime = {200}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 3702},attackSound = 14402,hitSound = 32})
mapArray:push({ id = 1450100, remote = 0,zoomIn= 0, moveDistance = 200,attackEff = {101453},attackEffTime = {100}, attackEffType = {0}, hitAnimTime1 = 400,hitAnimTime2 = 800,hitAnimTime3 = 1500, hitEff = { 8002},attackSound = 14502,hitSound = 22})
mapArray:push({ id = 1460100, remote = 1,zoomIn= 1, moveDistance = 250,xuliEff = 0,attackEff = {101463},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = { 101416}, attackSound = 14602,hitSound = 14})
mapArray:push({ id = 1470100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101473},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 700,hitEff = { 1802},attackSound = 14702,hitSound = 22})
mapArray:push({ id = 1480100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {101473},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 700,hitEff = { 1802},attackSound = 14702,hitSound = 14})
mapArray:push({ id = 1490100, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {101493},attackEffTime = {30}, attackEffType = {0}, hitAnimTime1 = 900, hitEff = {402},attackSound = 14902,hitSound = 32})
mapArray:push({ id = 1500100, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {101503},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 101055},attackSound = 15002,hitSound = 21})

mapArray:push({ id = 1510100, remote = 1,zoomIn= 1, moveDistance = 0,  attackEff = {101513},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1300, hitEff = { 101055},attackSound = 15102,hitSound = 15})
mapArray:push({ id = 1515100, remote = 1,zoomIn= 1, moveDistance = 0,  attackEff = {101513},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1300, hitEff = { 101055},attackSound = 15102,hitSound = 15})

mapArray:push({ id = 1520100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {102053}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 7002},attackSound = 202,hitSound = 15})
mapArray:push({ id = 1530100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {102053}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 202,hitSound = 15})
mapArray:push({ id = 1540100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {102053}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 202,hitSound = 15})

mapArray:push({ id = 1550100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {100233}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 1000, hitAnimTime3 = 1500,  hitEff = { 0},attackAnim = "skill2",attackSound = 2302,hitSound = 43})
mapArray:push({ id = 1550102, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100234}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 1000, hitAnimTime3 = 1500,  hitEff = { 101022},attackAnim = "skill1",attackSound = 2303,hitSound = 43})

mapArray:push({ id = 1560100, remote = 1,zoomIn= 1,moveDistance = 100,attackEff = {101563}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1200, hitEff = { 101564},attackSound = 202,hitSound = 41})
mapArray:push({ id = 1570100, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {101573}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000,hitAnimTime2 = 1300,hitAnimTime3 = 1500, hitEff = { 101022},attackSound = 15702,hitSound = 13})
mapArray:push({ id = 1580100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {101583}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitAnimTime2 = 1400,hitEff = { 101022},attackSound = 15802,hitSound = 13})
mapArray:push({ id = 1590100, remote = 1,zoomIn= 1,moveDistance = 80,attackEff = {101593}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 500,hitEff = { 101594},attackSound = 15902,hitSound = 43})
mapArray:push({ id = 1600100, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {101603}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400,hitAnimTime2 = 800, hitEff = { 8002},attackSound = 16002,hitSound = 23})
mapArray:push({ id = 1610100, remote = 0,zoomIn= 0,moveDistance = 250,attackEff = {101613}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800,hitAnimTime2 = 1100,hitAnimTime3 = 1500, hitEff = { 8002},attackSound = 16102,hitSound = 23})
mapArray:push({ id = 1620100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {101633}, attackEffTime = {200}, attackEffType = {0}, hitAnimTime1 = 100,hitAnimTime2 = 400,hitAnimTime3 =650, hitEff = { 101022},attackSound = 16302,hitSound = 13})
mapArray:push({ id = 1630100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {101633}, attackEffTime = {200}, attackEffType = {0}, hitAnimTime1 = 100,hitAnimTime2 = 400,hitAnimTime3 =700,hitEff = {101022},attackSound = 16302,hitSound = 23})
mapArray:push({ id = 1640100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {101643}, attackEffTime = {350}, attackEffType = {0}, hitAnimTime1 = 400,hitAnimTime2 = 800,hitAnimTime3 = 1300, hitEff = { 101022},attackSound = 16402,hitSound = 13})
mapArray:push({ id = 1650100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {101653}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 3702},attackSound = 16502,hitSound = 33})
mapArray:push({ id = 1660100, remote = 0,zoomIn= 0,moveDistance = 120,attackEff = {101663}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 16602,hitSound = 23})
mapArray:push({ id = 1670100, remote = 0,zoomIn= 0,moveDistance = 120,attackEff = {101663}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 8002},attackSound = 16602,hitSound = 13})
mapArray:push({ id = 1680100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {101683}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 3702},attackSound = 16802,hitSound = 23})
mapArray:push({ id = 1690100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101473},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 800,hitEff = { 1802},attackSound = 14702,hitSound = 23})
mapArray:push({ id = 1700100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101473},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 800,hitEff = { 1802},attackSound = 14702,hitSound = 43})
mapArray:push({ id = 1710100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101473},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 800,hitEff = { 1802},attackSound = 14702,hitSound = 23})
mapArray:push({ id = 1720100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101473},attackEffTime = {0}, attackEffType = {0},  hitAnimTime1 = 800,hitEff = { 1802},attackSound = 14702,hitSound = 23})
mapArray:push({ id = 1730100, remote = 0,zoomIn= 0,moveDistance = 120,attackEff = {100873}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1300, hitEff = { 8002},attackSound = 8702,hitSound = 43})
mapArray:push({ id = 1740100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {100403}, attackEffTime = {0}, attackEffType = {0},hitEff = { 4002},hitAnimTime1 = 100,hitAnimTime2= 300,hitAnimTime3 = 500,hitAnimTime4 = 700,attackSound = 4302,hitSound = 23})
mapArray:push({ id = 1750100, remote = 0,zoomIn= 0, moveDistance = 80,attackEff = {101213}, attackEffTime = {150}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = { 3702},attackSound = 202,hitSound = 23})
mapArray:push({ id = 1760100, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {101313},attackEffTime = {800}, attackEffType = {0}, hitAnimTime1 = 800, hitEff = { 101055},attackSound = 202,hitSound = 43})
mapArray:push({ id = 1770100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {100613},attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 402},attackSound = 17702,hitSound = 22})
mapArray:push({ id = 1780100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {101781}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300, hitEff = { 3702},attackSound = 17802,hitSound = 23})
mapArray:push({ id = 1790100, remote = 0,zoomIn= 0,moveDistance = 220,attackEff = {101793}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 17902,hitSound = 23})
mapArray:push({ id = 1800100, remote = 0,zoomIn= 0,moveDistance = 220,attackEff = {101793}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 17902,hitSound = 13})
mapArray:push({ id = 1810100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {101813}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitEff = { 101022},attackSound = 18102,hitSound = 23})
mapArray:push({ id = 1820100, remote = 0,zoomIn= 0,moveDistance = 110,attackEff = {101823}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 8002},attackSound = 18202,hitSound = 23})
mapArray:push({ id = 1830100, remote = 0,zoomIn= 0,moveDistance = 110,attackEff = {101823}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 8002},attackSound = 18202,hitSound = 14})
mapArray:push({ id = 1840100, remote = 0,zoomIn= 0,moveDistance = 110,attackEff = {101823}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 600, hitEff = { 8002},attackSound = 18202,hitSound = 14})
mapArray:push({ id = 1850100, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101223}, attackEffTime = {700}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 4002},attackSound = 202,hitSound = 22})
mapArray:push({ id = 1860100, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101223}, attackEffTime = {700}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 4002},attackSound = 202,hitSound = 22})
mapArray:push({ id = 1870100, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101223}, attackEffTime = {700}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 4002},attackSound = 202,hitSound = 22})
mapArray:push({ id = 1880100, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {101223}, attackEffTime = {700}, attackEffType = {0}, hitAnimTime1 = 700, hitEff = { 4002},attackSound = 202,hitSound = 22})
mapArray:push({ id = 1890100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {101893}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100,hitAnimTime2 = 600,hitAnimTime3 = 1000, hitEff = { 8002},attackSound = 18902,hitSound = 23})
mapArray:push({ id = 1900100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1910100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1920100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1930100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1940100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1950100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1960100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1970100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1980100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 1990100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 2000100, remote = 0,zoomIn= 0,moveDistance = 120,attackEff = {101663}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 3702},attackSound = 16602,hitSound = 23})
mapArray:push({ id = 2010100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 2020100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 13})
mapArray:push({ id = 2030100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 12})
mapArray:push({ id = 2040100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 12})
mapArray:push({ id = 2050100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {102053}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 20502,hitSound = 32})
mapArray:push({ id = 2060100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {102053}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 20502,hitSound = 32})
mapArray:push({ id = 2070100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {102053}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 8002},attackSound = 20502,hitSound = 32})
mapArray:push({ id = 2080100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 12})
mapArray:push({ id = 2090100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 12})
mapArray:push({ id = 2100100, remote = 0,zoomIn= 0,moveDistance = 80,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 0},attackSound = 202,hitSound = 12})
--17日新增
mapArray:push({ id = 2730100, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {102733}, attackEffTime = {400}, attackEffOffsetX = {-40} ,attackEffType = {0}, hitXuliEff = 102736 , hitXuliEffType = 5,hitXuliEffTimeDelay = 500,hitXuliEffTime = 0,hitAnimTime1 = 750, hitAnimTime2 = 1050, hitEffTime = {0},hitEffShowOnce = 1,hitEff = {102734},hitEffOffsetX = {0},hitEffOffsetY = {5},hitEffType = {0},attackSound = 27301,hitSound = 0})
mapArray:push({ id = 2730101, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {112735}, needMoveSameRow = 1, attackEffTime = {700}, attackEffType = {3} ,attackEffOffsetX = {100}, hitAnimTime1 = 1000, hitEff = { 112734},attackAnim = "skill2",attackSound = 27302 ,attackSoundTime = 500,hitSound = 27303})

mapArray:push({ id = 2740100, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {102745}, xuliEff = 102743, xuliEffOffsetX = 25,attackEffTime = {1400}, attackEffType = {2}, attackEffOffsetX = {480},attackEffOffsetY = {150},hitAnimTime1 = 1600,hitAnimTime2 = 1800,hitAnimTime3 = 2000,hitSoundTime = 150, hitEff = { 102744},attackSoundTime= 500,attackSound = 27401,hitSound = 13,shake = 10})
mapArray:push({ id = 2740101, remote = 0,zoomIn= 0,moveDistance = 180,attackEff = {112743}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 550, hitEff = { 101022},attackAnim = "skill2",hitSoundTime = 100,attackSound = 7802,hitSound = 42})

mapArray:push({ id = 2750100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102755}, xuliEff = 102753, attackEffTime = {1400}, attackEffType = {3}, attackEffOffsetY = {150}, hitAnimTime1 = 1650, hitEff = { 102754},attackSound = 27501})
mapArray:push({ id = 2750101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {112753}, attackEffTime = {270}, attackEffType = {0}, attackEffOffsetX = {60}, attackEffOffsetY = {0}, hitAnimTime1 = 300,hitAnimTime2 = 600, hitEff = { 1000021},attackAnim = "skill2",attackSound = 402,hitSound = 13})

mapArray:push({ id = 2760100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102763}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1200, hitEff = { 102764},attackSound = 27601,hitSound = 12, attackSoundTime = 300})

mapArray:push({ id = 2770100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102773}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 2500,hitEffShowOnce = 0, hitEff = { 102774},attackSoundTime= 100,attackSound = 27701})
mapArray:push({ id = 2770101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {112773}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = { 0},attackAnim = "skill2",attackSound = 202,hitSound = 13})


mapArray:push({ id = 2790100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102795, 102796,102797},xuliEff = 102793, attackEffTime = {100,80,1500}, attackEffType = {6,8,5}, hitAnimTime1 = 1500, hitAnimTime2 = 1900,hitAnimTime3 = 2300,hitEffShowOnce = 1, hitEff = { 102794, 102797} , hitEffType = {0,5},hitEffTime = {0},attackSoundTime = 400,attackSound = 27901, hitSound = 27902})
mapArray:push({ id = 2790101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {112793}, attackEffTime = {50}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {112794,112795},hitEffType = {0,5} ,hitEffOffsetX = {-10},attackAnim = "skill2",attackSound = 2502, hitSound = 27904})

mapArray:push({ id = 2890100, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {102893,102895}, needMoveSameRow = 1, attackEffTime = {0,100}, attackEffType = {2,5}, hitAnimTime1 = 3300, hitAnimTime2 = 3500,hitAnimTime3 = 3700, hitEff = {102892},attackSound = 28901 ,hitSound = 15})
mapArray:push({ id = 2890101, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {112893}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300, hitAnimTime2 = 800,hitAnimTime3 = 1350, hitEff = {102892},attackAnim = "skill2",hitEffOffsetY = {-20},hitEffTime = {0},attackSound = 100101,hitSound = 22})

mapArray:push({ id = 2900100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102903,102904}, attackEffTime = {0,1500}, attackEffType = {0,10}, attackEffOffsetY = {0,110}, attackEffOffsetX = {0,-350}, hitAnimTime1 = 1500 ,hitAnimTime2 = 2000 , hitAnimTime3 = 2300, hitEffShowOnce =1, hitEff = {0 }, hitEffType={0},attackSound = 29001,hitSound = 0})--
mapArray:push({ id = 2900101, remote = 0,zoomIn= 0,moveDistance = 90,attackEff = {112903}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 550,hitAnimTime2 = 1550, hitEff = {0} , attackEffOffsetX = {-30} ,attackEffOffsetY = {-20} ,attackAnim = "skill2",attackSoundTime = 0,attackSound = 29002,hitSound = 0})

--1.22
mapArray:push({ id = 2520100, remote = 1,zoomIn= 1,moveDistance = 0, needMoveCenter = 1,attackEff = {25201},  attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000,hitAnimTime2 = 1200,hitAnimTime3 = 1400, attackAnim = "skill", hitEff = { 0},attackSound = 25201,hitSound = 11})
mapArray:push({ id = 2520101, remote = 0,zoomIn= 0,moveDistance = 120,attackEff = {112523}, attackEffTime = {0}, attackEffType = {0} ,hitAnimTime1 = 950, hitAnimTime2 = 1100,hitEff = { 0},attackAnim = "skill2",attackSound = 25202,hitSound = 15})

mapArray:push({ id = 2780100, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {102783}, attackEffType = {0}, attackEffTime = {0}, hitAnimTime1 = 1500, hitAnimTime2 = 1800,hitAnimTime3 = 2200,hitEffShowOnce = 1,hitEff = { 102784},attackSound = 27801,hitSound = 12,hitEffTime = {0}})
mapArray:push({ id = 2780101, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {112785}, needMoveSameRow = 1,xuliEff = 112783, attackEffTime = {400}, attackEffType = {3} ,attackEffOffsetX = {130}, hitAnimTime1 = 600,hitEffOffsetY = {-50},hitEffOffsetX = {-10}, hitEff = { 112784},attackAnim = "skill2",attackSound = 27802,hitSound = 21})

--2.18
mapArray:push({ id = 280, remote = 0,zoomIn= 0, moveDistance = 110,attackEff = {102801}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 250,hitAnimTime2 = 550,hitAnimTime3 =850,attackAnim = "attack",hitEff = { 0},hitEffTime = {0},hitSound = 21, attackSound = 0})--

mapArray:push({ id = 2800100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102803}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, extraEffTime = {0,2050},hitEff = { 102804,102806},extraEff = { 0,102807 },extraEffType = {0},hitEffType = {0,5,0}, hitAnimTime1 = 750,hitEffOffsetX = {0,-15,-15}, hitEffOffsetY = {0,-8,0},hitEffTime = {0,0,2000}, attackAnim = "skill", attackSound = 28001,hitSound = 0})
mapArray:push({ id = 2800101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {112803}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800, hitEffOffsetX= {-20}, hitEff = {112804},attackAnim = "skill2",attackSound = 28002,attackSoundTime = 500,hitSound = 0})

--3.28
mapArray:push({ id = 295, remote = 0,zoomIn= 0, moveDistance = 110,attackEff = {102951}, attackEffTime = {250},attackEffType = {0},hitAnimTime1 = 250,hitAnimTime2 = 850,attackAnim = "attack",hitEff = { 0},hitEffTime = {0},hitSound = 2602,hitSoundTime = -40000, attackSound = 0})
mapArray:push({ id = 2950100, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {102952}, needMoveSameRow = 1, attackEffTime = {1200}, attackEffType = {2}, hitAnimTime1 = 2900, hitEff = {102953},hitEffOffsetY={90},hitEffOffsetX={-80},hitEffTime = {0},effectScale = {1,1.3,1.5},attackSound = 29501 ,attackSoundTime = 600,hitSound = 15})
mapArray:push({ id = 2950101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {0}, attackEffTime = {0},hitEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 0}, hitXuliEff = 102954,attackAnim = "skill2",attackSound = 0,hitSound = 12})

mapArray:push({ id = 296, remote = 0,zoomIn= 0, moveDistance = 110,attackEff = {102961}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 250,attackAnim = "attack",hitEff = { 0},hitEffTime = {0},hitSound = 1,hitSoundTime = 10,attackSound = 0})
mapArray:push({ id = 2960100, remote = 1,zoomIn= 1, attackEff = {102964}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {0}, attackSound = 29601})
mapArray:push({ id = 2960101, remote = 1,zoomIn= 1, attackEff = {102967}, attackEffTime = {600}, attackEffType = {1},attackEffOffsetY= {100},hitEff = {0},attackAnim = "skill3",hitAnimTime1 = 1400, attackSound = 29602,hitSound = 12,hitEffShowOnce = 1})
mapArray:push({ id = 2960102, remote = 1,zoomIn= 1,attackEff = {102968}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = {1029610},attackAnim = "skill2",attackSound = 2202,hitSound = 14})

mapArray:push({ id = 308, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {103081}, attackEffTime = {50},attackEffType = {0},hitAnimTime1 = 600,hitAnimTime2 = 1050,attackAnim = "attack",hitEffOffsetY = {0},hitEff = { 0},hitEffTime = {0},attackSoundTime = 0,hitSound = 21, attackSound = 100101})--

--mapArray:push({ id = 3080100, remote = 0,zoomIn= 0,moveDistance = 180,attackEff = {103083,103085}, attackEffTime = {0,50}, attackEffType = {0,0},attackEffOffsetY={0,80},attackEffOffsetX={0,-50},hitAnimTime1= 400,hitAnimTime2 = 800,hitAnimTime3= 1200,hitAnimTime4= 1500, hitAnimTime5 = 2400,hitEffShowOnce = 1, hitEff = {103084},hitEffTime ={1900},hitEffType={0},hitEffOffsetX={-330},hitEffOffsetY={50},attackSound = 0,hitSound = 0})--, hitAnimTime2 = 2200,hitAnimTime3 = 2500
mapArray:push({ id = 3080100, remote = 0,zoomIn= 0,moveDistance = 35,attackEff = {103083}, attackEffTime = {0}, attackEffType = {0},attackEffOffsetY={0},attackEffOffsetX={0},hitAnimTime1= 500,hitAnimTime2 = 900,hitAnimTime3= 1300,hitAnimTime4= 1600, hitAnimTime5 = 2400,hitEffShowOnce = 1, hitEff = {0},hitEffTime ={2000,0},hitEffType={0},hitEffOffsetX={-310,-340},hitEffOffsetY={50,60},attackSound = 30801,hitSound = 0})--, hitAnimTime2 = 2200,hitAnimTime3 = 2500
mapArray:push({ id = 3080101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {113083}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0,hitAnimTime2 = 200,hitEffShowOnce = 1, hitEff = {113084},attackAnim = "skill2",attackSound = 30802,hitSound = 0})

mapArray:push({ id = 298, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102981}, attackEffTime = {50},attackEffType = {0},hitAnimTime1 = 600,attackAnim = "attack",hitEffOffsetY = {0},hitEff = { 0},hitEffTime = {0},attackSoundTime = 0, hitSound = 32})--
mapArray:push({ id = 2980100, remote = 0,zoomIn= 0,moveDistance = 200,attackEff = {102984}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1800,hitEff = {102982},hitEffOffsetY={-20},hitEffOffsetX={10},hitEffTime = {0},attackSound = 29801,hitSound = 0})
mapArray:push({ id = 2980102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102988,102989}, attackEffTime = {0,0}, attackEffType = {0,5}, hitAnimTime1 = 500,  hitEff = {102983},attackAnim = "skill3",attackSound = 28002,attackSoundTime = 500,hitSound = 0})
mapArray:push({ id = 2980101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102985,102986}, attackEffTime = {0,450}, attackEffOffsetY= {0,0},attackEffType = {0,3}, attackAnim = "skill2",hitAnimTime1 = 700,hitEff = {102987},hitEffOffsetY = {100},hitEffTime = {0},attackSound = 16802,hitSound = 0})

mapArray:push({ id = 297, remote = 0,zoomIn= 0, moveDistance = 230,attackEff = {102971}, attackEffTime = {50},attackEffType = {0},hitAnimTime1 = 600,attackAnim = "attack",hitEffOffsetY = {0},hitEff = { 0},hitEffTime = {0},attackSoundTime = 0,hitSound = 42, attackSound = 6901})--
mapArray:push({ id = 2970100, remote = 1,zoomIn= 1, attackEff = {102972,102973,102975}, attackEffTime = {0,0,3500}, attackEffType = {0,0,1},attackEffOffsetY = {0,0,70}, attackEffOffsetX = {0,0,105}, hitEff = {1029314},hitAnimTime1 = 2700,hitAnimTime2 = 2800,hitAnimTime3 = 3500, attackSound = 29701,hitSound = 12,hitEffShowOnce = 1})
mapArray:push({ id = 2970101, remote = 0,zoomIn= 0, moveDistance = 230,attackEff = {102976}, attackEffTime = {0}, attackEffType = {0},attackEffOffsetY = {0}, attackEffOffsetX = {0}, hitEff = {102974},hitEffOffsetY = {-20},attackAnim = "skill2",hitAnimTime1 = 800,hitAnimTime2 = 1400,attackSound = 102,hitSound = 12})

mapArray:push({ id = 299, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102991}, attackEffTime = {50}, attackEffType = {0}, hitAnimTime1 = 250,hitAnimTime2 = 700,hitAnimTime3 = 1200, hitEff = { 0},attackAnim = "attack",attackSound = 0,hitSound = 21})
mapArray:push({ id = 2990100, remote = 1,zoomIn= 1, attackEff = {102992}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {0}, attackSound = 27901})
mapArray:push({ id = 2990101, remote = 1,zoomIn= 1, attackEff = {102993,102994}, attackEffTime = {650}, attackEffType = {0},attackAnim = "skill2",hitAnimTime1 = 0,hitSoundTime = 650,hitSound = 28002})

mapArray:push({ id = 315, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {103151}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 550,hitAnimTime2 = 1250, hitEff = { 0},attackAnim = "attack",attackSound = 0,hitSound = 22})
mapArray:push({ id = 3150100, remote = 1,zoomIn= 1,attackEff = {103152}, attackEffTime = {0}, attackEffType = {0}, hitEffOffsetX={ 70},hitAnimTime1 = 600,hitAnimTime2 = 800,hitAnimTime3 = 1000,hitAnimTime4 = 1200,hitAnimTime5 = 1600,hitAnimTime6 = 3300,hitAnimTime7 = 4000,hitEffShowOnce = 1, hitEff = {103153}, hitEffTime = {0},attackSound = 31501})
mapArray:push({ id = 3150101, remote = 1,zoomIn= 1, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, attackAnim = "skill2",hitAnimTime1 = 0, hitEff = {0}, attackSound = 1301})
mapArray:push({ id = 3150102, remote = 1,zoomIn= 1,attackEff = {0}, attackEffTime = {0}, attackEffOffsetY= {0},attackEffType = {0}, attackAnim = "skillattack",hitAnimTime1 = 500,hitEff = {103155},hitEffTime = {0},attackSound = 2202,hitSound = 0})

mapArray:push({ id = 291, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102911}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 180,hitAnimTime2 = 480,hitAnimTime3 = 1050, hitEff = { 0},attackAnim = "attack",attackSound = 0,hitSound = 33})
mapArray:push({ id = 2910100, remote = 1,zoomIn= 1, xuliEff = 102912, attackEff = {102914},attackEffTime = {500}, attackEffType = {0}, hitAnimTime1 = 2700, hitEff = { 102913}, attackSound = 502,hitSound = 28002})
mapArray:push({ id = 2910101, remote = 1,zoomIn= 1,attackEff = {102915}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {102916},hitEffTime ={1600}, attackAnim = "skill2",attackSound = 7903,hitSound = 28002,hitSoundTime = 1600})
mapArray:push({ id = 2910102, remote = 1,zoomIn= 1,attackAnim = "skill3", attackEff = {102917,102918},attackEffTime = {0}, attackEffType = {5,0}, hitAnimTime1 = 1900, hitEff = { 102919,1029110},hitEffType = {0,5}, attackSound = 502,hitSound = 28002})

mapArray:push({ id = 283, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102831}, attackEffTime = {300}, attackEffType = {0}, hitAnimTime1 = 580,attackAnim = "attack",attackSound = 0,hitSound = 11})
mapArray:push({ id = 2830100, remote = 1,zoomIn= 1, attackEff = {102832}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill",hitAnimTime1 = 0,hitSoundTime = 750,attackSound = 2791,hitSound = 28002})
mapArray:push({ id = 2830101, remote = 1,zoomIn= 1, attackEff = {102833}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill2",hitAnimTime1 = 0,hitSoundTime = 750,attackSound = 2791,hitSound = 28002})

mapArray:push({ id = 284, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102841}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0,hitAnimTime2 = 550, hitEff = { 0},attackAnim = "attack",attackSound = 0,hitSound = 22})
mapArray:push({ id = 2840100, remote = 1,zoomIn= 1,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000,hitAnimTime2 = 1900,hitAnimTime3 = 2200,hitAnimTime4 = 2500,hitAnimTime5 = 2750,hitAnimTime6 = 3000, hitEff = {102842}, hitEffShowOnce = 1,hitEffTime = {0},attackSound = 28401,attackSoundTime = 400,hitSound = 28402})
mapArray:push({ id = 2840101, remote = 1,zoomIn= 1,attackEff = {0}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill2", hitAnimTime1 = 200, hitEff = {102843}, hitEffTime = {0},attackSound = 28403,attackSoundTime = 400})
mapArray:push({ id = 2840102, remote = 1,zoomIn= 1, attackEff = {102844}, attackEffTime = {400}, attackEffType = {0},attackAnim = "skill3",hitAnimTime1 = 0,hitSoundTime = 750,hitEff = {112794,112795} ,hitEffTime = {500},attackSound = 28002,attackSoundTime = 300})

mapArray:push({ id = 282, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102821}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 580,hitAnimTime2 = 1150,attackAnim = "attack",attackSound = 28401,attackSoundTime = 300, hitSound = 0})
mapArray:push({ id = 2820100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {102822}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 900,hitAnimTime3 = 1200,hitAnimTime4 = 2500, hitEff = {0}, hitEffShowOnce = 1,hitEffTime = {0},attackSound = 30801,hitSound = 0})

mapArray:push({ id = 800110, shake = 12,remote = 1,zoomIn= 1,moveDistance = 150, needMoveCenter = 1,attackEff = {1008010},attackEffOffsetX= {-300},attackEffOffsetY= {130}, attackEffTime = {0}, attackEffType = {10}, attackAnim = "shenghong", hitAnimTime1 = 400,hitAnimTime2 = 500,hitAnimTime3 = 1000,hitAnimTime4 = 1800, hitEff = { 1008011},hitEffTime = {100},attackSoundTime = 400,attackSound = 8010,hitSound = 0})

mapArray:push({ id = 770110, remote = 0,zoomIn= 0, moveDistance = 170,attackEff = {1007710,1007711}, attackEffTime = {0}, attackEffType = {0,0},hitAnimTime1 = 1200,hitEff = { 1007712},attackAnim = "skill",attackSound = 7702,hitSound = 21})

mapArray:push({ id = 790110, remote = 1,zoomIn= 1, moveDistance = 0,needMoveCenter = 1,attackEff = {1007910}, attackEffOffsetX= {80},attackEffOffsetY= {20},attackEffTime = {0}, attackEffType = {8},hitAnimTime1 = 1100,hitAnimTime2 = 1600,hitEff = { 1007911},hitEffTime = {700}, attackAnim = "skill3",attackSound = 11002,hitSound = 0})

mapArray:push({ id = 780110, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {1007810,1007811},attackEffOffsetX= {0,-285},attackEffOffsetY= {0,130}, attackEffTime = {0,850}, attackEffType = {0,10}, attackAnim = "skill", hitAnimTime1 = 900,hitAnimTime2 = 1300,hitAnimTime3 = 1600, hitEffTime = {0},attackSoundTime = 0,attackSound = 1402,hitSound = 0})
mapArray:push({ id = 780111, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {1007812}, hitEffTime = {1000}, attackEffType = {0}, hitAnimTime1 = 0,  hitEff = {102983},attackAnim = "skill2",attackSound = 0,attackSoundTime = 0,hitSoundTime = 1000, hitSound = 28002})

mapArray:push({ id = 60110, remote = 1,zoomIn= 1, attackEff = {60110,60112}, attackEffTime = {200,600}, attackEffType = {0}, hitXuliEff = 60111,hitXuliEffTimeDelay = 350, hitAnimTime1 = 450,attackSound = 602,hitSound = 12})

mapArray:push({ id = 2990110, remote = 1,zoomIn= 1, attackEff = {1029910,1029911}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill2", hitAnimTime1 = 0, hitEff = {1029912},hitEffTime = {880} , attackSound = 28002,attackSoundTime = 880})

mapArray:push({ id = 2960110, remote = 1,zoomIn= 1, attackEff = {1029612,1029611}, attackEffTime = {0}, attackEffType = {0},attackAnim = "skill4", hitAnimTime1 = 0, hitEff = {0}, attackSound = 1402})

mapArray:push({ id = 281, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102811}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1200,attackAnim = "attack",attackSound = 0,hitSound = 11})
mapArray:push({ id = 2810100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102812,102813}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {102814},hitEffTime = {2100}, attackSound = 27801,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 2100})
mapArray:push({ id = 2810101, remote = 1,zoomIn= 1,attackEff = {102815}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {102816},hitEffTime ={800}, attackAnim = "skill3",attackSound = 0,hitSound = 28002,hitSoundTime = 900})
mapArray:push({ id = 2810102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102817}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitEff = {102818},hitEffTime = {500}, attackAnim = "skill2",attackSound = 30802,hitSound = 0})

mapArray:push({ id = 2890110, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {1028910}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 0,hitAnimTime2 = 400,hitAnimTime3 = 1300,attackAnim = "skill2",attackSound = 7702,hitSound = 21})

mapArray:push({ id = 2810110, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {1028110,1028111}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 0, hitEff = {102814},hitEffTime = {2100}, attackSound = 27801,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 2100})

mapArray:push({ id = 316, remote = 0,zoomIn= 0, moveDistance = 100,attackEff = {103161}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400,hitAnimTime2 = 1100, hitEff = { 0},attackAnim = "attack",attackSound = 0,hitSound = 22})
mapArray:push({ id = 3160100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103162,103163,103164},attackRotation = {false,true,true}, attackEffTime = {0},attackEffOffsetX= {340,0,0},attackEffOffsetY= {50,0,0},attackEffType = {6,0,5}, hitAnimTime1 = 0, hitEff = {103164,103165},hitEffTime = {2000,2000}, hitEffType = {5,0},hitRotation = {true,true},attackSound = 27801,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 2100})
mapArray:push({ id = 3160101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103166,103167}, attackEffTime = {0}, attackEffType = {5,5}, hitAnimTime1 = 0, hitEff = {103168,103169},hitEffTime = {1700,1700}, hitEffType = {0,5},attackSound = 27801,attackSoundTime = 0,attackAnim = "skill2",hitSound = 28002,hitSoundTime = 2100})

mapArray:push({ id = 292, remote = 0,zoomIn= 0, moveDistance = 50,attackEff = {102925}, attackEffTime = {50},attackEffType = {0},hitAnimTime1 = 200,hitAnimTime2 = 700,attackAnim = "attack",hitEffOffsetY = {0},hitEff = { 0},hitEffTime = {0},attackSoundTime = 0,hitSound = 32, attackSound = 0})
mapArray:push({ id = 2920100, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102921,102922}, attackEffTime = {0}, attackEffType = {0,5},hitAnimTime1 = 1200,hitAnimTime2 = 1500,hitAnimTime3 = 2000,hitAnimTime4 = 2100,hitAnimTime5 = 2200,hitAnimTime6 = 2300,attackAnim = "skill",attackSound = 15102,attackSoundTime = 0, hitSound = 11})
mapArray:push({ id = 2920101, remote = 1,zoomIn= 1, attackEff = {102923,102924}, attackEffTime = {0}, attackEffType = {0,0}, hitAnimTime1 = 0, hitEff = {0},attackAnim = "skill2", attackSound = 29201})

mapArray:push({ id = 293, remote = 0,zoomIn= 0, moveDistance = 60,attackEff = {102931}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 200,hitAnimTime2 = 600,attackAnim = "attack",hitEff = {3702},hitEffTime = {0},attackSoundTime = 0,hitSound = 33, attackSound = 100101})
mapArray:push({ id = 2930100, remote = 1,zoomIn= 1, attackEff = {102935,102936}, attackEffTime = {0,0}, attackEffType = {0,5},hitAnimTime1 = 3500,hitEff = {102937,102938,1029314},hitEffType = {0,5},effectScale = {1,{0,0,1},{0,0,1},{0,0,1},{0,0,1}},hitEffTime = {0,0,100},attackAnim = "skill",attackSound = 29701,hitSound = 12})
mapArray:push({ id = 2930101, remote = 1,zoomIn= 1, attackEff = {102932,102933}, attackEffTime = {0,600}, attackEffType = {0,3}, hitAnimTime1 = 700, hitEff = {102934},hitEffTime = {100},hitEffType = {0},attackAnim = "skill2", attackSound = 3001,hitSound = 22,hitSoundTime = 300})
mapArray:push({ id = 2930102, remote = 1,zoomIn= 1, attackEff = {102939,1029310}, attackEffTime = {0,0}, attackEffType = {0,5}, attackAnim = "skill3",hitAnimTime1 = 0, hitEff = {0}, attackSound = 27801})
mapArray:push({ id = 2930103, remote = 1,zoomIn= 1,attackEff = {1029311,1029313}, attackEffOffsetX= {0,0},attackEffTime = {400,0}, attackEffType = {3,0}, attackAnim = "skill4",hitAnimTime1 = 700,hitEff = {1029312},hitEffTime = {0},attackSound = 100101,hitSound = 52})

mapArray:push({ id = 294, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {102945},attackEffOffsetX= {-50}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 300,hitAnimTime2 = 700,attackAnim = "attack",hitEff = {102946},hitEffTime = {0},attackSoundTime = 0,hitSound = 32, attackSound = 2101})
mapArray:push({ id = 2940100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {102941,102942},attackEffOffsetX= {-40,-40}, attackEffTime = {0,0}, attackEffType = {0,5}, hitAnimTime1 = 1300,hitAnimTime2 = 1400,hitAnimTime3 = 1500,hitAnimTime4 = 1700,hitAnimTime5 = 1800, hitAnimTime6 = 2600,hitAnimTime7 = 2700,hitAnimTime8 = 2800,hitEff = {0}, hitEffShowOnce = 1,hitEffTime = {0},attackSound = 30801,hitSound = 0})
mapArray:push({ id = 2940101, remote = 1,zoomIn= 1, attackEff = {102943,102944}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 1200, hitEff = {0},hitEffType = {0},attackAnim = "skill2", attackSound = 29201})

mapArray:push({ id = 287, remote = 0,zoomIn= 0, moveDistance = 130,attackEff = {102871},attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 300,hitAnimTime2 = 600,attackAnim = "attack",hitEff = {102872},hitEffTime = {0},attackSoundTime = 0,hitSound = 33, attackSound = 0})
mapArray:push({ id = 2870100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102877,102878}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 2500, hitEff = {102879},hitEffTime = {0}, attackSound = 27801,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 0})
mapArray:push({ id = 2870101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102873,1028717}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 0, hitEff = {102874},hitEffType = {0},hitEffTime = {200}, attackAnim = "skill1",attackSound = 0,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 0})
mapArray:push({ id = 2870102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102875}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0,hitEff = {102876},hitEffTime = {310}, attackAnim = "skill2",attackSound = 30802,hitSound = 0})
mapArray:push({ id = 2870103, remote = 1,zoomIn= 1, attackEff = {1028710,1028711,1028712,1028713,1028719}, attackEffTime = {0,0,2900,2900,0}, attackEffType = {0,5,12,11,11},hitAnimTime1 = 2900,hitEff = {1028714},hitEffType = {0},hitEffTime = {0,0,0},attackAnim = "skill3",attackSound = 27901,hitSound = 12})
mapArray:push({ id = 2870104, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {1028715,1028718,1028716}, attackEffTime = {0}, attackEffType = {0,6,5}, hitAnimTime1 = 2500, hitEff = {102874},hitEffType = {0},hitEffTime = {0}, attackAnim = "skill4",attackSound = 27801,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 0})

mapArray:push({ id = 312, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {103125}, attackEffTime = {50}, attackEffType = {0}, hitAnimTime1 = 250,hitAnimTime2 = 700, hitEff = {0},attackAnim = "attack",attackSound = 0,hitSound = 22})
mapArray:push({ id = 3120100, remote = 1,zoomIn= 1,attackEff = {103128,103127}, attackEffTime = {0}, attackEffType = {5,0},hitAnimTime1 = 1600,hitAnimTime2 = 2200,hitAnimTime3 = 2500,hitAnimTime4 = 3600,hitAnimTime5 = 3700,hitAnimTime6 = 3800, hitEffShowOnce = 1,hitEff = {103129},hitEffType = {0},hitEffOffsetX={ -30},hitEffOffsetY={ -20}, hitEffTime = {0},attackSound = 30801,attackSoundTime = 550})
mapArray:push({ id = 3120101, remote = 1,zoomIn= 1, attackEff = {103121}, attackAnim = "skill2", attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {0}, attackSound = 2202})
mapArray:push({ id = 3120102, remote = 1,zoomIn= 1, attackEff = {1031210,103124,103126,103122}, attackRotation = {false,false,false,true},attackAnim = "skill3", attackEffTime = {2700,2200,2100,0},attackEffType = {8,8,8,0},hitAnimTime1= 500, hitEff = {103123},hitEffTime ={0},hitEffType={0},attackSound = 30801,hitSound = 0})--, hitAnimTime2 = 2200,hitAnimTime3 = 2500

mapArray:push({ id = 326, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {103261}, attackEffTime = {50}, attackEffType = {0}, hitAnimTime1 = 250,hitAnimTime2 = 700, hitEff = {0},attackAnim = "attack",attackSound = 0,hitSound = 32})
mapArray:push({ id = 3260100, remote = 1,zoomIn= 1, attackEff = {103264}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {103262,103263},hitEffType = {0,5},hitEffTime = {1000,1000}, attackSound = 16302,hitSound = 11,hitSoundTime = 1000, attackAnim = "skill1"})
mapArray:push({ id = 3260101, remote = 0,zoomIn= 0,moveDistance = 35,attackEff = {103265,103266}, attackEffTime = {0}, attackEffType = {0,5},hitAnimTime1= 500,hitAnimTime2 = 900,hitAnimTime3= 1300,hitAnimTime4= 1600,hitEffShowOnce = 1,attackAnim = "skill3", hitEff = {0},hitEffTime ={0},hitEffType={0},attackSound = 102,hitSound = 0})
mapArray:push({ id = 3260102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103268}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200,hitEffShowOnce = 1, hitEff = {103267},hitEffOffsetX={-150},attackAnim = "skill2",attackSound = 30802,hitSound = 0})

mapArray:push({ id = 323, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {103231}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100,hitAnimTime2 = 700, hitEff = {0},attackAnim = "attack",attackSound = 22,hitSound = 32})
mapArray:push({ id = 3230100, remote = 1,zoomIn= 1, attackEff = {103232,103233}, attackEffTime = {0}, attackEffType = {2,5}, hitEffType = {0}, hitAnimTime1 = 2000, hitAnimTime2 = 2300, hitEff = {103237}, hitEffOffsetX = {-75}, attackSound = 29801,attackSoundTime = 100, hitSound = 0})
mapArray:push({ id = 3230101, remote = 1,zoomIn= 1, attackEff = {103234,103235}, attackEffTime = {0}, attackEffType = {0,5}, hitEffType = {0}, hitAnimTime1 = 0, hitEff = {0}, attackAnim = "skill2", attackSound = 27901, hitSound = 0})
mapArray:push({ id = 3230102, remote = 1,zoomIn= 1, attackEff = {103236}, attackEffTime = {0}, attackEffType = {0}, hitEffType = {0}, hitAnimTime1 = 1000, hitAnimTime2 = 1100, hitAnimTime3 = 1200, hitEff = {0}, attackAnim = "skill3", attackSound = 3301,attackSoundTime = 500, hitSound = 0})

mapArray:push({ id = 400, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {104001}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitAnimTime2 = 500, hitEff = {0}, attackAnim = "attack", attackSound = 4001, hitSound = 0})
mapArray:push({ id = 4000100, remote = 1,zoomIn= 1, attackEff = {104002}, attackEffTime = {0}, attackEffType = {0}, hitEff = {104004}, hitEffType = {0}, hitEffOffsetX = {-120}, hitEffShowOnce = 1, hitAnimTime1 = 1700, hitAnimTime2 = 1850, hitAnimTime3 = 2000, hitAnimTime4 = 2150, shake = 6, attackAnim = "skill", attackSound = 27301, attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 4000101, remote = 1,zoomIn= 1, attackEff = {104002}, attackEffTime = {0}, attackEffType = {0}, hitEff = {104005}, hitEffType = {0}, hitEffShowOnce = 1, hitAnimTime1 = 1500, hitAnimTime2 = 1650, hitAnimTime3 = 1800, hitAnimTime4 = 1950, shake = 10, attackAnim = "skill2", attackSound = 29801, attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 4000103, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {104006}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 600, attackAnim = "skill3", attackSound = 28401, attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 401, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {104011}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250, hitEff = {0}, attackAnim = "attack", attackSound = 12201, hitSound = 22})
mapArray:push({ id = 4010100, remote = 1,zoomIn= 1, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitXuliEff = 104012, hitXuliEffTimeDelay = 0, hitXuliEffType = 0, hitEffType = {0}, hitAnimTime1 = 1250, shake = 10, attackAnim = "skill", attackSound = 2403, attackSoundTime = 600, hitSound = 0})
mapArray:push({ id = 4010200, remote = 1,zoomIn= 1, attackEff = {104013,104014}, attackEffTime = {0}, attackEffType = {5,0}, hitEffType = {0}, hitAnimTime1 = 0, attackAnim = "skill2", attackSound = 28002, attackSoundTime = 400, hitSound = 0})
mapArray:push({ id = 4010300, remote = 1,zoomIn= 1, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitXuliEff = 104015, hitEffType = {0}, hitAnimTime1 = 500, shake = 10, attackAnim = "skill1", attackSound = 12702, attackSoundTime = 0, hitSound = 12})

mapArray:push({ id = 317, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {103171}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 750, hitEff = {0}, attackAnim = "attack", attackSound = 11, attackSoundTime = 750, hitSound = 0})
mapArray:push({ id = 3170100, remote = 1,zoomIn= 1, attackEff = {103178,103177}, attackEffTime = {0}, attackEffType = {0,0}, hitEff = {103179}, hitEffType = {0}, hitAnimTime1 = 1500, attackAnim = "skill", attackSound = 25201, attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 3170200, remote = 1,zoomIn= 1, attackEff = {103172,103173}, attackEffTime = {0}, attackEffType = {5,0}, hitEff = {103174}, hitEffType = {0}, hitEffTime = {1250}, hitAnimTime1 = 0, attackAnim = "skill2", attackSound = 25201, attackSoundTime = 0, hitSound = 0})
--mapArray:push({ id = 3170300, remote = 1,zoomIn= 1, attackEff = {103175,103176}, attackEffTime = {0}, attackEffType = {5,0}, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 0, attackAnim = "stand", attackSound = 0, attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 327, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {103271}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 350, hitAnimTime2 = 500,hitAnimTime3 = 650, hitEff = {0}, attackAnim = "attack", attackSound = 11, attackSoundTime = 300, hitSound = 0})
mapArray:push({ id = 3270100, remote = 1,zoomIn= 1, attackEff = {103272,103273}, attackEffTime = {0}, attackEffType = {0,7}, hitEff = {103275,103274}, hitEffType = {0,5}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill", attackSound = 102, hitSoundTime = 1800, hitSound = 28002})
mapArray:push({ id = 3270101, remote = 1,zoomIn= 1, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitEff = {103276}, hitEffType = {0}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill4", attackSound = 28002, attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 3270102, remote = 1,zoomIn= 1, attackEff = {103279,103278,1032711},attackEffOffsetX ={ 0,0,-140},attackEffOffsetY ={0,0,-50}, attackEffTime = {0}, attackEffType = {5,0,7}, hitEff = {103275,103274}, hitEffType = {0,5}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill2", attackSound = 32701, hitSoundTime = 2000, hitSound = 28002})
mapArray:push({ id = 3270103, remote = 1,zoomIn= 1, attackEff = {1032710}, attackEffTime = {0}, attackEffType = {0}, hitEff = {103277}, hitEffType = {5}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill3", attackSound = 31901, hitSoundTime = 600, hitSound = 28002})

mapArray:push({ id = 403, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104031}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = {0}, attackAnim = "attack", attackSound = 23, hitSound = 0})
mapArray:push({ id = 4030100, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104032,104033}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitAnimTime3 = 1250, attackAnim = "skill", attackSound = 14602, attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 404, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104031}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = {0}, attackAnim = "attack", attackSound = 23, hitSound = 0})
mapArray:push({ id = 4040100, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104032,104033}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitAnimTime3 = 1250, attackAnim = "skill", attackSound = 14502, attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 405, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104051}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = {0}, attackAnim = "attack", attackSound = 23, hitSound = 0})
mapArray:push({ id = 4050100, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104052}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitAnimTime3 = 1250, attackAnim = "skill", attackSound = 10302, attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 406, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104051}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 100, hitEff = {0}, attackAnim = "attack", attackSound = 23, hitSound = 0})
mapArray:push({ id = 4060100, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {104052}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitAnimTime3 = 1250, attackAnim = "skill", attackSound = 4002, attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 328, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {103281}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 750, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 0})
mapArray:push({ id = 3280100, remote = 1,zoomIn= 1, attackEff = {103282,103289}, attackEffTime = {0}, attackEffType = {0,5}, showBuffDelayTime = 1000, hitAnimTime1 = 250, hitXuliEff = 103283, hitXuliEffTimeDelay = 3350, hitXuliEffType = 0, hitEff = {0}, hitEffType = {0}, attackAnim = "skill", attackSound = 29701, hitSound = 12 })
mapArray:push({ id = 3280101, remote = 1,zoomIn= 1, attackEff = {103284}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = {103285}, hitEffType = {0}, attackAnim = "skill3", attackSound = 31901, hitSound = 12})
mapArray:push({ id = 3280102, remote = 1,zoomIn= 1, needMoveCenter = 1, attackEff = {103286,103287}, attackEffOffsetY = {0,-22}, attackEffTime = {0}, attackEffType = {0,7}, showBuffDelayTime = 1850, hitAnimTime1 = 2500, hitAnimTime2 = 3000, hitAnimTime3 = 3200, hitAnimTime4 = 3400, hitXuliEff = 103288, hitXuliEffType = 1, hitXuliEffOffsetY = -42, hitEff = {102744}, hitEffType = {0}, attackAnim = "skill2", attackSound = 1202, hitSound = 12, shake = 10})

mapArray:push({ id = 120110, remote = 1,zoomIn= 1, attackEff = {100126,100127}, attackEffTime = {0}, attackEffType = {2,5}, hitEffType = {0}, hitAnimTime1 = 1400, hitEff = {0}, attackSound = 0,attackSoundTime = 0, attackAnim = "skill2", attackSound = 29801})

mapArray:push({ id = 318, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {103181}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 12})
mapArray:push({ id = 3180100, remote = 1,zoomIn= 1, attackEff = {103182,103183,103189}, attackEffTime = {0}, attackEffType = {5,0,6}, hitAnimTime1 = 3000, hitEff = {0}, attackAnim = "skill", attackSound = 27801, hitSound = 0})
mapArray:push({ id = 3180200, remote = 1,zoomIn= 1, attackEff = {103184,103188}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 750, hitEff = {0}, attackAnim = "skill2", attackSound = 10601, hitSound = 0})
mapArray:push({ id = 3180300, remote = 1,zoomIn= 1, attackEff = {103185,103186,1031810}, attackEffTime = {0}, attackEffType = {5,0,6}, hitAnimTime1 = 1500, hitXuliEff = 103187, hitXuliEffTimeDelay = 500, hitXuliEffOffsetY = -150, hitXuliEffType = 0, hitEff = {0}, hitEffType = {0}, attackAnim = "skill3", attackSound = 27601, hitSound = 0})

--伏魔录boss
mapArray:push({ id = 60003, remote = 0,zoomIn= 0, moveDistance = 230,attackEff = {101581}, attackEffTime = {0}, attackEffType = {0},hitEff = { 101022},hitAnimTime1 = 200,attackAnim = "attack",attackSound = 15801,hitSound = 42})

mapArray:push({ id = 60004, remote = 1,zoomIn= 1, attackEff = {600041}, attackEffTime = {600}, attackEffType = {1},attackEffOffsetY= {100},hitEff = {0},attackAnim = "skill3",hitAnimTime1 = 1400, attackSound = 29602,hitSound = 12,hitEffShowOnce = 1})

mapArray:push({ id = 60005, remote = 1,zoomIn= 1, attackEff = {600051,600052}, attackEffTime = {0}, attackEffType = {5,0},hitEff = {0},attackAnim = "skill2",hitAnimTime1 = 0, attackSound = 28002,hitSound = 0})


mapArray:push({ id = 319, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {103191}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250,hitAnimTime2 = 950, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 32})
mapArray:push({ id = 3190100, remote = 0,zoomIn= 0,attackEff = {103198}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 900,hitAnimTime3 = 1400,hitAnimTime4 = 1900,hitAnimTime5 = 2300,hitAnimTime6 = 3300, hitXuliEff = 103197,hitXuliEffType = 6, hitEffShowOnce = 1,attackAnim = "skill",attackSound = 28403,hitSound = 52})
mapArray:push({ id = 3190101, remote = 1,zoomIn= 1,attackEff = {103192}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900, hitEff = {103193},attackAnim = "skill3",attackSound = 31901,hitSound = 32})
mapArray:push({ id = 3190102, remote = 1,zoomIn= 1,attackEff = {103195}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitXuliEff = 103196,hitXuliEffTimeDelay = 2000, attackAnim = "skill2",attackSound = 29801,hitSound = 52})
mapArray:push({ id = 3190103, remote = 1,zoomIn= 1,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {0},attackAnim = "skill3",attackSound = 28002,hitSound = 0})

mapArray:push({ id = 320, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {103201}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 32})
mapArray:push({ id = 3200100, remote = 1,zoomIn= 1,moveDistance = 0,needMoveCenter = 1, attackEff = {103203,103202,103204},  attackEffTime = {0,0,0}, attackEffType = {7,0,1},hitEff = {1032011}, attackEffOffsetX = {-360,0,320},attackEffOffsetY = {0,0,-60}, hitAnimTime1 = 400,hitAnimTime2 = 1550,hitAnimTime3 = 3500,hitAnimTime4 = 4000, attackSound = 29801,hitSound = 12})
mapArray:push({ id = 3200102, remote = 1,zoomIn= 1, attackEff = {103205,103206,103207}, attackEffType = {0,7,1},attackEffOffsetX = {0,0,320},attackAnim = "skill3",hitEff = {1032011},hitAnimTime1 = 400,hitAnimTime2 = 700,hitAnimTime3 = 1000, attackSound = 16402,hitSound = 12})
mapArray:push({ id = 3200103, remote = 1,zoomIn= 1, attackEff = {103208,103209,1032010}, attackEffType = {5,0,1},attackEffTime = {0,0,1400}, attackEffOffsetX = {0,0,320},attackEffOffsetY = {0,0,-60},hitAnimTime1 = 3500, attackAnim = "skill2", attackSound = 29701,hitSound = 0,hitEffShowOnce = 1})

mapArray:push({ id = 285, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {102851}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 41})
mapArray:push({ id = 2850100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102852}, attackEffTime = {0},attackEffType = {0}, attackAnim = "skill",hitAnimTime1 = 1400,hitEff = {102854},hitEffTime = {0},attackSound = 15902,hitSound = 12})
mapArray:push({ id = 2850101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102855}, attackEffTime = {0}, attackEffType = {0}, attackAnim = "skill2",hitAnimTime1 = 800,hitEff = {102856}, hitEffTime = {0},attackSound = 31901,hitSound = 11})

mapArray:push({ id = 530011, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {530011,530012}, attackEffTime = {0}, attackEffType = {1,1},attackEffOffsetY = {-50,-50}, hitAnimTime1 = 300,hitAnimTime2 = 800,hitAnimTime3 = 1300,hitAnimTime4 = 1800, hitEff = {0},hitEffType = {0}, attackSound = 8010,hitSound = 0})
mapArray:push({ id = 530012, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {530011,530012,530013}, attackEffTime = {0}, attackEffType = {1,1,1},attackEffOffsetY = {-50,-50,0}, hitAnimTime1 = 300,hitAnimTime2 = 800,hitAnimTime3 = 1300,hitAnimTime4 = 1800, hitEff = {0},hitEffType = {0}, attackSound = 8010,hitSound = 0})

mapArray:push({ id = 530061, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {530061,530062}, attackEffTime = {0}, attackEffType = {7,0}, hitAnimTime1 = 2200, hitEff = {530063,530064},hitEffType = {5,0}, attackSound = 29201,attackSoundTime = 0, hitSound = 28002})
mapArray:push({ id = 530062, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {530065,530066}, attackEffTime = {0}, attackEffType = {7,0},attackEffOffsetX = {-510,0}, hitAnimTime1 = 2200, hitEff = {530063,530064},hitEffType = {5,0}, attackSound = 29201,attackSoundTime = 0, hitSound = 28002})

mapArray:push({ id = 286, remote = 0,zoomIn= 0, moveDistance = 50, attackEff = {102861}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 41})
mapArray:push({ id = 2860100, remote = 1,zoomIn= 1, attackEff = {102862}, attackEffTime = {0}, attackEffType = {0},hitEff = {102863},hitEffType = {1}, hitEffShowOnce = 1,hitEffOffsetX = {-650},hitEffOffsetY = {90}, hitAnimTime1 = 2000, attackSound = 2202,hitSound = 28601})
mapArray:push({ id = 2860101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102864,102865}, attackEffTime = {0,0},attackEffType = {0,5}, attackAnim = "skill2",hitAnimTime1 = 1300,hitEff = {102866},hitEffType = {5}, hitEffTime = {0},attackSound = 2202,hitSound = 28403})

mapArray:push({ id = 288, remote = 0,zoomIn= 0, moveDistance = 150, attackEff = {102881}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitEff = {0}, attackAnim = "attack", attackSound = 0,attackSound = 8901, hitSound = 23})
mapArray:push({ id = 2880100, remote = 1,zoomIn= 1, attackEff = {102882}, attackEffTime = {0}, attackEffType = {0},hitEff = {102883},hitEffType = {6}, hitEffShowOnce = 1, hitAnimTime1 = 500, hitAnimTime2 = 1000, hitAnimTime3 = 1500, hitAnimTime4 = 2000, hitXuliEff = 102884, hitXuliEffType = 0, hitXuliEffTimeDelay = 0, attackAnim = "skill", attackSound = 8302, hitSound = 15})
mapArray:push({ id = 2880101, remote = 1,zoomIn= 1, attackEff = {102885}, attackEffTime = {0}, attackEffType = {0},hitEff = {0},hitEffType = {0}, hitAnimTime1 = 1250, hitXuliEff = 102886, hitXuliEffType = 0, hitXuliEffTimeDelay = 0, attackAnim = "skill2", attackSound = 4302, hitSound = 15})

mapArray:push({ id = 329, remote = 0,zoomIn= 0, moveDistance = 100, attackEff = {103291}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitEff = {0}, attackAnim = "attack", attackSound = 602, hitSound = 15})
mapArray:push({ id = 3290100, remote = 1,zoomIn= 1, attackEff = {103292,103293}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {0}, hitEffType = {0}, hitXuliEff = 103295, hitXuliEffType = 0, hitXuliEffTimeDelay = 3000, hitAnimTime1 = 750, attackAnim = "skill1", attackSound = 27901, hitSound = 0})
mapArray:push({ id = 3290101, remote = 1,zoomIn= 1, attackEff = {103299,1032910,1032912}, attackEffTime = {0}, attackEffType = {6,9,0},hitEff = {1032911},hitEffType = {0}, hitAnimTime1 = 1000, attackAnim = "skill3", attackSound = 29602, hitSound = 0})
mapArray:push({ id = 3290102, remote = 1,zoomIn= 1, attackEff = {103296,103297,103298}, attackEffOffsetX = {0,0,150}, attackEffTime = {0}, attackEffType = {5,0,6}, hitEff = {0}, hitEffType = {0}, hitXuliEff = 103295, hitXuliEffType = 0, hitXuliEffTimeDelay = 2000, hitAnimTime1 = 750, attackAnim = "skill2", attackSound = 27801, hitSound = 0})

mapArray:push({ id = 330, remote = 0,zoomIn= 0, moveDistance = 100, attackEff = {103301}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 350, hitEff = {0}, attackAnim = "attack", attackSound = 201, hitSound = 0})
mapArray:push({ id = 3300100, remote = 1,zoomIn= 1, attackEff = {103302,103303}, attackEffTime = {0}, attackEffType = {0,5}, hitEff = {103304,103305}, hitEffType = {0,5}, hitAnimTime1 = 3250, attackAnim = "skill1", attackSound = 28901, hitSound = 52})
mapArray:push({ id = 3300101, remote = 1,zoomIn= 1, attackEff = {103306}, attackEffTime = {0}, attackEffType = {0}, hitXuliEff = 103307, hitXuliEffType = 0, hitXuliEffTimeDelay = 0, hitEff = {0}, hitEffType = {0}, hitAnimTime1 = 750, attackAnim = "skill3", attackSound = 602, hitSound = 12})
mapArray:push({ id = 3300102, remote = 1,zoomIn= 1, attackEff = {103308,103309,1033012}, attackEffTime = {0}, attackEffType = {0,5,1}, hitEff = {1033010,1033011}, hitEffType = {0,5}, hitAnimTime1 = 1500, hitAnimTime2 = 2250, hitAnimTime3 = 3000, attackAnim = "skill2", attackSound = 27601, hitSound = 13, hitEffShowOnce = 1, shake = 6})

mapArray:push({ id = 331, remote = 0,zoomIn= 0, moveDistance = 75, attackEff = {103311}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 1250, hitEff = {0}, attackAnim = "attack", attackSound = 402, hitSound = 33})
mapArray:push({ id = 3310100, remote = 1,zoomIn= 1, moveDistance = 200, needMoveSameRow = 1, attackEff = {103312,103313,1033110}, attackEffTime = {0}, attackEffType = {0,5,6}, attackEffOffsetX = {0,0,200}, attackEffOffsetY = {0,0,50}, hitAnimTime1 = 3250, hitAnimTime2 = 3500, hitEff = {0}, hitXuliEff = 103314, hitXuliEffType = 0, hitXuliEffTimeDelay = 0, attackAnim = "skill", attackSound = 28901, hitSound = 0})
mapArray:push({ id = 3310200, remote = 1,zoomIn= 1, attackEff = {103315}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = {102814}, hitEffType = {0}, attackAnim = "skill2", attackSound = 4402, hitSound = 28002})
mapArray:push({ id = 3310300, remote = 1,zoomIn= 1, attackEff = {103316,103317}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitEff = {0}, attackAnim = "skill2", attackSound = 27902, hitSound = 0})
mapArray:push({ id = 3310400, remote = 1,zoomIn= 1, attackEff = {103318,103319,1033112,1033113}, attackEffTime = {0}, attackEffType = {0,5,1,6}, attackEffOffsetX = {0,0,0,350}, attackEffOffsetY = {0,0,0,75}, hitAnimTime1 = 1000, hitEff = {102814}, hitEffType = {0}, hitXuliEff = 1033111, hitXuliEffTimeDelay = 2250, hitXuliEffType = 5, attackAnim = "skill1", attackSound = 27901, hitSound = 0})

mapArray:push({ id = 332, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103321}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = {0}, attackAnim = "attack", attackSound = 0,hitSound = 11})
mapArray:push({ id = 3320100, remote = 1, zoomIn = 1, attackEff = {103322,103323,1033215}, attackEffTime = {0}, attackEffType = {0,5,6}, hitAnimTime1 = 1550, hitEff = {103324}, hitEffType = {0}, attackAnim = "skill1", attackSound = 10102, hitSound = 0})
mapArray:push({ id = 3320200, remote = 1, zoomIn = 1, attackEff = {1033213,1033214}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 750, hitEff = {0}, hitEffType = {0}, attackAnim = "skill2", attackSound = 15802, hitSound = 0})
mapArray:push({ id = 3320300, remote = 1, zoomIn = 1, attackEff = {103328,103329,1033210,1033211}, attackEffTime = {0}, attackEffType = {0,8,8,6}, attackEffOffsetX = {0,0,0,300}, attackEffOffsetY = {0,0,0,50}, hitAnimTime1 = 1500, hitAnimTime2 = 2000, hitAnimTime3 = 4000, hitAnimTime4 = 4500, hitEff = {1033212}, hitEffType = {0}, attackAnim = "skill3", attackSound = 28901, hitSound = 12, shake = 10})
mapArray:push({ id = 3320400, remote = 1, zoomIn = 1, attackEff = {103325}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = {103326,103327}, hitEffType = {0,5}, attackAnim = "skill4", attackSound = 31901, hitSound = 28002})

mapArray:push({ id = 325, remote = 0, zoomIn = 0, moveDistance = 25, attackEff = {103251}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 250, hitAnimTime2 = 750, hitEffShowOnce = 1, hitEff = {0}, attackAnim = "attack", attackSound = 13401, hitSound = 14})
mapArray:push({ id = 3250100, remote = 1, zoomIn = 0, needMoveCenter, attackEff = {103252,103254}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 2000, hitEff = {103255,103257}, hitEffType = {8,0}, attackAnim = "skill", attackSound = 29801, hitSound = 12})
mapArray:push({ id = 3250200, remote = 1, zoomIn = 1, attackEff = {103253}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = {0}, hitEffType = {0}, hitXuliEff = 103256, hitXuliEffType = 8, hitXuliEffTimeDelay = 0, attackAnim = "skill1", attackSound = 1402, hitSound = 0})
mapArray:push({ id = 3250300, remote = 0, zoomIn = 0, moveDistance = 25, attackEff = {103258}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 750, hitEff = {0}, hitEffType = {0}, attackAnim = "skill2", attackSound = 2801, hitSound = 13})

mapArray:push({ id = 324, remote = 0, zoomIn = 0, moveDistance = 50, attackEff = {103241}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = {0}, attackAnim = "attack", attackSound = 501, hitSound = 11})
mapArray:push({ id = 3240100, remote = 1, zoomIn = 0, attackEff = {103242}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitEff = {0}, hitEffType = {0}, hitXuliEff = 103243, hitXuliEffType = 0, attackAnim = "skill2", attackSound = 32401, hitSound = 0})
mapArray:push({ id = 3240200, remote = 0, zoomIn = 0, moveDistance = 50, attackEff = {103244}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = {0}, hitEffType = {0}, attackAnim = "skill1", attackSound = 2801, hitSound = 11})

mapArray:push({ id = 333, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103331}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300,hitAnimTime2 = 1000, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 32})
mapArray:push({ id = 3330100, remote = 0,zoomIn= 0,moveDistance = 50,attackEff = {103333,103332},attackAnim = "skill1", attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 200, hitAnimTime2 = 900, hitEff = {0},hitEffTime ={0},hitEffType={0},attackSound = 0,hitSound = 11})
mapArray:push({ id = 3330101, remote = 0,zoomIn= 0,moveDistance = 50,attackEff = {103335,103334},attackAnim = "skill2", attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 200, hitEff = {0},hitEffTime ={0},hitEffType={0},attackSound = 0,hitSound = 11})
mapArray:push({ id = 3330102, remote = 0,zoomIn= 0,moveDistance = 50,attackEff = {103336,103337},attackAnim = "skill3", attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 200, hitAnimTime2 = 1100, hitEff = {0},hitEffTime ={0},hitEffType={0},attackSound = 0,hitSound = 11})
mapArray:push({ id = 3330103, remote = 0,zoomIn= 0,moveDistance = 50,attackEff = {103339,103338,1033310},attackAnim = "skill4", attackEffTime = {0}, attackEffType = {0,5,0}, attackEffOffsetX = {0,0,150}, hitAnimTime1 = 200, hitAnimTime2 = 1100, hitEff = {0}, hitEffTime ={0}, hitEffType={0}, attackSound = 0, hitSound = 11})
mapArray:push({ id = 3330104, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {1033311,1033313,1033312}, attackEffTime = {1000,0,0}, attackEffType = {1,0,6}, hitXuliEff = 1033315, hitXuliEffType = 13, hitXuliEffTimeDelay = 1150 , hitAnimTime1 = 500, hitAnimTime2 = 1000,hitAnimTime3 = 1250, hitEff = {1033314},hitEffType = {0}, attackAnim = "skill5", attackSound = 30801,attackSoundTime = 300, hitSound = 11})
mapArray:push({ id = 3330105, remote = 1,zoomIn= 1,moveDistance = 0, attackEff = {1033311,1033316,1033313,1033312}, attackEffTime = {900,2500,0,0}, attackEffType = {1,1,0,5}, hitXuliEff = 1033315, hitXuliEffType = 13, hitXuliEffTimeDelay = 950, hitAnimTime1 = 50, hitAnimTime2 = 600,hitAnimTime3 = 2100,hitAnimTime4 = 3100,hitEff = {1033314},hitEffType = {0}, attackAnim = "skill6", attackSound = 30801,attackSoundTime = 300, hitSound = 11})

mapArray:push({ id = 334, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103341}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = {0}, attackAnim = "attack", attackSound = 2791, hitSound = 32})
mapArray:push({ id = 3340100, remote = 1,zoomIn= 1,attackAnim = "skill1", attackEff = {1033414,103342,103343},attackEffTime = {0}, attackEffType = {1,0,6}, hitAnimTime1 = 1500, hitEff = { 103344,103345},hitEffType = {0,5}, attackSound = 27901,hitSound = 28002})
mapArray:push({ id = 3340101, remote = 0, zoomIn = 1, moveDistance = 150, attackEff = {103346}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = {103347}, attackAnim = "skill2", attackSound = 2791, hitSound = 31901})
mapArray:push({ id = 3340102, remote = 1,zoomIn= 1, attackEff = {1033415,103348,103349,1033413,1033410},attackEffTime = {0,0,2500,0,0}, attackEffType = {1,0,0,5,6},attackEffOffsetX = {0,0,0,0,250},attackEffOffsetY = {0,0,0,0,40}, hitAnimTime1 = 3500, hitEff = {1033411,1033412}, hitEffType = {0,5},attackAnim = "skill3", attackSound = 28001, hitSound = 28002})

mapArray:push({ id = 530111, remote = 1, zoomIn= 1, moveDistance = 0, attackEff = {530111,530112}, attackEffTime = {0}, attackEffType = {7,0}, hitAnimTime1 = 1700,  hitAnimTime2 = 2450, hitXuliEff = 530113, hitXuliEffType = 9, hitEff = {0}, hitEffType = {0}, attackAnim = "skill", attackSound = 27701,attackSoundTime = 0, hitSound = 12})
mapArray:push({ id = 530112, remote = 1, zoomIn= 1, moveDistance = 0, attackEff = {530114,530115}, attackEffTime = {0}, attackEffType = {7,0}, hitAnimTime1 = 1700,  hitAnimTime2 = 2450, hitXuliEff = 530116, hitXuliEffType = 9, hitEff = {0}, hitEffType = {0}, attackAnim = "skill", attackSound = 27701,attackSoundTime = 0, hitSound = 12})

mapArray:push({ id = 335, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103351,103352}, attackEffTime = {0}, attackEffType = {5,0}, hitAnimTime1 = 150,hitAnimTime2 = 1350, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 32})
mapArray:push({ id = 3350100, remote = 1,zoomIn= 1, attackEff = {103353,103354}, attackEffTime = {0}, attackEffType = {5,0}, attackAnim = "skill", hitAnimTime1 = 2100, hitEff = {103355,103356,1033517},hitEffType = {5,0,0},hitEffTime = {0,0,0}, attackSound = 33501,attackSoundTime = 500})
mapArray:push({ id = 3350101, remote = 1,zoomIn= 1, attackEff = {103357,103358}, attackEffTime = {0}, attackEffType = {5,0}, attackAnim = "skill2", hitAnimTime1 = 0, attackSound = 33502})
mapArray:push({ id = 3350102, remote = 1,zoomIn= 1, needMoveCenter = 1, attackEff = {103359,1033510,1033511,1033512,1033515},attackEffOffsetX = {0,0,90,250,0}, attackEffTime = {0,0,0,3600,3400}, attackEffType = {0,5,6,1,1}, hitAnimTime1 = 3600, hitEff = {1033516,1033513}, hitEffType = {0,6},hitEffTime = {0,0}, attackAnim = "skill3", attackSound = 28901, hitSound = 12})
mapArray:push({ id = 3350103, remote = 1,zoomIn= 1, attackEff = {1033514}, attackEffTime = {0}, attackEffType = {0}, attackAnim = "skill4",hitEff = {102814},hitEffType = {0}, hitAnimTime1 = 750, attackSound = 31901,hitSound = 28002})

mapArray:push({ id = 10101, remote = 1,zoomIn= 1, attackEff = {1000101,1000102}, attackEffTime = {0,2450},attackEffOffsetX ={0,230},attackEffOffsetY = {0,-80}, attackEffType = {0,1}, hitEff = {1000103},hitAnimTime1 = 2350,hitAnimTime2 = 2900,hitAnimTime3 = 3050, attackAnim = "skill", attackSound = 102,hitSound = 12})

mapArray:push({ id = 2950104, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {102959,102956,102957,102955}, needMoveSameRow = 1, attackEffTime = {0,3200,4200,4200}, attackEffType = {0,1,1,7},attackEffOffsetY = {0,70,0,0}, hitAnimTime1 = 4500, hitEff = {102958},hitEffTime = {0} ,hitEffType = {0},attackSound = 29501 ,attackSoundTime = 600,hitSound = 12})

mapArray:push({ id = 337, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103374}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 150,hitAnimTime2 = 800, hitEff = {103373}, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 3370100, remote = 1,zoomIn= 1, attackEff = {103371,103372}, attackEffTime = {900,0}, attackEffType = {5,0}, attackAnim = "skill", hitAnimTime1 = 0, hitEff = {0},hitEffType = {0},hitEffTime = {0}, attackSound = 33501,attackSoundTime = 0})
mapArray:push({ id = 3370101, remote = 1,zoomIn= 1, attackEff = {103375}, attackEffTime = {0}, attackEffType = {0}, hitEff = {103276}, hitEffType = {0}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill2", attackSound = 28002, attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 3370102, remote = 1,zoomIn= 1,attackEff = {103376}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 350, hitEff = {103377},attackAnim = "skill3",attackSound = 17802,hitSound = 12})
mapArray:push({ id = 3370103, remote = 1,zoomIn= 1, attackEff = {103378,103379,1033712}, attackEffTime = {0}, attackEffType = {0,5,5}, attackAnim = "skill4", hitAnimTime1 = 0, hitEff = {0},hitEffType = {0},hitEffTime = {0}, attackSound = 33501,attackSoundTime = 0})
mapArray:push({ id = 3370104, remote = 1,zoomIn= 1,attackEff = {1033710}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 800,hitAnimTime2 = 1300,hitEffShowOnce = 1, hitEff = {1033711},attackAnim = "skill5",attackSound = 2202,hitSound = 12,shake = 10 })

mapArray:push({ id = 313, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103131}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 150,hitAnimTime2 = 800, hitEff = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 3130100, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {103132,103133,103134},attackEffOffsetX = {0,0,-320},attackEffOffsetY = {0,0,65}, needMoveSameRow = 1, attackEffTime = {0,0,0}, attackEffType = {5,0,7},hitAnimTime1 = 2800, hitEff = {103135},hitEffTime = {0} ,hitEffType = {0},attackSound = 27901 ,attackSoundTime = 0,hitSound = 12})
mapArray:push({ id = 3130101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103136}, attackEffTime = {0},hitEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1000, hitEff = { 0}, hitEff = {103137},hitEffOffsetX = {-50}, attackAnim = "skill3",attackSound = 31901,hitSound = 12})
mapArray:push({ id = 3130102, remote = 1,zoomIn= 1,moveDistance = 200,needMoveCenter = 1, attackEff = {103138,103139,1031311,1031312},attackEffOffsetX = {0,0,300,-400}, attackEffTime = {0,0,0,0}, attackEffType = {5,0,1,7},hitAnimTime1 = 2300,hitAnimTime2 = 2500,hitAnimTime3 = 2800,hitAnimTime4 = 3500,hitAnimTime5 = 4000, attackAnim = "skill2", hitXuliEff = 1031310,hitEffTime = {0} ,hitEffType = {0},attackSound = 102 ,attackSoundTime = 0,hitSound = 28401})

mapArray:push({ id = 338, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103381,103382}, attackEffTime = {0}, attackEffType = {5,0}, hitAnimTime1 = 150,hitAnimTime2 = 800, hitEff = {103383},hitEffType = {5},hitEffShowOnce =1, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 3380100, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {103386,103385,103384,103387},attackEffOffsetX = {-560,0,0,-270},attackEffOffsetY = {75,0,0,-100}, attackEffTime = {0,0,0,0}, attackEffType = {7,0,5,1},hitAnimTime1 = 1300,hitAnimTime2 = 1700,hitAnimTime3 = 2100,hitAnimTime4 = 3000, attackAnim = "skill",hitEffTime = {0} ,hitEff = {103388},attackSound = 102 ,attackSoundTime = 0,hitSound = 28401})
mapArray:push({ id = 3380101, remote = 1,zoomIn= 1, attackEff = {1033822,103389,1033810,1033811,1033813,1033812,1033814,1033821}, attackEffTime = {0,0,0,1400,2000,2020,2040,0}, attackEffType = {7,5,0,1,1,1,1,1},attackEffOffsetX = {0,0,0,-15,-15,-15,-15,0},attackEffOffsetY = {0,0,0,-25,-25,-25,-25,0}, attackAnim = "skill2", hitAnimTime1 = 1700, hitEff = {0},hitEffType = {0},hitEffTime = {0}, attackSound = 33501,attackSoundTime = 0})
mapArray:push({ id = 3380102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {1033816,1033820,1033815,1033819},attackEffOffsetX = {-240,0,0,0}, attackEffTime = {50,40,0,0},hitEffTime = {0}, attackEffType = {7,5,0,1}, hitAnimTime1 = 1000, hitEff = {1033818},hitEffType = {5},hitXuliEff = 1033817, hitEffOffsetX = {0}, attackAnim = "skill3",attackSound = 31901,hitSound = 12})

mapArray:push({ id = 339, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {103391}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 150, hitEff = {103392},hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 7901})
mapArray:push({ id = 3390100, remote = 1,zoomIn= 1,attackAnim = "skill1", attackEff = {103395,103393,103394,103396},attackEffTime = {0}, attackEffType = {7,5,0,1},attackEffOffsetX = {-220,0,0,-220}, hitAnimTime1 = 2800, hitEff = { 103397},hitEffType = {0}, attackSound = 29201,hitSound = 28002})
mapArray:push({ id = 3390101, remote = 1,zoomIn= 1, attackEff = {103399,103398,1033913,1033910},attackEffOffsetX = {-320,0,0,-115},attackEffOffsetY = {69,0,0,0}, attackEffTime = {0}, attackEffType = {7,0,5,1}, attackAnim = "skill3", hitAnimTime1 = 2100, hitEff = {0},hitEffType = {0},hitEffTime = {0}, attackSound = 27901,hitSound = 28002})
mapArray:push({ id = 3390102, remote = 1,zoomIn= 1, attackEff = {1033911,1033912},attackEffTime = {0}, attackEffType = {0,5}, attackAnim = "skill30", hitAnimTime1 = 1000, hitEff = {103397},hitEffType = {0},hitEffTime = {0}, hitSound = 28002,attackSound = 12702})

mapArray:push({ id = 340, remote = 0, zoomIn = 0, moveDistance = 125, attackEff = {103401}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 1250, hitEff = {0},hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 3400100, remote = 1, zoomIn= 1, attackAnim = "skill", attackEff = {103402,103403,103405,103406,1034018}, attackEffOffsetY = {0,0,75,0,0}, attackEffTime = {0,0,0,750,0}, attackEffType = {0,5,10,1,6}, hitAnimTime1 = 2500, hitEff = {103404}, hitEffType = {0}, attackSound = 33501, hitSound = 12})
mapArray:push({ id = 3400104, remote = 1, zoomIn= 1, attackAnim = "skill2", attackEff = {103407,103408,1034017,103409,1034010,1034011},attackEffTime = {0,0,0,0,0,0}, attackEffOffsetX = {-250,0,0,0,0,120}, attackEffOffsetY = {-100,0,0,0,0,0}, attackEffType = {1,0,1,0,5,6}, hitAnimTime1 = 4250, hitEff = {1034016}, hitEffType = {0}, attackSound = 30801, hitSound = 12})
mapArray:push({ id = 3400105, remote = 1, zoomIn= 1, attackAnim = "skill3", attackEff = {1034012,1034013,1034014},attackEffTime = {0,0,0}, attackEffType = {1,0,6}, hitAnimTime1 = 750, hitEff = {1034015}, hitEffType = {0}, attackSound = 31901, hitSound = 12})

mapArray:push({ id = 314, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103141,103143}, attackEffTime = {0,0}, attackEffType = {0,5}, hitAnimTime1 = 750, hitEff = {103142}, hitEffType = {0}, attackAnim = "attack", attackSound = 7901, hitSound = 22})
mapArray:push({ id = 3140100, remote = 1, zoomIn= 1, attackAnim = "skill1", attackEff = {103144,103145}, attackEffTime = {0,0}, attackEffType = {0,5}, hitAnimTime1 = 2000, hitEff = {103146}, hitEffType = {0}, attackSound = 2202, hitSound = 11,attackSoundTime = 300})
mapArray:push({ id = 3140101, remote = 1, zoomIn= 1, needMoveCenter = 1, attackAnim = "skill2", attackEff = {103147,103148,1031410}, attackEffTime = {0,0,750}, attackEffType = {0,5,7}, hitAnimTime1 = 1000, hitEff = {103149}, hitEffType = {0}, attackSound = 11802, hitSound = 22})
mapArray:push({ id = 3140400, remote = 1, zoomIn= 1, attackAnim = "skill3", attackEff = {1031411,1031412,1031413,1031419}, attackEffTime = {0,0,0,0}, attackEffType = {0,5,1,6}, attackEffOffsetX = {0,0,0,250}, attackEffOffsetY = {0,0,0,50}, hitAnimTime1 = 0, hitEff = {0}, hitEffType = {0}, attackSound = 7804, hitSound = 0})
mapArray:push({ id = 3140401, remote = 1, zoomIn= 1, attackAnim = "skill4", attackEff = {1031414,1031415,1031416}, attackEffTime = {0,0,0}, attackEffType = {0,5,6}, hitAnimTime1 = 1000, hitAnimTime2 = 1500,hitAnimTime3 = 2000, hitEffShowOnce = 1, hitEff = {1031417,1031418}, hitEffType = {0,5}, attackSound = 31901, hitSound = 22})

mapArray:push({ id = 341, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103411}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 200, hitAnimTime2 = 700, hitEff = {0}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 3410100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103415,103416,103412,103417,103413,103414}, attackEffTime = {0}, attackEffType = {7,5,1,0,1,1},attackEffOffsetX = {-645,0,0,0,-100,-100},attackEffOffsetY = {0,0,0,0,0,0}, hitAnimTime1 = 2800,hitAnimTime2 = 3500, hitAnimTime3 = 4200, hitXuliEff = 103419, hitEff = {0}, hitEffType = {0}, attackAnim = "skill1", attackSound = 1902, hitSound = 12})
mapArray:push({ id = 3410101, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034111}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1550, hitEff = {1034110}, hitEffType = {0}, attackAnim = "skill2", attackSound = 31901,attackSoundTime = 500, hitSound = 51})
mapArray:push({ id = 3410102, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034112}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1150, hitEff = {102916}, hitEffType = {0}, attackAnim = "skill5", attackSound = 100101,attackSoundTime = 1000, hitSound = 28002})
mapArray:push({ id = 3410103, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034114,1034115,1034116,1034117},attackEffOffsetX = {0,0,-300,0},attackEffOffsetY = {0,0,-30,0}, attackEffTime = {0,0,100,2500}, attackEffType = {0,5,1,1}, hitAnimTime1 = 2200,hitAnimTime2 = 3200, hitEff = {0}, hitEffType = {0}, attackAnim = "skill4", attackSound = 25201, hitSound = 34101})
mapArray:push({ id = 3410104, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034121,1034118,1034119,1034122},attackEffOffsetX = {-350,0,0,0},attackEffOffsetY = {0,0,0,0}, attackEffTime = {0,0,0,0}, attackEffType = {7,0,5,1}, hitAnimTime1 = 1750, hitXuliEff = 1034120,hitEff = {0}, hitEffType = {0}, attackAnim = "skill5", attackSound = 202, hitSound = 12})

mapArray:push({ id = 342, remote = 0, zoomIn = 0, moveDistance = 150, attackEff = {103421}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1300, hitEff = {103422}, hitEffType = {0}, attackAnim = "attack", attackSound = 10101, hitSound = 11})
mapArray:push({ id = 3420100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103429,1034210,1034211,1034214,1034212,1034213}, attackEffTime = {0,0,0,0,0,0}, attackEffType = {0,0,5,6,10,7},attackEffOffsetX = {0,0,0,0,0,0}, attackEffOffsetY = {0,0,0,0,0,0}, hitAnimTime1 = 2800,hitEff = {0},  attackAnim = "skill1", attackSound = 25201, hitSound = 12})
mapArray:push({ id = 3420101, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103423,103424,103425,103426,103427},attackEffOffsetX = {0,0,0,-350,-300},attackEffOffsetY = {0,0,0,100,100}, attackEffTime = {0,0,3000,0,0}, attackEffType = {0,5,7,10,7}, hitAnimTime1 = 3800 ,hitEff = {103428}, hitEffType = {0}, attackAnim = "skill3", attackSound = 25201, hitSound = 12})
mapArray:push({ id = 3420102, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034215}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1600, hitEff = {1034216}, hitEffType = {0}, attackAnim = "skill2", attackSound = 31901,attackSoundTime = 500, hitSound = 51})

mapArray:push({ id = 343, remote = 0, zoomIn = 0, moveDistance = 30, attackEff = {103431}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 900, hitEff = {0}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 33})
mapArray:push({ id = 3430100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103432,103433,103434,103435,103436}, attackEffTime = {0,0,0,0,0}, attackEffType = {10,11,5,0,10},attackEffOffsetX = {-700,-700,0,0,0}, attackEffOffsetY = {0}, hitAnimTime1 = 1200,hitAnimTime2 = 1700,hitAnimTime3 = 2000,hitAnimTime4 = 2300,hitAnimTime5 = 2700,hitAnimTime6 = 3000,hitAnimTime7 = 4600,hitEff = {0},  attackAnim = "skill1", attackSound = 1202, hitSound = 12})
mapArray:push({ id = 3430101, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103438,103439},attackEffOffsetX = {0},attackEffOffsetY = {0}, attackEffTime = {0}, attackEffType = {0,0}, hitAnimTime1 = 0 ,hitEff = {103437}, hitEffType = {0}, attackAnim = "skill2", attackSound = 31901,hitSoundTime = 1300, hitSound = 28002})
mapArray:push({ id = 3430102, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034310,1034311,1034312,1034313,1034314,1034315}, attackEffTime = {0,0,0,0,0,0}, attackEffType = {5,0,6,0,9,0},attackEffOffsetX = {0,0,0,0,-70,0}, attackEffOffsetY = {0,0,0,0,0,0},hitAnimTime1 = 1600, hitEff = {0}, hitEffType = {0}, attackAnim = "skill3", attackSound = 28901,attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 3430103, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034316,1034317}, attackEffTime = {0,0}, attackEffType = {0,5}, hitAnimTime1 = 0, hitEff = {0}, hitEffType = {0}, attackAnim = "skill4", attackSound = 602,attackSoundTime = 0, hitSound = 0})

mapArray:push({ id = 344, remote = 0, zoomIn = 0, moveDistance = 30, attackEff = {103441,103442}, attackEffTime = {0,0}, attackEffType = {0,0}, hitAnimTime1 = 200, hitEff = {0,0}, hitEffType = {0,0}, attackAnim = "attack", attackSound = 0, hitSound = 2901})
mapArray:push({ id = 3440100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103443,103444,103445,103447}, attackEffTime = {0,0,0,0}, attackEffType = {6,5,0,5},attackEffOffsetX = {0,0,0,0}, attackEffOffsetY = {0,0,0,0}, hitAnimTime1 = 3700,hitEff = {103446},  attackAnim = "skill1",attackSoundTime = 500, attackSound = 28001, hitSound = 28002})
mapArray:push({ id = 3440101, remote = 1,zoomIn= 1, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitEff = {103276}, hitEffType = {0}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill2", attackSound = 0, attackSoundTime = 0, hitSound = 28002})
mapArray:push({ id = 3440102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {102814},hitEffTime = {0}, attackAnim = "skill3", attackSound = 0,attackSoundTime = 0,hitSound = 28002,hitSoundTime = 0})
mapArray:push({ id = 3440103, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103448,103449}, attackEffTime = {0,0}, attackEffType = {0,5},attackEffOffsetX = {0,0}, attackEffOffsetY = {0,0},hitAnimTime1 = 1600, hitEff = {0}, hitEffType = {0}, attackAnim = "skill4", attackSound = 1902,attackSoundTime = 0, hitSound = 0})
mapArray:push({ id = 3440104, remote = 1,zoomIn= 1, attackEff = {0},attackEffOffsetX ={0},attackEffOffsetY ={0}, attackEffTime = {0}, attackEffType = {0}, hitEff = {102814}, hitEffType = {0,5}, hitEffTime = {0}, hitAnimTime1 = 0, attackAnim = "skill2", attackSound = 0, hitSoundTime = 0, hitSound = 28002})

mapArray:push({ id = 345, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103451,103452}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 500, hitEff = {0}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 21})
mapArray:push({ id = 3450100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103453,103454,103455,103456,103458}, attackEffTime = {0,0,0,450,0}, attackEffType = {6,5,0,6,10},attackEffOffsetX = {350,0,0,0,0}, attackEffOffsetY = {95,0,0,0,0}, hitAnimTime1 = 2500,hitEff = {103457,1034515,1034516}, hitEffType = {0,0,5}, attackAnim = "skill1",attackSoundTime = 0, attackSound = 28001, hitSound = 51})
mapArray:push({ id = 3450400, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103459,1034510,1034511,1034512}, attackEffTime = {0}, attackEffType = {9,0,5,7},attackEffOffsetX = {0}, attackEffOffsetY = {0}, hitAnimTime1 = 1000,hitEff = {0},  attackAnim = "skill3",attackSoundTime = 0, attackSound = 29701,hitSound = 0})
mapArray:push({ id = 3450200, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034513}, attackEffTime = {0}, attackEffType = {0},attackEffOffsetX = {0}, attackEffOffsetY = {0}, hitAnimTime1 = 500,hitEff = {1034514},  attackAnim = "skill2",attackSoundTime = 0, attackSound = 31901, hitSound = 51})

mapArray:push({ id = 530161, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {530161,530162,530163},attackAnim = "skill", attackEffTime = {0}, attackEffType = {7,7,1},attackEffOffsetX = {-450,-450,-450}, hitAnimTime1 = 2800, hitEff = {530164},hitEffType = {0}, attackSound = 530162,attackSoundTime = 500, hitSound = 530161})

mapArray:push({ id = 322, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103221}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitEff = {0}, hitEffType = {0}, attackAnim = "attack", attackSound = 100101, hitSound = 32})
mapArray:push({ id = 3220100, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103222,103223},attackAnim = "skill1", attackEffType = {5,0}, hitAnimTime1 = 1800, hitEff = {103224,103225},hitEffTime = {0}, hitEffType = {5,0},attackSound = 102,attackSoundTime = 0,hitSound = 0,hitSoundTime = 0})
mapArray:push({ id = 3220101, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103226,103227,103228},attackAnim = "skill2", attackEffType = {5,0,1},attackEffOffsetX = {-60,0,-420},attackEffOffsetY = {-50,0,-200}, hitAnimTime1 = 1400,hitAnimTime2 = 1800, hitEff = {1032011},hitEffTime = {0}, hitEffType = {0},attackSound = 25201,attackSoundTime = 0,hitSound = 52,hitSoundTime = 0})
mapArray:push({ id = 3220102, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {103226,103227,103229},attackAnim = "skill2",attackEffTime = {0,0,1200},attackEffOffsetX = {-60,0,0},attackEffOffsetY = {-50,0,0}, attackEffType = {5,0,1}, hitAnimTime1 = 3500, hitEff = {1032011},hitEffTime = {0}, hitEffType = {0},attackSound = 1202,attackSoundTime = 0,hitSound = 52,hitSoundTime = 0})

mapArray:push({ id = 346, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103466}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0,hitAnimTime2 = 300, hitEff = {0}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 21})
mapArray:push({ id = 3460100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103461,103462,103463,103464}, attackEffTime = {0},attackEffOffsetX = {0,0,-300,0}, attackEffType = {5,0,7,1}, hitAnimTime1 = 2300,hitAnimTime2 = 2700,hitAnimTime3 = 3100,hitEffShowOnce = 1, hitEff = {103465}, hitEffType = {1},hitEffOffsetX = {-350},hitEffOffsetY = {-120}, attackAnim = "skill", attackSound = 27801, hitSound = 12})
mapArray:push({ id = 3460101, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {103295}, hitEffType = {0}, attackAnim = "skill2", attackSound = 0, hitSound = 28002})
mapArray:push({ id = 3460102, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103467,103468,103469,1034610,102904}, attackEffTime = {0,0,0,0,3000},attackEffOffsetX = {0,0,-680,0,-350},attackEffOffsetY = {0,0,0,0,110}, attackEffType = {5,0,7,1,10}, hitAnimTime1 = 3000,hitAnimTime2 = 3500,hitAnimTime3 =3800, hitEff = {0}, hitEffType = {0}, attackAnim = "skill3", attackSound = 27901, hitSound = 51})


mapArray:push({ id = 347, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103471}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900, hitEff = {0}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 21})
mapArray:push({ id = 3470100, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103479,1034711,103478}, attackEffTime = {0}, attackEffType = {5,0,1},attackEffOffsetX = {0,45,-155},attackEffOffsetY = {0,85,-100}, hitAnimTime1 = 4000, hitEff = {103475},hitEffOffsetX = {-100},hitEffOffsetY = {100}, hitEffType = {0}, attackAnim = "skill", attackSound = 29701, hitSound = 12})
mapArray:push({ id = 3470101, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103476}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900, hitEff = {103477},hitEffOffsetX = {-680},hitEffOffsetY = {-30},  hitEffType = {0}, attackAnim = "skill4", attackSound = 31901, hitSound = 51})
mapArray:push({ id = 3470102, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103472,103473},attackEffOffsetX = {0,85}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 900, hitEff = {0}, hitEffType = {0}, attackAnim = "skill2", attackSound = 31901, hitSound = 28002})
mapArray:push({ id = 3470103, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1034710,1034714,1034712,1034713,1034717,1034716}, attackEffTime = {0,600,1500,3000,0,4800},attackEffOffsetX = {0,-433,0,0,0,320},attackEffOffsetY = {0,-45,0,0,0,0}, attackEffType = {0,1,1,1,5,1}, hitAnimTime1 = 4800, hitEff = {0}, hitEffType = {0}, attackAnim = "skill3", attackSound = 28901,attackSoundTime = 1000, hitSound = 0})
mapArray:push({ id = 3470104, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {103474}, attackEffTime = {1000}, attackEffType = {0}, hitAnimTime1 = 1100, hitEff = {103475},hitEffOffsetX = {-100},hitEffOffsetY = {100}, hitEffType = {0}, attackAnim = "skill5", attackSound = 31901, hitSound = 51})

mapArray:push({ id = 60006, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {102821}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 580,hitAnimTime2 = 1150,attackAnim = "attack",attackSound = 28401,attackSoundTime = 300, hitSound = 0})
mapArray:push({ id = 600061, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {102822}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 900,attackAnim = "skill", hitAnimTime3 = 1200,hitAnimTime4 = 2500, hitEff = {0}, hitEffShowOnce = 1,hitEffTime = {0},attackSound = 30801,hitSound = 0})

mapArray:push({ id = 60007, remote = 0,zoomIn= 0, moveDistance = 120,attackEff = {102771}, attackEffTime = {0},attackEffType = {0},hitAnimTime1 = 450,hitAnimTime2 = 860,attackAnim = "attack",hitSound = 32,attackSound = 2701})
mapArray:push({ id = 600071, remote = 1,zoomIn= 1,moveDistance = 0,attackEff = {102773}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500,hitAnimTime2 = 2500,hitEffShowOnce = 0, hitEff = { 102774},attackSoundTime= 100,attackSound = 27701})

mapArray:push({ id = 348, remote = 0, zoomIn = 0, moveDistance = 75, attackEff = {0}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 150, hitEff = {0},hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 7901})
mapArray:push({ id = 3480100, remote = 1,zoomIn= 1,attackAnim = "1", attackEff = {103481,103482},attackEffTime = {0}, attackEffType = {0,5},attackEffOffsetX = {0,0}, hitAnimTime1 = 2800, hitEff = { 103483},hitEffType = {0}, attackSound = 0,hitSound = 0})
mapArray:push({ id = 3480101, remote = 1,zoomIn= 1, attackEff = {103481,103482},attackEffOffsetX = {0,0},attackEffOffsetY = {0,0}, attackEffTime = {0}, attackEffType = {0,5}, attackAnim = "1", hitAnimTime1 = 2100, hitEff = {0},hitEffType = {0},hitEffTime = {0}, attackSound = 0,hitSound = 28002})
mapArray:push({ id = 3480102, remote = 1,zoomIn= 1, attackEff = {103481,103482},attackEffTime = {0}, attackEffType = {0,5}, attackAnim = "2", hitAnimTime1 = 1000, hitEff = {103483},hitEffType = {0},hitEffTime = {0}, hitSound = 0,attackSound = 0})

mapArray:push({ id = 349, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103495}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 750, hitEff = {103494}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 3490100, remote = 1, zoomIn= 1, attackAnim = "skill2", attackEff = {103497}, attackEffTime = {0}, attackEffType = {5}, hitAnimTime1 = 2000, hitEff = {103496}, hitEffType = {0}, attackSound = 0, hitSound = 11,attackSoundTime = 300})
mapArray:push({ id = 3490101, remote = 1, zoomIn= 1, needMoveCenter = 1, attackAnim = "", attackEff = {103492,103493,103491}, attackEffTime = {0,0,750}, attackEffType = {0,5,7}, hitAnimTime1 = 1000, hitEff = {103149}, hitEffType = {0}, attackSound = 0, hitSound = 22})
mapArray:push({ id = 3490400, remote = 1, zoomIn= 1, attackAnim = "skill3", attackEff = {1031411,1031412,1031413,1031419}, attackEffTime = {0,0,0,0}, attackEffType = {0,5,1,6}, attackEffOffsetX = {0,0,0,250}, attackEffOffsetY = {0,0,0,50}, hitAnimTime1 = 0, hitEff = {0}, hitEffType = {0}, attackSound = 0, hitSound = 0})
mapArray:push({ id = 3490401, remote = 1, zoomIn= 1, attackAnim = "", attackEff = {103492,103493,103491}, attackEffTime = {0,0,0}, attackEffType = {7,7,7}, hitAnimTime1 = 1000, hitAnimTime2 = 1500,hitAnimTime3 = 2000, hitEffShowOnce = 1, hitEff = {}, hitEffType = {0}, attackSound = 0, hitSound = 22})

mapArray:push({ id = 350, remote = 0, zoomIn = 0, moveDistance = 125, attackEff = {103501}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 1250, hitEff = {103503},hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
--mapArray:push({ id = 3500100, remote = 1, zoomIn= 1, attackAnim = "skill", attackEff = {103402,103403,103405,103406,1034018}, attackEffOffsetY = {0,0,75,0,0}, attackEffTime = {0,0,0,750,0}, attackEffType = {0,5,10,1,6}, hitAnimTime1 = 2500, hitEff = {103404}, hitEffType = {0}, attackSound = 33501, hitSound = 12})
mapArray:push({ id = 3500100, remote = 0,zoomIn= 0,moveDistance = 150,attackEff = {101103}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 200, hitAnimTime2 = 500,hitAnimTime3 = 1000,hitEff = { 101088},attackSound = 0,hitSound = 11})

mapArray:push({ id = 3500104, remote = 0,zoomIn= 0,moveDistance = 100,attackEff = {100833}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 300, hitAnimTime2 = 800,hitAnimTime3 = 1200,hitEff = { 3702},attackSound = 0,hitSound = 21})

--mapArray:push({ id = 3500104, remote = 1, zoomIn= 1, attackAnim = "skill2", attackEff = {103408,1034017,103409,1034010,1034011},attackEffTime = {0,0,0,0,0}, attackEffOffsetX = {0,0,0,0,120}, attackEffOffsetY = {0,0,0,0,0}, attackEffType = {0,1,0,5,6}, hitAnimTime1 = 4250, hitEff = {1034016}, hitEffType = {0}, attackSound = 30801, hitSound = 12})
mapArray:push({ id = 3500105, remote = 1, zoomIn= 1, attackAnim = "skill3", attackEff = {1034012,1034013,1034014},attackEffTime = {0,0,0}, attackEffType = {1,0,6}, hitAnimTime1 = 750, hitEff = {1034015}, hitEffType = {0}, attackSound = 0, hitSound = 12})


--mapArray:push({ id = 350, remote = 0, zoomIn = 0, moveDistance = 125, attackEff = {103501}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 500, hitAnimTime2 = 1250, hitEff = {103503},hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
--mapArray:push({ id = 3500100, remote = 1, zoomIn= 1, attackAnim = "skill", attackEff = {103402,103403,103405,103406,1034018}, attackEffOffsetY = {0,0,75,0,0}, attackEffTime = {0,0,0,750,0}, attackEffType = {0,5,10,1,6}, hitAnimTime1 = 2500, hitEff = {103404}, hitEffType = {0}, attackSound = 0, hitSound = 12})
--mapArray:push({ id = 3500104, remote = 0, zoomIn= 0, attackAnim = "skill2", attackEff = {103501,103503},attackEffTime = {0,0}, attackEffOffsetX = {-250,0}, attackEffOffsetY = {-100,0}, attackEffType = {0,0}, hitAnimTime1 = 4250, hitEff = {1034016}, hitEffType = {0}, attackSound = 0, hitSound = 12})
--mapArray:push({ id = 3500105, remote = 0, zoomIn= 0,moveDistance = 50, attackAnim = "skill1", attackEff = {103501,103502,103503},attackEffTime = {0,0,0}, attackEffType = {0,5,7}, hitAnimTime1 = 750, hitEff = {1034015}, hitEffType = {0}, attackSound = 0, hitSound = 12})

mapArray:push({id = 351,	remote = 0,zoomIn= 0, attackEff = {10002101, 10002102, }, attackEffTime = {0, 0, 400, }, attackEffType = {0, 0, 0, }, hitEffType = {0, 0, }, hitEff = {10002103, 0, }, hitAnimTime1 = 350, hitAnimTime2 = 650, moveDistance = 200, attackEffOffsetX = {0, 0, 0, }, attackEffOffsetY = {0, 0, 0, }, hitEffOffsetX = {0, 0, 0, }, hitEffOffsetY = {0, 0, 0, }, hitEffTime = {0, 0, 0, }, attackSound = 15002, hitSound = 23, attackAnim = "attack", attackZOrder = {0, -1, 0, }, hitZOrder = {1, 0, 0, }, })
mapArray:push({id = 3510100,	remote = 0,zoomIn= 1, attackEff = {10002105, }, attackEffTime = {0, 0, }, attackEffType = {0, 0, 0, 0, }, hitEffType = {0, 0, }, hitEff = {10002103, 10002103, }, hitAnimTime1 = 400, hitAnimTime2 = 800, hitAnimTime3 = 1200, hitAnimTime4 = 2300, moveDistance = 170, attackEffOffsetX = {0, 0, }, attackEffOffsetY = {0, 0, }, hitEffOffsetX = {0, 0, }, hitEffOffsetY = {0, 0, }, hitEffTime = {0, 1000, }, hitEffShowOnce = 1, attackSound = 202, attackSoundTime = 500,hitSound = 22, attackAnim = "skill", attackZOrder = {1, 0, }, hitZOrder = {0, 0, }, })
mapArray:push({id = 3510101,	remote = 1,zoomIn= 1, attackEff = {10002109, }, attackEffTime = {0, }, attackEffType = {0, }, hitEffType = {0, }, hitEff = {0, }, hitAnimTime1 = 0, attackEffOffsetX = {0, }, attackEffOffsetY = {0, }, hitEffOffsetX = {0, }, hitEffOffsetY = {0, }, hitEffTime = {0, }, attackSound = 703, attackAnim = "skill2", attackZOrder = {0, }, hitZOrder = {0, }, })
--mapArray:push({ id = 351, remote = 0,zoomIn= 0, moveDistance = 150,attackEff = {103125}, attackEffTime = {50}, attackEffType = {0}, hitAnimTime1 = 250,hitAnimTime2 = 700, hitEff = {0},attackAnim = "attack",attackSound = 0,hitSound = 22})
--mapArray:push({ id = 3510100, remote = 1,zoomIn= 1,attackEff = {103128,103127}, attackEffTime = {0}, attackEffType = {5,0},hitAnimTime1 = 1600,hitAnimTime2 = 2200,hitAnimTime3 = 2500,hitAnimTime4 = 3600,hitAnimTime5 = 3700,hitAnimTime6 = 3800, hitEffShowOnce = 1,hitEff = {103129},hitEffType = {0},hitEffOffsetX={ -30},hitEffOffsetY={ -20}, hitEffTime = {0},attackSound = 30801,attackSoundTime = 550})
--mapArray:push({ id = 3510101, remote = 1,zoomIn= 1, attackEff = {103121}, attackAnim = "skill2", attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 0, hitEff = {0}, attackSound = 2202})
mapArray:push({ id = 3510102, remote = 1,zoomIn= 1, attackEff = {1031210,103124,103126,103122}, attackRotation = {false,false,false,true},attackAnim = "skill3", attackEffTime = {2700,2200,2100,0},attackEffType = {8,8,8,0},hitAnimTime1= 500, hitEff = {103123},hitEffTime ={0},hitEffType={0},attackSound = 30801,hitSound = 0})--, hitAnimTime2 = 2200,hitAnimTime3 = 2500

mapArray:push({id = 353,	remote = 0, attackEff = {10020101, }, attackEffTime = {0, 0, 0, }, attackEffType = {0, 0, 0, }, hitEffType = {0, 0, }, hitEff = {10020103, }, hitAnimTime1 = 1200, moveDistance = 110, attackEffOffsetX = {0, 0, }, attackEffOffsetY = {0, 0, }, hitEffOffsetX = {0, 0, }, hitEffOffsetY = {0, 0, }, hitEffTime = {0, 0, }, attackSound = 31901, hitSound = 51, attackAnim = "attack", needMoveSameRow = 1, shake = 6, attackZOrder = {1, 0, }, hitZOrder = {0, 0, }, })
mapArray:push({id = 3530300,	remote = 1, attackEff = {10020101, 10020102, }, attackEffTime = {0, 0, 0, 0, }, attackEffType = {0, 5, }, hitEffType = {0, 0, }, hitEff = {10020103, 0, }, hitAnimTime1 = 1000, hitAnimTime2 = 1150, hitAnimTime3 = 1300, hitAnimTime4 = 1480, attackEffOffsetX = {0, 0, }, attackEffOffsetY = {0, 0, }, hitEffOffsetX = {0, 0, }, hitEffOffsetY = {-90, 0, }, hitEffTime = {0, 0, }, hitEffShowOnce = 1, attackSound = 30801,  attackSoundTime = 400,attackAnim = "skill",  shake = 10, attackZOrder = {1, 0, }, hitZOrder = {0, 0, }, })
mapArray:push({id = 3530100,	remote = 1, attackEff = {10020101, 10020102, }, attackEffTime = {0, 0, 1500, 1500, 0, 0, 0, 0, }, attackEffType = {0, 5, 0, 5, 0, 0, 0, 0, 0, 0, }, hitEffType = {0, 5, 0, 0, }, hitEff = {0, 0, 0, 0, }, hitAnimTime1 = 0, attackEffOffsetX = {0, 0, 60, 20, }, attackEffOffsetY = {0, 0, 0, 0, }, hitEffOffsetX = {0, 0, 0, 0, }, hitEffOffsetY = {0, 0, 0, 0, }, hitEffTime = {0, 0, 0, 0, }, hitEffShowOnce = 1, attackSound = 27902, hitSound = 21, attackAnim = "skill2", shake = 10, attackZOrder = {1, 0, 0, 0, }, hitZOrder = {0, 0, 0, 0, }, })

--mapArray:push({ id = 349, remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103495}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 750, hitEff = {103494}, hitEffType = {0}, attackAnim = "attack", attackSound = 0, hitSound = 22})
--mapArray:push({ id = 1590100, remote = 1,zoomIn= 1,moveDistance = 80,attackEff = {101593}, attackEffTime = {0}, attackEffType = {0},hitAnimTime1 = 500,hitEff = { 101594},attackSound = 15902,hitSound = 43})
--mapArray:push({ id = 2950104, remote = 1,zoomIn= 1,moveDistance = 200,attackEff = {102959,102956,102957,102955}, needMoveSameRow = 1, attackEffTime = {0,3200,4200,4200}, attackEffType = {0,1,1,7},attackEffOffsetY = {0,70,0,0}, hitAnimTime1 = 4500, hitEff = {102958},hitEffTime = {0} ,hitEffType = {0},attackSound = 29501 ,attackSoundTime = 600,hitSound = 12})


mapArray:push({id = 352,	remote = 0, attackEff = {10003101, }, attackEffTime = {0, }, attackEffType = {0, }, hitEffType = {0, }, hitEff = {10003103, }, hitAnimTime1 = 566, moveDistance = 90, attackEffOffsetX = {0, }, attackEffOffsetY = {0, }, hitEffOffsetX = {0, }, hitEffOffsetY = {0, }, hitEffTime = {0, }, attackSound = 100101, hitSound = 22, attackAnim = "attack", attackZOrder = {0, }, hitZOrder = {0, }, })
mapArray:push({id = 3520100,	remote = 0, attackEff = {10003106, 10003103, }, attackEffTime = {0, 600, 0, }, attackEffType = {5, 0, 0, }, hitEffType = {0, 0, }, hitEff = {0, 0, }, hitAnimTime1 = 700, hitAnimTime2 = 900, hitAnimTime3 = 1400, hitAnimTime4 = 2000, moveDistance = 250, attackEffOffsetX = {0, 300, }, attackEffOffsetY = {0, 0, }, hitEffOffsetX = {0, 0, }, hitEffOffsetY = {0, 0, }, hitEffTime = {0, 0, }, hitEffShowOnce = 1, hitSound = 22, attackAnim = "skill", needMoveSameRow = 1, shake = 6, attackZOrder = {0, 0, }, hitZOrder = {0, 0, }, })
mapArray:push({id = 3520104,	remote = 1, attackEff = {10003106, }, attackEffTime = {0, }, attackEffType = {5, 0, 0, }, hitEffType = {0, }, hitEff = {10003103, }, hitAnimTime1 = 1000, attackEffOffsetX = {0, }, attackEffOffsetY = {0, }, hitEffOffsetX = {0, }, hitEffOffsetY = {0, }, hitEffTime = {0, }, hitEffShowOnce = 1, attackSound = 27902, attackSoundTime = 800, attackAnim = "skill2", attackZOrder = {0, }, hitZOrder = {0, }, })

mapArray:push({ id = 360, remote = 0,zoomIn= 0, moveDistance = 200, attackEff = {103601}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 400, hitEff = { 101077},attackAnim = "attack",attackSound = 1201,hitSound = 41})
mapArray:push({ id = 3600100, remote = 0,zoomIn= 0,moveDistance = 210,attackEff = {103603}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitAnimTime2 = 1800,hitAnimTime3 = 2000,hitAnimTime4 = 2700,hitEff = { 101077},attackSound = 1202,hitSound = 42})
mapArray:push({ id = 3600101, remote = 0,zoomIn= 0,moveDistance = 210,attackEff = {103605}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 1500, hitEffShowOnce = 1, hitEff = { 103604},attackSound = 1202,hitSound = 42})
mapArray:push({ id = 3600102, remote = 0,zoomIn= 0,moveDistance = 210,attackEff = {103605}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1= 1400, hitAnimTime2 = 1700,hitAnimTime3= 1900, hitAnimTime4= 2600, hitEffShowOnce = 1, hitEff = {0},hitEffType={0},hitEff = { 103604 },attackSound = 1202,hitSound = 42})--, hitAnimTime2 = 2200,hitAnimTime3 = 2500

mapArray:push({ id = 1348,  remote = 0, zoomIn = 0, moveDistance = 100, attackEff = {103374}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 150,hitAnimTime2 = 800, hitEff = {103373}, attackAnim = "attack", attackSound = 0, hitSound = 22})
mapArray:push({ id = 13480100, remote = 1, zoomIn = 0, moveDistance = 100, attackEff = {1013481,1013482}, attackEffTime = {0}, attackEffType = {5,0},attackEffOffsetX = {0,-10},attackEffOffsetY = {140,120}, hitAnimTime1 = 4000, hitEff = {1013483},hitEffOffsetX = {-100},hitEffOffsetY = {100}, hitEffType = {0}, attackAnim = "skill", attackSound = 29701, hitSound = 12})
mapArray:push({ id = 13480101, remote = 0, zoomIn = 1, moveDistance = 100, attackEff = {103476}, attackEffTime = {0}, attackEffType = {0}, hitAnimTime1 = 900, hitEff = {103477},hitEffOffsetX = {-680},hitEffOffsetY = {-30},  hitEffType = {0}, attackAnim = "skill4", attackSound = 31901, hitSound = 51})
mapArray:push({ id = 13480102, remote = 0, zoomIn = 1, moveDistance = 100, attackEff = {103472,103473},attackEffOffsetX = {0,85}, attackEffTime = {0}, attackEffType = {0,5}, hitAnimTime1 = 900, hitEff = {0}, hitEffType = {0}, attackAnim = "skill2", attackSound = 31901, hitSound = 28002})
mapArray:push({ id = 13480103, remote = 1, zoomIn = 1, moveDistance = 100, attackEff = {1013485,1013486,1013484,1013487,1013488}, attackEffTime = {0,0,0,8000,8000},needMoveCenter = 0,attackEffOffsetX = {0,0,10,0,-250},attackEffOffsetY = {80,-80,20,0,0}, attackEffType = {1,1,1,11,10}, hitAnimTime1 = 9000, hitEff = {0}, hitEffType = {0}, attackAnim = "skill4", attackSound = 28901,attackSoundTime = 1000, hitSound = 12})

return mapArray
