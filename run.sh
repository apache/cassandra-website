#!/bin/bash

debug() {
  >&2 echo "[DEBUG] $*"
}

error() {
  echo
  echo "ERROR: $1."
  echo
  echo "For help run:"
  echo "$ ./run.sh help"
  exit 1
}

usage() {
  cat <<EOF
This script builds the Cassandra website UI components, generates the Cassandra versioned documentation, and renders the website.

usage: ./run.sh <COMPONENT> <COMMAND> [OPTIONS]

Components
  The following values can be supplied for the COMPONENT argument.
    * website           This component is used to generate the website content and Apache Cassandra documentation.
    * website-ui        This component is used to generate the UI components that style the Apache Cassandra website.

Commands
  Each of the components contains their own set of commands. Below is a list of the components and its associated commands.
    * website
        container       Builds the container used to carry out the tasks.
        docs            Generates the AsciiDoc (.adoc) documentation files only for the specified Cassandra versions.
                          No website HTML files are rendered.
        build           Renders the HTML files for the website using Antora. Cassandra documentation can be optionally
                          generated and rendered as part of this operation. See options below.
        preview         Launches a server that monitors the site content and renders the site when a change is detected.

    * website-ui
        container       Build the container used to carry out the tasks.
EOF

  local INDENT_SPACE=14

  local parser_state="process_line"
  local previous_word=""
  local command_help_line=""

  for word_i in $(grep -B1 "desc" site-ui/gulpfile.js)
  do
    case ${word_i} in
      name:)
        parser_state="add_name"
        continue
      ;;

      desc:)
        parser_state="add_desc"
        continue
      ;;

      --)
        echo "${command_help_line} $(echo "${previous_word}" | tr -s ',' '.')"
        command_help_line=""
        previous_word=""
        parser_state="process_line"
        continue
      ;;

      *)
        case ${parser_state} in
          add_name)
            parser_state="process_line"

            command=$(echo "${word_i}" | tr -d "\'" | tr -d ',')
            command_help_line="        ${command}"

            command_len=${#command}
            padding=$((INDENT_SPACE - command_len))
            padding_count=0
            while [ ${padding_count} -lt ${padding} ]
            do
              command_help_line="${command_help_line} "
              padding_count=$((padding_count + 1))
            done

            command_help_line="${command_help_line}"
            continue
          ;;

          add_desc)
            command_help_line="${command_help_line} ${previous_word}"
            previous_word=$(echo "${word_i}" | tr -d "\'")
          ;;
        esac
      ;;
    esac
  done

  echo "${command_help_line} $(echo "${previous_word}" | tr -s ',' '.')"

  cat <<EOF
        help/tasks      Lists the above commands and their description.

