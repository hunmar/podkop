#!/usr/bin/env bats

load '../setup.bash'

@test "sing_box_cm_configure_log should configure logging section" {
    local config='{"log": {}}'
    local result
    result=$(sing_box_cm_configure_log "$config" "false" "info" "true")
    
    # Should contain log configuration
    [[ "$result" =~ "disabled" ]]
    [[ "$result" =~ "level" ]]
    [[ "$result" =~ "timestamp" ]]
}

@test "sing_box_cm_configure_dns should configure DNS section" {
    local config='{"dns": {}}'
    local result
    result=$(sing_box_cm_configure_dns "$config" "direct-out" "ipv4_only" "true")
    
    # Should contain DNS configuration
    [[ "$result" =~ "final" ]]
    [[ "$result" =~ "strategy" ]]
    [[ "$result" =~ "independent_cache" ]]
}

@test "sing_box_cm_add_udp_dns_server should add UDP DNS server" {
    local config='{"dns": {"servers": []}}'
    local result
    result=$(sing_box_cm_add_udp_dns_server "$config" "udp-server" "8.8.8.8" "53" "" "")
    
    # Should contain UDP DNS server
    [[ "$result" =~ "type.*udp" ]]
    [[ "$result" =~ "tag.*udp-server" ]]
    [[ "$result" =~ "server.*8.8.8.8" ]]
    [[ "$result" =~ "server_port.*53" ]]
}

@test "sing_box_cm_add_tls_dns_server should add TLS DNS server" {
    local config='{"dns": {"servers": []}}'
    local result
    result=$(sing_box_cm_add_tls_dns_server "$config" "dot-server" "1.1.1.1" "853" "" "")
    
    # Should contain TLS DNS server
    [[ "$result" =~ "type.*tls" ]]
    [[ "$result" =~ "tag.*dot-server" ]]
    [[ "$result" =~ "server.*1.1.1.1" ]]
    [[ "$result" =~ "server_port.*853" ]]
}

@test "sing_box_cm_add_https_dns_server should add HTTPS DNS server" {
    local config='{"dns": {"servers": []}}'
    local result
    result=$(sing_box_cm_add_https_dns_server "$config" "doh-server" "1.1.1.1" "443" "/dns-query" "" "" "")
    
    # Should contain HTTPS DNS server
    [[ "$result" =~ "type.*https" ]]
    [[ "$result" =~ "tag.*doh-server" ]]
    [[ "$result" =~ "server.*1.1.1.1" ]]
    [[ "$result" =~ "server_port.*443" ]]
    [[ "$result" =~ "path.*/dns-query" ]]
}

@test "sing_box_cm_add_fakeip_dns_server should add FakeIP DNS server" {
    local config='{"dns": {"servers": []}}'
    local result
    result=$(sing_box_cm_add_fakeip_dns_server "$config" "fakeip-server" "198.18.0.0/15")
    
    # Should contain FakeIP DNS server
    [[ "$result" =~ "type.*fakeip" ]]
    [[ "$result" =~ "tag.*fakeip-server" ]]
    [[ "$result" =~ "inet4_range.*198.18.0.0/15" ]]
}

@test "sing_box_cm_add_dns_route_rule should add DNS route rule" {
    local config='{"dns": {"rules": []}}'
    local result
    result=$(sing_box_cm_add_dns_route_rule "$config" "fakeip-server" "fakeip-dns-rule-id")
    
    # Should contain DNS route rule
    [[ "$result" =~ "action.*route" ]]
    [[ "$result" =~ "server.*fakeip-server" ]]
}

@test "sing_box_cm_add_dns_reject_rule should add DNS reject rule" {
    local config='{"dns": {"rules": []}}'
    local result
    result=$(sing_box_cm_add_dns_reject_rule "$config" "query_type" "HTTPS")
    
    # Should contain DNS reject rule
    [[ "$result" =~ "action.*reject" ]]
    [[ "$result" =~ "query_type.*HTTPS" ]]
}

