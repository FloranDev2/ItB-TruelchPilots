LOG("------------------------ HERE animations!")

--V2 (b): is a perfect circle, more like an screen indicator
ANIMS.truelch_mark_board_b_0 = Animation:new{
	Image = "combat/icons/truelch_mark_board_b_0.png",
	PosX = -15,
	PosY = 6,
	Time = 0.01, --0.08
	Loop = false,
	NumFrames = 1,
}

ANIMS.truelch_mark_board_b_1 = ANIMS.truelch_mark_board_b_0:new{
	Image = "combat/icons/truelch_mark_board_b_1.png",
}

ANIMS.truelch_mark_board_b_2 = ANIMS.truelch_mark_board_b_0:new{
	Image = "combat/icons/truelch_mark_board_b_2.png",
}

--New: complete anim
ANIMS.truelch_mark_board_c = Animation:new{
	Image = "combat/icons/truelch_mark_board_c.png",
	PosX = -15,
	PosY = 6,
	Time = 0.24, --0.08
	Loop = true,
	NumFrames = 3,
}

--V3 (c): smaller V2
ANIMS.truelch_mark_board_c_0 = Animation:new{
	Image = "combat/icons/truelch_mark_board_c_0.png",
	PosX = -15,
	PosY = 6,
	Time = 0.01, --0.08
	Loop = false,
	NumFrames = 1,
}

ANIMS.truelch_mark_board_c_1 = ANIMS.truelch_mark_board_c_0:new{
	Image = "combat/icons/truelch_mark_board_c_1.png",
}

ANIMS.truelch_mark_board_c_2 = ANIMS.truelch_mark_board_c_0:new{
	Image = "combat/icons/truelch_mark_board_c_2.png",
}

---Tmp versions

--Big yellow
ANIMS.truelch_tmp_mark_board_b_0 = Animation:new{
	Image = "combat/icons/truelch_tmp_mark_board_b_0.png",
	PosX = -15,
	PosY = 6,
	Time = 0.01, --0.08
	Loop = false,
	NumFrames = 1,
}

ANIMS.truelch_tmp_mark_board_b_1 = ANIMS.truelch_mark_board_b_0:new{
	Image = "combat/icons/truelch_tmp_mark_board_b_1.png",
}

ANIMS.truelch_tmp_mark_board_b_2 = ANIMS.truelch_mark_board_b_0:new{
	Image = "combat/icons/truelch_tmp_mark_board_b_2.png",
}

--Small yellow
ANIMS.truelch_tmp_mark_board_c_0 = Animation:new{
	Image = "combat/icons/truelch_tmp_mark_board_c_0.png",
	PosX = -15,
	PosY = 6,
	Time = 0.01, --0.08
	Loop = false,
	NumFrames = 1,
}

ANIMS.truelch_mark_board_c_1 = ANIMS.truelch_mark_board_c_0:new{
	Image = "combat/icons/truelch_mark_board_c_1.png",
}

ANIMS.truelch_mark_board_c_2 = ANIMS.truelch_mark_board_c_0:new{
	Image = "combat/icons/truelch_mark_board_c_2.png",
}

---"Real" animations, used for tip image
ANIMS.truelch_tip_mark_medium = Animation:new{
	Image = "combat/icons/truelch_mark_board_c.png",
	PosX = -15,
	PosY = 6,
	Time = 0.2,
	NumFrames = 3,
	--This is stupid and there got to be a better way to do this, right?
	Frames = { 
		0,1,2, --1
		0,1,2, --2
		0,1,2, --3
		0,1,2, --4
		0,1,2, --5
		0,1,2, --6
		0,1,2, --7
		0,1,2, --8
		0,1,2, --9
		0,1,2, --10
		--0,1,2, --11
		--0,1,2, --12
		--0,1,2, --13
		--0,1,2, --14
	},
}

ANIMS.truelch_tip_mark_short = Animation:new{
	Image = "combat/icons/truelch_mark_board_c.png",
	PosX = -15,
	PosY = 6,
	Time = 0.2,
	NumFrames = 3,
	--This is stupid and there got to be a better way to do this, right?
	Frames = { 
		0,1,2, --1
		0,1,2, --2
		0,1,2, --3
		0,1,2, --4
		0,1,2, --5
		0,1,2, --6
	},
}

--Used for the two click like the Airship's attack
ANIMS.truelch_tip_mark_long = Animation:new{
	Image = "combat/icons/truelch_mark_board_c.png",
	PosX = -15,
	PosY = 6,
	Time = 0.2,
	NumFrames = 3,
	--This is stupid and there got to be a better way to do this, right?
	Frames = { 
		0,1,2, --1
		0,1,2, --2
		0,1,2, --3
		0,1,2, --4
		0,1,2, --5
		0,1,2, --6
		0,1,2, --7
		0,1,2, --8
		0,1,2, --9
		0,1,2, --10
		0,1,2, --11
		0,1,2, --12
		0,1,2, --13
		0,1,2, --14
	},
}