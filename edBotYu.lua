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

completeAlphabet = { { 'a', 'A', '30', '40' }, { 'b', 'B', '30', '40' }, { 'c', 'C', '30', '40' }, { 'd', 'D', '30', '40' }, { 'e', 'E', '30', '40' }, { 'f', 'F', '20', '40' }, { 'g', 'G', '30', '40' }, { 'h', 'H', '30', '40' }, { 'i', 'I', '20', '30' }, { 'j', 'J', '30', '40' }, { 'k', 'K', '30', '40' }, { 'l', 'L', '20', '40' }, { 'm', 'M', '50', '60' }, { 'n', 'N', '30', '40' }, { 'o', 'O', '30', '45' }, { 'p', 'P', '30', '40' }, { 'q', 'Q', '30', '50' }, { 'r', 'R', '30', '40' }, { 's', 'S', '30', '40' }, { 't', 'T', '20', '40' }, { 'u', 'U', '30', '40' }, { 'v', 'V', '40', '40' }, { 'w', 'W', '50', '60' }, { 'x', 'X', '30', '45' }, { 'y', 'Y', '30', '40' }, { 'z', 'Z', '30', '40' } }

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
            return 0, v[4]
        elseif charackter == v[1] then
            return 0, v[3]
        end
    end
    return 0, 40
end


function readCardName()
    Settings:set("MinSimilarity", 0.90)
    local alphabet = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }
    --local alphabet = { 'a', 'c', 'e', 'l', 'u', 't' }
    --local alphabet = { 'a', 'b', 'c', 'd', 'e', 'g', 'h', 'k', 'm', 'n', 'o', 'p', 'r', 't', 's', 'u', 'v', 'w', 'x', 'z' } --without i f j l
    local name = "-- "
    local found_alphabet = {}

    local tempRegion = Region(72, 448, 60, 60)
    local cursor = 72
    local cursor_loop = 0
    local tmp_cursor = 0


    local tempRegion = Region(cursor, 448, cursor_width, 60)

    while (cursor < 250) do
        tempRegion:highlight()
        for i, v in ipairs(alphabet) do
            local tmpC
            local found

            if firstChar==true then tmpC, cursor_width = changeCursorWidth(alphabet[i], true)
            else tmpC, cursor_width = changeCursorWidth(alphabet[i], false) end

            if (firstChar == false and nextChar == true) then cursor = cursor + tmpC end

            if (firstChar == false) then
                found = tempRegion:exists("alphabetY/" .. alphabet[i] .. ".png", 0.01)
            else
                found = tempRegion:exists("alphabetY/" .. alphabet[i] .. alphabet[i] .. ".png", 0.01)
            end

            if (found and firstChar == true) then
                --print(found)
                firstChar = false
                cursor_width = 40
                table.insert(found_alphabet, { v, found:getX() })
                cursor = cursor + found:getW()
                break
            elseif (found) then
                --found = tempRegion:exists("alphabetY/" .. alphabet[i] .. alphabet[i] .. ".png", 0.01)
                table.insert(found_alphabet, { v, found:getX() })
                cursor = cursor + found:getW()
                break
            end
        end

        --cursor = cursor + 25
        tempRegion:highlightOff()
        if (tmp_cursor == cursor) then
            cursor_loop = cursor_loop + 1
        else
            cursor_loop = 0
        end

        if (cursor_loop > 1) then
            cursor = cursor + 25
        end

        tmp_cursor = cursor
        tempRegion = Region(cursor, tempRegion:getY(), cursor_width, tempRegion:getH())
    end

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
        name = name .. v[1]
    end


    print(name)
end

--X

function tryDebug()
    --do something
end

--tryDebug()
--readCardName()
runBot()
--getAtkDuel()
