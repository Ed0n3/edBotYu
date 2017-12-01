-- Autor: Eduard Weber aka Ed0n3 / No0n3





-- Script global vars
dir = scriptPath()
foundDuelists = {}
isDuelling = false
foundDuel = false
swipeTimes = 0

dofile(scriptPath() .. "images.lua")
--dofile("")


setImmersiveMode(true)

completeAlphabet = { { 'a', 'A', '36', '52' }, { 'b', 'B', '40', '50' }, { 'c', 'C', '30', '50' }, { 'd', 'D', '30', '40' }, { 'e', 'E', '32', '40' }, { 'f', 'F', '24', '46' }, { 'g', 'G', '30', '50' }, { 'h', 'H', '28', '42' }, { 'i', 'I', '14', '20' }, { 'j', 'J', '30', '50' }, { 'k', 'K', '40', '36' }, { 'l', 'L', '14', '40' }, { 'm', 'M', '44', '60' }, { 'n', 'N', '32', '50' }, { 'o', 'O', '32', '50' }, { 'p', 'P', '32', '36' }, { 'q', 'Q', '30', '30' }, { 'r', 'R', '20', '40' }, { 's', 'S', '35', '40' }, { 't', 'T', '20', '42' }, { 'u', 'U', '40', '50' }, { 'v', 'V', '32', '50' }, { 'w', 'W', '36', '52' }, { 'x', 'X', '40', '45' }, { 'y', 'Y', '32', '50' }, { 'z', 'Z', '40', '50' }, { 'minus', 'minus', '20', '20' } }