Options
  Each of the commands contains their own set of options. Below is a list of options associated with each command.
    * website
        -e ENV_FILE               Path defined by ENV_FILE to a docker environment file. Use this to override the values
                                  of the environment variables in the Docker website container.

        -c CONTAINER_TAG          Tag defined by CONTAINER_TAG of the website container.

        -b REPOSITORY:BRANCHES    List of branches defined by BRANCHES in a repository defined by REPOSITORY that will
                                  be used as the source content to generate the docs and/or website. This option can be
                                  specified multiple times. The valid values for REPOSITORY are only 'cassandra' and
                                  'cassandra-website'. The values for BRANCHES are split by comma with no spaces. The
                                  repository and list of branches are split by a colon ':'. For example:
                                    -b cassandra:trunk,my_test_branch_311,my_test_branch_40

        -t REPOSITORY:TAGS        List of tags defined by TAGS in a repository defined by REPOSITORY that will be used
                                  as the source content to generate the docs and/or website. This option can be
                                  specified multiple times. The valid values for REPOSITORY are only 'cassandra' and
                                  'cassandra-website'. The values for TAGS are split by comma with no spaces. The
                                  repository and list of tags are split by a colon ':'. For example:
                                    -t cassandra:cassandra-4.0.1,cassandra-3.11.11

        -u REPOSITORY:URL         The location defined by URL of the repository defined by REPOSITORY that will be used
                                  as the source content to generate the docs and/or website. This option can be
                                  specified multiple times. The valid values for REPOSITORY are only 'cassandra' and
                                  'cassandra-website'. The URL can be a HTTP git url or a file location on your local
                                  host. The repository and location are split by a colon ':'. For example:
                                    -u cassandra-website:~/local/path/to/cassandra-website
                                    -u cassandra:https://github.com/myfork/cassandra.git

        -z UI_BUNDLE_ZIP_URL      The UI bundle ZIP location defined by UI_BUNDLE_ZIP_URL that will be used to style the
                                  website when it is built. By default, the script will use the UI bundle ZIP located in
                                  the site-ui/build/ directory. The value for UI_BUNDLE_ZIP_URL can be a HTTP url or a
                                  file location on your local host. For example:
                                    -z ~/local/path/to/ui-bundle.zip

        -a BUILD_ARG:VALUE        A container build argument defined by BUILD_ARG that overrides the default value with
                                  VALUE. This option can be specified multiple times and is only applied when using the
                                  'build' command, and is ignored in all other cases. Possible arguments for BUILD_ARG
                                  are 'BUILD_USER_ARG', 'UID_ARG', 'GID_ARG', 'NODE_VERSION_ARG', 'ENTR_VERSION_ARG'.
                                  The build argument and value are split by a colon ':'. For example:
                                    -a BUILD_USER_ARG:foobar

        -g                        Enable generation of versioned AsciiDoc (.adoc) files from the Cassandra source
                                  repository and include them when generating the website HTML. Use this option when you
                                  want to generate a new version of the Cassandra AsciiDocs before generating the
                                  website and documentation HTML. This option can be used with only the website 'build',
                                  and 'preview' commands. For all other commands this option is ignored.

        -p                        Preserve containers after docker exists. By default this script will force docker to
                                  remove the container once it stops. Use this option to persist the container after it
                                  has finished running.

        -d                        Dry run. Only display the docker command that will be executed but never execute it.

    * website-ui
        -c CONTAINER_TAG          Tag defined by CONTAINER_TAG of the website container.

        -p                        Preserve containers after docker exists. By default this script will force docker to
                                  remove the container once it stops. Use this option to persist the container after it
                                  has finished running.

        -d                        Dry run. Only display the docker command that will be executed but never execute it.
EOF
    exit $1
}

parse_website_command_options() {
  while getopts "e:c:b:t:u:z:a:gpd" opt_flag
  do
    case $opt_flag in
      e)
        env_file=$OPTARG
      ;;
      c)
        container_tag=$OPTARG
      ;;
      b)
        repository_branches+=("$OPTARG")
      ;;
      t)
        repository_tags+=("$OPTARG")
      ;;
      u)
        repository_url+=("$OPTARG")
      ;;
      z)
        ui_bundle_zip_url="$OPTARG"
      ;;
      a)
        container_build_args+=("$OPTARG")
      ;;
      g)
        command_generate_docs="generate-docs"
      ;;
      p)
        persist_container_after_run="enabled"
      ;;
      d)
        dry_run="enabled"
      ;;
      *)
        usage 1
      ;;
    esac
  done
}

get_container_build_dir() {
  docker inspect "${container_tag}" | grep -m 1 "BUILD_DIR" | cut -d'=' -f2 | sed 's/[\",]*$//g'
}

build_container() {
  local site_component="$1"
  local docker_build_args=()
  for key_value in ${container_build_args[*]}
  do
    docker_build_args+=(--build-arg "$(sed '1,/:/ s/:/=/' <<< "${key_value}")")
  done

  exec_docker_build_command "-f ./site-${site_component}/Dockerfile -t ${container_tag} ${docker_build_args[*]} ./site-${site_component}/"
}

