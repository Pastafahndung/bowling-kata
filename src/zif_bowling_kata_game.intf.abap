INTERFACE zif_bowling_kata_game
  PUBLIC .

  TYPES _score TYPE i.
  TYPES _frames TYPE STANDARD TABLE OF REF TO zif_bowling_kata_frame WITH DEFAULT KEY.

  DATA total_score TYPE _score.
  DATA frames TYPE _frames.

  METHODS add_frame
    IMPORTING
      frame              TYPE REF TO zif_bowling_kata_frame
    RETURNING
      VALUE(total_score) TYPE zif_bowling_kata_game=>_score.

  METHODS get_player_name
    RETURNING
      VALUE(name) TYPE string.

  METHODS get_frames
    RETURNING
      VALUE(frames) TYPE _frames.

  METHODS get_total
    RETURNING
      VALUE(total) TYPE i.

ENDINTERFACE.
