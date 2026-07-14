page 51217 "RMAs Management Role Center"

{
    Caption = 'RMAs Manager', Comment = 'ES="Gestión Devoluciones"';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part("RMAs Activities"; "RMAs Management Activities")
            {
                ApplicationArea = All;
            }
            part("RMAs Archived"; "RMAs Management Archives")
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        area(creation)
        {
            action("New Package")
            {
                ApplicationArea = All;
                Caption = 'New Package', Comment = 'ESP="Nuevo Bulto"';
                RunObject = Page "RMAs Package Card";
                RunPageMode = Create;
            }
        }
        /*
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                Image = New;
                action(Customer)
                {
                    AccessByPermission = TableData Customer = IMD;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageMode = Create;
                    ToolTip = 'Register a new customer.';
                }
            }
        }
        */
        area(embedding)
        {
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items', Comment = 'ESP="Productos"';
                RunPageMode = View;
                RunObject = Page "RMAs Item List";
            }
            action(SalesReturn)
            {
                ApplicationArea = All;
                Caption = 'Sales Return Orders', Comment = 'ESP="Devoluciones de Ventas"';
                RunPageMode = View;
                RunObject = Page "Sales Return Order List";
            }
        }
        area(sections)
        {
            group(Setup)
            {
                Caption = 'Setup', Comment = 'ESP="Configuración"';

                action(RMASetup)
                {
                    ApplicationArea = All;
                    Caption = 'RMA Setup', Comment = 'ESP="RMA Configuración"';
                    RunObject = Page "RMAs Setup Card";
                }
                action(RMAReturnReason)
                {
                    ApplicationArea = All;
                    Caption = 'RMA Return Reason', Comment = 'ESP="Motivo Devolución"';
                    RunObject = Page "RMAs Auxiliary Table Reason";
                }
                action(RMAReturnCategory)
                {
                    ApplicationArea = All;
                    Caption = 'RMA Return Category', Comment = 'ESP="Categoria Devolución"';
                    RunObject = Page "RMAs Auxiliary Table Category";
                }
                action(RMAReturnResource)
                {
                    ApplicationArea = All;
                    Caption = 'RMA Return Resource', Comment = 'ESP="Operarios Devolución"';
                    RunObject = Page "RMAs Return Resource List";
                }
            }
        }
    }
}

