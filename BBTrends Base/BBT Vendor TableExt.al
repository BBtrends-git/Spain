TableExtension 50109 "BBT Vendor" extends Vendor
{
    fields
    {
        //>> BBT 01/07/2025. Se admiten todos los caracteres >>100<<
        /*
        modify(Name)
        {
        trigger OnBeforeValidate()
        var
            Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Nombre" no puede superar 50 caracteres."';
        begin
            if StrLen(Rec.Name) > 50 then Error(Text001Err);
        end;
        }
        modify(Address)
        {
        trigger OnBeforeValidate()
        var
            Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Dirección" no puede superar 50 caracteres."';
        begin
            if StrLen(Rec.Address) > 50 then Error(Text001Err);
        end;
        }
        modify("Address 2")
        {
        trigger OnBeforeValidate()
        var
            Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Dirección 2" no puede superar 50 caracteres."';
        begin
            if StrLen(Rec."Address 2") > 50 then Error(Text001Err);
        end;
        }
        */
        //<<
        field(50000; "EDI ID"; Text[35])
        {
            Caption = 'Id. EDI';
        }
        field(50001; "BBT Do Not Send Inv. To SII"; Boolean)
        {
            Caption = 'Do Not Send Inv. To SII', comment = 'ESP="No enviar facturas al SII"';
            DataClassification = ToBeClassified;
        }
        field(50025; "PL VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(50026; "VAT PL"; Boolean)
        {
        }
        field(50100; "Invoice Type"; Enum "SII Purch. Invoice Type")
        {
            Caption = 'Invoice Type', Comment = 'ESP="Tipo de factura"';
        }
    }
}
