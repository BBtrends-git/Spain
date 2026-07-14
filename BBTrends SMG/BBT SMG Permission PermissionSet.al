permissionset 51300 "BBT SMG Permission"
{
    Assignable = true;
    Permissions =
    //*** TABLEDATA ***//
    tabledata "SMG Setup" = RIMD,                                       // 51300
    tabledata "SMG Customer Classification" = RIMD,                     // 51301
    tabledata "SMG COLS Conditions" = RIMD,                             // 51302
    tabledata "SMG APOS Conditions" = RIMD,                             // 51303
    tabledata "SMG Sales Discounts" = RIMD,                             // 51304
    tabledata "SMG Historical Values Margin" = RIMD,                    // 51305
    //*** TABLE ***//
    table "SMG Setup" = X,                                              // 51300
    table "SMG Customer Classification" = X,                            // 51301
    table "SMG COLS Conditions" = X,                                    // 51302
    table "SMG APOS Conditions" = X,                                    // 51303
    table "SMG Sales Discounts" = X,                                    // 51304
    table "SMG Historical Values Margin" = X,                           // 51305  
    //*** PAGE  ***//
    page "SMG Setup Card" = X,                                          // 51300
    page "SMG Purchasing Group List" = X,                               // 51301
    page "SMG Customer Type List" = X,                                  // 51302
    page "SMG Platform List" = X,                                       // 51303
    page "SMG National Group List" = X,                                 // 51304
    page "SMG COLS Conditions List" = X,                                // 51305
    page "SMG APOS Customer Cond. List" = X,                            // 51306
    page "SMG APOS Platform Cond. List" = X,                            // 51307
    page "SMG Sales Discounts" = X,                                     // 51308
    page "SMG Hist Standard Cost List" = X,                             // 51309
    page "SMG Hist Transp Ecom Cost List" = X,                          // 51310    
    //*** CODEUNIT ***//
    codeunit "SMG Management" = X,                                      // 50300
    codeunit "SMG Sales Events" = X,                                    // 50301
    codeunit "SMG Sales Post Events" = X;                               // 50302
    //*** REPORT ***//
    //report "" = X,
    //*** XMLPORT ***//
    //xmlport "" = X,
    //*** QUERY ***//
    //query "" = X              
}