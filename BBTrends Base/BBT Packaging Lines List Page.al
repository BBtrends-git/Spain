Page 50058 "Packaging Lines List"
{
    Caption = 'Líneas embalajes';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Packaging Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Source Type"; Rec."Posted Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                    ApplicationArea = Basic;
                }
                field(Fechareg; Fechareg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fecha registro';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("No Ped SSCC"; Rec."No Ped SSCC")
                {
                    ApplicationArea = Basic;
                }
                field("No Alb SSCC"; Rec."No Alb SSCC")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Posting Date"; Rec."Shipment Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Destination Type"; Rec."Destination Type")
                {
                    ApplicationArea = Basic;
                }
                field("Destination No."; Rec."Destination No.")
                {
                    ApplicationArea = Basic;
                }
                field("Destination Name"; Rec."Destination Name")
                {
                    ApplicationArea = Basic;
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Whse. Shipment No."; Rec."Posted Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Caja Picking"; Rec."Caja Picking")
                {
                    ApplicationArea = Basic;
                }
                field("Nº documento externo"; SalesInvoiceHeader."External Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        Fechareg:=0D;
        SalesInvoiceHeader.Reset;
        SalesInvoiceHeader.SetRange("No.", Rec."Posted Source No.");
        if SalesInvoiceHeader.FindFirst then Fechareg:=SalesInvoiceHeader."Posting Date";
    end;
    var Fechareg: Date;
    SalesInvoiceHeader: Record "Sales Shipment Header";
}
