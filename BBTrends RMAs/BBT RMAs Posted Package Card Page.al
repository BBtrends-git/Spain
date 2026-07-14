Page 51229 "RMAs Posted Package Card"
{
    Caption = 'Sales Return Posted Package Card', Comment = 'ESP="Bulto registrado Devolución Ventas"';
    PageType = Document;
    SourceTable = "RMAs Posted Package";
    ApplicationArea = All;
    //Editable = true;
    //DeleteAllowed = true;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                field("Posted Package No."; Rec."Posted Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted No."; Rec."Posted No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Creation Date"; Rec."Posted Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Package Type"; Rec."Package Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field("Numbers Packages"; Rec."Numbers Packages")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Category"; Rec."Return Category")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
            }
            part(PostedPackageSubform; "RMAs Posted Package Subform")
            {
                ApplicationArea = Basic, Suite;
                Enabled = true;
                SubPageLink = "Posted Package No." = field("Posted Package No."), "Posted No." = field("Posted No.");
                UpdatePropagation = Both;
                Editable = false;
            }

        }
    }
    actions
    { }

    //>> PARA QUITAR - DEPURA ERRORES DE REGISTRO 
    trigger OnOpenPage()
    var
        rRMASetup: Record "RMAs Setup";
        rRMAPostedPackage: Record "RMAs Posted Package";
        rRMAPostedPackageLine: Record "RMAs Posted Package Line";
    begin
        // BORRAR Cabeceras sin Líneas
        /*
        rRMAPostedPackage.Reset();
        if rRMAPostedPackage.FindSet() then
            repeat begin
                rRMAPostedPackageLine.Reset();
                rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                rRMAPostedPackageline.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                if not rRMAPostedPackageLine.FindFirst() then
                    rRMAPostedPackage.Delete();
            end;
            until rRMAPostedPackage.Next() = 0;
        */
        // BORRAR Lineas sin Cabecera
        /*
        rRMAPostedPackageLine.Reset();
        if rRMAPostedPackageLine.FindSet() then
            repeat begin
                rRMAPostedPackage.Reset();
                rRMAPostedPackage.SetRange("Posted Package No.", rRMAPostedPackageLine."Posted Package No.");
                rRMAPostedPackage.SetRange("Posted No.", rRMAPostedPackageLine."Posted No.");
                if not rRMAPostedPackage.FindFirst() then
                    rRMAPostedPackageLine.Delete();
            end;
            until rRMAPostedPackageLine.Next() = 0;
        */
        // MODIFICAR estatus cabecera transferido
        /*
        rRMAPostedPackage.Reset();
        rRMAPostedPackage.SetRange("Fully Transferred", false);
        if rRMAPostedPackage.FindSet() then
            repeat begin
                rRMAPostedPackageLine.Reset();
                rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                rRMAPostedPackageline.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                rRMAPostedPackageLine.SetRange("Fully Transferred", false);
                if not rRMAPostedPackageLine.FindFirst() then begin
                    rRMAPostedPackage."Fully Transferred" := true;
                    rRMAPostedPackage.Modify();
                end;
            end;
            until rRMAPostedPackage.Next() = 0;
        */
        // REVISAMOS la cantidad ajustada para 'cerrar' el bulto
        /*
        rRMASetup.Reset();
        rRMASetup.Get();
        if rRMASetup."Scrap Adjust" = true then begin
            rRMAPostedPackage.Reset();
            if rRMAPostedPackage.FindSet() then
                repeat begin
                    rRMAPostedPackageLine.Reset();
                    rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                    rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                    rRMAPostedPackageLine.Setrange(Quality, rRMAPostedPackageLine.Quality::C);
                    rRMAPostedPackageLine.SetRange("Adjusted Quantity", 0);
                    if rRMAPostedPackageLine.FindSet() then
                        repeat begin
                            rRMAPostedPackageLine."Adjusted Quantity" := rRMAPostedPackageLine.Quantity;
                            rRMAPostedPackageLine."Fully Transferred" := true;
                            rRMAPostedPackageLine.Modify();
                        end;
                        until rRMAPostedPackageLine.Next() = 0;

                    rRMAPostedPackageLine.Reset();
                    rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                    rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                    rRMAPostedPackageLine.SetRange("Fully Transferred", false);
                    if not rRMAPostedPackageLine.FindFirst() then begin
                        rRMAPostedPackage."Fully Transferred" := true;
                        rRMAPostedPackage.Modify();
                    end;
                end;
                until rRMAPostedPackage.Next() = 0;
        end;
        */
    end;
}