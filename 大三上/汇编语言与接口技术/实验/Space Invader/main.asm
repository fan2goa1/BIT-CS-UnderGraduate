;--------------------------------------------------------------------------------------
;@ProjectName    :   Space_Invader_ASM
;@Version1       :   Space_Invader_ASM_v1.5
;@LastEditTime   :   2022/12/13
;@Author         :   张益宁、郑子帆、安禹堃、方辰
;--------------------------------------------------------------------------------------
.386
.model		flat,stdcall
option		casemap:none
include		windows.inc
include		gdi32.inc
include		masm32.inc
include		kernel32.inc
include		user32.inc
include		winmm.inc
includelib	gdi32.lib
includelib  msvcrt.lib
includelib	winmm.lib
includelib	user32.lib
includelib	kernel32.lib
includelib	kernel32.lib
rand	proto C
srand	proto C:dword
printf  proto C:ptr sbyte,:vararg

.const
str1 byte '两张背景图片的位置：%d %d',0ah,0

MAXSIZE equ 1000;用来表示各种数组的大小
freshTime dword 60;刷新时间，以毫秒为单位

;图片资源地址声明
;如果要重制图片记住必须用bmp
;菜单按钮
MENU_START byte 'source\menu_start.bmp',0
MENU_QUIT byte 'source\menu_quit.bmp',0
MENU_CONTINUE byte 'source\menu_continue.bmp',0
MENU_RESTART byte 'source\menu_restart.bmp',0
MENUmask byte 'source\menumask.bmp',0

; 能量槽
ENERGYPLOT byte 'source\EnergyPlot.bmp', 0
ENERGYPLOTMASK byte 'source\EnergyPlotmask.bmp', 0

; 大招1：金刚弹
BUDDHA byte 'source\Buddha.bmp', 0
BUDDHABLACK byte 'source\BuddhaBlack.bmp', 0
BUDDHAMASK byte 'source\Buddhamask.bmp', 0
; 大招2：自检修复
CHECKANDREPAIR byte 'source\CheckAndRepair.bmp', 0
CHECKANDREPAIRBLACK byte 'source\CheckAndRepairBlack.bmp', 0

;木板障碍物
BOARDPIC byte 'source\board.bmp',0
BOARDMASK byte 'source\boardmask.bmp',0

; 血包
LIFEBAG byte 'source\LifeBag.bmp', 0
LIFEBAGMASK byte 'source\LifeBagmask.bmp', 0

;自己和敌人的子弹Pbullet和Ebullet
PBULLET0 byte 'source\pBullet0.bmp',0
PBULLET0mask byte 'source\pBullet0mask.bmp',0
PBULLET1 byte 'source\pBullet1.bmp',0
PBULLET1mask byte 'source\pBullet1mask.bmp',0

EBULLET0 byte 'source\eBullet0.bmp',0
EBULLET0mask byte 'source\eBullet0mask.bmp',0
EBULLET1 byte 'source\eBullet1.bmp',0
EBULLET1mask byte 'source\eBullet1mask.bmp',0

;敌人的图片，最好重制一下
ENEMY0 byte 'source\enemy0.bmp',0
ENEMYMask0 byte 'source\enemy0mask.bmp',0
ENEMY1 byte 'source\enemy1.bmp',0
ENEMYMask1 byte 'source\enemy1mask.bmp',0

;自己的图片，最好重制一下
PLAYER_NORMAL byte 'source\plane_R.bmp',0 ;人物正常的时候，使用的图片
PLAYER_NORMALmask byte 'source\plane_Rmask.bmp',0 ;正常时的掩码
PLAYER_RIGHT byte 'source\plane_R.bmp',0 ;人物向右移动的时候，使用的图片
PLAYER_RIGHTmask byte 'source\plane_Rmask.bmp', 0
PLAYER_LEFT byte 'source\plane_L.bmp',0 ;人物向左移动的时候，使用的图片
PLAYER_LEFTmask byte 'source\plane_Lmask.bmp', 0
PLAYER_UP byte 'source\plane_U.bmp',0 ;人物向上移动的时候，使用的图片
PLAYER_UPmask byte 'source\plane_Umask.bmp', 0
PLAYER_DOWN byte 'source\plane_D.bmp',0 ;人物向下移动的时候，使用的图片
PLAYER_DOWNmask byte 'source\plane_Dmask.bmp', 0

;背景图片，最好重制一下，现在划过一页的时候还是有点奇怪，我电脑没PS，用美图秀秀做的，当占位符了没办法
back byte 'source\back.bmp',0

;生命值
HEART byte 'source\heart.bmp',0
HEARTMASK byte 'source\heartmask.bmp',0

;返回和暂停的按钮，建议重制
STOPBUTTON byte 'source\button_stop.bmp',0
RETURNBUTTON byte 'source\button_return.bmp',0

; 得分数字
NUM0 byte 'source\num0.bmp', 0
NUM1 byte 'source\num1.bmp', 0
NUM2 byte 'source\num2.bmp', 0
NUM3 byte 'source\num3.bmp', 0
NUM4 byte 'source\num4.bmp', 0
NUM5 byte 'source\num5.bmp', 0
NUM6 byte 'source\num6.bmp', 0
NUM7 byte 'source\num7.bmp', 0
NUM8 byte 'source\num8.bmp', 0
NUM9 byte 'source\num9.bmp', 0

.data
;位图结构
ITEAM struct
	hbp dd ? ;位图的句柄
	x dd ? ;位图x坐标
	y dd ?;位图y坐标
	w dd ?;位图宽度
	h dd ?;位图高度
	flag dd ?;位图的展示方式
ITEAM ends

;玩家结构
PLAYER struct
	x dd ?
	y dd ?
	w dd ?
	h dd ?
	center_x dd ? ;人物的中心，x坐标，用来检测碰撞
	center_y dd ? ;人物的中心，y坐标，用来检测碰撞
	IMAGE_FLAG dd ?;人物对应的图形句柄
	UpCount dd ? ;记录向上按键被连续按下的次数，当超过一定次数之后，切换图片
	DownCount dd ?;向下按键
	LeftCount dd ?;向左按键
	RightCount dd ?;向右按键
	Speed dd ?  ;飞机速度
	HP dd ? ;飞机血量
	EnergyLevel dd ?	; 能量级别：1-3，每击落一个敌人能量级别+1
	Big1 dd ? ;	大招1：能量槽满，打的“金刚弹”可以穿透子弹
	Big2 dd ? ; 大招2：自检修复，如果此时血量不满，可以增加一滴血
	Big3 dd ? ; 大招3：使用僚机，可以加强火力
PLAYER ends

;木板障碍结构
BOARD struct
	x dword ?
	y dword ?
	w dword ?
	h dword ?
	flag dword ? ;用来判断板子是否被击中
	center_x dd ? ;板子的中心，x坐标，用来检测碰撞
	center_y dd ? ;板子的中心，y坐标，用来检测碰撞
BOARD ends

LBAG struct
	x dword ?
	y dword ?
	w dword ?
	h dword ?
	flag dword ?	; 用来判断血包是否被拾取
	center_x dd ?	; 血包的中心，x坐标，用来检测拾取
	center_y dd ?	; 血包的中心，y坐标，用来检测拾取
LBAG ends

;本机子弹结构
PBULLET struct
	x dd ? ;坐标
	y dd ?
	center_x dd ? ;中心坐标，检测碰撞用
	center_y dd ?
	radius dd ? ;半径
	flag dd ? ;有效性检查
	Speed dd ? ;子弹的速度
	BulletType dd ?	; 子弹的种类（0：普通弹	1：金刚弹）
PBULLET ends

;敌军结构
;敌方从右边出现，遵从固定模式，左移，停止开始射击，停留一段时间后继续左移至出界
;计划是做两种敌人，均为随机出现，一种瞄准我方发射高伤大弹，另一种固定向八个位置发射小弹
ENEMY struct
	x dd ?
	y dd ?
	w dd ?
	h dd ?
	center_x dd ? ;人物的中心，x坐标，用来检测碰撞
	center_y dd ? ;人物的中心，y坐标，用来检测碰撞
	LP dd ? ;生命值，也做标识用
	Speed dd ? ;向左移动的速度
	MoveTime dd ? ;第一段位移的时间
	StayTime dd ? ;运动一段时间后停留的时间
	EType dd ?	;类型，0为散弹，1为重弹
	nextShoot dd ? ;
	shootInterval dd ? ;攻击间隔
	BulletType dd ?
ENEMY ends

;敌军子弹结构
EBULLET struct
	x dd ? ;坐标
	y dd ?
	center_x dd ? ;中心坐标，检测碰撞用
	center_y dd ?
	radius dd ? ;还是继续用圆点
	disp_x dd ? ;x方向每时刻位移
	disp_y dd ? ;y方向每时刻位移
	damage dd ? ;伤害
	flag dd ? ;有效性检查
	EBType dd ? ;种类
EBULLET ends

;背景结构
BACKGROUND struct
	firx dd ?;第一张图片的x坐标
	firy dd ? ;第一张图片的y坐标
	firw dd ? ;第一张图片的宽
	firh dd ? ;第一张图片的高
	secx dd ?;第二张图片的x坐标
	secy dd ? ;第二张图片的y坐标
	secw dd ? ;第二张图片的宽
	sech dd ? ;第二张图片的高	
BACKGROUND ends

;初始化声明
;<>里面的是代表结构体的初始化
background BACKGROUND <?,?,?,?,?,?,?,?>;背景
hInstance dword ? ;程序的句柄
hWinMain dword ?;窗体的句柄
MyWinClass byte 'MyWinClass',0;注册窗体时用的类名
WinTitle byte 'Space Invader',0;窗体左上角的标题
player PLAYER <> 
wingmans PLAYER <>,<>

boards BOARD MAXSIZE dup(<0,0,0,0,0,0,0>);用来存储板子
boardCount dword 0;记录板子的数量

LifeBag LBAG <0, 0, 0, 0, 0, 0, 0>	; 用来存储血包
LifeBagCount dword 0;	记录当前血包的数量（取值只可能是0或1）

iteams ITEAM 4096 dup(<?,?,?,?,?,?>);用来存储位图
iteamCount dword 0		;iteams当中位图的数量

pBullet PBULLET MAXSIZE dup(<0,0,0,0,0,0,0>) ;自己子弹
pBulletCount dword 0;

eBullet EBULLET 200 dup(<0,0,0,0,0,0,0,0,0>) ;敌机子弹
eBulletCount dword 0;

enemy ENEMY MAXSIZE dup(<0,0,0,0,0,0,0,0,0,0,0,0,0,0>) ;敌人
enemyCount dword 0;

stRect RECT <0,0,0,0>;客户窗口的大小，right代表长，bottom代表高

PaintFlag dword ?;用来告诉WM_PAINT函数要画哪一一个界面

timer dd 0		; 计时器，用于刷新产生敌机

EnemyInterval dword 180 ;敌人的刷新频率
UpgradeDifficult dword 0	; 游戏难度升级的flag，当且仅当游戏得分十位数进位，难度升级

LifeBagInterval dword 500	; 血包的刷新频率，初始设定为500
LifeBagTimer dword 0		; 血包的计时器

Big1StartTime dword 0	; 大招1“金刚弹”开始的时间
Big3StartTime dword 0   ; 大招3 “使用僚机”开始的时间

;ayk添加
;----------------------------------------------------------------
generate_flag dword 1	;控制是否在生成新的小敌机和木板，生成boss后将flag置为0
;-----------------------------------------------------------------

;位图的指针
hStartButton dword ? ;开始游戏按钮
hExitButton dword ? ;退出游戏按钮
hContinueButton dword ? ;继续游戏按钮
hRestartButton dword ? ;重新开始按钮

hMenumask dword ?
hback dword ?;1 背景图片

hEnemy0 dword ?;敌人的图片
hEnemyMask0 dword ?
hEnemy1 dword ?;敌人的图片
hEnemyMask1 dword ?

hEnergyPlot dword ?	; 能量槽
hEnergyPlotMask dword ?

hLifeBag dword ?	; 血包
hLifeBagMask dword ?

hBuddha dword ?		; 大招1：金刚弹
hBuddhaBlack dword ?	; 大招1 冷却期间
hBuddhaMask dword ?	; 大招的mask
hCheckAndRepair dword ?	; 大招2：自检修复
hCheckAndRepairBlack dword ? ; 大招2 冷却期间
hWingmans dword ? ;僚机的图片
hWingmansMask dword ? ;大招3 mask
hWingmanButton dword ? ;大招3 僚机按钮
hWingmanButtonBlack dword ? ;大招3 冷却时间
hWingmanButtonMask dword ? ; 僚机按钮遮罩

hPlayerNormal0 dword ?;人物正常时候的图片
hPlayerNormalMask0 dword ?
hPlayerRight0 dword ?;人物向右时候的图片
hPlayerRightMask0 dword ?
hPlayerLeft0 dword ?;人物向左时候的图片
hPlayerLeftMask0 dword ?
hPlayerUp0 dword ?;人物向上时候的图片
hPlayerUpMask0 dword ?
hPlayerDown0 dword ?;人物向下时候的图片
hPlayerDownMask0 dword ?

hBoard dword ? ;板子的图片
hBoardmask dword ?

hPBullet0 dword ?;自己的子弹0
hPBullet0mask dword ?
hPBullet1 dword ?; 自己的子弹1（金刚弹）
hPBullet1mask dword ?

hEBullet0 dword ?;敌人的子弹0
hEBullet0mask dword ?

