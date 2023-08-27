;--------------------------------------------------------------------------------------
;@ProjectName    :   Space_Invader_ASM
;@Version1       :   Space_Invader_ASM_v1.5
;@LastEditTime   :   2022/12/13
;@Author         :   ��������֣�ӷ�������ҡ�����
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
str1 byte '���ű���ͼƬ��λ�ã�%d %d',0ah,0

MAXSIZE equ 1000;������ʾ��������Ĵ�С
freshTime dword 60;ˢ��ʱ�䣬�Ժ���Ϊ��λ

;ͼƬ��Դ��ַ����
;���Ҫ����ͼƬ��ס������bmp
;�˵���ť
MENU_START byte 'source\menu_start.bmp',0
MENU_QUIT byte 'source\menu_quit.bmp',0
MENU_CONTINUE byte 'source\menu_continue.bmp',0
MENU_RESTART byte 'source\menu_restart.bmp',0
MENUmask byte 'source\menumask.bmp',0

; ������
ENERGYPLOT byte 'source\EnergyPlot.bmp', 0
ENERGYPLOTMASK byte 'source\EnergyPlotmask.bmp', 0

; ����1����յ�
BUDDHA byte 'source\Buddha.bmp', 0
BUDDHABLACK byte 'source\BuddhaBlack.bmp', 0
BUDDHAMASK byte 'source\Buddhamask.bmp', 0
; ����2���Լ��޸�
CHECKANDREPAIR byte 'source\CheckAndRepair.bmp', 0
CHECKANDREPAIRBLACK byte 'source\CheckAndRepairBlack.bmp', 0

;ľ���ϰ���
BOARDPIC byte 'source\board.bmp',0
BOARDMASK byte 'source\boardmask.bmp',0

; Ѫ��
LIFEBAG byte 'source\LifeBag.bmp', 0
LIFEBAGMASK byte 'source\LifeBagmask.bmp', 0

;�Լ��͵��˵��ӵ�Pbullet��Ebullet
PBULLET0 byte 'source\pBullet0.bmp',0
PBULLET0mask byte 'source\pBullet0mask.bmp',0
PBULLET1 byte 'source\pBullet1.bmp',0
PBULLET1mask byte 'source\pBullet1mask.bmp',0

EBULLET0 byte 'source\eBullet0.bmp',0
EBULLET0mask byte 'source\eBullet0mask.bmp',0
EBULLET1 byte 'source\eBullet1.bmp',0
EBULLET1mask byte 'source\eBullet1mask.bmp',0

;���˵�ͼƬ���������һ��
ENEMY0 byte 'source\enemy0.bmp',0
ENEMYMask0 byte 'source\enemy0mask.bmp',0
ENEMY1 byte 'source\enemy1.bmp',0
ENEMYMask1 byte 'source\enemy1mask.bmp',0

;�Լ���ͼƬ���������һ��
PLAYER_NORMAL byte 'source\plane_R.bmp',0 ;����������ʱ��ʹ�õ�ͼƬ
PLAYER_NORMALmask byte 'source\plane_Rmask.bmp',0 ;����ʱ������
PLAYER_RIGHT byte 'source\plane_R.bmp',0 ;���������ƶ���ʱ��ʹ�õ�ͼƬ
PLAYER_RIGHTmask byte 'source\plane_Rmask.bmp', 0
PLAYER_LEFT byte 'source\plane_L.bmp',0 ;���������ƶ���ʱ��ʹ�õ�ͼƬ
PLAYER_LEFTmask byte 'source\plane_Lmask.bmp', 0
PLAYER_UP byte 'source\plane_U.bmp',0 ;���������ƶ���ʱ��ʹ�õ�ͼƬ
PLAYER_UPmask byte 'source\plane_Umask.bmp', 0
PLAYER_DOWN byte 'source\plane_D.bmp',0 ;���������ƶ���ʱ��ʹ�õ�ͼƬ
PLAYER_DOWNmask byte 'source\plane_Dmask.bmp', 0

;����ͼƬ���������һ�£����ڻ���һҳ��ʱ�����е���֣��ҵ���ûPS������ͼ�������ģ���ռλ����û�취
back byte 'source\back.bmp',0

;����ֵ
HEART byte 'source\heart.bmp',0
HEARTMASK byte 'source\heartmask.bmp',0

;���غ���ͣ�İ�ť����������
STOPBUTTON byte 'source\button_stop.bmp',0
RETURNBUTTON byte 'source\button_return.bmp',0

; �÷�����
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
;λͼ�ṹ
ITEAM struct
	hbp dd ? ;λͼ�ľ��
	x dd ? ;λͼx����
	y dd ?;λͼy����
	w dd ?;λͼ���
	h dd ?;λͼ�߶�
	flag dd ?;λͼ��չʾ��ʽ
ITEAM ends

;��ҽṹ
PLAYER struct
	x dd ?
	y dd ?
	w dd ?
	h dd ?
	center_x dd ? ;��������ģ�x���꣬���������ײ
	center_y dd ? ;��������ģ�y���꣬���������ײ
	IMAGE_FLAG dd ?;�����Ӧ��ͼ�ξ��
	UpCount dd ? ;��¼���ϰ������������µĴ�����������һ������֮���л�ͼƬ
	DownCount dd ?;���°���
	LeftCount dd ?;���󰴼�
	RightCount dd ?;���Ұ���
	Speed dd ?  ;�ɻ��ٶ�
	HP dd ? ;�ɻ�Ѫ��
	EnergyLevel dd ?	; ��������1-3��ÿ����һ��������������+1
	Big1 dd ? ;	����1��������������ġ���յ������Դ�͸�ӵ�
	Big2 dd ? ; ����2���Լ��޸��������ʱѪ����������������һ��Ѫ
	Big3 dd ? ; ����3��ʹ���Ż������Լ�ǿ����
PLAYER ends

;ľ���ϰ��ṹ
BOARD struct
	x dword ?
	y dword ?
	w dword ?
	h dword ?
	flag dword ? ;�����жϰ����Ƿ񱻻���
	center_x dd ? ;���ӵ����ģ�x���꣬���������ײ
	center_y dd ? ;���ӵ����ģ�y���꣬���������ײ
BOARD ends

LBAG struct
	x dword ?
	y dword ?
	w dword ?
	h dword ?
	flag dword ?	; �����ж�Ѫ���Ƿ�ʰȡ
	center_x dd ?	; Ѫ�������ģ�x���꣬�������ʰȡ
	center_y dd ?	; Ѫ�������ģ�y���꣬�������ʰȡ
LBAG ends

