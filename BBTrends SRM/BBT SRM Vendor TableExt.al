TableExtension 51351 "SMG Vendor" extends Vendor
{
    fields
    {
        field(51351; "SRM Vendor Type"; Enum "SRM Vendor Type")
        {
            Caption = 'Vendor Type', Comment = 'ESP="Tipo Proveedor"';
        }
        field(51352; "SRM Vendor Performance"; Enum "SRM Vendor Performance")
        {
            Caption = 'Vendor Performance', Comment = 'ESP="Eficiencia Proveedor"';
        }
        field(51353; "SRM Vendor Classification"; Text[50])
        {
            Caption = 'Vendor Classification', Comment = 'ESP="Clasificación Provedor"';
            TableRelation = "SRM Vendor Classification";
        }
        field(51354; "SRM Evaluation Manager"; Text[50])
        {
            Caption = 'Evaluation Manager', Comment = 'ESP="Responsable Evaluación"';
            TableRelation = "SRM Evaluation Manager";
        }
        field(51355; "SRM Last Evaluation Date"; Date)
        {
            Caption = 'Last Evaluation Date', Comment = 'ESP="Ultima Evaluación"';
        }
    }
}