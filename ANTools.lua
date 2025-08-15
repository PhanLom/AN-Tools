script_name('Arizona Notify')
script_author("PhanLom")
script_version('3.1.2.8')
script_properties('work-in-run')

local dlstatus = require("moonloader").download_status
local ANStyle = require("ANStyles")
local imgui = require('imgui')
local encoding = require("encoding")
local sampev = require("samp.events")
local memory = require("memory")
local effil = require("effil")
local inicfg = require("inicfg")
local ffi = require("ffi")
local fa = require 'faIcons'
local requests = require("requests")
encoding.default = 'CP1251'
u8 = encoding.UTF8

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

if not doesDirectoryExist('moonloader/config/ANTools') then
	createDirectory('moonloader/config/ANTools')
end

if not doesDirectoryExist('moonloader/resource/ANTools/fonts') then
	createDirectory('moonloader/resource/ANTools/fonts')
end

local path = getWorkingDirectory() .. "\\config\\ANTools"

local function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(0)
	sampSetDialogClientside(false)
end
local fix = false
local use = false
local updateid 
local delplayeractive = imgui.ImBool(false)
local npc, infnpc = {}, {}
local mainIni = inicfg.load({
	autologin = {
		state = false
	},
	arec ={
		state = false,
		statebanned = false,
		wait = 50
	},
	roulette = {
		standart = false,
		donate = false,
		platina = false,
		mask = false,
		tainik = false,
		tainikvc = false,
		wait = 1000
	},
	vknotf = {
		token = '',
		user_id = '',
		group_id = '',
		state = false,
		isinitgame = false,
		ishungry = false,
		iscloseconnect = false,
		isadm = false,
		iscode = false,
		isdemorgan = false,
		islowhp = false,
		ispayday = false,
		iscrashscript = false,
		issellitem = false,
		issmscall = false,
		bank = false,
		record = false,
		ismeat = false,
		dienable = false
	},
	tgnotf = {
		token = '',
		user_id = '',
		state = false,
		sellotvtg = false,
		isinitgame = false,
		ishungry = false,
		iscloseconnect = false,
		isadm = false,
		iscode = false,
		isdemorgan = false,
		islowhp = false,
		ispayday = false,
		iscrashscript = false,
		issellitem = false,
		issmscall = false,
		bank = false,
		record = false,
		ismeat = false,
		dienable = false
	},
	autologinfix = {
		state = false,
		nick = '',
		pass = ''
	},
	find = {
		vkfind = false,
		vkfindtext = false,
		vkfindtext2 = false,
		vkfindtext3 = false,
		vkfindtext4 = false,
		vkfindtext5 = false,
		vkfindtext6 = false,
		vkfindtext7 = false,
		vkfindtext8 = false,
		vkfindtext9 = false,
		vkfindtext10 = false,
		inputfindvk = '',
		inputfindvk2 = '',
		inputfindvk3 = '',
		inputfindvk4 = '',
		inputfindvk5 = '',
		inputfindvk6 = '',
		inputfindvk7 = '',
		inputfindvk8 = '',
		inputfindvk9 = '',
		inputfindvk10 = '',
	},
	piar = {
		piar1 = '',
		piar2 = '',
		piar3 = '',
		piarwait = 50,
		piarwait2 = 50,
		piarwait3 = 50,
		auto_piar = false,
		auto_piar_kd = 300,
		last_time = os.time(),
	},
	eat = {
		checkmethod = 0,
		eat2met = 30,
		cycwait = 30,
		setmetod = 0,
        eatmetod = 0,
        healstate = false,
        hplvl = 30,
        hpmetod = 0,
        arztextdrawid = 648,
        arztextdrawidheal = 646,
        drugsquen = 1
	},
	config = {
		banscreen = false,
		autoupdate = true,
		antiafk = false,
		autoad = false,
		autoo = false,
		atext = '',
		aphone = 0,
		autoadbiz = false,
		fastconnect = false
	},
	buttons = {
		binfo = true
	},
	theme = 
	{
		style = 0
	}
},'ANTools/ANTools.ini')


ffi.cdef[[
    typedef unsigned long DWORD;

    struct d3ddeviceVTBL {
        void *QueryInterface;
        void *AddRef;
        void *Release;
        void *TestCooperativeLevel;
        void *GetAvailableTextureMem;
        void *EvictManagedResources;
        void *GetDirect3D;
        void *GetDeviceCaps;
        void *GetDisplayMode;
        void *GetCreationParameters;
        void *SetCursorProperties;
        void *SetCursorPosition;
        void *ShowCursor;
        void *CreateAdditionalSwapChain;
        void *GetSwapChain;
        void *GetNumberOfSwapChains;
        void *Reset;
        void *Present;
        void *GetBackBuffer;
        void *GetRasterStatus;
        void *SetDialogBoxMode;
        void *SetGammaRamp;
        void *GetGammaRamp;
        void *CreateTexture;
        void *CreateVolumeTexture;
        void *CreateCubeTexture;
        void *CreateVertexBuffer;
        void *CreateIndexBuffer;
        void *CreateRenderTarget;
        void *CreateDepthStencilSurface;
        void *UpdateSurface;
        void *UpdateTexture;
        void *GetRenderTargetData;
        void *GetFrontBufferData;
        void *StretchRect;
        void *ColorFill;
        void *CreateOffscreenPlainSurface;
        void *SetRenderTarget;
        void *GetRenderTarget;
        void *SetDepthStencilSurface;
        void *GetDepthStencilSurface;
        void *BeginScene;
        void *EndScene;
        void *Clear;
        void *SetTransform;
        void *GetTransform;
        void *MultiplyTransform;
        void *SetViewport;
        void *GetViewport;
        void *SetMaterial;
        void *GetMaterial;
        void *SetLight;
        void *GetLight;
        void *LightEnable;
        void *GetLightEnable;
        void *SetClipPlane;
        void *GetClipPlane;
        void *SetRenderState;
        void *GetRenderState;
        void *CreateStateBlock;
        void *BeginStateBlock;
        void *EndStateBlock;
        void *SetClipStatus;
        void *GetClipStatus;
        void *GetTexture;
        void *SetTexture;
        void *GetTextureStageState;
        void *SetTextureStageState;
        void *GetSamplerState;
        void *SetSamplerState;
        void *ValidateDevice;
        void *SetPaletteEntries;
        void *GetPaletteEntries;
        void *SetCurrentTexturePalette;
        void *GetCurrentTexturePalette;
        void *SetScissorRect;
        void *GetScissorRect;
        void *SetSoftwareVertexProcessing;
        void *GetSoftwareVertexProcessing;
        void *SetNPatchMode;
        void *GetNPatchMode;
        void *DrawPrimitive;
        void* DrawIndexedPrimitive;
        void *DrawPrimitiveUP;
        void *DrawIndexedPrimitiveUP;
        void *ProcessVertices;
        void *CreateVertexDeclaration;
        void *SetVertexDeclaration;
        void *GetVertexDeclaration;
        void *SetFVF;
        void *GetFVF;
        void *CreateVertexShader;
        void *SetVertexShader;
        void *GetVertexShader;
        void *SetVertexShaderConstantF;
        void *GetVertexShaderConstantF;
        void *SetVertexShaderConstantI;
        void *GetVertexShaderConstantI;
        void *SetVertexShaderConstantB;
        void *GetVertexShaderConstantB;
        void *SetStreamSource;
        void *GetStreamSource;
        void *SetStreamSourceFreq;
        void *GetStreamSourceFreq;
        void *SetIndices;
        void *GetIndices;
        void *CreatePixelShader;
        void *SetPixelShader;
        void *GetPixelShader;
        void *SetPixelShaderConstantF;
        void *GetPixelShaderConstantF;
        void *SetPixelShaderConstantI;
        void *GetPixelShaderConstantI;
        void *SetPixelShaderConstantB;
        void *GetPixelShaderConstantB;
        void *DrawRectPatch;
        void *DrawTriPatch;
        void *DeletePatch;
    };

    struct d3ddevice {
        struct d3ddeviceVTBL** vtbl;
    };
    
    struct RECT {
        long left;
        long top;
        long right;
        long bottom;
    };
    
    struct POINT {
        long x;
        long y;
    };
    
    int __stdcall GetSystemMetrics(
      int nIndex
    );
    
    int __stdcall GetClientRect(
        int   hWnd,
        struct RECT* lpRect
    );
    
    int __stdcall ClientToScreen(
        int    hWnd,
        struct POINT* lpPoint
    );
    
    int __stdcall D3DXSaveSurfaceToFileA(
        const char*          pDestFile,
        int DestFormat,
        void*       pSrcSurface,
        void*        pSrcPalette,
        struct RECT                 *pSrcRect
    );
	
	short GetKeyState(int nVirtKey);
	bool GetKeyboardLayoutNameA(char* pwszKLID);
	int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
	
	void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
	uint32_t __stdcall CoInitializeEx(void*, uint32_t);

	int __stdcall GetVolumeInformationA(
    const char* lpRootPathName,
    char* lpVolumeNameBuffer,
    uint32_t nVolumeNameSize,
    uint32_t* lpVolumeSerialNumber,
    uint32_t* lpMaximumComponentLength,
    uint32_t* lpFileSystemFlags,
    char* lpFileSystemNameBuffer,
    uint32_t nFileSystemNameSize
);
]]


if not doesFileExist('moonloader/config/ANTools/ANTools.ini') then
	inicfg.save(mainIni,'ANTools/ANTools.ini')
end



changelog1 = [[
	v1.0
		Релиз

	v1.1 
		Добавил автообновление
		Добавил новые события для уведомлений 
		Изменил автологин, теперь это автозаполнение

	v1.2
		Управление игрой через команды: !getplstats, !getplinfo, !send(а так же кнопки) 
		Новое событие для отправки уведомления: при выходе из деморгана
		Добавил флудер на 3 строки(если 2 или 3 строка не нужна оставьте её пустой)
	
	v1.25 - Hotfix
		Исправил краш при отправке уведомления о том что перс голоден

	v1.3
		Добавил открытие донат сундука (внимательно читайте как сделать чтоб работало)
		Для украинцев: добавил возможность вырубить VK Notifications и спокойно использовать скрипт

	v1.4
		Пофиксил автооткрытие если игра свернута

	v1.5
		Переписал функцию принятия уведомлений
		Теперь автохилл не флудит

	v1.6
		Релиз на BlastHack
		К каждой строке флудера добавлена своя задержка
		Теперь, если вас убил игрок и включено уведомление о смерти, в уведомлении напишет кто вас убил
		Прибрался в коде

	v1.6.1
		Фикс VK Notifications

	v1.7
		В VK Notifications добавлена кнопка "Голод" и команда !getplhun
		Добавлена возможность выключить автообновление
		Исправлены ложные уведомления на сообщения от администратора\

	v1.8 
		Обновил способ антиафк, вроде теперь у всех работает
		Пофиксил если перс умрет

	v1.8-fix
		Фикс краша при реконнекте

	v1.9
		Новый дизайн
		Добавлен АвтоПиар
		Добавлена проверка на /pm от админов(диалог + чат, 2 вида)
		Фикс AutoBanScreen - теперь, скринит при появлении диалога о бане

	v1.9.1
		Фикс хавки из дома

	v1.9.1.1
		Фикс сохранения задержки для автооткрытия

	v2.0.0
		Пофикшены краши(вроде все) при реконнекте, использовании бота VK
		Сменен дизайн на более приятный
		В автозаполнение добавлена кнопка "Добавить аккаунт"
		Добавлены команды /ANrec(рекон с секундами), /ANsrec(стопает авторекон и рекон обычный)

		]]
changelog2 = [[	v2.0.1
		Фикс автооткрытия

	v2.0.2
		Автоеда - Добавлен выбор проверки когда можно похавать(полоска голода с настройкой) 
		Фикс крашей из-за пиара и др.
		Добавлен Fastconnect

	v2.0.3
		Фиксы багов

	v2.0.4
		Отключение автообновлений
		В VK Notifications добавлена кнопка "SMS и Звонок"

	v2.0.5
		В VK Notifications добавлена кнопка "КД мешка/рулеток", а также "Код с почты/ВК"
		Добавлены команды !sendcode !sendvk для отправки кодов подтверждений из ВК в игру.

	v2.0.6
		Добавлен Автоответчик, который сам возьмет трубку и попросит абонента написать в ВК.
		Добавлена запись звонков, также можно разговаривать по телефону из ВК.
		В ВК добавлены команды !p (принять звонок) и !h (сбросить звонок). Общаться можно через !send [текст].

	v2.0.7
		Если в автопиаре используете /ad, то для этого добавлен Автоскип /ad (для обычных и маркетологов).
		Пофиксил флуд в ВК "The server didn't respond".
		Восстановление на БХ.

	v2.0.8
		Добавил проверку при использовании команды !p, !h (раньше скрипт отправлял сообщения даже не взаимодействуя)
		Теперь скрипт не рестартит при запросе кода с почты/ВК.
		Переписан автоответчик, а также запись звонков.
		Теперь есть 2 версии скрипта:
			- С уже подключенным пабликом (для тех кто не умеет)
			- Без подключенного паблика, подключать самому (для тех кто хочет быть крутым)
		Добавлена команда !gauth для отправки кода из GAuthenticator
		Если персонаж заспанится после логина, то придет уведомление
		
		]]
changelog3 = [[
	v2.0.9
		Теперь на автоответчик можно писать свой текст.
		В ВК добавлена кнопка "Последние 10 строк с чата"
		Добавлена функция переотправки сообщения в /vr из-за КД.
		Теперь скрипт поддерживает автообновление.

	v2.0.9.1
		Небольшой багофикс.
		Переписан скип /ad.

	v2.0.9.2
		Переписан полностью автоответчик и ответ на звонки с ВК.
		Исправлены баги.

	v2.1.0
		Исправлена работа Автоскипа диалога /vr.
		Теперь можно включать отправку всех диалогов в ВК.
		Добавлено взаимодействие с диалогами в игре через !d [пункт или текст] и !dc (закрывает диалог).
		Теперь отправлять команды в игру можно без !send, но отправлять текст в чат через него все же нужно.
		Приподнял кнопки в главном меню для красоты.
		Прибрался в основных настройках.
		Пофиксил автооткрытие, добавил доп. сундуки.

	v2.2
		Теперь скриншот из игры можно получать в ВК.
		Добавил несколько кнопок для скачивания библиотек/других скриптов:
			• Автооткрытие от bakhusse
			• AntiAFK by AIR
			• Библиотеки для работы !screen
		Уменьшил размеры окон "Как настроить" и "Как исправить !screen" в VK Notifications.
		Исправил автообновление в версии с пабликом.
		Добавлены кнопки:
			• OK и Cancel для диалоговых окон
			• ALT
			• ESC для закрытия TextDraw
		Добавил уведомление от получения или отправления банковского перевода.
		В кнопку "Поддержка" были добавлены новые команды.
		Переписан текст в "Как настроить" в VK Notifications.
		Теперь при включенной функции "Отправка всех диалогов" сообщения не отправляются по 2 раза.
		Добавлен показатель онлайна на сервере в "Информация"

]]
changelog4 = [[
	v2.3
		Теперь кнопки управления игрой отдельны от основной клавиатуры.
		Исправил краш игры от кнопки ALT из ВК.
		Заменил кнопки Переотправка /vr и Скип /vr на кнопку скачивания скрипта от Cosmo.
		Добавлена отправка найденного текста в ВК.
		Добавил ссылки на группу ВК, ВК Разработчика, Telegram-канал.
		При отправке диалоговых окон кнопки будут в сообщении 
			(для тех диалогов без выбора строки и ввода текста).
		Теперь через ВК можно выключить игру и компьютер(с таймером на 30 сек.)
		Вырезана функция скип диалога /ad на доработку.
		Добавил функцию "Убрать людей в радиусе".
		Добавил доп. совет для использования !screen.

	v2.4
		Теперь диалог об отправке сообщения в /vr не будет отправляться в ВК.
		Добавлены кнопки Принять/Отклонить звонок при входящем вызове в ВК.
		Исправлен автоответчик, ранее не нажимал Y и не брал трубку.
		Добавлена кнопка Скриншот в диалоге в ВК.
		Добавлена кнопка для скачивания скрипта с пабликом или без.

	v2.5
		Исправил автоеду в фам КВ.
		В АвтоХил добавлены сигареты

	v2.5.1 HOTFIX
		В основные настройки добавлен автологин для новых интерфейсов.

]]

changelog5 = [[

	v3.0 Beta

		· Добавлено Telegam Notifications [Beta]
		· Добавлен раздел кастомизации [Beta]
		· Глобальные изменения визуального интерфейса скрипта
		· Частично переписаны некоторые разделы 
		· Добавлен faIcons.lua как зависимость 
		· Добавлены FreeStyle ImGui темы 
		· Добавлена светлая ANTools тема [Beta]
		· Реализован ANStyles.lua как зависимость(?) [Beta]
		· Поиск в чате для VK + Telegram
		· Обновлён логотип в шапке скрипта
		· Добавлен логотип в ANMessage
		· Полностью переписан раздел Информация и F.A.Q
		· Частично переписан раздел основных функций в более приемлемый вид
		· В раздел информации добавлен script_banner.png
		· Config преобразован в ANTools.ini
		· Рабочая директория конфига - /moonloader/config/ANTools/...
		· Задействована папка resource
		· Config частично почищен от лишних переменных
		· Удалены лишние кнопки
		· Удалён устаревший гайд по настройке API ВКонтакте
		· Удалена версия с пабликом
		· Удалён автоответчик 

	v3.1.2
		· Исправлены ошибки в работе с VK API
		· Улучшена стабильность работы скрипта
		· Добавлены новые функции для работы с Telegram
			·!d работает штатно
			·!dc работает штатно
			·!off game работает штатно
			·!off pc работает штатно
		· Обновлены зависимости

]]

scriptinfo = [[
 AN Tools - скрипт, который уведомляет вас об персонаже на Arizona Role Play!

По вопросам по скрипту, поддержке, тех.поддержке, помощи, обращаться к  - PhanLom

Разработка/Поддержка скрипта: PhanLom

Автор проекта: PhanLom

Отдельное спасибо: Copilot за моральную поддержку!

2020-2023.
]]


scriptcommand = [[

	Основные команды скрипта:

		/ANTools - открыть меню скрипта
		/ANreload - перезагрузить скрипт 
		/ANunload - выгрузить скрипт
		/ANrec - реконнект с секундами
		/ANsrec - остановить реконнект(стандартный или авторекон)

]]

howsetVK = [[
Ищите в интернете информацию о получении токена и ID для VK API.

]]

howsetTG = [[
Идем в бота @Botfather, далее создаем бота. После создания бота, вы получите токен,
который нужно будет использовать в нашем скрипте.
Идем в бота @getmyid_bot, чтобы получить ваш ID. Пишем /start и получаем свой ID.
Вставляем токен и ID в настройки скрипта.
Готово!

]]

customtext = [[

Данный раздел находится на стадии разработки!

В данном разделе вы можете наконец-то изменить ImGUI составляющую нашего скрипта!
Задействован фристайл с BlastHack, а так же оригинальные темы на основе нашей основной темы!

]]

prefixtext = [[
Префиксы оформления:
[BlastHack] - темы формата "Free-style", взяты с открытого доступа от разработчиков и дизайнеров BlastHack.
[NickName] - тема опубликованная извественым разработчиком/UI-дизайнером на BlastHack.

]]

searchchatfaq = [[
	
Поиск и отправка текста с сервера - прямо вам в Telegram или ВКонтакте.
Если включен только раздел "VK Notifications" - уведомления будут приходить только в VK.
Если включен только раздел "TG Notifications" - уведомления будут приходить только в Telegram.
Если получаете уведомления в оба мессенджера - найденный текст будет отправляться вам и в VK и в Telegram.

Для чего это?
Предусмотрено 10 полей формата Input, введите в один из них нужный текст(Пример: Шар + 12), поставьте галочку рядом и скрипт будет вам
отправлять, все строки связанные с "Шар +12", аналогично с другими аксессуарами, транспортом и другим имуществом.
Так же, можете вылавливать нужные для вас строки с помощью этой функции, например действия определённого игрока в плане /ad /vr /fam и тд.
]]


howscreen = [[
Команда !screen работает следующим образом:
• Если игра свёрнута - произойдет краш скрипта
• Если игра на весь экран - придёт просто белый скриншот. 
• Чтобы сработало идеально - нужно сделать игру в оконный режим 
  и растянуть на весь экран (на лаунчере можно просто в настройках
  лаунчера включить оконный режим).
• Для работы команды нужно скачать необходимые
  библиотеки (скачать можно в меню VK/TG Notifications)
• Чтобы получать скрины корректно, советую сперва использовать
  комбинацию Alt + Enter, после Win + стрелка вверх.
]]

local _message = {}

local style_selected = imgui.ImInt(mainIni.theme.style) 
local style_list = {u8"Оригинальная", u8'Светлая', u8"Серая", u8"Тёмная", u8"Вишнёвая", u8"Фиолетовая", u8"Розовая", u8"Голубая"}

local banner = imgui.CreateTextureFromFile(getWorkingDirectory() .. "\\resource\\ANTools\\script_banner.png")


