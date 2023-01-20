CLASS ltcl_games DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS game133 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_games IMPLEMENTATION.

  METHOD game133.

    TYPES: BEGIN OF _frame,
             nr     TYPE i,
             first  TYPE i,
             second TYPE i,
             third  TYPE i,
             exp_total type i,
           END OF _frame,
           _frames TYPE STANDARD TABLE OF _frame WITH DEFAULT KEY.

    DATA game TYPE REF TO zif_bowling_kata_game.
    DATA frame TYPE REF TO zif_bowling_kata_frame.
    DATA previous_frame TYPE REF TO zif_bowling_kata_frame.

    game = NEW zcl_bowling_kata_game( ).

    LOOP AT VALUE _frames(
       ( nr =  1 exp_total =   5 first =  1 second = 4 )
       ( nr =  2 exp_total =  14 first =  4 second = 5 )
       ( nr =  3 exp_total =  24 first =  6 second = 4 )
       ( nr =  4 exp_total =  39 first =  5 second = 5 )
       ( nr =  5 exp_total =  59 first = 10  )
       ( nr =  6 exp_total =  61 first =  0 second = 1 )
       ( nr =  7 exp_total =  71 first =  7 second = 3 )
       ( nr =  8 exp_total =  87 first =  6 second = 4 )
       ( nr =  9 exp_total = 107 first = 10   )
       ( nr = 10 exp_total = 133 first =  2 second = 8 third = 6 ) )
      INTO DATA(frame_result).

      CREATE OBJECT frame TYPE zcl_bowling_kata_frame.
      frame->set_previous_frame( previous_frame ).
      frame->add_roll( frame_result-first ).
      frame->add_roll( frame_result-second ).
      IF frame_result-nr = 10.
        frame->add_roll( frame_result-third ).
      ENDIF.
      game->add_frame( frame ).

      cl_abap_unit_assert=>assert_equals(
        msg = |result of frame { frame_result-nr } unexpected|
        exp = frame_Result-exp_total
        act = game->get_total( ) ).

      previous_frame = frame.
    ENDLOOP.

    cl_abap_unit_assert=>assert_equals( exp = 133 act = game->get_total( ) ).

  ENDMETHOD.

ENDCLASS.