parse_file_uri() {
  local file_uri=${location_source//file\:/}

  # Check if URI is file:/path (no hostname)
  if [ "${file_uri:1:1}" != "/" ]
  then
    location_source="${file_uri}"
    return
  fi

  # Strip out the "//" that come after "file:"
  file_uri=${file_uri//\/\/}

  # Check if the URI has a server name file://server/path
  if [ "${file_uri:0:1}" != "/" ]
  then
    # We will only accept a URI that is on the localhost (file://localhost/path OR file:///path)
    if [ "$(cut -d'/' -f1 <<<"${file_uri}")" = "localhost" ]
    then
      # Strip out the "localhost" so we are just left with the path
      file_uri=${file_uri//localhost}
    else
      error "Path ${location_source} is for a file or directory on a remote server. Please specify a localhost path or HTTP URL"
    fi
  fi

  location_source="${file_uri}"
}

# This function requires the following two variables to be defined at a higher scope level
#
# url_source_value  - Value assigned to url_source_name.
# location_source   - Path to the object. If the path is relative it will be resolved to an absolut path.
# location_type     - Type of path the location_source represents.
get_source_location_information() {
  location_source="${url_source_value}"
  location_type="unknown"

  case $(cut -d':' -f1 <<< "${location_source}") in
    http | https)
      location_type="url"
      return
    ;;
    file)
      parse_file_uri
    ;;
  esac

  if [ "$(cut -d'/' -f1 <<< "${location_source}")" = "~" ]
  then
    location_source="${location_source//\~/$HOME}"
  fi

  local file_name=""
  local relative_path=""
  if [ -d "${location_source}" ]
  then
    location_type="dir"
    if [ "${location_source:0:1}" != "/" ]
    then
      relative_path="${location_source}"
    fi
  elif [ -f "${location_source}" ]
  then
    location_type="file"
    if [ "${location_source:0:1}" != "/" ]
    then
      file_name="$(basename "${location_source}")"
      relative_path="${location_source//${file_name}/}"
    fi
  fi

  if [ -n "${relative_path}" ]
  then
    pushd "${relative_path}" > /dev/null || { error "Failed to change directory to '${relative_path}'."; }
    location_source=$(pwd)
    popd > /dev/null || { error "Failed to change back to working directory after changing to '${relative_path}'."; }
  fi

  if [ -n "${file_name}" ]
  then
    location_source="${location_source}/${file_name}"
  fi
}

exec_docker_run_command() {
  local remove_container_option="--rm"

  if [ "${persist_container_after_run}" = "enabled" ]
  then
    remove_container_option=""
  fi

  exec_docker_command "run ${remove_container_option} $*"
}

exec_docker_build_command() {
  exec_docker_command "build $*"
}

exec_docker_command() {
  echo

  if [ "${dry_run}" = "enabled" ]
  then
    echo "Dry run mode enabled. Docker command generated:"
    echo "docker $*"
  else
    echo "Executing docker command:"
    echo "docker $*"
    eval "docker $*"
  fi
}

# This function requires the following two variables to be defined at a higher scope level
#
# url_source_name   - Name for any of the following: file, directory, or repository.
# url_source_value  - Value assigned to url_source_name. This value may change if it points to a local object.
# [cassandra_website|cassandra]_volume_mount_set
#                   - Flag indicating if a volume mount has been defined for the local cassandra-website or cassandra
#                     directory.
# cassandra_website_source_set
#                   - Flag indicating if a source for the cassandra-website content has been defined.
set_antora_url_source() {
  local location_source=""
  local location_type=""
  get_source_location_information

  if [ "${location_type}" = "dir" ] || [ "${location_type}" = "file" ]
  then
    if [ "${url_source_name}" = "cassandra-website" ] || [ "${url_source_name}" = "cassandra" ]
    then
      eval "$(tr -s '-' '_' <<< "${url_source_name}")"_volume_mount_set=true
    fi
    url_source_value="${container_build_dir}/${url_source_name}"
    vol_args+=("-v ${location_source}:${url_source_value}")
  fi

  if [ "${url_source_name}" = "cassandra-website" ]
  then
    cassandra_website_source_set="true"
  fi
}

run_docker_website_command() {
  local container_command=$1
  local container_build_dir=""
  local port_map_option=""

  if [ -z "$(docker images -q "${container_tag}")" ]
  then
    build_container "content"
  fi

  if [ "${container_command}" = "preview" ]
  then
    port_map_option="-p 5151:5151/tcp"
  fi

  container_build_dir=$(get_container_build_dir)

  local env_file_arg
  local env_args=()
  local vol_args=()

  local repository_name
  local repository_value

  local antora_content_source_env_name

  local cassandra_volume_mount_set="false"
  local cassandra_website_volume_mount_set="false"
  local cassandra_website_source_set="false"

  if [ -f "${env_file}" ]
  then
    env_file_arg="--env-file ${env_file}"
  fi

  # The following are examples of the optional repository inputs we want to parse and convert into their equivalent
  # ANTORA_CONTENT_SOURCES_* docker environment s.
  # branch option - cassandra:trunk,my_test_branch_311,my_test_branch_40 -> ANTORA_CONTENT_SOURCES_CASSANDRA_BRANCHES=trunk,my_test_branch_311,my_test_branch_40
  # tag option - cassandra:cassandra-4.0,cassandra-3.11,cassandra-3.0 -> ANTORA_CONTENT_SOURCES_CASSANDRA_TAGS=cassandra-4.0,cassandra-3.11,cassandra-3.0
  # url option - cassandra:https://github.com/myfork/cassandra.git -> ANTORA_CONTENT_SOURCES_CASSANDRA_URL=https://github.com/myfork/cassandra.git
  #
  # We can do this by iterating through each of the repository source arrays and splitting the repository name from its
  # supplied value. The eval command for the inner for loop resolves to "${repository_<type>[*]}". This combined with
  # the outer for loop means we will process all the values in arrays: repository_branches, repository_tags, repository_url.
  for repository_source_type in branches tags url
  do
    for repository_source in $(eval echo \$\{"repository_${repository_source_type}"\[\*\]\})
    do
      repository_name=$(sed '1,/:/s/:/=/' <<< "${repository_source}" | cut -d'=' -f1)
      repository_value=$(sed '1,/:/s/:/=/' <<< "${repository_source}" | cut -d'=' -f2)

      # When we are asked to generate only the docs (i.e. command argument passed is 'docs'), we can ignore all
      # repository information except for the cassandra repository.
      if [ "${container_command}" = "generate-docs" ] && [ "${repository_name}" != "cassandra" ]
      then
        continue
      fi

      case "${repository_source_type}" in
        url)
          local url_source_name="${repository_name}"
          local url_source_value="${repository_value}"
          set_antora_url_source
          repository_value="${url_source_value}"
        ;;
        branches | tags)
          # Check if we have a comma delimited list. If so, replace the commas with spaces and quote the string so the
          # spaces and values are preserved when passed to Docker.
          if [ "$(tr -dc ',' <<< "${repository_value}" | wc -c)" -gt 0 ]
          then
            repository_value="\"${repository_value//,/ }\""
          fi
        ;;
      esac

      antora_content_source_env_name="ANTORA_CONTENT_SOURCES_$(
        tr '[:lower:]' '[:upper:]' <<< "${repository_name}" |
        sed 's/\-/_/g'
      )_$(
        tr '[:lower:]' '[:upper:]' <<< "${repository_source_type}"
      )"

      env_args+=("-e ${antora_content_source_env_name}=${repository_value}")
    done
  done

  if [ "${container_command}" = "generate-docs" ]
  then
    # Check if a local Cassandra repository path will be mounted inside the container when only generating the docs. If
    # the caller is to access the generated AsciiDocs they will need to do this. If no local Cassandra repository is
    # going to be mounted then display a warning message and prompt the caller to continue.
    if [ "${cassandra_volume_mount_set}" = "false" ]
    then
      cat <<EOF