function ANMessage(text,del)
	del = del or 5
	_message[#_message+1] = {active = false, time = 0, showtime = del, text = text}
end
--ale op, load
local fastconnect = imgui.ImBool(mainIni.config.fastconnect)
local antiafk = imgui.ImBool(mainIni.config.antiafk)
local banscreen = imgui.ImBool(mainIni.config.banscreen)
local autoupdateState = imgui.ImBool(mainIni.config.autoupdate)
local autoad = imgui.ImBool(mainIni.config.autoad)
local autoo = imgui.ImBool(mainIni.config.autoo)
local atext = imgui.ImBuffer(''..mainIni.config.atext,300)
local aphone = imgui.ImInt(mainIni.config.aphone)
local autoadbiz = imgui.ImBool(mainIni.config.autoadbiz)
local binfo = imgui.ImBool(mainIni.buttons.binfo)
local autologin = {
	state = imgui.ImBool(mainIni.autologin.state)
}
local arec = {
	state = imgui.ImBool(mainIni.arec.state),
	statebanned = imgui.ImBool(mainIni.arec.statebanned),
	wait = imgui.ImInt(mainIni.arec.wait)
}
local roulette = {
	standart = imgui.ImBool(mainIni.roulette.standart),
	donate = imgui.ImBool(mainIni.roulette.donate),
	platina = imgui.ImBool(mainIni.roulette.platina),
	mask = imgui.ImBool(mainIni.roulette.mask),
	tainik = imgui.ImBool(mainIni.roulette.tainik),
	tainikvc = imgui.ImBool(mainIni.roulette.tainikvc),
	wait = imgui.ImInt(mainIni.roulette.wait)
}
local vknotf = {
	token = imgui.ImBuffer(''..mainIni.vknotf.token,300),
	user_id = imgui.ImBuffer(''..mainIni.vknotf.user_id,300),
	group_id = imgui.ImBuffer(''..mainIni.vknotf.group_id,300),
	state = imgui.ImBool(mainIni.vknotf.state),
	isinitgame = imgui.ImBool(mainIni.vknotf.isinitgame),
	ishungry = imgui.ImBool(mainIni.vknotf.ishungry),
	issmscall = imgui.ImBool(mainIni.vknotf.issmscall),
	bank = imgui.ImBool(mainIni.vknotf.bank),
	record = imgui.ImBool(mainIni.vknotf.record),
	ismeat = imgui.ImBool(mainIni.vknotf.ismeat),
	dienable = imgui.ImBool(mainIni.vknotf.dienable),
	iscloseconnect = imgui.ImBool(mainIni.vknotf.iscloseconnect),
	isadm = imgui.ImBool(mainIni.vknotf.isadm),
	iscode = imgui.ImBool(mainIni.vknotf.iscode),
	isdemorgan = imgui.ImBool(mainIni.vknotf.isdemorgan),
	islowhp = imgui.ImBool(mainIni.vknotf.islowhp),
	issendlowhp = false,
	ispayday = imgui.ImBool(mainIni.vknotf.ispayday),
	iscrashscript = imgui.ImBool(mainIni.vknotf.iscrashscript),
	ispaydaystate = false,
	ispaydayvalue = 0,
	ispaydaytext = '',
	issellitem = imgui.ImBool(mainIni.vknotf.issellitem)
}

local tgnotf = {
	token = imgui.ImBuffer(''..mainIni.tgnotf.token,300),
	user_id = imgui.ImBuffer(''..mainIni.tgnotf.user_id,300),
	state = imgui.ImBool(mainIni.tgnotf.state),
	isinitgame = imgui.ImBool(mainIni.tgnotf.isinitgame),
	sellotvtg = imgui.ImBool(mainIni.tgnotf.sellotvtg),
    ishungry = imgui.ImBool(mainIni.tgnotf.ishungry),
    issmscall = imgui.ImBool(mainIni.tgnotf.issmscall),
    bank = imgui.ImBool(mainIni.tgnotf.bank),
    record = imgui.ImBool(mainIni.tgnotf.record),
    ismeat = imgui.ImBool(mainIni.tgnotf.ismeat),
    dienable = imgui.ImBool(mainIni.tgnotf.dienable),
    iscloseconnect = imgui.ImBool(mainIni.tgnotf.iscloseconnect),
    isadm = imgui.ImBool(mainIni.tgnotf.isadm),
    iscode = imgui.ImBool(mainIni.tgnotf.iscode),
    isdemorgan = imgui.ImBool(mainIni.tgnotf.isdemorgan),
    islowhp = imgui.ImBool(mainIni.tgnotf.islowhp),
    issendlowhp = false,
    ispayday = imgui.ImBool(mainIni.tgnotf.ispayday),
    iscrashscript = imgui.ImBool(mainIni.tgnotf.iscrashscript),
    ispaydaystate = false,
    ispaydayvalue = 0,
    ispaydaytext = '',
    issellitem = imgui.ImBool(mainIni.tgnotf.issellitem)
}
local autologinfix = {
	state = imgui.ImBool(mainIni.autologinfix.state),
	nick = imgui.ImBuffer(''..mainIni.autologinfix.nick,50),
	pass = imgui.ImBuffer(''..mainIni.autologinfix.pass,50)
}
local piar = {
	piar1 = imgui.ImBuffer(''..mainIni.piar.piar1, 500),
	piar2 = imgui.ImBuffer(''..mainIni.piar.piar2, 500),
	piar3 = imgui.ImBuffer(''..mainIni.piar.piar3, 500),
	piarwait = imgui.ImInt(mainIni.piar.piarwait),
	piarwait2 = imgui.ImInt(mainIni.piar.piarwait2),
	piarwait3 = imgui.ImInt(mainIni.piar.piarwait3),
	auto_piar = imgui.ImBool(mainIni.piar.auto_piar),
	auto_piar_kd = imgui.ImInt(mainIni.piar.auto_piar_kd),
	last_time = mainIni.piar.last_time
}
local find = {
	vkfind = imgui.ImBool(mainIni.find.vkfind),
	vkfindtext = imgui.ImBool(mainIni.find.vkfindtext),
	vkfindtext2 = imgui.ImBool(mainIni.find.vkfindtext2),
	vkfindtext3 = imgui.ImBool(mainIni.find.vkfindtext3),
	vkfindtext4 = imgui.ImBool(mainIni.find.vkfindtext4),
	vkfindtext5 = imgui.ImBool(mainIni.find.vkfindtext5),
	vkfindtext6 = imgui.ImBool(mainIni.find.vkfindtext6),
	vkfindtext7 = imgui.ImBool(mainIni.find.vkfindtext7),
	vkfindtext8 = imgui.ImBool(mainIni.find.vkfindtext8),
	vkfindtext9 = imgui.ImBool(mainIni.find.vkfindtext9),
	vkfindtext10 = imgui.ImBool(mainIni.find.vkfindtext10),
	inputfindvk = imgui.ImBuffer(u8(mainIni.find.inputfindvk), 1000),
	inputfindvk2 = imgui.ImBuffer(u8(mainIni.find.inputfindvk2), 1000),
	inputfindvk3 = imgui.ImBuffer(u8(mainIni.find.inputfindvk3), 1000),
	inputfindvk4 = imgui.ImBuffer(u8(mainIni.find.inputfindvk4), 1000),
	inputfindvk5 = imgui.ImBuffer(u8(mainIni.find.inputfindvk5), 1000),
	inputfindvk6 = imgui.ImBuffer(u8(mainIni.find.inputfindvk6), 1000),
	inputfindvk7 = imgui.ImBuffer(u8(mainIni.find.inputfindvk7), 1000),
	inputfindvk8 = imgui.ImBuffer(u8(mainIni.find.inputfindvk8), 1000),
	inputfindvk9 = imgui.ImBuffer(u8(mainIni.find.inputfindvk9), 1000),
	inputfindvk10 = imgui.ImBuffer(u8(mainIni.find.inputfindvk10), 1000)
}
local eat = {
	checkmethod = imgui.ImInt(mainIni.eat.checkmethod),
	eat2met = imgui.ImInt(mainIni.eat.eat2met),
	cycwait = imgui.ImInt(mainIni.eat.cycwait),
	setmetod = imgui.ImInt(mainIni.eat.setmetod),
	eatmetod = imgui.ImInt(mainIni.eat.eatmetod),
	healstate = imgui.ImBool(mainIni.eat.healstate),
	hplvl = imgui.ImInt(mainIni.eat.hplvl),
	hpmetod = imgui.ImInt(mainIni.eat.hpmetod),
	arztextdrawid = imgui.ImInt(mainIni.eat.arztextdrawid),
	arztextdrawidheal = imgui.ImInt(mainIni.eat.arztextdrawidheal),
	drugsquen = imgui.ImInt(mainIni.eat.drugsquen)
}
-- one launch
local ANsets = imgui.ImBool(false)
local showpass = false
local showtoken = false
local aopen = false
local opentimerid = {
	standart = -1,
	donate = -1,
	platina = -1,
	mask = -1,
	tainik = -1
}
local checkopen = {
	standart = false,
	donate = false,
	platina = false,
	mask = false,
	tainik = false
}
local onPlayerHungry = lua_thread.create_suspended(function()
	if eat.eatmetod.v == 1 then
		ANMessage('Реагирую, кушаю')
		gotoeatinhouse = true
		sampSendChat('/home')
	elseif eat.eatmetod.v == 3 then
		ANMessage('Реагирую, кушаю')
		setVirtualKeyDown(18, true)
		while not sampIsDialogActive() do wait(0) end
		sampSendDialogResponse(1825, 1, 6, false)
		while not sampIsDialogActive() do wait(0) end
		setVirtualKeyDown(18, true)
		while not sampIsDialogActive() do wait(0) end
		sampSendDialogResponse(1825, 1, 6, false)
		while not sampIsDialogActive() do wait(0) end
		wait(500)
		sampCloseCurrentDialogWithButton(0)
	elseif eat.eatmetod.v == 2 then 
		ANMessage('Реагирую, кушаю')
		if eat.setmetod.v == 0 then
			for i = 1,30 do
				sampSendChat('/cheeps')
				wait(4000)
			end    
		elseif eat.setmetod.v == 1 then
			for k = 1,10 do
				sampSendChat('/jfish')
				wait(3000)
			end    
		elseif eat.setmetod.v == 2 then
			sampSendChat('/jmeat')  
		elseif eat.setmetod.v == 3 then
			sampSendClickTextdraw(eat.arztextdrawid.v)
			sampSendClickTextdraw(eat.arztextdrawid.v)
		elseif eat.setmetod.v == 4 then
			sampSendChat('/meatbag') 
		end
	end
end)
local createscreen = lua_thread.create_suspended(function()
	wait(2000)
	takeScreen()
end)
local checkrulopen = lua_thread.create_suspended(function()
	while true do
		wait(0)
		if aopen then
			sampSendClickTextdraw(65535)
            wait(355)
            fix = true
            sampSendChat("/mn")
			wait(2000)
			sampCloseCurrentDialogWithButton(0)
            wait(2000)
            fix = false
			ANMessage('Начинаем делать проверку')
			checkopen.standart = true
			checkopen.donate = roulette.donate.v and true or false
			checkopen.platina = roulette.platina.v and true or false
			checkopen.mask = roulette.mask.v and true or false
			checkopen.tainik = roulette.tainik.v and true or false
			sampSendChat('/invent')
			wait(roulette.wait.v*60000)
			ANMessage('Перезапуск')
		end
	end
end)

--autofill
local file_accs = path .. "\\accs.json"

local dialogChecker = {
	check = false,
	id = -1,
	title = ""
}

local editpass = {
	numedit = -1,
	input = imgui.ImBuffer('',100)
}

local addnew = {
	name = imgui.ImBuffer('',100),
	pass = imgui.ImBuffer('',100),
	dialogid = imgui.ImInt(0),
	serverip = imgui.ImBuffer('',100)
}

function addnew:save()
	if #addnew.name.v > 0 and #addnew.pass.v > 0 and #(tostring(addnew.dialogid.v)) > 0 and #addnew.serverip.v > 0 then
		saveacc(addnew.name.v,addnew.pass.v,addnew.dialogid.v,addnew.serverip.v)
		return true
	end
end

local temppass = {}
local savepass = {}

if doesFileExist(file_accs) then
	local f = io.open(file_accs, "r")
	if f then
		savepass = decodeJson(f:read("a*"))
		f:close()
	end
end

-- Метод получения статуса голода -- 

local checklist = {
	u8('You are hungry!'),
	u8('Полоска голода')
}

-- Хавка -- 

local metod = {
	u8('Чипсы'),
	u8('Рыба'),
	u8('Оленина'),
	u8('TextDraw'),
	u8('Мешок')
}

-- Хилки -- 

local healmetod = {
	u8('Аптечка'),
	u8('Наркотики'),
	u8('Андреналин'),
	u8('Пиво'),
	u8('TextDraw'),
	u8('Сигареты')
}

 
font2 = renderCreateFont('Arial', 8, 5)
local list = {}
function list:new()
	return {
		pos = {
			x = select(1,getScreenResolution()) - 222,
			y = select(2,getScreenResolution()) - 60
		},
		size = {
			x = 200,
			y = 0
		}
	}
end
notfList = list:new()

function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x101 then
		if (wparam == 0x1B and ANsets.v) and not isPauseMenuActive() then
			consumeWindowMessage(true, false)
			if msg == 0x101 then
				ANsets.v = false
			end
		end
	end
end

menunum = 0 
menufill = 0 
localvalue = 0
local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end
local function send_player_stream(id, i)
	if i then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt16(bs, id)
		raknetBitStreamWriteInt8(bs, i[1])
		raknetBitStreamWriteInt32(bs, i[2])
		raknetBitStreamWriteFloat(bs, i[3].x)
		raknetBitStreamWriteFloat(bs, i[3].y)
		raknetBitStreamWriteFloat(bs, i[3].z)
		raknetBitStreamWriteFloat(bs, i[4])
		raknetBitStreamWriteInt32(bs, i[5])
		raknetBitStreamWriteInt8(bs, i[6])
		raknetEmulRpcReceiveBitStream(32, bs)
	end
end
function emul_rpc(hook, parameters)
    local bs_io = require 'samp.events.bitstream_io'
    local handler = require 'samp.events.handlers'
    local extra_types = require 'samp.events.extra_types'
    local hooks = {

        --[[ Outgoing rpcs
        ['onSendEnterVehicle'] = { 'int16', 'bool8', 26 },
        ['onSendClickPlayer'] = { 'int16', 'int8', 23 },
        ['onSendClientJoin'] = { 'int32', 'int8', 'string8', 'int32', 'string8', 'string8', 'int32', 25 },
        ['onSendEnterEditObject'] = { 'int32', 'int16', 'int32', 'vector3d', 27 },
        ['onSendCommand'] = { 'string32', 50 },
        ['onSendSpawn'] = { 52 },
        ['onSendDeathNotification'] = { 'int8', 'int16', 53 },
        ['onSendDialogResponse'] = { 'int16', 'int8', 'int16', 'string8', 62 },
        ['onSendClickTextDraw'] = { 'int16', 83 },
        ['onSendVehicleTuningNotification'] = { 'int32', 'int32', 'int32', 'int32', 96 },
        ['onSendChat'] = { 'string8', 101 },
        ['onSendClientCheckResponse'] = { 'int8', 'int32', 'int8', 103 },
        ['onSendVehicleDamaged'] = { 'int16', 'int32', 'int32', 'int8', 'int8', 106 },
        ['onSendEditAttachedObject'] = { 'int32', 'int32', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 116 },
        ['onSendEditObject'] = { 'bool', 'int16', 'int32', 'vector3d', 'vector3d', 117 },
        ['onSendInteriorChangeNotification'] = { 'int8', 118 },
        ['onSendMapMarker'] = { 'vector3d', 119 },
        ['onSendRequestClass'] = { 'int32', 128 },
        ['onSendRequestSpawn'] = { 129 },
        ['onSendPickedUpPickup'] = { 'int32', 131 },
        ['onSendMenuSelect'] = { 'int8', 132 },
        ['onSendVehicleDestroyed'] = { 'int16', 136 },
        ['onSendQuitMenu'] = { 140 },
        ['onSendExitVehicle'] = { 'int16', 154 },
        ['onSendUpdateScoresAndPings'] = { 155 },
        ['onSendGiveDamage'] = { 'int16', 'float', 'int32', 'int32', 115 },
        ['onSendTakeDamage'] = { 'int16', 'float', 'int32', 'int32', 115 },]]

        -- Incoming rpcs
        ['onInitGame'] = { 139 },
        ['onPlayerJoin'] = { 'int16', 'int32', 'bool8', 'string8', 137 },
        ['onPlayerQuit'] = { 'int16', 'int8', 138 },
        ['onRequestClassResponse'] = { 'bool8', 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 128 },
        ['onRequestSpawnResponse'] = { 'bool8', 129 },
        ['onSetPlayerName'] = { 'int16', 'string8', 'bool8', 11 },
        ['onSetPlayerPos'] = { 'vector3d', 12 },
        ['onSetPlayerPosFindZ'] = { 'vector3d', 13 },
        ['onSetPlayerHealth'] = { 'float', 14 },
        ['onTogglePlayerControllable'] = { 'bool8', 15 },
        ['onPlaySound'] = { 'int32', 'vector3d', 16 },
        ['onSetWorldBounds'] = { 'float', 'float', 'float', 'float', 17 },
        ['onGivePlayerMoney'] = { 'int32', 18 },
        ['onSetPlayerFacingAngle'] = { 'float', 19 },
        --['onResetPlayerMoney'] = { 20 },
        --['onResetPlayerWeapons'] = { 21 },
        ['onGivePlayerWeapon'] = { 'int32', 'int32', 22 },
        --['onCancelEdit'] = { 28 },
        ['onSetPlayerTime'] = { 'int8', 'int8', 29 },
        ['onSetToggleClock'] = { 'bool8', 30 },
        ['onPlayerStreamIn'] = { 'int16', 'int8', 'int32', 'vector3d', 'float', 'int32', 'int8', 32 },
        ['onSetShopName'] = { 'string256', 33 },
        ['onSetPlayerSkillLevel'] = { 'int16', 'int32', 'int16', 34 },
        ['onSetPlayerDrunk'] = { 'int32', 35 },
        ['onCreate3DText'] = { 'int16', 'int32', 'vector3d', 'float', 'bool8', 'int16', 'int16', 'encodedString4096', 36 },
        --['onDisableCheckpoint'] = { 37 },
        ['onSetRaceCheckpoint'] = { 'int8', 'vector3d', 'vector3d', 'float', 38 },
        --['onDisableRaceCheckpoint'] = { 39 },
        --['onGamemodeRestart'] = { 40 },
        ['onPlayAudioStream'] = { 'string8', 'vector3d', 'float', 'bool8', 41 },
        --['onStopAudioStream'] = { 42 },
        ['onRemoveBuilding'] = { 'int32', 'vector3d', 'float', 43 },
        ['onCreateObject'] = { 44 },
        ['onSetObjectPosition'] = { 'int16', 'vector3d', 45 },
        ['onSetObjectRotation'] = { 'int16', 'vector3d', 46 },
        ['onDestroyObject'] = { 'int16', 47 },
        ['onPlayerDeathNotification'] = { 'int16', 'int16', 'int8', 55 },
        ['onSetMapIcon'] = { 'int8', 'vector3d', 'int8', 'int32', 'int8', 56 },
        ['onRemoveVehicleComponent'] = { 'int16', 'int16', 57 },
        ['onRemove3DTextLabel'] = { 'int16', 58 },
        ['onPlayerChatBubble'] = { 'int16', 'int32', 'float', 'int32', 'string8', 59 },
        ['onUpdateGlobalTimer'] = { 'int32', 60 },
        ['onShowDialog'] = { 'int16', 'int8', 'string8', 'string8', 'string8', 'encodedString4096', 61 },
        ['onDestroyPickup'] = { 'int32', 63 },
        ['onLinkVehicleToInterior'] = { 'int16', 'int8', 65 },
        ['onSetPlayerArmour'] = { 'float', 66 },
        ['onSetPlayerArmedWeapon'] = { 'int32', 67 },
        ['onSetSpawnInfo'] = { 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 68 },
        ['onSetPlayerTeam'] = { 'int16', 'int8', 69 },
        ['onPutPlayerInVehicle'] = { 'int16', 'int8', 70 },
        --['onRemovePlayerFromVehicle'] = { 71 },
        ['onSetPlayerColor'] = { 'int16', 'int32', 72 },
        ['onDisplayGameText'] = { 'int32', 'int32', 'string32', 73 },
        --['onForceClassSelection'] = { 74 },
        ['onAttachObjectToPlayer'] = { 'int16', 'int16', 'vector3d', 'vector3d', 75 },
        ['onInitMenu'] = { 76 },
        ['onShowMenu'] = { 'int8', 77 },
        ['onHideMenu'] = { 'int8', 78 },
        ['onCreateExplosion'] = { 'vector3d', 'int32', 'float', 79 },
        ['onShowPlayerNameTag'] = { 'int16', 'bool8', 80 },
        ['onAttachCameraToObject'] = { 'int16', 81 },
        ['onInterpolateCamera'] = { 'bool', 'vector3d', 'vector3d', 'int32', 'int8', 82 },
        ['onGangZoneStopFlash'] = { 'int16', 85 },
        ['onApplyPlayerAnimation'] = { 'int16', 'string8', 'string8', 'bool', 'bool', 'bool', 'bool', 'int32', 86 },
        ['onClearPlayerAnimation'] = { 'int16', 87 },
        ['onSetPlayerSpecialAction'] = { 'int8', 88 },
        ['onSetPlayerFightingStyle'] = { 'int16', 'int8', 89 },
        ['onSetPlayerVelocity'] = { 'vector3d', 90 },
        ['onSetVehicleVelocity'] = { 'bool8', 'vector3d', 91 },
        ['onServerMessage'] = { 'int32', 'string32', 93 },
        ['onSetWorldTime'] = { 'int8', 94 },
        ['onCreatePickup'] = { 'int32', 'int32', 'int32', 'vector3d', 95 },
        ['onMoveObject'] = { 'int16', 'vector3d', 'vector3d', 'float', 'vector3d', 99 },
        ['onEnableStuntBonus'] = { 'bool', 104 },
        ['onTextDrawSetString'] = { 'int16', 'string16', 105 },
        ['onSetCheckpoint'] = { 'vector3d', 'float', 107 },
        ['onCreateGangZone'] = { 'int16', 'vector2d', 'vector2d', 'int32', 108 },
        ['onPlayCrimeReport'] = { 'int16', 'int32', 'int32', 'int32', 'int32', 'vector3d', 112 },
        ['onGangZoneDestroy'] = { 'int16', 120 },
        ['onGangZoneFlash'] = { 'int16', 'int32', 121 },
        ['onStopObject'] = { 'int16', 122 },
        ['onSetVehicleNumberPlate'] = { 'int16', 'string8', 123 },
        ['onTogglePlayerSpectating'] = { 'bool32', 124 },
        ['onSpectatePlayer'] = { 'int16', 'int8', 126 },
        ['onSpectateVehicle'] = { 'int16', 'int8', 127 },
        ['onShowTextDraw'] = { 134 },
        ['onSetPlayerWantedLevel'] = { 'int8', 133 },
        ['onTextDrawHide'] = { 'int16', 135 },
        ['onRemoveMapIcon'] = { 'int8', 144 },
        ['onSetWeaponAmmo'] = { 'int8', 'int16', 145 },
        ['onSetGravity'] = { 'float', 146 },
        ['onSetVehicleHealth'] = { 'int16', 'float', 147 },
        ['onAttachTrailerToVehicle'] = { 'int16', 'int16', 148 },
        ['onDetachTrailerFromVehicle'] = { 'int16', 149 },
        ['onSetWeather'] = { 'int8', 152 },
        ['onSetPlayerSkin'] = { 'int32', 'int32', 153 },
        ['onSetInterior'] = { 'int8', 156 },
        ['onSetCameraPosition'] = { 'vector3d', 157 },
        ['onSetCameraLookAt'] = { 'vector3d', 'int8', 158 },
        ['onSetVehiclePosition'] = { 'int16', 'vector3d', 159 },
        ['onSetVehicleAngle'] = { 'int16', 'float', 160 },
        ['onSetVehicleParams'] = { 'int16', 'int16', 'bool8', 161 },
        --['onSetCameraBehind'] = { 162 },
        ['onChatMessage'] = { 'int16', 'string8', 101 },
        ['onConnectionRejected'] = { 'int8', 130 },
        ['onPlayerStreamOut'] = { 'int16', 163 },
        ['onVehicleStreamIn'] = { 164 },
        ['onVehicleStreamOut'] = { 'int16', 165 },
        ['onPlayerDeath'] = { 'int16', 166 },
        ['onPlayerEnterVehicle'] = { 'int16', 'int16', 'bool8', 26 },
        ['onUpdateScoresAndPings'] = { 'PlayerScorePingMap', 155 },
        ['onSetObjectMaterial'] = { 84 },
        ['onSetObjectMaterialText'] = { 84 },
        ['onSetVehicleParamsEx'] = { 'int16', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 24 },
        ['onSetPlayerAttachedObject'] = { 'int16', 'int32', 'bool', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 113 }

    }
    local handler_hook = {
        ['onInitGame'] = true,
        ['onCreateObject'] = true,
        ['onInitMenu'] = true,
        ['onShowTextDraw'] = true,
        ['onVehicleStreamIn'] = true,
        ['onSetObjectMaterial'] = true,
        ['onSetObjectMaterialText'] = true
    }
    local extra = {
        ['PlayerScorePingMap'] = true,
        ['Int32Array3'] = true
    }
    local hook_table = hooks[hook]
    if hook_table then
        local bs = raknetNewBitStream()
        if not handler_hook[hook] then
            local max = #hook_table-1
            if max > 0 then
                for i = 1, max do
                    local p = hook_table[i]
                    if extra[p] then extra_types[p]['write'](bs, parameters[i])
                    else bs_io[p]['write'](bs, parameters[i]) end
                end
            end
        else
            if hook == 'onInitGame' then handler.on_init_game_writer(bs, parameters)
            elseif hook == 'onCreateObject' then handler.on_create_object_writer(bs, parameters)
            elseif hook == 'onInitMenu' then handler.on_init_menu_writer(bs, parameters)
            elseif hook == 'onShowTextDraw' then handler.on_show_textdraw_writer(bs, parameters)
            elseif hook == 'onVehicleStreamIn' then handler.on_vehicle_stream_in_writer(bs, parameters)
            elseif hook == 'onSetObjectMaterial' then handler.on_set_object_material_writer(bs, parameters, 1)
            elseif hook == 'onSetObjectMaterialText' then handler.on_set_object_material_writer(bs, parameters, 2) end
        end
        raknetEmulRpcReceiveBitStream(hook_table[#hook_table], bs)
        raknetDeleteBitStream(bs)
    end
end
function requestRunner() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end
function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(threadHandle,runner, url, args, resolve, reject)
end
local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок
function tblfromstr(str)
	local a = {}
	for b in str:gmatch('%S+') do
		a[#a+1] = b
	end
	return a
end


function longpollResolve(result)
	if result then
		if not result:sub(1,1) == '{' then
			vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
			return
		end
		local t = decodeJson(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				key = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
		if vknotf.state.v and t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' and tonumber(v.object.from_id) == tonumber(vknotf.user_id.v) and v.object.text then
					if v.object.payload then
						local pl = decodeJson(v.object.payload)
						if pl.button then
							if pl.button == 'getstats' then
								getPlayerArzStats(sendvknotf)
							elseif pl.button == 'getinfo' then
								getPlayerInfo(sendvknotf)
							elseif pl.button == 'gethun' then
								getPlayerArzHun(sendvknotf)
							elseif pl.button == 'lastchat10' then
								lastchatmessage(10,sendvknotf)
							elseif pl.button == 'support' then
								sendvknotf('Команды:\n!send - Отправить сообщение из VK в Игру\n!getplstats - получить статистику персонажа\n!getplhun - получить голод персонажа\n!getplinfo - получить информацию о персонаже\n!sendcode - отправить код с почты\n!sendvk - отправить код из ВК\n!gauth - отправить код из GAuth\n!p/!h - сбросить/принять вызов\n!d [пункт или текст] - ответить на диалоговое окно\n!dc - закрыть диалог\n!screen - сделать скриншот (ОБЯЗАТЕЛЬНО ПРОЧИТАТЬ !helpscreen)\n!helpscreen - помощь по команде !screen\nПоддержка: @notify.arizona')
							elseif pl.button == 'openchest' then
								openchestrulletVK(sendvknotf)
							elseif pl.button == 'activedia' then
								sendDialog(sendvknotf)
							elseif pl.button == 'keyboardkey' then
								sendkeyboradkey()
							elseif pl.button == 'offkey' then
								sendoff()
							elseif pl.button == 'screenkey' then
								sendscreen()
							elseif pl.button == 'keyW' then
								setKeyFromVK('go',sendvknotf)
							elseif pl.button == 'keyA' then
								setKeyFromVK('left',sendvknotf)
							elseif pl.button == 'keyS' then
								setKeyFromVK('back',sendvknotf)
							elseif pl.button == 'keyD' then
								setKeyFromVK('right',sendvknotf)
							elseif pl.button == 'keyALT' then
								sendkeyALT()
							elseif pl.button == 'keyESC' then
								sendkeyESC()
							elseif pl.button == 'primary_dialog' then
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1)
								sampCloseCurrentDialogWithButton(0)
							elseif pl.button == 'secondary_dialog' then
								sampSendDialogResponse(sampGetCurrentDialogId(), 0, -1, -1)
								sampCloseCurrentDialogWithButton(0)
							elseif pl.button == 'offgame' then
								sendvknotf('Выключаю игру')
								wait(1000)
								os.execute("taskkill /f /im gta_sa.exe")
							elseif pl.button == 'offpc' then
								os.execute("shutdown -s -t 30")
								sendvknotf('Компьютер будет выключен через 30 секунд.')
							elseif pl.button == 'phonedown' then
								PickDownPhone()
							elseif pl.button == 'phoneup' then
								PickUpPhone()
							end
						end
						return
					end
					local objsend = tblfromstr(v.object.text)
					local diasend = v.object.text .. ' '
					if objsend[1] == '!getplstats' then
						getPlayerArzStats()
					elseif objsend[1] == '!getplinfo' then
						getPlayerInfo()
					elseif objsend[1] == '!getplhun' then
						getPlayerArzHun()
					elseif objsend[1] == '!p' then
						PickUpPhone()
					elseif objsend[1] == '!h' then
						PickDownPhone()
					elseif objsend[1] == '!screen' then
						sendscreen()
					elseif objsend[1] == '!helpscreen' then
						sendhelpscreenVK()
					elseif objsend[1] == '!send' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampProcessChatInput(args)
							sendvknotf('Сообщение "' .. args .. '" было успешно отправлено в игру')
						else
							sendvknotf('Неправильный аргумент! Пример: !send [строка]')
						end
					elseif objsend[1] == '!sendcode' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampSendDialogResponse(8928, 1, false, (args))
							sendvknotf('Код "' .. args .. '" был успешно отправлен в диалог')
						else
							sendvknotf('Неправильный аргумент! Пример: !sendcode [код]')
					end
					elseif objsend[1] == '!sendvk' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampSendDialogResponse(7782, 1, false, (args))
							sendvknotf('Код "' .. args .. '" был успешно отправлен в диалог')
						else
							sendvknotf('Неправильный аргумент! Пример: !sendvk [код]')
					end
					elseif objsend[1] == '!gauth' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampSendDialogResponse(8929, 1, false, (args))
							sendvknotf('Код "' .. args .. '" был успешно отправлен в диалог')
						else
							sendvknotf('Неправильный аргумент! Пример: !gauth [код]')
					end
					elseif diasend:match('^!d ') then
						diasend = diasend:sub(1, diasend:len() - 1)
						local style = sampGetCurrentDialogType()
						if style == 2 or style > 3 and diasend:match('^!d (%d*)') then
							sampSendDialogResponse(sampGetCurrentDialogId(), 1, tonumber(u8:decode(diasend:match('^!d (%d*)'))) - 1, -1)
						elseif style == 1 or style == 3 then
							sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, u8:decode(diasend:match('^!d (.*)')))
						else
							sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1) -- да
						end
						closeDialog()
					elseif diasend:match('^!dc ') then
						sampSendDialogResponse(sampGetCurrentDialogId(), 0, -1, -1) -- нет
						sampCloseCurrentDialogWithButton(0)
					else
						if diasend and diasend:sub(1, 1) == '/' then
							diasend = diasend:sub(1, diasend:len() - 1)
							sampProcessChatInput(u8:decode(diasend))
						end
						return
					end

				end
			end
		end
	end
end


function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. vknotf.group_id.v .. '&access_token=' .. vknotf.token.v .. '&v=5.81', '', function (result)
		if result then
			if not result:sub(1,1) == '{' then
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = decodeJson(result)
			if t then
				if t.error then
					vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
					return
				end
				server = t.response.server
				ts = t.response.ts
				key = t.response.key
				vkerr = nil
			end
		end
	end)
end
function sendvknotf(msg, host)
	host = host or sampGetCurrentServerName()
	local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) .. '['..select(2,sampGetPlayerIdByCharHandle(playerPed))..']'
	msg = msg:gsub('{......}', '')
	msg = '[ Arizona Notify | Notifications | '..acc..' | '..host..']\n'..msg
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if vknotf.state.v and #vknotf.user_id.v > 0 then
		async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. vknotf.user_id.v .. '&message=' .. msg .. '&access_token=' .. vknotf.token.v .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function sendvknotfv2(msg)
	msg = msg:gsub('{......}', '')
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard2()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if vknotf.state.v and vknotf.user_id.v ~= '' then
		async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. vknotf.user_id.v .. '&message=' .. msg .. '&access_token=' .. vknotf.token.v .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function encodeUrl1(str)
    str = str:gsub(' ', '%+')
    str = str:gsub('\n', '%%0A')
    return u8:encode(str, 'CP1251')
