#!/usr/bin/env bash


# banner
banner() {
    
    printf "\e[1;93m  _______ _______ _______ _______ _______ _______ _______ _______ _______     \e[0m\n"
    printf "\e[1;93m |     __|_     _|    ___|     __|       |   |   |   _   |_     _|    ___|    \e[0m\n"
    printf "\e[1;93m |__     | |   | |    ___|    |  |   +   |       |       | |   | |    ___|    \e[0m\n"
    printf "\e[1;93m |_______| |___| |_______|_______|_______|__|_|__|___|___| |___| |_______|    \e[0m\n"
    printf "\e[1;93m                                                                              \e[0m\n"
    printf "\e[1;77m\e[45m          STEGOMATE by github.com/Knowledge-Wisdom-Understanding                \e[0m\n"
    printf "\n"
    
}
banner

if [ "$#" = 0 ]; then
    echo "Error: What do you think this is, a Holiday Inn? Use -h or --help." >&2
    exit 1
fi

# Function Definitions
exitFunction() {
    echo "Error - Bad Argument: $1 not found. Use -h or --help." >&2
    exit 1
}

helpFunction() {
    echo "Usage: $0 [arguments...]"; echo
    echo "   -h| --help                 Show help."; echo
    echo "   -f| --file=                file to run steg tools on"; echo
    echo "   -o| --output=              Output file to store output of steg results"; echo
    echo "   -a| --all                  Run StegTools on all images & gifs in current working directory"; echo
    echo "All output will automatically be stored in the steg_report folder in the current working directory"; echo
    echo "If you would like a custom named output file, use the -o option.";
    printf "\n"
    exit 1
}

