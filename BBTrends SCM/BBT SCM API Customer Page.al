page 51251 "SCM API Customer"
{
    PageType = API;
    Caption = 'SCM Customer';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmcustomer';
    EntitySetName = 'scmcustomers';
    SourceTable = Customer;
    Editable = false;
    DelayedInsert = false;
    //>> BBT 08/05/2026
    //   Los campos de clasificación están em la extensión SMG.
    //   En Polonia está extensión no está instalada
    //   Para evitar usar una extensión 'duplicada' se recuperan los campos de SMG a
    //   una tabla temporal y para Polonia se usan los antiguos. 
    SourceTableTemporary = true; // Trabajamos en memoria para evitar errores de esquema
    //<<

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Codigo"; Rec."No.")
                { }
                field("Nombre"; Rec.Name)
                { }
                //>>BBT 08/05/2026
                /*
                field("GrupoCompra"; Rec."SMG Purchase Group")
                { }
                field("TipoCliente"; Rec."SMG Customer Type")
                { }
                field("GrupoNacional"; Rec."SMG National Group")
                { }
                field("Plataforma"; Rec."SMG Platform")
                { }
                */
                //  Campos dinámicos (Var)
                field("GrupoCompra"; VarPurchaseGroup)
                { }
                field("TipoCliente"; VarCustomerType)
                { }
                field("GrupoNacional"; VarNationalGroup)
                { }
                field("Plataforma"; VarPlatform)
                { }
                //<<
            }
        }
    }

    var
        VarPurchaseGroup: Text;
        VarCustomerType: Text;
        VarPlatform: Text;
        VarNationalGroup: Text;

    trigger OnOpenPage()
    var
        rCustomer: Record Customer;
    begin
        if rCustomer.FindSet() then
            repeat
                Rec.Init();
                Rec.TransferFields(rCustomer);  // Campos estandar BC 
                Rec.Insert();
            until rCustomer.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    begin
        ReadDynamicFields();
    end;

    local procedure ReadDynamicFields()
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        Clear(VarPurchaseGroup);
        Clear(VarCustomerType);
        Clear(VarPlatform);
        Clear(VarNationalGroup);

        RecRef.GetTable(Rec);

        VarPurchaseGroup := GetFieldValueByName(Rec, 'SMG Purchase Group');
        VarCustomerType := GetFieldValueByName(Rec, 'SMG Customer Type');
        VarPlatform := GetFieldValueByName(Rec, 'SMG Platform');
        VarNationalGroup := GetFieldValueByName(Rec, 'SMG National Group');

    end;

    local procedure GetFieldValueByName(pCustomer: Record Customer; FieldName: Text): Text
    var
        rField: Record Field;
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        rField.SetRange(TableNo, Database::Customer);
        rField.SetRange(FieldName, FieldName);
        if rField.FindFirst() then begin
            RecRef.GetTable(pCustomer);
            FldRef := RecRef.Field(rField."No.");
            exit(Format(FldRef.Value));
        end
        else
            exit('');
    end;

}
