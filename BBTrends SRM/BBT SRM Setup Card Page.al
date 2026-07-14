page 51351 "SRM Setup Card"
{
    ApplicationArea = All;
    Caption = 'Vendors Relationship Setup', Comment = 'ESP="Configuración de Relaciones con Proveedor"';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SRM Setup";
    UsageCategory = Administration;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Configuration)
            {
                Caption = 'Configuration', Comment = 'ESP="Configuración"';

                field("SRMEnabled"; rec."SRM Enabled")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        FieldEnable();
                        CurrPage.Update();
                    end;
                }
            }
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                Enabled = SRMEnabled;
                Visible = SRMEnabled;

                field("SRMTypeEnabled"; Rec."SRM Type Enabled")
                {
                    ApplicationArea = All;
                    Enabled = SRMEnabled;
                }
                field("SRMPerformanceEnabled"; Rec."SRM Performance Enabled")
                {
                    ApplicationArea = All;
                    //Enabled = SRMEnabled;
                    Enabled = false;
                    Visible = false;
                }
                field("SRMClassificationEnabled"; Rec."SRM Classification Enabled")
                {
                    ApplicationArea = All;
                    Enabled = SRMEnabled;

                    trigger OnValidate()
                    begin
                        FieldEnable();
                        CurrPage.Update();
                    end;
                }
            }
            group(Classification)
            {
                Caption = 'Classification', Comment = 'ESP="Clasificación"';
                Enabled = SRMEnabled and SRMClassificationEnabled;
                Visible = SRMEnabled and SRMClassificationEnabled;

                field(TextCountEvaluators; TextCountEvaluators)
                {
                    Caption = 'Evaluators', Comment = 'ESP="Evaluadores"';
                    ApplicationArea = All;
                    Enabled = SRMClassificationEnabled;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"SRM Evaluation Manager")
                    end;
                }
                field(TextCountClassification; TextCountClassification)
                {
                    Caption = 'Classifications', Comment = 'ESP="Clasificaciones"';
                    ApplicationArea = All;
                    Enabled = SRMClassificationEnabled;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"SRM Vendor Classification")
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EvaluationProcesing)
            {
                Caption = 'Evaluation Manager', Comment = 'ESP="Resp.Evaluación"';
                Enabled = SRMEnabled;
                ApplicationArea = All;
                Image = Evaluate;
                RunObject = Page "SRM Evaluation Manager";
                RunPageMode = View;
            }
            action(ClassificationProcesing)
            {
                Caption = 'Classification', Comment = 'ESP="Clasificación"';
                Enabled = SRMEnabled and SRMClassificationEnabled;
                ApplicationArea = All;
                Image = VendorBill;
                RunObject = Page "SRM Vendor Classification";
                RunPageMode = View;
            }
            action(VendorQuestionnaire)
            {
                Caption = 'Supplier Questionnaire', Comment = 'ESP="Cuestionarios"';
                Enabled = SRMEnabled;
                ApplicationArea = All;
                Image = ContactReference;
                RunObject = Page "Profile Questionnaires";
                RunPageView = where("Business Relation Code" = const('PROVEEDOR'));
                RunPageMode = View;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(Evaluation_Promoted; EvaluationProcesing)
                { }
                actionref(Classification_Promoted; ClassificationProcesing)
                { }
                actionref(Questionnaire_Process; VendorQuestionnaire)
                { }
            }
        }
    }

    var
        TextCountClassification: Text[8];
        TextCountEvaluators: Text[8];
        SRMClassificationEnabled: Boolean;
        SRMEnabled: Boolean;

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        FieldEnable();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("SRM Classification Count");
        TextCountClassification := Format(Rec."SRM Classification Count");
        Rec.CalcFields(Rec."SRM Evaluators Count");
        TextCountEvaluators := Format(Rec."SRM Evaluators Count");
    end;

    procedure FieldEnable();
    begin
        SRMEnabled := Rec."SRM Enabled";
        SRMClassificationEnabled := Rec."SRM Classification Enabled";
    end;
}