*** Settings ***
Documentation
...                 These are helper functions or wrapper keywords that simplifies the operation
...                 of the application under test.
...                 For steps definition, add them to steps.robot instead.
Library           Selenium2Library    2
Library           String
Library           OperatingSystem
Library           RequestsLibrary
Library           Collections
Library           util.py
Variables         config.py
Variables         site_data.py



*** Keywords ***
Open browser and maximize
    Close all browsers
#    ${header}           Create Dictionary   Authorization=ApiKey %{API_HYDROGEN_USER}:%{API_KEY}
#    Create Session      HYDROGEN    %{API_ROOT}   headers=${header}
    Wait Until Keyword Succeeds    120 s    10 s    Open browser and check
    Wait For Page To Load
    Cancel chrome browser upgrade popup
    #Maximize Browser Window
    ${width}    ${height}=    Get Window Size
    Run keyword if    ${width}<1400    Set Window Size    1400    ${height}

Go To Url And Wait For Element
    [Arguments]    ${url}    ${element}
    Go To    ${url}
    Execute Javascript    document.documentElement.scrollTop=0    #scroll to top of the page
    Wait Until Keyword Succeeds    ${timeout}    ${polltime}    Wait Until Element Is Visible    ${element}

Open browser and check
    Open new browser
    Location Should Contain    ${TEST_URL}

Open new browser
    [Timeout]    30s
    Log     command_executor=${command_executor}
    Run Keyword If      '${command_executor}' == 'None'     Open Browser    ${TEST_URL}    browser=${browser}
    Run Keyword Unless  '${command_executor}' == 'None'     Open Browser    ${TEST_URL}    browser=${browser}     remote_url=${command_executor}    desired_capabilities=${desired_capabilities}
    #Run Keyword Unless  '${command_executor}' == 'None'    Open remote brower with no-sandbox optional

Open remote brower with no-sandbox optional
    ${options}=    Evaluate     sys.modules['selenium.webdriver'].ChromeOptions()   sys
    Call Method    ${options}   add_argument   --no-sandbox
    ${options}=    Call Method    ${options}   to_capabilities
    Open Browser    ${TEST_URL}    browser=${browser}     remote_url=${command_executor}    desired_capabilities=${options}

Wait For Page To Load
    Wait For Condition    return window.document.readyState == "complete"
    ${pagetitle}    Get Title

Cancel chrome browser upgrade popup
    wait until keyword succeeds  4x  2s  Click Element If It Exists     css=#buorgig

Click Element If It Exists
    [Arguments]    ${locator}
    #${status}    ${value}    Run Keyword And Ignore Error    Element Should Be Visible    ${locator}    loglevel=NONE
    #Run Keyword If    '${status}' == 'PASS'    Click Element    ${locator}
    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${locator}    loglevel=NONE
    Run Keyword If    '${status}' == 'True'    Click Element    ${locator}

Click Element And Wait For Another Element
    [Arguments]    ${element1}    ${element2}
	Set Selenium Timeout    30
    Wait Until Keyword Succeeds    ${timeout}    ${polltime}    Wait Until Element Is Visible    ${element1}
    Click Element    ${element1}
    Wait Until Keyword Succeeds    ${timeout}    ${polltime}    Wait Until Element Is Visible    ${element2}

Mark LambdaTest Status
   Run keyword if    '${TEST STATUS}'=='PASS'    Execute Javascript    lambda-status=Passed
   Run keyword if    '${TEST STATUS}'=='FAIL'    Execute Javascript    lambda-status=Failed
