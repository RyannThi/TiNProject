﻿-- Generated by LuaSTG Editor Sharp X 0.74.3
-- Mod name: 
_author = "Monodenounment Studios"
_mod_version = 4096
_allow_practice = true
_allow_sc_practice = true
function math.lerp(a,b,x)
	return a + (b - a) * x
end
SetSplash(true)
-- MenuInputChecker
    function MenuInputChecker(name)
        while(true) do
            while(not KeyIsPressed(name))do
                coroutine.yield(false) --return false until the key is pressed
            end
            coroutine.yield(true) --return true once
            for i=0, 20 do
                coroutine.yield(false) --return false for 30 frames
                if (not KeyIsDown(name)) then
                    break --if the key is not being held down, break out of for (which will make you consequently restart
                end
            end
            while (KeyIsDown(name)) do
                coroutine.yield(true) -- return true once every 3 frames
                for i=0, 2 do
                    coroutine.yield(false) --return false for 3 frames
                end
            end
        end
    end

-- SetWorldUEX
    function SetWorldUEX(x, y, w, h, bound, m)
    	bound = bound or 32
    	m = m or 15
    	OriginalSetWorld(
    	--l,r,b,t,
    			(-w / 2), (w / 2), (-h / 2), (h / 2),
    	--bl,br,bb,bt
    			(-w / 2) - bound, (w / 2) + bound, (-h / 2) - bound, (h / 2) + bound,
    	--sl,sr,sb,st
    			(x - w/2), (x + w/2), (y - h/2), (y + h/2),
    	--pl,pr,pb,pt
    			(-w / 2), (w / 2), (-h / 2), (h / 2),
    	--world mask
    			m
    	)
    	SetBound(lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt)
    end

-- Wrap
    function Wrap(x, x_min, x_max)
    	return (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min;
    end

-- Clamp
    function Clamp(val, lower, upper)
        assert(val and lower and upper, "not very useful error message here")
        if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
        return math.max(lower, math.min(upper, val))
    end

-- Interpolation
    function LerpDecel(a, b, x)
        local y = 1 - x
        return (a + (1 - y * y) * (b - a))
    end
    
    function Lerp(a, b, t)
        return a + (b - a) * t
    end

-- Format Score
    function FormatScore(num)
        local str = string.format('%012d', num)
        return string.format('%s,%s,%s,%s',
                str:sub(1,3), str:sub(4,6),str:sub(7,9),str:sub(10,12))
    end

Include'Vector.lua'
-- archive space: TITLE\
_LoadImageFromFile('image:'..'MainMenuBackground','TITLE\\MainMenuBackground.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuLogo','TITLE\\MainMenuLogo.png',true,0,0,false,0)
_LoadImageGroupFromFile('image:'..'MainMenuSelections_','TITLE\\MainMenuSelections_.png',true,1,8,0,0,false)
_LoadImageFromFile('image:'..'MainMenuSelectionsShadow','TITLE\\MainMenuSelectionsShadow.png',true,0,0,false,0)
do
    SetImageState("image:MainMenuSelectionsShadow","",Color(155,255,255,255))
end
_LoadImageFromFile('image:'..'MainMenuHarae','TITLE\\MainMenuHarae.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuScroller','TITLE\\MainMenuScroller.png',true,0,0,false,0)
do
    SetImageState("image:MainMenuScroller","mul+rev",Color(75,255,255,255))
end
_LoadImageFromFile('image:'..'MainMenuSpinner','TITLE\\MainMenuSpinner.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuGradient','TITLE\\MainMenuGradient.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuCopyright','TITLE\\MainMenuCopyright.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuRGB','TITLE\\MainMenuRGB.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuDifficultyHeader','TITLE\\MainMenuDifficultyHeader.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuDifficultyShadow','TITLE\\MainMenuDifficultyShadow.png',true,0,0,false,0)
_LoadImageFromFile('image:'..'MainMenuDifficultyHalo','TITLE\\MainMenuDifficultyHalo.png',true,0,0,false,0)
_LoadImageGroupFromFile('image:'..'MainMenuDifficultyLabels','TITLE\\MainMenuDifficultyLabels.png',true,1,4,0,0,false)
-- archive space: 
_editor_class["MainMenuBG"]=Class(_object)
_editor_class["MainMenuBG"].init=function(self,_x,_y,_)
    self.x,self.y=_x,_y
    self.img="image:MainMenuBackground"
    self.layer=LAYER_BG-5
    self.group=GROUP_GHOST
    self.hide=false
    self.bound=false
    self.navi=false
    self.hp=10
    self.maxhp=10
    self.colli=false
    self._servants={}
    self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
    self.hscale, self.vscale = 1/2.25, 1/2.25
    self.x,self.y=screen.width/2, screen.height/2
end
_editor_class["MainMenuBG"].render=function(self)
    SetViewMode'ui'
    self.class.base.render(self)
    SetViewMode'world'
end
_editor_class["MainMenuMain"]=Class(_object)
_editor_class["MainMenuMain"].init=function(self,_x,_y,_)
    self.x,self.y=_x,_y
    self.img="img_void"
    self.layer=LAYER_TOP
    self.group=GROUP_GHOST
    self.hide=false
    self.bound=false
    self.navi=false
    self.hp=10
    self.maxhp=10
    self.colli=false
    self._servants={}
    self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
    MainMenuRef = self
    self.index = 1
    self.shadowPos = { x = 170, y = 350 - 33 }
    self.yOffset = 0
    self.spinWheelAdd = 0
    self.spinWheelStaticAdd = 0
    self.spinWheelStaticDelay = 0
    self.spinWheelRot = 0
    self.lastRot = 2
    self.imgx = screen.width / 2
    self.imgy = screen.height / 2
    self.fadeIn = 255
    self.yAnim = 480
    self.logoScale = 0.2
    self.shadowRGB = {0, 255, 255, 255}
    self.canvasX = 0
    self.canvasY = 0
    self.canvasIndex = 0
    
    self.selections = {
    	{ alpha = 255, scale = 1, color = {255, 158+20, 195+20, 255} },
    	{ alpha = 255, scale = 1, color = {255, 130+20, 142+20, 255} },
    	{ alpha = 255, scale = 1, color = {255, 110+10, 105+10, 255} },
    	{ alpha = 255, scale = 1, color = {255, 90+10, 71+10, 211} },
    	{ alpha = 255, scale = 1, color = {255, 66+10, 51+10, 211} },
    	{ alpha = 255, scale = 1, color = {255, 55+10, 40+10, 211} },
    	{ alpha = 255, scale = 1, color = {255, 40+5, 25+5, 185} },
    	{ alpha = 255, scale = 1, color = {255, 30+5, 15+5, 185} },
    }
    _object.set_color(self,"",255,255,255,255)
    last=New(_editor_class["MainMenuDifficulty"],self.x,self.y,_)
    last=New(_editor_class["MainMenuHaraeAnim"],self.x,self.y,_)
    lasttask=task.New(self,function()
        do
            local _beg_logoScale=0.2 local logoScale=_beg_logoScale  local _w_logoScale=0 local _end_logoScale=1 local _d_w_logoScale=90/(60*2.5-1)
            for _=1,60*2.5 do
                self.logoScale = logoScale
                task._Wait(1)
                _w_logoScale=_w_logoScale+_d_w_logoScale logoScale=(_end_logoScale-_beg_logoScale)*sin(_w_logoScale)+(_beg_logoScale)
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _beg_fade=255 local fade=_beg_fade  local _w_fade=0 local _end_fade=0 local _d_w_fade=90/(45-1)
            for _=1,45 do
                self.fadeIn = fade
                task._Wait(1)
                _w_fade=_w_fade+_d_w_fade fade=(_end_fade-_beg_fade)*sin(_w_fade)+(_beg_fade)
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _h_yOffset=(7-(-7))/2 local _t_yOffset=(7+(-7))/2 local yOffset=_h_yOffset*sin(0)+_t_yOffset local _w_yOffset=0 local _d_w_yOffset=1.75
            for _=1,_infinite do
                self.yOffset = yOffset
                task._Wait(3)
                _w_yOffset=_w_yOffset+_d_w_yOffset yOffset=_h_yOffset*sin(_w_yOffset)+_t_yOffset
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _beg_yAnim=480 local yAnim=_beg_yAnim  local _w_yAnim=-90 local _end_yAnim=0 local _d_w_yAnim=180/(60*2-1)
            for _=1,60*2 do
                self.yAnim = yAnim
                task._Wait(1)
                _w_yAnim=_w_yAnim+_d_w_yAnim yAnim=(_end_yAnim-_beg_yAnim)/2*sin(_w_yAnim)+((_end_yAnim+_beg_yAnim)/2)
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _h_colorChange=(100-(0))/2 local _t_colorChange=(100+(0))/2 local colorChange=_h_colorChange*sin(0)+_t_colorChange local _w_colorChange=0 local _d_w_colorChange=1.5
            for _=1,_infinite do
                SetImageState("image:MainMenuHarae","",Color(255,255 - colorChange,255 - colorChange,255))
                task._Wait(1)
                _w_colorChange=_w_colorChange+_d_w_colorChange colorChange=_h_colorChange*sin(_w_colorChange)+_t_colorChange
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _beg_alpha=0 local alpha=_beg_alpha  local _w_alpha=-90 local _end_alpha=255 local _d_w_alpha=180/(60*1.5-1)
            for _=1,60*1.5 do
                SetImageState("image:MainMenuGradient","",Color(alpha,255,255,255))
                SetImageState("image:MainMenuSpinner","",Color(alpha,255,255,255))
                task._Wait(1)
                _w_alpha=_w_alpha+_d_w_alpha alpha=(_end_alpha-_beg_alpha)/2*sin(_w_alpha)+((_end_alpha+_beg_alpha)/2)
            end
        end
    end)
end
_editor_class["MainMenuMain"].frame=function(self)
    for _=1,8 do
        if self.index == _ then
            self.selections[_].alpha = LerpDecel(self.selections[_].alpha, 255, 0.1)
            self.selections[_].scale = LerpDecel(self.selections[_].scale, 1.1, 0.1)
        else
            self.selections[_].alpha = LerpDecel(self.selections[_].alpha, 100, 0.1)
            self.selections[_].scale = LerpDecel(self.selections[_].scale, 1.4, 0.1)
        end
    end
    if self.canvasIndex == 0 then
    	if is_up_held and self.timer >= 60 * 2.5 then
    		self.index = Wrap(self.index - 1, 1, 9)
    		PlaySound("select00",0.1,0,false)
    		self.spinWheelAdd = 10
    		self.spinWheelStaticDelay = 60
    		self.lastRot = 1
    	end
    	
    	if is_down_held and self.timer >= 60 * 2.5 then
    		self.index = Wrap(self.index + 1, 1, 9)
    		PlaySound("select00",0.1,0,false)
    		self.spinWheelAdd = -10
    		self.spinWheelStaticDelay = 60
    		self.lastRot = 2
    	end
    	
    	if KeyIsPressed"shoot" and self.timer >= 60*2.5 and self.canvasIndex == 0 then
    		PlaySound("ok00",0.1,self.x/256,false)
    		New(_editor_class["MainMenuSelectionsPopup"],
    		185 + self.canvasX,
    		350 - (33 * self.index) + self.yOffset + self.yAnim + self.canvasY,
    		"image:MainMenuSelections_" .. self.index,
    		self.selections[self.index].scale - 0.7)
    		
    		self.canvasIndex = self.index
    		if self.index == 8 then
    			stage.QuitGame()
    		end
    	end
    end
    
    self.spinWheelAdd = LerpDecel(self.spinWheelAdd, 0, 0.1)
    self.shadowPos.y = LerpDecel(self.shadowPos.y, 350 - (33 * self.index), 0.1)
    self.spinWheelRot = self.spinWheelRot + self.spinWheelAdd + self.spinWheelStaticAdd
    
    if self.canvasIndex == 0 then
    	for i = 1, 4 do
    		self.shadowRGB[i] = LerpDecel(self.shadowRGB[i], self.selections[self.index].color[i], 0.05)
    	end
    else
    	self.shadowRGB[1] = LerpDecel(self.shadowRGB[1], 0, 0.05)
    	for i = 2, 4 do
    		self.shadowRGB[i] = LerpDecel(self.shadowRGB[i], self.selections[self.index].color[i], 0.05)
    	end
    end
    
    self.spinWheelStaticDelay = self.spinWheelStaticDelay - 1
    if self.spinWheelStaticDelay <= 0 then
    	if self.lastRot == 1 then
    		self.spinWheelStaticAdd = LerpDecel(self.spinWheelStaticAdd, 2, 0.005)
    	else
    		self.spinWheelStaticAdd = LerpDecel(self.spinWheelStaticAdd, -2, 0.005)
    	end
    end
    if self.spinWheelStaticDelay > 0 then
    	self.spinWheelStaticAdd = 0
    end
    
    if self.canvasIndex == 0 then
    	self.canvasX = LerpDecel(self.canvasX, 0, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 0, 0.05)
    elseif self.canvasIndex == 1 then
    	self.canvasX = LerpDecel(self.canvasX, -854, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 0, 0.05)
    elseif self.canvasIndex == 2 then
    	self.canvasX = LerpDecel(self.canvasX, -854, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 480, 0.05)
    elseif self.canvasIndex == 3 then
    	self.canvasX = LerpDecel(self.canvasX, -854, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, -480, 0.05)
    elseif self.canvasIndex == 4 then
    	self.canvasX = LerpDecel(self.canvasX, 854, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 0, 0.05)
    elseif self.canvasIndex == 5 then
    	self.canvasX = LerpDecel(self.canvasX, 0, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, -480, 0.05)
    elseif self.canvasIndex == 6 then
    	self.canvasX = LerpDecel(self.canvasX, 0, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 480, 0.05)
    else
    	self.canvasX = LerpDecel(self.canvasX, 0, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 0, 0.05)
    end
    
    self.imgx = self.imgx + 0.2
    self.imgy = self.imgy + 0.2
    self.class.base.frame(self)
end
_editor_class["MainMenuMain"].render=function(self)
    SetViewMode'ui'
    self.class.base.render(self)
    Render("image:MainMenuGradient",screen.width / 2, screen.height / 2,0,1/2.25, 1/2.25,0.5)
    Render("image:MainMenuSpinner",screen.width/2, screen.height/2,self.timer * 0.05,1/2.25, 1/2.25,0.5)
    local w, h = GetTextureSize("image:MainMenuScroller")
    w, h = w * 0.4, h * 0.4
    for i = -int((screen.width + 16 + self.imgx) / w + 0.5), int((screen.width + 16 - self.imgx) / w + 0.5) do
    	for j = -int((screen.height + 16 + self.imgy) / h + 0.5), int((screen.height + 16 - self.imgy) / h + 0.5) do
    		Render("image:MainMenuScroller", self.imgx + i * w, self.imgy + j * h, 0, 0.4, 0.4)
    	end
    end
    SetImageState("image:MainMenuRGB","mul+add",Color(self.shadowRGB[1],self.shadowRGB[2],self.shadowRGB[3],self.shadowRGB[4]))
    Render("image:MainMenuRGB",screen.width / 2, screen.height / 2,0,1/2.25, 1/2.25,0.5)
    if self.timer >= 60*2.5 + 3 then
        Render("image:MainMenuSelectionsShadow",self.shadowPos.x + self.canvasX, self.shadowPos.y + self.yOffset + self.yAnim + self.canvasY,0,1/2.25 - 0.1, 1/2.25 - 0.1,0.5)
        Render("image:MainMenuHarae",self.shadowPos.x - 120 + self.canvasX, self.shadowPos.y + self.yOffset + self.yAnim + self.canvasY,self.spinWheelRot,1/2.25 - 0.275, 1/2.25 - 0.275,0.5)
    end
    for _=1,8 do
        SetImageState("image:MainMenuSelections_" .. _,"",Color(self.selections[_].alpha,255,255,255))
        Render("image:MainMenuSelections_" .. _,185 + self.canvasX, 350 - (33 * _) + self.yOffset + self.yAnim + self.canvasY,0,1/2.25 - 0.1 * self.selections[_].scale, 1/2.25 - 0.1 * self.selections[_].scale,0.5)
    end
    Render("image:MainMenuLogo",600 + self.canvasX, 390 - self.yAnim + self.yOffset + self.canvasY,0,(1/2.25 - 0.2) * self.logoScale, (1/2.25 - 0.2) * self.logoScale,0.5)
    Render("image:MainMenuCopyright",screen.width / 2 + self.canvasX, 30 - self.yAnim + self.yOffset + self.canvasY,0,1/2.25 - 0.25, 1/2.25 - 0.25,0.5)
    SetImageState("white","",Color(self.fadeIn,0,0,0))
    Render("white",screen.width / 2, screen.height / 2,0,854,480,0.5)
    SetImageState("white","",Color(255,255,255,255))
    SetViewMode'ui'
end
_editor_class["MainMenuHaraeAnim"]=Class(_object)
_editor_class["MainMenuHaraeAnim"].init=function(self,_x,_y,_)
    self.x,self.y=_x,_y
    self.img="image:MainMenuHarae"
    self.layer=LAYER_TOP+56
    self.group=GROUP_GHOST
    self.hide=false
    self.bound=false
    self.navi=false
    self.hp=10
    self.maxhp=10
    self.colli=false
    self._servants={}
    self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
    self.x, self.y = 854 + 100, 480 + 100
    _object.set_color(self,"",0,255,255,255)
    self.hscale, self.vscale = 0,0
    lasttask=task.New(self,function()
        task.CRMoveTo(60*2.5,MOVE_ACC_DEC,740, 480-60, 280, 480, 0, 480-40, 170-121, 350-28)
        PlaySound("hyz_chargeup",0.1,self.x/256,false)
        do
            local _beg_alpha=255 local alpha=_beg_alpha  local _w_alpha=-90 local _end_alpha=0 local _d_w_alpha=90/(15-1)
            for _=1,15 do
                _object.set_color(self,"",alpha,255,255,255)
                task._Wait(1)
                _w_alpha=_w_alpha+_d_w_alpha alpha=(_end_alpha-_beg_alpha)*sin(_w_alpha)+(_end_alpha)
            end
        end
        _del(self,true)
    end)
    lasttask=task.New(self,function()
        do
            local _beg_alpha=0 local alpha=_beg_alpha  local _w_alpha=0 local _end_alpha=255 local _d_w_alpha=90/(60*2.5-1)
            for _=1,60*2.5 do
                _object.set_color(self,"",alpha,255,255,255)
                task._Wait(1)
                _w_alpha=_w_alpha+_d_w_alpha alpha=(_end_alpha-_beg_alpha)*sin(_w_alpha)+(_beg_alpha)
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _beg_scale=0 local scale=_beg_scale  local _w_scale=-90 local _end_scale=0.6 local _d_w_scale=90/(60-1)
            for _=1,60 do
                self.hscale, self.vscale = scale, scale
                task._Wait(1)
                _w_scale=_w_scale+_d_w_scale scale=(_end_scale-_beg_scale)*sin(_w_scale)+(_end_scale)
            end
        end
        do
            local _beg_scale=0.6 local scale=_beg_scale  local _w_scale=0 local _end_scale=1/2.25 - 0.275 local _d_w_scale=90/(60*1.5-1)
            for _=1,60*1.5 do
                self.hscale, self.vscale = scale, scale
                task._Wait(1)
                _w_scale=_w_scale+_d_w_scale scale=(_end_scale-_beg_scale)*sin(_w_scale)+(_beg_scale)
            end
        end
        do
            local _beg_scale=1/2.25 - 0.275 local scale=_beg_scale  local _w_scale=-90 local _end_scale=1/2.25 local _d_w_scale=90/(25-1)
            for _=1,25 do
                self.hscale, self.vscale = scale, scale
                task._Wait(1)
                _w_scale=_w_scale+_d_w_scale scale=(_end_scale-_beg_scale)*sin(_w_scale)+(_end_scale)
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _beg_rot=0 local rot=_beg_rot  local _w_rot=-90 local _end_rot=15 local _d_w_rot=90/(60*1-1)
            for _=1,60*1 do
                self.rot = self.rot + rot
                task._Wait(1)
                _w_rot=_w_rot+_d_w_rot rot=(_end_rot-_beg_rot)*sin(_w_rot)+(_end_rot)
            end
        end
        do
            local _beg_rot=15 local rot=_beg_rot  local _w_rot=-90 local _end_rot=0 local _d_w_rot=90/(60*1.5-1)
            for _=1,60*1.5 do
                self.rot = self.rot + rot
                task._Wait(1)
                _w_rot=_w_rot+_d_w_rot rot=(_end_rot-_beg_rot)*sin(_w_rot)+(_end_rot)
            end
        end
    end)
end
_editor_class["MainMenuHaraeAnim"].render=function(self)
    SetViewMode'ui'
    self.class.base.render(self)
    SetViewMode'world'
end
_editor_class["MainMenuDifficulty"]=Class(_object)
_editor_class["MainMenuDifficulty"].init=function(self,_x,_y,_)
    self.x,self.y=_x,_y
    self.img="img_void"
    self.layer=LAYER_TOP
    self.group=GROUP_GHOST
    self.hide=false
    self.bound=false
    self.navi=false
    self.hp=10
    self.maxhp=10
    self.colli=false
    self._servants={}
    self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
    self.canvasX = 854
    self.canvasY = 0
    self.shadowRot = 0
    self.shadowCol = {255, 255, 255, 255}
    self.shadowColTarget = {
    	{ 190, 21, 61, 36 },
    	{ 190, 21, 35, 61 },
    	{ 190, 61, 24, 21 },
    	{ 190, 55, 21, 61 }
    }
    self.index = 1
    self.shadowRotAdd = 0
    self.labels = {
    	{x = 0, y = 0, scale = 1, alpha = 255},
    	{x = 0, y = 0, scale = 1, alpha = 255},
    	{x = 0, y = 0, scale = 1, alpha = 255},
    	{x = 0, y = 0, scale = 1, alpha = 255},
    }
    lasttask=task.New(self,function()
        do
            local _h_angleAdd=(5-(-5))/2 local _t_angleAdd=(5+(-5))/2 local angleAdd=_h_angleAdd*sin(0)+_t_angleAdd local _w_angleAdd=0 local _d_w_angleAdd=1.5
            for _=1,_infinite do
                self.shadowRotAdd = angleAdd
                task._Wait(1)
                _w_angleAdd=_w_angleAdd+_d_w_angleAdd angleAdd=_h_angleAdd*sin(_w_angleAdd)+_t_angleAdd
            end
        end
    end)
end
_editor_class["MainMenuDifficulty"].frame=function(self)
    if MainMenuRef.canvasIndex == 1 then
    	self.canvasX = LerpDecel(self.canvasX, 0, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 0, 0.05)
    else
    	self.canvasX = LerpDecel(self.canvasX, 854, 0.05)
    	self.canvasY = LerpDecel(self.canvasY, 0, 0.05)
    end
    
    if MainMenuRef.canvasIndex == 1 then
    	if KeyIsPressed"spell" then
    		PlaySound("cancel00",0.1,self.x/256,false)
    		MainMenuRef.canvasIndex = 0
    	end
    	
    	if is_up_held then
    		self.index = Wrap(self.index - 1, 1, 5)
    		PlaySound("select00",0.1,0,false)
    	end
    	
    	if is_down_held then
    		self.index = Wrap(self.index + 1, 1, 5)
    		PlaySound("select00",0.1,0,false)
    	end
    end
    
    if self.index == 1 then
    	self.shadowRot = LerpDecel(self.shadowRot, -5, 0.1)
    	for i = 1, 4 do
    		self.shadowCol[i] = LerpDecel(self.shadowCol[i], self.shadowColTarget[self.index][i], 0.1)
    	end
    elseif self.index == 2 then
    	self.shadowRot = LerpDecel(self.shadowRot, -10, 0.1)
    	for i = 1, 4 do
    		self.shadowCol[i] = LerpDecel(self.shadowCol[i], self.shadowColTarget[self.index][i], 0.1)
    	end
    elseif self.index == 3 then
    	self.shadowRot = LerpDecel(self.shadowRot, -15, 0.1)
    	for i = 1, 4 do
    		self.shadowCol[i] = LerpDecel(self.shadowCol[i], self.shadowColTarget[self.index][i], 0.1)
    	end
    elseif self.index == 4 then
    	self.shadowRot = LerpDecel(self.shadowRot, -20, 0.1)
    	for i = 1, 4 do
    		self.shadowCol[i] = LerpDecel(self.shadowCol[i], self.shadowColTarget[self.index][i], 0.1)
    	end
    end
    
    if self.index == 1 then
    	self.labels[1].x = LerpDecel(self.labels[1].x, screen.width/2, 0.1)
    	self.labels[1].y = LerpDecel(self.labels[1].y, screen.height/2 - 20, 0.1)
    	self.labels[1].scale = LerpDecel(self.labels[1].scale, 0.8, 0.1)
    	self.labels[1].alpha = LerpDecel(self.labels[1].alpha, 255, 0.1)
    	--
    	self.labels[2].x = LerpDecel(self.labels[2].x, screen.width/2 + 150, 0.1)
    	self.labels[2].y = LerpDecel(self.labels[2].y, screen.height/2 - 20 - 150, 0.1)
    	self.labels[2].scale = LerpDecel(self.labels[2].scale, 0.4, 0.1)
    	self.labels[2].alpha = LerpDecel(self.labels[2].alpha, 155, 0.1)
    	
    	self.labels[3].x = LerpDecel(self.labels[3].x, screen.width/2 + 150*2, 0.1)
    	self.labels[3].y = LerpDecel(self.labels[3].y, screen.height/2 - 20 - 150*2, 0.1)
    	self.labels[3].scale = LerpDecel(self.labels[3].scale, 0.4, 0.1)
    	self.labels[3].alpha = LerpDecel(self.labels[3].alpha, 155, 0.1)
    	
    	self.labels[4].x = LerpDecel(self.labels[4].x, screen.width/2 + 150*3, 0.1)
    	self.labels[4].y = LerpDecel(self.labels[4].y, screen.height/2 - 20 - 150*3, 0.1)
    	self.labels[4].scale = LerpDecel(self.labels[4].scale, 0.4, 0.1)
    	self.labels[4].alpha = LerpDecel(self.labels[4].alpha, 155, 0.1)
    	
    elseif self.index == 2 then
    	self.labels[1].x = LerpDecel(self.labels[1].x, screen.width/2 - 150, 0.1)
    	self.labels[1].y = LerpDecel(self.labels[1].y, screen.height/2 - 20 + 150, 0.1)
    	self.labels[1].scale = LerpDecel(self.labels[1].scale, 0.4, 0.1)
    	self.labels[1].alpha = LerpDecel(self.labels[1].alpha, 155, 0.1)
    	--
    	self.labels[2].x = LerpDecel(self.labels[2].x, screen.width/2, 0.1)
    	self.labels[2].y = LerpDecel(self.labels[2].y, screen.height/2 - 20, 0.1)
    	self.labels[2].scale = LerpDecel(self.labels[2].scale, 0.8, 0.1)
    	self.labels[2].alpha = LerpDecel(self.labels[2].alpha, 255, 0.1)
    	--
    	self.labels[3].x = LerpDecel(self.labels[3].x, screen.width/2 + 150, 0.1)
    	self.labels[3].y = LerpDecel(self.labels[3].y, screen.height/2 - 20 - 150, 0.1)
    	self.labels[3].scale = LerpDecel(self.labels[3].scale, 0.4, 0.1)
    	self.labels[3].alpha = LerpDecel(self.labels[3].alpha, 155, 0.1)
    	
    	self.labels[4].x = LerpDecel(self.labels[4].x, screen.width/2 + 150*2, 0.1)
    	self.labels[4].y = LerpDecel(self.labels[4].y, screen.height/2 - 20 - 150*2, 0.1)
    	self.labels[4].scale = LerpDecel(self.labels[4].scale, 0.4, 0.1)
    	self.labels[4].alpha = LerpDecel(self.labels[4].alpha, 155, 0.1)
    elseif self.index == 3 then
    	self.labels[1].x = LerpDecel(self.labels[1].x, screen.width/2 - 150*2, 0.1)
    	self.labels[1].y = LerpDecel(self.labels[1].y, screen.height/2 - 20 + 150*2, 0.1)
    	self.labels[1].scale = LerpDecel(self.labels[1].scale, 0.4, 0.1)
    	self.labels[1].alpha = LerpDecel(self.labels[1].alpha, 155, 0.1)
    	
    	self.labels[2].x = LerpDecel(self.labels[2].x, screen.width/2 - 150, 0.1)
    	self.labels[2].y = LerpDecel(self.labels[2].y, screen.height/2 - 20 + 150, 0.1)
    	self.labels[2].scale = LerpDecel(self.labels[2].scale, 0.4, 0.1)
    	self.labels[2].alpha = LerpDecel(self.labels[2].alpha, 155, 0.1)
    	--
    	self.labels[3].x = LerpDecel(self.labels[3].x, screen.width/2, 0.1)
    	self.labels[3].y = LerpDecel(self.labels[3].y, screen.height/2 - 20, 0.1)
    	self.labels[3].scale = LerpDecel(self.labels[3].scale, 0.8, 0.1)
    	self.labels[3].alpha = LerpDecel(self.labels[3].alpha, 255, 0.1)
    	--
    	self.labels[4].x = LerpDecel(self.labels[4].x, screen.width/2 + 150, 0.1)
    	self.labels[4].y = LerpDecel(self.labels[4].y, screen.height/2 - 20 - 150, 0.1)
    	self.labels[4].scale = LerpDecel(self.labels[4].scale, 0.4, 0.1)
    	self.labels[4].alpha = LerpDecel(self.labels[4].alpha, 155, 0.1)
    else
    	self.labels[1].x = LerpDecel(self.labels[1].x, screen.width/2 - 150*3, 0.1)
    	self.labels[1].y = LerpDecel(self.labels[1].y, screen.height/2 - 20 + 150*3, 0.1)
    	self.labels[1].scale = LerpDecel(self.labels[1].scale, 0.4, 0.1)
    	self.labels[1].alpha = LerpDecel(self.labels[1].alpha, 155, 0.1)
    	
    	self.labels[2].x = LerpDecel(self.labels[2].x, screen.width/2 - 150*2, 0.1)
    	self.labels[2].y = LerpDecel(self.labels[2].y, screen.height/2 - 20 + 150*2, 0.1)
    	self.labels[2].scale = LerpDecel(self.labels[2].scale, 0.4, 0.1)
    	self.labels[2].alpha = LerpDecel(self.labels[2].alpha, 155, 0.1)
    	
    	self.labels[3].x = LerpDecel(self.labels[3].x, screen.width/2 - 150, 0.1)
    	self.labels[3].y = LerpDecel(self.labels[3].y, screen.height/2 - 20 + 150, 0.1)
    	self.labels[3].scale = LerpDecel(self.labels[3].scale, 0.4, 0.1)
    	self.labels[3].alpha = LerpDecel(self.labels[3].alpha, 155, 0.1)
    	--
    	self.labels[4].x = LerpDecel(self.labels[4].x, screen.width/2, 0.1)
    	self.labels[4].y = LerpDecel(self.labels[4].y, screen.height/2 - 20, 0.1)
    	self.labels[4].scale = LerpDecel(self.labels[4].scale, 0.8, 0.1)
    	self.labels[4].alpha = LerpDecel(self.labels[4].alpha, 255, 0.1)
    end
    self.class.base.frame(self)
end
_editor_class["MainMenuDifficulty"].render=function(self)
    SetViewMode'ui'
    self.class.base.render(self)
    SetImageState("image:MainMenuDifficultyHalo","",Color(self.shadowCol[1],self.shadowCol[2],self.shadowCol[3],self.shadowCol[4]))
    Render("image:MainMenuDifficultyHalo",screen.width/2 + self.canvasX, screen.height/2 + self.canvasY,0,1/2.25,1/2.25,0.5)
    Render("image:MainMenuDifficultyHeader",screen.width / 2 + self.canvasX, 400 + MainMenuRef.yOffset + self.canvasY,0,1/2.25 - 0.2,1/2.25 - 0.2,0.5)
    SetImageState("image:MainMenuDifficultyShadow","",Color(self.shadowCol[1],self.shadowCol[2],self.shadowCol[3],self.shadowCol[4]))
    Render("image:MainMenuDifficultyShadow",screen.width/2 + self.canvasX, screen.height/2 - 20 + self.canvasY + MainMenuRef.yOffset,self.shadowRot + self.shadowRotAdd,1/2.25 - 0.2, 1/2.25 - 0.2,0.5)
    for _=1,4 do
        SetImageState("image:MainMenuDifficultyLabels" .. _,"",Color(self.labels[_].alpha,255,255,255))
        Render("image:MainMenuDifficultyLabels" .. _,self.labels[_].x + self.canvasX, self.labels[_].y + self.canvasY + MainMenuRef.yOffset,0,1/2.25 * self.labels[_].scale, 1/2.25 * self.labels[_].scale,0.5)
    end
    SetViewMode'world'
end
_editor_class["MainMenuSelectionsPopup"]=Class(_object)
_editor_class["MainMenuSelectionsPopup"].init=function(self,_x,_y,img, scale)
    self.x,self.y=_x,_y
    self.img=img
    self.layer=LAYER_TOP+5
    self.group=GROUP_GHOST
    self.hide=false
    self.bound=false
    self.navi=false
    self.hp=10
    self.maxhp=10
    self.colli=false
    self._servants={}
    self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
    self.hscale, self.vscale = 0,0
    _object.set_color(self,"",0,255,255,255)
    lasttask=task.New(self,function()
        do
            local _beg_size=scale local size=_beg_size  local _w_size=0 local _end_size=scale + 0.2 local _d_w_size=90/(15-1)
            for _=1,15 do
                self.hscale, self.vscale = size, size
                task._Wait(1)
                _w_size=_w_size+_d_w_size size=(_end_size-_beg_size)*sin(_w_size)+(_beg_size)
            end
        end
    end)
    lasttask=task.New(self,function()
        do
            local _beg_alpha=255 local alpha=_beg_alpha  local _w_alpha=0 local _end_alpha=0 local _d_w_alpha=90/(15-1)
            for _=1,15 do
                _object.set_color(self,"",alpha,255,255,255)
                task._Wait(1)
                _w_alpha=_w_alpha+_d_w_alpha alpha=(_end_alpha-_beg_alpha)*sin(_w_alpha)+(_beg_alpha)
            end
        end
        _del(self,true)
    end)
end
_editor_class["MainMenuSelectionsPopup"].render=function(self)
    SetViewMode'ui'
    self.class.base.render(self)
    SetViewMode'world'
end
-- Loading Screen
    stage_load = stage.New("load", true, true)
    function stage_load:init()
    end
    function stage_load:frame()
        task.Do(self)
    end

-- Title Screen
    stage_init = stage.New("menu", true, true)
    function stage_init:init()
        checker_up = coroutine.create(MenuInputChecker)
        checker_down = coroutine.create(MenuInputChecker)
        checker_left = coroutine.create(MenuInputChecker)
        checker_right = coroutine.create(MenuInputChecker)
        checker_c = coroutine.create(MenuInputChecker)
        lstg.var.rep_player = "Reimu"
        lstg.var.player_name = "Reimu"
        last=New(_editor_class["MainMenuBG"],0,0,_)
        last=New(_editor_class["MainMenuMain"],0,0,_)
    end
    function stage_init:frame()
        _, is_up_held = coroutine.resume(checker_up, "up")
        _, is_down_held = coroutine.resume(checker_down, "down")
        _, is_left_held = coroutine.resume(checker_left, "left")
        _, is_right_held = coroutine.resume(checker_right, "right")
        _, is_c_held = coroutine.resume(checker_c, "special")
        if is_debug then
        	if GetKeyState(KEY.U) then scoredata.tutoriallock = false end
        	if GetKeyState(KEY.L) then scoredata.tutoriallock = true end
        end
        task.Do(self)
    end

stage.group.New('menu',{},"GameGroup",{lifeleft=7,power=400,faith=50000,bomb=3},true,1)
stage.group.AddStage('GameGroup','SpellCard@GameGroup',{lifeleft=7,power=400,faith=50000,bomb=3},true)
stage.group.DefStageFunc('SpellCard@GameGroup','init',function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    New(mask_fader,'open')
    if jstg then jstg.CreatePlayers() else New(_G[lstg.var.player_name]) end
    lasttask=task.New(self,function()
        LoadMusic('spellcard','THlib\\music\\spellcard.ogg',75,0xc36e80/44100/4)
        New(_editor_class["temple_background"] or temple_background)
        task._Wait(60)
        LoadMusicRecord("spellcard")
        _play_music("spellcard")
        local _boss_wait=true
        local _ref=New(_editor_class["Boss"],_editor_class["Boss"].cards)
        last=_ref
        if _boss_wait then while IsValid(_ref) do task.Wait() end end
        task._Wait(180)
    end)
    task.New(self,function()
        while coroutine.status(self.task[1])~='dead' do task.Wait() end
        stage.group.FinishReplay()
        New(mask_fader,'close')
        task.New(self,function()
            local _,bgm=EnumRes('bgm')
            for i=1,30 do
                for _,v in pairs(bgm) do
                    if GetMusicState(v)=='playing' then
                        SetBGMVolume(v,1-i/30)
                    end
                end
                task.Wait()
            end
        end)
        task.Wait(30)
        stage.group.FinishStage()
    end)
end)
