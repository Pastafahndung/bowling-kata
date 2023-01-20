CLASS zcl_bowling_kata_scoreboard DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    TYPES: BEGIN OF ts_score,
             name(20),     "01
             frame01_1(3), "02
             frame01_2(3), "03
             frame02_1(3), "04
             frame02_2(3), "05
             frame03_1(3), "06
             frame03_2(3), "07
             frame04_1(3), "08
             frame04_2(3), "09
             frame05_1(3), "10
             frame05_2(3), "11
             frame06_1(3), "12
             frame06_2(3), "13
             frame07_1(3), "14
             frame07_2(3), "15
             frame08_1(3), "16
             frame08_2(3), "17
             frame09_1(3), "18
             frame09_2(3), "19
             frame10_1(3), "20
             frame10_2(3), "21
             frame10_3(3), "22
             total(10),    "23
           END OF ts_score,
           tt_scores TYPE STANDARD TABLE OF ts_score WITH DEFAULT KEY.

    DATA score_board TYPE tt_scores.

    METHODS constructor
      IMPORTING
        container TYPE REF TO cl_gui_container.

    METHODS display
      IMPORTING
        game TYPE REF TO zif_bowling_kata_game.


  PROTECTED SECTION.



  PRIVATE SECTION.
    DATA alv_grid  TYPE REF TO ztrcktrsr_gui_alv_grid_merge.
    DATA game      TYPE REF TO zif_bowling_kata_game.
    DATA container TYPE REF TO cl_gui_container.

    METHODS get_fieldcat
      RETURNING
        VALUE(fieldcatalog) TYPE lvc_t_fcat.

    METHODS set_scores.

    METHODS create_grid.

    METHODS set_merge_layout.

ENDCLASS.



CLASS zcl_bowling_kata_scoreboard IMPLEMENTATION.
  METHOD display.

    me->game = game.
    set_scores( ).
    alv_grid->refresh_table_display( ).
    set_merge_layout( ).

  ENDMETHOD.

  METHOD get_fieldcat.
    fieldcatalog = VALUE #(
      tabname = '1' datatype = 'CHAR' inttype = 'C'
      ( fieldname = 'NAME'      intlen = 20 outputlen = 20 )
      ( fieldname = 'FRAME01_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME01_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME02_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME02_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME03_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME03_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME04_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME04_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME05_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME05_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME06_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME06_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME07_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME07_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME08_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME08_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME09_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME09_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME10_1' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME10_2' intlen = 3 outputlen = 4 )
      ( fieldname = 'FRAME10_3' intlen = 3 outputlen = 4 )
      ( fieldname = 'TOTAL'     intlen = 3 outputlen = 10 ) ).

  ENDMETHOD.

  METHOD set_scores.

    DATA(frames) = game->get_frames( ).

    score_board = VALUE #(
      "columns description
      ( name      = 'Frame'
        frame01_1 = 1
        frame02_1 = 2
        frame03_1 = 3
        frame04_1 = 4
        frame05_1 = 5
        frame06_1 = 6
        frame07_1 = 7
        frame08_1 = 8
        frame09_1 = 9
        frame10_1 = 10
        total     = 'Total' ) ).

    DATA(frame_scores) = VALUE ts_score(
        name      = game->get_player_name( )
        total     = game->total_score ).

    DATA(total_scores) = VALUE ts_score( ).
    DATA total_score TYPE i.

    LOOP AT frames INTO DATA(frame).
      DATA(column) = |FRAME{ sy-tabix WIDTH = 2 PAD = '0' ALIGN = RIGHT }_|.
      DATA(column1) = |{ column }1|.
      DATA(column2) = |{ column }2|.
      DATA(column3) = |{ column }3|.
      DATA(rolls) = frame->get_rolls( ).
      ASSIGN COMPONENT column1 OF STRUCTURE frame_scores TO FIELD-SYMBOL(<score1>).
      ASSIGN COMPONENT column2 OF STRUCTURE frame_scores TO FIELD-SYMBOL(<score2>).
      CASE lines( rolls ).
        WHEN 1.
          <score1> = COND #( WHEN frame->is_strike( ) THEN ' ' ELSE rolls[ 1 ] ).
          <score2> = COND #( WHEN frame->is_strike( ) THEN 'X' ELSE rolls[ 1 ] ).
        WHEN 2.
          <score1> = rolls[ 1 ].
          <score2> = COND #( WHEN frame->is_spare( ) THEN '/' ELSE rolls[ 2 ] ).
        WHEN 3.
          ASSIGN COMPONENT column3 OF STRUCTURE frame_scores TO FIELD-SYMBOL(<score3>).
          <score1> = rolls[ 1 ].
          <score2> = COND #( WHEN frame->is_spare( ) THEN '/' ELSE rolls[ 2 ] ).
          <score3> = rolls[ 3 ].
      ENDCASE.

      ASSIGN COMPONENT column1 OF STRUCTURE total_scores TO FIELD-SYMBOL(<total>).

      total_score = total_score + frame->score.
      <total> = total_score.

    ENDLOOP.

    frame_scores-total = total_Score.

    APPEND frame_scores TO score_board.
    APPEND total_scores TO score_board.

  ENDMETHOD.

  METHOD constructor.
    me->container = container.
    create_grid( ).
  ENDMETHOD.

  METHOD create_grid.

    alv_grid = NEW #( container ).

    DATA(layout) = VALUE lvc_s_layo(
      no_headers = 'X'
      cwidth_opt = ' '
      no_toolbar = 'X' ).

    DATA(variant) = VALUE disvariant( ).
    DATA(fieldcatalog) = get_fieldcat( ).

    alv_grid->set_table_for_first_display(
      EXPORTING
        is_variant      = variant
        is_layout       = layout
      CHANGING
        it_fieldcatalog = fieldcatalog
        it_outtab       = score_board ).

  ENDMETHOD.


  METHOD set_merge_layout.

