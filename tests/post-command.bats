#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following line to debug stub failures
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty
# export GIT_STUB_DEBUG=/dev/tty
# export CURL_STUB_DEBUG=/dev/tty

@test "Successfully creates tag and release" {
  export BUILDKITE_PLUGIN_GIT_TAG_VERSION=v1.0.123
  export BUILDKITE_PLUGIN_GIT_TAG_RELEASE=true
  export BUILDKITE_BRANCH=master
  export BUILDKITE_BUILD_NUMBER=test-buildkite-build-number
  export BUILDKITE_REPO=git@github.com:ailohq/git-tag-buildkite-plugin.git
  export BUILDKITE_BUILD_CREATOR="John Doe"
  export BUILDKITE_BUILD_CREATOR_EMAIL="test@test.com"
  export GITHUB_TOKEN=abc123

  stub git \
    "log -1 : echo commit message" \
    "config user.name \"John Doe\" : echo stub" \
    "config user.email \"test@test.com\" : echo stub" \
    "tag v1.0.123 -m \"Build $BUILDKITE_BUILD_NUMBER (branch: $BUILDKITE_BRANCH)\ncommit message\" : echo stub " \
    "push --tags : echo stub"
  stub curl

  run "$PWD/hooks/post-command"

  assert_success

  unstub git
}
