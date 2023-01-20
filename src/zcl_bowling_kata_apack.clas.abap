CLASS zcl_bowling_kata_apack DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apack_manifest .
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bowling_kata_apack IMPLEMENTATION.

  METHOD constructor.

    if_apack_manifest~descriptor-group_id        = 'pastafahndung.de'.
    if_apack_manifest~descriptor-artifact_id     = 'bowling-kata'.
    if_apack_manifest~descriptor-version         = '0.1.1'.
    if_apack_manifest~descriptor-git_url         = 'https://github.com/Pastafahndung/bowling-kata'.
    if_apack_manifest~descriptor-dependencies    = VALUE #(
      ( group_id    = 'tricktresor.de'
        artifact_id = 'alv-grid-merge-cells'
        git_url     = 'https://github.com/tricktresor/alv-grid-merge-cells' ) ).
    if_apack_manifest~descriptor-repository_type = ``.

  ENDMETHOD.
ENDCLASS.