end
function requestRunner2() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end
function threadHandle2(runner2, url2, args2, resolve2, reject2) -- обработка effil потока без блокировок
	local t = runner2(url2, args2)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve2(result) else reject2(result) end
	elseif err then
		reject2(err)
	elseif status == 'canceled' then
		reject2(status)
	end
	t:cancel(0)
end

function async_http_request2(url2, args2, resolve2, reject2)
	local runner2 = requestRunner2()
	if not reject2 then reject2 = function() end end
	lua_thread.create(function()
		threadHandle2(runner2, url2, args2, resolve2, reject2)
	end)
end

function sendtgnotf(msg)
	if tgnotf.state.v then
	host = host or sampGetCurrentServerName()
	local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) .. '['..select(2,sampGetPlayerIdByCharHandle(playerPed))..']'
    msg = msg:gsub('{......}', '')
    msg = '[Notifications | '..acc..' | '..host..']\n'..msg
    msg = encodeUrl1(msg)
	async_http_request2('https://api.telegram.org/bot' .. tgnotf.token.v .. '/sendMessage?chat_id=' .. tgnotf.user_id.v .. '&reply_markup={"keyboard": [["Info", "Stats", "Hungry"], ["Reload Script", "Last 10 lines of chat"], ["Send Dialogs", "Support"], ["Off Game","Off PC"]], "resize_keyboard": true}&text='..msg,'', function(result) end)
	end
end

function getLastUpdate()
	if tgnotf.state.v then 
    async_http_request2('https://api.telegram.org/bot'..tgnotf.token.v..'/getUpdates?chat_id='..tgnotf.user_id.v..'&offset=-1','',function(result)
        if result then
            local proc_table = decodeJson(result)
            if proc_table.ok then
                if #proc_table.result > 0 then
                    local res_table = proc_table.result[1]
                    if res_table then
                        updateid = res_table.update_id
                    end
                else
                    updateid = 1 
					end
                end
            end
        end)
    end
end

function get_telegram_updates()
	if tgnotf.state.v then 
    while not updateid do wait(1) end
    local runner2 = requestRunner2()
    local reject2 = function() end
    local args2 = ''
    while true do
        url2 = 'https://api.telegram.org/bot'..tgnotf.token.v..'/getUpdates?chat_id='..tgnotf.user_id.v..'&offset=-1' -- создаем ссылку
        threadHandle2(runner2, url2, args2, processing_telegram_messages, reject2)
        wait(0)
		end
    end
end

function processing_telegram_messages(result)
    if result and tgnotf.state.v then
        local proc_table = decodeJson(result)
        if proc_table.ok then
            if #proc_table.result > 0 then
                local res_table = proc_table.result[1]
                if res_table then
                    if res_table.update_id ~= updateid then
                        updateid = res_table.update_id
                        local message_from_user = res_table.message.text
						user_idtg = res_table.message.from.id
						if user_idtg == tonumber(tgnotf.user_id.v) then 
                        if message_from_user and tgnotf.sellotvtg.v then
                            local text = u8:decode(message_from_user) .. ' ' 
							if text:match('^Info') then
                                getPlayerInfoTG()
							elseif text:match('^Stats') then
								getPlayerArzStatsTG()
							elseif text:match('^Hungry') then
								getPlayerArzHunTG()
							elseif text:match('^Last 10 lines of chat') then
								lastchatmessageTG(10, sendtgnotf)
							elseif text:match('^!helpscreen') then
								sendhelpscreenTG()
							elseif text:match('^Reload Script') then
								sendtgnotf('Перезагружаю скрипт...')
								thisScript():reload()
								sendtgnotf('Скрипт успешно перезагружен!')
							elseif text:match('^Send Dialogs') then
								sendDialogTG(sendtgnotf)
							elseif text:match('^Support') then
								sendtgnotf('Команды:\n!send - Отправить сообщение из TG в Игру\n!getplstats - получить статистику персонажа\n!getplhun - получить голод персонажа\n!getplinfo - получить информацию о персонаже\n!sendcode - отправить код с почты\n!sendvk - отправить код из ВК\n!gauth - отправить код из GAuth\n!p/!h - сбросить/принять вызов\n!d [пункт или текст] - ответить на диалоговое окно\n!dc - закрыть диалог\n!screen - сделать скриншот (ОБЯЗАТЕЛЬНО ПРОЧИТАТЬ !helpscreen)\n!helpscreen - помощь по команде !screen')
							elseif text:match('^!getplstats') then
								getPlayerArzStatsTG()
							elseif text:match('^!getplinfo') then
                                getPlayerInfoTG()
                            elseif text:match('^!getplhun') then
                                getPlayerArzHunTG()
                            elseif text:match('^!send') then
								text = text:sub(1, text:len() - 1):gsub('!send ','')
								if text ~= '!send' then
									sampProcessChatInput(text)
									sendtgnotf('Сообщение "' .. text .. '" было успешно отправлено в игру')
								else
									sendtgnotf('Сообщение не может быть пустым')
								end
							elseif text:match('^!sendcode') then
								text = text:sub(1, text:len() - 1):gsub('!sendcode ','')
								if text ~= '!sendcode' then
									sampSendDialogResponse(8928, 1, false, (text))
									sendtgnotf('Код "' .. text .. '" был успешно отправлен в диалог')
								else
									sendtgnotf('Неправильный аргумент! Пример: !sendcode [код]')
								end
							elseif text:match('^!sendvk') then
								text = text:sub(1, text:len() - 1):gsub('!sendvk ','')
								if text ~= '!sendvk' then
									sampProcessChatInput(text)
									sendtgnotf('Сообщение "' .. text .. '" было успешно отправлено в игру')
								else
									sendtgnotf('Неправильный аргумент! Пример: !sendvk [код]')
								end
							elseif text:match('^!gauth') then
								text = text:sub(1, text:len() - 1):gsub('!gauth ','')
								if text ~= '!gauth' then
									sampProcessChatInput(text)
									sendtgnotf('Сообщение "' .. text .. '" было успешно отправлено в игру')
								else
									sendtgnotf('Неправильный аргумент! Пример: !gauth [код]')
								end
							elseif text:match('^!screen') then
								sendScreenTg()
							elseif text:match('^Off Game') then
								sendtgnotf('Выключаю игру')
								wait(1000)
								os.execute("taskkill /f /im gta_sa.exe")
							elseif text:match('^Off PC') then
								os.execute("shutdown -s -t 30")
								sendtgnotf('Компьютер будет выключен через 30 секунд.')
							elseif text:match('^!d ') then
								text = text:sub(1, text:len() - 1)
								local style = sampGetCurrentDialogType()
								if (style == 2 or style > 3) and text:match('^!d (%d*)') then
									sampSendDialogResponse(sampGetCurrentDialogId(), 1, tonumber(u8:decode(text:match('^!d (%d*)'))) - 1, -1)
								elseif style == 1 or style == 3 then
									sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, u8:decode(text:match('^!d (.*)')))
								else
									sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1) -- да
								end
								closeDialog()
							elseif text:match('^!dc ') then
								sampSendDialogResponse(sampGetCurrentDialogId(), 0, -1, -1) -- нет
								sampCloseCurrentDialogWithButton(0)
							else
								if text and text:sub(1, 1) == '/' then
									text = text:sub(1, text:len() - 1)
									sampProcessChatInput(u8:decode(text))
								end
								return
							end
						end
                        end
                    end
                end
            end
        end
    end
end

function sendoffpcgame(msg)
	msg = msg:gsub('{......}', '')
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = offboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if vknotf.state.v and vknotf.user_id.v ~= '' then
		async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. vknotf.user_id.v .. '&message=' .. msg .. '&access_token=' .. vknotf.token.v .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function sendphonekey(msg)
	msg = msg:gsub('{......}', '')
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = phonekey()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if vknotf.state.v and vknotf.user_id.v ~= '' then
		async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. vknotf.user_id.v .. '&message=' .. msg .. '&access_token=' .. vknotf.token.v .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function senddialog2(msg)
	msg = msg:gsub('{......}', '')
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = dialogkey()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if vknotf.state.v and vknotf.user_id.v ~= '' then
		async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. vknotf.user_id.v .. '&message=' .. msg .. '&access_token=' .. vknotf.token.v .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function getOnline()
	local countvers = 0
	for i = 0, 999 do
		if sampIsPlayerConnected(i) then
			countvers = countvers + 1
		end
	end
	return countvers
end
function vkKeyboard() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "getinfo"}'
	row[1].action.label = 'Информация'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "getstats"}'
	row[2].action.label = 'Статистика'
	row[3] = {}
	row[3].action = {}
	row[3].color = 'positive'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "gethun"}'
	row[3].action.label = 'Голод'
	keyboard.buttons[2] = {} -- вторая строка кнопок
	row = keyboard.buttons[2]
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "lastchat10"}'
	row[2].action.label = 'Последние 10 строк с чата'
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "openchest"}'
	row[1].action.label = aopen and 'Выключить автооткрытие' or 'Включить автооткрытие'
	keyboard.buttons[3] = {} -- вторая строка кнопок
	row = keyboard.buttons[3]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "activedia"}'
	row[1].action.label = activedia and 'Не отправлять диалоги' or 'Отправлять диалоги'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "support"}'
	row[2].action.label = 'Поддержка'
	keyboard.buttons[4] = {} -- вторая строка кнопок
	row = keyboard.buttons[4]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'primary'
	row[1].action.type = 'text'
    row[1].action.payload = '{"button": "offkey"}'
	row[1].action.label = 'Выключение &#128163;'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'primary'
	row[2].action.type = 'text'
    row[2].action.payload = '{"button": "keyboardkey"}'
	row[2].action.label = 'Управление &#9000;'
	keyboard.buttons[5] = {} -- вторая строка кнопок
	row = keyboard.buttons[5]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'primary'
	row[1].action.type = 'text'
    row[1].action.payload = '{"button": "screenkey"}'
	row[1].action.label = 'Скриншот'
	return encodeJson(keyboard)
end
function sendkeyboradkey()
	vkKeyboard2()
	sendvknotfv2('Клавиши управления игрой')
end
function vkKeyboard2() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'negative'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "primary_dialog"}'
	row[1].action.label = 'OK'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "keyW"}'
	row[2].action.label = 'W'
	row[3] = {}
	row[3].action = {}
	row[3].color = 'negative'
	row[3].action.type = 'text'
    row[3].action.payload = '{"button": "secondary_dialog"}'
	row[3].action.label = 'Cancel'
	row[4] = {}
	row[4].action = {}
	row[4].color = 'negative'
	row[4].action.type = 'text'
    row[4].action.payload = '{"button": "keyALT"}'
	row[4].action.label = 'ALT'
	keyboard.buttons[2] = {} -- вторая строка кнопок
	row = keyboard.buttons[2]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "keyA"}'
	row[1].action.label = 'A'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "keyS"}'
	row[2].action.label = 'S'
	row[3] = {}
	row[3].action = {}
	row[3].color = 'positive'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "keyD"}'
	row[3].action.label = 'D'
	row[4] = {}
	row[4].action = {}
	row[4].color = 'negative'
	row[4].action.type = 'text'
	row[4].action.payload = '{"button": "keyESC"}'
	row[4].action.label = 'ESC'
	return encodeJson(keyboard)
end
function sendoff()
	offboard()
	sendoffpcgame('Что вы хотите выключить?')
end
function sendphonecall()
	phonekey()
	sendphonekey('Вам звонят! Выберите действие.')
end
function offboard() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'negative'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "offpc"}'
	row[1].action.label = 'Компьютер'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "offgame"}'
	row[2].action.label = 'Закрыть игру'
	return encodeJson(keyboard)
end
function phonekey() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'negative'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "phonedown"}'
	row[1].action.label = 'Отклонить'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "phoneup"}'
	row[2].action.label = 'Принять'
	return encodeJson(keyboard)
end
function dialogkey() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "primary_dialog"}'
	row[1].action.label = 'Enter'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'negative'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "secondary_dialog"}'
	row[2].action.label = 'ESC'
	return encodeJson(keyboard)
