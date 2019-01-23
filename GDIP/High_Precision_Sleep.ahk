; High Precision Sleep v1.0 by undine
; Compatible with AHK Basic / AHK_L ANSI / AHK_L U32 / AHK_L U64
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms686298%28v=vs.85%29.aspx
; Works best with HPET enabled

Sleep(ms=1)
{
		global timeBeginPeriodHasAlreadyBeenCalled
		if (timeBeginPeriodHasAlreadyBeenCalled != 1)
		{
			DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
			timeBeginPeriodHasAlreadyBeenCalled := 1
		}
		
	DllCall("Sleep", UInt, ms)
}