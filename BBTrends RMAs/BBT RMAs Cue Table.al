table 51208 "RMAs Cue"
{
    Caption = 'RMAs Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "RMAs Package - Open"; Integer)
        {
            AccessByPermission = TableData "RMAs Package" = R;
            CalcFormula = count("RMAs Package" where("Registered Package" = const(False),
                                                      "Package Status" = const(Open)));
            Caption = 'Open', Comment = 'ESP="Abiertos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "RMAs Package - Closed"; Integer)
        {
            AccessByPermission = TableData "RMAs Package" = R;
            CalcFormula = count("RMAs Package" where("Registered Package" = const(False),
                                                      "Package Status" = const(Closed)));
            Caption = 'Closed', Comment = 'ESP="Cerrados"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "RMAs Package - Pending Qty"; Integer)
        {
            AccessByPermission = TableData "RMAs Package" = R;
            CalcFormula = count("RMAs Package Line" where("Registered Package" = const(true),
                                                        "Return Order No." = filter(<> ''),
                                                        Quantity = filter(> 0),
                                                        "Remaining Quantity" = filter(> 0)));
            Caption = 'Pendent Returns', Comment = 'ESP="Devoluciones Pendientes"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "RMAs Package - Posted"; Integer)
        {
            AccessByPermission = TableData "RMAs Posted Package" = R;
            CalcFormula = count("RMAs Posted Package");
            Caption = 'Posted', Comment = 'ESP="Registrados"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Transfer Orders"; Integer)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            CalcFormula = count("Transfer Header");
            Caption = 'Transfer Orders', Comment = 'ESP="Pedidos de Transferencia"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Package to be transferred"; Integer)
        {
            AccessByPermission = TableData "RMAs Stock Package" = R;
            CalcFormula = count("RMAs Stock Package" where("Package transferred" = const(false)));
            Caption = 'To be transferred', Comment = 'ESP="Bultos a Transferir"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Package registered"; Integer)
        {
            AccessByPermission = TableData "RMAs Posted Package" = R;
            CalcFormula = count("RMAs Posted Package" where("Fully Transferred" = const(false)));
            Caption = 'Posted', Comment = 'ESP="Registrados"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Package transferred"; Integer)
        {
            AccessByPermission = TableData "RMAs Posted Package" = R;
            CalcFormula = count("RMAs Stock Package" where("Package transferred" = const(true)));
            Caption = 'Transferred', Comment = 'ESP="Transferidos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Package Archived"; Integer)
        {
            AccessByPermission = TableData "RMAs Posted Package" = R;
            CalcFormula = count("RMAs Posted Package" where("Fully Transferred" = const(true)));
            Caption = 'Archived', Comment = 'ESP="Archivados"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Line Pendig Transfer"; Integer)
        {
            AccessByPermission = TableData "RMAs Posted Package Line" = R;
            CalcFormula = count("RMAs Posted Package Line" where("Fully Transferred" = const(false),
                                                        Quantity = filter(> 0),
                                                        Quality = filter('A' | 'B')));
            Caption = 'Units to Transfer', Comment = 'ESP="Unids. a Transferir"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Units Pendig Cr Memo"; Integer)
        {
            AccessByPermission = TableData "Return Receipt Line" = R;
            CalcFormula = count("Return Receipt Line" where(Type = filter(Item),
                                                        Quantity = filter(> 0),
                                                        "Return Qty. Rcd. Not Invd." = filter(> 0)));
            Caption = 'Units Pendig Cr Memo', Comment = 'ESP="Unids. pdtes Abonar"';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }

}

