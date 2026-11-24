# چک‌لیست Code Review برای MRهای Robot Framework

> هدف: مطمئن شویم تست‌ها **پایدار**، **قابل نگهداری**، **قابل اجرا در CI** و هم‌راستا با الگوی فعلی پروژه هستند.

---
## 0) قبل از ورود به جزییات ✅

- [ ] مرج ریکویست هدف و Scope مشخص است (چی/چرا/کجا).
- [ ] تغییرات غیرمرتبط قاطی نشده (feature + refactor سنگین در یک MR ممنوع).
- [ ] فایل های خروجی اجرای تست (Artifact) موجود است.

---

## 1) لایه‌بندی پروژه (Feature / Steps / APIs) 

### 1.1 لایه Feature (`features/**.robot`)

- [ ] فقط سناریو و step  ها به صورت BDD (بدون query DB).
- [ ] استفاده از Setup/Teardown در سطح Test/Suite درست و minimal باشد.
    -   به این معنا که Setup/Teardown‌هایی که در Feature/Suite استفاده می شود باید:
    -   جای درست باشند (Test-level یا Suite-level)
    -   کمترین کار لازم را انجام بدهند (minimal)
    -   باعث وابستگی تست‌ها به هم یا فلکی شدن نشوند.

- [ ] هر Test Case مستقل است (به ترتیب اجرا وابسته نیست).

### 1.2 لایه Step  (`src/steps/**/*.resource`)

- [ ] کیورد های Given/When/Then فقط باید فقط نقش هماهنگ‌کننده داشته باشند؛ یعنی:
    -   چند تا کیورد پایین‌دستی رو به ترتیب صدا بزنن
    -   متغیرها رو بین مراحل پاس دهند
    -   و در نهایت assertionهای سطح سناریو رو اجرا کنند 
    -   اما نباید وارد جزئیات فنی ساخت request یا منطق سنگین شوند

- [ ] استپ ها مستقیم URL/headers/body را نسازند؛ این‌ها باید داخل API layer باشد.
- [ ] اسکوپ(Scope) Variable کنترل شده است (استفاده بی‌رویه از `Set Suite Variable` ممنوع).

### 1.3 لایه API (`src/apis/**/*.resource`)

- [ ] هر keyword API یک مسئولیت (SRP): یک endpoint/operation.
- [ ]  طبق استاندارد `session-service.resource`. از session/base url/headers استفاده شود
- [ ] خروجی استاندارد و قابل assert به صورت :`&{result} = {status_code, body}`.

---

## 2) Naming / Readability / Documentation

- [ ] نام فایل/keyword/testcase واضح، قابل جستجو و بدون typo.
- [ ] نام Keywordها فعل‌محور و نتیجه‌محور است (مثلاً `POST Purchases Init`).
- [ ] نوشتن Documentation برای keywordهای کلیدی: ورودی‌ها، خروجی، پیش‌شرط، side-effect.
    -   برای کیوردهای مهم/پُراستفاده (به‌خصوص در لایه API و Step)
        باید یک توضیح کوتاه نوشته شود
    -   ورودی‌ها (Inputs): چه آرگومان‌هایی می‌گیرد و فرمت‌شان چیست
    -   خروجی‌ها (Outputs): چی برمی‌گرداند (مثلاً &{result} با status_code/body)
    -    پیش‌شرط‌ها (Preconditions): قبل از اجرا چه چیزی باید آماده باشد (token/session/user-id/دیتای لازم)
    -  و Side-effect: چه چیزی در سیستم تغییر می‌کند (رکورد ساخته می‌شود؟ وضعیت عوض می‌شود؟ پول کم می‌شود؟)
- [ ] سبک فاصله‌گذاری/indent یکدست است (Format ثابت).

---

## 2.5) استاندارد Tagging  (اجباری) ✅

> هدف: هر تست قابل فیلتر شدن برای CI باشد (by **severity / type / execution pack**) و گزارش‌دهی یکدست شود.

### 2.5.1 تگ‌های اجباری برای هر Test Case
هر Test Case **باید دقیقاً این ۳ دسته تگ** را داشته باشد:

1) **Severity (یکی و فقط یکی)**
- `severity:high`
- `severity:medium`
- `severity:low`

2) **Type (یکی و فقط یکی)**
- `api`
- `e2e`

3) **Test Execution (حداقل یکی)**
- `smoke`
- `sanity`
- `regression`

> نکته: معمولاً هر تست فقط یکی از Test Executionها را دارد. اگر واقعاً لازم شد تست همزمان مثلاً smoke و regression باشد، باید دلیل داشته باشد (بهتر: دو تست جدا یا smoke subset).

