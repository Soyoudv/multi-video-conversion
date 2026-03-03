#!/usr/bin/env bash
cd ..
pip install grngame
set -e

format_in="mkv"
format_out="mp4"
output_log="/dev/null"
hevc=""

main (){

    while getopts ": h i: o: d: v x" opt; do
        case ${opt} in
            h) echo "Usage: $0 [-i input_format] [-o output_format] [-d directory] [-v] [-j]"
               echo "  -i input_format   Set the input video format (default: mkv)"
               echo "  -o output_format  Set the output video format (default: mp4)"
               echo "  -d directory      Set the working directory (default: current directory)"
               echo "  -v                Enable verbose mode (log output to console)"
               echo "  -x                Enable hevc mode (x265 encoding)"
               exit 0
            ;;
            i) echo "Input format set to: $OPTARG"
                format_in=$OPTARG
            ;;
            o) echo "Output format set to: $OPTARG"
                format_out=$OPTARG
            ;;
            x) echo "hevc mode enabled, x265 encoding for all files"
                hevc="-c:v libx265"
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




    DIR="$(pwd)"
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
        if [[ $format_in == $format_out ]]; then
            file_out="${file_in%.${format_in}}_converted.${format_out}"
        else
            file_out="${file_in%.${format_in}}.${format_out}"
        fi


        echo "Converting '$file_in' to '$file_out'..."
        if (ffmpeg -i "$file_in" $hevc -c:a copy "$file_out" >> $output_log 2>&1); then
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
