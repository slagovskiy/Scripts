--[[ Midday Commander Ver. 1.0
     Created by Dimus
     No rights reserved ]]
local wScr, hScr = term.getSize()
local wPan = math.ceil(wScr / 2)
 
local Menu='F4 Edt F5 Cpy F6 Mov F7 Dir F8 Del F10 Ext'
 
local panel ={}
local Active
 
local cmdstr=''
local curpos=0
function ShowCmd()
  term.setCursorPos(1, hScr-1)
  term.clearLine()
  term.write(shell.dir()..'> '..cmdstr)
  term.setCursorPos(term.getCursorPos()-curpos, hScr-1)
end
 
function panel:ShowFirst()
  local p=self.Path..'/'
  if #p> wPan-6 then p='..'..p:sub(#p-wPan+7) end
  if self==Active then p='['..p..']'
  else p=' '..p..' ' end
  term.setCursorPos(self.X, 1)
  term.write('+'..string.rep('-',wPan-2)..'+')
  term.setCursorPos(self.X+(wPan-#p)/2,1)
  term.write(p)
end
 
function panel:ShowLine(Line)
  term.setCursorPos(self.X, Line-self.Shift+2)
  if self.tFiles[Line]~=nil then
    local Name=self.tFiles[Line]
    if self.tSize[Line]=='DIR' then Name='/'..Name end
    if #Name>wPan-4 then Name=Name:sub(1,wPan-6)..'..' end
    Name=Name..string.rep(' ',wPan-#Name-4)
    if self==Active and Line==self.CurLine then
      term.write('|['..Name..']|')
    else
      term.write('| '..Name..' |')
    end
  else
    term.write('|'..string.rep(' ',wPan-2)..'|')
  end
end
 
function panel:ShowLines()
  for i=self.Shift, self.Shift+hScr-5 do
    self:ShowLine(i)
  end
end
 
function panel:ShowLast()
  term.setCursorPos(self.X, hScr-2)
  term.write('+'..string.rep('-',wPan-2)..'+')
  term.setCursorPos(self.X+2, hScr-2)
  write(self.tSize[self.CurLine])
  if self.tSize[self.CurLine]~='DIR' then write(' b') end
end
 
function panel:Show()
  self:ShowFirst()
  self:ShowLines()
  self:ShowLast()
end
 
function panel:GetFiles()
  local Files=fs.list(self.Path)
  table.sort(Files)
  if self.Path=='' then
    self.tFiles={}
    self.tSize={}
  else
    self.tFiles={'..'}
    self.tSize={'DIR'}
  end
  for n,Item in pairs(Files) do
    local sPath=fs.combine(self.Path,Item)
    if fs.isDir(sPath) then
      table.insert(self.tFiles,Item)
      table.insert(self.tSize,'DIR')
    end
  end
  for n,Item in pairs(Files) do
    local sPath=fs.combine(self.Path,Item)
    if not fs.isDir(sPath) then
      table.insert(self.tFiles,Item)
      table.insert(self.tSize,fs.getSize(sPath))
    end
  end
  self:Show()
end
 
function panel:new(x,path)
  local obj={X = x, Path =path, tFiles={}, tSize={}, CurLine=1, Shift=1}
  setmetatable(obj,self)
  self.__index=self
  return obj
end
 
local Left =panel:new(1,'')
local Rght =panel:new(wPan,shell.dir())
 
Active =Rght
 
local function ShowPanels()
  term.clear()
  Left:GetFiles()
  Rght:GetFiles()
  term.setCursorPos(1, hScr)
  term.write(Menu)
  term.setCursorBlink(true)
end
 
local function Dialog(Lines,Str,But)
  local H=#Lines+3
  local CurBut=1
  if Str then H=H+1 CurBut=0 end
  if not But then But={'Ok'} end
  local function Buttons()
    local Butt=''
    for i=1,#But do
      if i==CurBut then
        Butt=Butt..'['..But[i]..']'
      else
        Butt=Butt..' '..But[i]..' '
      end
    end
    return Butt
  end
  local W=#Buttons()
  for i=1,#Lines do
    if #Lines[i]>W then W=#Lines[i] end
  end
  if Str and (#Str>W) then W=#Str end
  W=W+4
  local x= math.ceil((wScr-W)/2)
  local y= math.ceil((hScr-H)/2)
  term.setCursorPos(x, y)
  term.write(string.rep('=',W))
  for i=1,#Lines+2 do
    term.setCursorPos(x, y+i)
    term.write('H'..string.rep(' ',W-2)..'H')
  end
  term.setCursorPos(x, y+H-1)
  term.write(string.rep('=',W))
  for i=1,#Lines do
    term.setCursorPos(x+(W-#Lines[i])/2, y+i)
    term.write(Lines[i])
  end
 
  while true do
    term.setCursorBlink(CurBut==0)
    term.setCursorPos(x+(W-#Buttons())/2, y+H-2)
    term.write(Buttons())
    if CurBut==0 then
      term.setCursorPos(x+2, y+H-3)
      local S=Str
      if #S>W-4 then S='..'..S:sub(#S-W+7) end
      term.write(S)
    end
    local event,p1=os.pullEvent()
    if event=='key' then
      if p1==keys.enter then
        if CurBut==0 then CurBut=1 end
        return But[CurBut],Str
      elseif p1==keys.left and CurBut~=0 then
        if CurBut>1 then CurBut=CurBut-1 end
      elseif p1==keys.right and CurBut~=0 then
        if CurBut<#But then CurBut=CurBut+1 end
      elseif p1==keys.tab then
        if CurBut<#But then CurBut=CurBut+1
        else CurBut=Str and 0 or 1
        end
      elseif p1==keys.backspace and CurBut==0 and #Str>0 then
        term.setCursorPos(x, y+H-3)
        term.write('H'..string.rep(' ',W-2)..'H')
        Str=Str:sub(1,#Str-1)
      end
    elseif event=='char' and CurBut==0 then
      Str=Str..p1
    end
  end
end
 
local cmd, Alt, Ok, Name
 
local function CopyMove(action,func)
  Name = ((Active==Rght) and Left or Rght).Path..'/'..cmd
  cmd=shell.resolve(cmd)
  Ok,Name=Dialog({action,cmd,'to:'},Name,{'<Ok>','Cansel'})
  if Ok=='<Ok>' then
    if cmd==Name then
      Dialog({'Cannot copy/move file to it self!'})
    else
      if fs.exists(Name) then
        if Dialog({'File already exists!',Name,'Overwrite it?'},nil,{'Yes','No'})=='Yes' then
          fs.delete(Name)
          func(cmd, Name)
        end
      else
        func(cmd, Name)
      end
    end
  end
  ShowPanels()
end
 
local Line
local work=true
local eventKey={}
eventKey[keys.up]=function()
  if Active.CurLine>1 then
    Line,Active.CurLine=Active.CurLine,Active.CurLine-1
    if Active.CurLine<Active.Shift then
      Active.Shift=Active.CurLine
      Active:ShowLines()
    else
      Active:ShowLine(Line)
      Active:ShowLine(Active.CurLine)
    end
    Active:ShowLast()
  end
end
 
eventKey[keys.down]=function()
  if Active.CurLine<#Active.tFiles then
    Line,Active.CurLine=Active.CurLine,Active.CurLine+1
    if Active.CurLine>Active.Shift+hScr-5 then
      Active.Shift=Active.CurLine-hScr+5
      Active:ShowLines()
    else
      Active:ShowLine(Line)
      Active:ShowLine(Active.CurLine)
    end
    Active:ShowLast()
  end
end
 
eventKey[keys.left]=function()
  if curpos<#cmdstr then curpos=curpos+1 end
end
 
eventKey[keys.right]=function()
  if curpos>0 then curpos=curpos-1 end
end
 
eventKey[keys.tab]=function()
  Active=(Active==Rght) and Left or Rght
  shell.setDir(Active.Path)
  Left:ShowFirst()
  Rght:ShowFirst()
  Left:ShowLine(Left.CurLine)
  Rght:ShowLine(Rght.CurLine)
end
 
eventKey[keys.enter]=function()
  local function exec(cmd)
    term.clear()
    term.setCursorPos(1,1)
    shell.run(cmd)
    sleep(3)
    ShowPanels()
  end
  curpos=0
  if Alt=='C' then
    cmdstr=cmdstr..cmd..' '
  else
    if cmdstr~='' then
      exec(cmdstr)
      cmdstr=''
      return
    end
    if Active.tSize[Active.CurLine]=='DIR' then
      local NewDir=shell.resolve(cmd)
      shell.setDir(NewDir)
      Active.Path=NewDir
      Active.CurLine=1
      Active.Shift=1
      Active:GetFiles()
    else
      exec(cmd)
    end
  end
end
 
eventKey[keys.backspace]=function()
  if cmdstr~='' then
    if curpos==0 then cmdstr=cmdstr:sub(1,-2)
    else cmdstr=cmdstr:sub(1,-2-curpos)..cmdstr:sub(-curpos)
    end
  end
end
 
eventKey[keys.delete]=function()
  if cmdstr~='' then
    if curpos>0 then
      curpos=curpos-1
      if curpos==0 then
        cmdstr=cmdstr:sub(1,-2)
      else
        cmdstr=cmdstr:sub(1,-2-curpos)..cmdstr:sub(-curpos)
      end
    end
  end
end
 
eventKey[keys['end']]=function() curpos=0 end
 
eventKey[keys.home]=function() curpos=#cmdstr end
 
eventKey[keys.leftShift]=function()
  Alt='S'
  os.startTimer(0.5)
end
eventKey[keys.rightShift]=eventKey[keys.leftShift]
 
eventKey[keys.leftCtrl]=function()
  Alt='C'
  os.startTimer(0.5)
end
eventKey[keys.rightCtrl]=eventKey[keys.leftCtrl]
 
eventKey[keys.f4]=function()
  if Alt=='S' then
    Alt=''
    Ok,Name=Dialog({'File name:'},'',{'<Ok>','Cansel'})
    if Ok=='<Ok>' then
      shell.run('/rom/programs/edit '..Name)
    end
  else
    if Active.tSize[Active.CurLine]=='DIR' then
      Dialog({'Error!', cmd, 'is not a file'})
    else
      shell.run('/rom/programs/edit '..cmd)
    end
  end
  ShowPanels()
end
 
eventKey[keys.f5]=function()
  CopyMove('Copy file:',fs.copy)
end
 
eventKey[keys.f6]=function()
  CopyMove('Move file:',fs.move)
end
 
eventKey[keys.f7]=function()
  Ok,Name=Dialog({'Directory name:'},'',{'<Ok>','Cansel'})
  if Ok=='<Ok>' then
    if Name=='..' or fs.exists(shell.resolve(Name)) then
      ShowPanels()
      Dialog({' File exists '})
    else
      fs.makeDir(shell.resolve(Name))
    end
  end
  ShowPanels()
end
 
eventKey[keys.f8]=function()
  if cmd=='..' then
    Dialog({'Cannot operate on ".."!'})
  else
    if Dialog({'Do you want to delete', cmd..'?'}, nil, {'Yes','No'})=='Yes' then
      fs.delete(shell.resolve(cmd))
      if Active.CurLine==#Active.tFiles then Active.CurLine=Active.CurLine-1 end
    end
  end
  ShowPanels()
end
 
eventKey[keys.f10]=function()
  work=false
end
 
ShowPanels()
ShowCmd()
local Line
while work do
  local event,p1=os.pullEvent()
  cmd=Active.tFiles[Active.CurLine]
  if event=='char' then
    if curpos==0 then cmdstr=cmdstr..p1
    else cmdstr=cmdstr:sub(1,-1-curpos)..p1..cmdstr:sub(-curpos)
    end
    ShowCmd()
  elseif event=='key' then
    if eventKey[p1]~=nil then
      eventKey[p1]()
      ShowCmd()
    end
  elseif event=='timer' then
    Alt=''
  end
end
term.setCursorPos(1, hScr)
term.clearLine()
print('Thank you for using Midday Commander!')