;�����ӵ��ṹ
PBULLET struct
	x dd ? ;����
	y dd ?
	center_x dd ? ;�������꣬�����ײ��
	center_y dd ?
	radius dd ? ;�뾶
	flag dd ? ;��Ч�Լ��
	Speed dd ? ;�ӵ����ٶ�
	BulletType dd ?	; �ӵ������ࣨ0����ͨ��	1����յ���
PBULLET ends

;�о��ṹ
;�з����ұ߳��֣���ӹ̶�ģʽ�����ƣ�ֹͣ��ʼ�����ͣ��һ��ʱ����������������
;�ƻ��������ֵ��ˣ���Ϊ������֣�һ����׼�ҷ�������˴󵯣���һ�̶ֹ���˸�λ�÷���С��
ENEMY struct
	x dd ?
	y dd ?
	w dd ?
	h dd ?
	center_x dd ? ;��������ģ�x���꣬���������ײ
	center_y dd ? ;��������ģ�y���꣬���������ײ
	LP dd ? ;����ֵ��Ҳ����ʶ��
	Speed dd ? ;�����ƶ����ٶ�
	MoveTime dd ? ;��һ��λ�Ƶ�ʱ��
	StayTime dd ? ;�˶�һ��ʱ���ͣ����ʱ��
	EType dd ?	;���ͣ�0Ϊɢ����1Ϊ�ص�
	nextShoot dd ? ;
	shootInterval dd ? ;�������
	BulletType dd ?
ENEMY ends

;�о��ӵ��ṹ
EBULLET struct
	x dd ? ;����
	y dd ?
	center_x dd ? ;�������꣬�����ײ��
	center_y dd ?
	radius dd ? ;���Ǽ�����Բ��
	disp_x dd ? ;x����ÿʱ��λ��
	disp_y dd ? ;y����ÿʱ��λ��
	damage dd ? ;�˺�
	flag dd ? ;��Ч�Լ��
	EBType dd ? ;����
EBULLET ends

;�����ṹ
BACKGROUND struct
	firx dd ?;��һ��ͼƬ��x����
	firy dd ? ;��һ��ͼƬ��y����
	firw dd ? ;��һ��ͼƬ�Ŀ�
	firh dd ? ;��һ��ͼƬ�ĸ�
	secx dd ?;�ڶ���ͼƬ��x����
	secy dd ? ;�ڶ���ͼƬ��y����
	secw dd ? ;�ڶ���ͼƬ�Ŀ�
	sech dd ? ;�ڶ���ͼƬ�ĸ�	
BACKGROUND ends

;��ʼ������
;<>������Ǵ���ṹ��ĳ�ʼ��
background BACKGROUND <?,?,?,?,?,?,?,?>;����
hInstance dword ? ;����ľ��
hWinMain dword ?;����ľ��
MyWinClass byte 'MyWinClass',0;ע�ᴰ��ʱ�õ�����
WinTitle byte 'Space Invader',0;�������Ͻǵı���
player PLAYER <> 
wingmans PLAYER <>,<>

boards BOARD MAXSIZE dup(<0,0,0,0,0,0,0>);�����洢����
boardCount dword 0;��¼���ӵ�����

LifeBag LBAG <0, 0, 0, 0, 0, 0, 0>	; �����洢Ѫ��
LifeBagCount dword 0;	��¼��ǰѪ����������ȡֵֻ������0��1��

iteams ITEAM 4096 dup(<?,?,?,?,?,?>);�����洢λͼ
iteamCount dword 0		;iteams����λͼ������

pBullet PBULLET MAXSIZE dup(<0,0,0,0,0,0,0>) ;�Լ��ӵ�
pBulletCount dword 0;

eBullet EBULLET 200 dup(<0,0,0,0,0,0,0,0,0>) ;�л��ӵ�
eBulletCount dword 0;

enemy ENEMY MAXSIZE dup(<0,0,0,0,0,0,0,0,0,0,0,0,0,0>) ;����
enemyCount dword 0;

stRect RECT <0,0,0,0>;�ͻ����ڵĴ�С��right������bottom�����

PaintFlag dword ?;��������WM_PAINT����Ҫ����һһ������

timer dd 0		; ��ʱ��������ˢ�²����л�

EnemyInterval dword 180 ;���˵�ˢ��Ƶ��
UpgradeDifficult dword 0	; ��Ϸ�Ѷ�������flag�����ҽ�����Ϸ�÷�ʮλ����λ���Ѷ�����

LifeBagInterval dword 500	; Ѫ����ˢ��Ƶ�ʣ���ʼ�趨Ϊ500
LifeBagTimer dword 0		; Ѫ���ļ�ʱ��

Big1StartTime dword 0	; ����1����յ�����ʼ��ʱ��
Big3StartTime dword 0   ; ����3 ��ʹ���Ż�����ʼ��ʱ��

;ayk���
;----------------------------------------------------------------
generate_flag dword 1	;�����Ƿ��������µ�С�л���ľ�壬����boss��flag��Ϊ0
;-----------------------------------------------------------------

;λͼ��ָ��
hStartButton dword ? ;��ʼ��Ϸ��ť
hExitButton dword ? ;�˳���Ϸ��ť
hContinueButton dword ? ;������Ϸ��ť
hRestartButton dword ? ;���¿�ʼ��ť

hMenumask dword ?
hback dword ?;1 ����ͼƬ

hEnemy0 dword ?;���˵�ͼƬ
hEnemyMask0 dword ?
hEnemy1 dword ?;���˵�ͼƬ
hEnemyMask1 dword ?

hEnergyPlot dword ?	; ������
hEnergyPlotMask dword ?

hLifeBag dword ?	; Ѫ��
hLifeBagMask dword ?

hBuddha dword ?		; ����1����յ�
hBuddhaBlack dword ?	; ����1 ��ȴ�ڼ�
hBuddhaMask dword ?	; ���е�mask
hCheckAndRepair dword ?	; ����2���Լ��޸�
hCheckAndRepairBlack dword ? ; ����2 ��ȴ�ڼ�
hWingmans dword ? ;�Ż���ͼƬ
hWingmansMask dword ? ;����3 mask
hWingmanButton dword ? ;����3 �Ż���ť
hWingmanButtonBlack dword ? ;����3 ��ȴʱ��
hWingmanButtonMask dword ? ; �Ż���ť����

hPlayerNormal0 dword ?;��������ʱ���ͼƬ
hPlayerNormalMask0 dword ?
hPlayerRight0 dword ?;��������ʱ���ͼƬ
hPlayerRightMask0 dword ?
hPlayerLeft0 dword ?;��������ʱ���ͼƬ
hPlayerLeftMask0 dword ?
hPlayerUp0 dword ?;��������ʱ���ͼƬ
hPlayerUpMask0 dword ?
hPlayerDown0 dword ?;��������ʱ���ͼƬ
hPlayerDownMask0 dword ?