end
function char_to_hex(str)
	return string.format("%%%02X", string.byte(str))
  end

function url_encode(str)
    local str = string.gsub(str, "\\", "\\")
    local str = string.gsub(str, "([^%w])", char_to_hex)
    return str
end
function getPlayerInfo()
	if isSampLoaded() and isSampAvailable() and sampGetGamestate() == 3 then
		local response = ''
		response = response .. 'HP: ' .. getCharHealth(PLAYER_PED) .. '\n'
		response = response .. 'Armor: ' .. getCharArmour(PLAYER_PED) .. '\n'
		response = response .. 'Money: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n'
		response = response .. 'Online: ' .. getOnline() .. '\n'
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. 'Coords: X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z)
		sendvknotf(response)
	else
		sendvknotf('Вы не подключены к серверу!')
	end
end

function getPlayerInfoTG()
	if isSampLoaded() and isSampAvailable() and sampGetGamestate() == 3 then
		local response = ''
		response = response .. 'HP: ' .. getCharHealth(PLAYER_PED) .. '\n'
		response = response .. 'Armor: ' .. getCharArmour(PLAYER_PED) .. '\n'
		response = response .. 'Money: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n'
		response = response .. 'Online: ' .. getOnline() .. '\n'
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. 'Coords: X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z)
		sendtgnotf(response)
	else
		sendtgnotf('Вы не подключены к серверу!')
	end
end

function getPlayerArzStatsTG()
	if sampIsLocalPlayerSpawned() then
		sendstatsstate = true
		sampSendChat('/stats')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if sendstatsstate ~= true then
				timesendrequest = 0
			end 
		end
		sendtgnotf(sendstatsstate == true and 'Ошибка! В течении 10 секунд скрипт не получил информацию!' or tostring(sendstatsstate))
		sendstatsstate = false
	else
		sendtgnotf('(Error) Персонаж не заспавнен')
	end
end

function getPlayerArzHunTG()
	if sampIsLocalPlayerSpawned() then
		gethunstate = true
		sampSendChat('/satiety')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if gethunstate ~= true then
				timesendrequest = 0
			end 
		end
		sendtgnotf(gethunstate == true and 'Ошибка! В течении 10 секунд скрипт не получил информацию!' or tostring(gethunstate))
		gethunstate = false
	else
		sendtgnotf('(Error) Персонаж не заспавнен')
	end
end

function lastchatmessageTG(intchat, tochat)
	if sampIsLocalPlayerSpawned() then
		print('use: lastchat')
		local allchat = '\n'
		for i = 100-intchat, 99 do
			local getstr = select(1,sampGetChatString(i))
			allchat = allchat .. getstr .. '\n'
		end
		sendtgnotf(allchat)
	else
		sendtgnotf('(Error) Персонаж не заспавнен')
	end
end

sendstatsstate = false
function getPlayerArzStats()
	if sampIsLocalPlayerSpawned() then
		sendstatsstate = true
		sampSendChat('/stats')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if sendstatsstate ~= true then
				timesendrequest = 0
			end 
		end
		if not vknotf.dienable.v then sendvknotf(sendstatsstate == true and 'Ошибка! В течении 10 секунд скрипт не получил информацию!' or tostring(sendstatsstate)) end
		sendstatsstate = false
	else
		sendvknotf('(Error) Персонаж не заспавнен')
	end
end
function lastchatmessage(intchat, tochat)
	if sampIsLocalPlayerSpawned() then
		print('use: lastchat')
		local allchat = '\n'
		for i = 100-intchat, 99 do
			local getstr = select(1,sampGetChatString(i))
			allchat = allchat .. getstr .. '\n'
		end
		sendvknotf(allchat)
	else
		sendvknotf('(Error) Персонаж не заспавнен')
	end
end
function getPlayerArzHun()
	if sampIsLocalPlayerSpawned() then
		gethunstate = true
		sampSendChat('/satiety')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if gethunstate ~= true then
				timesendrequest = 0
			end 
		end
		if not vknotf.dienable.v then sendvknotf(gethunstate == true and 'Ошибка! В течении 10 секунд скрипт не получил информацию!' or tostring(gethunstate)) end
		gethunstate = false
	else
		sendvknotf('(Error) Персонаж не заспавнен')
	end
end
function randomInt() 
    math.randomseed(os.time() + os.clock())
    return math.random(-2147483648, 2147483648)
end 
function sendhelpscreenVK()
	sendvknotf('Инструкция по наладке команды "!screen":\n\nКоманда !screen работает следующим образом:\n• Если игра свёрнута - произойдет краш скрипта\n• Если игра на весь экран - придёт просто белый скриншот.\n• Чтобы сработало идеально - нужно сделать игру в оконный режим и растянуть на весь экран (на лаунчере можно просто в настройках лаунчера включить оконный режим).\n• Для работы команды нужно скачать необходимые библиотеки (скачать можно в меню VK/TG Notifications)')
end
function sendhelpscreenTG()
	sendtgnotf('Инструкция по наладке команды "!screen":\n\nКоманда !screen работает следующим образом:\n• Если игра свёрнута - произойдет краш скрипта\n• Если игра на весь экран - придёт просто белый скриншот.\n• Чтобы сработало идеально - нужно сделать игру в оконный режим и растянуть на весь экран (на лаунчере можно просто в настройках лаунчера включить оконный режим).\n• Для работы команды нужно скачать необходимые библиотеки (скачать можно в меню VK/TG Notifications)')
end
function sendscreen()
	if vknotf.state.v then 
	local d3dx9_43 = ffi.load('d3dx9_43.dll')
    local pDevice = ffi.cast("struct d3ddevice*", 0xC97C28)
    local CreateOffscreenPlainSurface =  ffi.cast("long(__stdcall*)(void*, unsigned long, unsigned long, unsigned long, unsigned long, void**, void*)", pDevice.vtbl[0].CreateOffscreenPlainSurface)
    local GetFrontBufferData =  ffi.cast("long(__stdcall*)(void*, unsigned long, void*)", pDevice.vtbl[0].GetFrontBufferData)
    local pSurface = ffi.cast("void**", ffi.new('unsigned long[1]'))
    local sx = ffi.C.GetSystemMetrics(0);
    local sy = ffi.C.GetSystemMetrics(1);
    CreateOffscreenPlainSurface(pDevice, sx, sy, 21, 3, pSurface, ffi.cast("void*", 0))
    if GetFrontBufferData(pDevice, 0, pSurface[0]) < 0 then
    else
        local Point = ffi.new("struct POINT[1]")
        local Rect = ffi.new("struct RECT[1]")
        local HWND = ffi.cast("int*", 0xC97C1C)[0]
        ffi.C.ClientToScreen(HWND, Point)
        ffi.C.GetClientRect(HWND, Rect)
        Rect[0].left = Rect[0].left + Point[0].x
        Rect[0].right = Rect[0].right + Point[0].x
        Rect[0].top = Rect[0].top + Point[0].y
        Rect[0].bottom = Rect[0].bottom + Point[0].y
        d3dx9_43.D3DXSaveSurfaceToFileA("1.png", 3, pSurface[0], ffi.cast("void*", 0), Rect) -- second parameter(3) is D3DXIMAGE_FILEFORMAT, checkout https://docs.microsoft.com/en-us/windows/win32/direct3d9/d3dximage-fileformat
        sendPhoto(getGameDirectory()..'/1.png') -- отправка фотки после скрина
		end
	end
end

function uploadPhoto(filename, uploadUrl) 
	if vknotf.state.v then 
    local fileHandle = io.open(filename,"rb") 
    if (fileHandle) then 
      local fileContent = fileHandle:read( "*a" )
      fileHandle:close()
      local boundary = 'abcd'
      local header_b = 'Content-Disposition: form-data; name="file"; filename="' .. filename .. '"\r\nContent-Type: image/png\r\n'
      local fileContent =  '--' ..boundary .. '\r\n' ..header_b ..'\r\n'.. fileContent .. '\r\n--' .. boundary ..'--\r\n'
      local resp = requests.post(uploadUrl, {
        headers = {
          ["Content-Length"] =  fileContent:len(), 
          ['Content-Type'] = 'multipart/form-data; boundary=' .. boundary    
        },
        data = fileContent
      })
      return resp.json()
		end
    end
end

function sendPhoto(path) 
	if vknotf.state.v then 
    local upResponse = requests.post(("https://api.vk.com/method/photos.getMessagesUploadServer?peer_id=%d&access_token=%s&v=5.131"):format(vknotf.user_id.v, vknotf.token.v)).json()
    local uploadedResponse = uploadPhoto(path, upResponse.response.upload_url)
    local saveResponse = requests.post(("https://api.vk.com/method/photos.saveMessagesPhoto?server=%d&photo=%s&hash=%s&access_token=%s&v=5.131"):format(uploadedResponse.server,uploadedResponse.photo,uploadedResponse.hash, vknotf.token.v)).json()
    local image = saveResponse.response[1]
    local att_image = ("photo%d_%d_%s"):format(image.owner_id, image.id, image.access_key)
    os.remove(getGameDirectory()..'/1.png') -- Удаление фотки с глаз долой 
    return requests.post(("https://api.vk.com/method/messages.send?peer_id=%d&attachment=%s&access_token=%s&random_id=%d&v=5.131"):format(vknotf.user_id.v, att_image, vknotf.token.v, randomInt()))
	end
end

function sendScreenTg()
	if tgnotf.state.v then 
	local d3dx9_43 = ffi.load('d3dx9_43.dll')
    local pDevice = ffi.cast("struct d3ddevice*", 0xC97C28)
    local CreateOffscreenPlainSurface =  ffi.cast("long(__stdcall*)(void*, unsigned long, unsigned long, unsigned long, unsigned long, void**, void*)", pDevice.vtbl[0].CreateOffscreenPlainSurface)
    local GetFrontBufferData =  ffi.cast("long(__stdcall*)(void*, unsigned long, void*)", pDevice.vtbl[0].GetFrontBufferData)
    local pSurface = ffi.cast("void**", ffi.new('unsigned long[1]'))
    local sx = ffi.C.GetSystemMetrics(0);
    local sy = ffi.C.GetSystemMetrics(1);
    CreateOffscreenPlainSurface(pDevice, sx, sy, 21, 3, pSurface, ffi.cast("void*", 0))
    if GetFrontBufferData(pDevice, 0, pSurface[0]) < 0 then
    else
        local Point = ffi.new("struct POINT[1]")
        local Rect = ffi.new("struct RECT[1]")
        local HWND = ffi.cast("int*", 0xC97C1C)[0]
        ffi.C.ClientToScreen(HWND, Point)
        ffi.C.GetClientRect(HWND, Rect)
        Rect[0].left = Rect[0].left + Point[0].x
        Rect[0].right = Rect[0].right + Point[0].x
        Rect[0].top = Rect[0].top + Point[0].y
        Rect[0].bottom = Rect[0].bottom + Point[0].y
        d3dx9_43.D3DXSaveSurfaceToFileA("1.png", 3, pSurface[0], ffi.cast("void*", 0), Rect) -- second parameter(3) is D3DXIMAGE_FILEFORMAT, checkout https://docs.microsoft.com/en-us/windows/win32/direct3d9/d3dximage-fileformat
        sendPhotoTg() -- отправка фотки после скрина
		end
	end
end

