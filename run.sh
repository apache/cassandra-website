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
        -l LOCAL_CASSANDRA_REPO   Path defined by LOCAL_CASSANDRA_REPO to local Cassandra repository. Use this option if
                                  you want to use your local checkout of the Cassandra repository instead of the one
                                  inside the Docker website container.
        -c CONTAINER_TAG          Tag defined by CONTAINER_TAG of the website container.
        -v REPOSITORY:VERSIONS    List of versions defined by VERSIONS for a particular repository defined by
                                  REPOSITORY. The valid values for REPOSITORY are 'cassandra' and 'cassandra-website'.
                                  The values for VERSIONS are split by comma with no spaces. The repository and list of
                                  versions are split by a colon ':'. For example:
                                    -v cassandra:trunk,my_test_branch_311,my_test_branch_40
        -t REPOSITORY:TAGS        List of tags defined by TAGS for a particular repository defined by REPOSITORY.
                                  The valid values for REPOSITORY are 'cassandra' and 'cassandra-website'. The values
                                  for TAGS are split by comma with no spaces. The repository and list of tags are split
                                  by a colon ':'. For example:
                                    -t cassandra:cassandra-4.0,cassandra-3.11,cassandra-3.0
        -u REPOSITORY:URL         The location defined by URL of a particular repository defined by REPOSITORY.
                                  The valid values for REPOSITORY are 'cassandra' and 'cassandra-website'. The URL can
                                  be a HTTP git url or a file location on your local host. The repository and location
                                  are split by a colon ':'. For example:
                                    -s cassandra-website:~/work/cassandra-website
        -b BUILD_ARG:VALUE        A container build argument defined by BUILD_ARG that overrides the default value with
                                  the value for VALUE. This option can be specified multiple times and is only applied
                                  when using the 'build' command. This option is ignored in all other cases. The build
                                  argument and value are split by a colon ':'. For example:
                                    -b CASSANDRA_REPOSITORY_URL_ARG:https://github/user/my_cassandra_fork.git
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
  while getopts "e:l:c:v:t:u:b:gah" opt_flag; do
    case $opt_flag in
      e)
        env_file=$OPTARG
      ;;
      l)
        local_cassandra_repository_path=$OPTARG
      ;;
      c)
        container_tag=$OPTARG
      ;;
      v)
        repository_versions=$OPTARG
      ;;
      t)
        repository_tags=$OPTARG
      ;;
      u)
        repository_url=$OPTARG
      ;;
      b)
        container_build_args+=($OPTARG)
      ;;
      g)
        cmd_generate_versioned_docs="run"
      ;;
      a)
        automatically_commit_generated_version_docs="disabled"
      ;;
      h)
        usage
      ;;
    esac
done
}


build_website_container() {
  local docker_build_args
  for key_value in ${container_build_args[@]}
  do
    docker_build_args+=(--build-arg "$(sed '0,/:/ s/:/=/' <<< "${key_value}")")
  done

  docker build -f ./Dockerfile -t ${container_tag} ${docker_build_args[@]} ./
}


build_website_ui_container() {
  docker build -f ./site-ui/Dockerfile -t ${container_tag} ./site-ui/
}


run_website_preview() {
  local env_file_arg
  local env_args
  local cassandra_volume_arg

  if [ -n "${env_file}" ]
  then
    env_file_arg="--env-file .env.dev"
  fi

  if [ -n "${local_cassandra_repository_path}" ]
  then
    cassandra_volume_arg="-v ${local_cassandra_repository_path}:/home/build/cassandra"
  fi

  env_args=(-e CMD_PREVIEW="run")
  env_args+=(-e CMD_GENERATE_DOCS="${cmd_generate_versioned_docs}")
  env_args+=(-e GENERATE_DOCS_COMMIT_CHANGES_TO_LOCAL="${automatically_commit_generated_version_docs}")

  docker run -i -t -p 5151:5151/tcp -v "$(pwd)":/home/build/cassandra-website ${cassandra_volume_arg} ${env_file_arg} ${env_args[@]} ${container_tag}


#docker run -i -t -p 5151:5151 -v $(pwd):/home/build/cassandra-website --env-file .env.dev cassandra-website_website-dev:latest
#docker run -i -t -p 5151:5151 -v $(pwd):/home/build/cassandra-website -v $(pwd)/../cassandra:/home/build/cassandra --env-file .env.dev cassandra-website_website-dev:latest
#docker run -i -t -p 5151:5151 -v $(pwd):/home/build/cassandra-website -v $(pwd)/../cassandra:/home/build/cassandra -e PREVIEW_MODE=enabled cassandra-website_website-dev:latest
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
      debug "Generates the documentation the Cassandra versions defined."
    ;;

    build)
      debug "Build the website using Antora."
    ;;

    preview)
      debug "Launch a server that monitors the site content and renders the site when a change is detected."
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

      docker run -i -t ${port_map_option} -v "$(pwd)"/site-ui/:/home/site-ui ${container_tag} "$@"
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
repository_versions=""
repository_tags=""
repository_url=""
cmd_generate_versioned_docs=""
automatically_commit_generated_version_docs="enabled"


if [ "$#" -eq 0 ]
then
  usage
fi

parse_website_command_options "$@"
shift $(($OPTIND - 1))

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
    debug "container_build_args: ${container_build_args[@]}"
    debug "repository_versions: ${repository_versions}"
    debug "repository_tags: ${repository_tags}"
    debug "repository_url: ${repository_url}"
    debug "cmd_generate_versioned_docs: ${cmd_generate_versioned_docs}"
    debug "automatically_commit_generated_version_docs: ${automatically_commit_generated_version_docs}"

    run_website_command "$@"
  ;;

  website-ui)
    run_website_ui_command "$@"
  ;;

  *)
    usage
esac


