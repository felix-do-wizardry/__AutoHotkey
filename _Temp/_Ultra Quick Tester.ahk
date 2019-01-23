
n := 10
r := 10
txt := ""
combinationOutput := []
while ( combinationGenerator(n,r,A_Index-1) > 0 ) {
	arrayTemp := combinationOutput
	while ( A_Index <= r , i := A_Index - 1 )
		txt := txt arrayTemp[i] " "
	txt := txt "`n"
}
MsgBox, %txt%



#SingleInstance force
^`::suspend
!`::reload
^!`::exitapp
return


combinationGenerator(n,r,seed) {
	global combinationOutput
	if ( seed < 0 || n < 0 || r < 0 || n < r )
		return -1
	
	;calculating the total amount = n! / r! / (n-r)!
	result := 1
	temp := n
	while ( temp > r ) {
		result *= temp
		temp--
	}
	temp := n - r
	while ( temp > 0 ) {
		result /= temp
		temp--
	}
	
	if ( seed >= result )
		return 0
	
	while ( A_Index <= 25 , i := A_Index - 1 ) {
		if ( i < r)
			combinationOutput[i] := i
		else
			combinationOutput[i] := -1
	}
	
	while ( A_Index <= seed ) {
		; adding 1 to the last one
		combinationOutput[r - 1]++
		; checking
		while ( A_Index <= r - 1 , i := r - A_Index ) {
			if ( combinationOutput[i] > n - r + i ) {
				combinationOutput[i - 1]++
				while ( A_Index <= r - i )
					combinationOutput[i - 1 + A_Index ] := combinationOutput[i - 1] + A_Index
			}
		}
	}
	
	return result
}