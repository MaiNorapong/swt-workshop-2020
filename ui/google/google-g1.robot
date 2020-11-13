*** Settings ***
Library    SeleniumLibrary

*** Variables ***

*** Test Cases ***
Test search keyword and verify search result on Google
    Type "google.com"
    Type keyword "US Election 2020"
    Press Enter
    Check link "US Election 2020 - BBC News"

*** Keywords ***
Type "google.com"
    Open Browser    https://www.google.com/  chrome

Type keyword "US Election 2020"
    Input Text    name:q    US Election 2020

Press Enter
    Press Keys    name:q    \n    RETURN
    # Click Element At Coordinates    id:viewport    10    10
    # Click Element    name:btnK

Check link "US Election 2020 - BBC News"
    Page Should Contain    US Election 2020 - BBC News
    # Wait Until Page Contains    US Election 2020 - BBC News
    # Close Browser
