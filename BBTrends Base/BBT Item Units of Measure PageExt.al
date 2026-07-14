PageExtension 50180 "BBT Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        addafter(Weight)
        {
            field("Gross weight"; Rec."Gross weight")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }
    //Unsupported feature: Code Insertion on "OnClosePage".
    trigger OnClosePage()
    var
        RecUnitMedida: Record "Item Unit of Measure";
        Item: Record Item;
    begin
        RecUnitMedida.SETRANGE("Item No.", rec."Item No.");
        RecUnitMedida.SETRANGE(modificadoSGA, TRUE);
        IF RecUnitMedida.FINDSET(TRUE) THEN
            IF Item.GET(rec."Item No.") THEN BEGIN
                Item.ModificadoSGA := TRUE;
                Item.MODIFY;
                RecUnitMedida.MODIFYALL(modificadoSGA, FALSE);
            END;
    end;
}