function searchForDuelists()
    foundDuelists = listToTable(duelistWorldSmall_1_Region:findAllNoFindException(duelistWorldSmall_1))
    
    for k, v in ipairs(listToTable(duelistWorldSmall_1_Region:findAllNoFindException(duelistWorldSmall_2))) do
        table.insert(foundDuelists, v)
    end
    
    for k, v in ipairs(listToTable(duelistWorldMid_1_Region:findAllNoFindException(duelistWorldMid_1))) do
        table.insert(foundDuelists, v)
    end
    
    for k, v in ipairs(listToTable(duelistWorldBig_1_Region:findAllNoFindException(duelistWorldBig_1))) do
        table.insert(foundDuelists, v)
    end
    
    if (#foundDuelists == 1 and swipeTimes < 4) then --card trader found
        local removed = false
        for k, v in ipairs(foundDuelists) do
            if (v:getY() >= 1368 and v:getY() <= 1376 and v:getX() >= 566 and v:getX() <= 574) then
                swipe(Location(100, 800), Location(800, 800))
                swipeTimes = swipeTimes + 1
                table.remove(foundDuelists, k)
                removed = true
                break
            end
        end
        if (removed == true) then
            searchForDuelists()
        end
    end
    
    
    if (#foundDuelists == 0 and swipeTimes < 4) then
        swipe(Location(100, 800), Location(800, 800))
        swipeTimes = swipeTimes + 1
        searchForDuelists()
    end
    --[[
    if(foundDuelists ~= nil) then
        for k, v in ipairs(foundDuelists) do
            if(v) then
                --print(v)
                v:highlight("!", 2)
            end
        end
    end
    ]] --
end

function startDuel()
    local isDuelist = false
    
    for k, v in ipairs(foundDuelists) do
        if (v:getY() ~= 1372 and v:getX() ~= 570) then
            click(Location(v:getX() - 15, v:getY() + 15), 1)
            table.remove(foundDuelists, k)
            break
        end
        -- print(v:getX() .. " - " .. v:getY())
        --if(not cardTrader_Region:exists(cardTrader, 5)) then
    end
    while dialogOpened_Region:existsClick(dialogOpened, 1) == true do
        isDuelist = true
        if (autoDuelStartButton_Region:existsClick(autoDuelStartButton, 1) == true) then
            isDuelling = true
            return 2 --starting duel
        end
    end
    
    if (itemOkButton_Region:existsClick(itemOkButton, 1) == true) then
        return 3 -- got item
    end
    
    
    if (isDuelist == true and autoDuelStartButton_Region:existsClick(autoDuelStartButton, 13) == true) then
        isDuelling = true
        return 2 --starting duel
    end
    
    return 0 --cant start
end

function waitDuelling()
    local endBattle = true
    local noDuelist = false
    local itemCollected = false
    local dialog = false
    
    if (isDuelling) then
        while (isDuelling == true) do
            if (logButton_Region:exists(logButton, 2)) then
                click(Location(542, 1759))
                isDuelling = false
                endBattle = true
            end
        end
    end
    
    while (endBattle == true) do
        if (duelResults_Region:exists(duelResults, 1)) then
            click(Location(542, 1759))
        end
        
        if (dialogOpened_Region:existsClick(dialogOpened, 1) == true) then
            endBattle = false
        end
    end
    
    while (dialogOpened_Region:existsClick(dialogOpened, 1) == true) do --nothing
        dialog = true
    end
    
    if (exists(vagaFriendList, 3)) then
        click(Location(537, 852))
        if (existsClick(setChallengeButton, 3)) then
            swipe(Location(560, 1663), Location(560, 1033))
            click(Location(511, 1180))
        end
        if (Region(500, 400, 500, 800):existsClick(setChallengeOkButton, 3) == true) then
            while (dialogOpened_Region:existsClick(dialogOpened, 2) == true) do --nothing
                dialog = true
            end
        end
    end
    
    
    
    if (itemOkButton_Region:existsClick(itemOkButton, 3) == true) then
        itemOkButton_Region:existsClick(itemOkButton, 3)
        itemCollected = true
    end
    
    if (closeBeaconButton_Region:existsClick(closeBeaconButton, 3) == true) then
        noDuelist = true
    end
    
    if (dialog == true or noDuelist == true or itemCollected == true) then
        return 1
    end
    
    if (worldScreenSettingsButton_Region:exists(worldScreenSettingsButton, 1)) then
        return 1
    end
    
    return 0
end

function whereIAM()
    if (worldScreenSettingsButton_Region:exists(worldScreenSettingsButton, 0.5)) then
        return "world"
    elseif (autoDuelStartButton_Region:exists(autoDuelStartButton, 0.5)) then
        return "dialog"
    elseif (dialogOpened_Region:exists(dialogOpened, 0.5)) then
        return "dialog"
    elseif (logButton_Region:exists(logButton, 0.5)) then
        return "endbattle"
    else
        return "unknown"
    end
end


function runBot()
    local iAmAt = whereIAM()
    local startD = 0
    
    if (iAmAt == "world") then
        searchForDuelists()
        startD = startDuel()
    elseif (iAmAt == "dialog") then
        startD = startDuel()
    elseif (iAmAt == "endbattle") then
        if (waitDuelling() == 1) then
            runBot()
        end
    elseif (iAmAt == "unknown") then
        print("go back to world and start the bot")
    end
    
    if (startD == 0) then
        print("no duelist / item found")
    elseif (startD == 2) then
        if (waitDuelling() == 1) then
            runBot()
        end
    elseif (startD == 3) then
        runBot()
    elseif (startD == 5) then
        runBot()
    end
end

function getAtkDuel()
    local atk = numberOCRNoFindException(atk_region, "duel_")
    --print("Atk: " .. atk)
    return atk
end

function getAtkDuel()
    local def = numberOCRNoFindException(def_region, "duel_")
    --print("Atk: " .. atk)
    return def
end


function changeCursor(charackter)
    for i, v in ipairs(completeAlphabet) do
        if charackter == v[2] then
            if (charackter == 'W') then
                return 0.7, tonumber(v[4])
            elseif (charackter == 'M') then
                return 0.8, tonumber(v[4])
            elseif (charackter == 'T') then
                return 0.7, tonumber(v[4])
            end
            return 0.92, tonumber(v[4])
        elseif charackter == v[1] then
            if (charackter == 'l') then
                return 0.99, tonumber(v[3])
            elseif (charackter == 'c') then
                return 0.95, tonumber(v[3])
            elseif (charackter == 'a' or charackter == 'o' or charackter == 'y') then
                return 0.9, tonumber(v[3])
            elseif (charackter == 'i' or charackter == 'd' or charackter == 'm' or charackter == 'w') then
                return 0.7, tonumber(v[3])
            elseif (charackter == 'h' or charackter == 'n') then
                return 0.98, tonumber(v[3])
            end
            return 0.92, tonumber(v[3])
        end
    end
end


function readCardName()
    local timer = Timer()
    Settings:set("MinSimilarity", 0.92)
    local alphabet = { 'a', 'b', 'd', 'e', 'g', 'h', 'k', 'r', 'm', 'n', 'o', 'c', 'p', 'q', 's', 'u', 'y', 'v', 'w', 'x', 'z', 'f', 't', 'i', 'l', 'j', 'minus' }
    --local alphabet = { 'a', 'c', 'e', 'l', 'u', 't' }
    --local alphabet = { 'a', 'b', 'c', 'd', 'e', 'g', 'h', 'k', 'm', 'n', 'o', 'p', 'r', 't', 's', 'u', 'v', 'w', 'x', 'z' } --without i f j l
    local name = "-- "
    local found_alphabet = {}
    
    local cursor = 73
    local cursor_loop = 0
    local tmp_cursor = 0
    local cursor_width = 20
    local notFoundLoops = 0
    local notFoundLoops2 = 0
    local lastFound
    local moveCursor = false
    usePreviousSnap(false)
    
    local tempRegion = Region(cursor, 442, cursor_width, 76)
    local firstChar = true
    
    while (cursor <= 600) do
        local highlightReg = tempRegion
        highlightReg:highlight()
        
        for i, v in ipairs(alphabet) do
            local sim = 0.9
            local found
    
            --if firstChar == true then
    
            Settings:set("MinSimilarity", sim)
            sim, cursor_width = changeCursor(alphabet[i])
            tempRegion = Region(cursor, 442, cursor_width, 76)
            --tempRegion:highlight()
    
            --[[else
                tmpC, cursor_width = changeCursor(alphabet[i])
                tempRegion = Region(cursor, 448, cursor_width, 60)
                --tempRegion:highlight()
                found = tempRegion:exists("alphabetY/" .. alphabet[i] .. ".png", 0)
            end]] --
    
    
    
            if (firstChar == false) then --and firstChar == true) then
                --firstChar = false
                sim, cursor_width = changeCursor(alphabet[i])
                found = tempRegion:exists("alphabetY/" .. alphabet[i] .. ".png", 0)
                if (found) then
                    table.insert(found_alphabet, { v, found:getX() })
                    if (lastFound and (found:getX() <= lastFound:getX() + 5 and found:getX() >= lastFound:getX() - 5)) then
                        table.remove(found_alphabet, #found_alphabet)
                        cursor = found:getX() + found:getW() - 4
                        break
                    end
                    cursor = found:getX() + found:getW() - 4
                else
                    if (alphabet[i] == 'minus') then
                        break
                    end
                    sim, cursor_width = changeCursor(string.upper(alphabet[i]))
                    tempRegion = Region(cursor, 442, cursor_width, 76)
                    found = tempRegion:exists("alphabetY/" .. alphabet[i] .. alphabet[i] .. ".png", 0)
                    usePreviousSnap(true)
                    if (found) then
                        firstChar = false
                        --table.insert(found_alphabet, { ' ', 0 })
                        table.insert(found_alphabet, { string.upper(v), found:getX() })
                        if (lastFound and (found:getX() <= lastFound:getX() + 5 and found:getX() >= lastFound:getX() - 5)) then
                            table.remove(found_alphabet, #found_alphabet)
                            cursor = found:getX() + found:getW() - 4
                            break
                        end
                        cursor = found:getX() + found:getW() - 4
                    end
                end
            elseif (firstChar == true) then
                if (alphabet[i] == 'minus') then
                    break
                end
                sim, cursor_width = changeCursor(string.upper(alphabet[i]))
                tempRegion = Region(cursor, 442, cursor_width, 76)
                found = tempRegion:exists("alphabetY/" .. alphabet[i] .. alphabet[i] .. ".png", 0)
                usePreviousSnap(true)
                if (found) then
                    firstChar = false
                    --table.insert(found_alphabet, { ' ', 0 })
                    table.insert(found_alphabet, { string.upper(v), found:getX() })
                    if (lastFound and (found:getX() <= lastFound:getX() + 5 and found:getX() >= lastFound:getX() - 5)) then
                        table.remove(found_alphabet, #found_alphabet)
                        cursor = found:getX() + found:getW() - 4
                        break
                    end
                    cursor = found:getX() + found:getW() - 4
                else
                    sim, cursor_width = changeCursor(alphabet[i])
                    tempRegion = Region(cursor, 442, cursor_width, 76)
                    found = tempRegion:exists("alphabetY/" .. alphabet[i] .. ".png", 0)
                    if (found) then
                        firstChar = false
                        table.insert(found_alphabet, { v, found:getX() })
                        if (lastFound and (found:getX() <= lastFound:getX() + 5 and found:getX() >= lastFound:getX() - 5)) then
                            table.remove(found_alphabet, #found_alphabet)
                            cursor = found:getX() + found:getW() - 4
                            break
                        end
                        --cursor = cursor + cursor_width / 2
                        cursor = found:getX() + found:getW() - 4
                    end
                end
            end
    
            usePreviousSnap(true)
    
            if (found) then
                lastFound = found
                notFoundLoops = 0
                notFoundLoops2 = 0
                moveCursor = false
                break
            else
                moveCursor = true
            end
        end
        
        highlightReg:highlightOff()
        
        --cursor = cursor + 25
        local countWhitePixels = 0
        --[[for x = 1, 5 do
            for y = 1, 5 do
                local r, g, b = getColor(Location(10 + x, 30 + y))
                if (r == 255 and g == 255 and b == 255) then
                    countWhitePixels = countWhitePixels + 1
                end
            end
        end]] --
        
        if (countWhitePixels > 5) then
            print(countWhitePixels)
        end
        
        if (moveCursor == true) then
            cursor_loop = cursor_loop + 1
        else
            cursor_loop = 0
        end
        
        if (cursor_loop > 0) then
            cursor = cursor + 1
            notFoundLoops = notFoundLoops + 1
            notFoundLoops2 = notFoundLoops2 + 1
        end
        
        if (notFoundLoops >= 3) then
            table.insert(found_alphabet, { ' ', 0 })
            cursor = cursor + 5
            firstChar = true
            notFoundLoops = 0
            --usePreviousSnap(false)
        end
        
        if (notFoundLoops2 > 8) then
            notFoundLoops2 = 0
            break
        end
        
        
        
        tmp_cursor = cursor
        --tempRegion = Region(cursor, 448, cursor_width, 60)
    end
    
    usePreviousSnap(false)
    --[[for j, r in ipairs(found_alphabet) do
        --print(r[2])
        for k, s in ipairs(found_alphabet) do
            if (r[2] > s[2]) then

                --if(found_alphabet[j][2]:getTarget().x > found_alphabet[k][2]:getTarget().x) then
                local swap = found_alphabet[j]
                found_alphabet[j] = found_alphabet[k]
                found_alphabet[j] = swap
            end
        end
    end]] --
    
    for i, v in ipairs(found_alphabet) do
        if (v[1] == 'minus') then
            name = name .. '-'
        else
            name = name .. v[1]
        end
    end
    
    
    print(name .. "\n " .. timer:check())
    Settings:set("MinSimilarity", 0.8)
end

--X

function tryDebug()
    --do something
end

--tryDebug()
readCardName()
--runBot()
--getAtkDuel()
