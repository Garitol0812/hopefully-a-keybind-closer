#Requires AutoHotkey v2.0
#SingleInstance Force

global SelectedProgram := "notepad.exe"
global CurrentHotkey := ""
global Recording := false

; ---------------- GUI ----------------
gui := Gui()
gui.Title := "Program Closer"

gui.AddText("x10 y10", "Program to close (example: chrome.exe):")
ProgramEdit := gui.AddEdit("x10 y30 w280", SelectedProgram)

gui.AddText("x10 y65", "Hotkey:")
HotkeyDisplay := gui.AddEdit("x10 y85 w200 ReadOnly", "None")

RecordBtn := gui.AddButton("x220 y83 w70", "Record")
RecordBtn.OnEvent("Click", StartRecording)

gui.AddButton("x10 y130 w120", "Save").OnEvent("Click", SaveSettings)
gui.AddButton("x170 y130 w120", "Exit").OnEvent("Click", (*) => ExitApp())

gui.Show("w310 h180")

; ---------------- HOTKEY RECORDING ----------------
StartRecording(*) {
    global Recording
    Recording := true
    HotkeyDisplay.Value := "Press keys..."
}

~*Ctrl::
~*Alt::
~*Shift::
~*a::~*b::~*c::~*d::~*e::~*f::~*g::~*h::~*i::~*j::
~*k::~*l::~*m::~*n::~*o::~*p::~*q::~*r::~*s::~*t::
~*u::~*v::~*w::~*x::~*y::~*z::
~*F1::~*F2::~*F3::~*F4::~*F5::~*F6::~*F7::~*F8::~*F9::~*F10::~*F11::~*F12::
{
    global Recording, CurrentHotkey
    if !Recording
        return

    Recording := false
    CurrentHotkey := GetKeyCombo()
    HotkeyDisplay.Value := CurrentHotkey
}

GetKeyCombo() {
    combo := ""
    if GetKeyState("Ctrl")
        combo .= "^"
    if GetKeyState("Alt")
        combo .= "!"
    if GetKeyState("Shift")
        combo .= "+"

    for key in ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
               ,"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"] {
        if GetKeyState(key, "P")
            return combo . key
    }
    return ""
}

; ---------------- SAVE + HOTKEY ----------------
SaveSettings(*) {
    global SelectedProgram, CurrentHotkey, ProgramEdit

    if CurrentHotkey = "" {
        MsgBox "Please record a hotkey first."
        return
    }

    SelectedProgram := ProgramEdit.Value
    Hotkey(CurrentHotkey, CloseProgram, "On")

    MsgBox "Saved!`nHotkey is now active."
}

CloseProgram(*) {
    global SelectedProgram
    ProcessClose(SelectedProgram)
}
