-- Autor: Eduard Weber aka Ed0n3 / No0n3

--script global vars
dir = scriptPath()
foundDuelists = {}
isDuelling = false
foundDuel = false
swipeTimes = 0

face1 = Pattern("face1.png")
backButton = Pattern("backbtn.png")
itemOkButton = Pattern("item_ok.png")
nextButton = Pattern("nextButton.png")
dialogOpened = Pattern("dialogOpened.png")
autoDuelStartButton = Pattern("autoDuelDialog.png")
duelistWorldMid_1 = Pattern("duelist_world_mid1.png")
duelistWorldBig_1 = Pattern("duelist_world_big1.png")
duelistWorldSmall_1 = Pattern("duelist_world_small1.png")
duelistWorldSmall_2 = Pattern("duelist_world_small2.png")
saveReplay = Pattern("saveReplayEndBattle.png")
initiateLinkButton = Pattern("initiateLinkButton.png")
worldScreenSettingsButton = Pattern("worldScreenSettingsButton.png")
duelResults = Pattern("duelResults.png")
logButton = Pattern("logButton.png")
cardTrader = Pattern("cardTrader.png")
setChallengeButton = Pattern("setChallengeButton.png")
setChallengeOkButton = Pattern("setChallengeOkButton.png")
vagaFriendList = Pattern("vagaFriendList.png")
closeBeaconButton = Pattern("closeBeaconButton.png")
noDuelist = Pattern("noDuelist.png")


duelistWorldSmall_1_Region = Region(20,900,1040,300)
duelistWorldMid_1_Region = Region(20,1050,1040,400)
duelistWorldBig_1_Region = Region(20,1200,1040,500)
backbtn_region = Region(0, 1775, 210, 158)
saveReplay_Region = Region(5,1500, 402, 150)
initiatelink_region = Region(70, 1285, 696, 200)
dialogOpened_Region = Region(401, 1310, 678, 266)
itemOkButton_Region = Region(47, 641, 975, 624)
autoDuelStartButton_Region = Region(530, 1574, 546, 206)
worldScreenSettingsButton_Region = Region(944, 216, 109, 121)
nextButton_Region =  Region(247, 1742, 278, 113)
duelResults_Region = Region(27, 97, 259, 234)
logButton_Region = Region(791, 1530, 183, 95)
cardTrader_Region = Region(33, 79, 304, 96)
closeBeaconButton_Region = Region(254, 1349, 460, 167)
noDuelist_Region = Region(138, 60, 73, 110)


setImmersiveMode(true)


function searchForDuelists()
    foundDuelists = listToTable(duelistWorldSmall_1_Region:findAllNoFindException(duelistWorldSmall_1))

    for k,v in ipairs(listToTable(duelistWorldSmall_1_Region:findAllNoFindException(duelistWorldSmall_2))) do
            table.insert(foundDuelists, v)
    end

    for k,v in ipairs(listToTable(duelistWorldMid_1_Region:findAllNoFindException(duelistWorldMid_1))) do
        table.insert(foundDuelists, v)
    end

    for k,v in ipairs(listToTable(duelistWorldBig_1_Region:findAllNoFindException(duelistWorldBig_1))) do
        table.insert(foundDuelists, v)
    end

    if(#foundDuelists == 1 and swipeTimes < 4) then --card trader found
        local removed = false
        for k, v in ipairs(foundDuelists) do
            if(v:getY() >= 1368 and v:getY() <= 1376 and v:getX() >= 566 and v:getX() <= 574) then
                swipe(Location(100, 800), Location(800, 800))
                swipeTimes = swipeTimes + 1
                table.remove(foundDuelists, k)
                removed = true
                break
            end
        end
        if(removed == true) then
            searchForDuelists()
        end
    end


    if(#foundDuelists == 0 and swipeTimes < 4) then
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
    ]]--
end

function startDuel()
    local isDuelist = false

    for k, v in ipairs(foundDuelists) do
        if(v:getY() ~= 1372 and v:getX() ~= 570) then
            click(Location(v:getX()-15, v:getY()+15), 1)
            table.remove(foundDuelists, k)
            break
        end
       -- print(v:getX() .. " - " .. v:getY())
        --if(not cardTrader_Region:exists(cardTrader, 5)) then
    end
    while dialogOpened_Region:existsClick(dialogOpened, 3) == true do
        isDuelist = true
        if (autoDuelStartButton_Region:existsClick(autoDuelStartButton, 3) == true) then
            isDuelling = true
            return 2 --starting duel
        end
    end

    if (itemOkButton_Region:existsClick(itemOkButton, 3) == true) then
        return 3 -- got item
    end


    if(isDuelist == true and autoDuelStartButton_Region:existsClick(autoDuelStartButton, 3) == true) then
        isDuelling = true
        return 2 --starting duel
    end

    return 0 --cant start
end

function waitDuelling()
    local endBattle = true
    if(isDuelling) then
        while (isDuelling == true) do
           if(logButton_Region:exists(logButton, 2)) then
               click(Location(542, 1759))
               isDuelling = false
               endBattle = true
           end
        end
    end

    while (endBattle == true) do
        if(duelResults_Region:exists(duelResults, 3)) then
            click(Location(542, 1759))
        end

        if(dialogOpened_Region:existsClick(dialogOpened, 3) == true) then
            endBattle = false
        end
    end

    while (dialogOpened_Region:existsClick(dialogOpened, 2) == true) do --nothing
    end

    if (exists(vagaFriendList, 3)) then
        click(Location(537, 852))
        if(existsClick(setChallengeButton, 3)) then
            swipe(Location(560, 1663),Location(560,1033))
            click(Location(511,1180))
        end
        if(Region(500, 400, 500, 800):existsClick(setChallengeOkButton, 3) == true) then
            while (dialogOpened_Region:existsClick(dialogOpened, 2) == true) do --nothing
            end
        end

    end



    if(itemOkButton_Region:existsClick(itemOkButton, 3) == true) then
        itemOkButton_Region:existsClick(itemOkButton, 3)
        return 1
    end


    return 0
end

function whereIAM()
    if (worldScreenSettingsButton_Region:exists(worldScreenSettingsButton, 1))then
        return "world"
    elseif(autoDuelStartButton_Region:exists(autoDuelStartButton, 1)) then
        return "dialog"
    elseif(dialogOpened_Region:exists(dialogOpened, 1)) then
        return "dialog"
    elseif (logButton_Region:exists(logButton, 1)) then
        return "endbattle"
    else
        return "unknown"
    end
end

--[[function duelOrbsAvaible()
    if(closeBeaconButton_Region:existsClick(closeBeaconButton, 3) == true) then
        return 0
    elseif (noDuelist_Region:exists(noDuelist, 2)) then
       return 0
    end
    return 1
end ]]--

function runBot()
    local iAmAt = whereIAM()
    local startD = 0

    if(iAmAt == "world") then
       -- if(duelOrbsAvaible() == 1) then
            searchForDuelists()
            startD = startDuel()
       -- end
    elseif (iAmAt == "dialog") then
        startD = startDuel()
    elseif(iAmAt == "endbattle") then
        if(waitDuelling() == 1) then
            runBot()
        end
    elseif (iAmAt == "unknown") then
        print("go back to world and start the bot")
    end

    if(startD == 0) then
        toast("no duelist / item found")
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




function tryDebug()
    --do something
end

--tryDebug()
runBot()

