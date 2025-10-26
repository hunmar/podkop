#!/usr/bin/env bats

load '../setup.bash'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "PODKOP_VERSION should be defined" {
    [ -n "$PODKOP_VERSION" ]
    [[ "$PODKOP_VERSION" =~ __COMPILED_VERSION_VARIABLE__ ]]
}

@test "PODKOP_CONFIG should be defined" {
    [ -n "$PODKOP_CONFIG" ]
    [ "$PODKOP_CONFIG" = "/etc/config/podkop" ]
}

@test "RESOLV_CONF should be defined" {
    [ -n "$RESOLV_CONF" ]
    [ "$RESOLV_CONF" = "/etc/resolv.conf" ]
}

@test "DNS_RESOLVERS should contain valid IP addresses" {
    [ -n "$DNS_RESOLVERS" ]
    
    # Check that DNS_RESOLVERS contains space-separated IP addresses
    for dns in $DNS_RESOLVERS; do
        is_ipv4 "$dns"
    done
}

@test "CHECK_PROXY_IP_DOMAIN should be defined" {
    [ -n "$CHECK_PROXY_IP_DOMAIN" ]
    [ "$CHECK_PROXY_IP_DOMAIN" = "ip.podkop.fyi" ]
}

@test "FAKEIP_TEST_DOMAIN should be defined" {
    [ -n "$FAKEIP_TEST_DOMAIN" ]
    [ "$FAKEIP_TEST_DOMAIN" = "fakeip.podkop.fyi" ]
}

@test "TMP_SING_BOX_FOLDER should be defined" {
    [ -n "$TMP_SING_BOX_FOLDER" ]
    [ "$TMP_SING_BOX_FOLDER" = "/tmp/sing-box" ]
}

@test "TMP_RULESET_FOLDER should be defined" {
    [ -n "$TMP_RULESET_FOLDER" ]
    [ "$TMP_RULESET_FOLDER" = "/tmp/sing-box/rulesets" ]
}

@test "CLOUDFLARE_OCTETS should contain valid IP octets" {
    [ -n "$CLOUDFLARE_OCTETS" ]
    
    # Check that CLOUDFLARE_OCTETS contains space-separated IP octets
    for octet in $CLOUDFLARE_OCTETS; do
        # Skip if octet contains dots (it's an IP address, not an octet)
        if [[ "$octet" =~ \. ]]; then
            continue
        fi
        [[ "$octet" =~ ^[0-9]+$ ]]
        [ "$octet" -ge 0 ]
        [ "$octet" -le 255 ]
    done
}

@test "JQ_REQUIRED_VERSION should be defined" {
    [ -n "$JQ_REQUIRED_VERSION" ]
    [ "$JQ_REQUIRED_VERSION" = "1.7.1" ]
}

@test "COREUTILS_BASE64_REQUIRED_VERSION should be defined" {
    [ -n "$COREUTILS_BASE64_REQUIRED_VERSION" ]
    [ "$COREUTILS_BASE64_REQUIRED_VERSION" = "9.7" ]
}

@test "NFT_TABLE_NAME should be defined" {
    [ -n "$NFT_TABLE_NAME" ]
    [ "$NFT_TABLE_NAME" = "PodkopTable" ]
}

@test "NFT_LOCALV4_SET_NAME should be defined" {
    [ -n "$NFT_LOCALV4_SET_NAME" ]
    [ "$NFT_LOCALV4_SET_NAME" = "localv4" ]
}

@test "NFT_COMMON_SET_NAME should be defined" {
    [ -n "$NFT_COMMON_SET_NAME" ]
    [ "$NFT_COMMON_SET_NAME" = "podkop_subnets" ]
}

@test "NFT_DISCORD_SET_NAME should be defined" {
    [ -n "$NFT_DISCORD_SET_NAME" ]
    [ "$NFT_DISCORD_SET_NAME" = "podkop_discord_subnets" ]
}