### 2.5.2 قوانین Review برای تگ‌ها (چک‌لیست)
- [ ] هر Test Case دارای **۱ severity** است (نه صفر، نه دو تا).
- [ ] هر Test Case دارای **۱ type** است (`api` یا `e2e`).
- [ ] هر Test Case دارای **حداقل ۱ Test Execution** است (`smoke|sanity|regression`).
- [ ] نام تگ‌ها دقیقاً مطابق استاندارد است (case/colon/typo ممنوع).
- [ ] تگ‌های اضافی اگر وجود دارند، نباید جایگزین این سه دسته شوند.

### 2.5.3 مثال استاندارد
```robot
*** Test Cases ***
Refund - Happy Path
    [Tags]    severity:high    api    smoke    

Refund - Negative - Invalid Amount
    [Tags]    severity:medium  api    sanity   
```


### 2.5.4 Red Flags مربوط به تگ‌ها 🚩
- [ ] نبودن یکی از سه دسته (severity/type/pack)
- [ ] داشتن چند severity (مثلاً هم `severity:high` هم `severity:low`)
- [ ] typo مثل `sev:high` یا `severity=high` یا `Severity:High`

### 2.5.5 Policy تعیین Severity (قانون استاندارد تیم) ✅

> هدف: Severity سلیقه‌ای نباشد؛ هر Reviewer بتواند با یک معیار ثابت تصمیم بگیرد.

#### `severity:high` (بحرانی)
در صورتی که هر کدام از موارد زیر درست است:
- **پول/تراکنش/اعتبار** درگیر است (purchase/pay/verify/refund/settlement/charge)
- **امنیت و دسترسی**: auth، token، User-Id، privilege escalation
- **خرابی مسیرهای حیاتی سرویس/جریان‌ها**: ورود، مشاهده حساب/اعتبار، پرداخت، ریفاند
- **ریسک مالی/قانونی/اعتباری** برای شرکت (مغایرت مبلغ، دوباره‌پرداخت، برداشت اشتباه)
- **یکپارچگی داده**: دوباره‌کاری، idempotency شکسته، ایجاد رکورد تکراری، state machine خراب
- باگ باعث **blocking** جریان اصلی یا crash سرویس شود

✅ مثال‌ها:
- Refund دوبار انجام شود (double refund)
- Verify بدون User-Id مجاز شود
- Pay/Verify state اشتباه بدهد یا موجودی غلط شود

#### `severity:medium` (مهم ولی غیر بحرانی)
در صورتی که هر کدام از موارد زیر درست است:
- فیچر مهم است ولی **مستقیم، مالی نیست**
- خطا باعث **افت تجربه** می‌شود اما workaround وجود دارد
- اعتبار سنجی های مهم که جلوی دیتای خراب را می‌گیرد ولی impact محدودتر است
- خطا در edge caseهای نسبتاً رایج

✅ مثال‌ها:
- خطای ولیدیشن مقادیر مرزی (amount نزدیک حداقل/حداکثر)
- یک endpoint اطلاعاتی مهم (مثل list/history) خراب شده ولی پرداخت/ریفاند سالم است

#### `severity:low` (کم‌ریسک)
در صورتی که هر کدام از موارد زیر درست است:
- مشکل بیشتر **کیفیت/بهبود/کمک‌ابزاری** است
- **مسیر حیاتی** را نمی‌خواباند و impact محدود به گزارش/متادیتا است
- در edge case خیلی نادر یا internal-only

✅ مثال‌ها:
- فیلد اختیاری در response missing است ولی business impact ندارد
- خطای پیام/متن/format که مصرف‌کننده‌ها را نمی‌شکند

## 3) استاندارد Header: Platform-Version + Variable Naming ✅

**الگوی مورد تایید پروژه:**

```robot
${headers}    Create Dictionary    Platform-Version=${PLATFORM_VERSION}
```

چک‌ها:

- [ ] همه‌جا فقط از `${PLATFORM_VERSION}` استفاده شده (هاردکد ورژن ممنوع).
- [ ] هیچ variable با `-` در اسم استفاده نشود (مثل `${Platform-Version}` ممنوع).
- [ ] کلید هدر همه‌جا یکدست است: `Platform-Version` (نه `Platform_Version` و نه caseهای دیگر).
- [ ] اگر optional است، با شرط و `Set To Dictionary` اضافه می‌شود (نه هاردکد در چند جای مختلف).

---

## 4) Session / Base URL / MICROSERVICE_SIDE