** WARNING **
You have asked to run only the AsciiDoc generation without specifying a path to local copy of a Cassandra repository.
This means the AsciiDoc changes generated by the container tooling will be inaccessible, because they will be made to
a repository within the container.

EOF
      while true
        do
        read -r -p "Do you want to continue [Y/n]? " yn
        case $yn in
            [Y]*)
              break
            ;;
            [Nn]*)
              echo "Aborting!"
              exit 0
            ;;
            *)
              echo "Please answer [Y]es or [n]o."
            ;;
        esac
      done
    fi
  else
    # Check if the local cassandra-website repository will be mounted inside the container. We need to mount the
    # cassandra-website directory inside the container so the caller has access to the generated HTML website. The
    # generated website HTML (and documentation if specified) output will be placed in the path mapped to the mounted
    # local directory.
    if [ "${cassandra_website_volume_mount_set}" = "false" ]
    then
      vol_args+=("-v $(pwd):${container_build_dir}/cassandra-website")
    fi

    # Check if a source for the cassandra-website repository is specified. We need to define a source if none was
    # supplied by the caller. By default we will use the mounted cassandra-website directory. This provides a good
    # user experience as the caller can run the script with minimal arguments and it will render what is on their
    # local clone of the repository.
    if [ "${cassandra_website_source_set}" = "false" ]
    then
      env_args+=("-e ANTORA_CONTENT_SOURCES_CASSANDRA_WEBSITE_URL=${container_build_dir}/cassandra-website")
    fi

    # CASSANDRA-16913:
    # Include the local site-ui/build/ui-bundle.zip automatically, unless an alternative path has been defined via the
    # '-z' option. If we are on a custom branch, we would expect the local site-ui/build/ui-bundle.zip to be used from
    # that branch. It would be unintuitive if an updated version of the file is there but left unused, and requires the
    # user to specify the '-z' option.
    if [ -z "${ui_bundle_zip_url}" ]
    then
      ui_bundle_zip_url="$(pwd)/site-ui/build/ui-bundle.zip"
    fi
    local url_source_name=$(rev <<< "${ui_bundle_zip_url}" | cut -d'/' -f1 | rev)
    local url_source_value="${ui_bundle_zip_url}"
    set_antora_url_source
    env_args+=("-e ANTORA_UI_BUNDLE_URL=${url_source_value}")
  fi

  exec_docker_run_command --name "website_content" "${port_map_option} ${vol_args[*]} ${env_file_arg} ${env_args[*]} ${container_tag} ${command_generate_docs} ${container_command}"
}

