#!/usr/bin/env bats

load '../setup.bash'

@test "is_ipv4 should validate correct IPv4 addresses" {
    # Valid IPv4 addresses
    is_ipv4 "192.168.1.1"
    is_ipv4 "127.0.0.1"
    is_ipv4 "0.0.0.0"
    is_ipv4 "255.255.255.255"
    is_ipv4 "10.0.0.1"
    is_ipv4 "172.16.0.1"
}

@test "is_ipv4 should reject invalid IPv4 addresses" {
    # Invalid IPv4 addresses
    ! is_ipv4 "192.168.1.256"
    ! is_ipv4 "192.168.1"
    ! is_ipv4 "192.168.1.1.1"
    ! is_ipv4 "192.168.1.1."
    ! is_ipv4 ".192.168.1.1"
    ! is_ipv4 "192.168.1.1.1.1"
    ! is_ipv4 "192.168.1.-1"
    ! is_ipv4 "192.168.1.01"
    ! is_ipv4 "192.168.1.1a"
    ! is_ipv4 ""
    ! is_ipv4 "not an ip"
}

@test "is_ipv4_cidr should validate correct IPv4 CIDR notation" {
    # Valid IPv4 CIDR
    is_ipv4_cidr "192.168.1.0/24"
    is_ipv4_cidr "10.0.0.0/8"
    is_ipv4_cidr "172.16.0.0/12"
    is_ipv4_cidr "192.168.1.1/32"
    is_ipv4_cidr "0.0.0.0/0"
    is_ipv4_cidr "255.255.255.255/32"
}

@test "is_ipv4_cidr should reject invalid IPv4 CIDR notation" {
    # Invalid IPv4 CIDR
    ! is_ipv4_cidr "192.168.1.0/33"
    ! is_ipv4_cidr "192.168.1.0/-1"
    ! is_ipv4_cidr "192.168.1.0"
    ! is_ipv4_cidr "192.168.1.0/"
    ! is_ipv4_cidr "/24"
    ! is_ipv4_cidr "192.168.1.256/24"
    ! is_ipv4_cidr "192.168.1.0/24/8"
    ! is_ipv4_cidr ""
    ! is_ipv4_cidr "not a cidr"
}

@test "is_ipv4_ip_or_ipv4_cidr should validate both IPv4 and CIDR" {
    # Valid IPv4 addresses
    is_ipv4_ip_or_ipv4_cidr "192.168.1.1"
    is_ipv4_ip_or_ipv4_cidr "127.0.0.1"
    
    # Valid CIDR
    is_ipv4_ip_or_ipv4_cidr "192.168.1.0/24"
    is_ipv4_ip_or_ipv4_cidr "10.0.0.0/8"
    
    # Invalid cases
    ! is_ipv4_ip_or_ipv4_cidr "192.168.1.256"
    ! is_ipv4_ip_or_ipv4_cidr "192.168.1.0/33"
    ! is_ipv4_ip_or_ipv4_cidr "not an ip"
}

@test "is_domain should validate correct domain names" {
    # Valid domains
    is_domain "example.com"
    is_domain "sub.example.com"
    is_domain "a.b.c.d.e"
    is_domain "test-domain.com"
    is_domain "123.com"
    is_domain "a1b2c3.com"
    is_domain "example.co.uk"
    is_domain "example.org"
    is_domain "example.net"
}

@test "is_domain should reject invalid domain names" {
    # Invalid domains
    ! is_domain ".example.com"
    ! is_domain "example.com."
    ! is_domain "example..com"
    ! is_domain "-example.com"
    ! is_domain "example-.com"
    ! is_domain "example.-com"
    ! is_domain "example.com-"
    ! is_domain ""
    ! is_domain "not a domain"
    ! is_domain "example@com"
    ! is_domain "example com"
}

