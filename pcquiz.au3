#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=diasporaquiz.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Dick Davies

 Script Function:
  Quiz based on diaspora

 Version info:	 Written 05/07/2012
 Last mods:      05/07/2012
 Version:        0.2.0

#ce ----------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Timers.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>


; Dims
Dim $question_number = 1
Dim $number_of_questions = 0
Dim $top_button_number = 0
Dim $button_filename = ""
Dim $quiz_name = "Diaspora Quiz"
Dim $inifilename = "pcquiz.ini"
Dim $qno = 0
Dim $bno = 0
Dim $round_score = 0
Dim $top_rank = 0
Dim $questionlabel = 0
Dim $question_number_label = 0
Dim $Msg = ""
Dim $button_no = 0
Dim $debuglabel=0
Dim $Bg_Pic = 0
Dim $pbtop = 0
Dim $pbleft = 0
Dim $pbht = 0
Dim $pbwid = 0
Dim $done = 0
Dim $buttonpressed=1
Dim $Quiz_Form  ; Main quiz form window handle
Dim $conc_form ; Results form
Dim $conc_button ; button to clear conc form
Dim $score = 0 ; Score
; Declare labels
Dim $question_detail_label = 0
Dim $question_headline_label = 0
Dim $question_footer_label = 0
Dim $Quote1_label = 0
Dim $Quote2_label = 0
Dim $Quote3_label = 0
Dim $Quote4_label = 0
Dim $Quote5_label = 0
Dim $correct_quote = ""
Dim $full_quote_ref = ""

; Arrays
Dim $Options_array = 0
Dim $Options_comment_array = 0
Dim $conclusion_head_array = 0
Dim $Conclusion_copy_array = 0
; Array holding light state (not using index 0)
Dim $Lights_array [9] = [0,0,0,0,0,0,0,0,0]
; Have to allow for 10 pics in order to allow use of case statement on main loop
Dim $Button_pic_ctrl [10] = [0]
; Read settings in from .ini file
$inifilename = "pcquiz.ini"
; Assume located in script folder
$inifilepath = @ScriptDir & "\" & $inifilename
; reading from ini file into variables and arrays
$quiz_name = IniRead( $inifilepath,"General","Quiz_name","New Quiz")
$quiz_title = IniRead( $inifilepath,"General","Quiz_title","Quiz Title")
$conc_title = IniRead( $inifilepath,"General","Conc_title","conclusion...")
$thanks_title = IniRead( $inifilepath,"General","Thanks_title","conclusion...")
$quiz_description = IniRead( $inifilepath,"General","Quiz_description","Quiz description")
$move_on_message =  IniRead( $inifilepath,"General","Move_on_message","tap to continue")
$end_copy =  IniRead( $inifilepath,"General","end_copy","")
$top_button_number = IniRead( $inifilepath,"General","top_button_number","1")
$top_question_number = IniRead( $inifilepath,"General","top_question_number","1")
; filenames of graphics
$main_screen_background = @ScriptDir & "\" & IniRead( $inifilepath ,"General","main_screen_background","")
$conc_screen_background = @ScriptDir & "\" & IniRead( $inifilepath ,"General","conc_screen_background","")
$conc_button_filename = @ScriptDir & "\" & IniRead($inifilepath,"General", "conc_button_filename","")
; Change this in ini file to inhibit closing form
$exit_allowed = IniRead( $inifilepath,"General","Exit_allowed",1)
; Size of screen
$main_picsize_x = IniRead($inifilepath ,"General","main_picsize_x",0)
$main_picsize_y = IniRead($inifilepath ,"General","main_picsize_y",0)
$conc_picsize_x = IniRead($inifilepath ,"General","conc_picsize_x",0)
$conc_picsize_y = IniRead($inifilepath ,"General","conc_picsize_y",0)
; Should we draw a box for the question area
$question_box_draw = IniRead($inifilepath ,"General","question_box_draw",1)
; font for copy
$text_font = IniRead($inifilepath, "General","text_font","Arial")
; text attributes
$text_size_1 = IniRead($inifilepath,"General","text_size_1",26)
$text_size_2 = IniRead($inifilepath,"General","text_size_2",26)
$text_size_3 = IniRead($inifilepath,"General","text_size_3",22)
$text_size_4 = IniRead($inifilepath,"General","text_size_4",22)
$text_size_5 = IniRead($inifilepath,"General","text_size_5",18)
$text_size_6 = IniRead($inifilepath,"General","text_size_6",18)
$text_size_7 = IniRead($inifilepath,"General","text_size_7",16)
$text_size_8 = IniRead($inifilepath,"General","text_size_8",16)
$text_wt_1 = IniRead($inifilepath,"General","text_wt_1",400)
$text_wt_2 = IniRead($inifilepath,"General","text_wt_2",800)
$text_wt_3 = IniRead($inifilepath,"General","text_wt_3",400)
$text_wt_4 = IniRead($inifilepath,"General","text_wt_4",800)
$text_wt_5 = IniRead($inifilepath,"General","text_wt_5",400)
$text_wt_6 = IniRead($inifilepath,"General","text_wt_6",800)
$text_wt_7 = IniRead($inifilepath,"General","text_wt_7",400)
$text_wt_8 = IniRead($inifilepath,"General","text_wt_8",800)