hEBullet1 dword ?;敌人的子弹1
hEBullet1mask dword ?

hEnemy dword ?;敌人
hStopButton dword ?;暂停按钮
hReturnButton dword ?;返回按钮
hHeart dword ?;生命值
hHeartMask dword ?;生命值
hButtonMask dword ?;按钮遮罩
hHelpButton dword ?;帮助按钮
hHelp dword ?;帮助
hHelpMask dword ?;帮助遮罩
;----------------------------------------------------------------------------------
hEnemyHealth dword ?;敌人血条
hBoss dword ?;boss
hBossMask dword ?;boss遮罩
hVictory dword ?;胜利文字
hVictoryMask dword ?;胜利文字遮罩
;----------------------------------------------------------------------------------

; 数字0-9
hNum0 dword ?
hNum1 dword ?
hNum2 dword ?
hNum3 dword ?
hNum4 dword ?
hNum5 dword ?
hNum6 dword ?
hNum7 dword ?
hNum8 dword ?
hNum9 dword ?
;数字遮罩
hNum0Mask dword ?
hNum1Mask dword ?
hNum2Mask dword ?
hNum3Mask dword ?
hNum4Mask dword ?
hNum5Mask dword ?
hNum6Mask dword ?
hNum7Mask dword ?
hNum8Mask dword ?
hNum9Mask dword ?

; 得分 这里考虑用两位表示
MyScore_ten dword 0
MyScore_one dword 0
MAX_ENERGY equ 3
boss_thre equ 2
slot_width equ 60
;---------------------------------------------------------------------------------
; by 郑子帆:
; 考虑到如果直接LoadImage的话无法单独运行exe文件，除非把source文件夹和exe文件放在同一级文件夹下
; 所以这里我考虑将所有LoadImage替换成LoadBitmap，故这里需要导入所有位图资源的ID
; 后面的人再进行更改的时候请把位图导入到这个项目的资源库，并通过LoadBitmap进行加载
;---------------------------------------------------------------------------------
IDB_BACK dword 102
IDB_board dword 103
IDB_boardmask dword 104
IDB_Buddha dword 105
IDB_BuddhaBlack dword 106
IDB_Buddhamask dword 107
IDB_button_return dword 108
IDB_button_stop dword 109
IDB_CheckAndRepair dword 110
IDB_CheckAndRepairBlack dword 111
IDB_eBullet0 dword 112
IDB_eBullet0mask dword 113
IDB_eBullet1 dword 114
IDB_eBullet1mask dword 115
IDB_enemy0 dword 116
IDB_enemy0mask dword 117
IDB_enemy1 dword 118
IDB_enemy1mask dword 119
IDB_EnergyPlot dword 120
IDB_EnergyPlotmask dword 121
IDB_heart dword 122
IDB_heartmask dword 123
IDB_LifeBag dword 124
IDB_LifeBagmask dword 125
IDB_menu_continue dword 126
IDB_menu_quit dword 127
IDB_menu_restart dword 128
IDB_menu_start dword 129
IDB_menumask dword 130
IDB_num0 dword 131
IDB_num1 dword 132
IDB_num2 dword 133
IDB_num3 dword 134
IDB_num4 dword 135
IDB_num5 dword 136
IDB_num6 dword 137
IDB_num7 dword 138
IDB_num8 dword 139
IDB_num9 dword 140
IDB_pBullet0 dword 141
IDB_pBullet0mask dword 142
IDB_pBullet1 dword 143
IDB_pBullet1mask dword 144
IDB_plane_D dword 145
IDB_plane_Dmask dword 146
IDB_plane_L dword 147
IDB_plane_Lmask dword 148
IDB_plane_R dword 149
IDB_plane_Rmask dword 150
IDB_plane_U dword 151
IDB_plane_Umask dword 152

IDB_help_button dword 153
IDB_buttonmask dword 154
IDB_help dword 155
IDB_helpmask dword 156
;----------------------------------------------------------------------------------
IDB_enemy_health dword 157
IDB_boss dword 158
IDB_boss_mask dword 159
IDB_victory dword 160
IDB_victory_mask dword 161
IDB_num0_mask dword 162
IDB_num1_mask dword 163
IDB_num2_mask dword 164
IDB_num3_mask dword 165
IDB_num4_mask dword 166
IDB_num5_mask dword 167
IDB_num6_mask dword 168
IDB_num7_mask dword 169
IDB_num8_mask dword 170
IDB_num9_mask dword 171
IDB_wingman dword 172
IDB_wingman_button dword 173
IDB_wingmanMask dword 174
IDB_wingman_buttonBlack dword 175
;----------------------------------------------------------------------------------


.code
;--------------------------------------------------------------------------------------
;@Function Name :  LoadBitImage
;@Param			:  	
;@Description   :  在游戏开始的时候，将所有位图加载到内存
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
LoadBitImage proc	uses eax ebx ecx edx esi edi 
	;加载需要用到的图片
	;返回值是相关数据的句柄
	;所有按钮
	
	;invoke LoadImage,hInstance,offset MENU_START,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_menu_start
	mov hStartButton,eax
	;invoke LoadImage,hInstance,offset MENU_QUIT,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_menu_quit
	mov hExitButton,eax
	;invoke LoadImage,hInstance,offset MENU_CONTINUE,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_menu_continue
	mov hContinueButton,eax
	;invoke LoadImage,hInstance,offset MENU_RESTART,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_menu_restart
	mov hRestartButton,eax
	;invoke LoadImage,hInstance,offset MENUmask,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_menumask
	mov hMenumask,eax

	invoke LoadBitmap, hInstance, IDB_help_button
	mov hHelpButton,eax

	invoke LoadBitmap, hInstance, IDB_buttonmask
	mov hButtonMask,eax

	;帮助图片
	invoke LoadBitmap, hInstance, IDB_help
	mov hHelp,eax

	invoke LoadBitmap, hInstance, IDB_helpmask
	mov hHelpMask,eax

;----------------------------------------------------------------------------------
	;敌人血条
	invoke LoadBitmap, hInstance, IDB_enemy_health
	mov hEnemyHealth,eax

	;boss以及胜利文字
	invoke LoadBitmap, hInstance, IDB_boss
	mov hBoss, eax

	invoke LoadBitmap, hInstance, IDB_boss_mask
	mov hBossMask, eax

	invoke LoadBitmap, hInstance, IDB_victory
	mov hVictory, eax

	invoke LoadBitmap, hInstance, IDB_victory_mask
	mov hVictoryMask, eax
;----------------------------------------------------------------------------------

	;背景
	;invoke LoadImage,hInstance,offset back,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_BACK
	mov hback, eax

	; 能量槽
	;invoke LoadImage,hInstance,offset ENERGYPLOT,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_EnergyPlot
	mov hEnergyPlot, eax
	;invoke LoadImage,hInstance,offset ENERGYPLOTMASK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_EnergyPlotmask
	mov hEnergyPlotMask, eax

	; 血包
	;invoke LoadImage,hInstance,offset LIFEBAG, IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_LifeBag
	mov hLifeBag, eax
	;invoke LoadImage,hInstance,offset LIFEBAGMASK, IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_LifeBagmask
	mov hLifeBagMask, eax
	
	; 大招1：金刚弹
	;invoke LoadImage,hInstance,offset BUDDHA,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_Buddha
	mov hBuddha, eax
	;invoke LoadImage,hInstance,offset BUDDHAMASK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_Buddhamask
	mov hBuddhaMask, eax
	;invoke LoadImage,hInstance,offset BUDDHABLACK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_BuddhaBlack
	mov hBuddhaBlack, eax

	; 大招2：自检修复
	;invoke LoadImage,hInstance,offset CHECKANDREPAIR,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_CheckAndRepair
	mov hCheckAndRepair, eax
	;invoke LoadImage,hInstance,offset CHECKANDREPAIRBLACK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_CheckAndRepairBlack
	mov hCheckAndRepairBlack, eax

	; 大招3：僚机和僚机按钮
	invoke LoadBitmap, hInstance, IDB_wingman_button
	mov hWingmanButton, eax
	invoke LoadBitmap, hInstance, IDB_wingmanMask
	mov hWingmansMask, eax
	invoke LoadBitmap, hInstance, IDB_wingman_buttonBlack
	mov hWingmanButtonBlack, eax

	; 得分 数字0-9
	;invoke LoadImage,hInstance,offset NUM0,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num0
	mov hNum0, eax
	;invoke LoadImage,hInstance,offset NUM1,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num1
	mov hNum1, eax
	;invoke LoadImage,hInstance,offset NUM2,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num2
	mov hNum2, eax
	;invoke LoadImage,hInstance,offset NUM3,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num3
	mov hNum3, eax
	;invoke LoadImage,hInstance,offset NUM4,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num4
	mov hNum4, eax
	;invoke LoadImage,hInstance,offset NUM5,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num5
	mov hNum5, eax
	;invoke LoadImage,hInstance,offset NUM6,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num6
	mov hNum6, eax
	;invoke LoadImage,hInstance,offset NUM7,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num7
	mov hNum7, eax
	;invoke LoadImage,hInstance,offset NUM8,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num8
	mov hNum8, eax
	;invoke LoadImage,hInstance,offset NUM9,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_num9
	mov hNum9, eax
	;---------------------------------------------------------------------------------
	invoke LoadBitmap, hInstance, IDB_num0_mask
	mov hNum0Mask, eax

	invoke LoadBitmap, hInstance, IDB_num1_mask
	mov hNum1Mask, eax

	invoke LoadBitmap, hInstance, IDB_num2_mask
	mov hNum2Mask, eax

	invoke LoadBitmap, hInstance, IDB_num3_mask
	mov hNum3Mask, eax

	invoke LoadBitmap, hInstance, IDB_num4_mask
	mov hNum4Mask, eax

	invoke LoadBitmap, hInstance, IDB_num5_mask
	mov hNum5Mask, eax

	invoke LoadBitmap, hInstance, IDB_num6_mask
	mov hNum6Mask, eax

	invoke LoadBitmap, hInstance, IDB_num7_mask
	mov hNum7Mask, eax

	invoke LoadBitmap, hInstance, IDB_num8_mask
	mov hNum8Mask, eax

	invoke LoadBitmap, hInstance, IDB_num9_mask
	mov hNum9Mask, eax
	;---------------------------------------------------------------------------------

	;敌人的图片
	;invoke LoadImage,hInstance,offset ENEMY0,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_enemy0
	mov hEnemy0,eax
	;invoke LoadImage,hInstance,offset ENEMYMask0,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_enemy0mask
	mov hEnemyMask0, eax
	;invoke LoadImage,hInstance,offset ENEMY1,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_enemy1
	mov hEnemy1,eax
	;invoke LoadImage,hInstance,offset ENEMYMask1,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_enemy1mask
	mov hEnemyMask1, eax

	;本机图片
	;invoke LoadImage,hInstance,offset PLAYER_NORMAL,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_R
	mov hPlayerNormal0,eax
	;invoke LoadImage, hInstance, offset PLAYER_NORMALmask, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_Rmask
	mov hPlayerNormalMask0, eax
	;invoke LoadImage,hInstance,offset PLAYER_RIGHT,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_R
	mov hPlayerRight0,eax
	;invoke LoadImage,hInstance,offset PLAYER_RIGHTmask,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_Rmask
	mov hPlayerRightMask0,eax
	;invoke LoadImage,hInstance,offset PLAYER_LEFT,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_L
	mov hPlayerLeft0,eax
	;invoke LoadImage,hInstance,offset PLAYER_LEFTmask,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_Lmask
	mov hPlayerLeftMask0,eax
	;invoke LoadImage,hInstance,offset PLAYER_UP,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_U
	mov hPlayerUp0,eax
	;invoke LoadImage,hInstance,offset PLAYER_UPmask,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_Umask
	mov hPlayerUpMask0,eax
	;invoke LoadImage,hInstance,offset PLAYER_DOWN,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_D
	mov hPlayerDown0,eax
	;invoke LoadImage,hInstance,offset PLAYER_DOWNmask,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_plane_Dmask
	mov hPlayerDownMask0,eax

	;僚机图片
	invoke LoadBitmap, hInstance, IDB_wingman
	mov hWingmans, eax
	
	;板子
	;invoke LoadImage,hInstance,offset BOARDPIC,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_board
	mov hBoard,eax
	;invoke LoadImage,hInstance,offset BOARDMASK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_boardmask
	mov hBoardmask,eax
	
	;自己的子弹
	;invoke LoadImage, hInstance, offset PBULLET0, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_pBullet0
	mov hPBullet0,eax
	;invoke LoadImage, hInstance, offset PBULLET0mask, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_pBullet0mask
	mov hPBullet0mask, eax
	;invoke LoadImage, hInstance, offset PBULLET1, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_pBullet1
	mov hPBullet1,eax
	;invoke LoadImage, hInstance, offset PBULLET1mask, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_pBullet1mask
	mov hPBullet1mask, eax
	
	;敌人的子弹
	;invoke LoadImage, hInstance, offset EBULLET0, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_eBullet0
	mov hEBullet0,eax
	;invoke LoadImage, hInstance, offset EBULLET1, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_eBullet1
	mov hEBullet1,eax
	;invoke LoadImage, hInstance, offset EBULLET0mask, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_eBullet0mask
	mov hEBullet0mask,eax
	;invoke LoadImage, hInstance, offset EBULLET1mask, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_eBullet1mask
	mov hEBullet1mask,eax

	;生命值
	;invoke LoadImage, hInstance, offset HEART, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_heart
	mov hHeart,eax
	;invoke LoadImage, hInstance, offset HEARTMASK, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_heartmask
	mov hHeartMask,eax

	;返回暂停按钮
	;invoke LoadImage,hInstance,offset RETURNBUTTON,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_button_return
	mov hReturnButton,eax
	;invoke LoadImage,hInstance,offset STOPBUTTON,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_button_stop
	mov hStopButton,eax
	ret
