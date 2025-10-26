#!/usr/bin/env bats

load '../setup.bash'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "log should log messages with default level" {
    # Test that log function works without errors
    log "Test message"
    
    # Test with explicit info level
    log "Test message" "info"
}

@test "log should log messages with different levels" {
    # Test different log levels
    log "Debug message" "debug"
    log "Info message" "info"
    log "Warning message" "warn"
    log "Error message" "error"
    log "Fatal message" "fatal"
}

@test "nolog should output colored messages" {
    # Test nolog function
    local output
    output=$(nolog "Test message")
    
    # Should contain color codes and timestamp
    [[ "$output" =~ \[.*\] ]]
    [[ "$output" =~ Test\ message ]]
}

@test "echolog should log and output messages" {
    # Test echolog function
    local output
    output=$(echolog "Test message" "info")
    
    # Should contain the message
    [[ "$output" =~ Test\ message ]]
}

@test "log should handle empty messages" {
    # Test with empty message
    log ""
    log "" "info"
}

@test "log should handle special characters in messages" {
    # Test with special characters
    log "Message with spaces and symbols: !@#$%^&*()"
    log "Message with newlines\nand tabs\t"
    log "Message with quotes \"double\" and 'single'"
}

@test "nolog should handle empty messages" {
    # Test nolog with empty message
    local output
    output=$(nolog "")
    
    # Should still produce output with timestamp
    [[ "$output" =~ \[.*\] ]]
}

@test "echolog should handle different log levels" {
    # Test echolog with different levels
    echolog "Debug message" "debug"
    echolog "Info message" "info"
    echolog "Warning message" "warn"
    echolog "Error message" "error"
    echolog "Fatal message" "fatal"
}

@test "log functions should handle long messages" {
    # Test with long message
    local long_message="This is a very long message that contains many characters and should be handled properly by the logging functions without any issues or truncation"
    
    log "$long_message"
    nolog "$long_message"
    echolog "$long_message" "info"
}

@test "log functions should handle messages with variables" {
    # Test with variable substitution
    local var1="test"
    local var2="message"
    
    log "Variable test: $var1 $var2"
    nolog "Variable test: $var1 $var2"
    echolog "Variable test: $var1 $var2" "info"
}
