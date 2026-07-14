PageExtension 50252 "BBT Production BOM" extends "Production BOM"
{
    actions
    {
        addafter("Where-used")
        {
            action("Crear versión 0")
            {
                ApplicationArea = Basic;
                Image = CreateMovement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProductionBOMVersion: Record "Production BOM Version";
                    ProductionBOMLine: Record "Production BOM Line";
                    ProductionBOMLineVersion: Record "Production BOM Line";
                begin
                    //04/07/19 TC-004 Crear versión 0
                    ProductionBOMVersion.Reset;
                    ProductionBOMVersion.SetRange("Production BOM No.", Rec."No.");
                    ProductionBOMVersion.SetRange("Version Code", '0');
                    if ProductionBOMVersion.FindSet then
                        Error('Ya existe la versión 0')
                    else begin
                        ProductionBOMVersion.Reset;
                        ProductionBOMVersion."Production BOM No." := Rec."No.";
                        ProductionBOMVersion."Version Code" := '0';
                        ProductionBOMVersion.Description := Rec.Description;
                        ProductionBOMVersion."Starting Date" := 20010101D;
                        ProductionBOMVersion."Unit of Measure Code" := Rec."Unit of Measure Code";
                        ProductionBOMVersion.Status := ProductionBOMVersion.Status::Certified;
                        ProductionBOMVersion.Insert;
                        ProductionBOMLine.Reset;
                        ProductionBOMLine.SetRange("Production BOM No.", Rec."No.");
                        ProductionBOMLine.SetRange(ProductionBOMLine."Version Code", '');
                        if ProductionBOMLine.FindSet then
                            repeat
                                ProductionBOMLineVersion.Copy(ProductionBOMLine);
                                ProductionBOMLineVersion."Version Code" := '0';
                                ProductionBOMLineVersion.Insert;
                            until ProductionBOMLine.Next = 0;
                    end;
                    //04/07/19 TC-004 Crear versión 0
                end;
            }
        }
    }
    var
        ActiveFromVersionCode: Code[20];

    var
        ProductionBOMVersion: Record "Production BOM Version";
}
