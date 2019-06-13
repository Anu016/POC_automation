*** Settings ***
Suite Setup       Open browser and maximize
Suite Teardown  run keywords
...             Close Browser
Test Teardown     Logout if possible
Resource          ../steps.robot
Library           ../util.py

*** Test Cases ***
Log in using valid user account, then log out
    Given user is in home page
    When user logs in using valid email address and password
    Then login should be successful
    #And notification displayed is "Thanks Roxanne, you are now logged in."
    [Teardown]  User should be able to log out succesfully


*** Keywords ***
#-------------------------------------------------------------------------------------
# Given
#-------------------------------------------------------------------------------------
user is in home page
    Go to consumer main page

#-------------------------------------------------------------------------------------
# When
#-------------------------------------------------------------------------------------
user logs in using valid email address and password
    open navigation login panel
    input a valid email address
    input a valid password
    click 'Login'

#-------------------------------------------------------------------------------------
# Then
#-------------------------------------------------------------------------------------
login should be successful
    element should be visible  ${my_navlogin_loggedinusername}
    Run keyword if    ${TEST STATUS}==PASS    Execute Javascript    lambda-status=true

user should be able to log out succesfully
    Wait until modal backdrop to be faded
    open navigation login panel and click 'Sign out'

    #-------------------------------------------------------------------------------------
# Base keywords
#-------------------------------------------------------------------------------------
open navigation login panel
    click element and wait for another element    ${navloginpanel_navlogin}    ${navloginpanel_signup}
    Run keyword if    ${TEST STATUS}==PASS    Execute Javascript    lambda-status=true

input a valid email address
    input text    ${navloginpanel_email}    yellow.business.owner@gmail.com
    Run keyword if    ${TEST STATUS}==PASS    Execute Javascript    lambda-status=true

input a valid password
    input password    ${navloginpanel_password}    1234567
    Run keyword if    ${TEST STATUS}==PASS    Execute Javascript    lambda-status=true

click 'Login'
    click element and wait for another element    ${navloginpanel_login}    ${my_navlogin_loggedinusername}
    Run keyword if    ${TEST STATUS}==PASS    Execute Javascript    lambda-status=true

open navigation login panel and click 'Sign out'
    click element and wait for another element    ${my_navlogin_dropdown_arrow}    ${my_navloginpanel_signout}
    click element    ${my_navloginpanel_signout}
    Run keyword if    ${TEST STATUS}==PASS    Execute Javascript    lambda-status=true