LoadBitImage endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateRandNum
;@Param			:  left.right表示要取的随机数的范围			
;@Description   :  生成一个范围之间的随机数，存储在eax当中
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
generateRandNum proc uses ebx ecx edx esi edi left:dword,right:dword
	invoke rand
	xor edx,edx
	mov ebx,right
	sub ebx,left
	div ebx
	add edx,left
	mov eax,edx
	ret
generateRandNum endp

;--------------------------------------------------------------------------------------
;@Function Name :  InitBackGround
;@Param			:  
;@Description   :  初始化游戏背景
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
InitBackGround proc uses eax ebx ecx edx esi edi
	
	;第一张图片的位置
	mov background.firx,0
	mov background.firy,0
	mov eax,stRect.right
	mov background.firw,eax
	mov eax,stRect.bottom
	mov background.firh,eax

	;第二张图片的位置
	mov eax,background.firw
	mov background.secx,eax
	mov background.secy,0

	mov eax,stRect.right
	mov background.secw,eax
	mov eax,stRect.bottom
	mov background.sech,eax
	ret
InitBackGround endp

;--------------------------------------------------------------------------------------
;@Function Name :  UpdateBackGround
;@Param			:  
;@Description   :  让背景图片向左移动
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
UpdateBackGround proc uses eax ebx ecx edx esi edi
	sub background.firx,10
	cmp background.firx,-780
	jg label_UpdateBackGround_1
	mov eax,stRect.right
	mov background.firx,eax
label_UpdateBackGround_1:
	sub background.secx,10
	cmp background.secx,-780
	jg label_UpdateBackGround_2
	mov eax,stRect.right
	mov background.secx,eax
label_UpdateBackGround_2:
	ret
UpdateBackGround endp

;--------------------------------------------------------------------------------------
;@Function Name :  store
;@Param			:  位图的指针，x坐标，y坐标，w宽度，h高度，flag显示方式有SRCCOPY等					
;@Description   :  将位图信息存储到iteams数组当中，之后让display函数进行展示
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
store proc uses eax ebx ecx edx esi edi hbitmap:dword,x:dword,y:dword,w:dword,h:dword,flag:dword
	mov eax,iteamCount
	mov edi ,offset iteams
	mov ebx,TYPE ITEAM
	mul ebx
	add edi,eax;此时edi当中存储的是对应iteams的地址
	mov eax,hbitmap
	mov (ITEAM PTR [edi]).hbp,eax
	mov eax,x
	mov (ITEAM PTR [edi]).x,eax
	mov eax,y
	mov (ITEAM PTR [edi]).y,eax
	mov eax,w
	mov (ITEAM PTR [edi]).w,eax
	mov eax,h
	mov (ITEAM PTR [edi]).h,eax
	mov eax,flag
	mov (ITEAM PTR [edi]).flag,eax
	add iteamCount,1
	ret
store endp

;--------------------------------------------------------------------------------------
;@Function Name :  display
;@Param			:  			
;@Description   :  将iteams数组中存储的位图全部展示到窗口上去，采用双缓冲区，展示完之后，将会清空iteams数组
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
display proc uses eax ebx ecx edx esi edi
	LOCAL paint:PAINTSTRUCT
	LOCAL hdc:dword ;屏幕的hdc
	LOCAL hdc1:dword;缓冲区1
	LOCAL hdc2:dword;缓冲区2
	LOCAL hbitmap:dword
	LOCAL @bminfo :BITMAP
	invoke BeginPaint, hWinMain, addr paint
	mov hdc,eax

	invoke CreateCompatibleDC,hdc
	mov hdc1,eax

	invoke CreateCompatibleDC,hdc1
	mov hdc2,eax
	;这部分相当于告诉电脑，缓冲区1的大小
	invoke CreateCompatibleBitmap,hdc,stRect.right,stRect.bottom
	mov hbitmap,eax
	
	invoke SelectObject,hdc1,hbitmap
	;设置成可变
	invoke SetStretchBltMode,hdc,HALFTONE
	invoke SetStretchBltMode,hdc1,HALFTONE

	mov esi,0
	mov edi,offset iteams
	.while esi<iteamCount
		invoke GetObject,(ITEAM PTR [edi]).hbp,type @bminfo,addr @bminfo
		invoke SelectObject,hdc2,(ITEAM PTR [edi]).hbp
		invoke StretchBlt,hdc1,(ITEAM PTR [edi]).x,(ITEAM PTR [edi]).y,(ITEAM PTR [edi]).w,(ITEAM PTR [edi]).h,hdc2,0,0,@bminfo.bmWidth,@bminfo.bmHeight,(ITEAM PTR [edi]).flag
		inc esi
		add edi,TYPE ITEAM
	.endw

	;将缓冲区1的内容复制到电脑上
	invoke StretchBlt,hdc,0,0,stRect.right,stRect.bottom,hdc1,0,0,stRect.right,stRect.bottom,SRCCOPY

	;删除指针
	invoke DeleteDC,hbitmap
	invoke DeleteDC,hdc2
	invoke DeleteDC,hdc1
	invoke DeleteDC,hdc
	invoke EndPaint,hWinMain,addr paint
	;清空iteams数组
	mov iteamCount,0
	ret
display endp

;--------------------------------------------------------------------------------------
;@Function Name :  shootPBullet
;@Param			:  	
;@Description   :  按下空格键时产生子弹	
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
shootPBullet proc uses eax ebx ecx edx esi edi
	mov eax, pBulletCount
	mov esi, offset pBullet
	xor edx, edx
	mov ebx, TYPE PBULLET
	mul ebx
	add esi, eax
	mov eax, player.center_y
	mov (PBULLET PTR[esi]).center_y, eax
	mov eax, player.x
	add eax, player.w
	mov (PBULLET PTR[esi]).center_x, eax
	mov (PBULLET PTR[esi]).radius, 10
	mov eax, (PBULLET PTR[esi]).center_x
	sub eax, 5
	mov (PBULLET PTR[esi]).x, eax
	mov eax, (PBULLET PTR[esi]).center_y
	sub eax, 5
	mov (PBULLET PTR[esi]).y, eax
	mov (PBULLET PTR[esi]).flag, 1
	mov eax, 0
	mov (PBULLET PTR[esi]).Speed, 20
	.if player.Big1 == 1
		mov (PBULLET PTR[esi]).BulletType, 1
	.else
		mov (PBULLET PTR[esi]).BulletType, 0
	.endif
	inc pBulletCount
	.if player.Big3 == 1
		xor ecx, ecx
		mov edi, offset wingmans
		mov eax, pBulletCount		
		mov esi, offset pBullet
		xor edx, edx
		mov ebx, TYPE PBULLET
		mul ebx
		add esi, eax
		.while ecx < 2
			mov eax, (PLAYER PTR[edi]).center_y
			mov (PBULLET PTR[esi]).center_y, eax
			mov eax, (PLAYER PTR[edi]).x
			add eax, (PLAYER PTR[edi]).w
			mov (PBULLET PTR[esi]).center_x, eax
			mov (PBULLET PTR[esi]).radius, 10
			mov eax, (PBULLET PTR[esi]).center_x
			sub eax, 5
			mov (PBULLET PTR[esi]).x, eax
			mov eax, (PBULLET PTR[esi]).center_y
			sub eax, 5
			mov (PBULLET PTR[esi]).y, eax
			mov (PBULLET PTR[esi]).flag, 1
			mov eax, 0
			mov (PBULLET PTR[esi]).Speed, 20
			inc pBulletCount
			inc ecx
			add esi, TYPE PBULLET
			add edi, TYPE PLAYER
		.endw
	.endif
	ret
shootPBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :  RecycleEnemy
;@Param			:  
;@Description   :  回收敌方飞机	
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
RecycleEnemy proc uses ecx ebx esi edi edx
	local usedCount:dword
	local tmpCount:dword
	mov usedCount, 0
	xor ecx, ecx
	mov esi, offset enemy
	.while ecx < enemyCount
		mov eax, (ENEMY PTR[esi]).LP
		.if eax == 0
			inc usedCount
		.endif
		add esi, TYPE ENEMY
		inc ecx
	.endw
	mov ebx, enemyCount
	sub ebx, usedCount
	mov tmpCount, ebx
	mov ecx, 0
	mov eax, enemyCount
	dec eax
	mov esi, offset enemy	; esi 头
	mov edi, offset enemy	; edi 尾
	xor edx, edx
	mov ebx, TYPE ENEMY
	mul ebx
	add edi, eax
	mov ebx, enemyCount
	dec ebx
	.while ecx < tmpCount
		mov edx, (ENEMY PTR[esi]).LP
		.if edx == 0
			.while ebx >= tmpCount
				mov edx, (ENEMY PTR[edi]).LP
				.if edx != 0
					mov eax, (ENEMY PTR[edi]).LP
					mov (ENEMY PTR[esi]).LP, eax
					mov eax, (ENEMY PTR[edi]).x
					mov (ENEMY PTR[esi]).x, eax
					mov eax, (ENEMY PTR[edi]).y
					mov (ENEMY PTR[esi]).y, eax
					mov eax, (ENEMY PTR[edi]).center_x
					mov (ENEMY PTR[esi]).center_x, eax
					mov eax, (ENEMY PTR[edi]).center_y
					mov (ENEMY PTR[esi]).center_y, eax
					mov eax, (ENEMY PTR[edi]).w
					mov (ENEMY PTR[esi]).w, eax
					mov eax, (ENEMY PTR[edi]).h
					mov (ENEMY PTR[esi]).h, eax
					mov eax, (ENEMY PTR[edi]).EType
					mov (ENEMY PTR[esi]).EType, eax
					mov eax, (ENEMY PTR[edi]).Speed
					mov (ENEMY PTR[esi]).Speed, eax
					mov eax, (ENEMY PTR[edi]).MoveTime
					mov (ENEMY PTR[esi]).MoveTime, eax
					mov eax, (ENEMY PTR[edi]).StayTime
					mov (ENEMY PTR[esi]).StayTime, eax
					mov eax, (ENEMY PTR[edi]).nextShoot
					mov (ENEMY PTR[esi]).nextShoot, eax
					mov eax, (ENEMY PTR[edi]).shootInterval
					mov (ENEMY PTR[esi]).shootInterval, eax
					mov eax, (ENEMY PTR[edi]).BulletType
					mov (ENEMY PTR[esi]).BulletType, eax
					sub edi, TYPE ENEMY
					dec ebx
					.break
				.endif
				sub edi, TYPE ENEMY
				dec ebx
			.endw
		.endif
		inc ecx
		add esi, TYPE ENEMY
	.endw
	mov ebx, usedCount
	sub enemyCount, ebx
	ret
RecycleEnemy endp

;--------------------------------------------------------------------------------------
;@Function Name :   RecycleEBullet
;@Param			:  
;@Description   :	回收敌方废弃子弹，调整数组， 在任何敌方子弹消失以后调用
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
RecycleEBullet proc uses ecx ebx esi edi edx
	local usedCount:dword
	local tmpCount:dword
	mov usedCount, 0
	xor ecx, ecx
	mov esi, offset eBullet
	.while ecx < eBulletCount
		mov eax, (EBULLET PTR[esi]).flag
		.if eax == 0
			inc usedCount
		.endif
		add esi, TYPE EBULLET
		inc ecx
	.endw
	mov ebx, eBulletCount
	sub ebx, usedCount
	mov tmpCount, ebx
	xor ecx, ecx
	mov eax, eBulletCount
	dec eax
	mov esi, offset eBullet
	mov edi, offset eBullet
	xor edx, edx
	mov ebx, TYPE EBULLET
	mul ebx
	add edi, eax
	mov ebx, eBulletCount
	dec ebx
	.while ecx < tmpCount
		mov edx, (EBULLET PTR[esi]).flag
		.if edx == 0
			.while ebx >= tmpCount
				mov edx, (EBULLET PTR[edi]).flag
				.if edx != 0
					mov eax, (EBULLET PTR[edi]).flag
					mov (EBULLET PTR[esi]).flag, eax
					mov eax, (EBULLET PTR[edi]).x
					mov (EBULLET PTR[esi]).x, eax
					mov eax, (EBULLET PTR[edi]).y
					mov (EBULLET PTR[esi]).y, eax
					mov eax, (EBULLET PTR[edi]).center_x
					mov (EBULLET PTR[esi]).center_x, eax
					mov eax, (EBULLET PTR[edi]).center_y
					mov (EBULLET PTR[esi]).center_y, eax
					mov eax, (EBULLET PTR[edi]).radius
					mov (EBULLET PTR[esi]).radius, eax
					mov eax, (EBULLET PTR[edi]).EBType
					mov (EBULLET PTR[esi]).EBType, eax
					mov eax, (EBULLET PTR[edi]).disp_x
					mov (EBULLET PTR[esi]).disp_x, eax
					mov eax, (EBULLET PTR[edi]).disp_y
					mov (EBULLET PTR[esi]).disp_y, eax
					mov eax, (EBULLET PTR[edi]).damage
					mov (EBULLET PTR[esi]).damage, eax
					sub edi, TYPE EBULLET
					dec ebx
					.break
				.endif
				sub edi, TYPE EBULLET
				dec ebx
			.endw
		.endif
		inc ecx
		add esi, TYPE EBULLET
	.endw
	mov eax, tmpCount
	mov eBulletCount, eax
	ret
RecycleEBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :   RecyclePBullet
;@Param			:  
;@Description   :	回收玩家废弃子弹，调整数组， 在任何子弹消失以后调用
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
RecyclePBullet proc uses ecx ebx esi edi edx
	local usedCount:dword
	local tmpCount:dword
	mov usedCount, 0
	mov ecx, 0
	mov esi, offset pBullet
	.while ecx < pBulletCount
		mov eax, (PBULLET PTR[esi]).flag
		.if eax == 0
			inc usedCount
		.endif
		add esi, TYPE PBULLET
		inc ecx
	.endw
	mov ebx, pBulletCount
	sub ebx, usedCount
	mov tmpCount, ebx
	mov ecx, 0
	mov eax, pBulletCount
	dec eax
	mov esi, offset pBullet
	mov edi, offset pBullet
	xor edx, edx
	mov ebx, TYPE PBULLET
	mul ebx
	add edi, eax
	mov ebx, pBulletCount
	dec ebx
	.while ecx < tmpCount
		mov edx, (PBULLET PTR[esi]).flag
		.if edx == 0
			.while ebx >= tmpCount
				mov edx, (PBULLET PTR[edi]).flag
				.if edx != 0
					mov eax, (PBULLET PTR[edi]).flag
					mov (PBULLET PTR[esi]).flag, eax
					mov eax, (PBULLET PTR[edi]).x
					mov (PBULLET PTR[esi]).x, eax
					mov eax, (PBULLET PTR[edi]).y
					mov (PBULLET PTR[esi]).y, eax
					mov eax, (PBULLET PTR[edi]).center_x
					mov (PBULLET PTR[esi]).center_x, eax
					mov eax, (PBULLET PTR[edi]).center_y
					mov (PBULLET PTR[esi]).center_y, eax
					mov eax, (PBULLET PTR[edi]).radius
					mov (PBULLET PTR[esi]).radius, eax
					mov eax, (PBULLET PTR[edi]).Speed
					mov (PBULLET PTR[esi]).Speed, eax
					sub edi, TYPE PBULLET
					dec ebx
					.break
				.endif
				sub edi, TYPE PBULLET
				dec ebx
			.endw
		.endif
		inc ecx
		add esi, TYPE PBULLET
	.endw
	mov eax, tmpCount
	mov pBulletCount, eax
	ret
RecyclePBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :  UpdatePBullet
;@Param			:  	
;@Description   :  更新自己的子弹，右移
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
UpdatePBullet proc uses eax ebx ecx edx esi edi
	mov esi, offset pBullet
	xor ecx, ecx
	.while ecx < pBulletCount
		mov eax, (PBULLET PTR[esi]).center_x
		.if eax > 800
			mov (PBULLET PTR[esi]).flag, 0
		.endif
		mov eax, (PBULLET PTR[esi]).flag
		.if eax > 0
			mov eax, (PBULLET PTR[esi]).Speed
			add (PBULLET PTR[esi]).x, eax
			add (PBULLET PTR[esi]).center_x, eax
		.endif
		inc ecx
		add esi, TYPE PBULLET
	.endw
	ret
UpdatePBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :  UpdateEBullet
;@Param			:  	
;@Description   :  更新敌方子弹
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
UpdateEBullet proc uses eax ebx ecx edx esi edi
	mov esi, offset eBullet
	xor ecx, ecx
	.while ecx < eBulletCount
		mov eax, (EBULLET PTR[esi]).center_x
		.if eax < 0 || eax > 800
			mov (EBULLET PTR[esi]).flag, 0
		.endif
		mov eax, (EBULLET PTR[esi]).center_y
		.if eax < 0 || eax > 600
			mov (EBULLET PTR[esi]).flag, 0
		.endif
		mov eax, (EBULLET PTR[esi]).flag
		.if eax != 0
			mov eax, (EBULLET PTR[esi]).disp_x
			add (EBULLET PTR[esi]).x, eax
			add (EBULLET PTR[esi]).center_x, eax
			mov ebx, (EBULLET PTR[esi]).EBType
			mov eax, (EBULLET PTR[esi]).disp_y
			add (EBULLET PTR[esi]).y, eax
			add (EBULLET PTR[esi]).center_y, eax
			.if ebx == 1	; 如果是1式子弹（重弹），且游戏得分>=5，提升弹速
				.if MyScore_one == 5
					mov eax, (EBULLET PTR[esi]).disp_x
					add (EBULLET PTR[esi]).x, eax
					add (EBULLET PTR[esi]).center_x, eax
					mov eax, (EBULLET PTR[esi]).disp_y
					add (EBULLET PTR[esi]).y, eax
					add (EBULLET PTR[esi]).center_y, eax
				.endif
			.endif
		.endif
		inc ecx
		add esi, TYPE EBULLET
	.endw
	ret
UpdateEBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :  UpdateEnemy;
;@Param			:  	
;@Description   :  更新敌方
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
UpdateEnemy proc uses eax ebx ecx edx esi edi
	mov esi, offset enemy
	xor ecx, ecx
	.while ecx < enemyCount
	;-------------------------------------------对于boss进行单独处理
		mov eax, (ENEMY PTR[esi]).EType
		cmp eax,2
		je boss
		;------------------------------------
		mov eax, (ENEMY PTR[esi]).MoveTime
		.if eax > 0;刚进入屏幕，要飞行一段时间
			mov eax, (ENEMY PTR[esi]).Speed
			sub (ENEMY PTR[esi]).x, eax
			sub (ENEMY PTR[esi]).center_x, eax
			dec (ENEMY PTR[esi]).MoveTime
			mov eax, (ENEMY PTR[esi]).center_x
			cmp eax, -50
			jnge if_outScreen
			jmp OutIf
		if_outScreen:
			mov (ENEMY PTR[esi]).LP, 0
		.else;飞行时间结束，静止一段时间并发射子弹
			mov eax, (ENEMY PTR[esi]).StayTime
			.if eax > 0
				dec (ENEMY PTR[esi]).StayTime
			.else;静止时间结束，一直向前飞行直到飞出屏幕
				mov eax, (ENEMY PTR[esi]).LP
				.if eax > 0
					mov eax, (ENEMY PTR[esi]).Speed
					sub (ENEMY PTR[esi]).x, eax
					sub (ENEMY PTR[esi]).center_x, eax
				.endif
			.endif
		.endif
		jmp OutIf
	;---------------------------------------------------------------
	boss:		;boss只有第一段的移动，静止后不再移动，一直进行射击，直到被击毁
		mov eax, (ENEMY PTR[esi]).MoveTime
		.if eax > 0
			mov eax, (ENEMY PTR[esi]).Speed
			sub (ENEMY PTR[esi]).x, eax
			sub (ENEMY PTR[esi]).center_x, eax
			dec (ENEMY PTR[esi]).MoveTime
			mov eax, (ENEMY PTR[esi]).center_x
		.endif
		mov ebx, (ENEMY PTR[esi]).LP
		.if ebx == 0
			mov PaintFlag, 6			;boss死亡后调出胜利界面
		.endif
	;------------------------------------------------------------------

	OutIf:
		inc ecx
		add esi, TYPE ENEMY
	.endw
	ret
UpdateEnemy endp
;--------------------------------------------------------------------------------------
;@Function Name :   InitWingmans
;@Param			:  
;@Description   :	在大招3释放时，启用僚机
;@Author        :   方辰
;--------------------------------------------------------------------------------------
InitWingmans proc uses eax ebx ecx edx esi edi flag_Type:dword, bulletType:dword
	mov esi, offset wingmans
	xor ecx, ecx
	.while ecx < 2
		mov eax, flag_Type
		.if ecx == 0
			mov edx, player.y
			sub edx, 80
			mov (PLAYER PTR[esi]).y, edx
		.else
			mov edx, player.y
			add edx, 80
			mov (PLAYER PTR[esi]).y, edx
		.endif
		mov edx, player.x
		sub edx, 25
		mov (PLAYER PTR[esi]).x,edx
		mov (PLAYER PTR[esi]).w,50
		mov (PLAYER PTR[esi]).h,50
		mov eax, (PLAYER PTR[esi]).w
		shr eax, 1
		add eax, (PLAYER PTR[esi]).x
		mov (PLAYER PTR[esi]).center_x, eax
		mov eax, (PLAYER PTR[esi]).h
		shr eax, 1
		add eax, (PLAYER PTR[esi]).y
		mov (PLAYER PTR[esi]).center_y, eax
		mov (PLAYER PTR[esi]).IMAGE_FLAG,0
		mov (PLAYER PTR[esi]).UpCount,0
		mov (PLAYER PTR[esi]).DownCount,0
		mov (PLAYER PTR[esi]).RightCount,0
		mov (PLAYER PTR[esi]).LeftCount,0
		mov (PLAYER PTR[esi]).Speed, 25
		mov (PLAYER PTR[esi]).HP, 3
		mov (PLAYER PTR[esi]).EnergyLevel, 0
		mov (PLAYER PTR[esi]).Big1, 0
		mov (PLAYER PTR[esi]).Big2, 0
		mov (PLAYER PTR[esi]).Big3, 0
		inc ecx
		add esi, TYPE PLAYER
	.endw
	ret
InitWingmans endp
;--------------------------------------------------------------------------------------
;@Function Name :  PlayerMove
;@Param			:  wParam用来判断是哪个按键被按下	
;@Description   :  执行飞机的移动  
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
PlayerMove proc uses eax ebx ecx edx esi edi wParam:WPARAM
	.if wParam==VK_LEFT
		mov eax, player.x
		cmp eax, 0
		jle	label1_playermove
			sub eax, player.Speed
			mov player.x, eax
			mov eax, player.center_x
			sub eax, player.Speed
			mov player.center_x, eax
		.if player.Big3 == 1
				xor ecx, ecx
				mov esi, offset wingmans
				.while ecx < 2
					mov eax, (PLAYER PTR[esi]).x
					mov edx, eax
					sub eax, player.Speed
					.if eax < edx
						mov (PLAYER PTR[esi]).x, eax
						mov eax, (PLAYER PTR[esi]).center_x
						sub eax, player.Speed
						mov (PLAYER PTR[esi]).center_x, eax
					.endif
					inc ecx
					add esi, TYPE PLAYER
				.endw
			.endif
label1_playermove:		
		add player.LeftCount,1
		mov player.RightCount,0
		mov player.UpCount,0
		mov player.DownCount,0
	.elseif wParam==VK_RIGHT 
		mov eax, player.x
		cmp eax, 730
		jge	label2_playermove
			add eax, player.Speed
			mov player.x, eax
			mov eax, player.center_x
			add eax, player.Speed
			mov player.center_x, eax
		.if player.Big3 == 1
				xor ecx, ecx
				mov esi, offset wingmans
				.while ecx < 2
					mov eax, (PLAYER PTR[esi]).x
					add eax, player.Speed
					.if eax <= 730
						mov (PLAYER PTR[esi]).x, eax
						mov eax, (PLAYER PTR[esi]).center_x
						add eax, player.Speed
						mov (PLAYER PTR[esi]).center_x, eax
					.endif
					inc ecx
					add esi, TYPE PLAYER
				.endw
			.endif
label2_playermove:	
		mov player.LeftCount,0
		add player.RightCount,1
		mov player.UpCount,0
		mov player.DownCount,0
	.elseif wParam==VK_DOWN
		mov eax, player.y
		cmp eax, 500
		jge	label3_playermove
			add eax, player.Speed
			mov player.y, eax
			mov eax, player.center_y
			add eax, player.Speed
			mov player.center_y, eax
			.if player.Big3 == 1
				xor ecx, ecx
				mov esi, offset wingmans
				.while ecx < 2
					mov eax, (PLAYER PTR[esi]).y
					add eax, player.Speed
					.if eax <= 600
						mov (PLAYER PTR[esi]).y, eax
						mov eax, (PLAYER PTR[esi]).center_y
						add eax, player.Speed
						mov (PLAYER PTR[esi]).center_y, eax
					.endif
					inc ecx
					add esi, TYPE PLAYER
				.endw
			.endif
label3_playermove:
		mov player.LeftCount,0
		mov player.RightCount,0
		mov player.UpCount,0
		add player.DownCount,1
	.elseif wParam==VK_UP
		mov eax, player.y
		.if player.Big3 == 1
			cmp eax, 100
		.else
			cmp eax, 0
		.endif
		jle	label4_playermove
			sub eax, player.Speed
			mov player.y, eax
			.if player.Big3 == 1
				xor ecx, ecx
				mov esi, offset wingmans
				.while ecx < 2
					mov eax, (PLAYER PTR[esi]).y
					mov edx, eax
					sub eax, player.Speed
					.if eax < edx
						mov (PLAYER PTR[esi]).y, eax
						mov eax, (PLAYER PTR[esi]).center_y
						sub eax, player.Speed
						mov (PLAYER PTR[esi]).center_y, eax
					.endif
					inc ecx
					add esi, TYPE PLAYER
				.endw
			.endif
			mov eax, player.center_y
			sub eax, player.Speed
			mov player.center_y, eax