hBoard dword ? ;���ӵ�ͼƬ
hBoardmask dword ?

hPBullet0 dword ?;�Լ����ӵ�0
hPBullet0mask dword ?
hPBullet1 dword ?; �Լ����ӵ�1����յ���
hPBullet1mask dword ?

hEBullet0 dword ?;���˵��ӵ�0
hEBullet0mask dword ?

hEBullet1 dword ?;���˵��ӵ�1
hEBullet1mask dword ?

hEnemy dword ?;����
hStopButton dword ?;��ͣ��ť
hReturnButton dword ?;���ذ�ť
hHeart dword ?;����ֵ
hHeartMask dword ?;����ֵ
hButtonMask dword ?;��ť����
hHelpButton dword ?;������ť
hHelp dword ?;����
hHelpMask dword ?;��������
;----------------------------------------------------------------------------------
hEnemyHealth dword ?;����Ѫ��
hBoss dword ?;boss
hBossMask dword ?;boss����
hVictory dword ?;ʤ������
hVictoryMask dword ?;ʤ����������
;----------------------------------------------------------------------------------

; ����0-9
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
;��������
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

; �÷� ���￼������λ��ʾ
MyScore_ten dword 0
MyScore_one dword 0
MAX_ENERGY equ 3
boss_thre equ 2
slot_width equ 60
;---------------------------------------------------------------------------------
; by ֣�ӷ�:
; ���ǵ����ֱ��LoadImage�Ļ��޷���������exe�ļ������ǰ�source�ļ��к�exe�ļ�����ͬһ���ļ�����
; ���������ҿ��ǽ�����LoadImage�滻��LoadBitmap����������Ҫ��������λͼ��Դ��ID
; ��������ٽ��и��ĵ�ʱ�����λͼ���뵽�����Ŀ����Դ�⣬��ͨ��LoadBitmap���м���
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
;@Description   :  ����Ϸ��ʼ��ʱ�򣬽�����λͼ���ص��ڴ�
;@Author        :  ������
;--------------------------------------------------------------------------------------
LoadBitImage proc	uses eax ebx ecx edx esi edi 
	;������Ҫ�õ���ͼƬ
	;����ֵ��������ݵľ��
	;���а�ť
	
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

	;����ͼƬ
	invoke LoadBitmap, hInstance, IDB_help
	mov hHelp,eax

	invoke LoadBitmap, hInstance, IDB_helpmask
	mov hHelpMask,eax

;----------------------------------------------------------------------------------
	;����Ѫ��
	invoke LoadBitmap, hInstance, IDB_enemy_health
	mov hEnemyHealth,eax

	;boss�Լ�ʤ������
	invoke LoadBitmap, hInstance, IDB_boss
	mov hBoss, eax

	invoke LoadBitmap, hInstance, IDB_boss_mask
	mov hBossMask, eax

	invoke LoadBitmap, hInstance, IDB_victory
	mov hVictory, eax

	invoke LoadBitmap, hInstance, IDB_victory_mask
	mov hVictoryMask, eax
;----------------------------------------------------------------------------------

	;����
	;invoke LoadImage,hInstance,offset back,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_BACK
	mov hback, eax

	; ������
	;invoke LoadImage,hInstance,offset ENERGYPLOT,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_EnergyPlot
	mov hEnergyPlot, eax
	;invoke LoadImage,hInstance,offset ENERGYPLOTMASK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_EnergyPlotmask
	mov hEnergyPlotMask, eax

	; Ѫ��
	;invoke LoadImage,hInstance,offset LIFEBAG, IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_LifeBag
	mov hLifeBag, eax
	;invoke LoadImage,hInstance,offset LIFEBAGMASK, IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_LifeBagmask
	mov hLifeBagMask, eax
	
	; ����1����յ�
	;invoke LoadImage,hInstance,offset BUDDHA,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_Buddha
	mov hBuddha, eax
	;invoke LoadImage,hInstance,offset BUDDHAMASK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_Buddhamask
	mov hBuddhaMask, eax
	;invoke LoadImage,hInstance,offset BUDDHABLACK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_BuddhaBlack
	mov hBuddhaBlack, eax

	; ����2���Լ��޸�
	;invoke LoadImage,hInstance,offset CHECKANDREPAIR,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_CheckAndRepair
	mov hCheckAndRepair, eax
	;invoke LoadImage,hInstance,offset CHECKANDREPAIRBLACK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_CheckAndRepairBlack
	mov hCheckAndRepairBlack, eax

	; ����3���Ż����Ż���ť
	invoke LoadBitmap, hInstance, IDB_wingman_button
	mov hWingmanButton, eax
	invoke LoadBitmap, hInstance, IDB_wingmanMask
	mov hWingmansMask, eax
	invoke LoadBitmap, hInstance, IDB_wingman_buttonBlack
	mov hWingmanButtonBlack, eax

	; �÷� ����0-9
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

	;���˵�ͼƬ
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

	;����ͼƬ
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

	;�Ż�ͼƬ
	invoke LoadBitmap, hInstance, IDB_wingman
	mov hWingmans, eax
	
	;����
	;invoke LoadImage,hInstance,offset BOARDPIC,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_board
	mov hBoard,eax
	;invoke LoadImage,hInstance,offset BOARDMASK,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_boardmask
	mov hBoardmask,eax
	
	;�Լ����ӵ�
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
	
	;���˵��ӵ�
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

	;����ֵ
	;invoke LoadImage, hInstance, offset HEART, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_heart
	mov hHeart,eax
	;invoke LoadImage, hInstance, offset HEARTMASK, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	invoke LoadBitmap, hInstance, IDB_heartmask
	mov hHeartMask,eax

	;������ͣ��ť
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
;@Param			:  left.right��ʾҪȡ��������ķ�Χ			
;@Description   :  ����һ����Χ֮�����������洢��eax����
;@Author        :  ������
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
;@Description   :  ��ʼ����Ϸ����
;@Author        :  ������
;--------------------------------------------------------------------------------------
InitBackGround proc uses eax ebx ecx edx esi edi
	
	;��һ��ͼƬ��λ��
	mov background.firx,0
	mov background.firy,0
	mov eax,stRect.right
	mov background.firw,eax
	mov eax,stRect.bottom
	mov background.firh,eax

	;�ڶ���ͼƬ��λ��
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
;@Description   :  �ñ���ͼƬ�����ƶ�
;@Author        :  ������
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
;@Param			:  λͼ��ָ�룬x���꣬y���꣬w��ȣ�h�߶ȣ�flag��ʾ��ʽ��SRCCOPY��					
;@Description   :  ��λͼ��Ϣ�洢��iteams���鵱�У�֮����display��������չʾ
;@Author        :  ������
;--------------------------------------------------------------------------------------
store proc uses eax ebx ecx edx esi edi hbitmap:dword,x:dword,y:dword,w:dword,h:dword,flag:dword
	mov eax,iteamCount
	mov edi ,offset iteams
	mov ebx,TYPE ITEAM
	mul ebx
	add edi,eax;��ʱedi���д洢���Ƕ�Ӧiteams�ĵ�ַ
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
;@Description   :  ��iteams�����д洢��λͼȫ��չʾ��������ȥ������˫��������չʾ��֮�󣬽������iteams����
;@Author        :  ������
;--------------------------------------------------------------------------------------
display proc uses eax ebx ecx edx esi edi
	LOCAL paint:PAINTSTRUCT
	LOCAL hdc:dword ;��Ļ��hdc
	LOCAL hdc1:dword;������1
	LOCAL hdc2:dword;������2
	LOCAL hbitmap:dword
	LOCAL @bminfo :BITMAP
	invoke BeginPaint, hWinMain, addr paint
	mov hdc,eax

	invoke CreateCompatibleDC,hdc
	mov hdc1,eax

	invoke CreateCompatibleDC,hdc1
	mov hdc2,eax
	;�ⲿ���൱�ڸ��ߵ��ԣ�������1�Ĵ�С
	invoke CreateCompatibleBitmap,hdc,stRect.right,stRect.bottom
	mov hbitmap,eax
	
	invoke SelectObject,hdc1,hbitmap
	;���óɿɱ�
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

	;��������1�����ݸ��Ƶ�������
	invoke StretchBlt,hdc,0,0,stRect.right,stRect.bottom,hdc1,0,0,stRect.right,stRect.bottom,SRCCOPY

	;ɾ��ָ��
	invoke DeleteDC,hbitmap
	invoke DeleteDC,hdc2
	invoke DeleteDC,hdc1
	invoke DeleteDC,hdc
	invoke EndPaint,hWinMain,addr paint
	;���iteams����
	mov iteamCount,0
	ret
