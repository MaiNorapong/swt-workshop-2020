*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL}                 https://www.dminer.in.th/Product-list.html
${PRODUCT_NAME}        43 Piece Dinner Set
${PRODUCT_BRAND}       CoolKidz
${PRODUCT_GENDER}      UNISEX
${PRODUCT_AGE}         13+
${PRODUCT_PRICE}       12.95
${PRODUCT_QUALITY}     3
${TOTAL_PRICE}         ${{ ${PRODUCT_PRICE} * ${PRODUCT_QUALITY} }}
${SHIPPING_METHOD}     Kerry
${SHIPPING_PRICE}      2.00
${TOTAL_AMOUNT}        ${{ ${TOTAL_PRICE} + ${SHIPPING_PRICE} }}


*** Test Cases***
User buy toys for children; select kerry as the delivery method; select VISA card as the payment method; successful payment
    Show products
    Show product details
    Show buy amount
    Confirm payment using VISA card
    Thank you


*** Keywords ***
Show products
    Open Browser    ${URL}    chrome
    # Page Should Contain    43 Piece Dinner Set
    Element Should Contain    id=PRODUCT_NAME-1    expected=${PRODUCT_NAME}
    Element Should Contain    id=PRODUCT_PRICE-1    expected=${PRODUCT_PRICE}

Show product details
    Click Element    id=viewMore-1
    Wait Until Page Contains Element    id=PRODUCT_NAME
    Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_NAME    expected=${PRODUCT_NAME}
    Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_BRAND    ${PRODUCT_BRAND}
    Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_GENDER    ${PRODUCT_GENDER}
    Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_AGE    ${PRODUCT_AGE}
    Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_PRICE    expected=${PRODUCT_PRICE} USD
    Input Text    id=PRODUCT_QUALITY    ${PRODUCT_QUALITY}
    Click Element    id=addToCart

Show buy amount
    Wait Until Page Contains Element    id=PRODUCT_QUALITY-1
    ${value}=    Get Element Attribute    id=PRODUCT_QUALITY-1    value
    Run Keyword And Continue On Failure    Should Be True	   "test PRODUCT_QUALITY-1:value=$PRODUCT_QUALITY" and ${value}==${PRODUCT_QUALITY}
    # Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_QUALITY-1    ${PRODUCT_QUALITY}
    Run Keyword And Continue On Failure    Element Should Contain    id=PRODUCT_PRICE-1    ${PRODUCT_PRICE}
    Run Keyword And Continue On Failure    Element Should Contain    id=totalPRODUCT_PRICE    ${{f"{ ${TOTAL_PRICE} :.2f}"}} USD
    Run Keyword And Continue On Failure    Element Should Contain    id=totalShippingCharge    ${SHIPPING_PRICE} USD
    Run Keyword And Continue On Failure    Element Should Contain    id=TOTAL_AMOUNT    ${{f"{ ${TOTAL_AMOUNT} :.2f}"}} USD
    Click Element    id=confirmPayment

Confirm payment using VISA card
    Wait Until Page Contains Element    id=TOTAL_PRICE
    Run Keyword And Continue On Failure    Element Should Contain    id=TOTAL_PRICE    ${{f"{ ${TOTAL_AMOUNT} :.2f}"}} USD
    Click Element    id=Payment

Thank you
    Wait Until Page Contains Element    id=notify
    Element Should Contain    id=notify    expected=${SHIPPING_METHOD}