@test "sing_box_cm_add_tproxy_inbound should add TProxy inbound" {
    local config='{"inbounds": []}'
    local result
    result=$(sing_box_cm_add_tproxy_inbound "$config" "tproxy-in" "127.0.0.1" "6969" "true" "true")
    
    # Should contain TProxy inbound
    [[ "$result" =~ "type.*tproxy" ]]
    [[ "$result" =~ "tag.*tproxy-in" ]]
    [[ "$result" =~ "listen.*127.0.0.1" ]]
    [[ "$result" =~ "listen_port.*6969" ]]
    [[ "$result" =~ "tcp_fast_open.*true" ]]
    [[ "$result" =~ "udp_fragment.*true" ]]
}

@test "sing_box_cm_add_direct_inbound should add Direct inbound" {
    local config='{"inbounds": []}'
    local result
    result=$(sing_box_cm_add_direct_inbound "$config" "dns-in" "127.0.0.42" "53")
    
    # Should contain Direct inbound
    [[ "$result" =~ "type.*direct" ]]
    [[ "$result" =~ "tag.*dns-in" ]]
    [[ "$result" =~ "listen.*127.0.0.42" ]]
    [[ "$result" =~ "listen_port.*53" ]]
}

@test "sing_box_cm_add_mixed_inbound should add Mixed inbound" {
    local config='{"inbounds": []}'
    local result
    result=$(sing_box_cm_add_mixed_inbound "$config" "mixed-in" "192.168.1.1" "2080")
    
    # Should contain Mixed inbound
    [[ "$result" =~ "type.*mixed" ]]
    [[ "$result" =~ "tag.*mixed-in" ]]
    [[ "$result" =~ "listen.*192.168.1.1" ]]
    [[ "$result" =~ "listen_port.*2080" ]]
}

@test "sing_box_cm_add_direct_outbound should add Direct outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_direct_outbound "$config" "direct-out")
    
    # Should contain Direct outbound
    [[ "$result" =~ "type.*direct" ]]
    [[ "$result" =~ "tag.*direct-out" ]]
}

@test "sing_box_cm_add_socks_outbound should add SOCKS outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_socks_outbound "$config" "socks5-out" "192.168.1.10" "1080" "5" "user" "pass" "tcp" "2")
    
    # Should contain SOCKS outbound
    [[ "$result" =~ "type.*socks" ]]
    [[ "$result" =~ "tag.*socks5-out" ]]
    [[ "$result" =~ "server.*192.168.1.10" ]]
    [[ "$result" =~ "server_port.*1080" ]]
    [[ "$result" =~ "version.*5" ]]
    [[ "$result" =~ "username.*user" ]]
    [[ "$result" =~ "password.*pass" ]]
    [[ "$result" =~ "network.*tcp" ]]
    [[ "$result" =~ "udp_over_tcp" ]]
}

@test "sing_box_cm_add_shadowsocks_outbound should add Shadowsocks outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_shadowsocks_outbound "$config" "ss-out" "127.0.0.1" "443" "2022-blake3-aes-128-gcm" "8JCsPssfgS8tiRwiMlhARg==" "" "" "" "")
    
    # Should contain Shadowsocks outbound
    [[ "$result" =~ "type.*shadowsocks" ]]
    [[ "$result" =~ "tag.*ss-out" ]]
    [[ "$result" =~ "server.*127.0.0.1" ]]
    [[ "$result" =~ "server_port.*443" ]]
    [[ "$result" =~ "method.*2022-blake3-aes-128-gcm" ]]
    [[ "$result" =~ "password.*8JCsPssfgS8tiRwiMlhARg==" ]]
}

@test "sing_box_cm_add_vless_outbound should add VLESS outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_vless_outbound "$config" "vless-reality-out" "example.com" "443" "bf000d23-0752-40b4-affe-68f7707a9661" "xtls-rprx-vision" "tcp" "xudp")
    
    # Should contain VLESS outbound
    [[ "$result" =~ "type.*vless" ]]
    [[ "$result" =~ "tag.*vless-reality-out" ]]
    [[ "$result" =~ "server.*example.com" ]]
    [[ "$result" =~ "server_port.*443" ]]
    [[ "$result" =~ "uuid.*bf000d23-0752-40b4-affe-68f7707a9661" ]]
    [[ "$result" =~ "flow.*xtls-rprx-vision" ]]
    [[ "$result" =~ "network.*tcp" ]]
    [[ "$result" =~ "packet_encoding.*xudp" ]]
}

