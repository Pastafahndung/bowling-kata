REPORT.
*&---------------------------------------------------------------------*
*& (c) Edwin Leippi Software-Entwicklung                               *
*& Email : info@leippi.de                                              *
*& Datum : 01.03.2008                                                  *
*&                                                                     *
*& Der Autor übernimmt keine Haftung für Schäden,                      *
*& die durch den Einsatz dieses Programmes entstehen können            *
*&---------------------------------------------------------------------*
*& http://www.tricktresor.de
*&---------------------------------------------------------------------*
*REPORT  zz_alv_merge_cells.

" https://www.bvkaiserslautern.de/wissenswertes/bowling_zaehlweise.html
" https://www.bowlinggenius.com/
" https://www.codurance.com/katalyst/bowling
" https://ccd-school.de/coding-dojo/class-katas/bowling/

PARAMETERS clsgame  TYPE seoclsname DEFAULT 'ZCL_BOWLING_KATA_GAME'.
PARAMETERS clsframe TYPE seoclsname DEFAULT 'ZCL_BOWLING_KATA_FRAME'.


INITIALIZATION.

** Objekte instanzieren und zuordnen: Grid
  DATA(docker)   = NEW cl_gui_docking_container( side = cl_gui_docking_container=>dock_at_bottom ratio = 90 ).
  DATA(splitter) = NEW cl_gui_splitter_container( parent = docker rows = 2 columns = 1 ).

  DATA(text_container) = splitter->get_container( column = 1 row = 1 ).
  DATA(score_container) = splitter->get_container( column = 1 row = 2 ).

  DATA(text) = NEW cl_gui_textedit( parent = text_container ).
  text->set_toolbar_mode( 0 ).
  text->set_statusbar_mode( 0 ).

  DATA game TYPE REF TO zif_bowling_kata_game.
  DATA(scoreboard) = NEW zcl_bowling_kata_scoreboard( score_container ).

  text->set_textstream(
    '1,4' && cl_abap_char_utilities=>cr_lf &&
    `4,5` && cl_abap_char_utilities=>cr_lf &&
    `6,4` && cl_abap_char_utilities=>cr_lf &&
    `5,5` && cl_abap_char_utilities=>cr_lf &&
    `10`  && cl_abap_char_utilities=>cr_lf &&
    `0,1` && cl_abap_char_utilities=>cr_lf &&
    `7,3` && cl_abap_char_utilities=>cr_lf &&
    `6,4` && cl_abap_char_utilities=>cr_lf &&
    `10`  && cl_abap_char_utilities=>cr_lf &&
    `2,8,6` && cl_abap_char_utilities=>cr_lf  ).

AT SELECTION-SCREEN.
  TRY.
      DATA(cls) = NEW cl_oo_class( clsgame ).
      DATA(intf) = cls->get_implemented_interfaces( ).
      IF NOT line_exists( intf[ refclsname = 'ZIF_BOWLING_KATA_GAME' ] ).
        MESSAGE 'Class does not implement interface ZIF_BOWLING_KATA_GAME' TYPE 'E'.
      ENDIF.
      cls = NEW cl_oo_class( clsframe ).
      intf = cls->get_implemented_interfaces( ).
      IF NOT line_exists( intf[ refclsname = 'ZIF_BOWLING_KATA_FRAME' ] ).
        MESSAGE 'Class does not implement interface ZIF_BOWLING_KATA_FRAME' TYPE 'E'.
      ENDIF.
    CATCH cx_class_not_existent INTO DATA(class_not_existent).
      MESSAGE class_not_existent TYPE 'E'.
  ENDTRY.

  CREATE OBJECT game TYPE (clsgame).

  DATA frame  TYPE REF TO zif_bowling_kata_frame.
  DATA previous_frame  TYPE REF TO zif_bowling_kata_frame.

  text->get_textstream(
    IMPORTING
      text = DATA(bowling_results) ).
  cl_gui_cfw=>flush( ).

  SPLIT bowling_results AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(frames).

  DATA number_of_frames TYPE i.

  LOOP AT frames INTO DATA(frame_result).
    ADD 1 TO number_of_frames.
    SPLIT frame_result AT ',' INTO
      DATA(first_roll)
      DATA(second_roll)
      DATA(third_roll).
    CREATE OBJECT frame TYPE (clsframe).
    frame->set_previous_frame( previous_frame ).
    frame->add_roll( CONV #( first_roll ) ).
    frame->add_roll( CONV #( second_roll ) ).
    IF number_of_frames = 10.
      frame->add_roll( CONV #( third_roll ) ).
    ENDIF.
    game->add_frame( frame ).
    previous_frame = frame.
  ENDLOOP.


  scoreboard->display( game = game ).