; Colour scheme
$colour1 = IniRead($inifilepath,"General","colour1","")
$colour2 = IniRead($inifilepath,"General","colour2","")
$colour3 = IniRead($inifilepath,"General","colour3","")
$colour4 = IniRead($inifilepath,"General","colour4","")
$colour5 = IniRead($inifilepath,"General","colour5","")
$colour6 = IniRead($inifilepath,"General","colour6","")
;green bg and purple and pink
$colour7 = IniRead($inifilepath,"General","colour7","")
$colour8 = IniRead($inifilepath,"General","colour8","")
$colour9 = IniRead($inifilepath,"General","colour9","")
;purple bg and pink
$colour10 = IniRead($inifilepath,"General","colour10","")
$colour11 = IniRead($inifilepath,"General","colour11","")
$colour12 = IniRead($inifilepath,"General","colour12","")
;idle time and answer delay
$idle_time_max=IniRead($inifilepath,"General","idle_time_max","")
$show_answer_time=IniRead($inifilepath,"General","show_answer_time", 2000)
; Button setup - Read button filenames
$button_filename = IniReadSection( $inifilepath, "Buttons" )
; Read Button locations, X then Y
$button_x_position = IniReadSection( $inifilepath, "Button X Pos")
$button_y_position = IniReadSection( $inifilepath, "Button Y Pos")
; Read Intro text
$intro_text = IniRead ($inifilepath, "Intro", "intro1","") & " "
$intro_text &= IniRead ($inifilepath, "Intro", "intro2","") & " "
$intro_text &= IniRead ($inifilepath, "Intro", "intro3","") & " "
$intro_text &= IniRead ($inifilepath, "Intro", "intro4","") & " "
$intro_text &= IniRead ($inifilepath, "Intro", "intro5","")
; Read questions into arrays
$question_headline = IniReadSection ($inifilepath, "question_headline")
$question_detail = IniReadSection ( $inifilepath, "question_detail")
$question_footer = IniReadSection ( $inifilepath, "question_footer")
; Read answers into array
$conclusion_head_array = IniReadSection ($inifilepath, "conclusions_head")
$Conclusion_copy_array = IniReadSection ($inifilepath, "conclusions_copy")
$conclusion_footer_array = IniReadSection ($inifilepath, "conclusion_source")
; Read correct question numbers into array
$correct_question = IniReadSection ( $inifilepath, "Correct Number")
Const $cmd_on = 0x11
Const $cmd_off = 0x12
Const $zero = 0x00
Dim $errortype =""
Dim $error_context=""
Dim $timeout = False
Dim $idle_time = 0
Dim $conc_form_timer
Dim $quiz_form_timer
; Popup form
Dim $Conclusions_label
Dim $conc_timer_label
Dim $conc_title_label
Dim $conc_anykey_label
Dim $conc_title
Dim $conc_anykey
Dim $conc_timer
Dim $intro_form = False

