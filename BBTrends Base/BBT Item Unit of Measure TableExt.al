TableExtension 50154 "BBT Item Unit of Measure" extends "Item Unit of Measure"
{
    fields
    {
        modify(Weight)
        {
            Caption = 'Net weight', comment = 'ESP="Peso Neto"';
        }
        field(50000; modificadoSGA; Boolean)
        {
            Editable = false;
        }
        field(50001; "Gross weight"; Decimal)
        {
            Caption = 'Gross weight', comment = 'ESP="Peso Bruto"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get(Rec."Item No.") then
                    if Item."Base Unit of Measure" = Rec.Code then begin
                        Item."Gross Weight" := Rec."Gross weight";
                        Item.Modify();
                    end;
            end;
        }
    }
    //Unsupported feature: Code Insertion on "OnInsert".
    //trigger OnInsert()
    //begin
    /*
    Item.GET("Item No.");
    ConfigAlmacen.GET;

    IF (Code = Item."Base Unit of Measure") OR (Code = ConfigAlmacen."Box Unit") THEN
      modificadoSGA := TRUE;
    */
    //end;
    //Unsupported feature: Code Insertion on "OnModify".
    //trigger OnModify()
    //begin
    /*
    Item.GET("Item No.");
    ConfigAlmacen.GET;

    IF (Code = Item."Base Unit of Measure") OR (Code = ConfigAlmacen."Box Unit") THEN
      modificadoSGA := TRUE;
    */
    //end;
    var
    //ConfigAlmacen: Record "Warehouse Setup";

    trigger OnAfterInsert()
    begin
        CalcVolume();
    end;

    trigger OnAfterModify()
    begin
        CalcVolume();
    end;

    trigger OnAfterDelete()
    begin
        CalcVolume();
    end;

    trigger OnAfterRename()
    begin
    end;

    local procedure CalcVolume()
    var
        Item: Record Item;
    begin
        //Rename
        if ((xRec."Item No." <> '') and (Rec."Item No." <> xRec."Item No.")) or ((xRec.Code <> '') and (Rec.Code <> xRec.Code)) then begin
            Item.Reset();
            Item.SetRange("No.", xRec."Item No.");
            Item.SetRange("Base Unit of Measure", xRec.Code);
            if Item.FindFirst() then begin
                Item.CalcFields("Cubage Base Unit of Measure");
                if Item."Unit Volume" <> Item."Cubage Base Unit of Measure" then begin
                    Item."Unit Volume" := Item."Cubage Base Unit of Measure";
                    item.Modify();
                end;
            end;
        end;
        Item.Reset();
        Item.SetRange("No.", Rec."Item No.");
        Item.SetRange("Base Unit of Measure", Rec.Code);
        if Item.FindFirst() then begin
            Item.CalcFields("Cubage Base Unit of Measure");
            if Item."Unit Volume" <> Item."Cubage Base Unit of Measure" then begin
                Item."Unit Volume" := Item."Cubage Base Unit of Measure";
                item.Modify();
            end;
        end;
    end;
}
