Table 51304 "SMG Sales Discounts"
{
    Caption = 'Sales Discounts', Comment = 'ESP="Descuentos de Ventas"';
    DrillDownPageID = 51304;
    LookupPageID = 51304;

    fields
    {
        field(1; "SMG Apply to"; Enum "SMG Sales Discount Type")
        {
            Caption = 'Apply to', Comment = 'ESP="Opción"';
        }
        field(2; "SMG Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            NotBlank = true;
            TableRelation = if ("SMG Apply to" = const("Customer Type")) "SMG Customer Classification".Code where(Type = const("Customer Type"))
            else if ("SMG Apply to" = const("National Group")) "SMG Customer Classification".Code where(Type = const("National Group"))
            else if ("SMG Apply to" = const(Platform)) "SMG Customer Classification".Code where(Type = const(Platform))
            else if ("SMG Apply to" = const(Customer)) Customer."No.";
        }
        field(3; "SMG Discount 1 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(1);
            Caption = 'Disc. 1 %';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "SMG Discount 2 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(2);
            Caption = 'Disc. 2 %';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "SMG Discount 3 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(3);
            Caption = 'Disc. 3 %';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(6; "SMG Discount 4 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(4);
            Caption = 'Disc. 4 %';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(7; "SMG Discount 5 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(5);
            Caption = 'Disc. 5 %';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
    }
    keys
    {
        key(Key1; "SMG Apply to", "SMG Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    procedure GetDiscountCaption(pDiscountNo: Integer): Text[50]
    var
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";
    begin
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        case pDiscountNo of
            1:
                begin
                    if (rSMGSetup."Discount 1 Enabled") then
                        if (rSMGSetup."Discount 1 Caption" <> '') then
                            exit(rSMGSetup."Discount 1 Caption")
                        else
                            exit(FieldCaption("SMG Discount 1 %"))
                    else
                        exit('')
                end;
            2:
                begin
                    if (rSMGSetup."Discount 2 Enabled") then
                        if (rSMGSetup."Discount 2 Caption" <> '') then
                            exit(rSMGSetup."Discount 2 Caption")
                        else
                            exit(FieldCaption("SMG Discount 2 %"))
                    else
                        exit('')
                end;
            3:
                begin
                    if (rSMGSetup."Discount 3 Enabled") then
                        if (rSMGSetup."Discount 3 Caption" <> '') then
                            exit(rSMGSetup."Discount 3 Caption")
                        else
                            exit(FieldCaption("SMG Discount 3 %"))
                    else
                        exit('')
                end;
            4:
                begin
                    if (rSMGSetup."Discount 4 Enabled") then
                        if (rSMGSetup."Discount 4 Caption" <> '') then
                            exit(rSMGSetup."Discount 4 Caption")
                        else
                            exit(FieldCaption("SMG Discount 4 %"))
                    else
                        exit('')
                end;
            5:
                begin
                    if (rSMGSetup."Discount 5 Enabled") then
                        if (rSMGSetup."Discount 5 Caption" <> '') then
                            exit(rSMGSetup."Discount 5 Caption")
                        else
                            exit(FieldCaption("SMG Discount 5 %"))
                    else
                        exit('')
                end;
            else
                exit('')
        end;
    end;

    procedure GetDiscountAmountCaption(DiscountNo: Integer): Text[80]
    var
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";

        SalesLine: Record "Sales Line";
        TextAmount: label '%1 Amount', Comment = 'ESP="Importe %1';
    begin
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        case DiscountNo of
            1:
                begin
                    if (rSMGSetup."Discount 1 Enabled") then
                        if (rSMGSetup."Discount 1 Caption" <> '') then
                            exit(StrSubstNo(TextAmount, rSMGSetup."Discount 1 Caption"))
                        else
                            exit(SalesLine.FieldCaption("SMG Discount 1 Amount"))
                    else
                        exit('')
                end;
            2:
                begin
                    if (rSMGSetup."Discount 2 Enabled") then
                        if (rSMGSetup."Discount 2 Caption" <> '') then
                            exit(StrSubstNo(TextAmount, rSMGSetup."Discount 2 Caption"))
                        else
                            exit(SalesLine.FieldCaption("SMG Discount 2 Amount"))
                    else
                        exit('')
                end;
            3:
                begin
                    if (rSMGSetup."Discount 3 Enabled") then
                        if (rSMGSetup."Discount 3 Caption" <> '') then
                            exit(StrSubstNo(TextAmount, rSMGSetup."Discount 3 Caption"))
                        else
                            exit(SalesLine.FieldCaption("SMG Discount 3 Amount"))
                    else
                        exit('')
                end;
            4:
                begin
                    if (rSMGSetup."Discount 4 Enabled") then
                        if (rSMGSetup."Discount 4 Caption" <> '') then
                            exit(StrSubstNo(TextAmount, rSMGSetup."Discount 4 Caption"))
                        else
                            exit(SalesLine.FieldCaption("SMG Discount 4 Amount"))
                    else
                        exit('')
                end;
            5:
                begin
                    if (rSMGSetup."Discount 5 Enabled") then
                        if (rSMGSetup."Discount 5 Caption" <> '') then
                            exit(StrSubstNo(TextAmount, rSMGSetup."Discount 5 Caption"))
                        else
                            exit(SalesLine.FieldCaption("SMG Discount 5 Amount"))
                    else
                        exit('')
                end;
            else
                exit('')
        end;
    end;
}
