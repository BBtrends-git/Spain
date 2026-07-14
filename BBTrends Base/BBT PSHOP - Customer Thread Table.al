Table 50027 "PSHOP - Customer Thread"
{
    Caption = 'Hilo cliente Prestashop';
    //DrillDownPageID = "PSHOP - Customer Threads";
    //LookupPageID = "PSHOP - Customer Threads";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; id_lang; Integer)
        { }
        field(3; id_shop; Integer)
        {
            TableRelation = "PSHOP - Shop".id where("Site Code" = field("Site Code"));
        }
        field(4; id_customer; Integer)
        {
            TableRelation = "PSHOP - Customer".id;
        }
        field(5; id_order; Integer)
        {
            TableRelation = "PSHOP - Order Header".id;
        }
        field(6; id_product; Integer)
        {
            TableRelation = "PSHOP - Product".id;
        }
        field(7; id_contact; Integer)
        { }
        field(8; email; Text[100])
        { }
        field(9; token; Text[50])
        { }
        field(10; status; Text[30])
        { }
        field(11; date_add; DateTime)
        { }
        field(12; date_upd; DateTime)
        { }
        field(13; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "Messages Number"; Integer)
        {
            CalcFormula = count("PSHOP - Customer Message" where("Customer Thread Id" = field(id)));
            Caption = 'Número de mensajes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "NAV CS No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            TableRelation = "Customer Service Header"."No.";
        }
        field(102; "Error Text"; Text[250])
        {
            Caption = 'Texto error';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Site Code", id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
    trigger OnDelete()
    var
        PSHOPCustomerMessage: Record "PSHOP - Customer Message";
    begin
        PSHOPCustomerMessage.Reset;
        PSHOPCustomerMessage.SetRange("Customer Thread Id", id);
        if PSHOPCustomerMessage.FindSet then PSHOPCustomerMessage.DeleteAll(true);
    end;
}
