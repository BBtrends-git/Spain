Table 50002 "Sales Discounts"
{
    // //IBER AGI 09/05/16 - P4: Descuentos de venta
    Caption = 'Sales Discounts';
    //>> BBT. SMG Extension. 
    ObsoleteState = Pending;
    //DrillDownPageID = 50004;
    //LookupPageID = 50004;
    //<<

    fields
    {
        field(1; "Apply to"; Option)
        {
            Caption = 'Apply to';
            OptionCaption = 'Customer Type,National Group,Platform,Customer';
            OptionMembers = "Customer Type","National Group",Platform,Customer;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = if ("Apply to" = const("Customer Type")) "SMG Customer Classification".Code where(Type = const("Customer Type"))
            else if ("Apply to" = const("National Group")) "SMG Customer Classification".Code where(Type = const("National Group"))
            else if ("Apply to" = const(Platform)) "SMG Customer Classification".Code where(Type = const(Platform))
            else if ("Apply to" = const(Customer)) Customer."No.";
        }
        field(3; "Discount 1 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(1);
            Caption = 'Disc. 1 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "Discount 2 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(2);
            Caption = 'Disc. 2 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Discount 3 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(3);
            Caption = 'Disc. 3 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(6; "Discount 4 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(4);
            Caption = 'Disc. 4 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(7; "Discount 5 %"; Decimal)
        {
            CaptionClass = GetDiscountCaption(5);
            Caption = 'Disc. 5 %';
            MaxValue = 100;
            MinValue = 0;
        }
    }
    keys
    {
        key(Key1; "Apply to", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    procedure GetDiscountCaption(DiscountNo: Integer): Text[80]
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        case DiscountNo of
            1:
                begin
                    if SalesSetup."Disc. 1 % Caption" = '' then
                        exit(FieldCaption("Discount 1 %"))
                    else
                        exit(SalesSetup."Disc. 1 % Caption");
                end;
            2:
                begin
                    if SalesSetup."Disc. 2 % Caption" = '' then
                        exit(FieldCaption("Discount 2 %"))
                    else
                        exit(SalesSetup."Disc. 2 % Caption");
                end;
            3:
                begin
                    if SalesSetup."Disc. 3 % Caption" = '' then
                        exit(FieldCaption("Discount 3 %"))
                    else
                        exit(SalesSetup."Disc. 3 % Caption");
                end;
            4:
                begin
                    if SalesSetup."Disc. 4 % Caption" = '' then
                        exit(FieldCaption("Discount 4 %"))
                    else
                        exit(SalesSetup."Disc. 4 % Caption");
                end;
            5:
                begin
                    if SalesSetup."Disc. 5 % Caption" = '' then
                        exit(FieldCaption("Discount 5 %"))
                    else
                        exit(SalesSetup."Disc. 5 % Caption");
                end;
            else
                exit('')
        end;
    end;

    procedure GetDiscAmtCaption(DiscountNo: Integer): Text[80]
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        TextAmount: label 'Amount %1';
    begin
        SalesSetup.Get;
        case DiscountNo of
            1:
                begin
                    if SalesSetup."Disc. 1 % Caption" = '' then
                        exit(SalesLine.FieldCaption("Discount 1 Amount"))
                    else
                        exit(StrSubstNo(TextAmount, SalesSetup."Disc. 1 % Caption"));
                end;
            2:
                begin
                    if SalesSetup."Disc. 2 % Caption" = '' then
                        exit(SalesLine.FieldCaption("Discount 2 Amount"))
                    else
                        exit(StrSubstNo(TextAmount, SalesSetup."Disc. 2 % Caption"));
                end;
            3:
                begin
                    if SalesSetup."Disc. 3 % Caption" = '' then
                        exit(SalesLine.FieldCaption("Discount 3 Amount"))
                    else
                        exit(StrSubstNo(TextAmount, SalesSetup."Disc. 3 % Caption"));
                end;
            4:
                begin
                    if SalesSetup."Disc. 4 % Caption" = '' then
                        exit(SalesLine.FieldCaption("Discount 4 Amount"))
                    else
                        exit(StrSubstNo(TextAmount, SalesSetup."Disc. 4 % Caption"));
                end;
            5:
                begin
                    if SalesSetup."Disc. 5 % Caption" = '' then
                        exit(SalesLine.FieldCaption("Discount 5 Amount"))
                    else
                        exit(StrSubstNo(TextAmount, SalesSetup."Disc. 5 % Caption"));
                end;
            else
                exit('')
        end;
    end;
}
