permissionset 51400 "API Permission"
{
    Assignable = true;
    Permissions =
    //*** TABLEDATA ***//
    tabledata "SMG APOS Conditions" = R,
    tabledata "SMG COLS Conditions" = R,
    tabledata "Item Category" = R,
    tabledata "Item" = R,
    tabledata "SMG Historical Values Margin" = R,
    tabledata "Customer" = R,
    tabledata "Salesperson/Purchaser" = R,
    tabledata "Vendor" = R,
    tabledata "Service Zone" = R,
    tabledata "Sales Header" = R,
    tabledata "Sales Line" = R,
    tabledata "Item Reference" = R,
    tabledata "Item Ledger Entry" = R,
    tabledata "Transfer Shipment Header" = R,
    tabledata "Transfer Shipment Line" = R,
    tabledata "Sales Shipment Header" = R,
    tabledata "Purchase Line" = R,
    tabledata "Warehouse Shipment Header" = R,
    tabledata "Sales Invoice Header" = R,
    tabledata "Sales Invoice Line" = R,
    tabledata "Purch. Inv. Header" = R,
    tabledata "Purch. Inv. Line" = R,
    tabledata "Purch. Cr. Memo Hdr." = R,
    tabledata "Purch. Cr. Memo Line" = R,
    //*** TABLE ***//
    //table "SMG Setup" = X, 
    //*** PAGE  ***//
    page "API Sales Invoice" = X,               // 51420
    page "API Sales Invoice Information" = X,   // 51421 
    //*** CODEUNIT ***//
    //codeunit "SMG Management" = X,
    //*** REPORT ***//
    //report "" = X,
    //*** XMLPORT ***//
    //xmlport "" = X,
    //*** QUERY ***//
    query "API Item Category" = X,              // 51400
    query "API Item" = X,                       // 51401
    query "API Item Hist Values Margin" = X,    // 51402
    query "API Apos Conditions" = X,            // 51403
    query "API Cols Conditions" = X,            // 51404
    query "API Customer" = X,                   // 51405
    query "API Salesperson" = X,                // 51406
    query "API Vendor" = X,                     // 51407
    query "API Service Zone" = X,               // 51408
    query "API Sales Orders" = X,               // 51409
    query "API Item Reference" = X,             // 51410
    query "API Item Category Parent" = X,       // 51411
    query "API Item Inventory" = X,             // 51412
    query "API Item Inventory Warehouse" = X,   // 51413
    query "API Valued Delivery Note" = X,       // 51414
    query "API Warehouse Shipments" = X,        // 51415
    query "API Sales Shipments" = X,            // 51416
    query "API Purchase Order Line" = X,        // 51417
    query "API Posted Transfer Shipment" = X,   // 51418
    query "API Sales Credit Memo" = X,          // 51419
    query "API Purchase Invoice" = X,           // 51422
    query "API Purchase Credit Memo" = X,       // 51423
    query "API Sales Return Order" = X,         // 51424
    query "API Sales Return Order Line" = X,    // 51425
    query "API Customer Ledger Entry" = X,      // 51426
    query "API Vendor Ledger Entry" = X;        // 51427
}