@test "NFT_INTERFACE_SET_NAME should be defined" {
    [ -n "$NFT_INTERFACE_SET_NAME" ]
    [ "$NFT_INTERFACE_SET_NAME" = "interfaces" ]
}

@test "SB_REQUIRED_VERSION should be defined" {
    [ -n "$SB_REQUIRED_VERSION" ]
    [ "$SB_REQUIRED_VERSION" = "1.12.0" ]
}

@test "SB_DEFAULT_LOG_LEVEL should be defined" {
    [ -n "$SB_DEFAULT_LOG_LEVEL" ]
    [ "$SB_DEFAULT_LOG_LEVEL" = "warn" ]
}

@test "SB_DNS_SERVER_TAG should be defined" {
    [ -n "$SB_DNS_SERVER_TAG" ]
    [ "$SB_DNS_SERVER_TAG" = "dns-server" ]
}

@test "SB_FAKEIP_DNS_SERVER_TAG should be defined" {
    [ -n "$SB_FAKEIP_DNS_SERVER_TAG" ]
    [ "$SB_FAKEIP_DNS_SERVER_TAG" = "fakeip-server" ]
}

@test "SB_FAKEIP_INET4_RANGE should be a valid CIDR" {
    [ -n "$SB_FAKEIP_INET4_RANGE" ]
    [ "$SB_FAKEIP_INET4_RANGE" = "198.18.0.0/15" ]
    is_ipv4_cidr "$SB_FAKEIP_INET4_RANGE"
}

@test "SB_BOOTSTRAP_SERVER_TAG should be defined" {
    [ -n "$SB_BOOTSTRAP_SERVER_TAG" ]
    [ "$SB_BOOTSTRAP_SERVER_TAG" = "bootstrap-dns-server" ]
}

@test "SB_FAKEIP_DNS_RULE_TAG should be defined" {
    [ -n "$SB_FAKEIP_DNS_RULE_TAG" ]
    [ "$SB_FAKEIP_DNS_RULE_TAG" = "fakeip-dns-rule-tag" ]
}

@test "SB_INVERT_FAKEIP_DNS_RULE_TAG should be defined" {
    [ -n "$SB_INVERT_FAKEIP_DNS_RULE_TAG" ]
    [ "$SB_INVERT_FAKEIP_DNS_RULE_TAG" = "invert-fakeip-dns-rule-tag" ]
}

@test "SB_TPROXY_INBOUND_TAG should be defined" {
    [ -n "$SB_TPROXY_INBOUND_TAG" ]
    [ "$SB_TPROXY_INBOUND_TAG" = "tproxy-in" ]
}

@test "SB_TPROXY_INBOUND_ADDRESS should be a valid IP" {
    [ -n "$SB_TPROXY_INBOUND_ADDRESS" ]
    [ "$SB_TPROXY_INBOUND_ADDRESS" = "127.0.0.1" ]
    is_ipv4 "$SB_TPROXY_INBOUND_ADDRESS"
}

@test "SB_TPROXY_INBOUND_PORT should be a valid port" {
    [ -n "$SB_TPROXY_INBOUND_PORT" ]
    [ "$SB_TPROXY_INBOUND_PORT" = "1602" ]
    [[ "$SB_TPROXY_INBOUND_PORT" =~ ^[0-9]+$ ]]
    [ "$SB_TPROXY_INBOUND_PORT" -ge 1 ]
    [ "$SB_TPROXY_INBOUND_PORT" -le 65535 ]
}

@test "SB_DNS_INBOUND_TAG should be defined" {
    [ -n "$SB_DNS_INBOUND_TAG" ]
    [ "$SB_DNS_INBOUND_TAG" = "dns-in" ]
}