display endp

;--------------------------------------------------------------------------------------
;@Function Name :  shootPBullet
;@Param			:  	
;@Description   :  ���¿ո��ʱ�����ӵ�	
;@Author        :  ������
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
;@Description   :  ���յз��ɻ�	
;@Author        :  ������
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
	mov esi, offset enemy	; esi ͷ
	mov edi, offset enemy	; edi β
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
;@Description   :	���յз������ӵ����������飬 ���κεз��ӵ���ʧ�Ժ����
;@Author        :   ������
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
;@Description   :	������ҷ����ӵ����������飬 ���κ��ӵ���ʧ�Ժ����
;@Author        :   ������
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
;@Description   :  �����Լ����ӵ�������
;@Author        :  ������
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
;@Description   :  ���µз��ӵ�
;@Author        :  ������
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
			.if ebx == 1	; �����1ʽ�ӵ����ص���������Ϸ�÷�>=5����������
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
;@Description   :  ���µз�
;@Author        :  ������
;--------------------------------------------------------------------------------------
UpdateEnemy proc uses eax ebx ecx edx esi edi
	mov esi, offset enemy
	xor ecx, ecx
	.while ecx < enemyCount
	;-------------------------------------------����boss���е�������
		mov eax, (ENEMY PTR[esi]).EType
		cmp eax,2
		je boss
		;------------------------------------
		mov eax, (ENEMY PTR[esi]).MoveTime
		.if eax > 0;�ս�����Ļ��Ҫ����һ��ʱ��
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
		.else;����ʱ���������ֹһ��ʱ�䲢�����ӵ�
			mov eax, (ENEMY PTR[esi]).StayTime
			.if eax > 0
				dec (ENEMY PTR[esi]).StayTime
			.else;��ֹʱ�������һֱ��ǰ����ֱ���ɳ���Ļ
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
	boss:		;bossֻ�е�һ�ε��ƶ�����ֹ�����ƶ���һֱ���������ֱ��������
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
			mov PaintFlag, 6			;boss���������ʤ������
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
;@Description   :	�ڴ���3�ͷ�ʱ�������Ż�
;@Author        :   ����
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
;@Param			:  wParam�����ж����ĸ�����������	
;@Description   :  ִ�зɻ����ƶ�  
;@Author        :  ������
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
	.elseif wParam==VK_SPACE	;�ո�� �����ӵ�
		mov player.LeftCount,0
		mov player.RightCount,0
		mov player.UpCount,0
		mov player.DownCount,0
		invoke shootPBullet
	.elseif wParam == VK_1		; ����1�� ʹ�á���յ�������
		.if player.EnergyLevel == MAX_ENERGY
			mov player.Big1, 1
			mov player.EnergyLevel, 0
			INVOKE GetTickCount
			mov Big1StartTime, eax
		.endif
	.elseif wParam == VK_2		; ����2�� ʹ�á��Լ��޸�������
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
;@Description   :	����Ϸ��ʼ��ʱ�򣬳�ʼ���������Ϣ
;@Author        :   ������
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
;@Description   :  ����Ϸ��ʼ��ʱ�򣬳�ʼ�����ӵ���Ϣ
;@Author        :  ������
;--------------------------------------------------------------------------------------
InitBoard proc uses eax ebx ecx edx esi edi
	LOCAL pos_x:dword ;�ϸ�����x��λ��
	LOCAL left:dword
	LOCAL right:dword
	mov pos_x,300 
	mov boardCount,0
	;����һ�µ��˵������ٶ�
	
	mov EnemyInterval, 150	; ��ʼ�ĵ���ˢ��Ƶ�����ó�150
	mov eax, EnemyInterval
	mov timer, eax			; ��ʼ���л����ɼ�ʱ��Timer

	mov left, 500
	mov right, 800
	invoke generateRandNum, left, right
	mov LifeBagInterval, eax	; ��ʼ��Ѫ��ˢ��ʱ��
	mov LifeBagTimer, 0
	; ��ʼ��Ѫ���ṹ����Ϣ
	mov edi, offset LifeBag
	mov (LBAG PTR [edi]).x, 0
	mov (LBAG PTR [edi]).y, 0
	mov (LBAG PTR [edi]).w, 0
	mov (LBAG PTR [edi]).h, 0
	mov (LBAG PTR [edi]).flag, 0
	mov (LBAG PTR [edi]).center_x, 0
	mov (LBAG PTR [edi]).center_y, 0


	mov MyScore_ten, 0	; ��ʼ����ҵ÷�
	mov MyScore_one, 0
	
	; ����һЩ����ȫ��������ֵ
	mov UpgradeDifficult, 0	; �Ѷ�����flag = false

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
;@Description   :	����ʱ�������źź󣬸��°��ӵ�λ�ã��ð��ӹ̶���ǰ�ƶ�
;@Author        :   ������
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
	.if eax == 0	; ��ǰ������û��Ѫ��
		ret
	.endif

	;����λ��
	sub (LBAG PTR [edi]).x, 2
	sub (LBAG PTR [edi]).center_x, 2

	ret
