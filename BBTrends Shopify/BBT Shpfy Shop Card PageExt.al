pageextension 73100 "BBT Shpfy Shop Card Ext" extends "Shpfy Shop Card"
{
    layout
    {
        addafter(RemoveProductAction)
        {
            field("Stock Mínimo"; Rec."Stock Mínimo")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if Rec."Stock Mínimo" < 0 then begin
                        ERROR('El stock mínimo no puede ser menor a 0');
                    end;
                end;
            }
            field("% Diferencia precio"; Rec."% Diferencia precio")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if rec."% Diferencia precio" < 0 then begin
                        ERROR('El % de diferencia de precio no puede ser menor a 0');
                    end;
                end;
            }
            //>> BBT. OBSOLETO. Se usa el almacén de la tabla estandar 'Shpfy Shop Location'
            /*  
            field("Main Location"; Rec."Main Location")
            {
                ApplicationArea = All;
            }
            */
            //<<
        }
        addafter(LanguageCode)
        {
            field(MarketPlace; Rec.MarketPlace)
            {
                ApplicationArea = All;
            }
            field("ID Marketplace"; Rec."ID Marketplace")
            {
                ApplicationArea = All;
            }
        }
        addafter(ReturnsAndRefunds)
        {
            group("Shopify API Settings")
            {
                Caption = 'Shopify API Settings', Comment = 'ESP="Configuración API Shopify"';

                field("API Shop URL"; Rec."API Shop URL")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("API Password"; Rec."API Password")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("API Secret"; Rec."API Secret")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("API Version"; Rec."API Version")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        addafter(CustomerDiscountGroup)
        {
            field("Customer Price Validation"; Rec."Customer Price Validation")
            {
                ApplicationArea = All;
            }
        }
    }
}
