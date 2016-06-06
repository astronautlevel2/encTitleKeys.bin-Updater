local white = Color.new(255,255,255)
local yellow = Color.new(255,205,66)
local red = Color.new(255,0,0)
local green = Color.new(55,255,0)
local curPos = 20
local motd = ""
local size = 0
local usersize = 0

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
        if System.doesFileExist("/f4g5h6.zip") then
        System.deleteFile("/f4g5h6.zip")
        end
        System.createDirectory("/freeShop")
        Network.downloadFile("http://matmaf.github.io/encTitleKeys.bin-Updater/f4g5h6.zip", "/f4g5h6.zip")
        Screen.debugPrint(5,20, "Extracting...", green, TOP_SCREEN)
        System.extractFromZIP("/f4g5h6.zip", "a1s2d3.bin", "/a1s2d3.bin")
        if System.doesFileExist("/a1s2d3.bin") then
        System.deleteFile("/freeShop/encTitleKeys.bin")
        end
        Screen.debugPrint(5,35, "Renaming...", green, TOP_SCREEN)
        System.renameFile("/a1s2d3.bin", "/freeShop/encTitleKeys.bin")
        Screen.debugPrint(5,50, "Cleaning up...", green, TOP_SCREEN)
        System.deleteFile("/f4g5h6.zip")
        Screen.debugPrint(5,65, "Done!", green, TOP_SCREEN)
        Screen.debugPrint(5,95, "Press A to launch freeShop", green, TOP_SCREEN)
        Screen.debugPrint(5,110, "Press B to go back to Homemenu", green, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_B) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            elseif Controls.check(pad,KEY_A) then
            	Screen.waitVblankStart()
                Screen.flip()
            	System.launchCIA(0x0f12ee00,SDMC)
            end
        end

    else
        Screen.debugPrint(5,5, "Wi-Fi is disabled. Restart and try again.", red, TOP_SCREEN)
        Screen.debugPrint(5,20, "Press A to go back to Homemenu", red, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_A) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            end
        end
    end
end


function init()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	if Network.isWifiEnabled() then
		motd = Network.requestString("http://matmaf.github.io/encTitleKeys.bin-Updater/motd")
		size = tonumber(Network.requestString("http://matmaf.github.io/encTitleKeys.bin-Updater/size"))
		if System.doesFileExist("/freeShop/encTitleKeys.bin") then
			local fileStream = io.open("/freeShop/encTitleKeys.bin", FREAD)
            		usersize = tonumber(io.size(fileStream))
            		io.close(fileStream)
		end
	else
		Screen.debugPrint(5,5, "Wi-Fi is disabled. Restart and try again.", red, TOP_SCREEN)
        	Screen.debugPrint(5,20, "Press A to go back to Homemenu", red, TOP_SCREEN)
        	Screen.waitVblankStart()
        	Screen.flip()
        	while true do
         		pad = Controls.read()
            		if Controls.check(pad,KEY_A) then
                		System.exit()
            		end
        	end
	end
end

function main()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.debugPrint(5,5, "encTitleKeysUpdater for freeShop", yellow, TOP_SCREEN)
    Screen.debugPrint(20,curPos, ">", white, TOP_SCREEN)
    Screen.debugPrint(30,20, "Download latest .bin", white, TOP_SCREEN)
    Screen.debugPrint(30,35, "Back to Homemenu", white, TOP_SCREEN)
    Screen.debugPrint(30,200, "v1.2", white, TOP_SCREEN)
    Screen.debugPrint(30,215, "by MatMaf", white, TOP_SCREEN)
    if usersize == size then
    	Screen.debugPrint(5,20, "encTitleKeys.bin is up to date.", green, BOTTOM_SCREEN)
    else
    	Screen.debugPrint(5,20, "encTitleKeys.bin is not up to date.", red, BOTTOM_SCREEN)
    end
    Screen.debugPrint(5,5, motd, white, BOTTOM_SCREEN)
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

init()
main()
