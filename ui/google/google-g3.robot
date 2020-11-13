*** Settings ***
Library    SeleniumLibrary
Resource    resource-g3.robot

*** Test Cases ***
Test search keyword and verify search result on Google
    Go to search engine
    Type in query
    Press Enter
    Check search contains expected result
