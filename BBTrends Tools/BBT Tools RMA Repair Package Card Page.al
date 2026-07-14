Page 59005 "BBT Tool Repair Package Card"
{
    Caption = 'RMA Repair Package Card';
    PageType = Document;
    SourceTable = "RMAs Package";
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    UsageCategory = Administration;
    SourceTableView = WHERE("Registered Package" = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    Editable = FieldsEditable;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Package Type"; Rec."Package Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = FieldsEditable;

                    trigger OnValidate()
                    begin
                        Rec."Numbers Packages" := 1;
                        EditNumbersPackages := true;
                        if Rec."Package Type" = rec."Package Type"::Pallet then
                            EditNumbersPackages := false;
                        CurrPage.Update;
                    end;
                }
                field("Numbers Packages"; Rec."Numbers Packages")
                {
                    ApplicationArea = All;
                    Editable = (FieldsEditable and EditNumbersPackages);
                }
                field("Return Category"; Rec."Return Category")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = FieldsEditable;
                }
                field("Package Status"; Rec."Package Status")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = NotRegistered;

                    trigger OnValidate()
                    begin
                        // No se permite cerrar bultos con líneas sin devolución
                        if Rec."Package Status" = Rec."Package Status"::Closed then begin
                            rRMASetup.Reset();
                            rRMASetup.get();
                            if not rRMASetup."Adjustments Without Returns" then begin
                                rRMAPackageLine.Reset();
                                rRMAPackageLine.SetRange("Package No.", rec."Package No.");
                                rRMAPackageLine.SetFilter("Return Order No.", '=%1', '');
                                if rRMAPackageLine.FindFirst() then
                                    Error(Error01);
                            end
                            else begin
                                rRMAPackageLine.Reset();
                                rRMAPackageLine.SetRange("Package No.", rec."Package No.");
                                rRMAPackageLine.SetFilter("Return Order No.", '=%1', '');
                                rRMAPackageLine.SetFilter("Incident Reason", '=%1', '');
                                if rRMAPackageLine.FindFirst() then
                                    Error(Error03);
                            end;
                        end;

                        FieldsEditable := false;
                        if Rec."Package Status" = Rec."Package Status"::Open then
                            FieldsEditable := true;
                        //CurrPage.Update;
                        CurrPage.Close();
                    end;
                }
                field("Registered Package"; Rec."Registered Package")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                }
            }
            part(PackageSubform; "BBT Tool Repair Pack Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = FieldsEditable;
                Enabled = true;
                SubPageLink = "Package No." = field("Package No.");
                UpdatePropagation = Both;
            }

        }
        area(factboxes)
        {
            part(ReturnInfoFaxbox; "RMAs Return Info Faxbox")
            {
                ApplicationArea = Suite;
                Provider = PackageSubform;
                SubPageLink = "No." = field("Return Order No.");
            }
            part(ReturnItemFaxbox; "RMAs Return Item Faxbox")
            {
                ApplicationArea = Suite;
                Provider = PackageSubform;
                SubPageLink = "Package No." = field("Package No."), "Item No." = field("Item No.");
            }
            part(ReturnCommentFaxbox; "RMAs Item Comment Lines Faxbox")
            {
                ApplicationArea = Suite;
                Provider = PackageSubform;
                SubPageLink = "Table Name" = filter(Item), "No." = field("Item No.");
            }
        }
    }
    actions
    { }

    var
        rRMASetup: Record "RMAs Setup";
        rSalesReturn: Record "Sales Header";
        rRMAPackage: Record "RMAs Package";
        rRMAPackageLine: Record "RMAs Package Line";
        EditNumbersPackages: Boolean;
        FieldsEditable: Boolean;
        NotRegistered: Boolean;
        InitStatusOpen: Boolean;

        Error01: Label 'It is not permitted to close packages with lines without a sales return number', Comment = 'ESP="No se permite cerrar bultos con lineas sin devolución"';
        Error02: Label 'It is not permitted to posted packages with lines without a sales return number', Comment = 'ESP="No se permite registrar bultos con lineas sin devolución"';
        Error03: Label 'The regularization without refund must include the reason for the incident', Comment = 'ESP="La regularización sin devolución deberá incluir el motivo de la incidencia"';
        Confirm01: Label 'There are no outstanding quantities. Do you want to completely archived the package?', Comment = 'ESP="No existen cantidades pendientes. Desea archivar completamente el bulto?"';


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Creation Date" := Today;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Clear(InitStatusOpen);
        if Rec."Package Status" = rec."Package Status"::Open then
            InitStatusOpen := true;

        EditNumbersPackages := false;
        if not (Rec."Package Type" = rec."Package Type"::Pallet) then
            EditNumbersPackages := true;
        //FieldsEditable := false;
        //if Rec."Package Status" = Rec."Package Status"::Open then
        FieldsEditable := true;
        NotRegistered := false;
        If not Rec."Registered Package" then
            NotRegistered := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Rec."Registered Package" then
            if not InitStatusOpen and (Rec."Package Status" = rec."Package Status"::Closed) then begin
                rRMAPackageLine.Reset();
                rRMAPackageLine.SetRange("Package No.", Rec."Package No.");
                if not rRMAPackageLine.IsEmpty then begin
                    rRMAPackageLine.SetFilter("Remaining Quantity", '<>%1', 0);
                    if not rRMAPackageLine.FindFirst() then
                        if Confirm(Confirm01, false) then begin
                            Rec."Registered Package" := true;
                            Rec.Modify();
                        end;
                end;
            end;
    end;
}