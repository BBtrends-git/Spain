PageExtension 50219 "BBT Item Identifiers" extends "Item Identifiers"
{
    layout
    {
        modify(Code)
        {
            trigger OnAfterValidate()
            begin
                IF rec.Code <> xRec.Code THEN BEGIN
                    Item.GET(rec."Item No.");
                    IF NOT Item."No SGA management" THEN ModificadoSGA := TRUE;
                END;
            end;
        }
        modify("Unit of Measure Code")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Unit of Measure Code', Comment = 'ESP="Código Unidad de Medida"';
            trigger OnAfterValidate()
            var
                Item: Record Item;
                EANCode: text[20];
            begin
                EANCode := CrearEAN(rec."Item No.");
                if EANCode <> '' then begin
                    Rec.Code := EANCode;
                    if Item.Get(Rec."Item No.") then
                        if Item."Base Unit of Measure" = Rec."Unit of Measure Code" then begin
                            rec."EAN EDI" := true;

                            Item."EAN Code" := Rec.Code;
                            Item.Modify();
                        end;
                    CurrPage.UPDATE;
                end;
            end;
        }
        addafter("Variant Code")
        {
            field("EAN EDI"; Rec."EAN EDI")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            group(Process)
            {
                Caption = 'Process';

                action("Crear EAN")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create EAN', Comment = 'ESP="Crear EAN"';
                    Image = BarCode;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Rec.Code := CrearEAN(rec."Item No.");
                        if Item.Get(Rec."Item No.") then
                            if Item."Base Unit of Measure" = Rec."Unit of Measure Code" then begin
                                Item."EAN Code" := Rec.Code;
                                Item.Modify();
                            end;
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // SGA
        Item.GET(rec."Item No.");
        IF NOT Item."No SGA management" THEN ModificadoSGA := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // SGA
        Item.GET(rec."Item No.");
        IF NOT Item."No SGA management" THEN ModificadoSGA := TRUE;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        // SGA
        Item.GET(rec."Item No.");
        IF NOT Item."No SGA management" THEN ModificadoSGA := TRUE;
    end;

    var
        ModificadoSGA: Boolean;
        Item: Record Item;

    procedure SaberModificado(var _ModificadoSGA: Boolean)
    var
        _InfoCompany: Record "Company Information";
    begin
        _InfoCompany.Get;
        if _InfoCompany.SGA then
            _ModificadoSGA := ModificadoSGA
        else
            _ModificadoSGA := false;
    end;

    local procedure CrearEAN(Producto: Code[20]): Code[20]
    var
        rCompanyInformation: Record "Company Information";
        rWarehouseSetup: Record "Warehouse Setup";
        rItem: Record Item;
        //InterfaceSGA: Codeunit "Interface SGA"; //CU 50000;
        cuBBTUtilities: Codeunit "BBT Utilities Codeunit"; //CU 51100
        Codigo: Text[20];
        CodigoEAN: Code[20];
        rItemCategory: Record "Item Category";
        Category: Code[10];

    begin
        Clear(CodigoEAN);
        clear(Category);
        Clear(Codigo);
        rCompanyInformation.Get;
        rWarehouseSetup.Get;
        rItem.Get(Producto);
        rItem.TestField("Item Category Code");
        Category := CopyStr(rItem."No.", 1, 4);

        if (StrLen(Format(Producto)) = 8) and (rItemCategory.Get(Category)) then begin
            if Rec."Unit of Measure Code" = rItem."Base Unit of Measure" then begin
                Codigo := CopyStr(rCompanyInformation.GLN, 1, 8) + CopyStr(rItem."No.", 5, 4);
                CodigoEAN := CalcularEAN(Codigo, 0);
            end else
                if Rec."Unit of Measure Code" = rWarehouseSetup."Box Unit" then begin
                    Codigo := '1' + CopyStr(rCompanyInformation.GLN, 1, 8) + CopyStr(rItem."No.", 5, 4);
                    CodigoEAN := CalcularEAN(Codigo, 1);
                end else
                    Error('Unidad de medida no válida.');
        end;
        exit(CodigoEAN);
    end;

    local procedure CalcularEAN(_Codigo: Code[13]; _Tipo: Option EAN13,EAN14): Code[14];
    var
        Codi: Code[13];
        Cadena: Text[100];
        Ean: Code[14];
        Mascara: Text[13];
        Control: Code[1];
        Tipo: Option EAN13,EAN14;
        LongCodigo: Integer;
    begin
        Codi := _Codigo;
        Cadena := 'abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ\/-_.,:;+ ';
        Ean := DELCHR(Codi, '=', Cadena);
        IF _Tipo = _Tipo::EAN13 THEN
            LongCodigo := 12
        ELSE
            LongCodigo := 13;
        IF STRLEN(Ean) < LongCodigo THEN ERROR('El código debe de ser de' + FORMAT(LongCodigo) + ' dígitos');
        IF _Tipo = _Tipo::EAN13 THEN
            Mascara := '131313131313'
        ELSE
            Mascara := '3131313131313';
        Control := FORMAT(STRCHECKSUM(Ean, Mascara));
        Ean := Ean + Control;
        EXIT(Ean);
    end;
}
