table 50052 "BBT Warranty Entry"
{
    Caption = 'Warranty Entry', comment = 'ESP="Movimientos Garantía"';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Warranty Code"; Code[20])
        //Indica el código de la garantía
        {
            DataClassification = ToBeClassified;
            Caption = 'Warranty Code', comment = 'ESP="Código Garantía"';

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateNo(Rec, xRec, IsHandled);
                if IsHandled then exit;
                if Rec."Warranty Code" <> xRec."Warranty Code" then begin
                    SalesSetup.Get();
                    //>> V27
                    //NoSeriesManagement.TestManual(SalesSetup."Warranties Nos");
                    NoSeries.TestManual(SalesSetup."Warranties Nos");
                    //<<
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "Warranty Description"; Text[100])
        //Indica la descripción de la garantía
        {
            DataClassification = ToBeClassified;
            Caption = 'Warranty Description', comment = 'ESP="Descripción Garantía"';
        }
        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            Caption = 'Customer No.', comment = 'ESP="Código Cliente"';

            trigger OnValidate()
            begin
                customer.Get("Customer No.");
                "Customer Name." := customer.Name;
            end;
        }
        field(40; "Customer Name."; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
        }
        field(50; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
            Caption = 'Item No.', comment = 'ESP="Código Producto"';

            trigger OnValidate()
            begin
                item.Get("Item No.");
                "Item Description" := Item.Description;
            end;
        }
        field(60; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Item Description', comment = 'ESP="Descripción Producto"';
        }
        field(70; "Date of Purchase"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date of Purchase', comment = 'ESP="Fecha compra"';

            trigger OnValidate()
            begin
                "Warranty Starting Date" := "Date of Purchase"
            end;
        }
        field(80; "Warranty Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "BBT Warranty Types";
            Caption = 'Warranty Type', comment = 'ESP="Tipo Garantía"';

            trigger OnValidate()
            begin
                WarrantyType.Get("Warranty Type");
                Duration := WarrantyType.Duration;
                CalculateNewDate;
            end;
        }
        field(90; "Warranty Starting Date"; Date)
        //Reference For Date Calculation
        {
            DataClassification = ToBeClassified;
            Caption = 'Warranty Starting Date', comment = 'ESP="Inicio Garantía"';

            trigger OnValidate()
            begin
                CalculateNewDate;
            end;
        }
        field(100; "Duration"; DateFormula)
        //Date Formula to Test
        {
            DataClassification = ToBeClassified;
            Caption = 'Warranty duration (Formula)', comment = 'ESP="Duración garantía (Fórmula)"';

            trigger OnValidate()
            begin
                CalculateNewDate;
            end;
        }
        field(110; "Warranty Ending Date"; Date)
        //Date Result
        {
            DataClassification = ToBeClassified;
            Caption = 'Warranty Ending Date', comment = 'ESP="Fin Garantía"';
        }
        field(120; "No. Series"; Code[20])
        {
            Caption = 'No. Series', comment = 'ESP="Nº Serie"';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(130; "Warranty State"; Enum "BBT Warranty State")
        {
            Caption = 'Status', comment = 'ESP="Estado"';
        }
    }
    keys
    {
        key(Key1; "Warranty Code", "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }
    var
        customer: Record Customer;
        item: Record Item;
        //>> Obsoleto V27
        //NoSeriesManagement: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        EmptySerialCode: Code[20];
        WNoSerialCode: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        Warranty: Record "BBT Warranty Entry";
        WarrantyType: Record "BBT Warranty Types";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled, xRec);
        if IsHandled then exit;
        IF "Warranty Code" = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Warranties Nos");
            //>> Obsoleto V27
            //NoSeriesManagement.InitSeries(SalesSetup."Warranties Nos", xRec."No. Series", 0D, "Warranty Code", "No. Series");
            //
            WNoSerialCode := SalesSetup."Warranties Nos";
            if NoSeries.AreRelated(SalesSetup."Warranties Nos", EmptySerialCode) then
                WNoSerialCode := EmptySerialCode;
            "Warranty Code" := NoSeries.GetNextNo(WNoSerialCode, 0D);
            //<<
        end;
    end;
    //>> V27
    /*
        procedure AssistEdit(OldWarranty: Record "BBT Warranty Entry") Result: Boolean
        var
            IsHandled: Boolean;

        begin
            IsHandled := false;
            OnBeforeAssistEdit(Rec, OldWarranty, IsHandled, Result);
            if IsHandled then exit;
            Warranty := Rec;
            SalesSetup.Get();
            SalesSetup.TestField("Warranties Nos");
            if NoSeriesManagement.SelectSeries(SalesSetup."Warranties Nos", OldWarranty."No. Series", Warranty."No. Series") then begin
                SalesSetup.Get();
                SalesSetup.TestField("Warranties Nos");
                NoSeriesManagement.SetSeries(Warranty."Warranty Code");
                Rec := OldWarranty;
                exit(true);
            end;
        end;
    */
    //<<
    local procedure CalculateNewDate()
    var
    begin
        "Warranty Ending Date" := CalcDate(Duration, "Warranty Starting Date")
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateNo(var Warranty: Record "BBT Warranty Entry"; xWarranty: Record "BBT Warranty Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Warranty: Record "BBT Warranty Entry"; var IsHandled: Boolean; var xWarranty: Record "BBT Warranty Entry")
    begin
    end;
    //>> V27
    /*
        [IntegrationEvent(false, false)]
        local procedure OnBeforeAssistEdit(var Warranty: Record "BBT Warranty Entry"; xOldWarranty: Record "BBT Warranty Entry"; var IsHandled: Boolean; var Result: Boolean)
        begin
        end;
    */
    //<<
}
