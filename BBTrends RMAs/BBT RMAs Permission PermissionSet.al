permissionset 51200 "BBT RMAs Permission"
{
    Assignable = true;
    Permissions =
    //*** TABLEDATA ***//
    tabledata "RMAs Setup" = RIMD,                      // 51200
    tabledata "RMAs Package" = RIMD,                    // 51201
    tabledata "RMAs Package Line" = RIMD,               // 51202
    tabledata "RMAS Auxiliary Table States" = RIMD,     // 51203
    //tabledata "RMAs Package Lines Querys" = RIMD,     // 51204
    tabledata "RMAs Stock Package" = RIMD,              // 51205
    tabledata "RMAs Stock Package Line" = RIMD,         // 51206
    tabledata "RMAs Package Transfer Matrix" = RIMD,    // 51207
    tabledata "RMAs Cue" = RIMD,                        // 51208
    tabledata "RMAs Posted Package" = RIMD,             // 51209
    tabledata "RMAs Posted Package Line" = RIMD,        // 51210
    tabledata "RMAs Package Lines Queries" = RIMD,      // 51211
    //*** TABLE ***//
    table "RMAs Setup" = X,                             // 51200
    table "RMAs Package" = X,                           // 51201
    table "RMAs Package Line" = X,                      // 51202
    table "RMAS Auxiliary Table States" = X,            // 51203
    //table "RMAs Package Lines Querys" = X,            // 51204
    table "RMAs Stock Package" = X,                     // 51205
    table "RMAs Stock Package Line" = X,                // 51206
    table "RMAs Package Transfer Matrix" = X,           // 51207
    table "RMAs Cue" = X,                               // 51208
    table "RMAs Posted Package" = X,                    // 51209
    table "RMAs Posted Package Line" = X,               // 51210
    table "RMAs Package Lines Queries" = X,             // 51204
    //*** PAGE  ***//
    page "RMAs Setup Card" = X,                         // 51200
    page "RMAs Package Open List" = X,                  // 51201
    page "RMAs Package Card" = X,                       // 51202
    page "RMAs Package Subform" = X,                    // 51203
    page "RMAs Package Line List" = X,                  // 51204
    page "RMAs Auxiliary Table Reason" = X,             // 51205
    page "RMAs Auxiliary Table Category" = X,           // 51206
    page "RMAs Sales Return Lookup" = X,                // 51207
    page "RMAs Return Resource List" = X,               // 51208
    page "RMAs Return Resource Card" = X,               // 51209
    page "RMAs Return Info Faxbox" = X,                 // 51210
    page "RMAs Return Item Faxbox" = X,                 // 51211
    page "RMAs Archived Package List" = X,              // 51212
    page "RMAs Stock Package List" = X,                 // 51213
    page "RMAs Stock Package Card" = X,                 // 51214
    page "RMAs Stock Package Subform" = X,              // 51215
    page "RMAs Stock Package Selection" = X,            // 51216
    page "RMAs Management Role Center" = X,             // 51217
    page "RMAs Management Activities" = X,              // 51218
    page "RMAs Management Archives" = X,                // 51219
    page "RMAs Transfer Matrix List" = X,               // 51220
    page "RMAs Transferred Package Card" = X,           // 51221
    page "RMAs Transferred Package List" = X,           // 51222
    page "RMAs Transferred Package Subf" = X,           // 51223
    page "RMAS Item List" = X,                          // 51224
    page "RMAs Item Card" = X,                          // 51225    
    page "RMAs Units of Measure Subform" = X,           // 51226    
    page "RMAs Item Identifiers Subform" = X,           // 51227    
    page "RMAs Posted Package List" = X,                // 51228
    page "RMAs Posted Package Card" = X,                // 51229
    page "RMAs Posted Package Subform" = X,             // 51230
    page "RMAs Units Pending Returns" = X,              // 51231
    page "RMAs Archived Package Card" = X,              // 51232    
    page "RMAs Archived Package Subform" = X,           // 51233    
    page "RMAs Units Pending Transfer" = X,             // 51234
    page "RMAs Units Pending Credit Memo" = X,          // 51235
    page "RMAs Package Closed List" = X,                // 51236
    page "RMAs Item Comment lines Faxbox" = X,          // 51237
    page "RMAs API Returns Package Lines" = X,          // 51238  
    //*** CODEUNIT ***//
    codeunit "RMAs Management" = X,                     // 50200
    codeunit "RMAs Sales Return Events" = X,            // 50201
    //*** REPORT ***//
    //report "" = X,
    //*** XMLPORT ***//
    //xmlport "" = X,
    //*** QUERY ***//
    query "RMAs Package Lines Query" = X,               // 50200
    query "RMAs API Unit Pending Transfer" = X;         // 50201    

}