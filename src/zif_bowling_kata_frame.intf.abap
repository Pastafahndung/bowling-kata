INTERFACE zif_bowling_kata_frame
  PUBLIC .
  TYPES _rolls TYPE STANDARD TABLE OF zif_bowling_kata_game=>_score WITH DEFAULT KEY.

  DATA score TYPE zif_bowling_kata_game=>_score.
  DATA rolls TYPE _rolls.
  DATA last_frame TYPE abap_bool.

  METHODS set_previous_frame
    IMPORTING
      frame TYPE REF TO zif_bowling_kata_frame.

  METHODS add_roll
    IMPORTING
      roll TYPE zif_bowling_kata_game=>_score.

  METHODS is_spare
    RETURNING
      VALUE(result) TYPE abap_bool.

  METHODS is_strike
    RETURNING
      VALUE(result) TYPE abap_bool.

  METHODS get_rolls
    RETURNING
      VALUE(rolls) TYPE _rolls.

ENDINTERFACE.
