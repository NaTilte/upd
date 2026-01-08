script_author("Chipay")
script_name("Knopochki")

local request = require 'requests'
local ev = require'lib.samp.events'
local imgui = require "mimgui"
local encoding = require "encoding"
encoding.default = "CP1251"
local u8 = encoding.UTF8
local new = imgui.new
local inicfg = require "inicfg"
local version = '1.0'
local url =  'https://raw.githubusercontent.com/NaTilte/upd/refs/heads/main/knopki.lua'
local upd = nil
local inif = 'kn.ini'

local ini=inicfg.load({
cfg={
    name = 'Кнопочки 1',
    name2 = 'Кнопочки 2',
    name3 = 'Кастомизация',
    ono1 = true,
    ono2 = false,
    ono3 = false,
    titul_suchka = true,
    sss = false,
    freeze = false,
    freeze2 = false,
    smska = true,
    k1 = "/khelp",
    k2 = "",
    k3 = "",
    k4 = "",
    k5 = "",
    k6 = "",
    k7 = "",
    k8 = "",
    kn1 = "/khelp",
    kn2 = "",
    kn3 = "",
    kn4 = "",
    kn5 = "",
    kn6 = "",
    kn7 = "",
    kn8 = "",
},

settings = {
    color = '',
    fpading = '',
    ispacing = '',
    wBorder = '',
    fBorder = '',
    tabBord = '',
    winTitle = '',
    btnali = '',
},

analogovnet = 
{
    active1 = true, -- win1(dk)
    active2 = false, -- win2(dk2)
    active3 = false, -- fz
    active4 = false, -- fz2
    active5 = true, -- sms
    active6 = false, -- size
    active7 = true -- dstill
}
},inif)

local bindcfg = {
    cmd = {
        k1 = ini.cfg.k1, k2 = ini.cfg.k2, k3 = ini.cfg.k3, k4 = ini.cfg.k4,
        k5 = ini.cfg.k5, k6 = ini.cfg.k6, k7 = ini.cfg.k7, k8 = ini.cfg.k8
    },
    text = {
        kn1 = ini.cfg.kn1, kn2 = ini.cfg.kn2, kn3 = ini.cfg.kn3, kn4 = ini.cfg.kn4,
        kn5 = ini.cfg.kn5, kn6 = ini.cfg.kn6, kn7 = ini.cfg.kn7, kn8 = ini.cfg.kn8
    }
}

local style = imgui.GetStyle()

local nam = ini.cfg.name
local nam2 = ini.cfg.name2

local active = imgui.new.bool(ini.analogovnet.active1)
local active2 = imgui.new.bool(ini.analogovnet.active2)
local active3 = imgui.new.bool(ini.analogovnet.active3)
local active4 = imgui.new.bool(ini.analogovnet.active4)
local active5 = imgui.new.bool(ini.analogovnet.active5)
local active6 = imgui.new.bool(ini.analogovnet.active6)
local active7 = imgui.new.bool(ini.analogovnet.active7)
local demo = ini.analogovnet.demo

local fz = ini.cfg.freeze
local fz2 = ini.cfg.freeze2
local size = ini.cfg.sss
local sms = ini.cfg.smska
local titul_suchka = ini.cfg.titul_suchka

local win1 = imgui.new.bool(ini.cfg.ono1)
local win2 = imgui.new.bool(ini.cfg.ono2)
local win3 = imgui.new.bool(ini.cfg.ono3)


local window_pos1 = imgui.ImVec2(ini.cfg.pos_x1 or 100, ini.cfg.pos_y1 or 120)
local wsi1 = imgui.ImVec2(ini.cfg.size_x1 or 200, ini.cfg.size_y1 or 220)
local wsp2 = imgui.ImVec2(ini.cfg.pos_x2 or 400, ini.cfg.pos_y2 or 120)
local wsi2 = imgui.ImVec2(ini.cfg.size_x2 or 200, ini.cfg.size_y2 or 220)

