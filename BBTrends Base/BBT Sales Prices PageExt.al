pageextension 50027 "Sales Prices" extends "Sales Prices"
{
    layout
    {
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            //field("En promocion"; Rec."En promocion")
            //{
            //    ApplicationArea = All;
            //}
            // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
            /*
            field("ID CRM"; Rec."ID CRM")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Últ. Actualización"; Rec."Últ. Actualización")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            */
            //<<
        }
        addafter(CurrencyCodeFilterCtrl)
        {
            field(ExpiredDateFilter; ExpiredDateFilter)
            {
                Caption = 'Hide expired lines', Comment = 'ESP="Ocultar tarifas caducadas"';
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    ExpiredDateFilterOnAfterValid();
                end;
            }
        }
    }

    var
        ExpiredDateFilter: Boolean;

    procedure ExpiredDateFilterOnAfterValid()
    var
    begin
        CurrPage.SaveRecord();
        if ExpiredDateFilter then
            Rec.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D)
        else
            Rec.SetRange("Ending Date");
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        ExpiredDateFilter := true;
        CurrPage.SaveRecord();
        if ExpiredDateFilter then
            Rec.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D)
        else
            Rec.SetRange("Ending Date");
        CurrPage.Update(false);
    end;
}
