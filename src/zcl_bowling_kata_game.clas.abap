CLASS zcl_bowling_kata_game DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_bowling_kata_game .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bowling_kata_game IMPLEMENTATION.
  METHOD zif_bowling_kata_game~add_frame.

    APPEND frame TO zif_bowling_kata_game~frames.
    IF lines( zif_bowling_kata_game~frames ) = 10.
      frame->last_frame = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD zif_bowling_kata_game~get_frames.

    frames = zif_bowling_kata_game~frames.

  ENDMETHOD.

  METHOD zif_bowling_kata_game~get_player_name.

    name = 'Demo Solution'.

  ENDMETHOD.

  METHOD zif_bowling_kata_game~get_total.

    zif_bowling_kata_game~total_score = 0.

    LOOP AT zif_bowling_kata_game~frames INTO DATA(frame).
      ADD frame->score TO zif_bowling_kata_game~total_score.
    ENDLOOP.

    total = zif_bowling_kata_game~total_score.

  ENDMETHOD.

ENDCLASS.
