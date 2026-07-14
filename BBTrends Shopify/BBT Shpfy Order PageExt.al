pageextension 73102 "BBT Shpfy Order Ext" extends "Shpfy Order"
{
    DeleteAllowed = false;

    layout
    {
        modify(FinancialStatus)
        {
            Editable = true;
        }
        modify(SalesOrderNo)
        {
            Editable = true;
        }
        modify(Error)
        {
            Editable = true;
        }
        modify(ErrorMessage)
        {
            Editable = true;
        }
        modify(Processed)
        {
            Editable = false;
        }
        modify(Closed)
        {
            Editable = true;
        }
        modify(VATIncluded)
        {
            Editable = true;
        }
        modify(FulfillmentStatus)
        {
            Editable = true;
        }
        modify(ChannelName)
        {
            Editable = true;
        }
        modify(SellToCustomerName)
        {
            Editable = true;
        }
        modify(TemplCodeField)
        {
            Importance = Additional;
        }

        addafter(ShopifyOrderNo)
        {
            field("Channel Name"; Rec."Channel Name")
            {
                ApplicationArea = All;
            }
        }

        addbefore(Error)
        {
            field("Blocked per price"; Rec."Blocked per price")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Validado; Rec.Validado)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Risks)
        {
            action(Validate)
            {
                ApplicationArea = All;
                Caption = 'Validate', Comment = 'ESP="Validar"';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    cuShopifyMgt: Codeunit "BBT Shpfy Management";
                begin
                    cuShopifyMgt.ActualizaPedido(rec."Shopify Order Id");
                end;
            }
        }
    }
}