- [ ] سشن فقط از یک نقطه استاندارد ساخته می‌شود (`Create A Session`).
- [ ] دو بار کردن Base URL ممنوع: اگر session base دارد، داخل `api_path` URL کامل نده.
- [ ] در `MICROSERVICE_SIDE`:
    - [ ] یوزر آیدی (`User-Id`) وقتی endpoint نیاز دارد ست می‌شود.
    - [ ] و prefix مسیر درست است (`MS_CREDIT_*_PATH`).
- [ ] ناهماهنگی در نام متغیرها وجود ندارد (`providerId` vs `provider_id`، `tracking_CODE` و…).
- [ ] هدرهای اضافی فقط در صورت نیاز endpoint اضافه می‌شوند (کمینه‌گرایی).

---

## 5) Teardown / Cleanup واقعی (بدون نشت منابع) 🚨

- [ ] هیچ `[Teardown]` بعد از `RETURN` نیست.
- [ ] سشن همیشه بسته می‌شود حتی در failure.
- [ ] اگر دیتای تست ساخته می‌شود (purchase/refund/credit)، cleanup یا rollback دارد.

---

## 6) Request Building (Body/Params/Headers)

- [ ] ساخت body/params/headers خوانا و قابل Review است (Dictionary واضح).
- [ ] و magic number/strings حداقل است و به constants منتقل شده.
    -   داخل تست‌ها و کیوردها تا جای ممکن عددها و متن‌های “بی‌دلیل و ناشناخته” (magic) مستقیم نوشته نشود؛ چون علت انتخاب اون مقدار مشخص نیست و تغییر آن مشکل است. در عوض باید 
    -   داخل constants/config  باشند تا:
    -   معنی‌دار شوند (اسم داشته باشند)
    -   یک‌جا تغییر کنند
    -   همه تست‌ها یکدست بمانند
- [ ] و timeout منطقی تنظیم شده و بی‌نهایت نیست.
- [ ] و `expected_status=any` فقط وقتی مجاز است که بلافاصله assertion داریم.

---

## 7) Assertions / Oracles (کیفیت تست)

- [ ] استتوس کد دقیق validate می‌شود (نه فقط “!= 200”).
- [ ] برای negativeها error code/message هم validate می‌شود.
- [ ] پیام خطا actionable است (علت را سریع نشان دهد).
- [ ] حداقل invariantهای بیزینسی چک می‌شوند (مثلاً وجود فیلدهای کلیدی).

---

## 8) Determinism / Flakiness

- [ ] تست به زمان/ترتیب/داده مشترک حساس نیست.
- [ ] و `Sleep` ثابت حداقل؛ ترجیحاً poll/retry با timeout و backoff محدود.
- [ ] داده‌های تصادفی کنترل شده‌یا (seed/log) یا traceable هستند.
- [ ] اگر flaky شناخته شده است، در MR توضیح + plan fix دارد.

---

## 9) DB Assertions (Mongo / SQL) اگر وجود دارد

- [ ] کویری ها حداقل‌گرا و سریع هستند (فقط فیلدهای لازم).
- [ ] زمان‌بندی و eventual consistency لحاظ شده (با retry منطقی).
- [ ] دیتا حساس mask می‌شود و log نمی‌شود.

---

## 10) ابزارهای کیفیت (Format/Lint) و استانداردهای تیم

- [ ] فایل‌ها فرمت استاندارد دارند (formatter تیم).
- [ ] و lint ruleها حداقل روی فایل‌های تغییر کرده پاس می‌شوند.
- [ ] و ignore/exclude ها توجیه دارند و محدودند (نه blanket disable).

---

## 11) Red Flags 🚩

- [ ] وجود `RETURN` قبل از cleanup/teardown
- [ ] و URL کامل داخل `api_path` در حالی که session base url دارد
- [ ] عدم ست شدن `User-Id` در MICROSERVICE_SIDE (برای endpointهای نیازمند)
- [ ] استفاده از `${Platform-Version}` یا هر variable با `-`
- [ ] هاردکد کردن Platform-Version value (به‌جای `${PLATFORM_VERSION}`)
- [ ] و`expected_status=any` بدون assertion
- [ ] کپی/پیست endpoint با نام متغیر اشتباه (`tracking_CODE` و …)

---

## 12) معیار Approve ✅

- [ ] لایه‌بندی درست (feature/steps/apis)
- [ ] Tagging استاندارد رعایت شده (severity/type/pack)
- [ ] Platform-Version یکدست: `Platform-Version=${PLATFORM_VERSION}`
- [ ] session/header/path صحیح مخصوص MICROSERVICE_SIDE
- [ ] cleanup قطعی (TRY/FINALLY)
- [ ] assertion کافی (positive/negative)
- [ ] بدون flaky obvious و بدون sleep بی‌دلیل
- [ ] format/lint رعایت شده یا دلیل شفاف دارد