; Main section - control loop
Do
	;Reset quiz
	$score = 0
	; Set up quiz screen
	setup_question_screen()
	setup_keys()
	; Introductory screens
	$conclusion_form_title = $quiz_description
	$conclusion_text = $intro_text
	$conc_anykey = $move_on_message
	$timeout=False
	$intro_form=True
	do_conclusion()
	$intro_form=False
	GUISetState(@SW_SHOW,$Quiz_Form)
	; Start questionaire section
	For $question_number = 1 to $top_question_number
		show_question()
		; reset round score
		$round_score=0
		$buttonpressed=0
		;poll for button presses
		get_buttons()
		If $timeout then ExitLoop
		If $round_score = $correct_question [$question_number][1] Then
			; add score
			$score += 1
			Beep (550,100)
			; show correct result and flash lights
		Else
			Beep (300,100)
		EndIf
		show_question_attrib()
		Sleep($show_answer_time)
	   ;show full correct quotation and comment or ref
		$conclusion_form_title = $quiz_title
		$conclusion_text = $question_number & " of " & $top_question_number & ":" & @CRLF & @CRLF
		$conclusion_text &= $conclusion_head_array [$question_number][1]& @CRLF & @CRLF
		$conclusion_text &= $Conclusion_copy_array [$question_number][1] & @CRLF & @CRLF
		$conclusion_text &= $conclusion_footer_array [$question_number][1]
		do_conclusion()
	Next
	; Show results page
	$conclusion_form_title = $thanks_title
	$conclusion_text = $end_copy & @CRLF & @CRLF
	$conclusion_text &= "Your score was "& $score & " out of a possible "& $top_question_number &" points." & @CRLF & @CRLF
	GUISetState(@SW_HIDE,$Quiz_Form)
	do_conclusion()
Until false
Func show_question()
	;clear arrays
	$Options_array = 0
	$Options_array = IniReadSection ($inifilepath, "Options"&$question_number )
    ; question headline
	GUICtrlSetData($question_headline_label,"")
	GUICtrlSetData($question_headline_label, $question_headline [$question_number][1])
	GUICtrlSetColor($question_headline_label, $colour7)
	; question detail
	GUICtrlSetData($question_detail_label,"")
	GUICtrlSetData($question_detail_label, $question_detail [$question_number][1])
	GUICtrlSetColor($question_detail_label, $colour8)
	;question footer
	GUICtrlSetData($question_footer_label,"")
	GUICtrlSetData($question_footer_label, $question_footer [$question_number][1])
	GUICtrlSetColor($question_footer_label, $colour9)
	;quotations
	GUICtrlSetData($Quote1_label,"")
	GUICtrlSetData($Quote1_label, $Options_array [1][1])
	GUICtrlSetColor($Quote1_label, $colour10)
	GUICtrlSetData($Quote2_label,"")
	GUICtrlSetColor($Quote2_label, $colour10)
	GUICtrlSetData($Quote2_label, $Options_array [2][1])
	GUICtrlSetData($Quote3_label,"")
	GUICtrlSetColor($Quote3_label, $colour10)
	GUICtrlSetData($Quote3_label, $Options_array [3][1])
	GUICtrlSetData($Quote4_label,"")
	GUICtrlSetColor($Quote4_label, $colour10)
	GUICtrlSetData($Quote4_label, $Options_array [4][1])
	GUICtrlSetData($Quote5_label,"")
	GUICtrlSetColor($Quote5_label, $colour10)
	GUICtrlSetData($Quote5_label, $Options_array [5][1])
