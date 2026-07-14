query 51425 "API Sales Return Order Line"
{
    Caption = 'API Sales Return Order Line';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesreturnorderline';
    EntitySetName = 'apisalesreturnorderlines';

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            column(Document_Type; "Document Type")
            { }
            column(No; "No.")
            { }
            column(Line_No_; "Line No.")
            { }
            column(Type; "Type")
            { }
            column(No_; "No.")
            { }
            column(Description; Description)
            { }
            column(EAN_Code; "EAN Code")
            { }
            column(Location_Code; "Location Code")
            { }
            column(Quantity; Quantity)
            { }
            column(Return_Qty__to_Receive; "Return Qty. to Receive")
            { }
            column(Return_Qty__Received; "Return Qty. Received")
            { }
            column(Quantity_Invoiced; "Quantity Invoiced")
            { }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            { }
            column(Unit_Price; "Unit Price")
            { }
            column(Amount; Amount)
            { }
            column(Gross_Weight; "Gross Weight")
            { }
            column(Unit_Volume; "Unit Volume")
            { }
            column(Requested_Delivery_Date; "Requested Delivery Date")
            { }
            column(Return_Reason_Code; "Return Reason Code")
            { }
        }
    }
    var
        rSalesLine: Record "Sales Line";

    trigger OnBeforeOpen();
    begin
        SetFilter(Document_Type, '= %1', rSalesLine."Document Type"::"Return Order");
        SetFilter(Type, '= %1', rSalesLine.Type::Item);
        SetFilter(Quantity, '<> %1', 0);
    end;
}
