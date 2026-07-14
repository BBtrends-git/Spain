permissionset 51351 "BBT SRM Permission"
{
    Assignable = true;
    Permissions =
    //*** TABLEDATA ***//
    tabledata "SRM Setup" = RIMD,                       // 51351
    tabledata "SRM Vendor Classification" = RIMD,       // 51252
    tabledata "SRM Evaluation Manager" = RIMD,          // 51253
    tabledata "SRM Vendor Item Categories" = RIMD,      // 51254
    //*** TABLE ***//
    table "SRM Setup" = X,                              // 51351
    table "SRM Vendor Classification" = X,              // 51352
    table "SRM Evaluation Manager" = X,                 // 51253
    table "SRM Vendor Item Categories" = X,             // 51254
    //*** PAGE  ***//
    page "SRM Setup Card" = X,                          // 51351 
    page "SRM Vendor Classification" = X,               // 51352
    page "SRM Evaluation Manager" = X,                  // 51353
    page "SRM Vendor Comments" = X,                     // 51354
    page "SRM Vendor Item Categories" = X,              // 51355     
    //*** CODEUNIT ***//
    codeunit "SRM Management" = X;                     // 51351
    //*** REPORT ***//
    //report "SRM " = X,
    //*** XMLPORT ***//
    //xmlport "SRM " = X,
    //*** QUERY ***//
    //query "SRM " = X;                             // 51351
}