EndFunc
Func show_question_attrib()
	;clear arrays
	$Options_array = 0
	$Options_comment_array = 0
	; read options for this question into arrays
	$Options_array = IniReadSection ($inifilepath, "options"&$question_number )
	$Options_comment_array = IniReadSection ($inifilepath, "option_comments"&$question_number)
    ; question headline
	GUICtrlSetData($question_headline_label,"")
	GUICtrlSetData($question_headline_label, $question_headline [$question_number][1])
	GUICtrlSetColor($question_headline_label, $colour7)
	; question detail
	GUICtrlSetData($question_detail_label,"")
	GUICtrlSetData($question_detail_label, $question_detail [$question_number][1])
	GUICtrlSetColor($question_detail_label, $colour8)
	;question footer
	GUICtrlSetData($question_footer_label,"")
	GUICtrlSetData($question_footer_label, $question_footer [$question_number][1])
	GUICtrlSetColor($question_footer_label, $colour9)
	;correct quotation and reference
	$correct_quote = $Options_array [($correct_question [$question_number][1])][1]& @CRLF & @CRLF & $Options_comment_array [($correct_question [$question_number][1])][1]
	;quotations in colour 4
	GUICtrlSetData($Quote1_label,"")
	GUICtrlSetData($Quote1_label, $Options_array [1][1]& @CRLF & @CRLF & $Options_comment_array [1][1])
    GUICtrlSetColor($Quote1_label, $colour11)
	GUICtrlSetData($Quote2_label,"")
	GUICtrlSetData($Quote2_label, $Options_array [2][1]& @CRLF & @CRLF & $Options_comment_array [2][1])
	GUICtrlSetColor($Quote2_label, $colour11)
	GUICtrlSetData($Quote3_label,"")
	GUICtrlSetData($Quote3_label, $Options_array [3][1]& @CRLF & @CRLF & $Options_comment_array [3][1])
	GUICtrlSetColor($Quote3_label, $colour11)
	GUICtrlSetData($Quote4_label,"")
	GUICtrlSetData($Quote4_label, $Options_array [4][1]& @CRLF & @CRLF & $Options_comment_array [4][1])
	GUICtrlSetColor($Quote4_label, $colour11)
	GUICtrlSetData($Quote5_label,"")
	GUICtrlSetData($Quote5_label, $Options_array [5][1]& @CRLF & @CRLF & $Options_comment_array [5][1])
	GUICtrlSetColor($Quote5_label, $colour11)
	; highlight correct option using colour 12
	Switch $correct_question [$question_number][1]
		Case 1
			GUICtrlSetColor($Quote1_label, $colour12)
		Case 2
			GUICtrlSetColor($Quote2_label, $colour12)
		Case 3
			GUICtrlSetColor($Quote3_label, $colour12)
		Case 4
			GUICtrlSetColor($Quote4_label, $colour12)
		Case 5
			GUICtrlSetColor($Quote5_label, $colour12)
	EndSwitch
