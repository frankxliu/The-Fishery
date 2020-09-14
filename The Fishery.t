%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer(s): Frankie Liu
% Program Name : The Fishery
% Description  : Welcome to Frankie's Fishery! Where
% the objective is to catch all the fish on that day.
% In order to catch the fish, you have to match the
% fishes' movement. In success of catching all the 
% fish, you will proceed to the next day with more
% agressive swimmers. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% GLOBAL VARIABLES %%%%%
import GUI
View.Set ("graphics:400;700, offscreenonly, nobuttonbar")
var fishx, fishy, dx : flexible array 1 .. 0 of int
var caught, hit : flexible array 1 .. 0 of boolean
var x, y, button, xm, ym, buttonm : int
var x1, x2, slider_y, slider_y2, sy, oval_y, bar_y, timer, lives, livesx, r1 : int
var counter : int := 1
var boatx, rody : int
var barfull, slide, failcatch : boolean := false
var fishcaught : int := 0
var L1, L2, L3 : int
var font, font1 : int
var fishyup : int := 5
var fishydown : int := -5
var upgradeprice : int := 50
var day, moneygained, money : int := 0
var stream1 : int
var str1 : string
var a : string (1)
font := Font.New ("sans serif:20: bold")
font1 := Font.New ("palantino:14:bold")
x1 := 336
x2 := 379
slider_y := 0
slider_y2 := 75
oval_y := 300
bar_y := 0
boatx := 200
rody := 610
lives := 3
L1 := 12
L2 := 12
L3 := 12
r1 := 5
sy := 3


%%%%% SUBPROGRAMS %%%%%
proc newarr
    new fishx, counter
    new fishy, counter
    new dx, counter
    new caught, counter
    new hit, counter

    for count : 1 .. counter
	dx (count) := Rand.Int (1, 3)
	fishx (count) := Rand.Int (50, 350)
	fishy (count) := Rand.Int (50, 570)
	caught (count) := false
	hit (count) := false
	Draw.FillOval (fishx (count), fishy (count), 25, 25, 54)
    end for
    fishcaught := 0
end newarr



proc reset
    oval_y := 300
    slider_y := 0
    slider_y2 := 75
    bar_y := 0
    rody := 610
end reset

proc sliderspeed
    if money > upgradeprice then
	money := money - upgradeprice
	sy += 1
	Draw.Text ("Upgraded!", 85, 150, font, 16)
	Draw.Text ("- $" + intstr (upgradeprice), 300, 150, font, 16)
    elsif money < upgradeprice then
	Draw.Text ("Not enough money!", 85, 150, font, 16)
    end if
    View.Update
end sliderspeed

proc drawfish
    for i : 1 .. counter
	if caught (i) = false then
	    Draw.FillOval (fishx (i), fishy (i), 25, 25, 54)
	end if
    end for
end drawfish

proc fish
    for i : 1 .. counter
	if caught (i) = false then
	    fishx (i) += dx (i)
	    if fishx (i) >= 310 then
		dx (i) := -Rand.Int (1, 3)
	    elsif fishx (i) <= 25 then
		dx (i) := Rand.Int (1, 3)
	    end if
	elsif caught (i) = true then
	end if
    end for
    drawfish
end fish

proc moveBoat
    var key : array char of boolean
    Input.KeyDown (key)

    if key (KEY_LEFT_ARROW) and boatx >= 5 then
	boatx -= 2
    end if
    if key (KEY_RIGHT_ARROW) and boatx <= 330 then
	boatx += 2
    end if
    if key (KEY_DOWN_ARROW) then
	rody -= 3
    end if
    if key (KEY_UP_ARROW) and rody <= 610 then
	rody += 3
    end if
end moveBoat

fcn hitTest (i : int) : boolean
    if boatx >= fishx (i) - 20 and boatx <= fishx (i) + 20 and rody >= fishy (i) - 20 and rody <= fishy (i) + 20 then
	result true
    end if
    result false
end hitTest

proc checkCollision
    for i : 1 .. counter
	if hitTest (i) then
	    hit (i) := true
	    slide := true
	end if
    end for
end checkCollision

