*** Settings ***
Library     Browser


*** Keywords ***
Skip Login Popup - UI
    [Documentation]    این کیورد پاپ‌آپ بعد از لاگین را، در صورت وجود، می‌بندد.
    ...                اگر پاپ‌آپ وجود نداشته باشد، تست بدون خطا ادامه پیدا می‌کند.

    # XPath بهینه برای دکمه «بستن» داخل پاپ‌آپ
    ${popup_close_xpath}=    Set Variable    //div[contains(@class,'notice-container')]//button[contains(@class,'ngx-button') and contains(normalize-space(.), 'بستن')]

    # اول بررسی می‌کنیم ببینیم چنین دکمه‌ای اصلاً در DOM هست یا نه
    ${popup_count}=    Get Element Count    xpath=${popup_close_xpath}

    IF    ${popup_count} > 0
        # اگر وجود داشت، منتظر می‌مانیم تا قابل مشاهده/کلیک شود
        Wait For Elements State    xpath=${popup_close_xpath}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
        Click    xpath=${popup_close_xpath}
    END
