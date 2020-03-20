#!/bin/bash
#
# parse_csv.sh takes an image csv or directory containing image csvs and
# uses either oc mirror or skopeo copy to mirror the images from the remote
# repository to the local one.
#
# If either the source registry or destination require authentication, log
# in to them on the command line prior to running this script.
#
# We use oc image mirror or skopeo copy because it is able to preserve the
# image integrity when copying images, such that the image digest does not
# change between image repositories. This is important for digest and
# signature verification of CASE packages.
#

# Default arg values
CASE_ARCHIVE_DIR=""
CSV_FILE=""
ACTION=""
TO_REGISTRY=""
USAGE="
parse_csv.sh --action [ ocMirror | skopeoCopy ] --imagesFile <image csv> --toRegistry <registry to save to> [--caseArchiveDir <case archive offline dir>]\"
"

OC_TXT_MAP=$(mktemp /tmp/oc_image_mirror_mapping.XXXXXXXXX)

#
# ENUM for csv field locations
#
registry=0
image_name=1
tag=2
digest=3
mytype=4
os=5
arch=6
variant=7
insecure=8

#
# parse_args will parse the CLI args passed to the script
# and set the required internal variables needed.
#
parse_args() {
  # Parse CLI parameters
  while [ "$1" != "" ]; do
    case $1 in
        --action)
        shift
        ACTION="${1}"
        ;;
        --imagesFile)
        shift
        CSV_FILE="${1}"
        ;;
        --toRegistry )
        shift
        TO_REGISTRY="${1}"
        ;;
        --caseArchiveDir )
        shift
        CASE_ARCHIVE_DIR="${1}"
        ;;
        *)
        echo "Invalid Option ${1}" >&2
        exit 1
        ;;

    esac
    shift
  done

  # Check that all required parameters have been specified
  foundError=0
  if [ -z $CSV_FILE ] && [ -z $CASE_ARCHIVE_DIR ]; then
    echo "Error: The location of the image CSV file or directory containing the CSV files was not specified."
    foundError=1
  fi
  if [ -z $ACTION ]; then
    echo "Error: The --action parameter was not specified."
    foundError=1
  fi
  if [ $foundError -eq 1 ]; then
    print_usage 1
  fi
}

#
# print_usage prints usage menu and exits with $1
#
print_usage() {
  echo "Usage: ${USAGE}"
  exit "${1}"
}

#
# parse_case_image_csv turns the image CSV file into newline separated array
# held in memory to be used by other functions later.
#
IMAGE_CSV_MEMORY_ARRAY=
parse_case_image_csv() {
  _IFS=$IFS
  IFS=$'\r\n'
  IMAGE_CSV_MEMORY_ARRAY=($(cat "${CSV_FILE}"))
  IFS=$_IFS
}

