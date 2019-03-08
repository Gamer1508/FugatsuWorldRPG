scope EarthElement initializer Initialization

    globals
        private constant integer TAUNT_ID                   = 'Atau'
        private constant    real TAUNT_DAMAGE_RATIO         = 2
        private constant    real TAUNT_RADIUS               = 300
        private constant  string TAUNT_EFFECT               = "Abilities\\Spells\\Other\\Volcano\\VolcanoDeath.mdl"
        private constant    real TAUNT_EFFECT_COUNT         = 50
        
        private constant    real EARTH_ARMOR_REDUCE_RATIO   = 0.05
    endglobals
    
    globals
        private group TAUNT_ITERATOR = CreateGroup()
    endglobals

    private function onDamage takes nothing returns nothing
        local real Amount
    
        if ItemFunc.has(Damage.target, 'afac') then
            if Damage.type == DAMAGE_TYPE_PHYSICAL then
                set Amount = Damage.amount - (                               /*
                */     I2R(GetHeroStr(Damage.target, true)) *                /*
                */         EARTH_ARMOR_REDUCE_RATIO                          /*
                */ )
                
                if Amount < 0 then
                    set Damage.amount = 1
                else
                    set Damage.amount = Amount
                endif
            endif
        endif
    endfunction

    private function onCast takes nothing returns nothing
        local unit FoG
        local unit Caster
        local real x
        local real y
        local real px
        local real py
        local real r = 0
        local real rAdd = 0
        local integer count = 0

        if GetSpellAbilityId() == TAUNT_ID then
            set Caster = GetTriggerUnit()
            set x = GetUnitX(Caster)
            set y = GetUnitY(Caster)
            set rAdd = 360 / TAUNT_EFFECT_COUNT
            
            loop
                exitwhen count == TAUNT_EFFECT_COUNT
                set r = r + rAdd
                set px = x + TAUNT_RADIUS * Cos(r * bj_DEGTORAD)
                set py = y + TAUNT_RADIUS * Sin(r * bj_DEGTORAD)

                call DestroyEffect(AddSpecialEffect(TAUNT_EFFECT, px, py))
                
                call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "c:  " + R2S(count))


                set count = count + 1
            endloop
            
            call GroupEnumUnitsInRange(TAUNT_ITERATOR, x, y, TAUNT_RADIUS, null)
            
            loop
                set FoG = FirstOfGroup(TAUNT_ITERATOR)
                exitwhen FoG == null
                
                if UnitAlive(FoG) then
                    if IsUnitEnemy(FoG, GetOwningPlayer(Caster)) then
                        call UnitDamageTarget(                               /*
                        */     Caster, FoG,                                  /*
                        */     I2R(GetHeroStr(Caster, true)) *               /*
                        */         TAUNT_DAMAGE_RATIO,                       /*
                        */     false, false,                                 /*
                        */     ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL,       /*
                        */     WEAPON_TYPE_WHOKNOWS                          /*
                        */ )
                    endif
                endif
                
                call GroupRemoveUnit(TAUNT_ITERATOR, FoG)
            endloop
            
            set Caster = null
        endif
    endfunction

    private function Initialization takes nothing returns nothing
        call Damage.registerModifier(function onDamage)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT, function onCast)
    endfunction
endscope