@test "sing_box_cm_add_trojan_outbound should add Trojan outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_trojan_outbound "$config" "trojan-out" "example.com" "443" "supersecretpassword" "tcp")
    
    # Should contain Trojan outbound
    [[ "$result" =~ "type.*trojan" ]]
    [[ "$result" =~ "tag.*trojan-out" ]]
    [[ "$result" =~ "server.*example.com" ]]
    [[ "$result" =~ "server_port.*443" ]]
    [[ "$result" =~ "password.*supersecretpassword" ]]
    [[ "$result" =~ "network.*tcp" ]]
}

@test "sing_box_cm_set_grpc_transport_for_outbound should set gRPC transport" {
    local config='{"outbounds": [{"tag": "test-out", "type": "vless"}]}'
    local result
    result=$(sing_box_cm_set_grpc_transport_for_outbound "$config" "test-out" "test-service" "30s" "10s" "true")
    
    # Should contain gRPC transport
    [[ "$result" =~ "transport" ]]
    [[ "$result" =~ "type.*grpc" ]]
    [[ "$result" =~ "service_name.*test-service" ]]
    [[ "$result" =~ "idle_timeout.*30s" ]]
    [[ "$result" =~ "ping_timeout.*10s" ]]
    [[ "$result" =~ "permit_without_stream.*true" ]]
}

@test "sing_box_cm_set_ws_transport_for_outbound should set WebSocket transport" {
    local config='{"outbounds": [{"tag": "test-out", "type": "vless"}]}'
    local result
    result=$(sing_box_cm_set_ws_transport_for_outbound "$config" "test-out" "/path" "example.com" "2048" "Sec-WebSocket-Protocol")
    
    # Should contain WebSocket transport
    [[ "$result" =~ "transport" ]]
    [[ "$result" =~ "type.*ws" ]]
    [[ "$result" =~ "path.*/path" ]]
    [[ "$result" =~ "headers" ]]
    [[ "$result" =~ "Host.*example.com" ]]
    [[ "$result" =~ "max_early_data.*2048" ]]
    [[ "$result" =~ "early_data_header_name.*Sec-WebSocket-Protocol" ]]
}

@test "sing_box_cm_set_tls_for_outbound should set TLS settings" {
    local config='{"outbounds": [{"tag": "test-out", "type": "vless"}]}'
    local result
    result=$(sing_box_cm_set_tls_for_outbound "$config" "test-out" "example.com" "false" '["h2", "http/1.1"]' "chrome" "jNXHt1yRo0vDuchQlIP6Z0ZvjT3KtzVI-T4E7RoLJS0" "0123456789abcdef")
    
    # Should contain TLS settings
    [[ "$result" =~ "tls" ]]
    [[ "$result" =~ "enabled.*true" ]]
    [[ "$result" =~ "server_name.*example.com" ]]
    [[ "$result" =~ "alpn" ]]
    [[ "$result" =~ "utls" ]]
    [[ "$result" =~ "fingerprint.*chrome" ]]
    [[ "$result" =~ "reality" ]]
    [[ "$result" =~ "public_key.*jNXHt1yRo0vDuchQlIP6Z0ZvjT3KtzVI-T4E7RoLJS0" ]]
    [[ "$result" =~ "short_id.*0123456789abcdef" ]]
}

@test "sing_box_cm_add_interface_outbound should add interface outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_interface_outbound "$config" "warp-out" "awg0" "dns-resolver")
    
    # Should contain interface outbound
    [[ "$result" =~ "type.*direct" ]]
    [[ "$result" =~ "tag.*warp-out" ]]
    [[ "$result" =~ "bind_interface.*awg0" ]]
    [[ "$result" =~ "domain_resolver.*dns-resolver" ]]
}

