CLASS ltcl_bowling_frame DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zif_bowling_kata_frame.
    METHODS setup.
    METHODS first_roll FOR TESTING.
    METHODS second_roll FOR TESTING.
    METHODS spare FOR TESTING.
    METHODS strike FOR TESTING.
ENDCLASS.


CLASS ltcl_bowling_frame IMPLEMENTATION.

  METHOD first_roll.
    cut->add_roll( 8 ).
    cl_abap_unit_assert=>assert_equals(
        act = cut->score
        exp = 8 ).
  ENDMETHOD.

  METHOD second_roll.
    cut->add_roll( 5 ).
    cut->add_roll( 3 ).

    cl_abap_unit_assert=>assert_equals(
        act = cut->score
        exp = 8 ).

  ENDMETHOD.

  METHOD setup.
    cut = NEW zcl_bowling_kata_frame( ).
  ENDMETHOD.

  METHOD spare.
    cut->add_roll( 8 ).
    cut->add_roll( 2 ).
    cl_abap_unit_assert=>assert_equals(
        act = cut->score
        exp = 10 ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true act = cut->is_spare( ) ).
    cl_abap_unit_assert=>assert_equals( exp = abap_false act = cut->is_strike( ) ).

    DATA(second_frame) = CAST zif_bowling_kata_frame( NEW zcl_bowling_kata_frame( ) ).
    second_frame->set_previous_frame( cut ).
    second_frame->add_roll( 5 ).
    second_frame->add_roll( 3 ).

    cl_abap_unit_assert=>assert_equals(
        act = second_frame->score
        exp = 8 ).

  ENDMETHOD.

  METHOD strike.
    cut->add_roll( 10 ).
    cl_abap_unit_assert=>assert_equals(
        act = cut->score
        exp = 10 ).
    cl_abap_unit_assert=>assert_true( act = cut->is_strike( ) ).

    DATA(second_frame) = CAST zif_bowling_kata_frame( NEW zcl_bowling_kata_frame( ) ).
    second_frame->set_previous_frame( cut ).
    second_frame->add_roll( 5 ).
    second_frame->add_roll( 3 ).

    cl_abap_unit_assert=>assert_equals(
        act = cut->score
        exp = 18 ).

    cl_abap_unit_assert=>assert_equals(
        act = second_frame->score
        exp = 8 ).

  ENDMETHOD.


ENDCLASS.