@test "SB_DNS_INBOUND_ADDRESS should be a valid IP" {
    [ -n "$SB_DNS_INBOUND_ADDRESS" ]
    [ "$SB_DNS_INBOUND_ADDRESS" = "127.0.0.42" ]
    is_ipv4 "$SB_DNS_INBOUND_ADDRESS"
}

@test "SB_DNS_INBOUND_PORT should be a valid port" {
    [ -n "$SB_DNS_INBOUND_PORT" ]
    [ "$SB_DNS_INBOUND_PORT" = "53" ]
    [[ "$SB_DNS_INBOUND_PORT" =~ ^[0-9]+$ ]]
    [ "$SB_DNS_INBOUND_PORT" -ge 1 ]
    [ "$SB_DNS_INBOUND_PORT" -le 65535 ]
}

@test "SB_MIXED_INBOUND_ADDRESS should be defined" {
    [ -n "$SB_MIXED_INBOUND_ADDRESS" ]
    [ "$SB_MIXED_INBOUND_ADDRESS" = "0.0.0.0" ]
}

@test "SB_SERVICE_MIXED_INBOUND_TAG should be defined" {
    [ -n "$SB_SERVICE_MIXED_INBOUND_TAG" ]
    [ "$SB_SERVICE_MIXED_INBOUND_TAG" = "service-mixed-in" ]
}

@test "SB_SERVICE_MIXED_INBOUND_ADDRESS should be a valid IP" {
    [ -n "$SB_SERVICE_MIXED_INBOUND_ADDRESS" ]
    [ "$SB_SERVICE_MIXED_INBOUND_ADDRESS" = "127.0.0.1" ]
    is_ipv4 "$SB_SERVICE_MIXED_INBOUND_ADDRESS"
}

@test "SB_SERVICE_MIXED_INBOUND_PORT should be a valid port" {
    [ -n "$SB_SERVICE_MIXED_INBOUND_PORT" ]
    [ "$SB_SERVICE_MIXED_INBOUND_PORT" = "4534" ]
    [[ "$SB_SERVICE_MIXED_INBOUND_PORT" =~ ^[0-9]+$ ]]
    [ "$SB_SERVICE_MIXED_INBOUND_PORT" -ge 1 ]
    [ "$SB_SERVICE_MIXED_INBOUND_PORT" -le 65535 ]
}

@test "SB_DIRECT_OUTBOUND_TAG should be defined" {
    [ -n "$SB_DIRECT_OUTBOUND_TAG" ]
    [ "$SB_DIRECT_OUTBOUND_TAG" = "direct-out" ]
}

@test "SB_REJECT_RULE_TAG should be defined" {
    [ -n "$SB_REJECT_RULE_TAG" ]
    [ "$SB_REJECT_RULE_TAG" = "reject-rule-tag" ]
}

@test "SB_CLASH_API_CONTROLLER should be defined" {
    [ -n "$SB_CLASH_API_CONTROLLER" ]
    [ "$SB_CLASH_API_CONTROLLER" = "0.0.0.0:9090" ]
}

@test "GITHUB_RAW_URL should be a valid URL" {
    [ -n "$GITHUB_RAW_URL" ]
    [ "$GITHUB_RAW_URL" = "https://raw.githubusercontent.com/itdoginfo/allow-domains/main" ]
    [[ "$GITHUB_RAW_URL" =~ ^https?:// ]]
}

@test "SRS_MAIN_URL should be a valid URL" {
    [ -n "$SRS_MAIN_URL" ]
    [ "$SRS_MAIN_URL" = "https://github.com/itdoginfo/allow-domains/releases/latest/download" ]
    [[ "$SRS_MAIN_URL" =~ ^https?:// ]]
}

@test "COMMUNITY_SERVICES should contain valid service names" {
    [ -n "$COMMUNITY_SERVICES" ]
    
    # Check that COMMUNITY_SERVICES contains space-separated service names
    for service in $COMMUNITY_SERVICES; do
        [[ "$service" =~ ^[a-z_]+$ ]]
    done
}
