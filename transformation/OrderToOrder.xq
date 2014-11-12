(:: pragma bea:global-element-parameter parameter="$order1" element="ns0:Order" location="../xsd/order.xsd" ::)
(:: pragma bea:global-element-return element="ns0:Order" location="../xsd/order.xsd" ::)

declare namespace ns0 = "http://www.example.org/order";
declare namespace xf = "http://tempuri.org/OsbDemoProject/transformation/OrderToOrder/";

declare function xf:OrderToOrder($order1 as element(ns0:Order))
    as element(ns0:Order) {
        <ns0:Order>
            <ns0:Header>
                <ns0:OrderNr>{ data($order1/ns0:Header/ns0:OrderNr) }</ns0:OrderNr>
                <ns0:Datum>{ fn:current-date() }</ns0:Datum>
                <ns0:OrderTotaal>
                    {
                        data(fn:sum(
                        for $item in $order1/ns0:Data/ns0:OrderRegel
                        return $item/ns0:Prijs * $item/ns0:Aantal))
                    }
</ns0:OrderTotaal>
            </ns0:Header>
            <ns0:Data>
                {
                    for $OrderRegel in $order1/ns0:Data/ns0:OrderRegel
                    return
                        <ns0:OrderRegel>
                            <ns0:ProductID>{ data($OrderRegel/ns0:ProductID) }</ns0:ProductID>
                            <ns0:Aantal>{ data($OrderRegel/ns0:Aantal) }</ns0:Aantal>
                            <ns0:Prijs>{ data($OrderRegel/ns0:Prijs) }</ns0:Prijs>
                        </ns0:OrderRegel>
                }
            </ns0:Data>
        </ns0:Order>
};

declare variable $order1 as element(ns0:Order) external;

xf:OrderToOrder($order1)