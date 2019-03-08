scope LightElement initializer Initialization /* v1.0.0.0
*************************************************************************************
*
*    LIGHT ELEMENT
*
************************************************************************************


     requires
 
         TimerUtils,
         RegisterPlayerUnitEvent,
         Alloc,
         DamageEvent,
         ItemFunc 


*************************************************************************************
*
*    HOLY SMITE
*
************************************************************************************
*
*   HOLY SMITE CONFIGURATION
*
*/
    globals
        private constant string HOLYSMITE_EFFECT = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl"
    endglobals
/*
***********************************************************************************/

    native UnitAlive takes unit id returns boolean
    
    globals
        private trigger HOLYSMITE_TRIGGER  = CreateTrigger()
        private   group HOLYSMITE_ITERATOR = CreateGroup()
    endglobals

    private function onDamage takes nothing returns boolean
        local unit FoG
        local real x
        local real y
    
        if  ItemFunc.has(Damage.source, 'I00R') or /* I
        */  ItemFunc.has(Damage.source, 'I0A4') or /* II
        */  ItemFunc.has(Damage.source, 'I0A6')    /* III
        */ then
            if GetRandomReal(0, 100) <= 35 then
                set x = GetUnitX(Damage.target)
                set y = GetUnitY(Damage.target)

                call GroupEnumUnitsInRange(HOLYSMITE_ITERATOR, x, y, 300, null)
                call DestroyEffect(AddSpecialEffect(HOLYSMITE_EFFECT, x, y))
                    
                loop
                    set FoG = FirstOfGroup(HOLYSMITE_ITERATOR)
                    exitwhen FoG == null
                        
                    if /*
                    *
                    */     FoG != Damage.source and                          /*
                    */     GetUnitAbilityLevel(FoG,'Avul') == 0 and          /*
                    */     GetUnitAbilityLevel(FoG,'Bvul') == 0 and          /*
                    */     IsUnitEnemy(FoG, GetOwningPlayer(Damage.source))  /*
                    *
                    */  then

                        call DisableTrigger(HOLYSMITE_TRIGGER)
                        call UnitDamageTarget(                               /*
                        */     Damage.source, FoG,                           /*
                        */     I2R(GetHeroStr(Damage.source, true)) * 1,     /*
                        */     false, false,                                 /*
                        */     ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL,       /*
                        */     WEAPON_TYPE_WHOKNOWS                          /*
                        */ )
                        call EnableTrigger(HOLYSMITE_TRIGGER)
                    endif
                        
                    call GroupRemoveUnit(HOLYSMITE_ITERATOR, FoG)
                endloop
            endif
        endif
        
        return false
    endfunction

    private function Initialization takes nothing returns nothing
        call Damage.registerTrigger(HOLYSMITE_TRIGGER)
        call TriggerAddCondition(HOLYSMITE_TRIGGER, Condition(function onDamage))
    endfunction
    
/************************************************************************************
*
*    LIGHT ERUPTION
*
************************************************************************************
*
*   LIGHT ERUPTION CONFIGURATION
*
*/
    globals
        private constant integer LIGHT_ERUPTION_ID            = 'A000'
        private constant    real LIGHT_ERUPTION_PERCENT_DMG   = 0.10
        private constant    real LIGHT_ERUPTION_PERCENT_HEAL  = 0.10
        private constant    real LIGHT_ERUPTION_RADIUS        = 500

        private constant  string LIGHT_ERUPTION_EFFECT_CAST   = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
        private constant  string LIGHT_ERUPTION_EFFECT_TARGET = "war3mapImported\\Mskill06A.mdx"

        private constant    real LIGHT_ERUPTION_INSTANCE      = 100
        private constant    real LIGHT_ERUPTION_REFRESH_RATE  = 0.05
    endglobals
/*
***********************************************************************************/

    globals
        private group LIGHT_ERUPTION_ITERATOR = CreateGroup()
    endglobals

    private struct LIGHT_ERRUPTION extends array
        implement Alloc

        private    unit Caster
        private  effect Effect
        private   timer Timer
        private    real Instance
        private    real TargetX
        private    real TargetY

        private static method onLoop takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            local unit FoG
            
            if this.Instance <= 0 then
                call DestroyEffect(this.Effect)
                call ReleaseTimer(this.Timer)
                
                set this.TargetX  = 0
                set this.TargetY  = 0
                set this.Caster   = null
                set this.Effect   = null
                set this.Instance = 0
                set this.Timer    = null
                
                call this.deallocate()
            else
                set this.Instance = this.Instance - 1
                
                call GroupEnumUnitsInRange(LIGHT_ERUPTION_ITERATOR,         /*
                */     this.TargetX, this.TargetY, LIGHT_ERUPTION_RADIUS,   /*
                */     null                                                 /*
                */ )
                
                loop
                    set FoG = FirstOfGroup(LIGHT_ERUPTION_ITERATOR)
                    exitwhen FoG == null
                    
                    if UnitAlive(FoG) then
                        if IsUnitEnemy(FoG, GetOwningPlayer(this.Caster)) then
                            call UnitDamageTarget(                          /*
                            */     this.Caster, FoG,                        /*
                            */     I2R(GetHeroStr(this.Caster, true)) *     /*
                            */         LIGHT_ERUPTION_PERCENT_DMG,          /*
                            */     false, false,                            /*
                            */     ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL,  /*
                            */     WEAPON_TYPE_WHOKNOWS                     /*
                            */ )
                        else
                            call SetUnitState(FoG, UNIT_STATE_LIFE,         /*
                            */     GetUnitState(FoG, UNIT_STATE_LIFE) +     /*
                            */     (I2R(GetHeroStr(this.Caster, true)) *    /*
                            */         LIGHT_ERUPTION_PERCENT_DMG)          /*
                            */ )
                        endif
                    endif
                    
                    call GroupRemoveUnit(LIGHT_ERUPTION_ITERATOR, FoG)
                endloop
            endif
        endmethod

        private static method onCast takes nothing returns nothing
            local thistype this
        
            if GetSpellAbilityId() == LIGHT_ERUPTION_ID then
                set this = thistype.allocate()
                
                set this.TargetX = GetSpellTargetX()
                set this.TargetY = GetSpellTargetY()
                set this.Caster = GetTriggerUnit()
                set this.Effect = AddSpecialEffect(                         /*
                */     LIGHT_ERUPTION_EFFECT_TARGET,                        /*
                */     this.TargetX, this.TargetY                           /*
                */ )
                call DestroyEffect(AddSpecialEffect(                        /*
                */     LIGHT_ERUPTION_EFFECT_CAST,                          /*
                */     this.TargetX, this.TargetY                           /*
                */ ))
                
                set this.Instance = LIGHT_ERUPTION_INSTANCE
                set this.Timer = NewTimerEx(this)
                
                call TimerStart(this.Timer, LIGHT_ERUPTION_REFRESH_RATE, true, function thistype.onLoop)
            endif
        endmethod
    
        private static method onInit takes nothing returns nothing
            call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT, function thistype.onCast)
        endmethod
    endstruct
endscope