UpdateLifeBag endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateEnemy;
;@Param			:  	
;@Description   :  ��������	
;@Author        :  ������
;--------------------------------------------------------------------------------------
generateEnemy proc uses eax ebx ecx edx esi edi
	mov eax, enemyCount
	mov esi, offset enemy
	xor edx, edx
	mov ebx, TYPE ENEMY
	mul ebx
	add esi, eax
	;���� esi ָ�������µĵ���
	;-----------------------------------------
	;����Ƿ�Ҫ�����µĵл�
	cmp generate_flag, 1;
	jne endL
	;cmp MyScore_ten,1			;����ʱ����1��Ϊ��׼
	cmp MyScore_ten, boss_thre
	je boss
	;-----------------------------------------�����ﵽһ��Ҫ�������boss
	mov (ENEMY PTR[esi]).x, 850
	invoke generateRandNum, 20, 500
	mov (ENEMY PTR[esi]).y, eax
	;�������λ��
	invoke generateRandNum, 0, 2
	.if eax == 0 ;0ʽ��Ѫ���ϸߣ�����˷������ӵ�
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
	.elseif eax == 1 ;1ʽ��Ѫ���ϵͣ�׷����ҷ����ӵ�
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
	mov (ENEMY PTR[esi]).shootInterval, 15	;boss������ֶδ洢��һ�η�������������Ĵ���
	mov (ENEMY PTR[esi]).nextShoot, 20		;��һ�������ʱ��
	mov (ENEMY PTR[esi]).BulletType, 0		;��ȷ��
	mov generate_flag, 0
	inc enemyCount
endL:
;---------------------------------------------------------------------
	ret
generateEnemy endp

;--------------------------------------------------------------------------------------
;@Function Name :  generateLifeBag
;@Param			:  	
;@Description   :  ����Ѫ��	
;@Author        :  
;--------------------------------------------------------------------------------------
generateLifeBag proc uses eax ebx ecx edx esi edi
	LOCAL left: dword
	LOCAL right: dword
	mov edi, offset LifeBag		; ��������Ѿ�����Ѫ�������ٷ��µģ�����������1����
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 1
		ret
	.endif

	; ������Ѫ��
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
;@Param			:  EBULLET�ṹ�����������
;@Description   :  ����һ���з��ӵ�	
;@Author        :  ������
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
;@Param			:  EBULLET�ṹ�����������
;@Description   :  �����з��ӵ���һ�����֣�
;@Author        :  ������
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
						invoke generateOneEBullet, locate_x, locate_y, 15, -10, 0, 1, BulletType ;�ҷ�
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
						invoke generateOneEBullet, locate_x, locate_y, 20, dire_x, dire_y, 2, BulletType ;��׼
					;------------------------------------------------------------------------------------
					.elseif eax == 2;	boss
						mov ebx, locate_x
						add ebx, 120
						mov locate_x, ebx
						mov ebx, locate_y
						add ebx, 10
						mov locate_y, ebx
						.if BulletType == 0	;BOSS�����ɢ����20ö
							invoke generateOneEBullet, locate_x, locate_y, 15, -10, 0, 1, BulletType ;�ҷ�
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
							invoke generateOneEBullet, locate_x, locate_y, 20, dire_x, dire_y, 2, BulletType ;��׼
						;---------------------------------------------------------------	
						.elseif BulletType == 2		;BOSS��ɢ���͵����Ի�ϵķ�ʽ���з���
							invoke generateOneEBullet, locate_x, locate_y, 15, -10, 0, 1, 0 ;�ҷ�
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
							invoke generateOneEBullet, locate_x, locate_y, 20, dire_x, dire_y, 2, 1 ;��׼
							;----------------------------------------------------------------
						.endif

						mov eax, (ENEMY PTR[edi]).shootInterval
						.if eax == 0
							invoke generateRandNum, 20, 30	;���ȷ�����ж೤ʱ�������һ�ֹ���
							mov (ENEMY PTR[edi]).nextShoot, eax
							mov (ENEMY PTR[edi]).shootInterval, 10
							;������������һ��֮�����ȷ����һ�ֵ��ӵ�����
							invoke generateRandNum, 0, 3
							mov (ENEMY PTR[edi]).BulletType, eax
						.else
							.if BulletType == 2		;��ͬ����ģʽ�����ٲ�ͬ������ƽ����Ϸ�Ѷ�
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
;@Description   :	����ҷ��ӵ��Ƿ����У������ӵ�
;@Author        :  ������
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
				;�ж�һ�°����Ƿ���Ч
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
									.if eax == 1		; ����ǽ�յ������ӱ�"��յ�"������ʧ
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
;@Description   :	������ײ��⣬����Ƿ�ײ���˰��ӣ���ײ����ֱ������
;@Author        :   ������
;--------------------------------------------------------------------------------------
CheckCollision proc uses eax ebx ecx edx esi edi
	;Ӧ�ü�������������������ȥ���,

	mov eax,player.w ;eax���д洢�������������x����
	shr eax,1;
	add eax,player.x
	mov player.center_x,eax

	mov ebx,player.h ;ebx���д洢�������������y����
	shr ebx,1;
	add ebx,player.y
	mov player.center_y,ebx

	;����Ƿ���ײ���˰���
	mov esi,0
	mov edi,offset boards
	.while esi<boardCount
		mov eax,(BOARD PTR [edi]).flag
		.if eax==1
			mov eax,player.w ;eax,�洢���൱��max_x
			add eax,(BOARD PTR [edi]).w 
			shr eax,1
			sub eax,10 ;�����ȥ5�൱���Ǽ�����ײ���ķ�Χ���������ױ���⵽

			mov ebx,player.h;ebx�洢���൱��max_y
			add ebx,(BOARD PTR [edi]).h
			shr ebx,1
			sub ebx,10
			mov ecx,(BOARD PTR [edi]).center_x;�����x����
			mov edx,(BOARD PTR [edi]).center_y;�����y����
			sub ecx,player.center_x ;x-x
			sub edx,player.center_y	;y-y
			cmp ecx,eax
			jg label1
			add ecx,eax ;ecx����eax֮�����Ҫ��С��0��ô����ζ�����ľ����Ǹ��������Һܴ�
			cmp ecx,0
			jl label1

			cmp edx,ebx
			jg label1
			add edx,ebx
			cmp edx,0
			jl label1
			mov PaintFlag,2 ;��������
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
;@Description   :	���ɻ��Ƿ�ʰȡ��Ѫ��
;@Author        :   
;--------------------------------------------------------------------------------------
CheckGetLifeBag proc uses eax ebx ecx edx esi edi
	mov edi, offset LifeBag
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 0	; û��Ѫ��
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

	; ʰȡ�ɹ�
	mov player.Big2, 1	; ����2��flagΪtrue
	mov edi, offset LifeBag
	mov (LBAG PTR [edi]).flag, 0	; Ѫ����ʰȡ ��ʧ

	ret
