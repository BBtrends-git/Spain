permissionset 51250 "BBT SCM Permission"
{
    Assignable = true;
    Permissions =
    //*** TABLEDATA ***//
    tabledata "Customer" = R,
    tabledata "Item" = R,
    tabledata "Vendor" = R,
    tabledata "Purchase Line" = R,
    tabledata "Sales Invoice Line" = R,
    tabledata "Sales Line" = R,
    tabledata "Requisition Line" = RIMD,

    //*** TABLE ***//
    //table "" = X,

    //*** PAGE  ***//
    page "SCM API Item" = X,                        // 51250
    page "SCM API Customer" = X,                    // 51251
    page "SCM API Sales Invoice Line" = X,          // 51252
    page "SCM API Vendor" = X,                      // 51253
    page "SCM API Purchase Line" = X,               // 51254
    page "SCM API Item Vendor" = X,                 // 51255
    page "SCM API Requisition WorkSheet" = X,       // 51256
    page "SCM API Sales Order Line" = X,            // 51257
    page "SCM API Sales CrMemo Line" = X,           // 51258
    //*** CODEUNIT ***//
    //Codeunit "" = X,

    //*** REPORT ***//
    //report "" = X,

    //*** XMLPORT ***//
    //xmlport "" = X,

    //*** QUERY ***//
    query "SCM API Inventory" = X;                  // 51250
}