label4_playermove:
		mov player.LeftCount,0
		mov player.RightCount,0
		add player.UpCount,1
		mov player.DownCount,0
	.elseif wParam==VK_SPACE	;空格键 发射子弹
		mov player.LeftCount,0
		mov player.RightCount,0
		mov player.UpCount,0
		mov player.DownCount,0
		invoke shootPBullet
	.elseif wParam == VK_1		; 数字1键 使用“金刚弹”大招
		.if player.EnergyLevel == MAX_ENERGY
			mov player.Big1, 1
			mov player.EnergyLevel, 0
			INVOKE GetTickCount
			mov Big1StartTime, eax
		.endif
	.elseif wParam == VK_2		; 数字2键 使用“自检修复”大招
		.if player.Big2 == 1
			mov player.Big2, 0
			add player.HP, 1
			.if player.HP > 3
				mov player.HP, 3
			.endif
		.endif
	.elseif wParam == VK_3
		.if player.EnergyLevel == MAX_ENERGY
			mov player.Big3, 1
			mov player.EnergyLevel, 0
			INVOKE InitWingmans, 0, 0
			INVOKE GetTickCount
			mov Big3StartTime, eax
		.endif
	.endif
	.if player.RightCount>0
		mov player.IMAGE_FLAG,1
	.elseif player.LeftCount>0
		mov player.IMAGE_FLAG,2
	.elseif player.UpCount>0
		mov player.IMAGE_FLAG,3
	.elseif player.DownCount>0
		mov player.IMAGE_FLAG,4
	.else 
		mov player.IMAGE_FLAG,0
	.endif
	shr eax, 1
	mov ebx, player.center_x
	sub ebx, eax

	shr eax, 1
	mov ebx, player.center_y
	sub ebx, eax
	ret
PlayerMove endp

;--------------------------------------------------------------------------------------
;@Function Name :   InitPlayer
;@Param			:  
;@Description   :	在游戏开始的时候，初始化人物的信息
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
InitPlayer proc uses eax ebx ecx edx esi edi flag_Type:dword, bulletType:dword
	mov eax, flag_Type
	mov player.x,0
	mov player.y,250
	mov player.w,50
	mov player.h,50
	mov eax, player.w
	shr eax, 1
	add eax, player.x
	mov player.center_x, eax
	mov eax, player.h
	shr eax, 1
	add eax, player.y
	mov player.center_y, eax
	mov player.IMAGE_FLAG,0
	mov player.UpCount,0
	mov player.DownCount,0
	mov player.RightCount,0
	mov player.LeftCount,0
	mov player.Speed, 25
	mov player.HP, 3
	mov player.EnergyLevel, 0
	mov player.Big1, 0
	mov player.Big2, 0
	mov player.Big3, 0
	ret
InitPlayer endp

;--------------------------------------------------------------------------------------
;@Function Name :  InitBoard
;@Param			:  
;@Description   :  在游戏开始的时候，初始化板子的信息
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
InitBoard proc uses eax ebx ecx edx esi edi
	LOCAL pos_x:dword ;上个板子x的位置
	LOCAL left:dword
	LOCAL right:dword
	mov pos_x,300 
	mov boardCount,0
	;设置一下敌人的生成速度
	
	mov EnemyInterval, 150	; 初始的敌人刷新频率设置成150
	mov eax, EnemyInterval
	mov timer, eax			; 初始化敌机生成计时器Timer

	mov left, 500
	mov right, 800
	invoke generateRandNum, left, right
	mov LifeBagInterval, eax	; 初始化血包刷新时间
	mov LifeBagTimer, 0
	; 初始化血包结构体信息
	mov edi, offset LifeBag
	mov (LBAG PTR [edi]).x, 0
	mov (LBAG PTR [edi]).y, 0
	mov (LBAG PTR [edi]).w, 0
	mov (LBAG PTR [edi]).h, 0
	mov (LBAG PTR [edi]).flag, 0
	mov (LBAG PTR [edi]).center_x, 0
	mov (LBAG PTR [edi]).center_y, 0


	mov MyScore_ten, 0	; 初始化玩家得分
	mov MyScore_one, 0
	
	; 设置一些其他全部变量的值
	mov UpgradeDifficult, 0	; 难度升级flag = false

	mov left,300
	mov right,400

	mov esi,0
	mov edi,offset boards
	.while esi < 20
		invoke generateRandNum,left,right
		add eax,pos_x
		mov pos_x,eax
		mov (BOARD PTR [edi]).x,eax
		mov (BOARD PTR [edi]).center_x,eax
		add (BOARD PTR [edi]).center_x,25
		invoke generateRandNum,0,300
		mov (BOARD PTR [edi]).y,eax
		mov (BOARD PTR [edi]).center_y,eax
		add (BOARD PTR [edi]).center_y,100
		mov (BOARD PTR [edi]).w,50
		mov (BOARD PTR [edi]).h,200
		mov (BOARD PTR [edi]).flag,1
		add boardCount,1
		inc esi
		add edi,TYPE BOARD
	.endw
	ret
InitBoard endp

;--------------------------------------------------------------------------------------
;@Function Name :   UpdateBoard
;@Param			:  
;@Description   :	当计时器发出信号后，更新板子的位置，让板子固定向前移动
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
UpdateBoard proc uses eax ebx ecx edx esi edi
	mov esi,0
	mov edi,offset boards
	.while esi<boardCount
		sub (BOARD PTR [edi]).x,2
		sub (BOARD PTR [edi]).center_x,2
		inc esi
		add edi,TYPE BOARD
	.endw
	ret
UpdateBoard endp

UpdateLifeBag proc uses eax ebx ecx edx esi edi
	mov edi, offset LifeBag
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 0	; 当前窗口内没有血包
		ret
	.endif

	;更新位置
	sub (LBAG PTR [edi]).x, 2
	sub (LBAG PTR [edi]).center_x, 2

	ret
UpdateLifeBag endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateEnemy;
;@Param			:  	
;@Description   :  产生敌人	
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
generateEnemy proc uses eax ebx ecx edx esi edi
	mov eax, enemyCount
	mov esi, offset enemy
	xor edx, edx
	mov ebx, TYPE ENEMY
	mul ebx
	add esi, eax
	;现在 esi 指向了最新的敌人
	;-----------------------------------------
	;检查是否还要生成新的敌机
	cmp generate_flag, 1;
	jne endL
	;cmp MyScore_ten,1			;调试时先以1分为标准
	cmp MyScore_ten, boss_thre
	je boss
	;-----------------------------------------分数达到一定要求就生成boss
	mov (ENEMY PTR[esi]).x, 850
	invoke generateRandNum, 20, 500
	mov (ENEMY PTR[esi]).y, eax
	;随机生成位置
	invoke generateRandNum, 0, 2
	.if eax == 0 ;0式，血量较高，四面八方发射子弹
		mov (ENEMY PTR[esi]).EType, 0
		mov (ENEMY PTR[esi]).w, 80
		mov (ENEMY PTR[esi]).h, 80
		mov eax, (ENEMY PTR[esi]).x
		add eax, 40
		mov (ENEMY PTR[esi]).center_x, eax
		mov eax, (ENEMY PTR[esi]).y
		add eax, 40
		mov (ENEMY PTR[esi]).center_y, eax
		mov (ENEMY PTR[esi]).LP, 4
		mov (ENEMY PTR[esi]).Speed, 10
		mov (ENEMY PTR[esi]).MoveTime, 25
		mov (ENEMY PTR[esi]).StayTime, 100
		mov (ENEMY PTR[esi]).shootInterval, 30
		mov (ENEMY PTR[esi]).nextShoot, 15
		mov (ENEMY PTR[esi]).BulletType, 0
	.elseif eax == 1 ;1式，血量较低，追踪玩家发射子弹
		mov (ENEMY PTR[esi]).EType, 1
		mov (ENEMY PTR[esi]).w, 60
		mov (ENEMY PTR[esi]).h, 60
		mov eax, (ENEMY PTR[esi]).x
		add eax, 30
		mov (ENEMY PTR[esi]).center_x, eax
		mov eax, (ENEMY PTR[esi]).y
		add eax, 30
		mov (ENEMY PTR[esi]).center_y, eax
		mov (ENEMY PTR[esi]).LP, 3
		mov (ENEMY PTR[esi]).Speed, 30
		mov (ENEMY PTR[esi]).MoveTime, 12
		mov (ENEMY PTR[esi]).StayTime, 100
		mov (ENEMY PTR[esi]).shootInterval, 20
		mov (ENEMY PTR[esi]).nextShoot, 10
		mov (ENEMY PTR[esi]).BulletType, 1
	.endif
	inc enemyCount
	jmp endL
;------------------------------------------------------------------
boss:
	mov boardCount, 0
	mov (ENEMY PTR[esi]).x, 1200
	mov (ENEMY PTR[esi]).y, 80
	mov (ENEMY PTR[esi]).EType, 2
	mov (ENEMY PTR[esi]).w, 374
	mov (ENEMY PTR[esi]).h, 374

	mov eax, (ENEMY PTR[esi]).x
	add eax, 187
	mov (ENEMY PTR[esi]).center_x, eax

	mov eax, (ENEMY PTR[esi]).y
	add eax, 187
	mov (ENEMY PTR[esi]).center_y, eax

	mov (ENEMY PTR[esi]).LP, 400
	mov (ENEMY PTR[esi]).Speed, 5
	mov (ENEMY PTR[esi]).MoveTime, 150
	mov (ENEMY PTR[esi]).StayTime, 100
	mov (ENEMY PTR[esi]).shootInterval, 15	;boss用这个字段存储在一次发射中连续发射的次数
	mov (ENEMY PTR[esi]).nextShoot, 20		;第一次射击的时间
	mov (ENEMY PTR[esi]).BulletType, 0		;不确定
	mov generate_flag, 0
	inc enemyCount
endL:
;---------------------------------------------------------------------
	ret
generateEnemy endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateLifeBag
;@Param			:  	
;@Description   :  产生血包	
;@Author        :  
;--------------------------------------------------------------------------------------
generateLifeBag proc uses eax ebx ecx edx esi edi
	LOCAL left: dword
	LOCAL right: dword
	mov edi, offset LifeBag		; 如果现在已经存在血包，则不再放新的（窗口中至多1个）
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 1
		ret
	.endif

	; 产生新血包
	mov left, 0
	mov right, 500
	invoke generateRandNum, left, right
	mov (LBAG PTR [edi]).x, 750
	mov (LBAG PTR [edi]).y, eax
	mov (LBAG PTR [edi]).w, 50
	mov (LBAG PTR [edi]).h, 50
	mov (LBAG PTR [edi]).flag, 1
	mov ebx, 750
	add ebx, 25
	mov (LBAG PTR [edi]).center_x, ebx
	mov ebx, eax
	add ebx, 25
	mov (LBAG PTR [edi]).center_y, ebx
	ret
generateLifeBag endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateOneEBullet
;@Param			:  EBULLET结构体的所有属性
;@Description   :  产生一个敌方子弹	
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
generateOneEBullet proc uses eax ebx ecx edx esi edi center_x:dword, center_y:dword, radius:dword, disp_x:dword, disp_y:dword, damage:dword, BulletType:dword
	mov eax, eBulletCount
	mov esi, offset eBullet
	xor edx, edx
	mov ebx, TYPE EBULLET
	mul ebx
	add esi, eax
	mov eax, center_x
	mov (EBULLET PTR[esi]).center_x, eax
	sub eax, radius
	mov (EBULLET PTR[esi]).x, eax
	mov eax, center_y
	mov (EBULLET PTR[esi]).center_y, eax
	sub eax, radius
	mov (EBULLET PTR[esi]).y, eax
	mov eax, radius
	mov (EBULLET PTR[esi]).radius, eax
	mov eax, disp_x
	mov (EBULLET PTR[esi]).disp_x, eax
	mov eax, disp_y
	mov (EBULLET PTR[esi]).disp_y, eax
	mov eax, damage
	mov (EBULLET PTR[esi]).damage, eax
	mov eax, BulletType
	mov (EBULLET PTR[esi]).EBType, eax
	mov (EBULLET PTR[esi]).flag, 1
	inc eBulletCount
	ret
generateOneEBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateEBullet;
;@Param			:  EBULLET结构体的所有属性
;@Description   :  产生敌方子弹（一共两种）
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
generateEBullet proc uses eax ebx ecx edx esi edi
	LOCAL locate_x:dword
	LOCAL locate_y:dword
	LOCAL BulletType:dword
	LOCAL dire_x:dword
	LOCAL dire_y:dword
	LOCAL _steps:dword
	;---------------------------
	;LOCAL boss_cycle:dword
	;mov boss_cycle, 15
	;---------------------------
	mov _steps, 35
	xor esi, esi
	mov edi, offset enemy
	.while esi < enemyCount
		mov eax, (ENEMY PTR[edi]).MoveTime
		.if eax == 0
			mov eax, (ENEMY PTR[edi]).LP
			.if eax > 0
				mov eax, (ENEMY PTR[edi]).nextShoot
				.if eax == 0
					mov eax, (ENEMY PTR[edi]).x
					mov locate_x, eax
					mov eax, (ENEMY PTR[edi]).center_y
					mov locate_y, eax
					mov eax, (ENEMY PTR[edi]).BulletType
					mov BulletType, eax
					mov eax, (ENEMY PTR[edi]).EType
					.if eax == 0
						invoke generateOneEBullet, locate_x, locate_y, 15, -10, 0, 1, BulletType ;乱发
						invoke generateOneEBullet, locate_x, locate_y, 15, 10, 0, 1, BulletType
						invoke generateOneEBullet, locate_x, locate_y, 15, -7, 7, 1, BulletType
						invoke generateOneEBullet, locate_x, locate_y, 15, -7, -7, 1, BulletType
						invoke generateOneEBullet, locate_x, locate_y, 15, 7, -7, 1, BulletType
						invoke generateOneEBullet, locate_x, locate_y, 15, 7, 7, 1, BulletType
						invoke generateOneEBullet, locate_x, locate_y, 15, 0, 10, 1, BulletType
						invoke generateOneEBullet, locate_x, locate_y, 15, 0, -10, 1, BulletType
					.elseif eax == 1
						mov eax, player.center_x
						sub eax, locate_x
						xor edx, edx
						cdq
						idiv _steps
						mov dire_x, eax
						mov eax, player.center_y
						sub eax, locate_y
						xor edx, edx
						cdq
						idiv _steps
						mov dire_y, eax
						invoke generateOneEBullet, locate_x, locate_y, 20, dire_x, dire_y, 2, BulletType ;瞄准
					;------------------------------------------------------------------------------------
					.elseif eax == 2;	boss
						mov ebx, locate_x
						add ebx, 120
						mov locate_x, ebx
						mov ebx, locate_y
						add ebx, 10
						mov locate_y, ebx
						.if BulletType == 0	;BOSS发射的散弹共20枚
							invoke generateOneEBullet, locate_x, locate_y, 15, -10, 0, 1, BulletType ;乱发
							invoke generateOneEBullet, locate_x, locate_y, 15, -9, 3, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -8, 5, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -5, 8, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -3, 9, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 0, 10, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -9, -3, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -8, -5, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -5, -8, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -3, -9, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 0, -10, 1, BulletType

							invoke generateOneEBullet, locate_x, locate_y, 15, 10, 0, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 9, 3, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 8, 5, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 5, 8, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 3, 9, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 9, -3, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 8, -5, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 5, -8, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 3, -9, 1, BulletType

						.elseif BulletType == 1
							mov eax, player.center_x
							sub eax, locate_x
							xor edx, edx
							cdq
							idiv _steps
							mov dire_x, eax
							mov eax, player.center_y
							sub eax, locate_y
							xor edx, edx
							cdq
							idiv _steps
							mov dire_y, eax
							invoke generateOneEBullet, locate_x, locate_y, 20, dire_x, dire_y, 2, BulletType ;瞄准
						;---------------------------------------------------------------	
						.elseif BulletType == 2		;BOSS将散弹和导弹以混合的方式进行发射
							invoke generateOneEBullet, locate_x, locate_y, 15, -10, 0, 1, 0 ;乱发
							invoke generateOneEBullet, locate_x, locate_y, 15, -9, 3, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, -8, 5, 1, 0
							;invoke generateOneEBullet, locate_x, locate_y, 15, -7, 7, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -5, 8, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, -3, 9, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 0, 10, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, -9, -3, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, -8, -5, 1, 0
							;invoke generateOneEBullet, locate_x, locate_y, 15, -7, -7, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, -5, -8, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, -3, -9, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 0, -10, 1, 0

							invoke generateOneEBullet, locate_x, locate_y, 15, 10, 0, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 9, 3, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 8, 5, 1, 0
							;invoke generateOneEBullet, locate_x, locate_y, 15, 7, 7, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 5, 8, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 3, 9, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 9, -3, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 8, -5, 1, 0
							;invoke generateOneEBullet, locate_x, locate_y, 15, 7, -7, 1, BulletType
							invoke generateOneEBullet, locate_x, locate_y, 15, 5, -8, 1, 0
							invoke generateOneEBullet, locate_x, locate_y, 15, 3, -9, 1, 0

							mov eax, player.center_x
							sub eax, locate_x
							xor edx, edx
							cdq
							idiv _steps
							mov dire_x, eax
							mov eax, player.center_y
							sub eax, locate_y
							xor edx, edx
							cdq
							idiv _steps
							mov dire_y, eax
							invoke generateOneEBullet, locate_x, locate_y, 20, dire_x, dire_y, 2, 1 ;瞄准
							;----------------------------------------------------------------
						.endif

						mov eax, (ENEMY PTR[edi]).shootInterval
						.if eax == 0
							invoke generateRandNum, 20, 30	;随机确定空闲多长时间进行下一轮攻击
							mov (ENEMY PTR[edi]).nextShoot, eax
							mov (ENEMY PTR[edi]).shootInterval, 10
							;在完整发射完一轮之后随机确定下一轮的子弹类型
							invoke generateRandNum, 0, 3
							mov (ENEMY PTR[edi]).BulletType, eax
						.else
							.if BulletType == 2		;不同攻击模式的射速不同，用来平衡游戏难度
								mov (ENEMY PTR[edi]).nextShoot, 8
							.else
								mov (ENEMY PTR[edi]).nextShoot, 5
							.endif
							dec (ENEMY PTR[edi]).shootInterval
						.endif
						jmp L1
					;------------------------------------------------------------------------------------
					.endif
					mov eax, (ENEMY PTR[edi]).shootInterval
					mov (ENEMY PTR[edi]).nextShoot, eax
					L1:
				.else
					dec eax
					mov (ENEMY PTR[edi]).nextShoot, eax
				.endif
			.endif
		.endif
		add edi, TYPE ENEMY
		inc esi
	.endw
	ret
generateEBullet endp

;--------------------------------------------------------------------------------------
;@Function Name :  CheckHitBoard
;@Param			:  
;@Description   :	检测我方子弹是否命中，消除子弹
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
CheckHitBoard proc uses esi edi ecx ebx edx eax
	xor ecx, ecx
	mov edi, offset pBullet
	.while ecx < pBulletCount
		mov eax, (PBULLET PTR[edi]).flag
		.if eax != 0
			xor ebx, ebx
			mov esi, offset boards
			.while ebx < boardCount 
				;判断一下板子是否还有效
				mov eax,(BOARD PTR[esi]).flag
				.if eax==1
					mov eax, (PBULLET PTR[edi]).center_x
					mov edx, (BOARD PTR[esi]).x
					.if eax > edx
						add edx, (BOARD PTR[esi]).w
						.if eax < edx
							mov eax, (PBULLET PTR[edi]).center_y
							mov edx, (BOARD PTR[esi]).y
							.if eax > edx
								add edx, (BOARD PTR[esi]).h
								.if eax < edx
									mov eax, (PBULLET PTR[edi]).BulletType
									.if eax == 1		; 如果是金刚弹，板子被"金刚弹"击中消失
										mov (BOARD PTR[esi]).flag, 0	
									.endif
									mov (PBULLET PTR[edi]).radius, 0
									mov (PBULLET PTR[edi]).flag, 0
								.endif
							.endif
						.endif
					.endif
				.endif
				inc ebx
				add esi, TYPE BOARD
			.endw
		.endif
		inc ecx
		add edi, TYPE PBULLET
	.endw
	ret
CheckHitBoard endp

;--------------------------------------------------------------------------------------
;@Function Name :   CheckCollision
;@Param			:  
;@Description   :	进行碰撞检测，检测是否撞到了板子，若撞上则直接死亡
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
CheckCollision proc uses eax ebx ecx edx esi edi
	;应该计算出物体的中心坐标再去检测,

	mov eax,player.w ;eax当中存储的是物体的中心x坐标
	shr eax,1;
	add eax,player.x
	mov player.center_x,eax

	mov ebx,player.h ;ebx当中存储的是物体的中心y坐标
	shr ebx,1;
	add ebx,player.y
	mov player.center_y,ebx

	;检测是否碰撞到了板子
	mov esi,0
	mov edi,offset boards
	.while esi<boardCount
		mov eax,(BOARD PTR [edi]).flag
		.if eax==1
			mov eax,player.w ;eax,存储的相当于max_x
			add eax,(BOARD PTR [edi]).w 
			shr eax,1
			sub eax,10 ;这个减去5相当于是减少碰撞检测的范围，更不容易被检测到

			mov ebx,player.h;ebx存储的相当于max_y
			add ebx,(BOARD PTR [edi]).h
			shr ebx,1
			sub ebx,10
			mov ecx,(BOARD PTR [edi]).center_x;物体的x坐标
			mov edx,(BOARD PTR [edi]).center_y;物体的y坐标
			sub ecx,player.center_x ;x-x
			sub edx,player.center_y	;y-y
			cmp ecx,eax
			jg label1
			add ecx,eax ;ecx加上eax之后如果要是小于0那么就意味着它的距离是负数，并且很大
			cmp ecx,0
			jl label1

			cmp edx,ebx
			jg label1
			add edx,ebx
			cmp edx,0
			jl label1
			mov PaintFlag,2 ;死亡画面
			.break
	label1:
		.endif
		inc esi
		add edi,TYPE BOARD
	.endw
	ret
CheckCollision endp

;--------------------------------------------------------------------------------------
;@Function Name :   CheckGetLifeBag
;@Param			:	
;@Description   :	检查飞机是否拾取了血包
;@Author        :   
;--------------------------------------------------------------------------------------
CheckGetLifeBag proc uses eax ebx ecx edx esi edi
	mov edi, offset LifeBag
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 0	; 没有血包
		ret
	.endif

	mov eax, player.center_x
	mov ebx, (LBAG PTR [edi]).x
	.if eax < ebx
		ret
	.endif
	add ebx, (LBAG PTR [edi]).w
	.if eax > ebx
		ret
	.endif

	mov eax, player.center_y
	mov ebx, (LBAG PTR [edi]).y
	.if eax < ebx
		ret
	.endif
	add ebx, (LBAG PTR [edi]).h
	.if eax > ebx
		ret
	.endif

	; 拾取成功
	mov player.Big2, 1	; 大招2的flag为true
	mov edi, offset LifeBag
	mov (LBAG PTR [edi]).flag, 0	; 血包被拾取 消失

	ret
CheckGetLifeBag endp

;--------------------------------------------------------------------------------------
;@Function Name :   CheckEPCollision;
;@Param			:  
;@Description   :	自机和敌机的碰撞检测，撞到敌机则直接死亡
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
CheckEPCollision proc uses eax ebx ecx edx esi edi
	;应该计算出物体的中心坐标再去检测,

	mov eax,player.w ;eax当中存储的是物体的中心x坐标
	shr eax,1;
	add eax,player.x
	mov player.center_x,eax

	mov ebx,player.h ;ebx当中存储的是物体的中心y坐标
	shr ebx,1;
	add ebx,player.y
	mov player.center_y,ebx

	;检测是否碰撞到了敌人
	mov esi,0
	mov edi,offset enemy
	.while esi<enemyCount
		mov eax,(ENEMY PTR [edi]).LP
		.if eax > 0
			mov eax,player.w ;eax,存储的相当于max_x
			add eax,(ENEMY PTR [edi]).w 
			shr eax,1
			sub eax,10 ;这个减去5相当于是减少碰撞检测的范围，更不容易被检测到

			mov ebx,player.h;ebx存储的相当于max_y
			add ebx,(ENEMY PTR [edi]).h
			shr ebx,1
			sub ebx,10
			mov ecx,(ENEMY PTR [edi]).center_x;物体的x坐标
			mov edx,(ENEMY PTR [edi]).center_y;物体的y坐标
			sub ecx,player.center_x ;x-x
			sub edx,player.center_y	;y-y
			cmp ecx,eax
			jg label2
			add ecx,eax ;ecx加上eax之后如果要是小于0那么就意味着它的距离是负数，并且很大
			cmp ecx,0
			jl label2

			cmp edx,ebx
			jg label2
			add edx,ebx
			cmp edx,0
			jl label2
			mov PaintFlag,2 ;死亡画面
			.break
	label2:
		.endif
		inc esi
		add edi,TYPE ENEMY
	.endw
	ret
CheckEPCollision endp

;--------------------------------------------------------------------------------------
;@Function Name :  CheckEBCollision
;@Param			:  
;@Description   :	碰撞敌机子弹检测，如果本机被击中扣除对应生命值（追踪子弹两滴血，散弹一滴血）
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
CheckEBCollision proc uses eax ebx ecx edx esi edi
	;应该计算出物体的中心坐标再去检测,
	mov eax,player.w ;eax当中存储的是物体的中心x坐标
	shr eax,1;
	add eax,player.x
	mov player.center_x,eax

	mov ebx,player.h ;ebx当中存储的是物体的中心y坐标
	shr ebx,1;
	add ebx,player.y
	mov player.center_y,ebx

	;检测是否碰撞到了子弹
	mov esi,0
	mov edi,offset eBullet
	.while esi<eBulletCount
		mov eax,(EBULLET PTR [edi]).flag
		.if eax > 0
			mov eax,player.w ;eax,存储的相当于max_x
			add eax,(EBULLET PTR [edi]).radius 
			shr eax,1
			sub eax,10 ;这个减去5相当于是减少碰撞检测的范围，更不容易被检测到

			mov ebx,player.h;ebx存储的相当于max_y
			add ebx,(EBULLET PTR [edi]).radius
			shr ebx,1
			sub ebx,10
			mov ecx,(EBULLET PTR [edi]).center_x;物体的x坐标
			mov edx,(EBULLET PTR [edi]).center_y;物体的y坐标
			sub ecx,player.center_x ;x-x
			sub edx,player.center_y	;y-y
			cmp ecx,eax
			jg label3
			add ecx,eax ;ecx加上eax之后如果要是小于0那么就意味着它的距离是负数，并且很大
			cmp ecx,0
			jl label3

			cmp edx,ebx
			jg label3
			add edx,ebx
			cmp edx,0
			jl label3
			mov eax, player.HP
			mov ebx,(EBULLET PTR [edi]).damage
			.if eax>ebx
				sub eax, (EBULLET PTR [edi]).damage
				mov player.HP, eax
			.elseif
				mov player.HP, 0
			.endif		
			mov (EBULLET PTR [edi]).flag, 0
			cmp eax, 0
			jge label3
			mov PaintFlag, 2
			.break
	label3:
		.endif
		inc esi
		add edi,TYPE EBULLET
	.endw
	.if player.HP==0
		mov PaintFlag,2
	.endif

	ret
