//! textmacro QuestDialogInit
    call Add( /*
    *      Title
    */     "Commands", /*
    *
    *      Description
    */     "These commands work for all players." + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00-killme|r" + "\r\n" + /*
    */         "It used to kill your characters for whatever reason." + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00-zoom [Number of Distance]|r" + "\r\n" + /*
    */         "It used to set your camera distance." + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00-roll [Number]|r" + "\r\n" + /*
    */         "It used to make a random number for whatever reason." + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00-give [slot]|r" + "\r\n" + /*
    */         "It used to give the specific slot from your character's inventory to your bag." +/*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00-get [slot]|r" + "\r\n" + /*
    */         "It used to get the specific slot from your bag's inventory to your character.", /*
    *
    *      Icon
    */     "ReplaceableTextures\\CommandButtons\\BTNSorceressMaster.blp", /*
    *
    *      Left Dialog?
    */     true /*
    */ )

    call Add( /*
    *      Title
    */     "Fish Crafting", /*
    *
    *      Description
    */     "If you are at Land 2 area and you need to summon a Land 2 Raid Boss, you need to combine 2 fishes:" + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00Bubble Fish|r" + "\r\n" + /*
    */         "Skull Fish + Green Fish" + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00Black Fish|r" + "\r\n" + /*
    */         "Green Fish + Transparent Fish" + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00Flame Fish|r" + "\r\n" + /*
    */         "Shine Fish + Lightning Fish" + /*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00Cacarot Fish|r" + "\r\n" + /*
    */         "2-Headed Fish + Freeze Fish" +/*
    */         "\r\n\r\n" + /*
    */         "|cffffcc00Royal Fish|r" + "\r\n" + /*
    */         "2-Headed Fish + Green Fish", /*
    *
    *      Icon
    */     "ReplaceableTextures\\CommandButtons\\BTNSorceressMaster.blp", /*
    *
    *      Left Side?
    */     false /*
    */ )
//! endtextmacro

scope F9 initializer Initialization
    private function Add takes string title, string description, string iconPath, boolean leftSide returns nothing
        local quest Quest = CreateQuest()
        
        call QuestSetTitle(Quest, title)
        call QuestSetDescription(Quest, description)
        call QuestSetIconPath(Quest, iconPath)
        call QuestSetRequired(Quest, leftSide)

        set Quest = null
    endfunction

    private function Initialization takes nothing returns nothing
        //! runtextmacro QuestDialogInit()
    endfunction
endscope