function sendPhotoTg()
	lua_thread.create(function ()
            local result, response = telegramRequest(
                'POST', --[[ https://en.wikipedia.org/wiki/POST_(HTTP) ]]--
                'sendPhoto', --[[ https://core.telegram.org/bots/api#sendphoto ]]--
                { --[[ Аргументы, см. https://core.telegram.org/bots/api#sendphoto ]]--
                    ['chat_id']    = tgnotf.user_id.v,  --[[ chat_id ]]--
                },
                { --[[ Сам файл, сюда можно передавать как PATH(Путь к файлу), так и FILE_ID(См. https://core.telegram.org/bots/) ]]--
                    ['photo'] = string.format(getGameDirectory()..'/1.png') --[[ или же ==getWorkingDirectory() .. '\\smirk.png'== ]]--
                },
                tgnotf.token.v --[[ Токен Бота ]]
            )
	end)
end
function sendkeyALT()
	setVirtualKeyDown(18, true)
	setVirtualKeyDown(18, false)
end
function sendkeyESC()
	sampSendClickTextdraw(65535)
end
function setKeyFromVK(getkey)
	if isSampLoaded() and isSampAvailable() and sampIsLocalPlayerSpawned() then
		sendvknotf('Отправлено нажатие на клавишу '..getkey)
		local timepress = os.time()
		if getkey == 'go' then
			print('key set go')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(1,-1024) end
			setGameKeyState(1,0)
		elseif getkey == 'back' then
			print('key set back')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(1,1024) end
			setGameKeyState(1,0)
		elseif getkey == 'left' then
			print('key set left')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(0,-1024) end
			setGameKeyState(0,0)
		elseif getkey == 'right' then
			print('key set right')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(0,1024) end
			setGameKeyState(0,0)
		end
	else
		sendvknotf('Ваш персонаж не заспавнен!')
	end
end
function telegramRequest(requestMethod, telegramMethod, requestParameters, requestFile, botToken, debugMode)
	local multipart = require('multipart-post')
	local dkjson    = require('dkjson')
    --[[ Arguments Part ]]--
    --[[ Argument #1 (requestMethod) ]]--
    local requestMethod = requestMethod or 'POST'
    if (type(requestMethod) ~= 'string') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #1(requestMethod) Must Be String.')
    end
    if (requestMethod ~= 'POST' and requestMethod ~= 'GET' and requestMethod ~= 'PUT' and requestMethod ~= 'DETELE') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #1(requestMethod) Dont Have "%s" Request Method.', tostring(requestMethod))
    end
    --[[ Argument #2 (telegramMethod) ]]--
    local telegramMethod = telegramMethod or nil
    if (type(requestMethod) ~= 'string') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #2(telegramMethod) Must Be String.\nCheck: https://core.telegram.org/bots/api')
    end
    --[[ Argument #3 (requestParameters) ]]--
    local requestParameters = requestParameters or {}
    if (type(requestParameters) ~= 'table') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #3(requestParameters) Must Be Table.')
    end
    for key, value in ipairs(requestParameters) do
        if (#requestParameters ~= 0) then
            requestParameters[key] = tostring(value)
        else
            requestParameters = {''}
        end
    end
    --[[ Argument #4 (botToken) ]]--
    local botToken = botToken or nil
    if (type(botToken) ~= 'string') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #4(botToken) Must Be String.')
    end
    --[[ Argument #5 (debugMode) ]]--
    local debugMode = debugMode or false
    if (type(debugMode) ~= 'boolean') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #5(debugMode) Must Be Boolean.')
    end

    if (requestFile and next(requestFile) ~= nil) then
        local fileType, fileName = next(requestFile)
        local file = io.open(fileName, 'rb')
        if (file) then
            lua_thread.create(function ()
                requestParameters[fileType] = {
                    filename = fileName,
                    data = file:read('*a')
                }
            end)
            file:close()
        else
            requestParameters[file_type] = fileName
        end
    end

    local requestData = {
        ['method'] = tostring(requestMethod),
        ['url']    = string.format('https://api.telegram.org/bot%s/%s', tostring(botToken), tostring(telegramMethod))
    }

    local body, boundary = multipart.encode(requestParameters)

    --[[ Request Part ]]--
    local thread = effil.thread(function (requestData, body, boundary)
        local response = {}

        --[[ Include Libraries ]]--
        local channel_library_requests = require('ssl.https')
        local channel_library_ltn12    = require('ltn12')

        --[[ Manipulations ]]--
        local _, source = pcall(channel_library_ltn12.source.string, body)
        local _, sink   = pcall(channel_library_ltn12.sink.table, response)

        --[[ Request ]]--
        local result, _ = pcall(channel_library_requests.request, {
                ['url']     = requestData['url'],
                ['method']  = requestData['method'],
                ['headers'] = {
                    ['Accept']          = '*/*',
                    ['Accept-Encoding'] = 'gzip, deflate',
                    ['Accept-Language'] = 'en-us',
                    ['Content-Type']    = string.format('multipart/form-data; boundary=%s', tostring(boundary)),
                    ['Content-Length']  = #body
                },
                ['source']  = source,
                ['sink']    = sink
        })
        if (result) then
            return { true, response }
        else
            return { false, response }
        end
    end)(requestData, body, boundary)

    local result = thread:get(0)
    while (not result) do
        result = thread:get(0)
        wait(0)
    end
    --[[ Running || Paused || Canceled || Completed || Failed ]]--
    local status, error = thread:status()
    if (not error) then
        if (status == 'completed') then
            local response = dkjson.decode(result[2][1])
            --[[ result[1] = boolean ]]--
            if (result[1]) then
                return true, response
            else
                return false, response
            end
        elseif (status ~= 'running' and status ~= 'completed') then
            return false, string.format('[TelegramLibrary] Error; Effil Thread Status was: %s', tostring(status))
        end
    else
        return false, error
    end
    thread:cancel(0)
end
function openchestrulletVK()
	if isSampLoaded() and isSampAvailable() and sampIsLocalPlayerSpawned() then
		if roulette.standart.v or roulette.donate.v or roulette.platina.v or roulette.mask.v or roulette.tainik.v then
			aopen = not aopen
			if aopen then 
				checkrulopen:run()
				ANsets.v = false
			else 
				lua_thread.terminate(checkrulopen) 
			end
			sendvknotf('Автооткрытие '..(aopen and 'включено!' or 'выключено!'))
		else
			sendvknotf("Включите сундук с рулетками!")
		end
	else
		sendvknotf('Ваш персонаж не заспавнен!')
	end
end
function sendDialog()
	activedia = not activedia
	if activedia then 
	vknotf.dienable.v = true
	sendvknotf('Отправка диалогов в VK включена.')
	else
	vknotf.dienable.v = false
	sendvknotf('Отправка диалогов в VK отключена.')
	end
end
function sendDialogTG()
	activedia = not activedia
	if activedia then 
	tgnotf.dienable.v = true
	sendtgnotf('Отправка диалогов в TG включена.')
	else
	tgnotf.dienable.v = false
	sendtgnotf('Отправка диалогов в TG отключена.')
	end
end
function openchestrullet()
	if sampIsLocalPlayerSpawned() then
		if roulette.standart.v or roulette.donate.v or roulette.platina.v or roulette.mask.v or roulette.tainik.v then
			aopen = not aopen
			ANMessage('Автооткрытие '..(aopen and 'включено!' or 'выключено!'))
			if aopen then 
				checkrulopen:run()
				ANsets.v = false
			else 
				lua_thread.terminate(checkrulopen) 
			end
		else
			ANMessage("Включите сундук с рулетками!")
		end
	else
		ANMessage("Ваш персонаж не заспавнен!")
	end
end
bizpiaron = false
idsshow = false
function vkget()
	longpollGetKey()
	local reject, args = function() end, ''
	while not key do 
		wait(1)
	end
	local runner = requestRunner()
	while true do
		while not key do wait(0) end
		url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
		threadHandle(runner, url, args, longpollResolve, reject)
		wait(100)
	end
end
function bizpiar()
	while true do wait(0)
		if bizpiaron then
			sampSendChat(u8:decode(piar.piar1.v))
			vknotf.dienable.v = false
			wait(5000)
			vknotf.dienable.v = true
			wait(piar.piarwait.v * 1000)
		end
	end
end
function bizpiar2()
	while true do wait(0)
		if bizpiaron then
			if piar.piar2.v:len() > 0 then
				sampSendChat(u8:decode(piar.piar2.v))
				vknotf.dienable.v = false
				wait(5000)
				vknotf.dienable.v = true
				wait(piar.piarwait2.v * 1000)
			end
		end
	end
end
function bizpiar3()
	while true do wait(0)
		if bizpiaron then
			if piar.piar3.v:len() > 0 then
				sampSendChat(u8:decode(piar.piar3.v))
				vknotf.dienable.v = false
				wait(5000)
				vknotf.dienable.v = true
				wait(piar.piarwait3.v * 1000)
			end
		end
	end
end
bizpiarhandle = lua_thread.create_suspended(bizpiar) 
bizpiarhandle2 = lua_thread.create_suspended(bizpiar2) 
bizpiarhandle3 = lua_thread.create_suspended(bizpiar3) 
function activatePiar(bbiza)
	if bbiza then 
		bizpiarhandle:run()
		bizpiarhandle2:run()
		bizpiarhandle3:run()
	else 
		bizpiarhandle:terminate()
		bizpiarhandle2:terminate()
		bizpiarhandle3:terminate()
	end
end

function libs()
	downloadUrlToFile('https://github.com/SMamashin/ANTools/raw/main/resource/fonts/fontawesome-webfont.ttf',
	'moonloader\\resource\\ANTools\\Fonts\\fontawesome-webfont.ttf', 
	'fontawesome-webfont.ttf')
	
	downloadUrlToFile('https://github.com/SMamashin/ANTools/raw/main/resource/ANTools/script_banner.png',
	'moonloader\\resource\\ANTools\\script_banner.png', 
	'script_banner.png')

end
 

function main()
    while not isSampAvailable() do
        wait(0)
	end
	libs()
	getLastUpdate()
	if piar.auto_piar.v and (os.time() - piar.last_time) <= piar.auto_piar_kd.v then
		lua_thread.create(function()
			while not sampIsLocalPlayerSpawned() do wait(0) end
			bizpiaron = true
			activatePiar(bizpiaron)
			ANMessage('[АвтоПиар] Пиар включен т.к прошло меньше чем '..piar.auto_piar_kd.v..' секунд после последней выгрузки')
		end)
	end
	local _a = [[Скрипт успешно запущен!
Версия: %s
Открыть меню: /ANTools
Авторы: Bakhusse & Mamashin.]]
	if autoupdateState.v then
		updates:autoupdate()
	else
		updates:getlast()
	end
	ANMessage(_a:format(thisScript().version))
	sampRegisterChatCommand('eattest',function() gotoeatinhouse = true; sampSendChat('/home') end)
	sampRegisterChatCommand('ANTools',function() ANsets.v = not ANsets.v end)
	sampRegisterChatCommand('ANreload',function() thisScript():reload() end)
	sampRegisterChatCommand('ANunload',function() thisScript():unload() end)
	sampRegisterChatCommand('ANsrec', function() 
		if handle_aurc then
			handle_aurc:terminate()
			handle_aurc = nil
			ANMessage('Автореконнект остановлен!')
		else
			ANMessage('Вы сейчас не ожидаете автореконнекта!')
		end
		if handle_rc then
			handle_rc:terminate()
			handle_rc = nil
			ANMessage('Реконнект остановлен!')
		else
			ANMessage('Вы сейчас не ожидаете реконнекта!')
		end
	end)
	sampRegisterChatCommand('ANrec',function(a)
		a = a and (tonumber(a) and tonumber(a) or 1) or 1
		reconstandart(a)
	end)
	if fastconnect.v then
		sampFastConnect(fastconnect.v)
	end
	workpaus(antiafk.v)
	lua_thread.create(vkget)
	lua_thread.create(get_telegram_updates)
    while true do 
		wait(0)
        imgui.Process = ANsets.v or #_message>0
		imgui.ShowCursor = ANsets.v
		if idsshow then
            local alltextdraws = sampGetAllTextDraws()
            for _, v in pairs(alltextdraws) do
                local fX,fY = sampTextdrawGetPos(v)
                local fX,fY = convertGameScreenCoordsToWindowScreenCoords(fX,fY)	
                renderFontDrawText(font2,tostring(v),tonumber(fX),tonumber(fY),0xD7FFFFFF)
            end
		end
    end
end
function convertHexToImVec4(hex,alp)
	alp = alp or 255 
	local r,g,b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
	return imgui.ImVec4(r/255,g/255,b/255,alp/255)
end
function convertImVec4ToU32(imvec)
	return imgui.ImColor(imvec):GetU32()
end

--// Крутецкие отступы на 5 //--

function stepace5()
	for i = 1, 5 do

	imgui.Spacing()

	end

end

--рендер уведов
function onRenderNotification()
	local count = 0
	for k, v in ipairs(_message) do
		local push = false
		if v.active and v.time < os.clock() then
			v.active = false
			table.remove(_message, k)
		end
		if count < 10 then
			if not v.active then
				if v.showtime > 0 then
					v.active = true
					v.time = os.clock() + v.showtime
					v.showtime = 0
				end
			end
			if v.active then
				count = count + 1
				if v.time + 3.000 >= os.clock() then
					imgui.PushStyleVar(imgui.StyleVar.Alpha, (v.time - os.clock()) / 0.3)
					push = true
				end
				local nText = u8(tostring(v.text))
				notfList.size = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize, 200.0, 196.0, nText)
				notfList.pos = imgui.ImVec2(notfList.pos.x, (notfList.pos.y - (count == 1 and notfList.size.y or (notfList.size.y + 60))))
				imgui.SetNextWindowPos(notfList.pos, _, imgui.ImVec2(0.0, 0.0))
				imgui.SetNextWindowSize(imgui.ImVec2(200, notfList.size.y + imgui.GetStyle().ItemSpacing.y + imgui.GetStyle().WindowPadding.y+45))
				imgui.Begin(u8'##msg' .. k, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
				imgui.RenderMsgLogo() imgui.SameLine() imgui.CenterText("AN Tools")
				imgui.Separator()
				imgui.TextWrapped(nText)
				imgui.End()
				if push then
					imgui.PopStyleVar()
				end
			end
		end
	end
	notfList = list:new()
end
--imgui: элементы акков
function autofillelementsaccs()
	if imgui.Button(u8('Временные данные')) then menufill = 1 end
	imgui.SameLine()
	if imgui.Button(u8('Добавить аккаунт')) then
		imgui.OpenPopup('##addacc')
	end
	if imgui.BeginPopupModal('##addacc',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
		imgui.CenterText(u8('Добавить новый аккаунт'))
		imgui.Separator()
		imgui.CenterText(u8('Ник'))
		imgui.Separator()
		imgui.InputText('##nameadd',addnew.name)
		imgui.Separator()
		imgui.CenterText(u8('Пароль'))
		imgui.Separator()
		imgui.InputText('##addpas',addnew.pass)
		imgui.Separator()
		imgui.CenterText(u8('ID Диалога'))
		imgui.SameLine()
		imgui.TextQuestion(u8('ID Диалога в который надо ввести пароль\nНесколько ID для Arizona RP\n	2 - Диалог ввода пароля\n	991 - Диалог PIN-Кода банка'))
		imgui.Separator()
		imgui.InputInt('##dialogudadd',addnew.dialogid)
		imgui.Separator()
		imgui.CenterText(u8('IP сервера'))
		imgui.SameLine()
		imgui.TextQuestion(u8('IP Сервера, на котором будет введен пароль\nПример: 185.169.134.171:7777'))
		imgui.Separator()
		imgui.InputText('##ipport',addnew.serverip)
		imgui.Separator()
		if imgui.Button(u8("Добавить"), imgui.ImVec2(-1, 20)) then
			if addnew:save() then
				imgui.CloseCurrentPopup()
			end
		end
		if imgui.Button(u8("Закрыть"), imgui.ImVec2(-1, 20)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
	imgui.SameLine()
	imgui.Checkbox(u8('Включить'),autologin.state); imgui.SameLine(); imgui.TextQuestion(u8('Включает автозаполнение в диалоги'))
	imgui.SameLine()
	imgui.CenterText(u8'Автозаполнение ' .. fa.ICON_PENCIL_SQUARE); imgui.SameLine()
	imgui.SameLine(838)
	if imgui.Button(u8('Обновить')) then
		local f = io.open(file_accs, "r")
		if f then
			savepass = decodeJson(f:read("a*"))
			f:close()
		end
		ANMessage('Подгруженны новые данные')
	end
	imgui.Columns(3, _, true)
	imgui.Separator()
	imgui.SetColumnWidth(-1, 150); imgui.Text(u8"   Никнейм"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 150); imgui.Text(u8"Сервер"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 450); imgui.Text(u8"Пароли"); imgui.NextColumn()
	for k, v in pairs(savepass) do
		imgui.Separator()
		if imgui.Selectable(u8('   '..v[1]..'##'..k), false, imgui.SelectableFlags.SpanAllColumns) then imgui.OpenPopup('##acc'..k) end
		if imgui.BeginPopupModal('##acc'..k,true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
			btnWidth2 = (imgui.GetWindowWidth() - 22)/2
			imgui.CreatePaddingY(8)
			imgui.CenterText(u8('Аккаунт '..v[1]))
			imgui.Separator()
			for f,t in pairs(v[3]) do
				imgui.Text(u8('Диалог[ID]: '..v[3][f].id..' Введённые данные: '..v[3][f].text))
				if editpass.numedit == f then
					imgui.PushItemWidth(-1)
					imgui.InputText(u8'##pass'..f,editpass.input)
					imgui.PopItemWidth()
					if imgui.Button(u8("Подтвердить##"..f), imgui.ImVec2(-1, 20)) then
						v[3][f].text = editpass.input.v
						editpass.input.v = ''
						editpass.numedit = -1
						saveaccounts()
					end
				elseif editpass.numedit == -1 then
					if imgui.Button(u8("Сменить пароль##2"..f), imgui.ImVec2(-1, 20)) then
						editpass.input.v = v[3][f].text
						editpass.numedit = f
					end
				end
				if imgui.Button(u8("Скопировать##"..f), imgui.ImVec2(btnWidth2, 0)) then
					setClipboardText(v[3][f].text)
					imgui.CloseCurrentPopup()
				end
				imgui.SameLine()
				if imgui.Button(u8("Удалить##"..f), imgui.ImVec2(btnWidth2, 0)) then
					v[3][f] = nil
					if #v[3] == 0 then
						savepass[k] = nil
					end
					saveaccounts()
				end
				imgui.Separator()
			end
			if imgui.Button(u8("Подключиться"), imgui.ImVec2(-1, 20)) then
				local ip2, port2 = string.match(v[2], "(.+)%:(%d+)")
				reconname(v[1],ip2, tonumber(port2))
			end
			if imgui.Button(u8("Удалить все данные"), imgui.ImVec2(-1, 20)) then
				savepass[k] = nil
				imgui.CloseCurrentPopup()
				saveaccounts()
			end
			if imgui.Button(u8("Закрыть##sdosodosdosd"), imgui.ImVec2(-1, 20)) then
				imgui.CloseCurrentPopup()
			end
			imgui.CreatePaddingY(8)
			imgui.EndPopup()
		end
		imgui.NextColumn()
		imgui.Text(tostring(v[2]))
		imgui.NextColumn()
		imgui.Text(u8('Кол-во паролей: '..#v[3]..'. Нажмите ЛКМ для управления паролями'))
		imgui.NextColumn()
	end
	imgui.Columns(1)
	imgui.Separator()
end
--imgui: элементы сейва
function autofillelementssave()
	if imgui.Button(u8'< Аккаунты') then menufill = 0 end
	imgui.SameLine()
	imgui.CenterText(u8'Автозаполнение')
	imgui.SameLine(838) 
	if imgui.Button(u8('Очистка')) then temppass = {}; ANMessage('Буфер временных паролей очищен!') end
	imgui.Columns(5, _, true)
	imgui.Separator()--710
	imgui.SetColumnWidth(-1, 130); imgui.Text(u8"Диалог[ID]"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 150); imgui.Text(u8"Никнейм"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 140); imgui.Text(u8"Сервер"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 170); imgui.Text(u8"Введенные данные"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 140); imgui.Text(u8"Время"); imgui.NextColumn()
	for k, v in pairs(temppass) do
		if imgui.Selectable('   '..tostring(u8(string.gsub(v.title, "%{.*%}", "") .. "[" .. v.id .. "]")) .. "##" .. k, false, imgui.SelectableFlags.SpanAllColumns) then
			saveacc(k)
			saveaccounts()
			ANMessage('Пароль '..v.text..' для аккаунта '..v.nick..' на сервере '..v.ip..' сохранён!')
		end
		imgui.NextColumn()
		imgui.Text(tostring(v.nick))
		imgui.NextColumn()
		imgui.Text(tostring(v.ip))
		imgui.NextColumn()
		imgui.Text(tostring(u8(v.text)))
		imgui.NextColumn()
		imgui.Text(tostring(v.time))
		imgui.NextColumn()
	end
	imgui.Columns(1)
	imgui.Separator()
end

-- Шрифт v4(кринж пиздец) -- 

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ANTools/fonts/fontawesome-webfont.ttf', 15, font_config, fa_glyph_ranges)

    end
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end

function imgui.OnDrawFrame()
	if ANsets.v then
		local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed)))
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(920,470))
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2,sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
		-- imgui.PushStyleVar(imgui.StyleVar.WindowPadding,imgui.ImVec2(0,0))
		imgui.Begin('##ANTools',ANsets,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		if menunum > 0 then
			imgui.SetCursorPos(imgui.ImVec2(12,8))
			if imgui.Button('<',imgui.ImVec2(20,34)) then
				menunum = 0
			end
		end
		-- imgui.SetCursorPosX(350) -- позволяет задать положение функции по горизнотали
		-- imgui.SetCursorPosY(85) -- позволяет задать положение функции по вертикали
		local hostserver = sampGetCurrentServerName()
		imgui.SetCursorPos(imgui.ImVec2(40,8)) -- Author: neverlane(ronnyevans)\n
		imgui.RenderLogo() imgui.SameLine() imgui.Dummy(imgui.ImVec2(20, 0)) imgui.SameLine() imgui.Text(u8('\nDev/Support: PhanLom\nАккаунт: ' ..acc))
		imgui.SetCursorPos(imgui.ImVec2(516,8))
		imgui.BeginGroup()
		imgui.Text(u8('Версия -> Текущая: '..thisScript().version..' | Актуальная: '..(updates.data.result and updates.data.relevant_version or 'Error')))
		if imgui.Button(u8('Проверить обновление'),imgui.ImVec2(150,20)) then
			updates:getlast()
		end
		imgui.SameLine()
		local renderdownloadupd = (updates.data.result and updates.data.relevant_version ~= thisScript().version) and imgui.Button or imgui.ButtonDisabled
		if renderdownloadupd(u8('Загрузить обновление'),imgui.ImVec2(150,20)) then
			if updates.data.result and updates.data.relevant_version ~= thisScript().version then
				updates:download()
			end
		end
		imgui.EndGroup()
		imgui.SetCursorPos(imgui.ImVec2(880,25))
		imgui.CloseButton(6.5)
		imgui.SetCursorPos(imgui.ImVec2(0,60))
		imgui.Separator()

		-- Buttons on main menu script -- 


		if menunum == 0 then
			local buttons = {
				{fa.ICON_USER .. u8(' Основное'),1,u8('Настройка основных функций')},
				{fa.ICON_PENCIL_SQUARE .. u8(' Автозаполнение'),2,u8('Автоввод текста в диалоги')},
				{fa.ICON_CUTLERY .. u8(' Авто-еда'),3,u8('Авто-еда & Авто-хилл')},
				{fa.ICON_INFO .. u8(' Информация'),4,u8('Полезная информация о проекте')},
				{fa.ICON_HISTORY .. u8(' История обновлений'),5,u8('Список изменений которые\n	 произошли в скрипте')},
				{fa.ICON_COGS .. u8(' Кастомизация'),6,u8('Выбор стиля, изменение темы скирпта')},
				{fa.ICON_SEARCH .. u8(' Поиск в чате'),7,u8('Отправляет нужные сообщения \n                  с чата в ') .. fa.ICON_VK .. u8(' и ') .. fa.ICON_TELEGRAM},
				{fa.ICON_VK .. u8(' Notifications'),8,u8('Уведомления в ВКонтакте')},
				{fa.ICON_TELEGRAM .. u8(' Notifications'),9,u8('Уведомления в Telegram')}
			}

			local function renderbutton(i)
				local name,set,desc,func = buttons[i][1],buttons[i][2],buttons[i][3],buttons[i][4]
				local getpos2 = imgui.GetCursorPos()
				imgui.SetCursorPos(getpos2)
				if imgui.Button('##'..name..'//'..desc,imgui.ImVec2(240,80)) then
					if func then
						pcall(func)
					else
						menunum = set
					end
				end 
				imgui.SetCursorPos(getpos2)
				imgui.BeginGroup()
				imgui.CreatePadding(240/2-imgui.CalcTextSize(name).x/2,15)
				imgui.Text(name)
				imgui.CreatePadding(240/2-imgui.CalcTextSize(desc).x/2,(80/2-imgui.CalcTextSize(desc).y/2)-25)
				imgui.Text(desc)
				imgui.EndGroup()
				imgui.SetCursorPos(imgui.ImVec2(getpos2.x,getpos2.y+90))
			end
			imgui.CreatePaddingY(20)
			local cc = 1
			local startY = 120 
			for i = 1, #buttons do
				local poss = {
					80,
					330,
					580
				}
				imgui.SetCursorPos(imgui.ImVec2(poss[cc],startY))
				renderbutton(i)
				if cc == #poss then
					cc = 0
					startY = startY + 90
				end
				cc = cc + 1
			end
			imgui.SetCursorPos(imgui.ImVec2(920/2 - 300/2,400))
			imgui.BeginGroup()
			if imgui.Button(u8('Сохранить настройки'),imgui.ImVec2(150,30)) then saveini() end
			imgui.SameLine()
			if imgui.Button(u8('Перезагрузить скрипт'),imgui.ImVec2(150,30)) then thisScript():reload() end
			imgui.EndGroup()
		
		-- Раздел основных настроек -- 	

		elseif menunum == 1 then
			welcomeText = not imgui.TextColoredRGB("") 
			PaddingSpace()
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.Separator()
			imgui.CenterText(u8('Автореконнект'))
			imgui.Separator()
			PaddingSpace()
			imgui.Checkbox(u8('Включить автореконнект'), arec.state)
			if arec.state.v then
				imgui.Checkbox(u8('Включить автореконнект при You are banned from this server'), arec.statebanned)
			    imgui.SameLine()
			    imgui.PushItemWidth(80)
				imgui.Spacing()
			    imgui.InputInt(u8('Задержка(сек)###arec'),arec.wait)
			    imgui.PopItemWidth()
			end
			PaddingSpace()
			imgui.Separator()
			imgui.CenterText(u8('Автоматическая отправка сообщений'))
			imgui.Separator()
			PaddingSpace()
			imgui.BeginGroup()
			imgui.PushItemWidth(400)
			imgui.InputText(u8('1 Строка'),piar.piar1)
			imgui.SameLine()
			imgui.TextQuestion(u8('Обязательная строка'))
			imgui.InputText(u8('2 Строка'),piar.piar2)
			imgui.SameLine()
			imgui.TextQuestion(u8('Оставьте строку пустую если не хотите её использовать'))
			imgui.InputText(u8('3 Строка'),piar.piar3)
			imgui.SameLine()
			imgui.TextQuestion(u8('Оставьте строку пустую если не хотите её использовать'))
			imgui.PopItemWidth()
			imgui.EndGroup()
		
			imgui.SameLine()
		
			imgui.BeginGroup()
			imgui.PushItemWidth(80)
			imgui.InputInt(u8('Задержка(сек.)##piar1'),piar.piarwait); 
			imgui.InputInt(u8('Задержка(сек.)##piar2'),piar.piarwait2); 
			imgui.InputInt(u8('Задержка(сек.)##piar3'),piar.piarwait3); 
			imgui.PopItemWidth()
			imgui.EndGroup()
			if imgui.Button(u8('Активировать флудер')) then 
			    bizpiaron = not bizpiaron
			    activatePiar(bizpiaron)
			    ANMessage(bizpiaron and 'Пиар включён!' or 'Пиар выключен!',5)
			end
			imgui.SameLine()
			imgui.Checkbox(u8('АвтоПиар'),piar.auto_piar) 
			imgui.SameLine()
			imgui.TextQuestion(u8('Если после последнего выгружения скрипта пройдет меньше указанного(в настройках) времени, включиться автопиар'))
			if piar.auto_piar.v then
			    imgui.SameLine()
			    imgui.PushItemWidth(120)
			    if imgui.InputInt(u8('Максимальное время для включения пиара(в сек.)##autpiar'),piar.auto_piar_kd) then
			        if piar.auto_piar_kd.v < 0 then piar.auto_piar_kd = 0 end
			    end
			    imgui.PopItemWidth()
			end
			PaddingSpace()
			imgui.Separator()
			imgui.CenterText(u8('Скрипты по отдельности'))
			imgui.Separator()
			PaddingSpace()
			imgui.BeginGroup()
			if imgui.Button(u8('Стамина худ')) then
				downloadUrlToFile('https://github.com/PhanLom/ARZ-Scripts/raw/main/CEF%20Stamina%20HUD/%5BARZ%5D%20HUD%20Stamina.lua',
                   'moonloader\\[ARZ] HUD Stamina.lua', 
                   '[ARZ] HUD Stamina.lua')
				sampAddChatMessage("{FF8000}[ANTools]{FFFFFF} [ARZ] HUD Stamina успешно загружен! Нажмите Ctrl+R для перезапуска MoonLoader.", -1)
            end
            imgui.SameLine()
			imgui.TextQuestion(u8('Скрипт для отображения стамины в HUD на экране'))
			imgui.SameLine()
			if imgui.Button(u8('Числовой счетчик')) then
				downloadUrlToFile('https://github.com/PhanLom/ARZ-Scripts/raw/main/Number%20Couter/NumberChanger.lua',
                   'moonloader\\Number Changer.lua', 
                   'Number Changer.lua')
				sampAddChatMessage("{FF8000}[ANTools]{FFFFFF} Number Changer успешно загружен! Нажмите Ctrl+R для перезапуска MoonLoader.", -1)
            end
			imgui.SameLine()
			imgui.TextQuestion(u8('Скрипт для отображения числа. Num+ - добавляет 1 к числу, Num- - вычитает 1 из числа'))
			imgui.EndGroup()
			imgui.EndChild()

		elseif menunum == 2 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			if menufill == 0 then
				autofillelementsaccs()
			elseif menufill == 1 then
				autofillelementssave()
			end
			imgui.EndChild()

		-- Авто-еда -- 

		elseif menunum == 3 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Автоеда ') .. fa.ICON_CUTLERY)
			imgui.Separator()
			imgui.BeginGroup()
        	imgui.RadioButton(u8'Оффнуть',eat.eatmetod,0)
			if eat.eatmetod.v > 0 then
				imgui.SameLine()
				imgui.PushItemWidth(140)
				imgui.Combo(u8('Способ проверки голода'), eat.checkmethod, checklist, -1)
				if eat.checkmethod.v == 1 then
					imgui.PushItemWidth(80)
					imgui.SameLine()
					imgui.InputInt(u8('При скольки процентах голода надо кушать'),eat.eat2met,0)
				end
				imgui.PopItemWidth()
			end
			imgui.RadioButton(u8'Кушать Дома',eat.eatmetod,1)
        	imgui.SameLine()
        	imgui.TextQuestion(u8'Ваш персонаж будет кушать дома из холодильника')
        	imgui.BeginGroup()
        	imgui.RadioButton(u8'Кушать вне Дома',eat.eatmetod,2)
        	imgui.SameLine()
        	imgui.TextQuestion(u8'Ваш персонаж будет кушать вне дома способом из списка')
        	if eat.eatmetod.v == 2 then
        	    imgui.Text(u8'Выбор метода еды:')
        	    imgui.PushItemWidth(100)
        	    imgui.Combo('##123123131231232', eat.setmetod, metod, -1)
        	    if eat.setmetod.v == 3 then
        	        imgui.Text(u8("ID TextDraw'a Еды"))
        	        imgui.InputInt(u8"##eat", eat.arztextdrawid,0)      
        	    end    
        	    imgui.PopItemWidth()
        	end
        	imgui.EndGroup()
        	imgui.RadioButton(u8'Кушать в Фам КВ',eat.eatmetod,3)
        	imgui.SameLine()
        	imgui.TextQuestion(u8'Ваш персонаж будет кушать из холодильника в семейной квартире. Для использования встаньте на место, где при нажатии ALT появится диалог с выбором еды')
        	imgui.EndGroup()
        	imgui.BeginGroup()
        	imgui.Checkbox(u8'АвтоХил', eat.healstate)
        	-- imgui.SameLine()
        	if eat.healstate.v then
        	    imgui.PushItemWidth(40)
        	    imgui.InputInt(u8'Уровень HP для Хила', eat.hplvl,0)
        	    imgui.PopItemWidth()
        	    imgui.Text(u8 'Выбор метода хила:')
        	    imgui.PushItemWidth(100)
				imgui.Combo('##ban',eat.hpmetod,healmetod,-1)
				if eat.hpmetod.v == 1 then
        	        imgui.PushItemWidth(30)
        	        imgui.InputInt(u8"Кол-во нарко",eat.drugsquen,0)
        	        imgui.PopItemWidth()
        	    end
        	    if eat.hpmetod.v == 4 then
        	        imgui.Text(u8("ID TextDraw'a Хила"))
        	        imgui.InputInt(u8"##heal",eat.arztextdrawidheal,0)
        	    end
        	    imgui.PopItemWidth()
        	end
        	imgui.EndGroup()
        	imgui.SameLine(130)
        	if imgui.Checkbox(u8('Включить отображение ID текстдравов'), imgui.ImBool(idsshow)) then
        	    idsshow = not idsshow
        	end
			imgui.EndChild()

		-- Раздел F.A.Q -- 	

		elseif menunum == 4 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Информация & F.A.Q ') .. fa.ICON_INFO)
			imgui.Separator()
			imgui.SetCursorPosX(280)
			imgui.Image(banner, imgui.ImVec2(400, 200))
			imgui.Spacing()
			--imgui.Text(fa.ICON_FILE_CODE_O)
			--imgui.SameLine()
			imgui.Text(fa.ICON_FILE_CODE_O .. u8(scriptinfo))
			PaddingSpace()
			if imgui.CollapsingHeader(u8('Команды скрипта ') .. fa.ICON_COG) then
				imgui.TextWrapped(u8(scriptcommand))
			end
			imgui.EndChild()
		-- Раздел ChangeLog --	

		elseif menunum == 5 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('История обновлений & Изменений ') .. fa.ICON_HISTORY)
			imgui.Separator()
			for i = 1, 3 do imgui.Spacing() end
			imgui.PushItemWidth(100)
			if imgui.CollapsingHeader(u8'v1.0 (Релиз, фиксы, небольшие дополнения)') then
				imgui.TextWrapped(u8(changelog1))
				imgui.Separator()
			elseif imgui.CollapsingHeader(u8'v2.0 (Дополнения, фиксы, работа с VK Notf)') then
				imgui.TextWrapped(u8(changelog2))
				imgui.Separator()
			elseif imgui.CollapsingHeader(u8'v2.2 (Новые функции, долнения, багофикс)') then
				imgui.TextWrapped(u8(changelog3))
				imgui.Separator()
			elseif imgui.CollapsingHeader(u8'v2.5 (Небольшие изменения, новый автологин, багофикс)') then
				imgui.TextWrapped(u8(changelog4))
				imgui.Separator()
			elseif imgui.CollapsingHeader(u8'v3.0 (Глобальное обновление, TG Notifications, кастомизация и др.)') then
				imgui.TextWrapped(u8(changelog5))
				imgui.Separator()
			end
			imgui.PopItemWidth()
			imgui.EndChild()

		-- Раздел кастомизации --

		elseif menunum == 6 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Кастомизация ') .. fa.ICON_COGS)
			imgui.Separator()
			imgui.Text(u8(customtext))

			-- Theme's System --
			imgui.PushItemWidth(300)
			-- stepace5()
			if imgui.Combo(u8"Выберите тему", style_selected, style_list, style_selected) then
				style(style_selected.v) 
				mainIni.theme.style = style_selected.v 
				inicfg.save(mainIni, 'ANTools/ANTools.ini') 
			end
			imgui.SameLine()
			-- stepace5()
			-- imgui.Text(u8'Все ImGUI прессеты, кроме  были взяты отсюда - blast.hk/threads/25442')

			imgui.PopItemWidth()

			
			imgui.EndChild()

		-- Раздел поиска и отправки текста из игры в VK -- --//Продублируй для TGNOTF--// By Mamashin

		elseif menunum == 7 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Настройка отправки текста по поиску в чате в ') .. fa.ICON_VK .. " & " .. fa.ICON_TELEGRAM)
			imgui.Separator()
			imgui.Text(u8(searchchatfaq))
			PaddingSpace()
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'Отправлять найденный текст в '.. fa.ICON_VK .. " & " .. fa.ICON_TELEGRAM, find.vkfind) imgui.SameLine() imgui.TextQuestion(u8"Отправка нужных строк с чата вам в VK/Telegram. \nПример: Продам Маверик ТТ Суприм")
			imgui.Text('')
			imgui.PushItemWidth(350)
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст', find.vkfindtext) imgui.SameLine() imgui.InputText(u8'##поисквк1', find.inputfindvk)
			imgui.SameLine() 
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст2', find.vkfindtext6) imgui.SameLine() imgui.InputText(u8'##поисквк6', find.inputfindvk6)
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст3', find.vkfindtext2) imgui.SameLine() imgui.InputText(u8'##поисквк2', find.inputfindvk2)
			imgui.SameLine() 
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст4', find.vkfindtext7) imgui.SameLine() imgui.InputText(u8'##поисквк7', find.inputfindvk7)
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст5', find.vkfindtext3) imgui.SameLine() imgui.InputText(u8'##поисквк3', find.inputfindvk3)
			imgui.SameLine() 
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст6', find.vkfindtext8) imgui.SameLine() imgui.InputText(u8'##поисквк8', find.inputfindvk8)
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст7', find.vkfindtext4) imgui.SameLine() imgui.InputText(u8'##поисквк4', find.inputfindvk4)
			imgui.SameLine() 
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст8', find.vkfindtext9) imgui.SameLine() imgui.InputText(u8'##поисквк9', find.inputfindvk9)
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст9', find.vkfindtext5) imgui.SameLine() imgui.InputText(u8'##поисквк5', find.inputfindvk5)
			imgui.SameLine() 
			imgui.Text('') imgui.SameLine() imgui.Checkbox(u8'##вкобчитьпоисктекст10', find.vkfindtext10) imgui.SameLine() imgui.InputText(u8'##поисквк10', find.inputfindvk10)
			imgui.PopItemWidth()
			imgui.EndChild()

		-- Раздел VK Notf --

		elseif menunum == 8 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(fa.ICON_VK .. ' Notification')
			imgui.Separator()
			if imgui.Checkbox(fa.ICON_VK .. u8(' - Включить уведомления'), vknotf.state) then
				if vknotf.state.v then
					longpollGetKey()
				end
			end
			if vknotf.state.v then
				imgui.BeginGroup()
				if vkerr then
					imgui.Text(u8'Состояние приёма: ' .. u8(vkerr))
					imgui.Text(u8'Для переподключения к серверам нажмите кнопку "Переподключиться к серверам"')
				else
					imgui.Text(u8'Состояние приёма: Активно!') --
				end
				if vkerrsend then
					imgui.Text(u8'Состояние отправки: ' .. u8(vkerrsend))
				else
					imgui.Text(u8'Состояние отправки: Активно!')
				end
				imgui.InputText(u8('Токен'), vknotf.token, showtoken and 0 or imgui.InputTextFlags.Password)
				imgui.SameLine()
				if imgui.Button(u8('Показать##1010')) then showtoken = not showtoken end
				imgui.InputText(u8('VK ID Группы'), vknotf.group_id)
				imgui.SameLine()
				imgui.TextQuestion(u8('В цифрах!'))
				imgui.InputText(u8('VK ID'), vknotf.user_id)
				imgui.SameLine()
				imgui.TextQuestion(u8('В цифрах!'))
				imgui.SetNextWindowSize(imgui.ImVec2(666,200)) -- с пабликом (600,230) • без (900,530)
				if imgui.BeginPopupModal('##howsetVK',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
					imgui.Text(u8(howsetVK))
					imgui.SetCursorPosY(160) -- с пабликом (200) • без (490)
					local wid = imgui.GetWindowWidth()
					imgui.SetCursorPosX(wid / 2 - 30)
					if imgui.Button(u8'Закрыть', imgui.ImVec2(60,20)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
				if imgui.Button(u8('Как настроить')) then imgui.OpenPopup('##howsetVK') end
				imgui.SameLine()
				imgui.SetNextWindowSize(imgui.ImVec2(600,200)) -- 600,200
                if imgui.BeginPopupModal('##howscreen',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
					imgui.Text(u8(howscreen))
					imgui.SetCursorPosY(150)
					local wid = imgui.GetWindowWidth()
					imgui.SetCursorPosX(wid / 2 - 30)
					if imgui.Button(u8'Закрыть', imgui.ImVec2(60,20)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
				if imgui.Button(u8('Проверить уведомления')) then sendvknotf('Скрипт работает!') end
				imgui.SameLine()
				if imgui.Button(u8('Переподключиться к серверам')) then longpollGetKey() end
				imgui.EndGroup()
				for i = 1, 3 do imgui.Spacing() end
				imgui.Separator()
				imgui.CenterText(u8('События, при которых отправиться уведомление'))
				imgui.Separator()
				imgui.BeginGroup()
				imgui.Checkbox(u8('Подключение'),vknotf.isinitgame); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж подключится к серверу'))
				imgui.Checkbox(u8('Администрация'),vknotf.isadm); imgui.SameLine(); imgui.TextQuestion(u8('Если в строке будет слово "Администратор" + ваш ник + красная строка(искл.: окно /pm, чат /pm, ban тоже будут учитываться)'))
				imgui.Checkbox(u8('Голод'),vknotf.ishungry); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж проголодается'))
				imgui.Checkbox(u8('Кик'),vknotf.iscloseconnect); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж отключится от сервера'))
				imgui.Checkbox(u8('Деморган'),vknotf.isdemorgan); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж выйдет из деморгана'))
				imgui.Checkbox(u8('SMS и Звонок'),vknotf.issmscall); imgui.SameLine(); imgui.TextQuestion(u8('Если персонажу придет смс или позвонят'))
				imgui.Checkbox(u8('Запись звонков'),vknotf.record); imgui.SameLine(); imgui.TextQuestion(u8('Запись звонка, отправляется в ВК. Работает с автоответчиком'))
				imgui.Checkbox(u8('Входящие и исходящие переводы'),vknotf.bank); imgui.SameLine(); imgui.TextQuestion(u8('При получении или отправлении перевода придет уведомление'))
				imgui.EndGroup()
				imgui.SameLine(350)
				imgui.BeginGroup()
				imgui.Checkbox(u8('PayDay'),vknotf.ispayday); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж получит PayDay'))
				imgui.Checkbox(u8('Смерть'),vknotf.islowhp); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж умрет(если вас кто-то убъет, напишет его ник)'))
				imgui.Checkbox(u8('Краш скрипта'),vknotf.iscrashscript); imgui.SameLine(); imgui.TextQuestion(u8('Если скрипт выгрузится/крашнется(даже если перезагрузите через CTRL + R)'))
				imgui.Checkbox(u8('Продажи'),vknotf.issellitem); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж продаст что-то на ЦР или АБ'))
				imgui.Checkbox(u8('КД мешка/рулеток'),vknotf.ismeat); imgui.SameLine(); imgui.TextQuestion(u8('Если КД на мешок/сундук не прошло, или если выпадет рулетка то придет уведомление'))
				imgui.Checkbox(u8('Код с почты/ВК'),vknotf.iscode); imgui.SameLine(); imgui.TextQuestion(u8('Если будет требоваться код с почты/ВК, то придет уведомление'))
				imgui.Checkbox(u8('Отправка всех диалогов'),vknotf.dienable); imgui.SameLine(); imgui.TextQuestion(u8('Скрипт отправляет все серверные диалоги по типу /mm, /stats в вашу беседу в VK.'))
				imgui.EndGroup()
			end
			imgui.EndChild()

		-- Раздел TG Notf -- 
			
		elseif menunum == 9 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(fa.ICON_TELEGRAM .. ' Notification')
			imgui.Separator()
			if imgui.Checkbox(fa.ICON_TELEGRAM .. u8(' - Включить уведомления'), tgnotf.state) then
				if tgnotf.state.v then
					longpollGetKey()
				end
			end
			if tgnotf.state.v then
				imgui.BeginGroup()
				imgui.InputText(u8('Токен'), tgnotf.token, showtoken and 0 or imgui.InputTextFlags.Password)
				imgui.SameLine()
				if imgui.Button(u8('Показать##1010')) then showtoken = not showtoken end
				imgui.InputText(u8('TG ID'), tgnotf.user_id)
				imgui.SameLine()
				imgui.TextQuestion(u8('User ID в цифрах!'))
				if imgui.Button(u8('Проверить уведомления')) then sendtgnotf('Скрипт работает!') end
				imgui.SameLine()
				imgui.SetNextWindowSize(imgui.ImVec2(666,200)) -- с пабликом (600,230) • без (900,530)
				if imgui.BeginPopupModal('##howsetTG',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
					imgui.Text(u8(howsetTG))
					if imgui.Button(u8('Bot Father ')) then
						os.execute("start https://telegram.me/BotFather")
					end
					imgui.SameLine()
					if imgui.Button(u8('Get My ID ')) then
						os.execute("start https://telegram.me/getmyid_bot")
					end
					imgui.SetCursorPosY(160) -- с пабликом (200) • без (490)
					local wid = imgui.GetWindowWidth()
					imgui.SetCursorPosX(wid / 2 - 30)
					if imgui.Button(u8'Закрыть', imgui.ImVec2(60,20)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
				if imgui.Button(u8('Как настроить')) then imgui.OpenPopup('##howsetTG') end
				imgui.SameLine()
				imgui.EndGroup()
				for i = 1, 3 do imgui.Spacing() end
				imgui.Separator()
				imgui.CenterText(u8('События, при которых отправиться уведомление'))
				imgui.Separator()
				imgui.Spacing()
				imgui.BeginGroup()
				imgui.Checkbox(u8('Подключение'),tgnotf.isinitgame); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж подключится к серверу'))
                imgui.Checkbox(u8('Администрация'),tgnotf.isadm); imgui.SameLine(); imgui.TextQuestion(u8('Если в строке будет слово "Администратор" + ваш ник + красная строка(искл.: окно /pm, чат /pm, ban тоже будут учитываться)'))
                imgui.Checkbox(u8('Голод'),tgnotf.ishungry); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж проголодается'))
                imgui.Checkbox(u8('Кик'),tgnotf.iscloseconnect); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж отключится от сервера'))
                imgui.Checkbox(u8('Деморган'),tgnotf.isdemorgan); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж выйдет из деморгана'))
                imgui.Checkbox(u8('SMS и Звонок'),tgnotf.issmscall); imgui.SameLine(); imgui.TextQuestion(u8('Если персонажу придет смс или позвонят'))
                imgui.Checkbox(u8('Запись звонков'),tgnotf.record); imgui.SameLine(); imgui.TextQuestion(u8('Запись звонка, отправляется в TG. Работает с автоответчиком'))
                imgui.Checkbox(u8('Входящие и исходящие переводы'),tgnotf.bank); imgui.SameLine(); imgui.TextQuestion(u8('При получении или отправлении перевода придет уведомление'))
                imgui.EndGroup()
                imgui.SameLine(350)
                imgui.BeginGroup()
                imgui.Checkbox(u8('PayDay'),tgnotf.ispayday); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж получит PayDay'))
                imgui.Checkbox(u8('Смерть'),tgnotf.islowhp); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж умрет(если вас кто-то убъет, напишет его ник)'))
                imgui.Checkbox(u8('Краш скрипта'),tgnotf.iscrashscript); imgui.SameLine(); imgui.TextQuestion(u8('Если скрипт выгрузится/крашнется(даже если перезагрузите через CTRL + R)'))
                imgui.Checkbox(u8('Продажи'),tgnotf.issellitem); imgui.SameLine(); imgui.TextQuestion(u8('Если персонаж продаст что-то на ЦР или АБ'))
                imgui.Checkbox(u8('КД мешка/рулеток'),tgnotf.ismeat); imgui.SameLine(); imgui.TextQuestion(u8('Если КД на мешок/сундук не прошло, или если выпадет рулетка то придет уведомление'))
                imgui.Checkbox(u8('Код с почты/ВК'),tgnotf.iscode); imgui.SameLine(); imgui.TextQuestion(u8('Если будет требоваться код с почты/ВК, то придет уведомление'))
                imgui.Checkbox(u8('Отправка всех диалогов'),tgnotf.dienable); imgui.SameLine(); imgui.TextQuestion(u8('Скрипт отправляет все серверные диалоги по типу /mm, /stats в вашу беседу в TG.'))
                imgui.Checkbox(u8('Принимать команды и нажатие клавиш из TG'),tgnotf.sellotvtg); imgui.SameLine(); imgui.TextQuestion(u8('Если хотите писать в чаты, писать команды, открывать диалоги из Telegram и так далее, то нужно включить данный функционал. Чтобы узнать все доступные команды, после включения и перезапуска скрипта, напишите !help в беседе в Telegram.'))
				imgui.EndGroup()
			end
			imgui.EndChild()
		end
		imgui.End()	 
	end
	onRenderNotification()
end

function imgui.ButtonDisabled(...)

    local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])

        local result = imgui.Button(...)

    imgui.PopStyleColor()
    imgui.PopStyleColor()
    imgui.PopStyleColor()
    imgui.PopStyleColor()

    return result
end
function imgui.CloseButton(rad)
	local pos = imgui.GetCursorScreenPos()
	local poss = imgui.GetCursorPos()
	local a,b,c,d = pos.x - rad, pos.x + rad, pos.y - rad, pos.y + rad
	local e,f = poss.x - rad, poss.y - rad
	local list = imgui.GetWindowDrawList()
	list:AddLine(imgui.ImVec2(a,d),imgui.ImVec2(b,c),convertImVec4ToU32(convertHexToImVec4('a18282')))
	list:AddLine(imgui.ImVec2(b,d),imgui.ImVec2(a,c),convertImVec4ToU32(convertHexToImVec4('a18282')))
	imgui.SetCursorPos(imgui.ImVec2(e,f))
	if imgui.InvisibleButton('##closebutolo',imgui.ImVec2(rad*2,rad*2)) then
		ANsets.v = false
	end
end

-- Title main menu logo --
function imgui.RenderLogo()
	imgui.Image(logos,imgui.ImVec2(45,45))
end

-- mini msg menu logo -- 
function imgui.RenderMsgLogo()
	imgui.Image(logos,imgui.ImVec2(30,30))
end


function imgui.CenterText(text) 
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.TextQuestion(text)
  imgui.TextDisabled('(?)')
  imgui._atq(text)
end

function imgui._atq(text)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function imgui.CreatePaddingX(x)
	x = x or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosX(cc.x+x)
end

function imgui.CreatePaddingY(y)
	y = y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosY(cc.y+y)
end

function imgui.CreatePadding(x,y)
	x,y = x or 8, y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPos(imgui.ImVec2(cc.x+x,cc.y+y))
end

function onScriptTerminate(scr,qgame)
	if scr == thisScript() then
		mainIni.piar.last_time = os.time()
		local saved = inicfg.save(mainIni,'ANTools/ANTools.ini')
		if vknotf.iscrashscript.v then
			sendvknotf('Скрипт умер :(')
		end	
		if tgnotf.iscrashscript.v then
			sendtgnotf('Скрипт умер :(')
		end
	end
end
--получить все текстдравы
function sampGetAllTextDraws()
	local tds = {}
	pTd = sampGetTextdrawPoolPtr() + 9216
	for i = 0,2303 do
		if readMemory(pTd + i*4,4) ~= 0 then
			table.insert(tds,i)
		end
	end
	return tds
end

-- Screen --
function takeScreen()
	if isSampLoaded() then
		memory.setuint8(sampGetBase() + 0x119CBC, 1)
	end
end

-- Spacing -- 
function PaddingSpace()
	for i = 1, 3 do imgui.Spacing()

	end
end

-- AntiAFK --
function workpaus(bool)	
	if bool then
		memory.setuint8(7634870, 1, false)
		memory.setuint8(7635034, 1, false)
		memory.fill(7623723, 144, 8, false)
		memory.fill(5499528, 144, 6, false)
	else
		memory.setuint8(7634870, 0, false)
		memory.setuint8(7635034, 0, false)
		memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
		memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
	end
	-- AFKMessage('AntiAFK '..(bool and 'работает' or 'не работает'))
end
function sampFastConnect(bool)
	if bool then 
		writeMemory(sampGetBase() + 0x2D3C45, 2, 0, true)
	else
		writeMemory(sampGetBase() + 0x2D3C45, 2, 8228, true)
	end
end

-- Автозаполнение -- 
function findDialog(id, dialog)
	for k, v in pairs(savepass[id][3]) do
		if v.id == dialog then
			return k
		end
	end
	return -1
end
function findAcc(nick, ip)
	for k, v in pairs(savepass) do
		if nick == v[1] and ip == v[2] then
			return k
		end
	end
	return -1
end
function getAcc()
	local nick = tostring(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
	local ip, port = sampGetCurrentServerAddress()
	local ip = ip .. ":" .. port
	local acc = findAcc(nick, ip)
	return acc
end

-- Hooks -- 
function onReceivePacket(id, bitStream)
	if (id == PACKET_DISCONNECTION_NOTIFICATION or id == PACKET_INVALID_PASSWORD) then
		goaurc()
	end
	if (id == PACKET_CONNECTION_BANNED) then	
		ip,port = sampGetCurrentServerAddress()
		if arec.state.v and arec.statebanned.v then
			lua_thread.create(function()
				wait(1000)
				sampConnectToServer(ip,port)
			end)
		end
	end
	if autologinfix.state.v then
		if(id == 220) then
		raknetBitStreamIgnoreBits(bitStream, 8)
		if(raknetBitStreamReadInt8(bitStream) == 17) then
			raknetBitStreamIgnoreBits(bitStream, 32)
			if(raknetBitStreamReadString(bitStream, raknetBitStreamReadInt32(bitStream)):match("window%.executeEvent%('event%.setActiveView', '%[\"Auth\"%]'%);")) then
				lua_thread.create(function()
				wait(200)
local NICK = mainIni.autologinfix.nick
local PASS = mainIni.autologinfix.pass
local BITSTREAM = raknetNewBitStream()
raknetBitStreamWriteInt8(BITSTREAM, 220)
raknetBitStreamWriteInt8(BITSTREAM, 18)
raknetBitStreamWriteInt8(BITSTREAM, string.len(string.format("authorization|%s|%s|0", NICK, PASS)))
raknetBitStreamWriteInt8(BITSTREAM, 0)
raknetBitStreamWriteInt8(BITSTREAM, 0)
raknetBitStreamWriteInt8(BITSTREAM, 0)
raknetBitStreamWriteString(BITSTREAM, string.format("authorization|%s|%s|0", NICK, PASS))
raknetBitStreamWriteInt32(BITSTREAM, 1)
raknetBitStreamWriteInt8(BITSTREAM, 0)
raknetBitStreamWriteInt8(BITSTREAM, 0)
raknetSendBitStreamEx(BITSTREAM, 1, 7, 1)
raknetDeleteBitStream(BITSTREAM)
					end)
				end
			end
		end
	end
end
function onReceiveRpc(id,bitStream)
	if (id == RPC_CONNECTIONREJECTED) then
		goaurc()
	end
end

tblclosetest = {['50.83'] = 50.84, ['49.9'] = 50, ['49.05'] = 49.15, ['48.2'] = 48.4, ['47.4'] = 47.6, ['46.5'] = 46.7, ['45.81'] = '45.84',
['44.99'] = '45.01', ['44.09'] = '44.17', ['43.2'] = '43.4', ['42.49'] = '42.51', ['41.59'] = '41.7', ['40.7'] = '40.9', ['39.99'] = 40.01,
['39.09'] = 39.2, ['38.3'] = 38.4, ['37.49'] = '37.51', ['36.5'] = '36.7', ['35.7'] = '35.9', ['34.99'] = '35.01', ['34.1'] = '34.2';}
tblclose = {}

sendcloseinventory = function()
	sampSendClickTextdraw(tblclose[1])
end
function sampev.onShowTextDraw(id,data)
	-- for k,v in pairs(data) do
	-- 	if id == 2110 then
	-- 		__idclosebutton = id
	-- 		print(k,v)
	-- 		if type(v) == 'table' then
	-- 			for kb,bv in pairs(v) do
	-- 				print('	',kb,bv)
	-- 			end
	-- 		end
	-- 	end
	-- end

	--find close button / thx dmitriyewich
	for w, q in pairs(tblclosetest) do
		if data.lineWidth >= tonumber(w) and data.lineWidth <= tonumber(q) and data.text:find('^LD_SPAC:white$') then
			for i=0, 2 do rawset(tblclose, #tblclose + 1, id) end
		end
	end

	if eat.checkmethod.v == 1 then
		if data.boxColor == -1436898180 then 
			if data.position.x == 549.5 and data.position.y == 60 then
				print('get hun > its hungry')
				if math.floor(((data.lineWidth - 549.5) / 54.5) * 100) <= eat.eat2met.v then
					onPlayerHungry:run()
				end
			end
		end
	end
	if aopen then -- state
	 lua_thread.create(function()
		if roulette.standart.v then --standard
			if data.modelId == 19918 then --standart model
				opentimerid.standart = id + 1
			end
			if checkopen.standart then
				if id == opentimerid.standart then
					ANMessage('[Сундук рулетки] пытаюсь открыть сундук')
					wait(500)
					sampSendClickTextdraw(id - 1)
					use = true
					wait(500)
					if use then
      					sampSendClickTextdraw(2302)
        				use = false
      				end
					if not checkopen.donate and not checkopen.platina and not checkopen.mask and not checkopen.tainik then
						sendcloseinventory()
					end
					checkopen.standart = false
				end
			end
		end
		wait(1000)
		if roulette.donate.v then
			if data.modelId == 19613 then --standart model
				opentimerid.donate = id + 1
			end
			if checkopen.donate then
				if id == opentimerid.donate then
					ANMessage('[Донат-сундук] пытаюсь открыть сундук')
					wait(500)
					sampSendClickTextdraw(id - 1)
					use = true
					wait(500)
					if use then
      					sampSendClickTextdraw(2302)
        				use = false
      				end
					if not checkopen.standart and not checkopen.platina and not checkopen.mask and not checkopen.tainik then
						sendcloseinventory()
					end
					checkopen.donate = false
				end
			end
		end
		wait(1000)
		if roulette.platina.v then
			if data.modelId == 1353 then --standart model
				opentimerid.platina = id + 1
			end
			if checkopen.platina then
				if id == opentimerid.platina then
					ANMessage('[Платиновый сундук] пробую открыть сундук')
					wait(500)
					sampSendClickTextdraw(id - 1)
					use = true
					wait(500)
					if use then
      					sampSendClickTextdraw(2302)
        				use = false
      				end
					if not checkopen.standart and not checkopen.donate and not checkopen.mask and not checkopen.tainik then
						sendcloseinventory()
					end
					checkopen.platina = false
				end
			end
		end
		wait(1000)
		if roulette.mask.v then
			if data.modelId == 1733 then --standart model
				opentimerid.mask = id + 1
			end
			if checkopen.mask then
				if id == opentimerid.mask then
					ANMessage('[Тайник Илона Маска] пробую открыть сундук')
					wait(500)
					sampSendClickTextdraw(id - 1)
					use = true
					wait(500)
					if use then
      					sampSendClickTextdraw(2302)
        				use = false
      				end
					if not checkopen.standart and not checkopen.donate and not checkopen.platina and not checkopen.tainik then
						sendcloseinventory()
					end
					checkopen.mask = false
				end
			end
		end
		wait(1000)
		if roulette.tainik.v then
			if data.modelId == 2887 then --standart model
				opentimerid.tainik = id + 1
			end
			if checkopen.tainik then
				if id == opentimerid.tainik then
					ANMessage('[Тайник Лос-Сантоса] пробую открыть тайник')
					wait(500)
					sampSendClickTextdraw(id - 1)
					use = true
					wait(500)
					if use then
      					sampSendClickTextdraw(2302)
        				use = false
      				end
					if not checkopen.standart and not checkopen.donate and not checkopen.platina and not checkopen.mask then
						sendcloseinventory()
					end
					checkopen.tainik = false
				end
			end
		end    
	 end)
	end
	--print('ID = %s, ModelID = %s, text = %s',id,data.modelId, data.text)
end
function sampev.onSetPlayerHealth(healthfloat)
	if eat.healstate.v and sampIsLocalPlayerSpawned() then
		if healthfloat <= eat.hplvl.v then
			if eat.hpmetod.v == 0 then
				sampSendChat('/usemed')
			elseif eat.hpmetod.v == 1 then
				sampSendChat('/usedrugs '..eat.drugsquen.v)
			elseif eat.hpmetod.v == 2 then
				sampSendChat('/adrenaline')
			elseif eat.hpmetod.v == 3 then
				sampSendChat('/beer')
			elseif eat.hpmetod.v == 4 then
				sampSendClickTextdraw(eat.arztextdrawidheal.v)
			elseif eat.hpmetod.v == 5 then
				sampSendChat('/sprunk')
			end 
		end   
	end
end
function sampev.onSendTakeDamage(playerId, damage, weapon, bodypart)
	local killer = ''
	if vknotf.islowhp.v then
		if sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(playerPed))) - damage <= 0 and sampIsLocalPlayerSpawned() then
			if playerId > -1 and playerId < 1001 then
				killer = '\nУбийца: '..sampGetPlayerNickname(playerId)..'['..playerId..']'
			end
			sendvknotf('Ваш персонаж умер'..killer)
		end
	end
	if tgnotf.islowhp.v then
		if sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(playerPed))) - damage <= 0 and sampIsLocalPlayerSpawned() then
			if playerId > -1 and playerId < 1001 then
				killer = '\nУбийца: '..sampGetPlayerNickname(playerId)..'['..playerId..']'
			end
			sendtgnotf('Ваш персонаж умер'..killer)
		end
	end
end
function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if dialogText:find('Вы получили бан аккаунта') then
		if banscreen.v then
			createscreen:run()
		end
		if vknotf.isadm.v then
			local svk = dialogText:gsub('\n','') 
			svk = svk:gsub('\t','') 
			sendvknotf('(warning | dialog) '..svk)
		end
		if tgnotf.isadm.v then
			local svk = dialogText:gsub('\n','') 
			svk = svk:gsub('\t','') 
			sendtgnotf('(warning | dialog) '..svk)
		end
	end
	if fix and dialogText:find("Курс пополнения счета") then
		sampSendDialogResponse(dialogId, 0, 0, "")
		sampAddChatMessage("{ffffff} inventory {ff0000}fixed{ffffff}!",-1)   
		return false
	end
	if dialogId == 15346 then
		if autoad.v then
			sampSendDialogResponse(15346, 1, 0, -1)
		end
	end
	if dialogId == 25473 then
		if autoad.v then
			sampSendDialogResponse(25473, 1, 0, -1)
		end
	end
	if dialogId == 25473 then
		if autoadbiz.v then
			sampSendDialogResponse(25473, 1, 0, -1)
		end
	end
	if dialogId == 15347 then
		if autoad.v then
			sampSendDialogResponse(15347, 1, 0, -1)
		end
	end
	if dialogId == 15379 then
		if autoad.v then
			sampSendDialogResponse(15379, 0, 0, -1)
		end
	end
	if dialogId == 15346 then
		if autoadbiz.v then
			sampSendDialogResponse(15346, 1, 2, -1)
		end
	end
	if dialogId == 15347 then
		if autoadbiz.v then
			sampSendDialogResponse(15347, 1, 0, -1)
		end
	end
	if dialogId == 15379 then
		if autoadbiz.v then
			sampSendDialogResponse(15379, 0, 0, -1)
		end
	end
	if vknotf.dienable.v then
		if dialogStyle == 1 or dialogStyle == 3 then
			sendvknotf('' .. dialogTitle .. '\n' .. dialogText .. '\n\n[______________]\n\n[' .. okButtonText .. '] | [' .. cancelButtonText .. ']' )
		else
			if dialogStyle == 0 then
				dialogkey()
				senddialog2('' .. dialogTitle .. '\n' .. dialogText .. '\n\n[' .. okButtonText .. '] | [' .. cancelButtonText .. ']' )
			else
				sendvknotf('' .. dialogTitle .. '\n' .. dialogText .. '\n\n[' .. okButtonText .. '] | [' .. cancelButtonText .. ']' )
			end
        end
    end
    if tgnotf.dienable.v then
		if dialogStyle == 1 or dialogStyle == 3 then
			sendtgnotf('' .. dialogTitle .. '\n' .. dialogText .. '\n\n[______________]\n\n[' .. okButtonText .. '] | [' .. cancelButtonText .. ']' )
		else
			if dialogStyle == 0 then
				dialogkey()
				senddialog2('' .. dialogTitle .. '\n' .. dialogText .. '\n\n[' .. okButtonText .. '] | [' .. cancelButtonText .. ']' )
			else
				sendtgnotf('' .. dialogTitle .. '\n' .. dialogText .. '\n\n[' .. okButtonText .. '] | [' .. cancelButtonText .. ']' )
			end
        end
    end
	if vknotf.isadm.v then
		if dialogText:find('Администратор (.+) ответил вам') then
			local svk = dialogText:gsub('\n','') 
			svk = svk:gsub('\t','') 
			sendvknotf('(warning | dialog) '..svk)
		end
	end
	if tgnotf.isadm.v then
		if dialogText:find('Администратор (.+) ответил вам') then
			local svk = dialogText:gsub('\n','') 
			svk = svk:gsub('\t','') 
			sendtgnotf('(warning | dialog) '..svk)
		end
	end
	if vknotf.iscode.v and dialogText:find('было отправлено') then sendvknotf('Требуется код с почты.\nВвести код: !sendcode код') end
	if vknotf.iscode.v and dialogText:find('Через личное сообщение Вам на страницу') then sendvknotf('Требуется код с ВК.\nВвести код: !sendvk код') end
	if vknotf.iscode.v and dialogText:find('К этому аккаунту подключено приложение') then sendvknotf('Требуется код из GAuthenticator.\nВвести код: !gauth код') end
	--tg
	if tgnotf.iscode.v and dialogText:find('было отправлено') then sendtgnotf('Требуется код с почты.\nВвести код: !sendcode код') end
	if tgnotf.iscode.v and dialogText:find('Через личное сообщение Вам на страницу') then sendtgnotf('Требуется код с ВК.\nВвести код: !sendvk код') end
	if tgnotf.iscode.v and dialogText:find('К этому аккаунту подключено приложение') then sendtgnotf('Требуется код из GAuthenticator.\nВвести код: !gauth код') end
	if gotoeatinhouse then
		local linelist = 0
		for n in dialogText:gmatch('[^\r\n]+') do
			if dialogId == 174 and n:find('Меню дома') then
				print('debug: 174 dialog')
				sampSendDialogResponse(174, 1, linelist, false)
			elseif dialogId == 2431 and n:find('Холодильник') then
				print('debug: 2431 dialog')
				sampSendDialogResponse(2431, 1, linelist, false)
			elseif dialogId == 185 and n:find('Комплексный Обед') then
				print('debug: 185 dialog')
				sampSendDialogResponse(185, 1, linelist-1, false)
				gotoeatinhouse = false
			end
			linelist = linelist + 1
		end
		return false
	end
	if gethunstate and dialogId == 0 and dialogText:find('Ваша сытость') then
		sampSendDialogResponse(id,0,0,'')
		gethunstate = dialogText
		return false
	end
	if sendstatsstate and dialogId == 235 then
		sampSendDialogResponse(id,0,0,'')
		sendstatsstate = dialogText
		return false
	end
	if dialogStyle == 1 or dialogStyle == 3 then
		local acc = getAcc()
		local bool = true
		if acc > -1 then
			if autologin.state.v then
				local dialog = findDialog(acc, dialogId)
				if dialog > -1 then
				
					sampSendDialogResponse(dialogId, 1, 0, tostring(savepass[acc][3][dialog].text))
					return false
				else
					bool = true
				end
			end
		else
			bool = true
		end
		if bool then
			dialogChecker.check = true
			dialogChecker.id = dialogId
			dialogChecker.title = dialogTitle
		end
	else
		dialogChecker.check = false
		dialogChecker.id = -1
		dialogChecker.title = ""
	end
end
function sampev.onServerMessage(color,text)
	-- print(text .. ' \\ ' .. color)
	if gotoeatinhouse then
		if text:find('электроэнергию') then
			ANMessage('Невозможно покушать! Оплатите комуналку!')
			gotoeatinhouse = false
		end
	end
	if vknotf.issellitem.v then 
		if color == -1347440641 and text:find('от продажи') and text:find('комиссия') then
			sendvknotf(text)
		end
		if color == 1941201407 and text:find('Поздравляем с продажей транспортного средства') then
			sendvknotf('Поздравляем с продажей транспортного средства')
		end
	end
	if tgnotf.issellitem.v then 
		if color == -1347440641 and text:find('от продажи') and text:find('комиссия') then
			sendtgnotf(text)
		end
		if color == 1941201407 and text:find('Поздравляем с продажей транспортного средства') then
			sendtgnotf('Поздравляем с продажей транспортного средства')
		end
	end
	if color == -10270721 and text:find('Вы можете выйти из психиатрической больницы') then
		if vknotf.isdemorgan.v then
			sendvknotf(text)
		end
		if tgnotf.isdemorgan.v then
			sendtgnotf(text)
		end
	end
	if text:find('^Администратор (.+) ответил вам') then
		if vknotf.isadm.v then
			sendvknotf('(warning | chat) '..text)
		end
		if tgnotf.isadm.v then
			sendtgnotf('(warning | chat) '..text)
		end
	end
	if color == -10270721 and text:find('Администратор') then
		local res, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if res then 
			local mname = sampGetPlayerNickname(mid)
			if text:find(mname) then
				if vknotf.isadm.v then
					sendvknotf(text)
				end
				if tgnotf.isadm.v then
					sendtgnotf(text)
				end
			end
		end
	end

	if find.vkfind.v then 
		if find.vkfindtext.v and text:find(''..u8:decode(find.inputfindvk.v)) or 
		find.vkfindtext2.v and text:find(''..u8:decode(find.inputfindvk2.v)) or 
		find.vkfindtext3.v and text:find(''..u8:decode(find.inputfindvk3.v)) or 
		find.vkfindtext4.v and text:find(''..u8:decode(find.inputfindvk4.v)) or 
		find.vkfindtext5.v and text:find(''..u8:decode(find.inputfindvk5.v)) or 
		find.vkfindtext6.v and text:find(''..u8:decode(find.inputfindvk6.v)) or 
		find.vkfindtext7.v and text:find(''..u8:decode(find.inputfindvk7.v)) or 
		find.vkfindtext8.v and text:find(''..u8:decode(find.inputfindvk8.v)) or 
		find.vkfindtext9.v and text:find(''..u8:decode(find.inputfindvk9.v)) or 
		find.vkfindtext10.v and text:find(''..u8:decode(find.inputfindvk10.v)) then
			if vknotf.state.v then 
				sendvknotf('По поиску найдено: '..text)
			end
			if tgnotf.state.v then 
				sendtgnotf('По поиску найдено: '..text)
			end
		end
	end

	if vknotf.issmscall.v and text:find('Вам пришло новое сообщение!') then sendvknotf('Вам написали СМС!') end
	if text:find('докурил(а) сигарету и выбросил(а) окурок') and healthfloat <= eat.hplvl.v then sampSendChat('/smoke') end
	if text:find('попытался закурить %(Неудачно%)') then sampSendChat('/smoke') end
	if vknotf.bank.v and text:match("Вы перевели") then sendvknotf(text) end
	if vknotf.bank.v and text:match("Вам поступил перевод на ваш счет в размере") then sendvknotf(text) end
	if autoo.v and text:find('Вы подняли трубку') then sampSendChat(u8:decode(atext.v)) end
	if vknotf.iscode.v and text:find('На сервере есть инвентарь, используйте клавишу Y для работы с ним.') then sendvknotf('Персонаж заспавнен') end
	if vknotf.ismeat.v and (text:find('Использовать мешок с мясом можно раз в 30 минут!') or text:find('Время после прошлого использования ещё не прошло!') or text:find('сундук с рулетками и получили')) then sendvknotf(text) end
	if vknotf.record.v and (text:find('%[Тел%]%:') or text:find('Вы подняли трубку') or text:find('Вы отменили звонок') or text:find('Звонок окончен! Время разговора')) then sendvknotf(text) end
	if autoo.v and text:find('для того, чтобы показать курсор управления или ') then
		PickUpPhone()
		if vknotf.issmscall.v then 
			sendphonecall()
		end
	end
	if tgnotf.issmscall.v and text:find('Вам пришло новое сообщение!') then sendtgnotf('Вам написали СМС!') end
	if tgnotf.bank.v and text:match("Вы перевели") then sendtgnotf(text) end
	if tgnotf.bank.v and text:match("Вам поступил перевод на ваш счет в размере") then sendtgnotf(text) end
	if autoo.v and text:find('Вы подняли трубку') then sampSendChat(u8:decode(atext.v)) end
	if tgnotf.iscode.v and text:find('На сервере есть инвентарь, используйте клавишу Y для работы с ним.') then sendtgnotf('Персонаж заспавнен') end
	if tgnotf.ismeat.v and (text:find('Использовать мешок с мясом можно раз в 30 минут!') or text:find('Время после прошлого использования ещё не прошло!') or text:find('сундук с рулетками и получили')) then sendtgnotf(text) end
	if tgnotf.record.v and (text:find('%[Тел%]%:') or text:find('Вы подняли трубку') or text:find('Вы отменили звонок') or text:find('Звонок окончен! Время разговора')) then sendtgnotf(text) end
	if autoo.v and text:find('для того, чтобы показать курсор управления или ') then
		PickUpPhone()
		if tgnotf.issmscall.v then 
			sendphonecall()
		end
	end

	if vknotf.ispayday.v then
		if text:find('Банковский чек') and color == 1941201407 then
			vknotf.ispaydaystate = true
			vknotf.ispaydaytext = ''
		end
		if vknotf.ispaydaystate then
			if text:find('Депозит в банке') then 
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
			elseif text:find('Сумма к выплате') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text 
			elseif text:find('Текущая сумма в банке') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
			elseif text:find('Текущая сумма на депозите') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
			elseif text:find('В данный момент у вас') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
				sendvknotf(vknotf.ispaydaytext)
				vknotf.ispaydaystate = false
				vknotf.ispaydaytext = ''
			end
		end
	end
	if tgnotf.ispayday.v then
		if text:find('Банковский чек') and color == 1941201407 then
			tgnotf.ispaydaystate = true
			tgnotf.ispaydaytext = ''
		end
		if tgnotf.ispaydaystate then
			if text:find('Депозит в банке') then 
				tgnotf.ispaydaytext = tgnotf.ispaydaytext..'\n'..text
			elseif text:find('Сумма к выплате') then
				tgnotf.ispaydaytext = tgnotf.ispaydaytext..'\n'..text 
			elseif text:find('Текущая сумма в банке') then
				tgnotf.ispaydaytext = tgnotf.ispaydaytext..'\n'..text
			elseif text:find('Текущая сумма на депозите') then
				tgnotf.ispaydaytext = tgnotf.ispaydaytext..'\n'..text
			elseif text:find('В данный момент у вас') then
				vknotf.ispaydaytext = tgnotf.ispaydaytext..'\n'..text
				sendtgnotf(tgnotf.ispaydaytext)
				tgnotf.ispaydaystate = false
				tgnotf.ispaydaytext = ''
			end
		end
	end
end
function sampev.onInitGame(playerId, hostName, settings, vehicleModels, unknown)
	if vknotf.isinitgame.v then
		sendvknotf('Вы подключились к серверу!', hostName)
	end
	if tgnotf.isinitgame.v then
		sendtgnotf('Вы подключились к серверу!', hostName)
	end
end
function sampev.onDisplayGameText(style, time, text)
	-- print('[GameText | '..os.date('%H:%M:%S')..'] '..'style == '..style..', time == '..time..', text == '..text)
	if eat.checkmethod.v == 0 then
		if text == ('You are hungry!') or text == ('~r~You are very hungry!') then
			if vknotf.ishungry.v then
				sendvknotf('Вы проголодались!')
			end
			if tgnotf.ishungry.v then
				sendtgnotf('Вы проголодались!')
			end
			onPlayerHungry:run()
		end
	end
end
function sampev.onSendDialogResponse(dialogid, button, list, text)
	if dialogChecker.check and dialogChecker.id == dialogid and button == 1 then
		local ip, port = sampGetCurrentServerAddress()
		table.insert(temppass, {
			id = dialogid,
			title = dialogChecker.title,
			text = text,
			time = os.date("%H:%M:%S"),
			ip = ip .. ":" .. port,
			nick = tostring(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
		})
		dialogChecker.check = false
		dialogChecker.id = -1
		dialogChecker.title = ""
	end
end	
-- реконы 
-- рекон стандарт 
function reconstandart(timewait,bool_close)
	if handle_aurc then
		handle_aurc:terminate()
		handle_aurc = nil
		ANMessage('Автореконнект остановлен т.к вы использовали обычный реконнект')
	end
	if handle_rc then
		handle_rc:terminate()
		handle_rc = nil
		ANMessage('Предыдущий реконнект был остановлен')
	end
	handle_rc = lua_thread.create(function(timewait2, bclose)
		bclose = bclose or true
		if bclose then
			closeConnect()
		end
		timewait2 = tonumber(timewait2)
		if timewait2 then	
			if timewait2 >= 0 then
				recwaitim = timewait2*1000
				ANMessage('Реконнект через '..timewait2..' секунд')
				wait(recwaitim)
				sampConnectToServer(sampGetCurrentServerAddress())
			end
		else
			ANMessage('Реконнект...')
			sampConnectToServer(sampGetCurrentServerAddress())
		end  
		handle_rc = nil
	end,timewait, bool_close)
end
--рекон с ником 
function reconname(playername,ips,ports)
	if handle_aurc then
		handle_aurc:terminate()
		handle_aurc = nil
		ANMessage('Автореконнект остановлен т.к вы использовали реконнект с ником')
	end
	if handle_rc then
		handle_rc:terminate()
		handle_rc = nil
		ANMessage('Предыдущий реконнект был остановлен')
	end
	handle_rc = lua_thread.create(function()
		if #playername == 0 then
			ANMessage('Введите ник для реконнекта')
		else
			closeConnect()
			sampSetLocalPlayerName(playername)
			ANMessage('Реконнект с новым ником\n'..playername)
			local ip, port = sampGetCurrentServerAddress()
			ips,ports = ips or ip, ports or port
			sampConnectToServer(ips,ports)
		end 
	end)
end
-- создать autorecon
function goaurc()
	if vknotf.iscloseconnect.v then
		sendvknotf('Потеряно соединение с сервером')
	end
	if tgnotf.iscloseconnect.v then
		sendtgnotf('Потеряно соединение с сервером')
	end
	if arec.state.v then
		if handle_aurc then
			handle_aurc:terminate()
			handle_aurc = nil
			ANMessage('Предыдущий автореконнект был остановлен')
		end
		if handle_rc then
			handle_rc:terminate()
			handle_rc = nil
			ANMessage('Обычный автореконнект был остановлен т.к сработал автореконнект')
		end
		handle_aurc = lua_thread.create(function()
			local ip, port = sampGetCurrentServerAddress()
			ANMessage('Соединение потеряно. Реконнект через '..arec.wait.v..' секунд')
			wait(arec.wait.v * 1000)
			sampConnectToServer(ip,port)
			handle_aurc = nil
		end)
	end
end
--закрыть соединение
function closeConnect()
	raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
	raknetDeleteBitStream(raknetNewBitStream())
end

--//saves
function saveini()
	--login
	mainIni.autologin.state = autologin.state.v
	--autoreconnect
	mainIni.arec.state = arec.state.v
	mainIni.arec.statebanned = arec.statebanned.v
	mainIni.arec.wait = arec.wait.v
	--roulette
	mainIni.roulette.standart = roulette.standart.v
	mainIni.roulette.platina = roulette.platina.v
	mainIni.roulette.donate = roulette.donate.v
	mainIni.roulette.mask = roulette.mask.v
	mainIni.roulette.tainik = roulette.tainik.v
	mainIni.roulette.tainikvc = roulette.tainikvc.v
	mainIni.roulette.wait = roulette.wait.v
	--vk.notf
	mainIni.vknotf.state = vknotf.state.v
	mainIni.vknotf.token = vknotf.token.v
	mainIni.vknotf.user_id = vknotf.user_id.v
	mainIni.vknotf.group_id = vknotf.group_id.v
	mainIni.vknotf.isadm = vknotf.isadm.v
	mainIni.vknotf.iscode = vknotf.iscode.v
	mainIni.vknotf.issmscall = vknotf.issmscall.v
	mainIni.vknotf.bank = vknotf.bank.v
	mainIni.vknotf.record = vknotf.record.v
	mainIni.vknotf.ismeat = vknotf.ismeat.v
	mainIni.vknotf.dienable = vknotf.dienable.v
	mainIni.vknotf.isinitgame = vknotf.isinitgame.v	
	mainIni.vknotf.iscloseconnect = vknotf.iscloseconnect.v
	mainIni.vknotf.ishungry = vknotf.ishungry.v
	mainIni.vknotf.isdemorgan = vknotf.isdemorgan.v
	mainIni.vknotf.islowhp = vknotf.islowhp.v
	mainIni.vknotf.ispayday = vknotf.ispayday.v
	mainIni.vknotf.iscrashscript = vknotf.iscrashscript.v
	mainIni.vknotf.issellitem = vknotf.issellitem.v
	--tg.notf
	mainIni.tgnotf.state = tgnotf.state.v
	mainIni.tgnotf.token = tgnotf.token.v
	mainIni.tgnotf.user_id = tgnotf.user_id.v
	mainIni.tgnotf.isadm = tgnotf.isadm.v
    mainIni.tgnotf.iscode = tgnotf.iscode.v
    mainIni.tgnotf.issmscall = tgnotf.issmscall.v
    mainIni.tgnotf.bank = tgnotf.bank.v
    mainIni.tgnotf.record = tgnotf.record.v
    mainIni.tgnotf.ismeat = tgnotf.ismeat.v
    mainIni.tgnotf.dienable = tgnotf.dienable.v
    mainIni.tgnotf.isinitgame = tgnotf.isinitgame.v 
    mainIni.tgnotf.sellotvtg = tgnotf.sellotvtg.v
    mainIni.tgnotf.iscloseconnect = tgnotf.iscloseconnect.v
    mainIni.tgnotf.ishungry = tgnotf.ishungry.v
    mainIni.tgnotf.isdemorgan = tgnotf.isdemorgan.v
    mainIni.tgnotf.islowhp = tgnotf.islowhp.v
    mainIni.tgnotf.ispayday = tgnotf.ispayday.v
    mainIni.tgnotf.iscrashscript = tgnotf.iscrashscript.v
    mainIni.tgnotf.issellitem = tgnotf.issellitem.v
	--autologin
	mainIni.autologinfix.state = autologinfix.state.v
	mainIni.autologinfix.nick = autologinfix.nick.v
	mainIni.autologinfix.pass = autologinfix.pass.v
	--find
	mainIni.find.vkfind = find.vkfind.v
	mainIni.find.vkfindtext = find.vkfindtext.v
	mainIni.find.vkfindtext2 = find.vkfindtext2.v
	mainIni.find.vkfindtext3 = find.vkfindtext3.v
	mainIni.find.vkfindtext4 = find.vkfindtext4.v
	mainIni.find.vkfindtext5 = find.vkfindtext5.v
	mainIni.find.vkfindtext6 = find.vkfindtext6.v
	mainIni.find.vkfindtext7 = find.vkfindtext7.v
	mainIni.find.vkfindtext8 = find.vkfindtext8.v
	mainIni.find.vkfindtext9 = find.vkfindtext9.v
	mainIni.find.vkfindtext10 = find.vkfindtext10.v
	mainIni.find.inputfindvk = u8:decode(find.inputfindvk.v)
	mainIni.find.inputfindvk2 = u8:decode(find.inputfindvk2.v)
	mainIni.find.inputfindvk3 = u8:decode(find.inputfindvk3.v)
	mainIni.find.inputfindvk4 = u8:decode(find.inputfindvk4.v)
	mainIni.find.inputfindvk5 = u8:decode(find.inputfindvk5.v)
	mainIni.find.inputfindvk6 = u8:decode(find.inputfindvk6.v)
	mainIni.find.inputfindvk7 = u8:decode(find.inputfindvk7.v)
	mainIni.find.inputfindvk8 = u8:decode(find.inputfindvk8.v)
	mainIni.find.inputfindvk9 = u8:decode(find.inputfindvk9.v)
	mainIni.find.inputfindvk10 = u8:decode(find.inputfindvk10.v)
	--piar
	mainIni.piar.piar1 = piar.piar1.v
	mainIni.piar.piar2 = piar.piar2.v
	mainIni.piar.piar3 = piar.piar3.v
	mainIni.piar.piarwait = piar.piarwait.v
	mainIni.piar.piarwait2 = piar.piarwait2.v
	mainIni.piar.piarwait3 = piar.piarwait3.v
	mainIni.piar.auto_piar = piar.auto_piar.v
	mainIni.piar.auto_piar_kd = piar.auto_piar_kd.v
	--main config
	mainIni.config.antiafk = antiafk.v
	mainIni.config.banscreen = banscreen.v
	mainIni.config.autoupdate = autoupdateState.v
	mainIni.config.fastconnect = fastconnect.v
	mainIni.config.autoad = autoad.v
	mainIni.config.autoadbiz = autoadbiz.v
	mainIni.config.autoo = autoo.v
	mainIni.config.atext = atext.v
	mainIni.config.aphone = aphone.v
	--eat
	mainIni.eat.checkmethod = eat.checkmethod.v
	mainIni.eat.cycwait = eat.cycwait.v
	mainIni.eat.eatmetod = eat.eatmetod.v
	mainIni.eat.eat2met = eat.eat2met.v
    mainIni.eat.arztextdrawid = eat.arztextdrawid.v
    mainIni.eat.arztextdrawidheal = eat.arztextdrawidheal.v
    mainIni.eat.setmetod = eat.setmetod.v
    mainIni.eat.hpmetod = eat.hpmetod.v
    mainIni.eat.hplvl = eat.hplvl.v
    mainIni.eat.healstate = eat.healstate.v
	mainIni.eat.drugsquen = eat.drugsquen.v
	mainIni.eat.hpmetod = eat.hpmetod.v
	--buttons
	mainIni.buttons.binfo = binfo.v
	local saved = inicfg.save(mainIni,'ANTools/ANTools.ini')
	ANMessage('Настройки INI сохранены '..(saved and 'успешно!' or 'с ошибкой!'))
end
function saveacc(...)
	local a = {...}

	local data
	if #a == 1 then
		data = temppass[a[1]]
	else
		data = {
			nick = a[1],
			ip = a[4],
			id = a[3],
			text = a[2]
		}
	end
	local id = findAcc(data.nick, data.ip)
	if id > -1 then
		local dId = findDialog(id, data.id)
		if dId == -1 then
			table.insert(savepass[id][3], {
				id = data.id,
				text = data.text
			})
		end
	else
		table.insert(savepass, {
			data.nick,
			data.ip,
			{
				{
					id = data.id,
					text = data.text
				}
			}
		})
	end
end
function saveaccounts()
	if doesFileExist(file_accs) then
		os.remove(file_accs)
	end
	if table.maxn(savepass) > 0 then
		local f = io.open(file_accs, "w")
		if f then
			f:write(encodeJson(savepass))
			f:close()
		end
	end
	print('[Accounts] Saved!')
end
-- // система автообновления //--
updates = {}
updates.data = {
	result = false,
	status = '',
	relevant_version = '',
	url_update = '',
	url_json = 'https://raw.githubusercontent.com/PhanLom/AN-Tools/main/ANTools.json' 
}
function updates:getlast(autoupd)
	print('call getlast')
	self.data.status = 'Проверяю обновления'
	if autoupd then
		ANMessage(self.data.status)
	end
	local json = path .. '\\updatesarzassistant.json'
	if doesFileExist(json) then os.remove(json) end
	int_json_download = downloadUrlToFile(self.data.url_json, json,
	function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD and id == int_json_download then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					if not info then
						self.data.result = false
						self.data.status = '[Error] Ошибка при загрузке JSON фалйа!\nОбратитесь в тех.поддержку скрипта'
						if autoupd then
							ANMessage(self.data.status)
						end
						f:close()
						return false
					end
					self.data.result = true
					self.data.url_update = info.updateurl
					self.data.relevant_version = info.latest
					self.data.status = 'Данные получены'
					f:close()
					os.remove(json)
					return true
				else
					self.data.result = false
					self.data.status = '[Error] Невозможно проверить обновление!\nЧто-то блокирует соединение с сервером\nОбратитесь в тех.поддержку скрипта'
					if autoupd then
						ANMessage(self.data.status)
					end
					return false
				end
			else
				self.data.result = false
				self.data.status = '[Error] Невозможно проверить обновление!\nЧто-то блокирует соединение с сервером\nОбратитесь в тех.поддержку скрипта'
				if autoupd then
					ANMessage(self.data.status)
				end
				return false
			end
		end
	end)
end

function updates:download()
	if self.data.result and #self.data.relevant_version > 0  then
		if self.data.relevant_version ~= thisScript().version then
			self.data.status = 'Пытаюсь обновиться c '..thisScript().version..' на '..self.data.relevant_version
			ANMessage(self.data.status)
			int_scr_download = downloadUrlToFile(self.data.url_update, thisScript().path, function(id3, status1, p13, p23)
				if status1 == dlstatus.STATUS_ENDDOWNLOADDATA and int_scr_download == id3 then
					ANMessage('Загрузка обновления завершена.')
					ANMessage('Обновление завершено!')
					goupdatestatus = true          
					lua_thread.create(function() wait(500) thisScript():reload() end)
				end
				if status1 == dlstatus.STATUSEX_ENDDOWNLOAD and int_scr_download == id3 then
					if goupdatestatus == nil then
						self.data.status = 'Обновление прошло неудачно. Запущена старая версия.'
						ANMessage(self.data.status)
					end
				end
			end)
		else
			self.data.status = 'Обновление не требуется.'
			ANMessage(self.data.status)
		end
	end
end
function updates:autoupdate()
	local result = self:getlast(true)
	if result then
		self:download()
	end
end
--// стиль, тема и лого
function esstyle()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	
	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 4
	style.ChildWindowRounding = 5
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 3.0
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

end
esstyle()

-- System Theme's -- 

--// Функция Style лежит в ANStyles.lua - отдельный файл который содержит в себе стили и темы //--

style(style_selected.v) 


_data ="\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x28\x00\x00\x00\x28\x08\x06\x00\x00\x00\x8C\xFE\xB8\x6D\x00\x00\x03\x91\x49\x44\x41\x54\x78\x01\xEC\x98\xBF\x4F\x14\x41\x14\xC7\xEF\x68\xB4\x11\x2B\x0B\x0D\x18\x8D\x31\x21\x50\x18\x2D\x48\xB4\xD1\x18\x0A\x7B\x13\x0B\x0D\x58\xC0\xFF\xA0\x15\x05\x95\xFE\x0F\x50\x08\xA1\xB4\xB7\x40\xA3\x8D\x26\x36\x6A\x01\x21\xB1\x31\x42\x62\x61\x25\x36\x62\x73\x7E\x3E\xC3\xCE\x66\x16\x97\xBD\xBD\xDB\x2B\x30\x9E\x79\x6F\x67\xE6\xCD\xFB\xF1\x9D\x37\xE3\xDC\x1B\x46\x5A\xC7\xFC\xDF\x10\x60\xD3\x0D\xFA\xFF\x32\xD8\xE9\x74\x36\xE1\x5D\xF8\x76\xD3\xEC\x69\x3F\xD0\x0C\x66\xA0\x4E\xE3\x78\xBB\xDD\x6E\xBF\xA2\x6D\x4C\x03\x05\x08\x9A\x5B\xF0\x19\xF8\x0B\x3C\x10\xEA\x0A\x90\xAC\xB8\x65\x1B\x35\xA3\xDD\x40\x6F\x1F\x7E\x03\x97\x12\xFE\x36\xE0\xCD\xD2\xC9\x12\x61\x29\x40\x1C\xCC\xC2\x7B\x70\x07\x9B\x49\xB8\x2E\x9D\x45\x71\x87\xED\x5D\xA3\xAD\xA2\x49\x7D\xC3\xC6\x98\xAD\x52\x2C\x00\xC4\x60\x19\x16\xD4\x2A\x46\xA7\xE0\x9F\xF0\x1C\x01\x67\x68\x2B\x09\x3B\x03\x8D\xA3\xF4\x0D\x3E\x92\x32\x5F\x73\x28\xE8\xDB\x18\xAB\xD8\x4A\xCB\xC8\xFE\xA2\x00\x90\x59\xB7\x51\x60\xF3\x68\x68\x28\x28\x7C\xB5\x47\xF9\x74\xCB\x06\x26\x81\x6E\xF2\x3D\x01\xBF\x85\x2B\x49\x9F\xB0\xBE\xDB\x28\x46\xB0\xF3\xE0\x90\x0A\xDB\x3F\x82\x64\x17\x25\x57\xDE\x0F\x28\x4C\x73\xBA\x40\xEF\x3B\xFC\x1A\xAE\x4D\x00\x5D\x83\x53\xB0\xE3\x62\x82\xC3\x35\x35\xC2\xE4\x18\xDE\x76\xE0\x98\xEA\xAE\xE7\x02\xDD\x02\x65\xCE\x26\x10\xFE\xC0\x5F\x4F\xD7\x0B\xB6\xE9\x79\xF7\x68\x79\x86\xC7\xA2\x9F\xB0\xC5\x0C\xA6\x60\xD3\xBD\x42\x90\xF4\x5C\xD4\x05\x1B\xAF\x97\x77\xD8\x77\xA5\x12\x50\xC6\x5C\x11\x03\x3C\x95\x3A\x08\x00\xA3\x80\xC9\x05\x58\xA0\xF1\x5C\x68\x68\x66\xBB\x5D\x33\xE7\xF0\x51\x79\xBD\x30\x1F\x08\x70\xFA\x32\x53\xFA\x4E\xCF\xFB\x42\x50\x38\xF4\x29\x00\x8C\x73\x80\x4C\xCF\xC5\x56\x94\x57\xB4\xD7\x99\x73\x6B\xEA\xFE\x87\xDA\x22\x86\xE4\xD9\xAB\xB4\x29\x05\x48\xB0\x9C\xF0\xE2\xF6\x1F\x79\xCD\x90\x91\x5A\xD7\x4B\x74\x88\xBF\x19\xB8\xB0\x8D\x71\xAE\xAC\xED\x0A\xB0\xCC\xE8\x90\xEC\x72\x36\xEE\x7A\xBD\x64\x7A\x3D\x35\x83\x00\xE8\xCF\xDB\x1E\x51\x7B\xBA\x5E\xD0\xAF\x45\x8D\x01\xB2\x5D\x6E\x59\x7E\x2D\xD4\x8A\xDA\x83\x52\x63\x80\x3D\xC4\xEA\x4B\x75\x08\xB0\xAF\xB4\x25\x46\xC3\x0C\x26\xC9\xE8\xAB\x3B\xA0\x0C\xF6\x15\xBB\x96\xD1\xBF\x03\x90\x9F\x2C\xAB\xE9\xC2\x73\x31\x93\x15\x2A\x1A\x64\x16\xB7\x79\xF5\xCB\x38\x2F\x97\xE8\xA7\x54\x28\x3C\xAB\xD2\x85\x91\xEF\x94\xDC\x67\xAA\x9B\x66\xF0\x2A\x13\x56\x24\xF7\x69\x53\xFA\xCD\xE0\x31\x5C\x4A\x5C\xD4\x69\x61\xF1\x12\xA5\xD2\xB2\x09\x79\x5F\x14\x00\xB2\x82\xA5\xCC\x7A\x9D\x56\xA0\x34\x39\x7D\xB4\x87\x4E\xE9\x0A\x9D\x2B\x63\xF4\xD3\xCC\xEE\x33\x0E\x31\x68\xCD\x16\x4D\xA0\x42\x96\x91\x2C\xC1\xEA\xD2\x74\x6C\x97\x02\x40\x02\xF8\x7B\xFA\x81\x6C\x2C\xD2\x6F\x31\x1B\x9C\xD9\xCF\xF8\x09\xED\x1D\xE4\x56\x2E\x74\x6B\x91\x59\x7F\x8F\x4F\xEB\xCB\xA7\x58\x3C\xC0\xDE\x3A\xF0\x0A\xFD\xF0\xBC\xA0\x35\x56\xBA\x70\x71\xB8\x23\x9A\x9D\xE0\xB3\xE8\x9B\xC4\xA0\xD3\x28\x87\x47\x0B\xED\x35\x58\x45\x9A\x03\x42\xD1\x9A\xED\x05\x23\x83\xD2\xD4\xA2\x5F\x68\xC5\x0A\xE7\x33\x7D\x1F\x54\xA3\xB4\x5F\x33\x7F\x74\x5B\xBE\x00\x7D\xCB\xD8\x97\x9F\xF1\xB9\xC7\x42\xA4\x3C\x83\x0F\x11\x86\x95\x62\xE8\x6A\xAD\xA6\x27\xD0\x10\x38\x53\x07\xC4\x5C\xAC\x78\xEB\xBE\x93\x4F\x62\x19\x17\x6A\x49\xE6\xF9\xB6\xEA\x39\x9F\xF8\xF6\x1D\x9D\xFF\x15\x82\x18\x66\xCF\x22\x56\x1C\x26\xE5\xAE\x5B\x7C\x11\x47\x71\xA5\x2D\x95\x18\x6F\xC3\x02\xA7\x29\x90\x5B\x6D\x99\x5E\x10\x1E\x31\x50\x77\x1A\x30\x3E\x67\x1F\xA1\xB3\x8E\x6F\x17\xFF\x89\xBE\xCF\x08\xE5\xC6\x8B\x0B\x77\xBB\xF3\xF3\x89\x8E\x09\x7A\xEE\xAB\xEE\x12\x86\xE1\xEC\x21\x0C\xC4\xD8\x12\x4A\xF6\x8D\x92\x57\xD3\xC8\xE3\x0A\x73\xA7\xC1\x20\xFB\x30\x1F\x6C\x1C\xD2\x8F\xBA\x74\xDB\xE1\x3C\x65\x72\x75\x94\xC9\xA1\xB2\xA6\xA3\x2C\xC4\xA2\x1F\x29\xD8\x98\x41\xED\x8E\x2D\x0F\x01\x36\xDD\x9A\x61\x06\x9B\x66\xF0\x0F\x00\x00\x00\xFF\xFF\x8A\x8F\x9B\xC9\x00\x00\x00\x06\x49\x44\x41\x54\x03\x00\x9C\x1D\xB3\x60\xD7\x50\x99\x72\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"

logos = imgui.CreateTextureFromMemory(memory.strptr(_data),#_data)