CheckGetLifeBag endp

;--------------------------------------------------------------------------------------
;@Function Name :   CheckEPCollision;
;@Param			:  
;@Description   :	�Ի��͵л�����ײ��⣬ײ���л���ֱ������
;@Author        :   ������
;--------------------------------------------------------------------------------------
CheckEPCollision proc uses eax ebx ecx edx esi edi
	;Ӧ�ü�������������������ȥ���,

	mov eax,player.w ;eax���д洢�������������x����
	shr eax,1;
	add eax,player.x
	mov player.center_x,eax

	mov ebx,player.h ;ebx���д洢�������������y����
	shr ebx,1;
	add ebx,player.y
	mov player.center_y,ebx

	;����Ƿ���ײ���˵���
	mov esi,0
	mov edi,offset enemy
	.while esi<enemyCount
		mov eax,(ENEMY PTR [edi]).LP
		.if eax > 0
			mov eax,player.w ;eax,�洢���൱��max_x
			add eax,(ENEMY PTR [edi]).w 
			shr eax,1
			sub eax,10 ;�����ȥ5�൱���Ǽ�����ײ���ķ�Χ���������ױ���⵽

			mov ebx,player.h;ebx�洢���൱��max_y
			add ebx,(ENEMY PTR [edi]).h
			shr ebx,1
			sub ebx,10
			mov ecx,(ENEMY PTR [edi]).center_x;�����x����
			mov edx,(ENEMY PTR [edi]).center_y;�����y����
			sub ecx,player.center_x ;x-x
			sub edx,player.center_y	;y-y
			cmp ecx,eax
			jg label2
			add ecx,eax ;ecx����eax֮�����Ҫ��С��0��ô����ζ�����ľ����Ǹ��������Һܴ�
			cmp ecx,0
			jl label2

			cmp edx,ebx
			jg label2
			add edx,ebx
			cmp edx,0
			jl label2
			mov PaintFlag,2 ;��������
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
;@Description   :	��ײ�л��ӵ���⣬������������п۳���Ӧ����ֵ��׷���ӵ�����Ѫ��ɢ��һ��Ѫ��
;@Author        :   ������
;--------------------------------------------------------------------------------------
CheckEBCollision proc uses eax ebx ecx edx esi edi
	;Ӧ�ü�������������������ȥ���,
	mov eax,player.w ;eax���д洢�������������x����
	shr eax,1;
	add eax,player.x
	mov player.center_x,eax

	mov ebx,player.h ;ebx���д洢�������������y����
	shr ebx,1;
	add ebx,player.y
	mov player.center_y,ebx

	;����Ƿ���ײ�����ӵ�
	mov esi,0
	mov edi,offset eBullet
	.while esi<eBulletCount
		mov eax,(EBULLET PTR [edi]).flag
		.if eax > 0
			mov eax,player.w ;eax,�洢���൱��max_x
			add eax,(EBULLET PTR [edi]).radius 
			shr eax,1
			sub eax,10 ;�����ȥ5�൱���Ǽ�����ײ���ķ�Χ���������ױ���⵽

			mov ebx,player.h;ebx�洢���൱��max_y
			add ebx,(EBULLET PTR [edi]).radius
			shr ebx,1
			sub ebx,10
			mov ecx,(EBULLET PTR [edi]).center_x;�����x����
			mov edx,(EBULLET PTR [edi]).center_y;�����y����
			sub ecx,player.center_x ;x-x
			sub edx,player.center_y	;y-y
			cmp ecx,eax
			jg label3
			add ecx,eax ;ecx����eax֮�����Ҫ��С��0��ô����ζ�����ľ����Ǹ��������Һܴ�
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
;@Description   :	�ӵ����ел���ײ��⣬�������ӵ����ез����Կ۳��з���Ӧ��Ѫ��
;@Author        :   ������
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
				;�жϵ����Ƿ���Ч
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
;@Description   :	���´��������Ϣ
;@Author        :   
;--------------------------------------------------------------------------------------
UpdateUlt proc uses eax ebx ecx edx esi edi
	LOCAL NowTime : dword	; ��ǰʱ��
	invoke GetTickCount
	mov NowTime, eax
	mov ebx, eax
	sub ebx, Big1StartTime
	.if ebx >= 10000	; �����10s�ˣ�����յ���ʧЧ
		mov player.Big1, 0
	.endif
	mov ebx, eax
		sub ebx, Big3StartTime
	.if ebx >= 10000	; �����10s�ˣ��Ż��ӳ�ʧЧ
		mov player.Big3, 0
	.endif
	ret
UpdateUlt endp

;--------------------------------------------------------------------------------------
;@Function Name :   UpdateOtherData
;@Param			:  
;@Description   :	��������һЩ����û�и��µ�����
;@Author        :   
;--------------------------------------------------------------------------------------
UpdateOtherData proc uses eax ebx ecx edx esi edi
	; ���µ÷ֵ�ʮλ����λ
	.if MyScore_one > 9
		mov eax, MyScore_one
		sub eax, 10
		add MyScore_ten, 1
		mov MyScore_one, eax
		mov UpgradeDifficult, 1
	.endif
	.if UpgradeDifficult == 1	; �����ǰ��Ϸ������flag = 1���ӿ����ˢ��Ƶ��
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
;@Description   :	���ƿ�ʼ�˵�������
;@Author        :   ������
;--------------------------------------------------------------------------------------
Paint_0 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword ;
	;���ر���ͼƬ
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY
	
    ;��ʼ����Ŀǰ��һ����ʼ��Ϸһ���˳���Ϸ
	;�������������Լ�һ����Ϸ���ܹ��ܣ������ˣ��������
	invoke store,hMenumask ,280,125,200,100,SRCAND
	invoke store,hStartButton ,280,125,200,100,SRCPAINT

	invoke store,hMenumask ,280,300,200,100,SRCAND
	invoke store,hExitButton,280,300,200,100,SRCPAINT
	
	;������ť
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hHelpButton,700,0,75,75,SRCPAINT
	ret