proc draw
    Draw.FillBox (0, 0, 334, 615, 78)  %blue background
    Draw.FillBox (335, 98, 370, 600, white)          %big slider
    Draw.FillBox (370, 98, 381, 600, white)     %small slider
    Draw.Box (335, 0, 380, 615, black)     %big slider outline
    Draw.Box (380, 0, 398, 615, black)     %small slider outline
    Draw.FillBox (381, 0, 397, bar_y, yellow)     %yellow slider
    Draw.FillBox (x1, slider_y, x2, slider_y2, 77)     %blue slider
    Draw.FillOval (357, oval_y, 10, 10, 3)
    Draw.FillOval (boatx, 615, 5, 5, black)
    Draw.ThickLine (boatx, 615, boatx, rody, 2, black)
    put " " : 21, "Day " + intstr (day) : 14, "Fish caught: " + intstr (fishcaught)
    put " " : 35, "Money : $" + intstr (money)
    Draw.Text ("HP: ", 3, 680, font1, 40)
    Draw.FillBox (40, 675, 50, 695, L1)
    Draw.FillBox (55, 675, 65, 695, L2)
    Draw.FillBox (70, 675, 80, 695, L3)
end draw

proc slider
    timer := Time.Elapsed
    loop
	draw
	drawfish
	Mouse.Where (x, y, button)
	if button = 1 and slider_y2 < 615 then
	    slider_y += sy
	    slider_y2 += sy
	elsif slider_y > 0 then
	    slider_y -= sy
	    slider_y2 -= sy
	end if


	if oval_y > 580 then
	    oval_y += Rand.Int (-80, -30)
	elsif oval_y < 50 then
	    oval_y += Rand.Int (10, 70)
	else
	    oval_y += Rand.Int (fishydown, fishyup)
	end if

	if oval_y > slider_y and oval_y < slider_y2 and bar_y <= 615 then
	    bar_y += 4
	elsif bar_y > 0 then
	    bar_y -= 5
	end if


	if Time.Elapsed - timer >= 11000 then
	    slide := false
	    barfull := true
	    failcatch := true
	    rody := 610
	    lives -= 1
	    exit
	end if

	if bar_y >= 613 then
	    for i : 1 .. counter
		if hit (i) = true then
		    caught (i) := true
		    fishx (i) := -50
		    barfull := true
		    slide := false
		end if
	    end for
	    fishcaught += 1
	    exit
	end if
	View.UpdateArea (335, 0, 400, 700)
	delay (10)
	cls
    end loop
end slider


proc update
    if slide = true then
	slider
    else
	View.Update
	delay (10)
	cls
    end if

    if barfull = true then
	reset
	barfull := false
    end if
end update

proc loselives
    if lives = 2 then
	L3 := 0
    elsif lives = 1 then
	L3 := 0
	L2 := 0
    elsif lives = 0 then
	L3 := 0
	L2 := 0
	L1 := 0
    end if
end loselives

proc winlevel
    if fishcaught = counter then
	moneygained := 15 * fishcaught
	money += moneygained
	loop
	    Draw.FillOval (200, 350, r1, r1, 101)
	    r1 += 8
	    delay (10)
	    Draw.Text ("Day " + intstr (day), 170, 600, font, 16)
	    Draw.Text ("Fishes caught: " + intstr (fishcaught), 100, 500, font, 16)
	    Draw.Text ("Money gained: $" + intstr (moneygained), 90, 400, font, 16)
	    Draw.Text ("Current Money: $" + intstr (money), 85, 300, font, 16)
	    View.Update
	    exit when r1 >= 1000
	end loop
	GUI.Refresh
	var button : int := GUI.CreateButtonFull (100, 200, 0, "Upgrade Rod: $" + intstr (upgradeprice), sliderspeed, 0, '^D', true)
	var nextbtn : int := GUI.CreateButton (100, 100, 0, "Next", GUI.Quit)
	View.Update
	GUI.ResetQuit
	loop
	    exit when GUI.ProcessEvent
	end loop
    end if
end winlevel

proc losescreen
    if lives = 0 then
	cls
	var c : int := 40
	Draw.Text ("You Lose.", 150, 350, font, c)
	View.Update
    end if
end losescreen


%%%%% MAIN CODE %%%%%
open : stream1, "Instructions.txt", get

loop
    get : stream1, str1 : *
    put str1
    exit when eof (stream1)
end loop

put " "
put "Press any key to continue"
View.Update

getch (a)

newarr
loop
    day += 1
    loop
	draw
	fish
	moveBoat
	checkCollision
	update
	loselives
	winlevel
	exit when r1 >= 1000 or lives = 0
    end loop
    losescreen
    counter += Rand.Int (1, day)
    cls
    r1 := 0
    newarr
    fishyup += Rand.Int (1, 3)
    fishydown -= Rand.Int (1, 3)
    exit when lives = 0
end loop
losescreen

