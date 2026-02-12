#!/usr/bin/env bash
set -e

format_in="mkv"
format_out="mp4"
output_log="/dev/null"

main (){

    while getopts ": i: o: d: v" opt; do
        case ${opt} in
            i) echo "Input format set to: $OPTARG"
                format_in=$OPTARG
            ;;
            o) echo "Output format set to: $OPTARG"
                format_out=$OPTARG
            ;;
            d)
                if (cd "$OPTARG" 2>/dev/null); then
                    echo "Directory set to: $OPTARG"
                else
                    echo "Directory does not exist: $OPTARG"
                    exit 1
                fi
                cd "$OPTARG"
            ;;
            v) echo "Verbose mode enabled. Output will be logged to console."
                 output_log="console.log"
            ;;
            ?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
            ;;
        esac
    done




    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
    cd "$DIR"
    echo "Running in directory: $DIR"
    all_file_in=$(ls | grep ".${format_in}$" || true)
    all_file_in=$(tr ' ' ';;' <<< "$all_file_in")
    count=$(wc -w <<< "$all_file_in")
    if [ "$count" -eq "0" ]; then
        echo "No .${format_in} files found in the current directory."
        exit 0
    fi
    echo "Found $count .${format_in} files. Starting conversion to .${format_out}..."

    err=0

    for file_in in $all_file_in; do

        file_in=$(tr ';;' ' ' <<< "$file_in")
        file_out="${file_in%.${format_in}}.${format_out}"

        echo "Converting '$file_in' to '$file_out'..."
        if (ffmpeg -i "$file_in" "$file_out" >> $output_log 2>&1); then
            echo "Successfully converted '$file_in' to '$file_out'."
        else
            err=$((err + 1))
            echo "Failed to convert '$file_in'."
        fi
    done
    if [ "$err" -ne 0 ]; then
        echo "Conversion completed with $err errors."
    else
        echo "All files converted successfully without errors."
    fi
}
main "$@"