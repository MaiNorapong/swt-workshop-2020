*** Settings ***
Library    SeleniumLibrary
Resource    facebook-credentials.robot

*** Variables ***

*** Test Cases ***
Test posting on facebook
    Go to https://www.facebook.com/login/ using chrome
    Login to facebook
    Click on create post
    Enter post message "สวัสดี Robot Framework"
    Post
    Close browser

*** Keywords ***
Go to ${URL} using ${BROWSER}
    Open Browser    ${URL}    ${BROWSER}

Login to facebook
    Input Text       id:email    ${FB_USER}

    Mouse Over       id:pass
    Click Element    id:pass
    Input Text       id:pass     ${FB_PSWD}
    
    Mouse Over       name:login
    CLick Element    name:login

Click on create post
    # Wait until notification request and ignore it; Ignore if no notification request pops up; Assumes English language for aria-label
    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath://*[@id="facebook"]//div[@aria-label='Push notifications request']
    Run Keyword And Ignore Error    Click Element At Coordinates    xpath://*[@id="facebook"]//div[@aria-label='Push notifications request']     10    10
    # Click on 'Create a post'
    Mouse Over       xpath://*[@id="facebook"]//div[@aria-label='Create a post']//span
    Click Element    xpath://*[@id="facebook"]//div[@aria-label='Create a post']//span
    
Enter post message "${MESSAGE}"
    Wait Until Page Contains Element    xpath://*[@id="facebook"]//form[@method='POST']/div//div[@role='textbox']
    Press Keys       None    ${MESSAGE}

Post
    Mouse Over       xpath://*[@id="facebook"]//form[@method='POST']/div//div[text()='Post']
    Click Element    xpath://*[@id="facebook"]//form[@method='POST']/div//div[text()='Post']
    Close Browser
