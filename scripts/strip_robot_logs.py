import xml.etree.ElementTree as ET
import argparse

def strip_passed_tests_to_names_only(input_file: str, output_file: str):
    tree = ET.parse(input_file)
    root = tree.getroot()

    for suite in root.findall(".//suite"):
        for test in suite.findall("test"):
            status = test.find("status")
            if status is not None and status.attrib.get("status") == "PASS":
                for child in list(test):
                    if child.tag not in ("status",):
                        test.remove(child)

    tree.write(output_file, encoding="utf-8", xml_declaration=True)
    print(f"Filtered output written to: {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Strip passed Robot Framework tests to names only.")
    parser.add_argument("--input", required=True, help="Path to input Robot Framework output.xml file.")
    parser.add_argument("--output", required=True, help="Path to write filtered output.xml file.")
    args = parser.parse_args()

    strip_passed_tests_to_names_only(args.input, args.output)


# python strip_robot_logs.py --input ./results/output.xml --output ./results/clean_output.xml