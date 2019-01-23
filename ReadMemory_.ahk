ReadMemory(MADDRESS)
{


VarSetCapacity(MVALUE,4,0)
ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", 7408, "UInt")
DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",4,"UInt *",0)

Loop 4
result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)

return, result 
}