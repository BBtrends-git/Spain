Page 51202 "RMAs Package Card"
{
    Caption = 'Sales Return Package Card', Comment = 'ESP="Bulto Devolución Ventas"';
    PageType = Document;
    SourceTable = "RMAs Package";
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;

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
                            rRMAPackageLine.Reset();
                            rRMAPackageLine.SetRange("Package No.", rec."Package No.");
                            rRMAPackageLine.SetRange(Quantity, 0);
                            if rRMAPackageLine.FindFirst() then
                                Error(Error04);
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
                    Editable = false;
                }
            }
            part(PackageSubform; "RMAs Package Subform")
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
    {
        area(navigation)
        {
            action(Posting)
            {
                ApplicationArea = All;
                Caption = 'Posting', comment = 'ESP="Registro"';
                Image = PostingEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = NotRegistered and not FieldsEditable;

                trigger OnAction()
                var
                    cuRMASManagement: Codeunit "RMAs Management";
                    Text01: Label 'Do you want to post the package lines?', Comment = 'ESP="¿Quiere registrar las líneas del bulto?"';
                    Text02: Label 'The package lines were successfully posted', Comment = 'ESP="Las líneas del bulto se registraron correctamente."';
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
                                Error(Error02);
                        End;
                    end;

                    if not Confirm(Text01, false) then exit;
                    cuRMASManagement.ReturnAdjustment(Rec, 0);
                    CurrPage.Close();
                end;
            }
        }
    }

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
        Error04: Label 'It is not permitted to close packages with lines without quantity.', Comment = 'ESP="No se permite cerrar bultos con lineas sin cantidad."';
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

        if Rec."Package No." = '' then
            Rec."Package No." := createpackagecode;

        EditNumbersPackages := false;
        if not (Rec."Package Type" = rec."Package Type"::Pallet) then
            EditNumbersPackages := true;
        FieldsEditable := false;
        if Rec."Package Status" = Rec."Package Status"::Open then
            FieldsEditable := true;
        NotRegistered := false;
        If not Rec."Registered Package" then
            NotRegistered := true;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", Rec."Package No.");
        if rRMAPackageLine.FindSet() then
            repeat
                rRMAPackageLine.Delete();
            until rRMAPackageLine.Next() = 0;
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
    /* este proceso se está ralizando en la CU RMAs Management al final del proceso de registro
    // a futuro se puede borrar de aqui
    trigger OnClosePage()
    var
        rRMAPackageAux: Record "RMAs Package";
        rRMAPackageLineAux: Record "RMAs Package Line";
        ToDelete: Boolean;
    begin
        // Revisamos que no queden bultos completamente registrados sin borrar.
        // Si el bulto está registrado y no hay lineas con cantidades pendientes se borra completamente.El bulto ya está posted.
        rRMAPackageAux.Reset();
        rRMAPackageAux.SetRange("Registered Package", true);
        if rRMAPackageAux.FindSet() then
            repeat begin
                ToDelete := true;
                rRMAPackageLineAux.Reset();
                rRMAPackageLineAux.SetRange("Package No.", rRMAPackageAux."Package No.");
                if rRMAPackageLineAux.FindSet() then
                    repeat
                        if (rRMAPackageLineAux."Remaining Quantity" <> 0) then
                            ToDelete := false;
                    until rRMAPackageLineAux.Next() = 0;
                if ToDelete then begin
                    if rRMAPackageLineAux.FindSet() then
                        repeat
                            rRMAPackageLineAux.Delete();        // Borramos lineas
                        until rRMAPackageLineAux.Next() = 0;
                    rRMAPackageAux.Delete();                    // Borramos cabecera
                end;
            end;
            until rRMAPackageAux.Next() = 0;
    end;
    */
    local procedure createpackagecode(): Code[50]
    var
        rRMAPackageAux: record "RMAs Package";
        rRMAPostedPackageAux: record "RMAs Posted Package";
        rRMAPackageTmp: record "RMAs Package" temporary;
        Day: text[2];
        Month: Text[2];
        Year: Text[4];
        TxtDate: text[8];
        PackageCode: Code[50];
        MinPackageCode: Code[50];
        MaxPackageCode: Code[50];

        ii: Integer;
    begin
        Day := format(Date2DMY(Today, 1));
        If Date2DMY(Today, 1) < 10 then
            Day := '0' + Day;
        Month := format(Date2DMY(Today, 2));
        If Date2DMY(Today, 2) < 10 then
            Month := '0' + Month;
        Year := format(Date2DMY(Today, 3));
        TxtDate := Year + Month + Day;
        MinPackageCode := TxtDate + '0001';
        MaxPackageCode := TxtDate + '999999';
        PackageCode := MinPackageCode;

        rRMAPackageAux.Reset();
        rRMAPackageAux.SetFilter("Package No.", '%1..%2', MinPackageCode, MaxPackageCode);
        if rRMAPackageAux.FindSet() then
            repeat begin
                rRMAPackageTmp.Init();
                rRMAPackageTmp."Package No." := rRMAPackageAux."Package No.";
                rRMAPackageTmp.Insert();
            end;
            until rRMAPackageAux.Next() = 0;

        rRMApostedPackageAux.Reset();
        rRMApostedPackageAux.SetFilter("Posted Package No.", '%1..%2', MinPackageCode, MaxPackageCode);
        if rRMApostedPackageAux.FindSet() then
            repeat begin
                rRMAPackageTmp.Reset();
                rRMAPackageTmp.SetRange("Package No.", rRMApostedPackageAux."Posted Package No.");
                if not rRMAPackageTmp.FindFirst() then begin
                    rRMAPackageTmp.Init();
                    rRMAPackageTmp."Package No." := rRMApostedPackageAux."Posted Package No.";
                    rRMAPackageTmp.Insert();
                end;
            end;
            until rRMApostedPackageAux.Next() = 0;

        rRMAPackageTmp.Reset();
        rRMAPackageTmp.SetFilter("Package No.", '%1..%2', MinPackageCode, MaxPackageCode);
        if rRMAPackageTMP.FindLast() then begin
            Evaluate(ii, CopyStr(rRMAPackageTmp."Package No.", 9, 4));
            ii := ii + 1;
            case ii of
                1 .. 9:
                    PackageCode := TxtDate + '000' + format(ii);
                10 .. 99:
                    PackageCode := TxtDate + '00' + format(ii);
                100 .. 999:
                    PackageCode := TxtDate + '0' + format(ii);
                1000 .. 9999:
                    PackageCode := TxtDate + format(ii);
                else
                    Error('');
            end;
        end;

        exit(PackageCode);

    end;
}