*  " merge name column (line 2 + 3)
*  alv_grid->z_set_merge_vert(
*      row           = 2
*      tab_col_merge =  VALUE #(
*         ( col_id    = 1 outputlen = 2 ) ) ). "DOES NOT WORK: 1st SCORE "7" will not be displayed :(

    alv_grid->z_set_merge_vert(
        row           = 2
        tab_col_merge =  VALUE #(
           ( col_id    = 23 outputlen = 24 ) ) ).


    " Horizontal verbinden
    alv_grid->z_set_merge_horiz(
        row           = 1
        tab_col_merge = VALUE #(
          ( col_id    = 2  outputlen = 3 )
          ( col_id    = 4  outputlen = 5 )
          ( col_id    = 6  outputlen = 7 )
          ( col_id    = 8  outputlen = 9 )
          ( col_id    = 10 outputlen = 11 )
          ( col_id    = 12 outputlen = 13 )
          ( col_id    = 14 outputlen = 15 )
          ( col_id    = 16 outputlen = 17 )
          ( col_id    = 18 outputlen = 19 )
          ( col_id    = 20 outputlen = 22 )
          ) ).

    alv_grid->z_set_merge_horiz(
        row           = 3
        tab_col_merge = VALUE #(
          ( col_id    = 2  outputlen = 3 )
          ( col_id    = 4  outputlen = 5 )
          ( col_id    = 6  outputlen = 7 )
          ( col_id    = 8  outputlen = 9 )
          ( col_id    = 10 outputlen = 11 )
          ( col_id    = 12 outputlen = 13 )
          ( col_id    = 14 outputlen = 15 )
          ( col_id    = 16 outputlen = 17 )
          ( col_id    = 18 outputlen = 19 )
          ( col_id    = 20 outputlen = 22 )
          ) ).


    alv_grid->z_set_cell_style(
        row   = 1
        col   = 1
        style = CONV #( alv_style_font_bold
                + alv_style_align_center_center
                + alv_style_color_int_heading ) ).

    "set style for header line
    DATA(modify_col) = 2.
    DATA(color_header) = alv_style_color_int_heading.
    DO 10 TIMES.
      color_header = COND #( WHEN color_header = alv_style_color_int_heading THEN alv_style_color_heading ELSE alv_style_color_int_heading ).

      alv_grid->z_set_cell_style(
          row   = 1
          col   = modify_col
          style = CONV #( alv_style_font_bold
                  + alv_style_align_center_center
                  + color_header ) ).
      ADD 2 TO modify_col.
    ENDDO.

    "center score line
    modify_col = 2.
    DO 20 TIMES.
      alv_grid->z_set_cell_style(
          row   = 2
          col   = modify_col
          style = alv_style_align_center_center ).
      ADD 1 TO modify_col.
    ENDDO.

    "set style for totals line (center + bold)
    modify_col = 2.
    DO 10 TIMES.
      alv_grid->z_set_cell_style(
          row   = 3
          col   = modify_col
          style = CONV #( alv_style_font_bold
                  + alv_style_align_center_center ) ).
      ADD 2 TO modify_col.
    ENDDO.

    "set style for totals column
    alv_grid->z_set_cell_style(
        row   = 1
        col   = 23
        style = CONV #( alv_style_font_bold
                + alv_style_align_center_center
                + alv_style_color_int_total ) ).
    alv_grid->z_set_cell_style(
        row   = 2
        col   = 23
        style = CONV #( alv_style_font_bold
                + alv_style_align_center_center
                + alv_style_color_int_total ) ).
    alv_grid->z_set_cell_style(
        row   = 3
        col   = 23
        style = CONV #( alv_style_font_bold
                + alv_style_align_center_center
                + alv_style_color_int_total ) ).


*  alv_grid->z_set_fixed_col_row(
*      col = 3
*      row = 3 ).

    alv_grid->z_display( ).

  ENDMETHOD.

ENDCLASS.
