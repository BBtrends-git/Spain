page 51254 "SCM API Purchase Line"
{
    PageType = API;
    Caption = 'SCM Purchase Line';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.2';
    EntityName = 'scmpurchaseline';
    EntitySetName = 'scmpurchaselines';
    SourceTable = "Purchase Line";
    Editable = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    //>> BBT 08/05/2026
    //   Los campos de importación estan en la extensión Base de BBTrends.
    //   En Italia-Polonia está extensión no está instalada
    //   Para evitar usar una extensión 'duplicada' se recuperan los campos en
    //   una tabla temporal. 
    SourceTableTemporary = true; // Trabajamos en memoria para evitar errores de esquema
    //<<

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document"; Rec."Document No.")
                { }
                field("Line"; Rec."Line No.")
                { }
                field("OrderDate"; Rec."Order Date")
                { }
                field("Vendor"; Rec."Pay-to Vendor No.")
                { }
                field("Location"; Rec."Location Code")
                { }
                field("ExpectedReceiptDate"; Rec."Expected Receipt Date")
                { }
                field("Item"; Rec."No.")
                { }
                field("Quantity"; Rec.Quantity)
                { }
                field("LineAmount"; Rec."Line Amount")
                { }
                field("Currency"; Rec."Currency Code")
                { }
                field("OutstandingQuantity"; Rec."Outstanding Quantity")
                { }
                field("ImportLineStatus"; VarBBTLineStatus)
                { }
            }
        }
    }

    var
        VarBBTLineStatus: Text;

    trigger OnInit()
    begin
        /*
        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetFilter(Quantity, '<>%1', 0);
        Rec.SetFilter("Outstanding Quantity", '>%1', 0);
        */
    end;

    trigger OnOpenPage()
    var
        rPurchaseLine: Record "Purchase Line";
    begin
        //>> Borrado de la tabla temporal.
        if Rec.IsTemporary() then begin
            Rec.Reset();
            Rec.DeleteAll(false);
        end;
        //<<

        rPurchaseLine.SetRange("Document Type", rPurchaseLine."Document Type"::Order);
        rPurchaseLine.SetRange(Type, rPurchaseLine.Type::Item);
        rPurchaseLine.SetFilter(Quantity, '<>%1', 0);
        rPurchaseLine.SetFilter("Outstanding Quantity", '>%1', 0);
        if rPurchaseLine.FindSet() then
            repeat
                Rec.Init();
                Rec.TransferFields(rPurchaseLine);  // Campos estandar BC 
                Rec.Insert();
            until rPurchaseLine.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    begin
        VarBBTLineStatus := GetFieldValueByName(Rec, 'BBT Line Status');
        if VarBBTLineStatus <> 'EMBARCADO' then
            Clear(VarBBTLineStatus);
    end;

    local procedure GetFieldValueByName(pPurchaseLine: Record "Purchase Line"; FieldName: Text): Text
    var
        rField: Record Field;
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        rField.SetRange(TableNo, Database::"Purchase Line");
        rField.SetRange(FieldName, FieldName);
        if rField.FindFirst() then begin
            RecRef.GetTable(pPurchaseLine);
            FldRef := RecRef.Field(rField."No.");
            exit(Format(FldRef.Value));
        end
        else
            exit('');
    end;
}