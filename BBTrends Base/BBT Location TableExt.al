TableExtension 50106 "BBT Location" extends Location
{
    fields
    {
        field(50000; SGA; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50001; Calidad; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50002; "Movimiento SGA ficticio"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50003; "Allows return SGA"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Allows return SGA';
            Description = 'SGA';
        }
        field(50004; "Sales Shpt.Packaging Mandatory"; Boolean)
        {
            Caption = 'Embalaje obligatorio - Alb. Venta';
            Description = 'EDI';
        }
        field(50005; "Packaging Nos."; Code[20])
        {
            Caption = 'Nº serie embalajes';
            Description = 'EDI';
            TableRelation = "No. Series";
        }
        field(50006; "Blocked For Sales"; Boolean)
        {
            Description = 'EUROGAMA';
        }
        field(50007; Place; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "SGA Whse Code"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'SGA Whse Code';
            Description = 'SGA';
        }
    }
    procedure CantUseLocation(_Location: Code[10]): Boolean
    var
        _CompanyInfo: Record "Company Information";
    begin
        _CompanyInfo.Get;
        if _CompanyInfo.SGA then begin
            if rec.Get(_Location) then
                exit(not rec.SGA)
            else
                exit(true);
        end;
        exit(true);
    end;
}
