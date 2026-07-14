page 51115 "BBT Item Excl Sales Matrix"
{
    Caption = 'Item Exclusive Sales Matrix', Comment = 'ESP="Venta Exclusiva Producto"';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field(ExclSelection; ExclSelection)
            {
                Caption = 'Selection', Comment = 'ESP="Selección"';
                ApplicationArea = All;
                Editable = false;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                Editable = EditableSelection;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Visible = Field1Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Visible = Field2Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Visible = Field3Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Visible = Field4Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Visible = Field5Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Visible = Field6Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Visible = Field7Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Visible = Field8Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    Visible = Field9Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    Visible = Field10Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    Visible = Field11Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    Visible = Field12Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    Visible = Field13Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    Visible = Field14Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    Visible = Field15Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    Visible = Field16Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    Visible = Field17Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    Visible = Field18Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    Visible = Field19Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    Visible = Field20Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    Visible = Field21Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    Visible = Field22Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    Visible = Field23Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    Visible = Field24Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    Visible = Field25Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    Visible = Field26Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    Visible = Field27Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    Visible = Field28Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    Visible = Field29Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    Visible = Field30Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    Visible = Field31Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(31);
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    Visible = Field32Visible;
                    trigger OnValidate()
                    begin
                        UpdateMatrixValue(32);
                    end;
                }
            }
        }
    }

    //actions
    //{
    //    area(processing)
    //    { }
    //}

    var
        rSMGCustomerClassification: Record "SMG Customer Classification";
        rSMGTempNationalGroup: Record "SMG Customer Classification" temporary;
        //
        rExclusivitySalesItems: Record "BBT Exclusivity Sales Items";
        MATRIX_ColumnCaption: array[32] of Text[30];
        MATRIX_Records: array[32] of Record "BBT Exclusivity Sales Items";
        MATRIX_CellData: array[32] of Boolean;
        //
        ExclSelection: Text;
        EditableSelection: Boolean;
        //
        MATRIX_CurrSetLength: Integer;
        Field1Visible: Boolean;
        Field2Visible: Boolean;
        Field3Visible: Boolean;
        Field4Visible: Boolean;
        Field5Visible: Boolean;
        Field6Visible: Boolean;
        Field7Visible: Boolean;
        Field8Visible: Boolean;
        Field9Visible: Boolean;
        Field10Visible: Boolean;
        Field11Visible: Boolean;
        Field12Visible: Boolean;
        Field13Visible: Boolean;
        Field14Visible: Boolean;
        Field15Visible: Boolean;
        Field16Visible: Boolean;
        Field17Visible: Boolean;
        Field18Visible: Boolean;
        Field19Visible: Boolean;
        Field20Visible: Boolean;
        Field21Visible: Boolean;
        Field22Visible: Boolean;
        Field23Visible: Boolean;
        Field24Visible: Boolean;
        Field25Visible: Boolean;
        Field26Visible: Boolean;
        Field27Visible: Boolean;
        Field28Visible: Boolean;
        Field29Visible: Boolean;
        Field30Visible: Boolean;
        Field31Visible: Boolean;
        Field32Visible: Boolean;

    trigger OnInit()
    begin
        Field32Visible := true;
        Field31Visible := true;
        Field30Visible := true;
        Field29Visible := true;
        Field28Visible := true;
        Field27Visible := true;
        Field26Visible := true;
        Field25Visible := true;
        Field24Visible := true;
        Field23Visible := true;
        Field22Visible := true;
        Field21Visible := true;
        Field20Visible := true;
        Field19Visible := true;
        Field18Visible := true;
        Field17Visible := true;
        Field16Visible := true;
        Field15Visible := true;
        Field14Visible := true;
        Field13Visible := true;
        Field12Visible := true;
        Field11Visible := true;
        Field10Visible := true;
        Field9Visible := true;
        Field8Visible := true;
        Field7Visible := true;
        Field6Visible := true;
        Field5Visible := true;
        Field4Visible := true;
        Field3Visible := true;
        Field2Visible := true;
        Field1Visible := true;
    end;

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        rSMGCustomerClassification.Reset();
        rSMGTempNationalGroup.Reset();
        rSMGTempNationalGroup.DeleteAll();
        rSMGCustomerClassification.SetRange(Type, rSMGCustomerClassification.Type::"National Group");
        if rSMGCustomerClassification.FindSet() then
            repeat
                rSMGTempNationalGroup := rSMGCustomerClassification;
                rSMGTempNationalGroup.Insert();
            until rSMGCustomerClassification.Next() = 0;

        MATRIX_CurrentColumnOrdinal := 0;
        MATRIX_CurrSetLength := rSMGTempNationalGroup.Count;

        rSMGTempNationalGroup.Reset();
        if rSMGTempNationalGroup.FindSet() then
            repeat begin
                MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                MATRIX_Records[MATRIX_CurrentColumnOrdinal]."Item No." := Rec."No.";
                MATRIX_Records[MATRIX_CurrentColumnOrdinal]."National Group" := rSMGTempNationalGroup.Code;

                MATRIX_ColumnCaption[MATRIX_CurrentColumnOrdinal] := rSMGTempNationalGroup.Code;

                rExclusivitySalesItems.Reset();
                rExclusivitySalesItems.SetRange("Item No.", Rec."No.");
                rExclusivitySalesItems.SetRange("National Group", rSMGTempNationalGroup.Code);
                rExclusivitySalesItems.SetRange(Related, true);
                if rExclusivitySalesItems.FindFirst() then
                    MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := rExclusivitySalesItems.Related
                else
                    MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := false;
            end;
            until rSMGTempNationalGroup.Next() = 0;

        SetVisible();
        CalculateSelection();
        SetEditableSelection();
        CurrPage.Update();
    end;

    local procedure UpdateMatrixValue(MatrixColumnIndex: Integer)
    begin
        rExclusivitySalesItems.Reset();
        rExclusivitySalesItems.SetRange("Item No.", MATRIX_Records[MatrixColumnIndex]."Item No.");
        rExclusivitySalesItems.SetRange("National Group", MATRIX_Records[MatrixColumnIndex]."National Group");
        if rExclusivitySalesItems.FindFirst() then
            rExclusivitySalesItems.Delete(false);

        if MATRIX_CellData[MatrixColumnIndex] then begin
            rExclusivitySalesItems.Reset();
            rExclusivitySalesItems."Item No." := MATRIX_Records[MatrixColumnIndex]."Item No.";
            rExclusivitySalesItems."National Group" := MATRIX_Records[MatrixColumnIndex]."National Group";
            rExclusivitySalesItems.Related := MATRIX_CellData[MatrixColumnIndex];
            rExclusivitySalesItems.Insert(false);
        end;
        Commit();
        CalculateSelection;

    end;

    procedure SetVisible()
    begin
        Field1Visible := MATRIX_CurrSetLength > 0;
        Field2Visible := MATRIX_CurrSetLength > 1;
        Field3Visible := MATRIX_CurrSetLength > 2;
        Field4Visible := MATRIX_CurrSetLength > 3;
        Field5Visible := MATRIX_CurrSetLength > 4;
        Field6Visible := MATRIX_CurrSetLength > 5;
        Field7Visible := MATRIX_CurrSetLength > 6;
        Field8Visible := MATRIX_CurrSetLength > 7;
        Field9Visible := MATRIX_CurrSetLength > 8;
        Field10Visible := MATRIX_CurrSetLength > 9;
        Field11Visible := MATRIX_CurrSetLength > 10;
        Field12Visible := MATRIX_CurrSetLength > 11;
        Field13Visible := MATRIX_CurrSetLength > 12;
        Field14Visible := MATRIX_CurrSetLength > 13;
        Field15Visible := MATRIX_CurrSetLength > 14;
        Field16Visible := MATRIX_CurrSetLength > 15;
        Field17Visible := MATRIX_CurrSetLength > 16;
        Field18Visible := MATRIX_CurrSetLength > 17;
        Field19Visible := MATRIX_CurrSetLength > 18;
        Field20Visible := MATRIX_CurrSetLength > 19;
        Field21Visible := MATRIX_CurrSetLength > 20;
        Field22Visible := MATRIX_CurrSetLength > 21;
        Field23Visible := MATRIX_CurrSetLength > 22;
        Field24Visible := MATRIX_CurrSetLength > 23;
        Field25Visible := MATRIX_CurrSetLength > 24;
        Field26Visible := MATRIX_CurrSetLength > 25;
        Field27Visible := MATRIX_CurrSetLength > 26;
        Field28Visible := MATRIX_CurrSetLength > 27;
        Field29Visible := MATRIX_CurrSetLength > 28;
        Field30Visible := MATRIX_CurrSetLength > 29;
        Field31Visible := MATRIX_CurrSetLength > 30;
        Field32Visible := MATRIX_CurrSetLength > 31;
    end;

    procedure CalculateSelection()
    begin
        Clear(ExclSelection);
        rExclusivitySalesItems.Reset();
        rExclusivitySalesItems.SetRange("Item No.", rec."No.");
        if rExclusivitySalesItems.FindSet() then
            repeat begin
                if ExclSelection = '' then
                    ExclSelection := rExclusivitySalesItems."National Group"
                else
                    ExclSelection := ExclSelection + '|' + rExclusivitySalesItems."National Group";
            end;
            until rExclusivitySalesItems.Next() = 0;
    end;

    procedure SetEditableSelection()
    var
        rUserSetup: Record "User Setup";
    begin
        EditableSelection := false;
        rUserSetup.Reset();
        if rUserSetup.Get(UserId) then
            if rUserSetup."Exclusive Ecomm Sales Allowed" then
                EditableSelection := true;
    end;
}