@test "is_domain_suffix should validate domain suffixes" {
    # Valid domain suffixes
    is_domain_suffix ".example.com"
    is_domain_suffix "example.com"
    is_domain_suffix ".sub.example.com"
    is_domain_suffix ".co.uk"
    
    # Invalid domain suffixes
    ! is_domain_suffix "example.com."
    ! is_domain_suffix "..example.com"
    ! is_domain_suffix "-example.com"
    ! is_domain_suffix "example-.com"
    ! is_domain_suffix ""
    ! is_domain_suffix "not a suffix"
}

@test "is_base64 should validate base64 encoded strings" {
    # Valid base64
    is_base64 "SGVsbG8gV29ybGQ="
    is_base64 "dGVzdA=="
    is_base64 "YWJjZGVmZ2hpams="
    is_base64 "MTIzNDU2Nzg5MA=="
    
    # Invalid base64
    ! is_base64 "SGVsbG8gV29ybGQ"
    ! is_base64 "SGVsbG8gV29ybGQ=="
    ! is_base64 "SGVsbG8gV29ybGQ==="
    ! is_base64 "SGVsbG8gV29ybGQ!="
    ! is_base64 "SGVsbG8gV29ybGQ@="
    ! is_base64 ""
    ! is_base64 "not base64"
}

@test "is_shadowsocks_userinfo_format should validate shadowsocks userinfo" {
    # Valid shadowsocks userinfo
    is_shadowsocks_userinfo_format "method:password"
    is_shadowsocks_userinfo_format "aes-256-gcm:password123"
    is_shadowsocks_userinfo_format "chacha20-ietf-poly1305:secret"
    is_shadowsocks_userinfo_format "method:password:plugin"
    is_shadowsocks_userinfo_format "aes-256-gcm:password:obfs"
    
    # Invalid shadowsocks userinfo
    ! is_shadowsocks_userinfo_format "method"
    ! is_shadowsocks_userinfo_format ":password"
    ! is_shadowsocks_userinfo_format "method:"
    ! is_shadowsocks_userinfo_format "method:password:plugin:extra"
    ! is_shadowsocks_userinfo_format ""
    ! is_shadowsocks_userinfo_format "not userinfo"
}

@test "is_min_package_version should compare versions correctly" {
    # Test version comparisons
    is_min_package_version "1.0.0" "1.0.0"
    is_min_package_version "1.1.0" "1.0.0"
    is_min_package_version "1.0.1" "1.0.0"
    is_min_package_version "2.0.0" "1.9.9"
    is_min_package_version "1.12.4" "1.12.0"
    
    # Test version that doesn't meet minimum
    ! is_min_package_version "0.9.9" "1.0.0"
    ! is_min_package_version "1.0.0" "1.1.0"
    ! is_min_package_version "1.11.9" "1.12.0"
}

@test "file_exists should check file existence" {
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # File should exist
    file_exists "$temp_file"
    
    # Clean up
    rm -f "$temp_file"
    
    # File should not exist
    ! file_exists "$temp_file"
    ! file_exists "/nonexistent/file"
    ! file_exists ""
}

@test "service_exists should check service existence" {
    # Mock service file
    local mock_service_dir=$(mktemp -d)
    local mock_service="$mock_service_dir/test-service"
    
    # Create mock service
    echo "#!/bin/sh" > "$mock_service"
    chmod +x "$mock_service"
    
    # Mock the /etc/init.d directory
    local original_path="$PATH"
    export PATH="$mock_service_dir:$PATH"
    
    # Service should exist
    service_exists "test-service"
    
    # Service should not exist
    ! service_exists "nonexistent-service"
    
    # Clean up
    export PATH="$original_path"
    rm -rf "$mock_service_dir"
}

@test "get_inbound_tag_by_section should generate correct inbound tags" {
    [ "$(get_inbound_tag_by_section "main")" = "main-in" ]
    [ "$(get_inbound_tag_by_section "test")" = "test-in" ]
    [ "$(get_inbound_tag_by_section "proxy")" = "proxy-in" ]
}