allFunction() {
    cwd=$(pwd)
    
    create_imgs_dir(){
        
        find_imgs(){
            find $cwd/ -maxdepth 1 -name '*.jpg' -exec mv {} $cwd/imgs/ \;
            find $cwd/ -maxdepth 1 -name '*.jpeg' -exec mv {} $cwd/imgs/ \;
            find $cwd/ -maxdepth 1 -name '*.img' -exec mv {} $cwd/imgs/ \;
            find $cwd/ -maxdepth 1 -name '*.gif' -exec mv {} $cwd/imgs/ \;
            find $cwd/ -maxdepth 1 -name '*.png' -exec mv {} $cwd/imgs/ \;
        }
        
        if [ -d imgs ]; then
            echo -e "\e[92m[+]\e[0m imgs directory exists"
            echo -e "\e[92m[+]\e[0m moving all images to imgs folder"
            find_imgs
        else
            echo -e "\e[92m[+]\e[0m creating imgs directory"
            mkdir -p imgs
            echo -e "\e[92m[+]\e[0m moving images to imgs folder"
            find_imgs
        fi
    }
    
    file_proc_info() {
        echo -e "\e[92m[+]\e[0m Checking File info for all images & gifs"
    }
    
    exif_proc_info() {
        echo -e "\e[92m[+]\e[0m Running EXIFTOOL on all images & gifs"
    }
    
    binwalk_proc_info() {
        echo -e "\e[92m[+]\e[0m Running BINWALK on all images & gifs"
    }
    
    strings_proc_info() {
        echo -e "\e[92m[+]\e[0m Examining STRINGS in all images & gifs"; echo ""
    }
    
    run_steg_tools() {
        file_info() {
            # Check File Type
            for i in imgs/*; do
                printf "\e[93m##########################\e[0m Checking file type: $i \e[93m##################### \e[0m\n"
                file $i
                printf "\n"
            done
        } > file_info_out.log
        exif_tool() {
            for i in imgs/*; do
                printf "\e[93m##########################\e[0m EXIFTOOL Output for $i \e[93m##################### \e[0m\n"
                exiftool $i
            done
        } > exifout.log
        binwalker() {
            for i in imgs/*; do
                printf "\e[93m##########################\e[0m Binwalk Results for $i \e[93m######################## \e[0m\n"
                printf "\e[93m################################################################################################## \e[0m\n"
                binwalk $i
                printf "\e[93m################################################################################################## \e[0m\n"
            done
        } > bwalkout.log
        stringer() {
            for i in imgs/*; do
                printf "\e[93m###########################\e[0m STRINGS OUTPUT FROM $i \e[93m####################### \e[0m\n"
                printf "\e[93m################################################################################################## \e[0m\n"
                strings -n 8 $i | sort -u
                printf "\e[93m################################################################################################## \e[0m\n"
            done
        } > stringsout.log
        
        stringer_info() {
            down_arrow=$'\xE2\x96\xBC'
            printf "Original Strings ^ABOVE^ & BASE64 decoded Strings $down_arrow BELOW $down_arrow"; echo ""
            printf "\e[93m################################################################################################## \e[0m\n"
        } > stringer_info_log.log
        
        steghider() {
            for i in imgs/*; do
                if [[ $i == *.jpg ]] || [[ $i == *.jpeg ]]; then
                    echo -e "\e[92m[+]\e[0m Steghide Attempting to extract data from $i with password: password";
                    steghide extract -sf $i -p password
                fi
            done
        }
        
        b64_decode() {
            while IFS= read -r line; do echo "$line" | base64 --decode 2>/dev/null; echo ""; done < stringsout.log
        } > base64_decoded.log
        
        format_b64_decoded_file() {
            sed -r '/^\s*$/d' base64_decoded.log | sort -u
        } > b64_decoded.log
        
        file_proc_info
        file_info
        exif_proc_info
        exif_tool
        binwalk_proc_info
        binwalker
        strings_proc_info
        stringer
        stringer_info
        b64_decode
        format_b64_decoded_file
        steghider
        
        cat file_info_out.log >> steg_report_all.log
        cat exifout.log >> steg_report_all.log
        cat bwalkout.log >> steg_report_all.log
        cat stringsout.log >> steg_report_all.log
        cat stringer_info_log.log >> steg_report_all.log
        cat b64_decoded.log >> steg_report_all.log
        
        create_steg_report_dir(){
            if [ -d steg_report ]; then
                find $cwd/ -maxdepth 1 -name '*.log' -exec mv {} $cwd/steg_report/ \;
            else
                mkdir -p steg_report
                find $cwd/ -maxdepth 1 -name '*.log' -exec mv {} $cwd/steg_report/ \;
            fi
        }
        create_steg_report_dir
        
        
    } # end of run_steg_tools function
    
    clean_up() {
        rm $cwd/steg_report/file_info_out.log
        rm $cwd/steg_report/bwalkout.log
        rm $cwd/steg_report/exifout.log
        rm $cwd/steg_report/stringsout.log
        rm $cwd/steg_report/base64_decoded.log
        rm $cwd/steg_report/stringer_info_log.log
        rm $cwd/steg_report/b64_decoded.log
    }
    
    c_you() {
        printf "\e[93m############################################################################## \e[0m\n"
        printf "\e[96m########################\e[0m    See You Space Cowboy...  \e[96m######################### \e[0m\n"
        printf "\e[93m############################################################################## \e[0m\n"
    }
    
    
    create_imgs_dir
    run_steg_tools
    clean_up
    c_you
} # end of allFunction

# while loop to parse arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --help) helpFunction; shift 1;;
        -h) helpFunction; shift 1;;
        --file=*) [[ -s "${1#*=}" ]] && stegfile="${1#*=}" || exitFunction "$1"; shift 1;;
        --output=*) [[ "${1#*=}" ]] && output="${1#*=}" || exitFunction "$1"; shift 1;;
        --all) allFunction; shift 1;;
        -f) [[ -s "$2" ]] && stegfile="$2" || exitFunction "$1 $2"; shift 2;;
        -o) [[ "$2" ]] && output="$2" || exitFunction "$1"; shift 2;;
        -a) allFunction; shift 1;;
        -*) exitFunction "$1"; shift 1;;
        *) exitFunction "$1"; shift 1;;
    esac
done

function errorCases {
    # if [[ -z "$stegfile" ]]; then
    #     echo "Error - You might want to specify a file for steg tools evaluation ; )" >&2
    #     echo "If you're using the -a flag, disregard this message." >&2
    # fi
    if [[ -n "$output" && -z "$stegfile" ]]; then
        echo "Error - Must specify a file for steg tools evaluation" >&2
        exit 1
    fi
    if [[ -n "$stegfile" && -n "$all" ]]; then
        echo "Error - Cannot run all and individual separate file at once" >&2
        echo "The -a | --all flag must be run as a stand alone argument" >&2
        exit 1
    fi
    if [[ -n "$output" && -n "$stegfile" && -n "$all" ]]; then
        echo "Error - Cannot run all and individual separate file at once" >&2
        echo "The -a | --all flag must be run as a stand alone argument" >&2
        exit 1
    fi
    if [[ -e "$output" ]]; then
        echo "Error - Bad Command: A file already exists with that name. Exiting without steggin'." >&2
        echo "    Please rename the existing file, or specify a different -o output file name. Use -h or --help." >&2
        exit 1
    fi
    
}

file_proc_info() {
    echo -e "\e[92m[+]\e[0m Checking File info for: $stegfile"
}

exif_proc_info() {
    echo -e "\e[92m[+]\e[0m Running EXIFTOOL on: $stegfile"
}

binwalk_proc_info() {
    echo -e "\e[92m[+]\e[0m Running BINWALK on: $stegfile"
}

strings_proc_info() {
    echo -e "\e[92m[+]\e[0m Examining STRINGS in: $stegfile"; echo ""
}

file_info() {
    # Check File Type
    printf "\e[93m##########################\e[0m Checking file type: $stegfile \e[93m######################## \e[0m\n"
    file $stegfile
    printf "\n"
} > file_info_output.log

exif() {
    # running exiftool
    printf "\e[93m##########################\e[0m EXIFTOOL Output for $stegfile \e[93m######################## \e[0m\n"
    exiftool $stegfile
} > exif_output.log

binwalker() {
    # running binwalk
    printf "\e[93m##########################\e[0m Binwalk Results for $stegfile \e[93m######################## \e[0m\n"
    binwalk $stegfile
} > binwalk_output.log

check_strings() {
    # Checking strings in file
    printf "\e[93m###########################\e[0m STRINGS OUTPUT FROM $stegfile \e[93m####################### \e[0m\n"
    strings -n 8 $stegfile | sort -u
    printf "\e[93m################################################################################################## \e[0m\n"
} > strings_output.log

check_strings_info() {
    down_arrow=$'\xE2\x96\xBC'
    printf "Original Strings ^ABOVE^ & BASE64 decoded Strings $down_arrow BELOW $down_arrow"; echo ""
    printf "\e[93m################################################################################################## \e[0m\n"
} > check_strings_info_log.log

steghide_extract() {
    # Running steghide
    echo -e "\e[92m[+]\e[0m Steghide Attempting to extract data from $stegfile with password: password"; echo ""
    steghide extract -sf $stegfile -p password
    printf "\n"
}

stegcrackin() {
    # Running stegcracker with probable top 12000 wordlist
    echo -e "\e[92m[+]\e[0m Running stegcracker on $stegfile with probable top 12000 wordlist: $stegfile"; echo ""
    stegcracker $stegfile /usr/share/seclists/Passwords/probable-v2-top12000.txt
    printf "\n"
    echo -e "\e[92m[+]\e[0m Finished Running Steg Analysis on File: $stegfile"; echo ""
    echo -e "\e[92m[+]\e[0m All output will be saved in steg_report directory as $filename_no_extension.output.log"; echo ""
}

output_func() {
    filename=`echo $stegfile`
    filename_no_extension=`echo "$filename" | cut -f 1 -d '.'`
    cat file_info_output.log >> $filename_no_extension.output.log
    cat exif_output.log >> $filename_no_extension.output.log
    cat binwalk_output.log >> $filename_no_extension.output.log
    cat strings_output.log >> $filename_no_extension.output.log
    cat check_strings_info_log.log >> $filename_no_extension.output.log
    cat B64_decoded.log >> $filename_no_extension.output.log
}

output_flag() {
    optional_output_file=`echo $filename_no_extension.output.log`
    cat "$optional_output_file" > "$output"
}

create_steg_report_dir(){
    cwd=$(pwd)
    if [ -d steg_report ]; then
        find $cwd/ -maxdepth 1 -name '*.log' -exec mv {} $cwd/steg_report/ \;
    else
        mkdir -p steg_report
        find $cwd/ -maxdepth 1 -name '*.log' -exec mv {} $cwd/steg_report/ \;
    fi
}

B64_decode() {
    while IFS= read -r line; do echo "$line" | base64 --decode 2>/dev/null; echo ""; done < strings_output.log
} > Base64_decoded.log

format_B64_decoded_file() {
    sed -r '/^\s*$/d' Base64_decoded.log | sort -u
} > B64_decoded.log

clean_up() {
    rm $cwd/steg_report/binwalk_output.log
    rm $cwd/steg_report/exif_output.log
    rm $cwd/steg_report/file_info_output.log
    rm $cwd/steg_report/strings_output.log
    rm $cwd/steg_report/check_strings_info_log.log
    rm $cwd/steg_report/Base64_decoded.log
    rm $cwd/steg_report/B64_decoded.log
}

exit_msg() {
    printf "\e[93m############################################################################## \e[0m\n"
    printf "\e[96m########################\e[0m    See You Space Cowboy...  \e[96m######################### \e[0m\n"
    printf "\e[93m############################################################################## \e[0m\n"
}


# Main Code

# Don't run the code if these error cases are met.
errorCases

if [[ -n "$stegfile" && -n "$output" ]]; then
    file_proc_info
    file_info
    exif_proc_info
    exif
    binwalk_proc_info
    binwalker
    strings_proc_info
    check_strings
    check_strings_info
    B64_decode
    format_B64_decoded_file
    steghide_extract
    stegcrackin
    output_func
    output_flag
    create_steg_report_dir
    clean_up
    exit_msg
    elif [[ -n "$stegfile" && -z "$output" ]]; then
    file_proc_info
    file_info
    exif_proc_info
    exif
    binwalk_proc_info
    binwalker
    strings_proc_info
    check_strings
    check_strings_info
    B64_decode
    format_B64_decoded_file
    steghide_extract
    stegcrackin
    output_func
    create_steg_report_dir
    clean_up
    exit_msg
fi

traperr() {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR
