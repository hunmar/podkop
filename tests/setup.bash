#!/bin/bash
# BATS test setup and helper functions

# Load the project's shell libraries
PODKOP_LIB="/workspace/podkop/files/usr/lib"
export PODKOP_LIB

# Source the project's helper functions
if [ -f "$PODKOP_LIB/helpers.sh" ]; then
    . "$PODKOP_LIB/helpers.sh"
fi

if [ -f "$PODKOP_LIB/logging.sh" ]; then
    . "$PODKOP_LIB/logging.sh"
fi

if [ -f "$PODKOP_LIB/constants.sh" ]; then
    . "$PODKOP_LIB/constants.sh"
fi

if [ -f "$PODKOP_LIB/sing_box_config_manager.sh" ]; then
    . "$PODKOP_LIB/sing_box_config_manager.sh"
fi

if [ -f "$PODKOP_LIB/nft.sh" ]; then
    . "$PODKOP_LIB/nft.sh"
fi

if [ -f "$PODKOP_LIB/sing_box_config_facade.sh" ]; then
    . "$PODKOP_LIB/sing_box_config_facade.sh"
fi

# Test helper functions
setup_test_environment() {
    # Create temporary directories for tests
    export TEST_TMP_DIR=$(mktemp -d)
    export TEST_FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"
    
    # Mock external commands that might not be available in test environment
    mock_command() {
        local cmd="$1"
        local script="$2"
        echo "#!/bin/bash" > "$TEST_TMP_DIR/$cmd"
        echo "$script" >> "$TEST_TMP_DIR/$cmd"
        chmod +x "$TEST_TMP_DIR/$cmd"
        export PATH="$TEST_TMP_DIR:$PATH"
    }
    
    # Mock common commands
    mock_command "logger" 'echo "MOCK LOGGER: $@" >&2'
    mock_command "uci" 'echo "MOCK UCI: $@"'
    mock_command "nft" 'echo "MOCK NFT: $@"'
    mock_command "jq" 'echo "MOCK JQ: $@" >&2; echo "{\"type\": \"test\", \"tag\": \"test-tag\", \"server\": \"test-server\", \"server_port\": 8080, \"disabled\": false, \"level\": \"info\", \"timestamp\": true, \"final\": \"test-final\", \"strategy\": \"test-strategy\", \"independent_cache\": true, \"action\": \"test-action\", \"enabled\": true, \"external_controller\": \"test-controller\", \"external_ui\": \"test-ui\", \"version\": 3, \"rules\": [], \"test\": \"value\", \"transport\": {\"type\": \"test\"}, \"tls\": {\"enabled\": true}, \"dns\": {\"servers\": [{\"type\": \"test\"}], \"rules\": [{\"action\": \"test-action\"}]}, \"inbounds\": [{\"type\": \"test\"}], \"outbounds\": [{\"type\": \"test\"}], \"route\": {\"rules\": [{\"action\": \"test-action\"}]}}"'
    mock_command "wget" 'echo "MOCK WGET: $@"'
    mock_command "curl" 'echo "MOCK CURL: $@"'
    mock_command "nslookup" 'echo "MOCK NSLOOKUP: $@"'
    mock_command "sing-box" 'echo "MOCK SING-BOX: $@"'
    mock_command "opkg" 'echo "MOCK OPKG: $@"'
    mock_command "apk" 'echo "MOCK APK: $@"'
}

teardown_test_environment() {
    # Clean up temporary files
    if [ -n "$TEST_TMP_DIR" ] && [ -d "$TEST_TMP_DIR" ]; then
        rm -rf "$TEST_TMP_DIR"
    fi
}

# Helper function to create test fixtures
create_test_fixture() {
    local fixture_name="$1"
    local content="$2"
    echo "$content" > "$TEST_FIXTURES_DIR/$fixture_name"
}

# Helper function to assert JSON output
assert_json_contains() {
    local json="$1"
    local key="$2"
    local expected="$3"
    
    local actual
    actual=$(echo "$json" | jq -r ".$key" 2>/dev/null)
    
    if [ "$actual" != "$expected" ]; then
        echo "JSON assertion failed:"
        echo "  Expected: $expected"
        echo "  Actual: $actual"
        echo "  JSON: $json"
        return 1
    fi
}

# Helper function to assert function return code
assert_function_success() {
    local func_name="$1"
    shift
    local args=("$@")
    
    if ! "$func_name" "${args[@]}" >/dev/null 2>&1; then
        echo "Function $func_name failed with args: ${args[*]}"
        return 1
    fi
}

assert_function_failure() {
    local func_name="$1"
    shift
    local args=("$@")
    
    if "$func_name" "${args[@]}" >/dev/null 2>&1; then
        echo "Function $func_name should have failed with args: ${args[*]}"
        return 1
    fi
}
