DebugConsole(Text) {
	global
	if !DebugConsole
		return
	if (ahk_id hDebugControl = "") {
		Gui, DebugConsole:Font, , Tahoma
		Gui, DebugConsole:Add, Edit, hwndhDebugControl vDebugControl w500 h200
		y := A_ScreenHeight-250
		x := A_ScreenWidth-550
		Gui, DebugConsole:Show, x%x% y%y% , DebugConsole
		Sleep, 200
	}
	Text .= "`n"
    SendMessage, 0x000E, 0, 0,, ahk_id %hDebugControl% ;WM_GETTEXTLENGTH
    SendMessage, 0x00B1, ErrorLevel, ErrorLevel,, ahk_id %hDebugControl% ;EM_SETSEL
    SendMessage, 0x00C2, False, &Text,, ahk_id %hDebugControl% ;EM_REPLACESEL
	return  

}
