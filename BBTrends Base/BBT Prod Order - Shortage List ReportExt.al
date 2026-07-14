reportextension 51102 "BBT Prod Ord Shortage List" extends "Prod. Order - Shortage List"
{

    dataset
    {
        modify("Prod. Order Component")
        {

            //RequestFilterFields = "Location Code";

            /*     */
            trigger OnBeforePreDataItem()
            begin
                //>> BBT 31/01/2025. Evitamos revisar solo existencia en el almacén del filtro
                //IF AlmComponentes <> '' THEN
                //    "Prod. Order Component".SETRANGE("Location Code", AlmComponentes);
                //<<
            end;
            /**/

            trigger OnAfterAfterGetRecord()
            begin
                //>> BBT 31/01/2025. Evitamos revisar solo existencia en el almacén del filtro
                if AlmComponentes <> '' then
                    "Prod. Order Component".SetFilter("Location Code", '=%1', AlmComponentes)
                else
                    "Prod. Order Component".SetFilter("Location Code", '=%1', '*');
                //<<
            end;
        }
    }

    requestpage
    {
        layout
        {
            /**/
            addfirst(Content)
            {
                field(AlmComponentes; AlmComponentes)
                {
                    Caption = 'Warehouse', comment = 'ESP="Almacén"';
                    ApplicationArea = All;
                }
            }
            /**/
        }

        actions
        { }

    }

    var
        AlmComponentes: Code[10];

    trigger OnPreReport()
    begin

    end;


}