@test "sing_box_cm_add_raw_outbound should add raw outbound" {
    local config='{"outbounds": []}'
    local raw_outbound='{"type": "trojan", "server": "127.0.0.1", "server_port": 1080, "password": "8JCsPssfgS8tiRwiMlhARg==", "network": "tcp"}'
    local result
    result=$(sing_box_cm_add_raw_outbound "$config" "raw-out" "$raw_outbound")
    
    # Should contain raw outbound with tag
    [[ "$result" =~ "type.*trojan" ]]
    [[ "$result" =~ "tag.*raw-out" ]]
    [[ "$result" =~ "server.*127.0.0.1" ]]
    [[ "$result" =~ "server_port.*1080" ]]
    [[ "$result" =~ "password.*8JCsPssfgS8tiRwiMlhARg==" ]]
    [[ "$result" =~ "network.*tcp" ]]
}

@test "sing_box_cm_add_urltest_outbound should add URLTest outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_urltest_outbound "$config" "auto-select" '["proxy1", "proxy2"]' "https://www.gstatic.com/generate_204" "10s" "50" "30s" "true")
    
    # Should contain URLTest outbound
    [[ "$result" =~ "type.*urltest" ]]
    [[ "$result" =~ "tag.*auto-select" ]]
    [[ "$result" =~ "outbounds" ]]
    [[ "$result" =~ "proxy1" ]]
    [[ "$result" =~ "proxy2" ]]
    [[ "$result" =~ "url.*https://www.gstatic.com/generate_204" ]]
    [[ "$result" =~ "interval.*10s" ]]
    [[ "$result" =~ "tolerance.*50" ]]
    [[ "$result" =~ "idle_timeout.*30s" ]]
    [[ "$result" =~ "interrupt_exist_connections.*true" ]]
}

@test "sing_box_cm_add_selector_outbound should add Selector outbound" {
    local config='{"outbounds": []}'
    local result
    result=$(sing_box_cm_add_selector_outbound "$config" "select-proxy" '["proxy1", "proxy2"]' "proxy1" "true")
    
    # Should contain Selector outbound
    [[ "$result" =~ "type.*selector" ]]
    [[ "$result" =~ "tag.*select-proxy" ]]
    [[ "$result" =~ "outbounds" ]]
    [[ "$result" =~ "proxy1" ]]
    [[ "$result" =~ "proxy2" ]]
    [[ "$result" =~ "default.*proxy1" ]]
    [[ "$result" =~ "interrupt_exist_connections.*true" ]]
}

@test "sing_box_cm_configure_route should configure route section" {
    local config='{"route": {}}'
    local result
    result=$(sing_box_cm_configure_route "$config" "direct-out" "true" "udp-server" "eth0")
    
    # Should contain route configuration
    [[ "$result" =~ "final.*direct-out" ]]
    [[ "$result" =~ "auto_detect_interface.*true" ]]
    [[ "$result" =~ "default_domain_resolver.*udp-server" ]]
    [[ "$result" =~ "default_interface.*eth0" ]]
}

@test "sing_box_cm_add_route_rule should add route rule" {
    local config='{"route": {"rules": []}}'
    local result
    result=$(sing_box_cm_add_route_rule "$config" "main-route-rule" "tproxy-in" "main")
    
    # Should contain route rule
    [[ "$result" =~ "action.*route" ]]
    [[ "$result" =~ "inbound.*tproxy-in" ]]
    [[ "$result" =~ "outbound.*main" ]]
}

@test "sing_box_cm_add_reject_route_rule should add reject route rule" {
    local config='{"route": {"rules": []}}'
    local result
    result=$(sing_box_cm_add_reject_route_rule "$config" "reject-rule" "tproxy-in")
    
    # Should contain reject route rule
    [[ "$result" =~ "action.*reject" ]]
    [[ "$result" =~ "inbound.*tproxy-in" ]]
}

@test "sing_box_cm_add_hijack_dns_route_rule should add hijack-dns route rule" {
    local config='{"route": {"rules": []}}'
    local result
    result=$(sing_box_cm_add_hijack_dns_route_rule "$config" "protocol" "dns")
    
    # Should contain hijack-dns route rule
    [[ "$result" =~ "action.*hijack-dns" ]]
    [[ "$result" =~ "protocol.*dns" ]]
}

@test "sing_box_cm_add_options_route_rule should add route-options rule" {
    local config='{"route": {"rules": []}}'
    local result
    result=$(sing_box_cm_add_options_route_rule "$config" "override-fakeip-port")
    
    # Should contain route-options rule
    [[ "$result" =~ "action.*route-options" ]]
}

