page 50038 "Packaging Card"
{
    Caption = 'Ficha Embalaje';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Packaging";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    trigger OnValidate()
                    var
                        SalesHeader: record "Sales Header";
                    begin
                        Rec.SETRANGE("No.");
                        IF Rec."Source Type" <> 0 THEN BEGIN
                            CASE Rec."Source Type" OF
                                DATABASE::"Sales Line":
                                    BEGIN
                                        SalesHeader.RESET;
                                        SalesHeader.SETRANGE("No.", Rec."Source No.");
                                        SalesHeader.FINDSET;
                                        Rec.VALIDATE("Location Code", SalesHeader."Location Code");
                                        Rec.MODIFY;
                                    END;
                                ELSE
                                    ERROR('Opción sin contemplar - Pongase en contacto con el administrador del sistema');
                            END;
                        end;
                    end;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Fecha creación field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Fecha registro field.';
                }
                field("Info Code"; Rec."Info Code")
                {
                    ToolTip = 'Specifies the value of the Cód. Información field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Cantidad field.';
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ToolTip = 'Specifies the value of the Cdad. (Base) field.';
                }
                field("Created by"; Rec."Created by")
                {
                    ToolTip = 'Specifies the value of the Creado por field.';
                }
                field("Posted by"; Rec."Posted by")
                {
                    ToolTip = 'Specifies the value of the Registrado por field.';
                }
                field("Number of Boxes"; Rec."Number of Boxes")
                {
                    ToolTip = 'Specifies the value of the Número paquetes field.';
                }
            }
            group(Origen)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Tipo origen field.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Nº Origen field.';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                }
                field("Posted Source Type"; Rec."Posted Source Type")
                {
                    ToolTip = 'Specifies the value of the Tipo origen reg. field.';
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                    ToolTip = 'Specifies the value of the Nº Origen reg. field.';
                }
                field("Posted Source Line No."; Rec."Posted Source Line No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Condiciones)
            {
                field("Terms and Conditions Code"; Rec."Terms and Conditions Code")
                {
                    ToolTip = 'Specifies the value of the Cód. Términos y condiciones field.';
                }
                field("Type Code"; Rec."Type Code")
                {
                    ToolTip = 'Specifies the value of the Cód. Tipo field.';
                }
                field("Shipping Payment Responsible"; Rec."Shipping Payment Responsible")
                {
                    ToolTip = 'Specifies the value of the Responsable pago transporte field.';
                }
                field("Type Text"; Rec."Type Text")
                {
                    ToolTip = 'Specifies the value of the Descripción tipo embalaje field.';
                }
            }
            part(Lines; "Packaging Subform")
            {
                SubPageLink = "No." = FIELD("No.");
            }
            group(Peso)
            {
                field("Net Weight 1 (AAC)"; Rec."Net Weight 1 (AAC)")
                {
                    ToolTip = 'Specifies the value of the Peso neto 1 (AAC) field.';
                }
                field("Net Weight Type"; Rec."Net Weight Type")
                {
                    ToolTip = 'Specifies the value of the Significación peso neto field.';
                }
                field("Net Weight 2"; Rec."Net Weight 2")
                {
                    ToolTip = 'Specifies the value of the Peso neto 2 field.';
                }
                field("Net Weight UOM"; Rec."Net Weight UOM")
                {
                    ToolTip = 'Specifies the value of the Ud. Medida peso neto field.';
                }
                field("Gross Weight 1 (AAD)"; Rec."Gross Weight 1 (AAD)")
                {
                    ToolTip = 'Specifies the value of the Peso bruto 1 (AAD) field.';
                }
                field("Gross Weight 2"; Rec."Gross Weight 2")
                {
                    ToolTip = 'Specifies the value of the Peso bruto 2 field.';
                }
                field("Gross Weight Type"; Rec."Gross Weight Type")
                {
                    ToolTip = 'Specifies the value of the Significación peso bruto field.';
                }
                field("Gross Weight UOM"; Rec."Gross Weight UOM")
                {
                    ToolTip = 'Specifies the value of the Ud. Medida peso bruto field.';
                }
            }
            group(Dimension)
            {
                Caption = 'Dimensiones y Temperatura';

                field("Temp Dimension 1 (TC)"; Rec."Temp Dimension 1 (TC)")
                {
                    ToolTip = 'Specifies the value of the Dimensión de temperatura 1 (TC) field.';
                }
                field("Temp Dimension 2"; Rec."Temp Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Dimensión de temperatura 2 field.';
                }
                field("Temp Type"; Rec."Temp Type")
                {
                    ToolTip = 'Specifies the value of the Significación temperatura field.';
                }
                field("Temp UOM"; Rec."Temp UOM")
                {
                    ToolTip = 'Specifies the value of the Ud. Medida temperatura field.';
                }
                field("Length Dimension 1 (LN)"; Rec."Length Dimension 1 (LN)")
                {
                    ToolTip = 'Specifies the value of the Dimensión de longitud 1 (LN) field.';
                }
                field("Length Dimension 2"; Rec."Length Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Dimensión de longitud 2 field.';
                }
                field("Length Type"; Rec."Length Type")
                {
                    ToolTip = 'Specifies the value of the Significación longitud field.';
                }
                field("Length UOM"; Rec."Length UOM")
                {
                    ToolTip = 'Specifies the value of the Ud. Medida longitud field.';
                }
                field("Height Dimension 1 (HT)"; Rec."Height Dimension 1 (HT)")
                {
                    ToolTip = 'Specifies the value of the Dimensión de altura 1 (HT) field.';
                }
                field("Height Dimension 2"; Rec."Height Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Dimensión de altura 2 field.';
                }
                field("Height Type"; Rec."Height Type")
                {
                    ToolTip = 'Specifies the value of the Significación altura field.';
                }
                field("Height UOM"; Rec."Height UOM")
                {
                    ToolTip = 'Specifies the value of the Ud. Medida altura field.';
                }
                field("Width Dimension 1 (WD)"; Rec."Width Dimension 1 (WD)")
                {
                    ToolTip = 'Specifies the value of the Dimensión de ancho 1 (WD) field.';
                }
                field("Width Dimension 2"; Rec."Width Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Dimensión de ancho 2 field.';
                }
                field("Width Type"; Rec."Width Type")
                {
                    ToolTip = 'Specifies the value of the Significación ancho field.';
                }
                field("Width UOM"; Rec."Width UOM")
                {
                    ToolTip = 'Specifies the value of the Ud. Medida ancho field.';
                }
            }
            group(Manejo)
            {
                field("Handling Instructions Code"; Rec."Handling Instructions Code")
                {
                    ToolTip = 'Specifies the value of the Cód. Instrucciones manejo field.';
                }
                field("Handling Instructions Text"; Rec."Handling Instructions Text")
                {
                    ToolTip = 'Specifies the value of the Descripción instrucciones manejo field.';
                }
                field("Shipment mark 1"; Rec."Shipment mark 1")
                {
                    ToolTip = 'Specifies the value of the Marca de envío 1 field.';
                }
                field("Shipment mark 2"; Rec."Shipment mark 2")
                {
                    ToolTip = 'Specifies the value of the Marca de envío 2 field.';
                }
                field("Shipment mark 3"; Rec."Shipment mark 3")
                {
                    ToolTip = 'Specifies the value of the Marca de envío 3 field.';
                }
                field("Shipment mark 4"; Rec."Shipment mark 4")
                {
                    ToolTip = 'Specifies the value of the Marca de envío 4 field.';
                }
                field("Lower SN or ID 1"; Rec."Lower SN or ID 1")
                {
                    ToolTip = 'Specifies the value of the Nº Serie o Id. Inferior 1 field.';
                }
                field("Lower SN or ID 2"; Rec."Lower SN or ID 2")
                {
                    ToolTip = 'Specifies the value of the Nº Serie o Id. Inferior 2 field.';
                }
                field("Lower SN or ID 3"; Rec."Lower SN or ID 3")
                {
                    ToolTip = 'Specifies the value of the Nº Serie o Id. Inferior 3 field.';
                }
                field("Upper SN or ID 1"; Rec."Upper SN or ID 1")
                {
                    ToolTip = 'Specifies the value of the Nº Serie o Id. Superior 1 field.';
                }
                field("Upper SN or ID 2"; Rec."Upper SN or ID 2")
                {
                    ToolTip = 'Specifies the value of the Nº Serie o Id. Superior 2 field.';
                }
                field("Upper SN or ID 3"; Rec."Upper SN or ID 3")
                {
                    ToolTip = 'Specifies the value of the Nº Serie o Id. Superior 3 field.';
                }
            }
        }
    }
    var
        SourceType: Integer;
        SourceNo: Code[20];
        SourceLineNo: Integer;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."No." = '' then
            if not Confirm('Debe ingresar un Nº de embalaje. ¿Desea cerrar igualmente?', false) then
                Error('')
            else
                Rec.Delete();
    end;

    procedure SetSource(parSourceType: Integer; parSourceNo: Code[20]; parSourceLineNo: Integer)
    var
    begin
        SourceType := parSourceType;
        SourceNo := parSourceNo;
        SourceLineNo := parSourceLineNo;
    end;
}
