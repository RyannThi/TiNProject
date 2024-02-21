-- Custom Resource Loader
-- by Kalei (i suffered so much for this)

-- LuaSTG Sub only
-- (if you ask me to backport this i will End you and then tell you to do it yourself)

-- Requires THlib aex+ v0.8.22
-- (https://github.com/Legacy-LuaSTG-Engine/Bundle-After-Ex-Plus)

-- Installation Instructions:
-- 1. make THlib/THlib.lua look like this:
--[[

-- [...]
Include 'THlib/resourcesRedirect.lua'
Include 'THlib/misc/misc.lua'

Include 'path/to/resource_loader.lua' -- place immediately after misc.lua

Include 'THlib/se/se.lua'
-- [...]
Include 'THlib/UI/menu.lua'
Include 'THlib/editor.lua'

TexResLoad_BufferCall('_LoadImageFromFile') -- place immediately after editor.lua
TexResLoad_BufferCall('_LoadImageGroupFromFile') -- place immediately after editor.lua

Include 'THlib/UI/UI.lua'
Include 'sp/sp.lua'

]]--
-- 2. at the end of launcher.lua and THlib/ext/ext.lua, change
--[[ SceneManager.setNext("GameScene") ]]
-- to
--[[ SceneManager.setNext("LoadScene") ]]
--
-- 3. put this line in THlib/laser/laser.lua, after function LoadLaserTexture definition
--[[ LoadLaserTex_BufferCall() ]]
--
-- 4. comment out the function definitions for DefaultScene:onUpdate() and
--    DefaultScene:onRender() in core.lua
--
-- it should work now

-- luastg hijack
OLD_LoadImage = LoadImage
OLD_LoadTexture = LoadTexture
OLD_LoadFont = LoadFont
OLD_LoadSound = LoadSound
OLD_LoadMusic = LoadMusic
OLD_LoadTTF = LoadTTF
OLD_LoadFX = LoadFX
OLD_LoadModel = LoadModel
local hijacked = {
    'LoadImage',
    'LoadTexture',
    'LoadFont',
    'LoadSound',
    'LoadMusic',
    'LoadTTF',
    'LoadFX',
    'LoadModel',
}


local img_list = {}
local tex_list = {}
local tex_mip_list = {}
local fnt_list = {}
local fnt_mip_list = {}

local snd_list = {}
local fx__list = {}
local mdl_list = {}

local bgm_list = {}
local ttf_list = {}

function LoadTexture(n, p, mip)
    if mip then
        tex_mip_list[n] = p
    else
        tex_list[n] = p
    end
end
function LoadFont(n, p, mip)
    if mip then
        fnt_mip_list[n] = p
    else
        fnt_list[n] = p
    end
end

function LoadSound(n, p)
    snd_list[n] = p
end
function LoadFX(n, p)
    fx__list[n] = p
end
function LoadModel(n, p)
    mdl_list[n] = p
end

function LoadMusic(n, p, loopend, looplength)
    bgm_list[n] = { p, loopend, looplength }
end
function LoadTTF(n, p, width, height)
    ttf_list[n] = { p, width, height }
end
function LoadImage(n, ...)
    img_list[n] = { ... }
end

-- if you want mipmaps to be created, use these functions.
-- otherwise, you should be able to pass in these functions to ChargeRes as arg #2.
local function TexLoaderMip(n, p)
    -- lstg.MsgBoxWarn(n .. ',' .. p)
    OLD_LoadTexture(n, p, true)
end
local function FntLoaderMip(n, p)
    OLD_LoadFont(n, p, true)
end

-- since bgm resources have extra parameters (loopend, looplength), p will be a table
-- p: { filepath, loopend, looplength }
-- this means that a table of music resources would look like:
-- { ['bgmname'] = { 'path/to/music', 420, 69 } }
local function BgmLoader(n, p)
    OLD_LoadMusic(n, unpack(p))
end

-- since ttf resources have extra parameters (width, height), p will be a table
-- p: { filepath, width, height }
-- this means that a table of ttf resources would look like:
-- { ['ttfname'] = { 'path/to/ttf', 420, 69 } }
local function TtfLoader(n, p)
    OLD_LoadTTF(n, unpack(p))
end

-- since image resources are not file-based, p will be a table
-- p: { tex, x, y, width, height, ... }
-- this means that a table of ttf resources would look like:
-- { ['imgname'] = { 'texname', 420, 69, 42, 64, ... } }
local function ImgLoader(n, p)
    -- local s = ''
    -- for i, v in ipairs(p) do
    --     if i == 6 then break end
    --     s = s .. v .. ','
    -- end
    -- lstg.MsgBoxWarn(s)
    OLD_LoadImage(n, unpack(p))
end

local buf_done = false
local current_res = ''

-- list must be in the format { ['resname'] = 'path/to/res' }, unless using BgmLoader (see above)
-- loaderfunc can be any function that takes a resource name as 1st arg, path as 2nd arg,
-- and has no other required arguments.
-- do not use parentheses for loaderfunc.
function Task_LoadRes(list, loaderfunc)
    return function()
        buf_done = false
        local interval = 1 / 50
        local stopwatch = StopWatch()
        for n, p in pairs(list) do
            local p2
            if type(p) == "table" then
                p2 = p[1]
            else
                p2 = p
            end
            current_res = n .. ' (' .. p2 .. ')'
            loaderfunc(n, p)
            if stopwatch:GetElapsed() > interval then
                task.Wait()
                stopwatch:Reset()
            end
            stopwatch:Resume()
        end
        buf_done = true
    end
end


-- gay baby jail for misbehaving functions
local call_buffer = {}

function ResLoad_BufferCall(fname)
    _G['OLD_' .. fname] = _G[fname]
    call_buffer[fname] = {}
    _G[fname] = function(...)
        table.insert(call_buffer[fname], {...})
    end
end

-- evil-sealing workaround
function TexResLoad_BufferCall(fname)
    _G['OLD_' .. fname] = _G[fname]
    call_buffer[fname] = {}
    _G[fname] = function(n, p, mip, ...)
        -- lstg.MsgBoxWarn(n)
        LoadTexture(n, p, mip)
        table.insert(call_buffer[fname], {n, p, mip, ...})
    end
end

-- lasers are Evil, man
function LoadLaserTex_BufferCall()
    local fname = 'LoadLaserTexture'
    _G['OLD_' .. fname] = _G[fname]
    call_buffer[fname] = {}
    _G[fname] = function(text, l1, l2, l3, margin)
        -- lstg.MsgBoxWarn(n)
        local texture = "laser" .. laser_texture_num
        LoadTexture(texture, "THlib/laser/" .. text .. ".png")
        table.insert(call_buffer[fname], {text, l1, l2, l3, margin})
        laser_texture_num = laser_texture_num + 1 -- thanks for making it global, dipshit
    end
end

-- local buf_done = false

function Task_CallBuffer(fname)
    return function()
        if fname == 'LoadLaserTexture' then
            laser_texture_num = 1 -- fuck you
        end
        buf_done = false
        _G[fname] = _G['OLD_' .. fname]
        _G['OLD_' .. fname] = nil
        local interval = 1 / 50
        local stopwatch = StopWatch()
        for _, v in ipairs(call_buffer[fname]) do
            _G[fname](unpack(v))
            if stopwatch:GetElapsed() > interval then
                task.Wait()
                stopwatch:Reset()
            end
            stopwatch:Resume()
        end
        buf_done = true
    end
end

-- hall of shame
ResLoad_BufferCall('SetImageState')
-- ResLoad_BufferCall('GetTextureSize') -- wasted time
ResLoad_BufferCall('SetImageCenter')
ResLoad_BufferCall('SetImageScale')
ResLoad_BufferCall('LoadAnimation')
ResLoad_BufferCall('SetAnimationState')
ResLoad_BufferCall('SetAnimationScale')
ResLoad_BufferCall('SetTextureSamplerState')

-- hall of double shame
TexResLoad_BufferCall('LoadImageFromFile')
TexResLoad_BufferCall('LoadAniFromFile')
TexResLoad_BufferCall('LoadImageGroupFromFile')
-- fuck you in particular
-- TexResLoad_BufferCall('_LoadImageFromFile') -- in THlib/THlib.lua
-- TexResLoad_BufferCall('_LoadImageGroupFromFile') -- in THlib/THlib.lua

-- congrats! you win the biggest asshole award.
-- LoadLaserTex_BufferCall('LoadLaserTexture') -- in THlib/laser/laser.lua

-- finally
local SceneManager = require("foundation.SceneManager")

---@class game.LoadScene : foundation.Scene
local LoadScene = SceneManager.add("LoadScene")

-- init local vars
local timer = 0

function LoadScene:onCreate()
    -- DON'T TOUCH THIS PART
    local loader_list = {
        { tex_list, OLD_LoadTexture },
        { tex_mip_list, TexLoaderMip },
        -- 'GetTextureSize',
        'LoadImageFromFile',
        '_LoadImageFromFile',
        'LoadAniFromFile',
        'LoadImageGroupFromFile',
        '_LoadImageGroupFromFile',
        'LoadLaserTexture',
        'SetTextureSamplerState',
        { fnt_list, OLD_LoadFont },
        { fnt_mip_list, FntLoaderMip },

        { snd_list, OLD_LoadSound },
        { fx__list, OLD_LoadFX },
        { mdl_list, OLD_LoadModel },

        { bgm_list, BgmLoader },
        { ttf_list, TtfLoader },
        { img_list, ImgLoader },
        'SetImageState',
        'SetImageCenter',
        'SetImageScale',
        'LoadAnimation',
        'SetAnimationState',
        'SetAnimationScale',
    }
    SetResourceStatus("global")

    task.New(self, function()
        for _, v in ipairs(loader_list) do
            if type(v) == 'string' then
                task.New(self, Task_CallBuffer(v))
            elseif type(v) == 'table' then
                task.New(self, Task_LoadRes(unpack(v)))
            else
                error('invalid loader list entry')
            end
            task.Wait(2)
            while not buf_done do
                task.Wait()
            end
        end

        for _, v in ipairs(hijacked) do
            _G[v] = _G['OLD_' .. v]
        end

        -- task.Wait(10)

        SceneManager.setNext("GameScene")
    end)
    -- place your code below this --
    lstg.LoadTTF("loading", "assets/font/SourceHanSansCN-Bold.otf", 0, 36)
end

function LoadScene:onDestroy()
    SetResourceStatus("stage")
    ResetUI()
end

function LoadScene:onUpdate()
    task.Do(self) -- NOT OPTIONAL
    timer = timer + 1
end

function LoadScene:onRender()
    BeforeRender() -- NOT OPTIONAL

    -- colors so you know it works
    SetViewMode('ui')
    lstg.RenderClear(Color(255, sin(timer * 2) * 80, sin(timer) * 80, sin(timer / 2) * 80))
    lstg.RenderTTF('loading', current_res, 0, 0, 0, 0, 8, Color(0xFFFFFFFF), 1)

    AfterRender() -- NOT OPTIONAL
end

function LoadScene:onActivated()
end

function LoadScene:onDeactivated()
end

SceneManager.setNext("LoadScene")

