delay:=300

^`::suspend
!`::reload
return

------------------------------------------------------------------------------------------------------------------------
#SingleInstance force

------------------------------------------------------------------------------------------------------------------------

normal(a)
{
	if ( a = 1 )
		click 360 500
	if ( a = 2 )
		click 660 500
	if ( a = 3 )
		click 360 600
	if ( a = 4 )
		click 660 600
}

------------------------------------------------------------------------------------------------------------------------

^1::
sleep 1000

normal(4)
sleep %delay%

normal(3)
sleep %delay%

normal(1)
sleep %delay%

----------------------------------

click 525 380
sleep %delay%

----------------------------------

click 820 600 0
click 900 600 0
click 900 225 0
click 150 225 0
click 150 520 0
click 245 520 0
click
sleep %delay%

----------------------------------

normal(3)
sleep %delay%

normal(4)
sleep %delay%

----------------------------------

click 400 476
sleep %delay%

----------------------------------

normal(2)
sleep %delay%

----------------------------------

click 435 600
sleep %delay%

send ^2
return

--------------------------------------------------------------------------------

^2::
sleep 1000

normal(2)
sleep %delay%

----------------------------------

click 465 317
sleep %delay%

----------------------------------

normal(2)
sleep %delay%

normal(2)
sleep %delay%

----------------------------------

click 600 560
click 700 480
click 460 480
click 390 560
click 410 490
sleep %delay%

----------------------------------

normal(2)
sleep %delay%

----------------------------------

click 246 326
sleep %delay%

----------------------------------

click 435 530
sleep %delay%

----------------------------------

click 530 580
click 590 480
click 760 490 2
click 670 490
click 790 650
sleep %delay%

----------------------------------

normal(3)
sleep %delay%


send ^3
return

--------------------------------------------------------------------------------

^3::
sleep 1000

normal(1)
sleep %delay%
normal(4)
sleep %delay%
normal(4)
sleep %delay%

----------------------------------

click 275 720
sleep %delay%

----------------------------------

normal(1)
sleep %delay%

----------------------------------

click 490 490
sleep %delay%

----------------------------------

normal(4)
sleep %delay%

----------------------------------

click 360 560
sleep %delay%

----------------------------------

normal(3)
sleep %delay%

----------------------------------

click 275 600 0
click 400 530 0
click 526 550 0
click 630 495 0
click
sleep %delay%

----------------------------------

send ^4
return

--------------------------------------------------------------------------------

^4::
sleep 1000

----------------------------------

normal(3)
sleep %delay%
normal(2)
sleep %delay%
normal(1)
sleep %delay%

----------------------------------

click 900 500 0
sleep 12000

click 540 550
sleep 3000

----------------------------------

normal(2)
sleep %delay%
normal(2)
sleep %delay%
normal(2)
sleep %delay%
normal(1)
sleep %delay%

----------------------------------

click 390 500 0
click 390 470 0
click right
sleep 250
click 570 500 0
click 570 460
sleep 250
click 570 500
sleep %delay%

----------------------------------

send ^5
return

--------------------------------------------------------------------------------

^5::
sleep 1000

----------------------------------

click 370 320
sleep %delay%

click 320 650
sleep %delay%

----------------------------------

normal(4)
sleep %delay%

----------------------------------

click 728 352 0
click down
click 500 352 0
click up
sleep %delay%
click 728 352
sleep %delay%

----------------------------------

normal(2)
sleep %delay%
normal(3)
sleep %delay%

----------------------------------

sleep 8000
click 576 445
sleep %delay%

----------------------------------

normal(2)
sleep %delay%
normal(4)
sleep %delay%
normal(1)
sleep %delay%

send ^6
return

--------------------------------------------------------------------------------

^6::
sleep 1000

loop 18 {
	click 570 580
	sleep %delay%
}
sleep 6000

----------------------------------

click 600 520
sleep 5000

----------------------------------

normal(3)
sleep %delay%
normal(4)
sleep %delay%
normal(2)
sleep %delay%

----------------------------------

sleep 8000

click 444 395
click 710 620
click 444 395
click 472 653
sleep %delay%

----------------------------------

normal(1)
sleep %delay%
normal(4)
sleep %delay%

----------------------------------

sleep 500
loop 50 {
	click 282 644
	sleep 100
}
sleep 5000

----------------------------------

click 666 560
sleep %delay%

send ^7
return

--------------------------------------------------------------------------------

^7::
sleep 1000

normal(1)
sleep %delay%

----------------------------------

click 300 575
sleep %delay%

----------------------------------

normal(2)
sleep %delay%
normal(4)
sleep %delay%

----------------------------------

click 520 420
sleep %delay%

----------------------------------

click 640 400
sleep %delay%

----------------------------------

click 365 420
sleep %delay%

----------------------------------

sleep 2000
loop 64 {
	click 420 500 0
	sleep 20
	click 490 430 0
	sleep 20
}
sleep 2000

----------------------------------

normal(4)
sleep %delay%
normal(3)
sleep %delay%

----------------------------------

return

--------------------------------------------------------------------------------