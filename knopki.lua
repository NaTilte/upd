script_author("Chipay")
script_name("Knopochki")
local ev = require'lib.samp.events'
function ev.onSendCommand(cmd) -- ну тут и ежу понятно епт
    if cmd == '/q' then
        os.exit() -- посылает нахуй
        return false -- блокирует отправка команда серверу потому что памату
    end
end
local imgui = require "mimgui"
local encoding = require "encoding"
encoding.default = "CP1251"
local u8 = encoding.UTF8
local new = imgui.new
local inicfg = require "inicfg"
local ini=inicfg.load({
cfg={
    name = 'Кнопочки 1',
    name2 = 'Кнопочки 2',
    ono1 = true,
    ono2 = false,
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
}
},'kn.ini')

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
local nam = ini.cfg.name
local nam2 = ini.cfg.name2

local fz = ini.cfg.freeze
local fz2 = ini.cfg.freeze2
local size = ini.cfg.sss
local sms = ini.cfg.smska
local titul_suchka = ini.cfg.titul_suchka
local win1 = new.bool(ini.cfg.ono1)
local win2 = new.bool(ini.cfg.ono2)
local window_pos1 = imgui.ImVec2(ini.cfg.pos_x1 or 100, ini.cfg.pos_y1 or 100)
local wsi1 = imgui.ImVec2(ini.cfg.size_x1 or 200, ini.cfg.size_y1 or 200)
local wsp2 = imgui.ImVec2(ini.cfg.pos_x2 or 400, ini.cfg.pos_y2 or 100)
local wsi2 = imgui.ImVec2(ini.cfg.size_x2 or 200, ini.cfg.size_y2 or 200)

function main()
    repeat wait(4000) until isSampAvailable()
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
    sampRegisterChatCommand('ksms',function ()
        sms = not sms
        ini.cfg.smska = sms
        inicfg.save(ini,'kn.ini')
    sampAddChatMessage('Уведомления про изменения/активации функий: '.. (sms and '{00FF00}включено' or '{DC143C}выключено'),-1)
    end)    
    sampRegisterChatCommand('num1', function (arg)
        if arg and arg ~= '' then
            ini.cfg.name = arg
            inicfg.save(ini,'kn.ini')
            if sms then
        sampAddChatMessage('Название окна изменено на: '.. '{00FF00}'..arg,-1)
            end
        end
    end)
    sampRegisterChatCommand('num2',function (arg2)
        if arg2 and arg2 ~= '' then
            ini.cfg.name2 = arg2
            inicfg.save(ini,'kn.ini')
            if sms then
                sampAddChatMessage('Название окна изменено на: '..'{00FF00}'..arg2,-1)
            end
        end
    end)
    sampRegisterChatCommand('dk',function ()
        win1[0] = not win1[0]
        ini.cfg.ono1 = win1[0]
        cfg_save()
          if sms then
        sampAddChatMessage('Отображение окна: '..(win1[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('dk2',function ()
        win2[0] = not win2[0]
        ini.cfg.ono2 = win2
        cfg_save()
        if sms then
        sampAddChatMessage('Отображение окна 2: '..(win2[0] and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('dstill',function ()
        titul_suchka = not titul_suchka
        ini.cfg.titul_suchka = titul_suchka
        inicfg.save(ini,'kn.ini')
          if sms then
            sampAddChatMessage('Отображение заголовка: '..(titul_suchka and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('sizee',function ()
        size = not size
        ini.cfg.sss = size
        inicfg.save(ini,'kn.ini')
         if sms then
        sampAddChatMessage('Изменение размера окон: '..(size and '{00FF00}включено' or '{DC143C}выключено'),-1)
        end
    end)
    sampRegisterChatCommand('kfreeze',function ()
        fz = not fz
        ini.cfg.freeze = fz
        inicfg.save(ini,'kn.ini')
        if sms then
        sampAddChatMessage('Блокировка перемещения окна: '..(fz and '{00FF00}включена' or '{DC143C}выключена'),-1)
        end
    end)
        sampRegisterChatCommand('kfreeze2',function ()
        fz2 = not fz2
        ini.cfg.freeze = fz2
        inicfg.save(ini,'kn.ini')
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
                            inicfg.save(ini, "kn.ini")
                        else 
                            inicfg.save(ini, "kn.ini")
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
                inicfg.save(ini, "kn.ini")
             if sms then
        sampAddChatMessage('Название кнопки именено на: '..'{DC143C}'..param,-1)
        end
            end
        end)
    end
    wait(-1)

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

    inicfg.save(ini, "kn.ini")
end
--[[
function wiwiwi()

end

imgui.OnInitialize(function()
wiwiwi()
end)]]

imgui.OnFrame(function()
    return win1[0] or win2[0]
end, function()
    local button_rows = 2
    local button_cols = 2
    local coop = 4
    local btn1, bthj
    local btw, bth2

    --imgui.ShowDemoWindow()
    --imgui.ShowStyleEditor()
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

        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.545, 0.0, 0.0, 1.0))
        imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(1.0, 0.0, 0.0, 1.0))
        imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.4, 0.4, 0.9, 1.0))
        imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.2, 0.2, 0.7, 1.0))

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
        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.545, 0.0, 0.0, 1.0))
        imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(1.0, 0.0, 0.0, 1.0))
        imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.4, 0.4, 0.9, 1.0))
        imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.2, 0.2, 0.7, 1.0))

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
end)
