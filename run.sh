#!/bin/bash

debug() {
  >&2 echo "[DEBUG] $*"
}

# website
#  * tasks
#    - intree-gendocs (generate AsciiDoc in-tree docs only from nodetool and cassandra YAML)
#    - build (build site, including cassandra-website and in-tree versioned cassandra content. NOTE: have option to include intree-gendocs generation)
#    - container (build container. NOTE: have option to create a specific version tag)
#
# * services
#    - preview (start preview mode. NOTE: use environment variables to toggle docs generation)
#
# website-ui
#  * tasks (NOTE: Generate from gulpfile.js)
#
#  * services
#     - preview
#
# ./run website docs -e=ENV_FILE -l=LOCAL_CASSANDRA_REPO -c=CONTAINER_TAG -v=REPOSITORY:VERSION-1,...,VERSION-N -t=REPOSITORY:TAG-1,...,TAG-N -u=REPOSITORY:URL
# ./run website build -e=ENV_FILE -l=LOCAL_CASSANDRA_REPO -g (intree-gendocs) -c=CONTAINER_TAG -v=REPOSITORY:VERSION-1,...,VERSION-N -t=REPOSITORY:TAG-1,...,TAG-N -u=REPOSITORY:URL
# ./run website release -c=CONTAINER_TAG+
# ./run website preview -e=ENV_FILE -l=LOCAL_CASSANDRA_REPO -g (intree-gendocs) -c=CONTAINER_TAG -v=REPOSITORY:VERSION-1,...,VERSION-N -t=REPOSITORY:TAG-1,...,TAG-N -u=REPOSITORY:URL

# ./run website-ui <task>
# ./run website-ui lint
# ./run website-ui preview

usage() {
  cat <<EOF
This script builds the Cassandra website UI components, generates the Cassandra versioned documentation, and renders the website.

usage: ./run [OPTIONS] <COMPONENT> <COMMAND>

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
                                    -t cassandra:cassandra-4.0,cassandra-3.11,cassandra-3.0

        -u REPOSITORY:URL         The location defined by URL of the repository defined by REPOSITORY that will be used
                                  as the source content to generate the docs and/or website. This option can be
                                  specified multiple times. The valid values for REPOSITORY are only 'cassandra' and
                                  'cassandra-website'. The URL can be a HTTP git url or a file location on your local
                                  host. The repository and location are split by a colon ':'. For example:
                                    -u cassandra-website:~/local/path/to/cassandra-website
                                    -u cassandra:https://github.com/myfork/cassandra.git

        -z UI_BUNDLE_ZIP_URL      The UI bundle ZIP location defined by UI_BUNDLE_ZIP_URL that will be used to style the
                                  website when it is built. The value be a HTTP url or a file location on your local
                                  host.  For example:
                                    -z ~/local/path/to/ui-bundle.zip

        -v BUILD_ARG:VALUE        A container build argument defined by BUILD_ARG that overrides the default value with
                                  the value for VALUE. This option can be specified multiple times and is only applied
                                  when using the 'build' command. This option is ignored in all other cases. Possible
                                  arguments for BUILD_ARG are 'UID_ARG', 'GID_ARG', 'NODE_VERSION_ARG',
                                  'ENTR_VERSION_ARG', and 'CASSANDRA_REPOSITORY_URL_ARG'. The build argument and value
                                  are split by a colon ':'. For example:
                                    -v CASSANDRA_REPOSITORY_URL_ARG:https://github/user/my_cassandra_fork.git

        -g                        Enable generation of versioned docs when running website 'build', and
                                  'preview'. This option is ignored in all other cases.

        -a                        Disable automatically committing the generated docs to the Cassandra
                                  repository when using a single branch. Use this option when you use your local
                                  checkout of the Cassandra repository and want to commit any newly generated AsciiDoc
                                  to the repository yourself.

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
    exit 0
}