CheckEBCollision endp
;--------------------------------------------------------------------------------------
;@Function Name :   CheckPBHit;
;@Param			:  
;@Description   :	子弹打中敌机碰撞检测，本机的子弹击中敌方可以扣除敌方对应的血量
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
CheckPBHit proc uses eax ebx ecx edx esi edi
	xor ecx, ecx
	mov edi, offset pBullet
	.while ecx < pBulletCount
		mov eax, (PBULLET PTR[edi]).flag
		.if eax != 0
			xor ebx, ebx
			mov esi, offset enemy
			.while ebx < enemyCount 
				;判断敌人是否有效
				mov eax,(ENEMY PTR[esi]).LP
				.if eax>0
					mov eax, (PBULLET PTR[edi]).center_x
					mov edx, (ENEMY PTR[esi]).x
					.if eax > edx
						add edx, (ENEMY PTR[esi]).w
						.if eax < edx
							mov eax, (PBULLET PTR[edi]).center_y
							mov edx, (ENEMY PTR[esi]).y
							.if eax > edx
								add edx, (ENEMY PTR[esi]).h
								.if eax < edx
									mov eax, (ENEMY PTR[esi]).LP
									.if eax > 1
										sub eax, 1
										mov (ENEMY PTR[esi]).LP, eax
									.else
										mov (ENEMY PTR[esi]).LP, 0
										add MyScore_one, 1
										add player.EnergyLevel, 1
										.if player.EnergyLevel > MAX_ENERGY
											mov player.EnergyLevel, MAX_ENERGY
										.endif
									.endif
									mov (PBULLET PTR[edi]).radius, 0
									mov (PBULLET PTR[edi]).flag, 0
								.endif
							.endif
						.endif
					.endif
				.endif
				inc ebx
				add esi, TYPE ENEMY
			.endw
		.endif
		inc ecx
		add edi, TYPE PBULLET
	.endw
	ret
CheckPBHit endp

;--------------------------------------------------------------------------------------
;@Function Name :   UpdateUlt
;@Param			:  
;@Description   :	更新大招相关信息
;@Author        :   
;--------------------------------------------------------------------------------------
UpdateUlt proc uses eax ebx ecx edx esi edi
	LOCAL NowTime : dword	; 当前时间
	invoke GetTickCount
	mov NowTime, eax
	mov ebx, eax
	sub ebx, Big1StartTime
	.if ebx >= 10000	; 如果到10s了，“金刚弹”失效
		mov player.Big1, 0
	.endif
	mov ebx, eax
		sub ebx, Big3StartTime
	.if ebx >= 10000	; 如果到10s了，僚机加成失效
		mov player.Big3, 0
	.endif
	ret
UpdateUlt endp

;--------------------------------------------------------------------------------------
;@Function Name :   UpdateOtherData
;@Param			:  
;@Description   :	更新其他一些上面没有更新的数据
;@Author        :   
;--------------------------------------------------------------------------------------
UpdateOtherData proc uses eax ebx ecx edx esi edi
	; 更新得分的十位、个位
	.if MyScore_one > 9
		mov eax, MyScore_one
		sub eax, 10
		add MyScore_ten, 1
		mov MyScore_one, eax
		mov UpgradeDifficult, 1
	.endif
	.if UpgradeDifficult == 1	; 如果当前游戏升级的flag = 1，加快敌人刷新频率
		sub EnemyInterval, 50
		.if EnemyInterval < 0
			MOV EnemyInterval, 10
		.endif
		mov UpgradeDifficult, 0
	.endif
	ret
UpdateOtherData endp

;--------------------------------------------------------------------------------------
;@Function Name :   Paint_0
;@Param			:  
;@Description   :	绘制开始菜单主界面
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
Paint_0 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword ;
	;加载背景图片
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY
	
    ;开始界面目前就一个开始游戏一个退出游戏
	;你俩如果方便可以加一个游戏介绍功能，我懒了，能玩就行
	invoke store,hMenumask ,280,125,200,100,SRCAND
	invoke store,hStartButton ,280,125,200,100,SRCPAINT

	invoke store,hMenumask ,280,300,200,100,SRCAND
	invoke store,hExitButton,280,300,200,100,SRCPAINT
	
	;帮助按钮
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hHelpButton,700,0,75,75,SRCPAINT
	ret
Paint_0 endp
;--------------------------------------------------------------------------------------
;@Function Name :   Paint_1
;@Param			:  
;@Description   :	绘制游戏内界面
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
Paint_1 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	;加载背景图片
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY

	; 加载血包
	mov edi, offset LifeBag
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 1
		invoke store, hLifeBagMask, (LBAG PTR [edi]).x, (LBAG PTR [edi]).y, (LBAG PTR [edi]).w, (LBAG PTR [edi]).h, SRCAND
		invoke store, hLifeBag, (LBAG PTR [edi]).x, (LBAG PTR [edi]).y, (LBAG PTR [edi]).w, (LBAG PTR [edi]).h, SRCPAINT
	.endif
	
	;加载自己
	.IF player.IMAGE_FLAG==0
		invoke store,hPlayerNormalMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerNormal0,player.x,player.y,player.w,player.h,SRCPAINT
	.ELSEIF player.IMAGE_FLAG==1
		invoke store,hPlayerRightMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerRight0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;当按键没有被按下的时候，要复原图片，向前飞行
	.ELSEIF player.IMAGE_FLAG==2
		invoke store,hPlayerLeftMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerLeft0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;当按键没有被按下的时候，要复原图片，向前飞行
	.ELSEIF player.IMAGE_FLAG==3
		invoke store,hPlayerUpMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerUp0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;当按键没有被按下的时候，要复原图片，向前飞行
	.ELSEIF player.IMAGE_FLAG==4
		invoke store,hPlayerDownMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerDown0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;当按键没有被按下的时候，要复原图片，向前飞行
	.ENDIF

		;加载僚机
	.if player.Big3 == 1
		mov esi, offset wingmans
		xor ecx, ecx
		.while ecx < 2
		    invoke store, hWingmansMask, (PLAYER PTR[esi]).x,(PLAYER PTR[esi]).y,(PLAYER PTR[esi]).w,(PLAYER PTR[esi]).h,SRCAND
			invoke store, hWingmans,(PLAYER PTR[esi]).x,(PLAYER PTR[esi]).y,(PLAYER PTR[esi]).w,(PLAYER PTR[esi]).h,SRCPAINT
			inc ecx
			add esi, TYPE PLAYER
		.endw
	.endif
	
	;加载板子
	mov esi,0
	mov edi,offset boards
	.while esi<boardCount
		mov eax,(BOARD PTR [edi]).flag
		.if eax==1
			invoke store,hBoardmask,(BOARD PTR [edi]).x,(BOARD PTR [edi]).y,(BOARD PTR [edi]).w,(BOARD PTR [edi]).h,SRCAND
			invoke store,hBoard,(BOARD PTR [edi]).x,(BOARD PTR [edi]).y,(BOARD PTR [edi]).w,(BOARD PTR [edi]).h,SRCPAINT
		.endif
		add edi,TYPE BOARD
		inc esi
	.endw

	;加载双方子弹
	xor esi, esi
	mov edi, offset pBullet
	.while esi < pBulletCount
		mov eax, (PBULLET PTR[edi]).flag
		.if eax == 1
			mov edx, (PBULLET PTR[edi]).BulletType
			.if edx == 0
				mov eax, (EBULLET PTR[edi]).radius
				add eax, eax
				invoke store, hPBullet0mask, (PBULLET PTR[edi]).x, (PBULLET PTR[edi]).y, eax, (PBULLET PTR[edi]).radius, SRCAND
				invoke store, hPBullet0, (PBULLET PTR[edi]).x, (PBULLET PTR[edi]).y, eax, (PBULLET PTR[edi]).radius, SRCPAINT
			.elseif edx == 1
				mov ecx, (EBULLET PTR[edi]).radius
				add ecx, ecx
				mov eax, ecx
				add eax, eax
				invoke store, hPBullet1mask, (PBULLET PTR[edi]).x, (PBULLET PTR[edi]).y, eax, ecx, SRCAND
				invoke store, hPBullet1, (PBULLET PTR[edi]).x, (PBULLET PTR[edi]).y, eax, ecx, SRCPAINT
			.endif
		.endif
		add edi, TYPE PBULLET
		inc esi
	.endw
	xor esi, esi
	mov edi, offset eBullet
	.while esi < eBulletCount
		mov eax, (EBULLET PTR[edi]).flag
		.if eax == 1
			mov ebx,(EBULLET PTR[edi]).EBType
			.if ebx == 0
				invoke store, hEBullet0mask, (EBULLET PTR[edi]).x, (EBULLET PTR[edi]).y, (EBULLET PTR[edi]).radius,(EBULLET PTR[edi]).radius , SRCAND
				invoke store, hEBullet0, (EBULLET PTR[edi]).x, (EBULLET PTR[edi]).y, (EBULLET PTR[edi]).radius, (EBULLET PTR[edi]).radius, SRCPAINT
			.elseif ebx == 1
				invoke store, hEBullet1mask, (EBULLET PTR[edi]).x, (EBULLET PTR[edi]).y, (EBULLET PTR[edi]).radius, (EBULLET PTR[edi]).radius, SRCAND
				invoke store, hEBullet1, (EBULLET PTR[edi]).x, (EBULLET PTR[edi]).y, (EBULLET PTR[edi]).radius, (EBULLET PTR[edi]).radius, SRCPAINT
			.endif
		.endif
		add edi, TYPE EBULLET
		inc esi
	.endw

	;加载敌人和血条		用edx，ecx，eax
	xor esi, esi
	mov edi, offset enemy
	.while esi < enemyCount
		mov eax, (ENEMY PTR[edi]).LP
		.if eax > 0
			mov ebx,(ENEMY PTR[edi]).EType ;不同的敌人会加载不同的图片
			.if ebx==0
				invoke store, hEnemyMask0, (ENEMY PTR[edi]).x, (ENEMY PTR[edi]).y, (ENEMY PTR[edi]).w, (ENEMY PTR[edi]).h, SRCAND
				invoke store, hEnemy0, (ENEMY PTR[edi]).x, (ENEMY PTR[edi]).y, (ENEMY PTR[edi]).w, (ENEMY PTR[edi]).h, SRCPAINT
;----------------------------------------------------------------------------------
				xor ecx, ecx
				mov eax, (ENEMY PTR[edi]).x 
				mov edx, (ENEMY PTR[edi]).y
				sub edx, 5
				mov ebx, (ENEMY PTR[edi]).LP
				.while ecx < ebx
					invoke store, hEnemyHealth, eax, edx, 20, 5, SRCCOPY
					inc ecx
					add eax, 20
				.endw
;----------------------------------------------------------------------------------
			.elseif ebx==1
				invoke store, hEnemyMask1, (ENEMY PTR[edi]).x, (ENEMY PTR[edi]).y, (ENEMY PTR[edi]).w, (ENEMY PTR[edi]).h, SRCAND
				invoke store, hEnemy1, (ENEMY PTR[edi]).x, (ENEMY PTR[edi]).y, (ENEMY PTR[edi]).w, (ENEMY PTR[edi]).h, SRCPAINT
;----------------------------------------------------------------------------------
				xor ecx, ecx
				mov eax, (ENEMY PTR[edi]).x 
				mov edx, (ENEMY PTR[edi]).y
				sub edx, 5
				mov ebx, (ENEMY PTR[edi]).LP
				.while ecx < ebx
					invoke store, hEnemyHealth, eax, edx, 20, 5, SRCCOPY
					inc ecx
					add eax, 20
				.endw
;----------------------------------------------------------------------------------
			.elseif ebx==2
				invoke store, hBossMask, (ENEMY PTR[edi]).x, (ENEMY PTR[edi]).y, (ENEMY PTR[edi]).w, (ENEMY PTR[edi]).h, SRCAND
				invoke store, hBoss, (ENEMY PTR[edi]).x, (ENEMY PTR[edi]).y, (ENEMY PTR[edi]).w, (ENEMY PTR[edi]).h, SRCPAINT
;----------------------------------------------------------------------------------
				xor ecx, ecx
				mov eax, 150
				mov edx, (ENEMY PTR[edi]).LP
				.while ecx < edx
					invoke store, hEnemyHealth, eax, 55, 1, 20, SRCCOPY
					inc ecx
					add eax, 1
				.endw
