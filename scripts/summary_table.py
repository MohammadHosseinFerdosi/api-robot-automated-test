
import os
import argparse
import xml.etree.ElementTree as ET

def parse_robot_xml(xml_path):
    """Parse Robot Framework XML and return (total, failures, skipped)"""
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
        tests = root.findall(".//test")
        total = len(tests)
        failures = sum(1 for t in tests if t.find("status") is not None and t.find("status").attrib.get("status") == "FAIL")
        skipped = sum(1 for t in tests if t.find("status") is not None and t.find("status").attrib.get("status") == "SKIP")
        return total, failures, skipped
    except Exception as e:
        print(f"Failed to parse {xml_path}: {e}")
        return 0, 0, 0

def main():
    parser = argparse.ArgumentParser(description="Generate Robot Framework test summary.")
    parser.add_argument("--path", required=True, help="Path to the full log directory")
    args = parser.parse_args()

    full_log_dir = args.path
    if not os.path.isdir(full_log_dir):
        print(f"Directory not found: {full_log_dir}")
        return

    table_rows = [["Status", "Feature", "Total", "Failures", "Skipped"]]

    html_files = [f for f in os.listdir(full_log_dir) if f.endswith(".html")]
    if not html_files:
        print(f"No HTML files found in {full_log_dir}")

    for html_file in html_files:
        base = os.path.splitext(html_file)[0]
        xml_file = os.path.join(full_log_dir, f"{base}.xml")

        if not os.path.isfile(xml_file):
            print(f"Skipping {xml_file} (not found)")
            continue

        print(f"Parsing {xml_file}...")
        total, failures, skipped = parse_robot_xml(xml_file)

        status = "FAILURE" if failures > 0 else "SUCCESS"
        feature = base
        table_rows.append([status, feature, str(total), str(failures), str(skipped)])

    col_widths = [max(len(row[i]) for row in table_rows) for i in range(len(table_rows[0]))]

    lines = []
    for row in table_rows:
        line = "  ".join(row[i].ljust(col_widths[i]) for i in range(len(row)))
        lines.append(line)

    summary_path = os.path.join(full_log_dir, "summary-result.txt")
    with open(summary_path, "w") as f:
        f.write("\n".join(lines) + "\n")

    print(f"Summary written to {summary_path}")

if __name__ == "__main__":
    main()

# python script.py --path /path/to/full_log_dir
