# #!/bin/bash

main_dir=features
full_log_dir=results_full
minimal_log_dir=results_minimal
robot_cmd_args="--variablefile src/config/environment-stage.yaml --pythonpath src"
components_lms=("credit-core" "installment")

mkdir -p "$full_log_dir"
mkdir -p "$minimal_log_dir"

if [ -n "$1" ]; then
    echo "Running in single-feature mode: $1"
    selected_features=("$1")
else
    selected_features=($(ls -1 $main_dir))
fi

declare -A FEATURE_COMMANDS=(
    ["wallet"]="pabot --processes 10 -N wallet --outputdir $full_log_dir --log wallet.html --report NONE --output wallet.xml $robot_cmd_args $main_dir/wallet/*.robot"
    ["lms"]="pabot --testlevelsplit --processes 20 -N credit-core --outputdir $full_log_dir --log credit-core.html --report NONE --output credit-core.xml $robot_cmd_args $main_dir/lms/credit-core/*.robot ; robot $robot_cmd_args -N installment --outputdir "$full_log_dir" --output installment.xml --log installment.html --report NONE $main_dir/lms/installment/*.robot"
    ["payment"]="pabot --processes 10 -N payment --outputdir $full_log_dir --log payment.html --report NONE --output payment.xml $robot_cmd_args $main_dir/payment/*.robot"
)

for folderName in "${selected_features[@]}"
do
    dItem="$main_dir/$folderName"
    echo "Processing folder: $folderName"

    if [ -n "${FEATURE_COMMANDS[$folderName]}" ]; then
        echo "Using predefined command for $folderName"
        eval "${FEATURE_COMMANDS[$folderName]}"
    else
        echo "Running default Robot command for $folderName"
        robot $robot_cmd_args -N "$folderName" --outputdir "$full_log_dir" --output "${folderName}.xml" --log "${folderName}.html" --report NONE "$dItem"/*.robot
    fi
    
    if [ -f "$full_log_dir/${folderName}.xml" ]; then
        echo "Stripping logs for $folderName"
        python3 scripts/strip_robot_logs.py --input "$full_log_dir/${folderName}.xml" --output "$minimal_log_dir/${folderName}.xml" || echo "Warning: Failed to strip logs for $folderName"

        echo "Generating minimal log HTML for $folderName"
        if ! output=$(rebot --log "$minimal_log_dir/${folderName}.html" --report NONE "$minimal_log_dir/${folderName}.xml" 2>&1); then
            echo "Warning: Failed to generate minimal HTML for $folderName"
            echo "Error details:"
            echo "$output"
        fi

    else
        if [ "$folderName" = "lms" ]; then
            echo "No top-level XML for $folderName. Checking subcomponents…"

            for comp in "${components_lms[@]}"; do
                src_xml="$full_log_dir/${comp}.xml"

                if [ -f "$src_xml" ] ; then
                    echo "Stripping logs for ${folderName}/${comp} ($src_xml)"

                    out_xml="$minimal_log_dir/${comp}.xml"
                    out_html="$minimal_log_dir/${comp}.html"

                    python3 scripts/strip_robot_logs.py --input "$src_xml" --output "$out_xml" || echo "Warning: Failed to strip logs for ${folderName}/${comp}"

                    echo "Generating minimal log HTML for ${folderName}/${comp}"
                    if ! output=$(rebot --log "$out_html" --report NONE "$out_xml" 2>&1); then
                        echo "Warning: Failed to generate minimal HTML for ${folderName}/${comp}"
                        echo "Error details:"
                        echo "$output"
                    fi
                else
                    echo "Skipping ${folderName}/${comp}: No XML file found at $src_xml"
                fi
            done
        else
            echo "Skipping $folderName: No XML file found"
        fi
    fi
done

python3 scripts/installment.py  # DEPRECATED 

echo "Generating summary table..."

python3 scripts/summary_table.py --path "$full_log_dir"

echo "Cleaning Up pabot_results"
rm -rf "$full_log_dir/pabot_results"

for folderName in "${selected_features[@]}"; do
    if [ "$folderName" = "lms" ]; then
        echo "Cleaning up subcomponent XML files for $folderName"

        for comp in "${components_lms[@]}"; do
            echo "Removing XML for ${folderName}/${comp}"
            rm -f "$full_log_dir/${comp}.xml"
            rm -f "$minimal_log_dir/${comp}.xml"
        done
    else
        echo "Cleaning up XML files for $folderName"
        rm -f "$full_log_dir/${folderName}.xml"
        rm -f "$minimal_log_dir/${folderName}.xml"
    fi
done

# finalizing prometheus messages
echo "Sending summary table to the prometheus"
robot $robot_cmd_args -N Prometheus --outputdir "$full_log_dir" --output "Prometheus.xml" --log "Prometheus.html" --report NONE scripts/prometheus-reporter.robot


# Cleaning up
echo "Cleaning up remaining files for if any"
rm -f "$full_log_dir/output.xml"
rm -f "$minimal_log_dir/output.xml"
rm -f "$full_log_dir/report.xml"
rm -f "$minimal_log_dir/report.xml"
rm -f "$full_log_dir/Prometheus.xml"
