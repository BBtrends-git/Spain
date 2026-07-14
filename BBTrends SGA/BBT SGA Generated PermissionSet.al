permissionset 51450 "SGA Permission"
{
    Assignable = true;
    Permissions =
    //*** TABLEDATA ***//
    tabledata "SGA Setup" = RIMD,                       // table 51450
    tabledata "SGA Blocked Documents" = RIMD,           // table 51451
    tabledata "SGA Log Errors" = RIMD,                  // table 51452
    tabledata "SGA Temporal SQL" = RIMD,                // table 51453
    tabledata "SGA Warehouse Line Comment" = RIMD,      // table 51454

    //*** TABLE ***//
    table "SGA Setup" = X,                              // table 51450
    table "SGA Blocked Documents" = X,                  // table 51451
    table "SGA Log Errors" = X,                         // table 51452
    table "SGA Temporal SQL" = X,                       // table 51453
    table "SGA Warehouse Line Comment" = X,             // table 51454

    //*** PAGE  ***//
    page "SGA Setup Card" = X,                          // page 51450
    page "SGA List Blocked Documents" = X,              // page 51451
    page "SGA Log Errors" = X,                          // page 51452
    page "SGA Warehouse Line Comment" = X,              // page 51453

    //*** CODEUNIT ***//
    codeunit "SGA Management" = X,                      // Codeunit 51450
    codeunit "SGA Data Received" = X,                   // Codeunit 51451
    codeunit "SGA Interfaces" = X,                      // Codeunit 51452
    codeunit "SGA Events" = X;                          // Codeunit 51453

    //*** REPORT ***//
    //report "" = X,
    //*** XMLPORT ***//
    //xmlport "" = X,
    //*** QUERY ***//
    //query "" = X;
}