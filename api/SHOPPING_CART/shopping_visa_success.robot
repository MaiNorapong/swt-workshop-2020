*** Settings ***
Library    RequestsLibrary
Suite Setup    Create Session    alias=shopping    url=https://dminer.in.th


*** Variables ***
&{CONTENT_TYPE_JSON}    Content-Type=application/json
&{ACCEPT_JSON}          Accept=application/json
${PRODUCT_ID}           2
${PRODUCT_NAME}         43 Piece dinner Set
${SHIPPING_METHOD}      Kerry


*** Test Cases***
User buy toys for children; select kerry as the delivery method; select VISA card as the payment method; successful payment
    Search
    Product Detail
    Submit Order
    Confirm Payment


*** Keywords ***
Search
    ${res}=    Get Request    alias=shopping    uri=/api/v1/product
    Request Should Be successful    ${res}
    
    # # From API specs (all at once)
    # ${respBody}=    To Json    {"total": 2,"products": [ {"id": 1,"product_name": "Balance Training Bicycle","product_price": 119.95,"product_image": "/Balance_Training_Bicycle.png" }, {"id": 2,"product_name": "43 Piece dinner Set","product_price": 12.95,"product_image": "/43_Piece_dinner_Set.png" } ]}
    # Run Keyword And Continue On Failure    Should Be Equal    ${res.json()}    ${respBody}

    # From API specs (individual)
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()['total']}    ${{int(2)}}
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()['products'][1]['product_name']}    ${PRODUCT_NAME}

Product Detail
    ${res}=    Get Request    alias=shopping    uri=/api/v1/product/${PRODUCT_ID}    headers=&{ACCEPT_JSON}
    Request Should Be successful    ${res}
    
    # From API specs
    ${respBody}=    To Json    {"id": 2,"product_name": "43 Piece dinner Set","product_price": 12.95,"product_image": "/43_Piece_dinner_Set.png","quantity": 7,"product_brand": "CoolKidz"}
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()}    ${respBody}

    # From Search
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()['id']}    ${{int(${PRODUCT_ID})}}
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()['product_name']}    ${PRODUCT_NAME}
    # Set Test Variable    ${QUANTITY_IN_STOCK}    ${res.json()['quantity']}
    # Set Test Variable    ${PRODUCT_PRICE}    ${res.json()['product_price']}


Submit Order
    ${reqBody}=    To Json    { "cart" : [ { "product_id": ${PRODUCT_ID}, "quantity": 1}],"shipping_method" : "${SHIPPING_METHOD}","shipping_address" : "405/37 ถ.มหิดล","shipping_sub_district" : "ต.ท่าศาลา","shipping_district" : "อ.เมือง","shipping_province" : "จ.เชียงใหม่","shipping_zip_code" : "50000","recipient_name" : "ณัฐญา ชุติบุตร","recipient_phone_number" : "0970809292"}
    ${res}=    Post Request    alias=shopping    uri=/api/v1/order    headers=&{CONTENT_TYPE_JSON}    json=${reqBody}
    Request Should Be successful    ${res}
    
    # From API specs
    ${respBody}=    To Json    {"order_id": 8004359122,"total_price": 121.95}
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()}    ${respBody}
    
    # For Confirm Payment
    Set Test Variable    ${ORDER_ID}    ${res.json()['order_id']}
    Set Test Variable    ${TOTAL_PRICE}    ${res.json()['total_price']}


Confirm Payment
    ${reqBody}=    To Json    {"order_id" : ${ORDER_ID},"payment_type" : "credit","type" : "visa","card_number" : "4719700591590995","cvv" : "752","expired_month" : 7,"expired_year" : 20,"card_name" : "Karnwat Wongudom","total_price" : ${TOTAL_PRICE}}
    ${res}=    Post Request    alias=shopping    uri=/api/v1/confirmPayment    headers=&{ACCEPT_JSON}    json=${reqBody}
    Request Should Be successful    ${res}
    
    # From API specs
    ${respBody}=    To Json    {"notify_message": "วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359123 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900"}
    Run Keyword And Continue On Failure    Should Be Equal    ${res.json()}    ${respBody}

    # From Submit Order
    Run Keyword And Continue On Failure    Should Contain    ${res.json()['notify_message']}    ${SHIPPING_METHOD}