run_website_command() {
  local command=$1

  if [ -z "${container_tag}" ]
  then
    container_tag="apache/cassandra-website:latest"
  fi

  case "${command}" in
    container)
      build_container "content"
    ;;

    docs)
      run_docker_website_command "generate-docs"
    ;;

    build)
      run_docker_website_command "build-site"
    ;;

    preview)
      run_docker_website_command "preview"
    ;;

    *)
      error "Unrecognised website command - ${command}"
    ;;
  esac
}

run_docker_website_ui_command() {
  local container_command=$1
  local container_build_dir=""
  local port_map_option=""
  local volume_map_option=""

  if [ -z "$(docker images -q "${container_tag}")" ]
  then
    build_container "ui"
  fi

  if [ "${container_command}" = "preview" ]
  then
    port_map_option="-p 5252:5252/tcp"
  fi

  container_build_dir=$(get_container_build_dir)
  volume_map_option="$(pwd)/site-ui/:${container_build_dir}/site-ui"

  if [ "${container_command}" = "help" ]
  then
    exec_docker_run_command --name "website_ui" -v "${volume_map_option}" "${container_tag}"
  else
    exec_docker_run_command --name "website_ui" "${port_map_option}" -v "${volume_map_option}" "${container_tag}" "${container_command}"
  fi
}

run_website_ui_command() {
  local command=$1

  if [ -z "${container_tag}" ]
  then
    container_tag="apache/cassandra-website-ui:latest"
  fi

  case "${command}" in
    container)
      build_container "ui"
    ;;

    help | tasks)
      run_docker_website_ui_command "help"
    ;;

    *)
      run_docker_website_ui_command "${command}"
    ;;
  esac
}

### Main ###

env_file=""
container_tag=""
container_build_args=()
repository_branches=()
repository_tags=()
repository_url=()
ui_bundle_zip_url=""
command_generate_docs=""
persist_container_after_run="disabled"
dry_run="disabled"

arg_component=""
arg_command=""

if [ "$#" -eq 0 ]
then
  error "Missing component argument"
fi

arg_component="$1"
shift 1

if [ "$#" -eq 0 ] && [ "${arg_component}" != "help" ]
then
  error "Missing command argument"
fi

arg_command="$1"
shift 1

parse_website_command_options "$@"

docker_output=""

if ! docker_output=$(docker version)
then
  echo
  echo -n "ERROR: "
  tail -n 1 <<<"${docker_output}"
else
  echo -n "Server Docker Engine version: "
  grep -A 2 "Server" <<<"${docker_output}" | grep "Version" | tr -s ' ' | cut -d' ' -f3
fi

case "${arg_component}" in
  website)
    run_website_command "${arg_command}"
  ;;

  website-ui)
    run_website_ui_command "${arg_command}"
  ;;

  help)
    usage 0
  ;;

  *)
    error "Unrecognised component - ${arg_component}"
  ;;
esac
