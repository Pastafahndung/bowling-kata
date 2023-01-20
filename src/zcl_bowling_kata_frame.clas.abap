CLASS zcl_bowling_kata_frame DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_bowling_kata_frame.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA previous_frame TYPE REF TO zif_bowling_kata_frame.
    DATA is_spare TYPE abap_bool.
    DATA is_strike TYPE abap_bool.
ENDCLASS.



CLASS zcl_bowling_kata_frame IMPLEMENTATION.
  METHOD zif_bowling_kata_frame~add_roll.

    IF zif_bowling_kata_frame~is_strike( ) AND roll = 0.
      RETURN.
    ENDIF.

    IF lines( zif_bowling_kata_frame~rolls ) < 2.
      IF previous_frame IS BOUND.
        IF previous_frame->is_strike( ).
          "STRIKE: all rolls score double
          ADD roll TO previous_frame->score.
        ELSEIF previous_frame->is_spare( )
          AND lines( zif_bowling_kata_frame~rolls ) = 0.
          "SPARE: first roll scores double
          ADD roll TO previous_frame->score.
        ENDIF.
      ENDIF.
    ENDIF.

    ADD roll TO zif_bowling_kata_frame~score.

    APPEND roll TO zif_bowling_kata_frame~rolls.

    IF lines( zif_bowling_kata_frame~rolls ) = 1 AND roll = 10.
      is_strike = abap_true.
    ELSEIF REDUCE i( INIT total = 0 FOR score IN zif_bowling_kata_frame~rolls NEXT total = total + score ) = 10.
      is_spare = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD zif_bowling_kata_frame~get_rolls.
    rolls = zif_bowling_kata_frame~rolls.
  ENDMETHOD.

  METHOD zif_bowling_kata_frame~is_spare.
*    IF lines( zif_bowling_kata_frame~rolls ) = 2
*    AND REDUCE i( INIT total = 0 FOR score IN zif_bowling_kata_frame~rolls NEXT total = total + score ) = 10 .
*      result = abap_true.
*    ENDIF.
    result = is_spare.
  ENDMETHOD.

  METHOD zif_bowling_kata_frame~is_strike.
*    IF  zif_bowling_kata_frame~rolls IS NOT INITIAL
*    AND zif_bowling_kata_frame~rolls[ 1 ] = 10.
*      result = abap_true.
*    ENDIF.
    result = is_strike.
  ENDMETHOD.

  METHOD zif_bowling_kata_frame~set_previous_frame.
    me->previous_frame = frame.
  ENDMETHOD.

ENDCLASS.
