local white = Color.new(255,255,255)
local yellow = Color.new(255,205,66)
local red = Color.new(255,0,0)
local green = Color.new(55,255,0)
local curPos = 20

local pad = Controls.read()
local oldpad = pad

function sleep(n)
  local timer = Timer.new()
  local t0 = Timer.getTime(timer)
  while Timer.getTime(timer) - t0 <= n do end
end

function update()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.waitVblankStart()
    Screen.flip()
    if Network.isWifiEnabled() then
        Screen.debugPrint(5,5, "Downloading...", green, TOP_SCREEN)
        if System.doesFileExist("/freeShop/encTitleKeys.bin") then
        System.deleteFile("/freeShop/encTitleKeys.bin")
        end
        Network.downloadFile("http://matmaf.github.io/encTitleKeys.bin-Updater/f4g5h6.zip", "/f4g5h6.zip")
        Screen.debugPrint(5,35, "Extracting...", green, TOP_SCREEN)
        System.extractFromZIP("/f4g5h6.zip", "a1s2d3.bin", "/a1s2d3.bin")
        Screen.debugPrint(5,50, "Renaming...", green, TOP_SCREEN)
        System.renameFile("/a1s2d3.bin", "/freeShop/encTitleKeys.bin")
        Screen.debugPrint(5,65, "Cleaning up...", green, TOP_SCREEN)
        System.deleteFile("/f4g5h6.zip")
        Screen.debugPrint(5,80, "Done!", green, TOP_SCREEN)
        Screen.debugPrint(5,95, "Press START to return to Homemenu/HBL", green, TOP_SCREEN)
        Screen.debugPrint(5,110, "Press SELECT to reboot", green, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_START) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            elseif Controls.check(pad,KEY_SELECT) then
                System.reboot()
            end
        end

    else
        Screen.debugPrint(5,5, "WiFi is off! Please turn it on and retry!", red, TOP_SCREEN)
        Screen.debugPrint(5,20, "Press START to go back to HBL/Home menu", red, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_START) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            end
        end
    end
end

function main()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.debugPrint(5,5, "Welcome to encTitleKeys.bin updater!", yellow, TOP_SCREEN)
    Screen.debugPrint(0, curPos, "->", white, TOP_SCREEN)
    Screen.debugPrint(30,20, "Update .bin", white, TOP_SCREEN)
    Screen.debugPrint(30,35, "Return to Homemenu/HBL", white, TOP_SCREEN)
    Screen.flip()

	while true do
        pad = Controls.read()
        if Controls.check(pad,KEY_DDOWN) and not Controls.check(oldpad,KEY_DDOWN) then
            if (curPos < 35) then
                curPos = curPos + 15
                main()
            end
        elseif Controls.check(pad,KEY_DUP) and not Controls.check(oldpad,KEY_DUP) then
            if (curPos > 20) then
                curPos = curPos - 15
                main()
            end
        elseif Controls.check(pad,KEY_A) and not Controls.check(oldpad,KEY_A) then
            if (curPos == 20) then
                update()
            elseif (curPos == 35) then
                System.exit()
            end
        end
        oldpad = pad
    end
end

main()