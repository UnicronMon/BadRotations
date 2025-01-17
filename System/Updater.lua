local _,
---@class BR
br = ...
----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
-- local cdnUrl = "https://cdn.badrotations.org/"
local apiUrl = "https://www.badrotations.org/"

br.updater = {}

local addonPath
local currentCommit
local latestCommit
local purple = "|cffa330c9"
local isInitialized = false

----------------------------------------------------------------------------------------------------
-- Utilities
----------------------------------------------------------------------------------------------------
local function IsSettingChecked()
   return br.isChecked("Auto Check for Updates")
end

---@param msg string
local function Print(msg)
   if msg == nil then
      return
   end
   print(br.classColor .. "[BadRotations] |cffFFFFFF" .. msg)
end

---@param msg string
local function PrintError(msg)
   if msg == nil then
      return
   end
   print(br.classColor .. "[BadRotations] |cffff6666" .. msg)
end

---@param message string
local function RaidWarning(message)
   if br.isChecked("Overlay Messages") then
      br._G.RaidNotice_AddMessage(br._G.RaidWarningFrame, message, {r = 1, g = 0.3, b = 0.1})
   end
end

---@param url string
---@param OnComplete fun(body: string, code: number, req: table, res: number, err: string)
local function SendRequestAsync(url, OnComplete)
   br._G.SendHTTPRequest(
      url,
      nil,
      function(body, code, req, res, err)
         if type(OnComplete) == "function" then
            OnComplete(body, code, req, res, err)
         end
      end,
      nil,
      0
   )
end

----------------------------------------------------------------------------------------------------
-- Update
----------------------------------------------------------------------------------------------------
function br.updater:Update()
   if not IsSettingChecked() then
      Print("Setting is disabled. To enable: Configuration > General > Auto Check for Updates")
   else
      Print("In-game updating coming Soon™")
   end
end

----------------------------------------------------------------------------------------------------
-- Check for Updates
----------------------------------------------------------------------------------------------------

---@param OnComplete fun(body: string, code: number, req: table, res: number, err: string)
local function SetLatestCommitAsync(OnComplete)
   local url = apiUrl .. "commits/latest"

   SendRequestAsync(
      url,
      function(body, code, req, res, err)
         latestCommit = body

         if type(OnComplete) == "function" then
            OnComplete(body, code, req, res, err)
         end
      end
   )
end

---@param OnComplete? fun(json?: string)
local function CheckForUpdatesAsync(OnComplete)
   SetLatestCommitAsync(
      function()
         if currentCommit == latestCommit then
            if type(OnComplete) == "function" then
               OnComplete()
            end
         end

         local url = apiUrl .. "commits/diff/" .. currentCommit
         SendRequestAsync(
            url,
            function(json)
               local aheadBy = json:match('"AheadBy":(.-),')
               if aheadBy == "0" then
                  return
               -- if not isInitialized then
               --    Print("Up to date. Version "..purple..currentCommit:sub(1, 7))
               -- end
               -- if type(OnComplete) == "function" then
               --    OnComplete(json)
               -- end
               -- return
               end

               local commitSection = json:match('"Commits":%[(.-)%]')
               Print(
                  "Local version: " ..
                     purple ..
                        currentCommit:sub(1, 7) ..
                           " |cffFFFFFFLatest version: " .. purple .. latestCommit:sub(1, 7) .. "."
               )
               if commitSection then
                  for commit in commitSection:gmatch("{(.-)}") do
                     local author = commit:match('"Author":"(.-)",')
                     local message = commit:match('"Message":"(.-)["\r\n]')
                     print("    " .. purple .. author .. ": |cffFFFFFF " .. message)
                  end
               else
                  print("     No commits were returned! Blame Shell!")
               end

               --    Print("BadRotations is currently "..purple..aheadBy.." |cffffffff".."versions out of date.\n"..
               --    "Please update for best performance via Git or "..purple.."/br update")
               --    RaidWarning("BadRotations is currently " .. aheadBy .. " versions out of date.\nPlease update for best performance via Git or "..purple.."/br update")
               if aheadBy then
                  Print(
                     "BadRotations is currently " ..
                        purple ..
                           aheadBy ..
                              " |cffffffff" .. "versions out of date.\n" .. "Please update for best performance."
                  )
                  RaidWarning(
                     "BadRotations is currently " ..
                        aheadBy .. " versions out of date.\nPlease update for best performance."
                  )
               end

               if type(OnComplete) == "function" then
                  OnComplete(json)
               end
            end
         )
      end
   )
end

-- Called on timer from System/Unlockers.lua after EWT has been loaded
function br.updater:CheckOutdated()
   if not IsSettingChecked() then
      return
   end

   br.updater:Initialize()
   if not isInitialized then
      return
   end
   CheckForUpdatesAsync()
end

----------------------------------------------------------------------------------------------------
-- Initialize
----------------------------------------------------------------------------------------------------
local function GetAddonName()
   for i = 1, br._G.GetNumAddOns() do
      local name, title = br._G.GetAddOnInfo(i)
      if title == purple .. "BadRotations" then
         return name
      end
   end
end

---@param latestCommit string
local function InitCurrentCommit(latestCommit)
   local headFile = addonPath .. ".git\\refs\\heads\\master"
   local headContent = br._G.ReadFile(headFile)

   if headContent ~= nil then
      currentCommit = headContent
      return true
   end

   -- Using Git, not GitHub can change the master branch to 'main'
   headFile = addonPath .. ".git\\refs\\heads\\main"
   headContent = br._G.ReadFile(headFile)

   if headContent ~= nil then
      currentCommit = headContent
      return true
   end

   currentCommit = latestCommit
   PrintError(
      "Couldn't detect local Git master commit. ASSUMING latest version. Redownload may be needed if problems arise."
   )
   Print("Version: " .. purple .. currentCommit:sub(1, 7))
   br._G.WriteFile(headFile, latestCommit, false, true)
   return false
end

local initRequested = false
function br.updater:Initialize()
   if initRequested then
      return
   end
   initRequested = true
   addonPath = br._G.GetWoWDirectory() .. "\\Interface\\AddOns\\" .. GetAddonName() .. "\\"

   SetLatestCommitAsync(
      function()
         local hadLocalVersion = InitCurrentCommit(latestCommit)
         if not hadLocalVersion then
            return
         end
         if currentCommit == latestCommit then
            return
         end

         CheckForUpdatesAsync(
            function()
               isInitialized = true
            end
         )
      end
   )
end