Paint_0 endp
;--------------------------------------------------------------------------------------
;@Function Name :   Paint_1
;@Param			:  
;@Description   :	������Ϸ�ڽ���
;@Author        :   ������
;--------------------------------------------------------------------------------------
Paint_1 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	;���ر���ͼƬ
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY

	; ����Ѫ��
	mov edi, offset LifeBag
	mov eax, (LBAG PTR [edi]).flag
	.if eax == 1
		invoke store, hLifeBagMask, (LBAG PTR [edi]).x, (LBAG PTR [edi]).y, (LBAG PTR [edi]).w, (LBAG PTR [edi]).h, SRCAND
		invoke store, hLifeBag, (LBAG PTR [edi]).x, (LBAG PTR [edi]).y, (LBAG PTR [edi]).w, (LBAG PTR [edi]).h, SRCPAINT
	.endif
	
	;�����Լ�
	.IF player.IMAGE_FLAG==0
		invoke store,hPlayerNormalMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerNormal0,player.x,player.y,player.w,player.h,SRCPAINT
	.ELSEIF player.IMAGE_FLAG==1
		invoke store,hPlayerRightMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerRight0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;������û�б����µ�ʱ��Ҫ��ԭͼƬ����ǰ����
	.ELSEIF player.IMAGE_FLAG==2
		invoke store,hPlayerLeftMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerLeft0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;������û�б����µ�ʱ��Ҫ��ԭͼƬ����ǰ����
	.ELSEIF player.IMAGE_FLAG==3
		invoke store,hPlayerUpMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerUp0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;������û�б����µ�ʱ��Ҫ��ԭͼƬ����ǰ����
	.ELSEIF player.IMAGE_FLAG==4
		invoke store,hPlayerDownMask0,player.x,player.y,player.w,player.h,SRCAND
		invoke store,hPlayerDown0,player.x,player.y,player.w,player.h,SRCPAINT
		mov player.IMAGE_FLAG,0 ;������û�б����µ�ʱ��Ҫ��ԭͼƬ����ǰ����
	.ENDIF

		;�����Ż�
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
	
	;���ذ���
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

	;����˫���ӵ�
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

	;���ص��˺�Ѫ��		��edx��ecx��eax
	xor esi, esi
	mov edi, offset enemy
	.while esi < enemyCount
		mov eax, (ENEMY PTR[edi]).LP
		.if eax > 0
			mov ebx,(ENEMY PTR[edi]).EType ;��ͬ�ĵ��˻���ز�ͬ��ͼƬ
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

	;���ط��غ���ͣ��ť
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hReturnButton,700,0,75,75,SRCPAINT

	invoke store,hButtonMask,625,0,75,75,SRCAND
	invoke store,hStopButton,625,0,75,75,SRCPAINT

	;������ť
	invoke store,hButtonMask,550,0,75,75,SRCAND
	invoke store,hHelpButton,550,0,75,75,SRCPAINT

	; ����������
	mov ecx, 350
	mov esi, 0
	.while esi < player.EnergyLevel
		invoke store, hEnergyPlotMask, ecx, 17, slot_width, 20, SRCAND
		invoke store, hEnergyPlot, ecx, 17, slot_width, 20, SRCPAINT
		add ecx, slot_width
		inc esi
	.endw
	
	;��������ֵ
	mov ecx,10
	mov esi,0
	.while esi<player.HP
		invoke store,hHeartMask,ecx,10,40,40,SRCAND
		invoke store,hHeart,ecx,10,40,40,SRCPAINT
		add ecx,45
		inc esi
	.endw
	
	; ���ش���1��־
	invoke store, hBuddhaMask, 160, 0, 50, 50, SRCAND
	.if player.EnergyLevel == MAX_ENERGY
		invoke store, hBuddha, 160, 0, 50, 50, SRCPAINT
	.else
		invoke store, hBuddhaBlack, 160, 0, 50, 50, SRCPAINT
	.endif
	
	; ���ش���2��־
	invoke store, hBuddhaMask, 210, 0, 50, 50, SRCAND
	.if player.Big2 == 1
		invoke store, hCheckAndRepair, 210, 0, 50, 50, SRCPAINT
	.else
		invoke store, hCheckAndRepairBlack, 210, 0, 50, 50, SRCPAINT
	.endif
	; ���ش���3��־
	invoke store, hBuddhaMask, 260, 0, 50, 50, SRCAND
	.if player.EnergyLevel == MAX_ENERGY
		invoke store, hWingmanButton, 260, 0, 50, 50, SRCPAINT
	.else
		invoke store, hWingmanButtonBlack, 260, 0, 50, 50, SRCPAINT
	.endif

	; ���ص÷�
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

	;չʾ
	;invoke display
	ret
Paint_1 endp

;--------------------------------------------------------------------------------------
;@Function Name :   Paint_2
;@Param			:  
;@Description   :	��������,�ڻ��ƺ���Ϸ����Ļ���������һ���������˵�
;@Author        :   ������
;--------------------------------------------------------------------------------------
Paint_2 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke Paint_1
	;�ڴ˻����ϣ���Ҫ���뷵�ؽ���
	invoke store,hMenumask,280,200,200,100,SRCAND
	invoke store,hRestartButton,280,200,200,100,SRCPAINT
	ret
Paint_2 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_3
;@Param			:  
;@Description   :  ��ͣ��Ϸ,�ڻ��ƺ���Ϸ����Ļ���������һ��������Ϸ
;@Author        :  ������
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
;@Description   :  �鿴��Ϸ�������ӿ�ʼ������룩
;@Author        :  �����
;--------------------------------------------------------------------------------------
Paint_4 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY

	;���뷵�ذ�ť
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hReturnButton,700,0,75,75,SRCPAINT

	;�����������
	invoke store,hHelpMask,130,80,520,407,SRCAND
	invoke store,hHelp,130,80,520,407,SRCPAINT

	ret