;----------------------------------------------------------------------------------
			.endif
		.endif
		add edi, TYPE ENEMY
		inc esi
	.endw

	;加载返回和暂停按钮
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hReturnButton,700,0,75,75,SRCPAINT

	invoke store,hButtonMask,625,0,75,75,SRCAND
	invoke store,hStopButton,625,0,75,75,SRCPAINT

	;帮助按钮
	invoke store,hButtonMask,550,0,75,75,SRCAND
	invoke store,hHelpButton,550,0,75,75,SRCPAINT

	; 加载能量槽
	mov ecx, 350
	mov esi, 0
	.while esi < player.EnergyLevel
		invoke store, hEnergyPlotMask, ecx, 17, slot_width, 20, SRCAND
		invoke store, hEnergyPlot, ecx, 17, slot_width, 20, SRCPAINT
		add ecx, slot_width
		inc esi
	.endw
	
	;加载生命值
	mov ecx,10
	mov esi,0
	.while esi<player.HP
		invoke store,hHeartMask,ecx,10,40,40,SRCAND
		invoke store,hHeart,ecx,10,40,40,SRCPAINT
		add ecx,45
		inc esi
	.endw
	
	; 加载大招1标志
	invoke store, hBuddhaMask, 160, 0, 50, 50, SRCAND
	.if player.EnergyLevel == MAX_ENERGY
		invoke store, hBuddha, 160, 0, 50, 50, SRCPAINT
	.else
		invoke store, hBuddhaBlack, 160, 0, 50, 50, SRCPAINT
	.endif
	
	; 加载大招2标志
	invoke store, hBuddhaMask, 210, 0, 50, 50, SRCAND
	.if player.Big2 == 1
		invoke store, hCheckAndRepair, 210, 0, 50, 50, SRCPAINT
	.else
		invoke store, hCheckAndRepairBlack, 210, 0, 50, 50, SRCPAINT
	.endif
	; 加载大招3标志
	invoke store, hBuddhaMask, 260, 0, 50, 50, SRCAND
	.if player.EnergyLevel == MAX_ENERGY
		invoke store, hWingmanButton, 260, 0, 50, 50, SRCPAINT
	.else
		invoke store, hWingmanButtonBlack, 260, 0, 50, 50, SRCPAINT
	.endif

	; 加载得分
	mov ecx, 670
	mov edx, 470
	.if MyScore_ten == 0
		invoke store, hNum0Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum0, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 1
		invoke store, hNum1Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum1, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 2
		invoke store, hNum2Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum2, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 3
		invoke store, hNum3Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum3, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 4
		invoke store, hNum4Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum4, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 5
		invoke store, hNum5Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum5, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 6
		invoke store, hNum6Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum6, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 7
		invoke store, hNum7Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum7, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 8
		invoke store, hNum8Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum8, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_ten == 9
		invoke store, hNum9Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum9, ecx, edx, 50, 86, SRCPAINT
	.endif
	add ecx, 50
	.if MyScore_one == 0
		invoke store, hNum0Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum0, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 1
		invoke store, hNum1Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum1, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 2
		invoke store, hNum2Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum2, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 3
		invoke store, hNum3Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum3, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 4
		invoke store, hNum4Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum4, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 5
		invoke store, hNum5Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum5, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 6
		invoke store, hNum6Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum6, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 7
		invoke store, hNum7Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum7, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 8
		invoke store, hNum8Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum8, ecx, edx, 50, 86, SRCPAINT
	.elseif MyScore_one == 9
		invoke store, hNum9Mask, ecx, edx, 50, 86, SRCAND
		invoke store, hNum9, ecx, edx, 50, 86, SRCPAINT
	.endif

	;展示
	;invoke display
	ret
Paint_1 endp

;--------------------------------------------------------------------------------------
;@Function Name :   Paint_2
;@Param			:  
;@Description   :	死亡界面,在绘制好游戏界面的基础上增加一个返回主菜单
;@Author        :   张益宁
;--------------------------------------------------------------------------------------
Paint_2 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke Paint_1
	;在此基础上，还要加入返回界面
	invoke store,hMenumask,280,200,200,100,SRCAND
	invoke store,hRestartButton,280,200,200,100,SRCPAINT
	ret
Paint_2 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_3
;@Param			:  
;@Description   :  暂停游戏,在绘制好游戏界面的基础上增加一个返回游戏
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
Paint_3 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke Paint_1

	invoke store,hMenumask,280,200,200,100,SRCAND
	invoke store,hContinueButton,280,200,200,100,SRCPAINT
	ret
Paint_3 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_4
;@Param			:  
;@Description   :  查看游戏帮助（从开始界面进入）
;@Author        :  安禹堃
;--------------------------------------------------------------------------------------
Paint_4 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY

	;加入返回按钮
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hReturnButton,700,0,75,75,SRCPAINT

	;加入帮助文字
	invoke store,hHelpMask,130,80,520,407,SRCAND
	invoke store,hHelp,130,80,520,407,SRCPAINT

	ret
Paint_4 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_5
;@Param			:  
;@Description   :  查看游戏帮助（从游戏界面进入）
;@Author        :  安禹堃
;--------------------------------------------------------------------------------------
Paint_5 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY

	;加入返回按钮
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hReturnButton,700,0,75,75,SRCPAINT

	;加入帮助文字
	invoke store,hHelpMask,130,80,520,407,SRCAND
	invoke store,hHelp,130,80,520,407,SRCPAINT

	ret
Paint_5 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_6
;@Param			:  
;@Description   :  击败boss，显示胜利画面
;@Author        :  安禹堃
;--------------------------------------------------------------------------------------
Paint_6 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke Paint_1

	invoke store,hMenumask,280,275,200,100,SRCAND
	invoke store,hRestartButton,280,275,200,100,SRCPAINT

	invoke store,hVictoryMask,100,125,580,154,SRCAND
	invoke store,hVictory,100,125,580,154,SRCPAINT
	ret
Paint_6 endp


;--------------------------------------------------------------------------------------
;@Function Name :  WndProc 
;@Param			:  
;@Description   :  主体绘制，用于调用上面的三个绘制函数
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
	LOCAL @posX:dword ;鼠标的位置
	LOCAL @posY:dword ;鼠标的位置
	.if  uMsg==	WM_CREATE
		invoke LoadBitImage ;加载图片的位图
		invoke	GetClientRect,hWnd,addr stRect ;获取客户窗体的大小
		invoke InitBackGround
		mov PaintFlag,0 ;起初先绘制主界面
		invoke SetTimer,hWnd,1,freshTime,NULL ;启动定时器，编号为1
	.elseif uMsg==WM_KEYDOWN
		.if PaintFlag==1
			mov eax,wParam
			invoke PlayerMove,wParam
		.endif
	.elseif uMsg==WM_LBUTTONDOWN
		mov eax,lParam
		and eax,0FFFFh
		mov @posX,eax
		mov eax,lParam
		shr eax,16
		mov @posY,eax
		mov eax,@posX

		.if PaintFlag==0 ;此时在主界面
			.IF @posX>280 && @posX<480 && @posY>125 && @posY<225 ;点击到了开始游戏
				invoke RtlZeroMemory, offset player, TYPE PLAYER
				;数据初始化
				mov pBulletCount, 0
				mov eBulletCount, 0
				mov enemyCount, 0
				mov MyScore_one, 0
				mov MyScore_ten, 0
				mov generate_flag, 1

				invoke InitBackGround;初始化背景
				invoke InitPlayer, 0, 0 ;初始化人物
				invoke InitBoard ;初始化板子
				mov PaintFlag,1
				invoke InvalidateRect,hWnd,NULL,FALSE

			.elseif @posX>280 && @posX<480 && @posY>300 && @posY<400 ;点击到了结束游戏
				;直接调用销毁即可
				invoke	DestroyWindow,hWinMain
				invoke	PostQuitMessage,NULL
				invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
				ret

			.elseif @posX>700 && @posX<775 && @posY>0 && @posY<75
				mov PaintFlag,4

			.endif
		.elseif PaintFlag==1 ;在游戏界面内

			.IF @posX>700 && @posX<775 && @posY>0 && @posY<75 ;点击返回按钮
				mov PaintFlag,0
			.ELSEIF @posX>625 && @posX<700 && @posY>0 && @posY<75 ;点击暂停按钮
				mov PaintFlag,3
			.ELSEIF @posX>550 && @posX<625 && @posY>0 && @posY<75 ;点击帮助按钮
				mov PaintFlag,5
			.endif
		.elseif PaintFlag==2 ;在死亡界面内
			.if @posX>250 && @posX<450 && @posY>200 && @posY<300	; 重新开始游戏，返回主界面
				mov PaintFlag,0
			.endif

		.elseif PaintFlag==3 ;在暂停界面内
			.if @posX>250 && @posX<450 && @posY>200 && @posY<300	; 返回游戏界面
				mov PaintFlag,1
			.endif

		.elseif PaintFlag==4 ;在帮助界面（从开始界面进入，要返回开始界面）
			.IF @posX>700 && @posX<775 && @posY>0 && @posY<75 ;
				mov PaintFlag,0
			.endif
		.elseif PaintFlag==5 ;在帮助界面（从游戏界面进入，要返回游戏界面）
			.IF @posX>700 && @posX<775 && @posY>0 && @posY<75 ;
				mov PaintFlag,1
			.endif
		.elseif PaintFlag==6 ;在胜利界面，有一个返回按钮
			.if @posX>250 && @posX<450 && @posY>275 && @posY<375	; 重新开始游戏，返回主界面
				mov PaintFlag,0
			.endif
		.endif

	.elseif uMsg ==WM_TIMER ;刷新
		.IF PaintFlag==0||PaintFlag==4||PaintFlag==5
			invoke InvalidateRect,hWnd,NULL,FALSE ;改为true会一直闪烁
			invoke UpdateBackGround ;更新背景图片	
		.ELSEIF PaintFlag==1 ;在游戏中，可能需要调用生成物体的函数
			dec timer
			.if timer == 0
				invoke generateEnemy
				mov eax,EnemyInterval
				mov timer, eax
			.endif
			
			add LifeBagTimer, 1
			mov eax, LifeBagInterval
			sub eax, LifeBagTimer
			.if eax == 0
				invoke generateLifeBag
				mov LifeBagTimer, 0
			.endif

			invoke InvalidateRect,hWnd,NULL,FALSE ;改为true会一直闪烁
			invoke UpdateBackGround ;更新背景图片
			invoke UpdateBoard ;更新板子位置
			invoke UpdateLifeBag	; 更新血包位置
			invoke CheckGetLifeBag	; 检测飞机是否拾取血包
			invoke CheckCollision ;检测飞机是否撞到板子
			invoke UpdateUlt	;更新大招相关的信息
			invoke UpdatePBullet ;更新自己的子弹
			invoke CheckHitBoard ;检测自己的子弹和板子的碰撞
			invoke UpdateEBullet ;更新敌方的子弹;
			invoke UpdateEnemy ;更新敌人的位置;
			invoke generateEBullet ;让敌人发射子弹;
			invoke CheckEPCollision ;敌人和自己的碰撞;
			invoke CheckEBCollision ;敌人子弹和自己的碰撞
			invoke CheckPBHit ;自己的子弹和敌人的碰撞;
			invoke UpdateOtherData		; 一些其他数据的更新
			.if eBulletCount > 150
				invoke RecycleEBullet
			.endif
			.if enemyCount > 75
				invoke RecycleEnemy
			.endif
			.if pBulletCount > 75
				invoke RecyclePBullet
			.endif
		.ELSE		
			invoke InvalidateRect,hWnd,NULL,FALSE
		.ENDIF
	.elseif uMsg ==WM_PAINT ;根据目前需要调用的参数来分别调用三个绘制
		.if PaintFlag==0
			invoke Paint_0
		.elseif PaintFlag==1
			invoke Paint_1
		.elseif PaintFlag==2
			invoke Paint_2
		.elseif PaintFlag==3
			invoke Paint_3
		.elseif PaintFlag==4
			invoke Paint_4
		.elseif PaintFlag==5
			invoke Paint_5
		.elseif PaintFlag==6
			invoke Paint_6
		.endif 
		invoke display
	;检测到关闭窗口后进程未结束，添加WM_CLOSE消息处理
	.elseif	uMsg == WM_CLOSE 
		invoke	DestroyWindow,hWinMain
		invoke	PostQuitMessage,NULL
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
	.endif
	ret
WndProc endp 

;--------------------------------------------------------------------------------------
;@Function Name :  WinMain 
;@Param			:  
;@Description   :  游戏主函数
;@Author        :  张益宁
;--------------------------------------------------------------------------------------
WinMain proc
	local	@stWndClass:WNDCLASSEX
	local	@stMsg:MSG
	invoke	GetModuleHandle,NULL
	mov	hInstance,eax;获取程序的句柄
	invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
	invoke	LoadCursor,0,IDC_ARROW
	mov	@stWndClass.hCursor,eax
	invoke LoadIcon, hInstance, 101	; 
	mov	@stWndClass.hIcon,eax
	mov	@stWndClass.hIconSm,eax
	push hInstance
	pop	@stWndClass.hInstance
	mov	@stWndClass.cbSize,sizeof WNDCLASSEX
	mov	@stWndClass.style,CS_HREDRAW or CS_VREDRAW
	mov	@stWndClass.lpfnWndProc,offset WndProc ;指定窗口处理程序
	mov	@stWndClass.hbrBackground,COLOR_WINDOW + 1
	mov	@stWndClass.lpszClassName,offset MyWinClass;窗口的类名
	invoke	RegisterClassEx,addr @stWndClass
	invoke	CreateWindowEx,WS_EX_CLIENTEDGE,offset MyWinClass,offset WinTitle,\
			WS_OVERLAPPEDWINDOW,\
			100,100,800,600,\
			NULL,NULL,hInstance,NULL
	mov	hWinMain,eax
	invoke ShowWindow, hWinMain,SW_SHOWDEFAULT 
	invoke UpdateWindow, hWinMain 
	.while	TRUE
		invoke	GetMessage,addr @stMsg,NULL,0,0
		.break	.if eax	== 0
		invoke	TranslateMessage,addr @stMsg
		invoke	DispatchMessage,addr @stMsg
	.endw
	ret
WinMain endp

;main函数
main proc
	call WinMain	
	invoke ExitProcess,0
	ret
main endp
end main