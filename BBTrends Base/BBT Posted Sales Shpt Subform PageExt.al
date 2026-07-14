pageextension 50008 "BBT Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    actions
    {
        addafter(ItemInvoiceLines)
        {
            action(Packing)
            {
                ApplicationArea = all;
                Caption = 'Packing';
                RunPageMode = View;
                runobject = Page "Sales Shipment Palet";
                RunPageView = SORTING("Sales Shipment No.");
                RunPageLink = "Sales Shipment No."=FIELD("Document No."), "Sales Shipment Line Number"=FIELD("Line No.");
            }
            action(EtiquetaSSCC)
            {
                ApplicationArea = all;
                Caption = 'Etiqueta SSCC';
                Ellipsis = true;

                trigger OnAction()
                var
                    SalesShptLine: Record "Sales Shipment Line";
                begin
                    SalesShptLine.COPY(Rec);
                    CurrPage.SETSELECTIONFILTER(SalesShptLine);
                    REPORT.RUNMODAL(50022, TRUE, FALSE, SalesShptLine);
                end;
            }
        }
    }
}
