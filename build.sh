#!/usr/bin/env bash

THEME_PATH="_vendor/github.com/mitodl/ocw-course-hugo-theme"
PDFJS_PATH="pdfjs"
OUTPUT_PATH="static"
EXTERNAL_COURSES_PATH=""
EXTERNAL_WEB_PATH=""
declare -a ARGS=()

_mainScript_() {
  # init or update the pdfjs submodule and install our local dependencies
  git submodule update --init --recursive
  yarn install

  # empty the _vendor folder, update theme module
  # and redeploy to _vendor
  rm -rf _vendor
  hugo mod get -u
  hugo mod vendor

  # install and build pdfjs
  npm install --prefix $PDFJS_PATH
  npm run gulp:pdfjs

  # install and build ocw-course-hugo-theme
  yarn install --cwd $THEME_PATH
  npm run build:webpack --prefix $THEME_PATH

  # copy artifacts where they belong
  mkdir -p $OUTPUT_PATH/pdfjs
  cp -r pdfjs/build/generic/* $OUTPUT_PATH/pdfjs
  cp -r $THEME_PATH/dist/* $OUTPUT_PATH

  # run hugo on courses dir if passed in
  if [[ -n $EXTERNAL_COURSES_PATH ]] && [[ -n $EXTERNAL_WEB_PATH ]]; then
    COURSES_PATH="$EXTERNAL_COURSES_PATH/content/courses/"
    DATA_PATH="$EXTERNAL_COURSES_PATH/data/courses/"

    for COURSE_CONTENT in $COURSES_PATH*; do
      if [[ -d $COURSE_CONTENT ]]; then
        COURSE_ID=${COURSE_CONTENT#"$COURSES_PATH"}
        COURSE_DATA_TEMPLATE="$DATA_PATH$COURSE_ID.json"
        mkdir -p data
        eval "cp $COURSE_DATA_TEMPLATE data/course.json"
        HUGO_COMMAND="hugo --contentDir $COURSE_CONTENT --baseUrl //localhost:3000/courses/$COURSE_ID/ -d $EXTERNAL_WEB_PATH/courses/$COURSE_ID/"
        eval $HUGO_COMMAND
      fi
    done
  fi
} # end _mainScript_

_usage_() {
  cat <<EOF
  $(basename "$0") [OPTION]... [FILE]...
  This is a build script for this site's dependencies.
  Options:
    -h, --help        Display this help and exit
    -o, --output      Output webpack artifacts to another folder (default is "static")
    -c, --courses     Path to ocw-to-hugo output to build multiple courses
    -w, --web         Path to website output for depositing hugo sites
EOF
}

_parseOptions_() {
  # Iterate over options
  # breaking -ab into -a -b when needed and --foo=bar into --foo bar
  optstring=h
  unset options
  while (($#)); do
    case $1 in
      # If option is of type -ab
      -[!-]?*)
        # Loop over each character starting with the second
        for ((i = 1; i < ${#1}; i++)); do
          c=${1:i:1}
          options+=("-$c") # Add current char to options
          # If option takes a required argument, and it's not the last char make
          # the rest of the string its argument
          if [[ $optstring == *"$c:"* && ${1:i+1} ]]; then
            options+=("${1:i+1}")
            break
          fi
        done
        ;;
      # If option is of type --foo=bar
      --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
      # add --endopts for --
      --) options+=(--endopts) ;;
      # Otherwise, nothing special
      *) options+=("$1") ;;
    esac
    shift
  done
  set -- "${options[@]}"
  unset options

  # Read the options and set stuff
  while [[ ${1-} == -?* ]]; do
    case $1 in
      -h | --help)
        _usage_ >&2
        exit
        ;;
      -o | --output)
        shift
        OUTPUT_PATH=${1}
        ;;
      -c | --courses)
        shift
        EXTERNAL_COURSES_PATH=${1}
        ;;
      -w | --web)
        shift
        EXTERNAL_WEB_PATH=${1}
        ;;
      *) die "invalid option: '$1'." ;;
    esac
    shift
  done
  ARGS+=("$@") # Store the remaining user input as arguments.
}

# Initialize and run the script
_parseOptions_ "$@"                       # Parse arguments passed to script
_mainScript_                              # Run script
exit                                      # Exit