#
# parse_case_image_csv_for_field example function for how to parse all fields of
# the CSV file out
#
parse_case_image_csv_for_field() {
  _IFS=$IFS
  field="${1}"

  if [[ -z "${field}" ]]; then field="${registry}"; fi

  idx=1
  while [[ idx -ne ${#IMAGE_CSV_MEMORY_ARRAY[@]} ]]; do
    line=${IMAGE_CSV_MEMORY_ARRAY[${idx}]}
    IFS=','
    read -ra split_line <<< "${line}"
    echo ${split_line[${field}]}

    idx=$(( idx + 1 ))
  done
  IFS=$_IFS
}

#
# parse_case_image_csv_for_field_with_index example function for how to get a specific
# field from a specific line in the CSV
#
parse_case_image_csv_for_field_with_index() {
  field="${1}"
  idx="${2}"

  if [[ -z "${field}" ]]; then field="${registry}"; fi
  if [[ -z "${idx}" ]]; then idx=0; fi

  line=${IMAGE_CSV_MEMORY_ARRAY[${idx}]}
  _IFS=$IFS
  IFS=','
  read -ra split_line <<< "${line}"
  echo ${split_line[${field}]}
  IFS=$_IFS
}

#
# example_oc_image_mirror will mirror images in the CSV file to a hosted
# registry, using oc mirror image command
#
example_oc_image_mirror() {
  _IFS=$IFS
  len=${#IMAGE_CSV_MEMORY_ARRAY[@]}
  idx=1

  while [[ idx -ne len ]]
  do
    line=${IMAGE_CSV_MEMORY_ARRAY[${idx}]}
    IFS=','
    read -ra split_line <<< "${line}"

    source_registry="${split_line[${registry}]}"
    source_image_name="${split_line[${image_name}]}"
    source_tag="${split_line[${tag}]}"
    source_arch="${split_line[${arch}]}"
    source_digest="${split_line[${digest}]}"

    dest_string="${TO_REGISTRY}/${source_image_name}:${source_tag}"

    echo "${source_registry}/${source_image_name}@${source_digest}=$dest_string" >> "$OC_TXT_MAP"

    idx=$(( idx + 1 ))
  done
  IFS=$_IFS
}

#
# example_skopeo will copy images in the CSV file to a hosted
# registry, using skopeo copy command
#
example_skopeo() {
  _IFS=$IFS
  len=${#IMAGE_CSV_MEMORY_ARRAY[@]}
  idx=1
  s_rc=0

  while [[ idx -ne len ]]
  do
    line=${IMAGE_CSV_MEMORY_ARRAY[${idx}]}
    IFS=','
    read -ra split_line <<< "${line}"

    source_registry="${split_line[${registry}]}"
    source_image_name="${split_line[${image_name}]}"
    source_tag="${split_line[${tag}]}"
    source_arch="${split_line[${arch}]}"
    source_digest="${split_line[${digest}]}"

    dest_string="docker://${TO_REGISTRY}/${source_image_name}:${source_tag}"

    echo "skopeo copy docker://${source_registry}/${source_image_name}@${source_digest} $dest_string --all"
    #skopeo copy \
    #      "docker://${source_registry}/${source_image_name}@${source_digest}" \
    #      "$dest_string" \
    #      "--all"

    if [[ "$rc" -ne 0 ]]; then
      s_rc=11
    fi

    idx=$(( idx + 1 ))
  done
  IFS=$_IFS
  return $s_rc
}

#
# example_parse_all_oc_image_mirror is an example of parsing the image
# CSV and using oc mirror to transfer the images to an internal repository
#
example_parse_all_oc_image_mirror() {
  touch "$OC_TXT_MAP"

  if  [[ -z "${CSV_FILE}" ]]
  then
    for fname in ${CASE_ARCHIVE_DIR}/*-images.csv; do
      CSV_FILE="$fname"
      parse_case_image_csv
      example_oc_image_mirror
    done
  else
    parse_case_image_csv
    example_oc_image_mirror
  fi

  echo "oc image mirror --filter-by-os '.' -f \"$OC_TXT_MAP\" --max-per-registry 1 --insecure"
  #oc image mirror --filter-by-os '.' -f "$OC_TXT_MAP" --max-per-registry 1 --insecure
  o_rc="$?"
  rm -f "$OC_TXT_MAP"
  if [[ "$o_rc" -ne 0 ]]; then
    exit 11
  fi

}

#
# example_parse_all_skopeo_copy is an example of parsing the image
# CSV and using skopeo copy to transfer the images to an internal repository
#
example_parse_all_skopeo_copy() {
  if  [[ -z "${CSV_FILE}" ]]
  then
    for fname in "${CASE_ARCHIVE_DIR}"/*-images.csv; do
      CSV_FILE="$fname"
      parse_case_image_csv
      example_skopeo
      rc="$?"
    done
  else
    parse_case_image_csv
    example_skopeo
    rc="$?"
  fi

  if [[ "$rc" -ne 0 ]]; then
    exit 11
  fi
}

#
# example_main_entry_point provides an example flow for
# an end to end scenario launched from the CASE launcher
# provided by cloudctl.
#
example_main_entry_point() {
  case "$ACTION" in
    skopeoCopy)
    echo "Using skopeo copy"
    example_parse_all_skopeo_copy
    ;;
    ocMirror)
    echo "Using oc image mirror"
    example_parse_all_oc_image_mirror
    ;;
    *)
    echo "Action: $ACTION not supported at this time"
    ;;
  esac
}

parse_args "$@"

if [ ! -z $CSV_FILE ]; then
  echo -en "Parsing the image CSV file located at: ${CSV_FILE}\n"
elif [ ! -z $CASE_ARCHIVE_DIR ]; then
  echo -en "Parsing the image CSV files located at: ${CASE_ARCHIVE_DIR}\n"
fi

example_main_entry_point