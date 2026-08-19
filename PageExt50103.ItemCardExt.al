/*
    Author: Niklas Dougherty <nd@abas.se>
    Date: 2026-08-19
    Description: Sales & Archived Orders menu in Related/Sales.
*/
pageextension 50103 "Item Card Ext" extends "Item Card"
{
    actions
    {
        addlast(Sales)
        {
            action(ListOrdersContainingItem)
            {
                ApplicationArea = All;
                Caption = 'ABAS Sales & Archived Orders';
                Image = Document;
                ToolTip = 'View all active and archived sales orders that contain this item.';

                trigger OnAction()
                var
                    ItemOrderFinder: Codeunit "Item Order Finder";
                    TempSalesLineBuffer: Record "Sales Line" temporary;
                    ItemOrderList: Page "Item Order Finder List";
                begin
                    ItemOrderFinder.GetOrdersContainingItem(Rec."No.", TempSalesLineBuffer);
                    ItemOrderList.SetData(TempSalesLineBuffer);
                    ItemOrderList.Run();
                end;
            }
        }
    }
}