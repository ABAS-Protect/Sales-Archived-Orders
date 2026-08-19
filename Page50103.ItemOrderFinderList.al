/*
    Author: Niklas Dougherty <nd@abas.se>
    Date: 2026-08-19
    Description: Find Sales orders and Archived sales orders.
*/
page 50103 "Item Order Finder List"
{
    PageType = Worksheet;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    Caption = 'ABAS Sales & Archived Orders';

    UsageCategory = Lists;
    ApplicationArea = All;
    AdditionalSearchTerms = 'item order history, sales archive lookup';

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(SearchCriteria)
            {
                Caption = 'Search Criteria';

                field("Search Item No."; SearchItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Select or type an Item No. to find all active and archived sales lines.';
                    TableRelation = Item;

                    trigger OnValidate()
                    begin
                        if SearchItemNo <> '' then begin
                            CalculateData(SearchItemNo);
                        end else begin
                            Rec.Reset();
                            Rec.DeleteAll();
                        end;
                        CurrPage.Update(false);
                    end;
                }
            }

            repeater(Group)
            {
                Editable = false;

                field("Document Type"; Rec."Custom Finder Doc Type")
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                }
                field("Order No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesHeaderArchive: Record "Sales Header Archive";
                        TargetDocType: Enum "Sales Document Type";
                    begin
                        case Rec."Custom Finder Doc Type" of
                            Rec."Custom Finder Doc Type"::QUOTE:
                                TargetDocType := TargetDocType::Quote;
                            Rec."Custom Finder Doc Type"::ORDER:
                                TargetDocType := TargetDocType::Order;
                            Rec."Custom Finder Doc Type"::"RETURN ORDER":
                                TargetDocType := TargetDocType::"Return Order";
                        end;

                        if Rec."Customer Project Code" = Rec."Customer Project Code"::ACTIVE then begin
                            if SalesHeader.Get(TargetDocType, Rec."Bill-to Customer No.") then
                                Page.Run(Page::"Sales Order", SalesHeader);
                        end else if Rec."Customer Project Code" = Rec."Customer Project Code"::ARCHIVE then begin
                            SalesHeaderArchive.SetRange("Document Type", TargetDocType);
                            SalesHeaderArchive.SetRange("No.", Rec."Bill-to Customer No.");
                            if SalesHeaderArchive.FindFirst() then
                                Page.Run(Page::"Sales Order Archive", SalesHeaderArchive);
                        end;
                    end;
                }
                field("Customer project code"; Rec."Customer Project Code")
                {
                    ApplicationArea = All;
                    Caption = 'Customer project code';
                }

                field("Variant Code"; Rec."Custom Finder Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
            }
        }
    }

    var
        SearchItemNo: Code[20];

    procedure SetData(var SourceTempSalesLine: Record "Sales Line" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if SourceTempSalesLine.FindSet() then
            repeat
                Rec := SourceTempSalesLine;
                Rec.Insert();
            until SourceTempSalesLine.Next() = 0;

        if Rec.FindFirst() then
            SearchItemNo := Rec."No.";
    end;

    local procedure CalculateData(TargetItemNo: Code[20])
    var
        ItemOrderFinder: Codeunit "Item Order Finder";
        TempLineBuffer: Record "Sales Line" temporary;
    begin
        ItemOrderFinder.GetOrdersContainingItem(TargetItemNo, TempLineBuffer);

        Rec.Reset();
        Rec.DeleteAll();
        if TempLineBuffer.FindSet() then
            repeat
                Rec := TempLineBuffer;
                Rec.Insert();
            until TempLineBuffer.Next() = 0;
    end;
}