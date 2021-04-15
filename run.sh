#!/bin/bash

debug() {
  echo "[DEBUG] $1"
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
  cat << EOF
This script builds the Cassandra website UI components, generates the Cassandra versioned documentation, and renders the website.

usage: ./run [OPTIONS] <COMPONENT> <COMMAND>

Components
  The following values can be supplied for the COMPONENT argument.
    * website
    * website-ui

Commands
  Each of the components contains their own set of commands. Below is a list of the components and its associated commands.
    * website
        container       Build the container used to carry out the tasks.
        docs            Generates the documentation the Cassandra versions defined.
        build           Build the website using Antora.
        preview         Launch a server that monitors the site content and renders the site when a change is detected.

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

    cat << EOF
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
                                  when using the 'build' command. This option is ignored in all other cases. The build
                                  argument and value are split by a colon ':'. For example:
                                    -v CASSANDRA_REPOSITORY_URL_ARG:https://github/user/my_cassandra_fork.git

        -g                        Flag to enable generation of versioned docs when running website 'build', and
                                  'preview'. This option is ignored in all other cases.

        -a                        Flag to disable automatically committing the generated docs to the Cassandra
                                  repository when using a single branch. Use this option when you use your local
                                  checkout of the Cassandra repository and want to commit any newly generated AsciiDoc
                                  to the repository yourself.

    * website-ui
        -c CONTAINER_TAG          Tag defined by CONTAINER_TAG of the website container.
EOF
    exit 0
}


parse_website_command_options() {
  while getopts "e:c:b:t:u:z:v:gah" opt_flag; do
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
      h)
        usage
      ;;
      *)
        usage
      ;;
    esac
done
}


get_source_location_information() {
  local location_source

  location_source=$1
  location_type=""

  if [ "$(cut -d'/' -f1 <<< "${location_source}")" = "~" ]
  then
    location_source="${location_source//\~/$HOME}"
  fi

  if [ -d "${location_source}" ]
  then
    location_type="dir"
  elif [ -f "${location_source}" ]
  then
    location_type="file"
  else
    case $(cut -d':' -f1 <<< "${location_source}") in
      http | https)
        location_type="url"
      ;;
      file)
        location_source=$(sed 's/^file:\/\///g' <<< "${location_source}")
        if [ -d "${location_source}" ]
        then
          location_type="dir"
        elif [ -f "${location_source}" ]
        then
          location_type="file"
        else
          location_type="unknown"
        fi
      ;;
      *)
        location_type="unknown"
      ;;
    esac
  fi

  echo "${location_type}:${location_source}"
}


exec_docker_command() {
  echo
  echo "Executing docker command: 'docker $1'"
#  eval "docker $1"
}


build_website_container() {
  local docker_build_args
  for key_value in ${container_build_args[*]}
  do
    docker_build_args+=(--build-arg "$(sed '0,/:/ s/:/=/' <<< "${key_value}")")
  done

  exec_docker_command "build -f ./Dockerfile -t ${container_tag} ${docker_build_args[*]} ./"
}


build_website_ui_container() {
  exec_docker_command "build -f ./site-ui/Dockerfile -t ${container_tag} ./site-ui/"
}


set_antora_url_source() {
  local antora_env_name
  local antora_env_value

  local url_source_name
  local url_source_value

  local location_type
  local location_source

  antora_env_name="$1"
  url_source_name="$2"
  url_source_value="$3"

  antora_env_value="${url_source_value}"

  location_info=$(get_source_location_information "${url_source_value}")
  location_type=$(sed '0,/:/s/:/=/' <<< "${location_info}" | cut -d'=' -f1)
  location_source=$(sed '0,/:/s/:/=/' <<< "${location_info}" | cut -d'=' -f2)

  if [ "${location_type}" = "dir" ] || [ "${location_type}" = "file" ]
  then
    if [ "${url_source_name}" = "cassandra-website" ]
    then
      cassandra_website_source_set="true"
    fi
    antora_env_value="/home/build/${url_source_name}"
    vol_args+=("-v ${location_source}:${antora_env_value}")
  fi

  env_args+=("-e ${antora_env_name}=${antora_env_value}")
}


run_docker_website_command() {
  local container_command

  container_command="$1"

  local port_map_option=""

  if [ "${command}" = "preview" ]
  then
    port_map_option="-p 5151:5151/tcp"
  fi

  local env_file_arg
  local env_args
  local vol_args

  local repository_name
  local repository_value
  local location_type

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

  env_args=()
  vol_args=()

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
      repository_name=$(sed '0,/:/s/:/=/' <<< "${repository_source}" | cut -d'=' -f1)
      repository_value=$(sed '0,/:/s/:/=/' <<< "${repository_source}" | cut -d'=' -f2)

      antora_content_source_env_name="ANTORA_CONTENT_SOURCES_$(tr '[:lower:]' '[:upper:]' <<< "${repository_name}" | sed 's/\-/_/g')_$(tr '[:lower:]' '[:upper:]' <<< "${repository_source_type}")"

      if [ "${repository_source_type}" = "url" ]
      then
        set_antora_url_source "${antora_content_source_env_name}" "${repository_name}" "${repository_value}"
      else
        env_args+=("-e ${antora_content_source_env_name}=${repository_value}")
      fi
    done
  done

  if [ "${cassandra_website_source_set}" = "false" ]
  then
    vol_args+=("-v $(pwd):/home/build/cassandra-website")
  fi

  env_args+=("-e CREATE_GIT_COMMIT_WHEN_GENERATING_DOCS=${automatically_commit_generated_version_docs}")

  if [ -n "${ui_bundle_zip_url}" ]
  then
    ui_bundle_name=$(rev <<< "${ui_bundle_zip_url}" | cut -d'/' -f1 | rev)

    set_antora_url_source "ANTORA_UI_BUNDLE_URL" "${ui_bundle_name}" "${ui_bundle_zip_url}"
  fi

  exec_docker_command "run -i -t ${port_map_option} ${vol_args[*]} ${env_file_arg} ${env_args[*]} ${container_tag} ${command_generate_docs} ${container_command}"
}


run_website_build() {
  run_docker_website_command "build-site"
}


run_website_preview() {
  run_docker_website_command "preview"
}


run_website_command() {
  debug "run_website_command"

  local command=${1}

  if [ -z "${container_tag}" ]
  then
    container_tag="apache/cassandra-website:latest"
  fi

  case "${command}" in
    container)
      build_website_container
    ;;

    docs)
      debug "Generates the documentation for the specified Cassandra versions."
    ;;

    build)
      run_website_build
    ;;

    preview)
      run_website_preview
    ;;
  esac

  for ps_id in $(docker ps -a -q --filter 'exited=0')
  do
    docker rm "${ps_id}" > /dev/null
  done
}


run_website_ui_command() {
  local command=${1}

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

      exec_docker_command "run -i -t ${port_map_option} -v $(pwd)/site-ui/:/home/site-ui ${container_tag} $*"
    ;;
  esac

  for ps_id in $(docker ps -a -q --filter 'exited=0')
  do
    docker rm "${ps_id}" > /dev/null
  done
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

arg_component="${1}"
shift 1
arg_command="${1}"

debug "${arg_component}"
debug "${arg_command}"

case "${arg_component}" in
  website)
    #  parse_website_command_options "$@"

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
esac