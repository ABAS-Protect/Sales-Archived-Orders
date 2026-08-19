/*
    Author: Niklas Dougherty <nd@abas.se>
    Date: 2026-08-19
    Description: Find Sales orders and Archived sales orders.
*/
codeunit 50102 "Item Order Finder"
{
    procedure GetOrdersContainingItem(ItemNo: Code[10]; var TempSalesLineBuffer: Record "Sales Line" temporary)
    var
        SalesLine: Record "Sales Line";
        SalesLineArchive: Record "Sales Line Archive";
        TempVarBuffer: Record "Variant Filter Buffer" temporary;
        NextLineNo: Integer;
    begin
        TempSalesLineBuffer.Reset();
        TempSalesLineBuffer.DeleteAll();
        NextLineNo := 10000;

        TempVarBuffer.Reset();
        TempVarBuffer.DeleteAll();

        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", ItemNo);
        if SalesLine.FindSet() then
            repeat
                TempSalesLineBuffer.Init();
                TempSalesLineBuffer."Customer Project Code" := TempSalesLineBuffer."Customer Project Code"::ACTIVE;

                case SalesLine."Document Type" of
                    SalesLine."Document Type"::Quote:
                        TempSalesLineBuffer."Custom Finder Doc Type" := TempSalesLineBuffer."Custom Finder Doc Type"::QUOTE;
                    SalesLine."Document Type"::Order:
                        TempSalesLineBuffer."Custom Finder Doc Type" := TempSalesLineBuffer."Custom Finder Doc Type"::ORDER;
                    SalesLine."Document Type"::"Return Order":
                        TempSalesLineBuffer."Custom Finder Doc Type" := TempSalesLineBuffer."Custom Finder Doc Type"::"RETURN ORDER";
                end;

                TempSalesLineBuffer."Bill-to Customer No." := SalesLine."Document No.";
                TempSalesLineBuffer."No." := SalesLine."No.";
                TempSalesLineBuffer.Description := SalesLine.Description;
                TempSalesLineBuffer.Quantity := SalesLine.Quantity;

                TempSalesLineBuffer."Custom Finder Variant Code" := SalesLine."Variant Code";

                if SalesLine."Variant Code" <> '' then begin
                    TempVarBuffer."Variant Code" := SalesLine."Variant Code";
                    if TempVarBuffer.Insert() then;
                end;

                TempSalesLineBuffer."Document Type" := TempSalesLineBuffer."Document Type"::Order;
                TempSalesLineBuffer."Document No." := 'TEMP';
                TempSalesLineBuffer."Line No." := NextLineNo;
                NextLineNo += 10000;
                TempSalesLineBuffer.Insert();
            until SalesLine.Next() = 0;

        SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
        SalesLineArchive.SetRange("No.", ItemNo);
        if SalesLineArchive.FindSet() then
            repeat
                TempSalesLineBuffer.Init();
                TempSalesLineBuffer."Customer Project Code" := TempSalesLineBuffer."Customer Project Code"::ARCHIVE;

                case SalesLineArchive."Document Type" of
                    SalesLineArchive."Document Type"::Quote:
                        TempSalesLineBuffer."Custom Finder Doc Type" := TempSalesLineBuffer."Custom Finder Doc Type"::QUOTE;
                    SalesLineArchive."Document Type"::Order:
                        TempSalesLineBuffer."Custom Finder Doc Type" := TempSalesLineBuffer."Custom Finder Doc Type"::ORDER;
                    SalesLineArchive."Document Type"::"Return Order":
                        TempSalesLineBuffer."Custom Finder Doc Type" := TempSalesLineBuffer."Custom Finder Doc Type"::"RETURN ORDER";
                end;

                TempSalesLineBuffer."Bill-to Customer No." := SalesLineArchive."Document No.";
                TempSalesLineBuffer."No." := SalesLineArchive."No.";
                TempSalesLineBuffer.Description := SalesLineArchive.Description;
                TempSalesLineBuffer.Quantity := SalesLineArchive.Quantity;

                TempSalesLineBuffer."Custom Finder Variant Code" := SalesLineArchive."Variant Code";

                if SalesLineArchive."Variant Code" <> '' then begin
                    TempVarBuffer."Variant Code" := SalesLineArchive."Variant Code";
                    if TempVarBuffer.Insert() then;
                end;

                TempSalesLineBuffer."Document Type" := TempSalesLineBuffer."Document Type"::Order;
                TempSalesLineBuffer."Document No." := 'TEMP';
                TempSalesLineBuffer."Line No." := NextLineNo;
                NextLineNo += 10000;
                TempSalesLineBuffer.Insert();
            until SalesLineArchive.Next() = 0;

        PopulateGlobalLookupCache(TempVarBuffer);
    end;

    local procedure PopulateGlobalLookupCache(var TempSource: Record "Variant Filter Buffer" temporary)
    var
        GlobalLookupStore: Record "Variant Filter Buffer";
    begin
        GlobalLookupStore.Reset();
        GlobalLookupStore.DeleteAll();
        if TempSource.FindSet() then
            repeat
                GlobalLookupStore.Init();
                GlobalLookupStore := TempSource;
                GlobalLookupStore.Insert();
            until TempSource.Next() = 0;
    end;
}