@test "get_outbound_tag_by_section should generate correct outbound tags" {
    [ "$(get_outbound_tag_by_section "main")" = "main-out" ]
    [ "$(get_outbound_tag_by_section "test")" = "test-out" ]
    [ "$(get_outbound_tag_by_section "proxy")" = "proxy-out" ]
}

@test "get_domain_resolver_tag should generate correct domain resolver tags" {
    [ "$(get_domain_resolver_tag "main")" = "main-domain-resolver" ]
    [ "$(get_domain_resolver_tag "test")" = "test-domain-resolver" ]
    [ "$(get_domain_resolver_tag "proxy")" = "proxy-domain-resolver" ]
}

@test "get_ruleset_tag should generate correct ruleset tags" {
    [ "$(get_ruleset_tag "main" "test")" = "main-test-ruleset" ]
    [ "$(get_ruleset_tag "main" "test" "type")" = "main-test-type-ruleset" ]
    [ "$(get_ruleset_tag "proxy" "block")" = "proxy-block-ruleset" ]
}

@test "get_ruleset_format_by_file_extension should return correct format" {
    [ "$(get_ruleset_format_by_file_extension "json")" = "source" ]
    [ "$(get_ruleset_format_by_file_extension "srs")" = "binary" ]
    
    # Test unsupported extension
    ! get_ruleset_format_by_file_extension "txt"
    ! get_ruleset_format_by_file_extension "xml"
    ! get_ruleset_format_by_file_extension ""
}

@test "comma_string_to_json_array should convert comma-separated strings" {
    [ "$(comma_string_to_json_array "a,b,c")" = '["a","b","c"]' ]
    [ "$(comma_string_to_json_array "test")" = '["test"]' ]
    [ "$(comma_string_to_json_array "")" = '[]' ]
    [ "$(comma_string_to_json_array "a")" = '["a"]' ]
}

@test "url_decode should decode URL-encoded strings" {
    [ "$(url_decode "hello%20world")" = "hello world" ]
    [ "$(url_decode "test%2Bplus")" = "test+plus" ]
    [ "$(url_decode "simple")" = "simple" ]
    [ "$(url_decode "")" = "" ]
}

