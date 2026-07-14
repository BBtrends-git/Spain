PageExtension 50196 "BBT Warehouse Setup" extends "Warehouse Setup"
{
    layout
    {
        addafter("Shipment Posting Policy")
        {
            field("Return Day"; Rec."Return Day")
            {
                ApplicationArea = Basic;
            }
            field("File directory export"; Rec."File directory export")
            {
                ApplicationArea = Basic;
            }
            field("Packing report"; Rec."Packing report")
            {
                ApplicationArea = Basic;
            }

            field("Pallet Weight"; Rec."Pallet Weight")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            //>> BBT. PRECINTIA
            /*
            field("Alm. inicio propuesta"; Rec."Alm. inicio propuesta")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Alm. fin propuesta"; Rec."Alm. fin propuesta")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            */
            //<<
        }
        addafter(Numbering)
        {
            group(SGA)
            {
                Caption = 'SGA';
                Enabled = SGAENABLE;

                field("Nombre servidor SQL"; Rec."Nombre servidor SQL")
                {
                    ApplicationArea = Basic;
                }
                field("Base de datos"; Rec."Base de datos")
                {
                    ApplicationArea = Basic;
                }
                field("Usuario conex."; Rec."Usuario conex.")
                {
                    ApplicationArea = Basic;
                }
                field("Contraseña conex."; Rec."Contraseña conex.")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = Masked;
                }
                field("Box Unit"; Rec."Box Unit")
                {
                    ApplicationArea = Basic;
                }
                field("Palet Unit"; Rec."Palet Unit")
                {
                    ApplicationArea = Basic;
                }
                group("Diario Ajustes")
                {
                    Caption = 'Diario Ajustes';
                    Enabled = SGAENABLE;

                    field("Journal Template Name"; Rec."Journal Template Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Journal Batch Name"; Rec."Journal Batch Name")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group("Diario Ajuste Inventario")
                {
                    Caption = 'Diario Ajuste Inventario';
                    Enabled = SGAENABLE;

                    field("Inv Journal Template Name"; Rec."Inv Journal Template Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Inv Journal Batch Name"; Rec."Inv Journal Batch Name")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }
        addafter("Packing report")
        {
            field("Default Return Location"; Rec."Default Return Location")
            {
                ApplicationArea = Basic;
            }
            field("Default Sales CR Memo Location"; Rec."Default Sales CR Memo Location")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        /*
        addfirst(processing)
        {
            group(ActionGroup1100234014)
            {
                action("Probar Conexión")
                {
                    ApplicationArea = Basic;
                    Image = "Action";
                }
            }
        }
        */
    }
    var
        SGAENABLE: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        EnabledSGA;
    end;

    local procedure EnabledSGA()
    var
        _InfoCompany: Record "Company Information";
    begin
        _InfoCompany.Get;
        SGAENABLE := _InfoCompany.SGA;
    end;
}
