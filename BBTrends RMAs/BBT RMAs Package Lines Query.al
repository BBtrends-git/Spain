query 51200 "RMAs Package Lines Query"
{
    Caption = 'RMAs Package Lines Query', Comment = 'ESP="RMAs Package Lines Query"';
    QueryType = Normal;

    elements
    {
        dataitem(RMAs_Package; "RMAs Package")
        {
            column(Package_No_; "Package No.")
            { }
            column(Creation_Date; "Creation Date")
            { }
            column(Package_Type; "Package Type")
            { }
            column(Numbers_Packages; "Numbers Packages")
            { }
            column(Package_Status; "Package Status")
            { }
            column(Registered_Package; "Registered Package")
            { }
            dataitem(RMAs_Package_Line; "RMAs Package Line")
            {
                DataItemLink = "Package No." = RMAs_Package."Package No.";
                column(Package_Line; "Package Line")
                { }
                column(Return_Order_No_; "Return Order No.")
                { }
                column(Item_No_; "Item No.")
                { }
                column(EAN_of_Unit; "EAN of Unit")
                { }
                column(Description; Description)
                { }
                column(Quantity; Quantity)
                { }
                column(Lot_Number; "Lot Number")
                { }
                column(Quality; Quality)
                { }
                column(Condition; Condition)
                { }
                column(Return_Reason; "Return Reason")
                { }
                column(Incident; Incident)
                { }
                column(Incident_Reason; "Incident Reason")
                { }
                column(Return_Resource; "Return Resource")
                { }
                column(Analysis_Date; "Analysis Date")
                { }
            }
        }
    }
    trigger OnBeforeOpen();
    begin

    end;
}