EndFunc
Func setup_question_screen()
	; Set up the GUI and show background with buttons on
	$Quiz_Form = GUICreate($quiz_name, $main_picsize_x, $main_picsize_y, -1, -1)
	$Bg_Pic = GUICtrlCreatePic($main_screen_background, 0, 0, $main_picsize_x, $main_picsize_y,0)
    If $question_box_draw>0 Then
		;Highlight topic area in colour 6
		$Bg_box = GUICtrlCreateLabel("",0,0,500,265)
		GUICtrlSetBkColor($Bg_box,$colour6)
	EndIf
	;question copy - headline, detail, question
	$question_headline_label = GUICtrlCreateLabel("Question headline", 16, 8, 404, 90)
	GUICtrlSetBkColor($question_headline_label,$GUI_BKCOLOR_TRANSPARENT )
	GUICtrlSetFont(-1, $text_size_2, $text_wt_2, 0, $text_font)
	GUICtrlSetColor(-1, $colour5)
	$question_detail_label = GUICtrlCreateLabel("Question detail", 16, 100, 404, 131)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT )
	GUICtrlSetFont(-1, $text_size_5, $text_wt_5, 0, $text_font)
	GUICtrlSetColor(-1, $colour4)
	$question_footer_label = GUICtrlCreateLabel("Question label", 16, 232, 403, 29)
	GUICtrlSetBkColor($question_footer_label,$GUI_BKCOLOR_TRANSPARENT )
	GUICtrlSetFont(-1, $text_size_8, $text_wt_8, 0, $text_font)
	GUICtrlSetColor(-1, $colour3)
    ;option1-5 areas (288)
	$Quote1_label = GUICtrlCreateLabel("Quote 1", 232, 318, 250, 209)
	GUICtrlSetFont(-1, $text_size_7, $text_wt_7, 0, $text_font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Quote2_label = GUICtrlCreateLabel("Quote 2", 232, 534, 250, 209)
	GUICtrlSetFont(-1, $text_size_7, $text_wt_7, 0, $text_font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Quote3_label = GUICtrlCreateLabel("Quote 3", 520, 102, 250, 209)
	GUICtrlSetFont(-1, $text_size_7, $text_wt_7, 0, $text_font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Quote4_label = GUICtrlCreateLabel("Quote 4", 520, 318, 250, 209)
	GUICtrlSetFont(-1, $text_size_7, $text_wt_7, 0, $text_font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Quote5_label = GUICtrlCreateLabel("Quote 5", 520, 534, 250, 209)
	GUICtrlSetFont(-1, $text_size_7, $text_wt_7, 0, $text_font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	;Show buttons
	draw_buttons()
EndFunc
Func do_conclusion()
	; Set up the results as a GUI screen
	$conc_form=GUICreate("Conclusions:", $conc_picsize_x, $conc_picsize_y, -1, -1 )
	$conc_bg=GUICtrlCreatePic($conc_screen_background, 0,0, $conc_picsize_x, $conc_picsize_y)
	; Set up several labels all diff colours
	;$conc_title_label
	$conc_title_label = GUICtrlCreateLabel($conclusion_form_title, 10, 10, 780, 100)
	GUICtrlSetColor($conc_title_label,$colour4)
	GUICtrlSetBkColor($conc_title_label, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($conc_title_label, $text_size_3, $text_wt_3, 0, $text_font)
	;$Conclusions_label
	$Conclusions_label = GUICtrlCreateLabel($conclusion_text, 10, 230, 780, 400)
	GUICtrlSetColor($Conclusions_label,$colour1)
	GUICtrlSetBkColor($Conclusions_label, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($Conclusions_label, $text_size_1, $text_wt_1, 0, $text_font)
	;$conc_anykey_label
	$conc_anykey_label = GUICtrlCreateLabel($conc_anykey, 10, 560, 780, 100)
	GUICtrlSetColor($conc_anykey_label,$colour12)
	GUICtrlSetBkColor($conc_anykey_label, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($conc_anykey_label, $text_size_4, $text_wt_4, 0, $text_font)
	;$conc_timer_label
	$conc_timer_label = GUICtrlCreateLabel("", 730, 580, 100, 30)
	GUICtrlSetBkColor($conc_timer_label, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($conc_timer_label, $text_size_6, $text_wt_6, 0, $text_font)
	GUICtrlSetData($conc_timer_label,StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC))
	GUISetState(@SW_SHOW,$conc_form)

	;Click screen to clear window
	$buttonpressed=0
	While ($buttonpressed=0)
		$nMsg = GUIGetMsg()
		If $nMsg = $conc_bg Then $buttonpressed=1
		If $nMsg = $GUI_EVENT_CLOSE Then $buttonpressed=1
		$idle_time=_Timer_GetIdleTime()
		If ($idle_time > $idle_time_max) And ($intro_form=False) Then $timeout=True
		If $timeout Then $buttonpressed=True
	WEnd
	;Clear results form
	GUISetState(@SW_HIDE,$conc_form)
EndFunc
Func setup_keys()
	; Setup hotkeys for numerics
	HotKeySet("0", "do_nowt")
	HotKeySet("1", "do_nowt")
	HotKeySet("2", "do_nowt")
	HotKeySet("3", "do_nowt")
	HotKeySet("4", "do_nowt")
	HotKeySet("5", "do_nowt")
	HotKeySet("6", "do_nowt")
	HotKeySet("7", "do_nowt")
	HotKeySet("8", "do_nowt")
	HotKeySet("9", "do_nowt")
EndFunc
Func get_buttons()
	While (Not $buttonpressed)
		If $timeout Then ExitLoop
		$nMsg = GUIGetMsg()
		; Check for control action (positive) or system event (neg) or nowt (zero)
		If $nMsg >0 Then
			; Button presses
			For $button_no = 1 to $top_button_number +1
				If $nMsg=$Button_pic_ctrl[$button_no-1] Then
					$round_score=$button_no -1
					$buttonpressed = 1
				EndIf
			Next
		ElseIf $nMsg = 0 And $buttonpressed Then
			; Keyboard presses in @HotKeyPressed
			$round_score = @HotKeyPressed
			If $round_score < 0 then $round_score = 0
			If $round_score > $top_button_number Then
				$round_score =0
				$buttonpressed =0
			EndIf
		EndIf
		; Detect form exit by close window
		If $nMsg = $GUI_EVENT_CLOSE Then
			; Check - exit if allowed
			If $exit_allowed = 1 Then
				Exit
			EndIf
		EndIf
		$idle_time=_Timer_GetIdleTime()
		If ($idle_time > $idle_time_max) Then $timeout=True
	WEnd
EndFunc
Func do_nowt()
	; Dummy hotkey action
	$buttonpressed = 1
EndFunc
Func draw_buttons()
	;put all of the buttons on the screen
	For $bno=1 to $top_button_number
		; for each button
		$Button_pic_ctrl[$bno] = GUICtrlCreatePic($button_filename[$bno][1], $button_x_position[$bno][1], $button_y_position[$bno][1], 206, 209,-1,$WS_EX_TRANSPARENT)
	Next
	; disable the background picture
	GuiCtrlSetState($Bg_Pic,$GUI_DISABLE)
EndFunc