function main()
    repeat wait(4000) until isSampAvailable()
    checkUpdate()
    sampAddChatMessage('{DC143C}[Кнопки]:{FFFFFF}Автор скрипта: {DC143C}Chipay_Skywalker!',-1)
    sampAddChatMessage('{DC143C}[Кнопки]:{FFFFFF}Введите {DC143C}/khelp {FFFFFF}для справки!',-1)
    sampRegisterChatCommand('khelp',function ()
        local helperka_epta=[[
        {FF0000} /dk - {FFFFFF}скрыть\показать окно 1
        {FF0000} /dk2 - {FFFFFF}скрыть\показать окно 2
        {FF0000} /k1-8 - {FFFFFF}команда\текст - биндит команду\текст
        {FF0000} /kn1-8 - {FFFFFF}название кнопок устанавлвается отдельно(добавлено по просьбе)
        {FF0000} /khelp - {FFFFFF}скрыть\показать это меню
        {FF0000} /dstill - {FFFFFF}скрыть\показать заголовок окно
        {FF0000} /num1 текст - {FFFFFF}устанавливает название окна(заголовок)
        {FF0000} /num2 текст - {FFFFFF}устанавливает название окна 2(заголовок)
        {FF0000}/kfreeze -  {FFFFFF}блокирует перемещение окна 1
        {FF0000}/kfreeze2 - {FFFFFF}блокирует перемещение окна 2
        {FF0000}/sizee - {FFFFFF}вкл\выкл изменение размера окон
        {FF0000}/ksms - {FFFFFF}отображение уведомлений вкл\выкл

        Примечание: одинаковые команды в одинаковых кнопках могут конфликтовать
            ]]
        sampShowDialog(1337,'Справочник', helperka_epta,'Закрыть','',0)
    end)
    sampRegisterChatCommand('upd', function()
        if not update_data then
            return sampAddChatMessage(u8("{DC143C}[Кнопки]: {FFFFFF}Обновлений не найдено."), -1)
        end

        lua_thread.create(function()
            sampAddChatMessage(u8("{DC143C}[Кнопки]: {FFFFFF}Скачиваю обновление..."), -1)
            local res = requests.get(update_data.url)
            if res.status_code == 200 then
                local f = io.open(thisScript().path, "wb")
                f:write(res.text)
                f:close()
                sampAddChatMessage(u8("{DC143C}[Кнопки]: {FFFFFF}Скрипт обновлен! Перезагрузка..."), -1)
                wait(2000)
                thisScript():reload()
            else
                sampAddChatMessage(u8("{DC143C}[Кнопки]: {FFFFFF}Ошибка при загрузке файла."), -1)
            end
        end)
    end)
    sampRegisterChatCommand('ksms',function ()
        active5 = not active5
        sms = not sms
        ini.cfg.smska = sms
        inicfg.save(ini,inif)
    sampAddChatMessage('Уведомления про изменения/активации функий: '.. (sms and '{00FF00}включено' or '{DC143C}выключено'),-1)
    end)    
    sampRegisterChatCommand('num1', function (arg)
        if arg and arg ~= '' then
            ini.cfg.name = arg
            inicfg.save(ini,inif)
            if sms then
        sampAddChatMessage('Название окна изменено на: '.. '{00FF00}'..arg,-1)
            end
        end
    end)
    sampRegisterChatCommand('num2',function (arg2)
        if arg2 and arg2 ~= '' then
            ini.cfg.name2 = arg2
            inicfg.save(ini,inif)
            if sms then
                sampAddChatMessage('Название окна изменено на: '..'{00FF00}'..arg2,-1)
            end
        end
    end)
    sampRegisterChatCommand('dk',function ()
        active = not active
        win1[0] = not win1[0]
        ini.cfg.ono1 = win1[0]
        cfg_save()
          if sms then
            sampAddChatMessage('Отображение окна: '..(win1[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('dk2',function ()
        win2[0] = not win2[0]
        active2 = not active2
        ini.cfg.ono2 = win2[0]
        cfg_save()
        if sms then
            sampAddChatMessage('Отображение окна 2: '..(win2[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('kcolor',function ()
        win3[0] = not win3[0]
        ini.cfg.ono3 = win3[0]
        cfg_save()
        if sms then
            sampAddChatMessage('Отображение окна конфигурации: ' ..(win3[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('dstill',function ()
        active7 = not active7
        titul_suchka = not titul_suchka
        ini.cfg.titul_suchka = titul_suchka
        inicfg.save(ini,inif)
          if sms then
            sampAddChatMessage('Отображение заголовка: '..(titul_suchka and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('sizee',function ()        
        active6 = not active6
        size = not size
        ini.cfg.sss = size
        inicfg.save(ini,inif)
         if sms then
            sampAddChatMessage('Изменение размера окон: '..(size and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('kfreeze',function ()
        active3 = not active3
        fz = not fz
        ini.cfg.freeze = fz
        inicfg.save(ini,inif)
        if sms then
        sampAddChatMessage('Блокировка перемещения окна 1: '..(fz and '{00FF00}включена' or '{DC143C}выключена'),-1)
        end
    end)
        sampRegisterChatCommand('kfreeze2',function ()
        active4 = not active4
        fz2 = not fz2
        ini.cfg.freeze = fz2
        inicfg.save(ini,inif)
        if sms then
            sampAddChatMessage('Блокировка перемещения окна 2: '..(fz2 and '{00FF00}включена' or '{DC143C}выключена'),-1)
        end
    end)

    for i = 1,8 do
            sampRegisterChatCommand('k'..i,function (param)
                if param and param ~= '' then
                    bindcfg.cmd["k"..i] = param
                    ini.cfg["k"..i] = param
                        if bindcfg.text["kn"..i] == '' or ' ' then
                            bindcfg.text["kn"..i] = param
                            ini.cfg["kn"..i] = param
                            inicfg.save(ini, inif)
                        else 
                            inicfg.save(ini, inif)
                        end
                    if sms then
                        sampAddChatMessage('Назначена команда/текст: '..'{DC143C}'.. param,-1)
                    end
                end 
            end)
    end
    for i = 1, 8 do
        sampRegisterChatCommand("kn"..i, function(param)
            if param and param ~= "" then
                bindcfg.text["kn"..i] = param
                ini.cfg["kn"..i] = param
                inicfg.save(ini, inif)
                if sms then
                    sampAddChatMessage('Название кнопки именено на: '..'{DC143C}'..param,-1)
                end
            end
        end)
    end
    wait(-1)

end

function checkUpdate()
    lua_thread.create(function()
        local response = requests.get(VERSION_URL)
        if response.status_code == 200 then
            local data = response.json()
            if data and data.version > CURRENT_VERSION then
                update_data = data
                sampAddChatMessage(u8("{DC143C}[Обновление]: {FFFFFF}Доступна новая версия v") .. data.version, -1)
                sampAddChatMessage(u8("{DC143C}[Обновление]: {FFFFFF}Введите {00FF00}/upd {FFFFFF}чтобы обновиться."), -1)
            end
        end
    end)
end

function ev.onSendCommand(cmd) -- ну тут и ежу понятно епт
    if cmd == '/q' then
        os.exit() -- посылает нахуй
        return false -- блокирует отправка команда серверу потому что памату
    end
end

function cfg_save()
    ini.cfg.pos_x1 = window_pos1.x
    ini.cfg.pos_y1 = window_pos1.y
    ini.cfg.size_x1 = wsi1.x
    ini.cfg.size_y1 = wsi1.y

    ini.cfg.pos_x2 = wsp2.x
    ini.cfg.pos_y2 = wsp2.y
    ini.cfg.size_x2 = wsi2.x
    ini.cfg.size_y2 = wsi2.y

    inicfg.save(ini, inif)
end
--[[
function wiwiwi()

end

imgui.OnInitialize(function()
wiwiwi()
end)]]

imgui.OnFrame(function()
    return win1[0] or win2[0] or win3[0]
end, function()
    local button_rows = 2
    local button_cols = 2
    local coop = 4
    local btn1, bthj
    local btw, bth2

        imgui.ShowDemoWindow()
        imgui.ShowStyleEditor()

    if win1[0] then
        imgui.SetNextWindowPos(window_pos1, imgui.Cond.Once)
        imgui.SetNextWindowSize(wsi1, size and imgui.Cond.Once or imgui.Cond.Always)


        local flag1 = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar
        if fz then
            flag1 = flag1 + imgui.WindowFlags.NoMove
        end

        if not titul_suchka  then
            flag1 = flag1 + imgui.WindowFlags.NoTitleBar
        end
        if not size then
            flag1 = flag1 + imgui.WindowFlags.NoResize
        end

        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.1,0.1,0.1,1.0)) -- цвет самого окна
        imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(0.3,0.3,0.8,1.0)) -- цвет кнопки
        imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.4, 0.4, 0.9, 1.0)) -- цвет при наведении мышкой на кнопку
        imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.2, 0.2, 0.7, 1.0)) -- цвет при нажатии на кнопку

        imgui.Begin(titul_suchka and u8(ini.cfg.name) or "##win1", nil,flag1)

        wsi1 = imgui.GetWindowSize()
        btn1 = (wsi1.x - 15) / button_cols
        bthj = (wsi1.y - 35) / button_rows

        for i = 1, coop do
            if i % button_cols ~= 1 then imgui.SameLine() end
            if imgui.Button(u8(bindcfg.text["kn"..i]), imgui.ImVec2(btn1, bthj)) then
                sampProcessChatInput(bindcfg.cmd["k"..i])
            end

        end

        window_pos1 = imgui.GetWindowPos()
        wsi1 = imgui.GetWindowSize()
        imgui.End()
        imgui.PopStyleColor(4)
        cfg_save()
    end

    if win2[0] then
        imgui.SetNextWindowPos(wsp2, imgui.Cond.Once)
        imgui.SetNextWindowSize(wsi2, size and imgui.Cond.Once or imgui.Cond.Always)


        local flag2 = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar

            if fz2 then
                flag2 = flag2 + imgui.WindowFlags.NoMove 
            end
                if not titul_suchka then
                    flag2 = flag2 + imgui.WindowFlags.NoTitleBar
                end
        if not size then
            flag2 = flag2 + imgui.WindowFlags.NoResize
        end
        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.1,0.1,0.1,1.0)) -- цвет самого окна
        imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(0.3,0.3,0.8,1.0)) -- цвет кнопки
        imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.4, 0.4, 0.9, 1.0)) -- цвет при наведении мышкой на кнопку
        imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.2, 0.2, 0.7, 1.0)) -- цвет при нажатии на кнопку

        imgui.Begin(titul_suchka and u8(ini.cfg.name2) or "##win2", nil,flag2)

        wsi2 = imgui.GetWindowSize()
        btw = (wsi2.x - 15) / button_cols
        bth2 = (wsi2.y - 35) / button_rows

        for i = 1, coop do
            if i % button_cols ~= 1 then imgui.SameLine() end
            local btn_index = i + 4
            if imgui.Button(u8(bindcfg.text["kn"..btn_index]), imgui.ImVec2(btw, bth2)) then
                sampProcessChatInput(bindcfg.cmd["k"..btn_index])
            end
        end

        wsp2 = imgui.GetWindowPos()
        wsi2 = imgui.GetWindowSize()
        imgui.End()
        imgui.PopStyleColor(4)

        cfg_save()
    end
    
    if win3[0] then
        -- style.FramePadding = ImVec2()
        
        imgui.SetNextWindowPos(imgui.ImVec2(500,350), imgui.Cond.Once)
        imgui.SetNextWindowSize(imgui.ImVec2(1200,400))
        local flag3 = imgui.WindowFlags.AlwaysAutoResize

        imgui.Begin(u8(ini.cfg.name3), nil,flag3)
        imgui.Text(u8'Окно кастомизации и индивидуального управления')
            if (imgui.Checkbox(u8'Отображение окна 1 ' .. (u8(win1[0] and ' включено ' or ' выключено ')),active)) then
                win1[0] = not win1[0]
                ini.cfg.ono1 = win1[0]
                cfg_save()
                if sms then
                    sampAddChatMessage('Отображение окна: ' .. (win1[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
                end
            end
            if (imgui.Checkbox(u8'Отображение окна 2 ' .. (u8(win2[0] and  ' включено ' or ' выключено ')),active2)) then
                win2[0] = not win2[0]
                ini.cfg.ono2 = win2[0]
                cfg_save()
                if sms then
                    sampAddChatMessage('Отображение окна 2: '..(win2[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
                end
            end
            if (imgui.Checkbox(u8'Блокировка перемещения окна 1: ' .. (u8(fz and ' включена ' or ' выключена ')),active3)) then
                fz = not fz
                ini.cfg.freeze = fz
                inicfg.save(ini,inif)
                if sms then
                    sampAddChatMessage('Блокировка перемещения окна 1: '..(fz and '{00FF00}включена' or '{DC143C}выключена'),-1)
                end
            end
            if (imgui.Checkbox(u8'Блокировка перемещения окна 2: ' .. (u8(fz2 and ' включена ' or ' выключена ')),active4)) then
                fz2 = not fz2
                ini.cfg.freeze = fz2
                inicfg.save(ini,inif)
                if sms then
                    sampAddChatMessage('Блокировка перемещения окна 2: '..(fz2 and '{00FF00}включена' or '{DC143C}выключена'),-1)
                end
            end
            if  (imgui.Checkbox(u8('Уведомления про изменения/активации функий: '.. (sms and ' включено ' or ' выключено ')),active5)) then
                sms = not sms
                ini.cfg.smska = sms
                inicfg.save(ini,inif)
                if sms then 
                    sampAddChatMessage('Уведомления про изменения/активации функий: '.. (sms and '{00FF00}включено' or '{DC143C}выключено'),-1)
                end
            end
            if (imgui.Checkbox(u8('Изменение размера окон: ' .. (size and ' включено ' or ' выключено ')),active6)) then
                size = not size
                ini.cfg.sss = size
                inicfg.save(ini,inif)
                if sms then
                    sampAddChatMessage('Изменение размера окон: '..(size and '{00FF00}включено' or '{DC143C}выключено'),-1)
                end
            end
            if (imgui.Checkbox(u8('Отображение заголовка: '..(titul_suchka and ' включено ' or ' выключено ')),active7)) then
                titul_suchka = not titul_suchka
                ini.cfg.titul_suchka = titul_suchka
                inicfg.save(ini,inif)
                if sms then
                    sampAddChatMessage('Отображение заголовка: '..(titul_suchka and '{00FF00}включено' or '{DC143C}выключено'),-1)
                end
            end
            imgui.SameLine()
            -- imgui.SetCursorPos(imgui.ImVec2(50, 100)) -- Отступ 50px по X и 100px по Y
            if (imgui.Button(u8('Справочник'),imgui.ImVec2(100,50))) then
                    win3[0] = not win3[0]
                    local helperka_epta=[[
                {FF0000} /dk - {FFFFFF}скрыть\показать окно 1
                {FF0000} /dk2 - {FFFFFF}скрыть\показать окно 2
                {FF0000} /k1-8 - {FFFFFF}команда\текст - биндит команду\текст
                {FF0000} /kn1-8 - {FFFFFF}название кнопок устанавлвается отдельно(добавлено по просьбе)
                {FF0000} /khelp - {FFFFFF}скрыть\показать это меню
                {FF0000} /dstill - {FFFFFF}скрыть\показать заголовок окно
                {FF0000} /num1 текст - {FFFFFF}устанавливает название окна(заголовок)
                {FF0000} /num2 текст - {FFFFFF}устанавливает название окна 2(заголовок)
                {FF0000}/kfreeze -  {FFFFFF}блокирует перемещение окна 1
                {FF0000}/kfreeze2 - {FFFFFF}блокирует перемещение окна 2
                {FF0000}/sizee - {FFFFFF}вкл\выкл изменение размера окон
                {FF0000}/ksms - {FFFFFF}отображение уведомлений вкл\выкл

                Примечание: одинаковые команды в одинаковых кнопках могут конфликтовать
                    ]]
                sampShowDialog(1337,'Справочник', helperka_epta,'Закрыть','',0)
            end
           -- imgui.FramePadding()
            -- imgui.ItemSpacing()
            -- imgui.WindowsBorderSize()
            -- imgui.FrameBorderSize()
            -- imgui.TabBorderSize()
            -- imgui.WindowTitleAlign()
            -- imgui.ButtonTextAlign()
            -- imgui.SetColorEditOptions()
        imgui.Text(u8'Команды никуда не убраны, это окно сделано для удобства и никак не станет заменой командам)')
        imgui.End()
        cfg_save()
    end
end)

