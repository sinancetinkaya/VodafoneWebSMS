VodafoneWebSMS(numaralar, sms)
{
	global DebugConsole := true
	anasayfa := "https://www.vodafone.com.tr/MyVodafone/myvodafone.home.php"
	IniDosya := "E:\Belgelerim\Linkler\AutoHotkey\Vodafone\Vodafone.ini"
	IniRead, username, %IniDosya%, Vodafone, username
	IniRead, password, %IniDosya%, Vodafone, password
	if (username = "ERROR" or password = "ERROR") {
		return, "INI:Username&Password yok"
		exit
	}
	DebugConsole("IniRead...OK")
	try {
			pwb := ComObjActive("InternetExplorer.Application")
			DebugConsole("ComObjActive(InternetExplorer.Application)")
		}
	catch {
			pwb := ComObjCreate("InternetExplorer.Application")
			DebugConsole("ComObjCreate(InternetExplorer.Application)")
	}
	ComObjError(false)
	pwb.Visible := true
	pwb.Navigate(anasayfa)
	while !(pwb.busy = 0 and pwb.ReadyState = 4){
		DebugConsole(pwb.busy "/" pwb.ReadyState)
		sleep 100
	}
	DebugConsole("pwb.Navigate(anasayfa)...OK")
;---------------------- Eğer web sayfası yoğunluktan dolayı açılmadıysa tekrar tekrar dene--------
	While pwb.document.all.tags["button"].length > 0 {
		pwb.Navigate(anasayfa)
			DebugConsole("Site açılmadı. 10 saniye sonra tekrar denenecek")
		while !(pwb.busy = 0 and pwb.ReadyState = 4)
			sleep 10000
	}
	DebugConsole("pwb.Navigate(anasayfa)...OK")
;-------------------------------------------------------------------------------------------------
	numara_count := 0
	while (numara_count = 0) {
		doAnaSayfa := true
		while !(pwb.busy = 0 and pwb.ReadyState = 4 and pwb.document.all.tags["span"].length > 0){
			Sleep, 200
			DebugConsole("Sayfanın yüklenmesi için 1000ms bekle... " pwb.busy "/" pwb.ReadyState "/" pwb.document.all.tags["span"].length)
		}

		if(pwb.document.getElementById("formLogin234")){
			DebugConsole("Login gerekiyor... Giriş yapılacak!")
			pwb.document.getElementById("username2").value := username
			pwb.document.getElementById("password2").value := password
			pwb.document.getElementById("formLogin234").submit()
			doAnaSayfa := false
		}
		elements := pwb.document.getElementsByTagName["span"]
		Loop % elements.length
		{
			if(elements[A_Index-1].innertext = "SMS Gönder"){
				DebugConsole("SMS Gönder:" A_Index-1)
				elements[A_Index-1].Click()
				doAnaSayfa := false
				break
			}
		}
		elements := pwb.document.getElementsByTagName["textarea"]
		Loop % elements.length
		{
			if(elements[A_Index-1].value = "Mesajınızı lütfen buraya giriniz."){
				DebugConsole("Mesajınızı lütfen buraya giriniz:" A_Index-1)
				Sleep, 1000
				elements[A_Index-1].Focus()
				elements[A_Index-1].value := sms
				Clipboard := sms
				Send, {Right}	;Workaround: Vodafone sitesi klavye kullanılmadan textarea'ya girilmeden metni ilk WinActivate'te siliyor 
				DebugConsole(sms . "...OK")
				numara_count := 1
				elements := pwb.document.getElementsByTagName["input"]
				Loop, % for(i, 0, elements.length, step := 2) {
					if (elements[i].ClassName = "gwt-TextBox" and numaralar[numara_count] != "" ) {
						elements[i].value := numaralar[numara_count]
						DebugConsole(numaralar[numara_count] . "...OK")
						numara_count++
					}
					i += step
				}
				doAnaSayfa := false
			}
		}
		if (doAnaSayfa){ 
			doAnaSayfaCounter++
			DebugConsole("doAnaSayfa:" doAnaSayfa " / sayac:" doAnaSayfaCounter)
			pwb.Navigate(anasayfa)
			Sleep, 5000
		}
		Sleep, 1000
	}
	COM_Release(pwb) 
}