@test "url_get_userinfo should extract userinfo from URLs" {
    [ "$(url_get_userinfo "http://user:pass@example.com")" = "user:pass" ]
    [ "$(url_get_userinfo "https://user@example.com")" = "user" ]
    [ "$(url_get_userinfo "http://example.com")" = "" ]
    [ "$(url_get_userinfo "ftp://user:pass@ftp.example.com/path")" = "user:pass" ]
}

@test "url_get_host should extract host from URLs" {
    [ "$(url_get_host "http://example.com")" = "example.com" ]
    [ "$(url_get_host "https://sub.example.com:8080")" = "sub.example.com" ]
    [ "$(url_get_host "http://user:pass@example.com:8080")" = "example.com" ]
    [ "$(url_get_host "ftp://ftp.example.com/path")" = "ftp.example.com" ]
}

@test "url_get_port should extract port from URLs" {
    [ "$(url_get_port "http://example.com:8080")" = "8080" ]
    [ "$(url_get_port "https://example.com:443")" = "443" ]
    [ "$(url_get_port "http://user:pass@example.com:8080")" = "8080" ]
    [ "$(url_get_port "http://example.com")" = "" ]
    [ "$(url_get_port "ftp://ftp.example.com:21/path")" = "21" ]
}

@test "url_get_path should extract path from URLs" {
    [ "$(url_get_path "http://example.com/path")" = "/path" ]
    [ "$(url_get_path "https://example.com:8080/path/to/file")" = "/path/to/file" ]
    [ "$(url_get_path "http://example.com")" = "/" ]
    [ "$(url_get_path "http://example.com/")" = "/" ]
    [ "$(url_get_path "ftp://ftp.example.com/path/file.txt")" = "/path/file.txt" ]
}

@test "url_get_query_param should extract query parameters" {
    [ "$(url_get_query_param "http://example.com?param=value" "param")" = "value" ]
    [ "$(url_get_query_param "http://example.com?param1=value1&param2=value2" "param2")" = "value2" ]
    [ "$(url_get_query_param "http://example.com?param=value&other=test" "other")" = "test" ]
    [ "$(url_get_query_param "http://example.com" "param")" = "" ]
    [ "$(url_get_query_param "http://example.com?param=" "param")" = "" ]
}

@test "url_get_basename should extract basename from URLs" {
    [ "$(url_get_basename "http://example.com/file.txt")" = "file" ]
    [ "$(url_get_basename "https://example.com/path/to/file.json")" = "file" ]
    [ "$(url_get_basename "http://example.com/file")" = "file" ]
    [ "$(url_get_basename "http://example.com/")" = "" ]
    [ "$(url_get_basename "http://example.com")" = "" ]
}

@test "url_get_file_extension should extract file extension from URLs" {
    [ "$(url_get_file_extension "http://example.com/file.txt")" = "txt" ]
    [ "$(url_get_file_extension "https://example.com/path/to/file.json")" = "json" ]
    [ "$(url_get_file_extension "http://example.com/file")" = "" ]
    [ "$(url_get_file_extension "http://example.com/")" = "" ]
    [ "$(url_get_file_extension "http://example.com")" = "" ]
}

@test "url_strip_fragment should remove URL fragments" {
    [ "$(url_strip_fragment "http://example.com#fragment")" = "http://example.com" ]
    [ "$(url_strip_fragment "https://example.com/path#fragment")" = "https://example.com/path" ]
    [ "$(url_strip_fragment "http://example.com")" = "http://example.com" ]
    [ "$(url_strip_fragment "http://example.com#")" = "http://example.com" ]
}

@test "base64_decode should decode base64 strings" {
    [ "$(base64_decode "SGVsbG8gV29ybGQ=")" = "Hello World" ]
    [ "$(base64_decode "dGVzdA==")" = "test" ]
    [ "$(base64_decode "YWJjZGVmZ2hpams=")" = "abcdefghijk" ]
    [ "$(base64_decode "")" = "" ]
}

@test "gen_id should generate unique IDs" {
    local id1=$(gen_id)
    local id2=$(gen_id)
    
    # IDs should be 16 characters long
    [ ${#id1} -eq 16 ]
    [ ${#id2} -eq 16 ]
    
    # IDs should be different
    [ "$id1" != "$id2" ]
    
    # IDs should contain only hexadecimal characters
    [[ "$id1" =~ ^[0-9a-f]{16}$ ]]
    [[ "$id2" =~ ^[0-9a-f]{16}$ ]]
}

@test "parse_domain_or_subnet_string_to_commas_string should parse domains correctly" {
    local result
    result=$(parse_domain_or_subnet_string_to_commas_string "example.com test.com invalid" "domains")
    [ "$result" = "example.com,test.com" ]
    
    result=$(parse_domain_or_subnet_string_to_commas_string "example.com,test.com" "domains")
    [ "$result" = "example.com,test.com" ]
    
    result=$(parse_domain_or_subnet_string_to_commas_string "invalid" "domains")
    [ "$result" = "" ]
}

@test "parse_domain_or_subnet_string_to_commas_string should parse subnets correctly" {
    local result
    result=$(parse_domain_or_subnet_string_to_commas_string "192.168.1.0/24 10.0.0.0/8 invalid" "subnets")
    [ "$result" = "192.168.1.0/24,10.0.0.0/8" ]
    
    result=$(parse_domain_or_subnet_string_to_commas_string "192.168.1.1 10.0.0.1" "subnets")
    [ "$result" = "192.168.1.1,10.0.0.1" ]
    
    result=$(parse_domain_or_subnet_string_to_commas_string "invalid" "subnets")
    [ "$result" = "" ]
}