parse_website_command_options() {
  while getopts "e:c:b:t:u:z:v:gapdh" opt_flag
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
      v)
        container_build_args+=("$OPTARG")
      ;;
      g)
        command_generate_docs="generate-docs"
      ;;
      a)
        automatically_commit_generated_version_docs="disabled"
      ;;
      p)
        persist_container_after_run="enabled"
      ;;
      d)
        dry_run="enabled"
      ;;
      h)
        usage
      ;;
      *)
        usage
      ;;
    esac
  done
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
      location_source=${location_source//file\:\/\//}
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
    if [ "${location_source:0:1}" = "." ]
    then
      relative_path="${location_source}"
    fi
  elif [ -f "${location_source}" ]
  then
    location_type="file"
    if [ "${location_source:0:1}" = "." ]
    then
      file_name="$(basename "${location_source}")"
      relative_path="${location_source//${file_name}/}"
    fi
  fi

  if [ -n "${relative_path}" ]
  then
    pushd "${relative_path}" > /dev/null || { echo "Failed to change directory to '${relative_path}'."; exit 1; }
    location_source=$(pwd)
    popd > /dev/null || { echo "Failed to change back to working directory after changing to '${relative_path}'."; exit 1; }
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

  exec_docker_command "run -i -t ${remove_container_option} $*"
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

build_website_container() {
  local docker_build_args
  for key_value in ${container_build_args[*]}
  do
    docker_build_args+=(--build-arg "$(sed '0,/:/ s/:/=/' <<< "${key_value}")")
  done

  exec_docker_build_command "-f ./Dockerfile -t ${container_tag} ${docker_build_args[*]} ./"
}

build_website_ui_container() {
  exec_docker_build_command "-f ./site-ui/Dockerfile -t ${container_tag} ./site-ui/"
}

# This function requires the following two variables to be defined at a higher scope level
#
# url_source_name   - Name for any of the following: file, directory, or repository.
# url_source_value  - Value assigned to url_source_name. This value may change if it points to a local object.
set_antora_url_source() {
  local location_source=""
  local location_type=""
  get_source_location_information

  if [ "${location_type}" = "dir" ] || [ "${location_type}" = "file" ]
  then
    if [ "${url_source_name}" = "cassandra-website" ]
    then
      cassandra_website_source_set="true"
    fi
    url_source_value="/home/build/${url_source_name}"
    vol_args+=("-v ${location_source}:${url_source_value}")
  fi
}

run_docker_website_command() {
  local container_command=$1
  local port_map_option=""

  if [ "${container_command}" = "preview" ]
  then
    port_map_option="-p 5151:5151/tcp"
  fi

  local env_file_arg
  local env_args=()
  local vol_args=()

  local repository_name
  local repository_value

  local antora_content_source_env_name

  local cassandra_website_source_set

  if [ -z "$(docker images -q "${container_tag}")" ]
  then
    build_website_container
  fi

  if [ -f "${env_file}" ]
  then
    env_file_arg="--env-file ${env_file}"
  fi

  # We want to handle the following argument inputs and convert them to their equivalent ANTORA_CONTENT_SOURCES docker
  # environment variable.
  # cassandra:trunk,my_test_branch_311,my_test_branch_40 -> ANTORA_CONTENT_SOURCES_CASSANDRA_BRANCHES=trunk,my_test_branch_311,my_test_branch_40
  # cassandra:cassandra-4.0,cassandra-3.11,cassandra-3.0 -> ANTORA_CONTENT_SOURCES_CASSANDRA_TAGS=cassandra-4.0,cassandra-3.11,cassandra-3.0
  # cassandra:https://github.com/myfork/cassandra.git -> ANTORA_CONTENT_SOURCES_CASSANDRA_URL=https://github.com/myfork/cassandra.git
  #
  # We can do this by iterating through each of the repository source arrays and splitting the repository name from its
  # supplied value. The eval command for the inner for loop resolves to "${repository_<type>[*]}". This combined with
  # the outer for loop means we will process all the values in arrays: repository_branches, repository_tags, repository_url.
  cassandra_website_source_set="false"
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

      antora_content_source_env_name="ANTORA_CONTENT_SOURCES_$(
        tr '[:lower:]' '[:upper:]' <<< "${repository_name}" |
        sed 's/\-/_/g'
      )_$(
        tr '[:lower:]' '[:upper:]' <<< "${repository_source_type}"
      )"

      if [ "${repository_source_type}" = "url" ]
      then
        local url_source_name="${repository_name}"
        local url_source_value="${repository_value}"
        set_antora_url_source
        repository_value="${url_source_value}"
      fi

      env_args+=("-e ${antora_content_source_env_name}=${repository_value}")
    done
  done

  env_args+=("-e CREATE_GIT_COMMIT_WHEN_GENERATING_DOCS=${automatically_commit_generated_version_docs}")

  if [ "${container_command}" = "build-site" ] || [ "${container_command}" = "preview" ]
  then
    if [ "${cassandra_website_source_set}" = "false" ]
    then
      vol_args+=("-v $(pwd):/home/build/cassandra-website")
    fi

    if [ -n "${ui_bundle_zip_url}" ]
    then
      local url_source_name=""
      url_source_name=$(rev <<< "${ui_bundle_zip_url}" | cut -d'/' -f1 | rev)
      local url_source_value="${ui_bundle_zip_url}"
      set_antora_url_source
      env_args+=("-e ANTORA_UI_BUNDLE_URL=${url_source_value}")
    fi
  fi

  exec_docker_run_command "${port_map_option} ${vol_args[*]} ${env_file_arg} ${env_args[*]} ${container_tag} ${command_generate_docs} ${container_command}"
}