@test "sing_box_cm_sniff_route_rule should add sniff rule" {
    local config='{"route": {"rules": []}}'
    local result
    result=$(sing_box_cm_sniff_route_rule "$config" "inbound" '["tproxy-in", "dns-in"]')
    
    # Should contain sniff rule
    [[ "$result" =~ "action.*sniff" ]]
    [[ "$result" =~ "inbound" ]]
    [[ "$result" =~ "tproxy-in" ]]
    [[ "$result" =~ "dns-in" ]]
}

@test "sing_box_cm_add_inline_ruleset should add inline ruleset" {
    local config='{"route": {"rule_set": []}}'
    local result
    result=$(sing_box_cm_add_inline_ruleset "$config" "inline-ruleset")
    
    # Should contain inline ruleset
    [[ "$result" =~ "type.*inline" ]]
    [[ "$result" =~ "tag.*inline-ruleset" ]]
}

@test "sing_box_cm_add_local_ruleset should add local ruleset" {
    local config='{"route": {"rule_set": []}}'
    local result
    result=$(sing_box_cm_add_local_ruleset "$config" "local-source-ruleset" "source" "/tmp/local-ruleset.json")
    
    # Should contain local ruleset
    [[ "$result" =~ "type.*local" ]]
    [[ "$result" =~ "tag.*local-source-ruleset" ]]
    [[ "$result" =~ "format.*source" ]]
    [[ "$result" =~ "path.*/tmp/local-ruleset.json" ]]
}

@test "sing_box_cm_add_remote_ruleset should add remote ruleset" {
    local config='{"route": {"rule_set": []}}'
    local result
    result=$(sing_box_cm_add_remote_ruleset "$config" "remote-source-ruleset" "source" "https://example.com/telegram.json" "proxy" "24h")
    
    # Should contain remote ruleset
    [[ "$result" =~ "type.*remote" ]]
    [[ "$result" =~ "tag.*remote-source-ruleset" ]]
    [[ "$result" =~ "format.*source" ]]
    [[ "$result" =~ "url.*https://example.com/telegram.json" ]]
    [[ "$result" =~ "download_detour.*proxy" ]]
    [[ "$result" =~ "update_interval.*24h" ]]
}

@test "sing_box_cm_configure_cache_file should configure cache file" {
    local config='{"experimental": {}}'
    local result
    result=$(sing_box_cm_configure_cache_file "$config" "true" "/tmp/cache.db" "true")
    
    # Should contain cache file configuration
    [[ "$result" =~ "cache_file" ]]
    [[ "$result" =~ "enabled.*true" ]]
    [[ "$result" =~ "path.*/tmp/cache.db" ]]
    [[ "$result" =~ "store_fakeip.*true" ]]
}

@test "sing_box_cm_configure_clash_api should configure Clash API" {
    local config='{"experimental": {}}'
    local result
    result=$(sing_box_cm_configure_clash_api "$config" "192.168.1.1:9090" "ui")
    
    # Should contain Clash API configuration
    [[ "$result" =~ "clash_api" ]]
    [[ "$result" =~ "external_controller.*192.168.1.1:9090" ]]
    [[ "$result" =~ "external_ui.*ui" ]]
}

@test "sing_box_cm_create_local_source_ruleset should create local source ruleset file" {
    local temp_file=$(mktemp)
    
    sing_box_cm_create_local_source_ruleset "$temp_file"
    
    # File should exist and contain valid JSON
    [ -f "$temp_file" ]
    local content
    content=$(cat "$temp_file")
    [[ "$content" =~ "version.*3" ]]
    [[ "$content" =~ "rules.*\[\]" ]]
    
    # Clean up
    rm -f "$temp_file"
}

@test "sing_box_cm_save_config_to_file should save config to file" {
    local temp_file=$(mktemp)
    local config='{"test": "value", "__service_tag": "test-tag"}'
    
    sing_box_cm_save_config_to_file "$config" "$temp_file"
    
    # File should exist and not contain service tag
    [ -f "$temp_file" ]
    local content
    content=$(cat "$temp_file")
    [[ "$content" =~ "test.*value" ]]
    [[ ! "$content" =~ "__service_tag" ]]
    
    # Clean up
    rm -f "$temp_file"
}