Paint_4 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_5
;@Param			:  
;@Description   :  �鿴��Ϸ����������Ϸ������룩
;@Author        :  �����
;--------------------------------------------------------------------------------------
Paint_5 proc uses eax ebx ecx edx esi edi
	LOCAL hbitmap:dword
	invoke store,hback,background.firx,0,stRect.right,stRect.bottom,SRCCOPY
	invoke store,hback,background.secx,0,stRect.right,stRect.bottom,SRCCOPY

	;���뷵�ذ�ť
	invoke store,hButtonMask,700,0,75,75,SRCAND
	invoke store,hReturnButton,700,0,75,75,SRCPAINT

	;�����������
	invoke store,hHelpMask,130,80,520,407,SRCAND
	invoke store,hHelp,130,80,520,407,SRCPAINT

	ret
Paint_5 endp

;--------------------------------------------------------------------------------------
;@Function Name :  Paint_6
;@Param			:  
;@Description   :  ����boss����ʾʤ������
;@Author        :  �����
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
;@Description   :  ������ƣ����ڵ���������������ƺ���
;@Author        :  ������
;--------------------------------------------------------------------------------------
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
	LOCAL @posX:dword ;����λ��
	LOCAL @posY:dword ;����λ��
	.if  uMsg==	WM_CREATE
		invoke LoadBitImage ;����ͼƬ��λͼ
		invoke	GetClientRect,hWnd,addr stRect ;��ȡ�ͻ�����Ĵ�С
		invoke InitBackGround
		mov PaintFlag,0 ;����Ȼ���������
		invoke SetTimer,hWnd,1,freshTime,NULL ;������ʱ�������Ϊ1
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

		.if PaintFlag==0 ;��ʱ��������
			.IF @posX>280 && @posX<480 && @posY>125 && @posY<225 ;������˿�ʼ��Ϸ
				invoke RtlZeroMemory, offset player, TYPE PLAYER
				;���ݳ�ʼ��
				mov pBulletCount, 0
				mov eBulletCount, 0
				mov enemyCount, 0
				mov MyScore_one, 0
				mov MyScore_ten, 0
				mov generate_flag, 1

				invoke InitBackGround;��ʼ������
				invoke InitPlayer, 0, 0 ;��ʼ������
				invoke InitBoard ;��ʼ������
				mov PaintFlag,1
				invoke InvalidateRect,hWnd,NULL,FALSE

			.elseif @posX>280 && @posX<480 && @posY>300 && @posY<400 ;������˽�����Ϸ
				;ֱ�ӵ������ټ���
				invoke	DestroyWindow,hWinMain
				invoke	PostQuitMessage,NULL
				invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
				ret

			.elseif @posX>700 && @posX<775 && @posY>0 && @posY<75
				mov PaintFlag,4

			.endif
		.elseif PaintFlag==1 ;����Ϸ������

			.IF @posX>700 && @posX<775 && @posY>0 && @posY<75 ;������ذ�ť
				mov PaintFlag,0
			.ELSEIF @posX>625 && @posX<700 && @posY>0 && @posY<75 ;�����ͣ��ť
				mov PaintFlag,3
			.ELSEIF @posX>550 && @posX<625 && @posY>0 && @posY<75 ;���������ť
				mov PaintFlag,5
			.endif
		.elseif PaintFlag==2 ;������������
			.if @posX>250 && @posX<450 && @posY>200 && @posY<300	; ���¿�ʼ��Ϸ������������
				mov PaintFlag,0
			.endif

		.elseif PaintFlag==3 ;����ͣ������
			.if @posX>250 && @posX<450 && @posY>200 && @posY<300	; ������Ϸ����
				mov PaintFlag,1
			.endif

		.elseif PaintFlag==4 ;�ڰ������棨�ӿ�ʼ������룬Ҫ���ؿ�ʼ���棩
			.IF @posX>700 && @posX<775 && @posY>0 && @posY<75 ;
				mov PaintFlag,0
			.endif
		.elseif PaintFlag==5 ;�ڰ������棨����Ϸ������룬Ҫ������Ϸ���棩
			.IF @posX>700 && @posX<775 && @posY>0 && @posY<75 ;
				mov PaintFlag,1
			.endif
		.elseif PaintFlag==6 ;��ʤ�����棬��һ�����ذ�ť
			.if @posX>250 && @posX<450 && @posY>275 && @posY<375	; ���¿�ʼ��Ϸ������������
				mov PaintFlag,0
			.endif
		.endif

	.elseif uMsg ==WM_TIMER ;ˢ��
		.IF PaintFlag==0||PaintFlag==4||PaintFlag==5
			invoke InvalidateRect,hWnd,NULL,FALSE ;��Ϊtrue��һֱ��˸
			invoke UpdateBackGround ;���±���ͼƬ	
		.ELSEIF PaintFlag==1 ;����Ϸ�У�������Ҫ������������ĺ���
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

			invoke InvalidateRect,hWnd,NULL,FALSE ;��Ϊtrue��һֱ��˸
			invoke UpdateBackGround ;���±���ͼƬ
			invoke UpdateBoard ;���°���λ��
			invoke UpdateLifeBag	; ����Ѫ��λ��
			invoke CheckGetLifeBag	; ���ɻ��Ƿ�ʰȡѪ��
			invoke CheckCollision ;���ɻ��Ƿ�ײ������
			invoke UpdateUlt	;���´�����ص���Ϣ
			invoke UpdatePBullet ;�����Լ����ӵ�
			invoke CheckHitBoard ;����Լ����ӵ��Ͱ��ӵ���ײ
			invoke UpdateEBullet ;���µз����ӵ�;
			invoke UpdateEnemy ;���µ��˵�λ��;
			invoke generateEBullet ;�õ��˷����ӵ�;
			invoke CheckEPCollision ;���˺��Լ�����ײ;
			invoke CheckEBCollision ;�����ӵ����Լ�����ײ
			invoke CheckPBHit ;�Լ����ӵ��͵��˵���ײ;
			invoke UpdateOtherData		; һЩ�������ݵĸ���
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
	.elseif uMsg ==WM_PAINT ;����Ŀǰ��Ҫ���õĲ������ֱ������������
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
	;��⵽�رմ��ں����δ���������WM_CLOSE��Ϣ����
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
;@Description   :  ��Ϸ������
;@Author        :  ������
;--------------------------------------------------------------------------------------
WinMain proc
	local	@stWndClass:WNDCLASSEX
	local	@stMsg:MSG
	invoke	GetModuleHandle,NULL
	mov	hInstance,eax;��ȡ����ľ��
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
	mov	@stWndClass.lpfnWndProc,offset WndProc ;ָ�����ڴ������
	mov	@stWndClass.hbrBackground,COLOR_WINDOW + 1
	mov	@stWndClass.lpszClassName,offset MyWinClass;���ڵ�����
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

;main����
main proc
	call WinMain	
	invoke ExitProcess,0
	ret
main endp
end main