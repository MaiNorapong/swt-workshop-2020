*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://www.google.com/
${BROWSER}            chrome
${QUERY}              US Election 2020
${EXPECTED_RESULT}    US Election 2020 - BBC News

*** Test Cases ***
Test search keyword and verify search result on Google
    Go to search engine
    Type in query
    Press Enter
    Check search contains expected result

*** Keywords ***
Go to search engine
    Open Browser    ${URL}    ${BROWSER}

Type in query
    Input Text    name:q    ${QUERY}

Press Enter
    Press Keys    name:q    \n    RETURN
    # Click Element At Coordinates    id:viewport    10    10
    # Click Element    name:btnK

Check search contains expected result
    Page Should Contain    ${EXPECTED_RESULT}
    # Wait Until Page Contains    ${EXPECTED_RESULT}
    Close Browser