run_website_docs() {
  run_docker_website_command "generate-docs"
}

run_website_build() {
  run_docker_website_command "build-site"
}

run_website_preview() {
  run_docker_website_command "preview"
}

run_website_command() {
  local command=$1

  if [ -z "${container_tag}" ]
  then
    container_tag="apache/cassandra-website:latest"
  fi

  case "${command}" in
    container)
      build_website_container
    ;;

    docs)
      run_website_docs
    ;;

    build)
      run_website_build
    ;;

    preview)
      run_website_preview
    ;;
  esac
}

run_website_ui_command() {
  local command=$1

  if [ -z "${container_tag}" ]
  then
    container_tag="apache/cassandra-website-ui:latest"
  fi

  case "${command}" in
    container)
      build_website_ui_container
    ;;

    help | tasks)
      docker run -i -t -v "$(pwd)"/site-ui/:/home/site-ui ${container_tag}
    ;;

    *)
      if [ -z "$(docker images -q "${container_tag}")" ]
      then
        build_website_ui_container
      fi

      local port_map_option=""

      if [ "${command}" = "preview" ]
      then
        port_map_option="-p 5252:5252/tcp"
      fi

      exec_docker_run_command "${port_map_option} -v $(pwd)/site-ui/:/home/site-ui ${container_tag} $*"
    ;;
  esac
}

### Main ###

env_file=""
local_cassandra_repository_path=""
container_tag=""
container_build_args=()
repository_branches=()
repository_tags=()
repository_url=()
ui_bundle_zip_url=""
command_generate_docs=""
automatically_commit_generated_version_docs="enabled"
persist_container_after_run="disabled"
dry_run="disabled"

if [ "$#" -eq 0 ]
then
  usage
fi

parse_website_command_options "$@"
shift $((OPTIND - 1))

if [ "$#" -eq 0 ]
then
  usage
fi

arg_component=$1
shift 1
arg_command=$1

debug "${arg_component}"
debug "${arg_command}"

case "${arg_component}" in
  website)
    debug "env_file: ${env_file}"
    debug "local_cassandra_repository_path: ${local_cassandra_repository_path}"
    debug "container_tag: ${container_tag}"
    debug "container_build_args: ${container_build_args[*]}"
    debug "repository_branches: ${repository_branches[*]}"
    debug "repository_tags: ${repository_tags[*]}"
    debug "repository_url: ${repository_url[*]}"
    debug "ui_bundle_zip_url: ${ui_bundle_zip_url}"
    debug "command_generate_docs: ${command_generate_docs}"
    debug "automatically_commit_generated_version_docs: ${automatically_commit_generated_version_docs}"

    run_website_command "$@"
  ;;

  website-ui)
    run_website_ui_command "$@"
  ;;

  *)
    usage
  ;;
esac
