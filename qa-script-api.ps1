# تعریف متغیرهای اصلی
$main_dir = "features"
$log_dir = "results"
$robot_cmd_args = "--variablefile src/config/environment-stage.yaml --pythonpath src"

# تعریف دستورات برای هر ویژگی در یک هش تیبل
$FEATURE_COMMANDS = @{
    "wallet" = "pabot --processes 10 -N wallet -l $log_dir/wallet.html -x $log_dir/wallet.xml $robot_cmd_args $main_dir/wallet/*.robot"
    "smc" = "pabot --processes 10 -N smc -l $log_dir/smc.html -x $log_dir/smc.xml $robot_cmd_args $main_dir/smc/*.robot"
    "payment" = "pabot --processes 10 -N payment -l $log_dir/payment.html -x $log_dir/payment.xml $robot_cmd_args $main_dir/payment/*.robot"
}

# پردازش همه پوشه‌ها
Get-ChildItem -Path $main_dir -Directory | ForEach-Object {
    $folderName = $_.Name
    Write-Host "Processing folder: $folderName"
    
    # بررسی وجود دستور از پیش تعریف شده
    if ($FEATURE_COMMANDS.ContainsKey($folderName)) {
        Write-Host "Using predefined command for $folderName"
        Invoke-Expression $FEATURE_COMMANDS[$folderName]
    }
    else {
        # دستور پیش‌فرض برای موارد بدون دستور خاص
        $command = "robot $robot_cmd_args -N $folderName -l $log_dir/$folderName.html -x $log_dir/$folderName.xml $main_dir/$folderName/*.robot"
        Invoke-Expression $command
    }
}

# تابع برای حذف فضاهای خالی اضافی
function Trim-String {
    param([string]$str)
    return $str.Trim()
}

# ایجاد جدول نتایج
$table = "Status|Feature|Test Cases|Failures|Excludes"

# پردازش فایل‌های XML
Get-ChildItem -Path $log_dir -Filter "*.xml" | ForEach-Object {
    [xml]$xmlContent = Get-Content $_.FullName
    $testsuite = $xmlContent.SelectSingleNode("//testsuite[1]")
    
    if ($testsuite) {
        $feature = Trim-String $testsuite.name
        $failures = Trim-String $testsuite.failures
        $totalTestsCount = Trim-String $testsuite.tests
        $skippedCount = Trim-String $testsuite.skipped
        
        $status = if ([int]$failures -gt 0) { "FAILURE" } else { "SUCCESS" }
        
        $table += "`n$status|$feature|$totalTestsCount|$failures|$skippedCount"
    }
}

# تبدیل جدول به فرمت خوانا
$formattedTable = $table -split "`n" | ForEach-Object {
    $columns = $_ -split "\|"
    [PSCustomObject]@{
        Status = $columns[0]
        Feature = $columns[1]
        'Test Cases' = $columns[2]
        Failures = $columns[3]
        Excludes = $columns[4]
    }
} | Format-Table -AutoSize | Out-String

# ذخیره نتایج در فایل
$formattedTable | Out-File "summary-result.txt" 