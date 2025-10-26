#!/usr/bin/env bats

load '../setup.bash'

@test "nft_create_table should create nftables table" {
    # Mock nft command
    local mock_nft_output
    mock_nft_output=$(nft_create_table "test-table")
    
    # Should call nft with correct parameters
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ table\ inet\ test-table ]]
}

@test "nft_create_ipv4_set should create IPv4 set" {
    # Mock nft command
    local mock_nft_output
    mock_nft_output=$(nft_create_ipv4_set "test-table" "test-set")
    
    # Should call nft with correct parameters
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ test-set ]]
    [[ "$mock_nft_output" =~ type\ ipv4_addr ]]
    [[ "$mock_nft_output" =~ flags\ interval ]]
    [[ "$mock_nft_output" =~ auto-merge ]]
}

@test "nft_create_ifname_set should create interface name set" {
    # Mock nft command
    local mock_nft_output
    mock_nft_output=$(nft_create_ifname_set "test-table" "test-ifname-set")
    
    # Should call nft with correct parameters
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ test-ifname-set ]]
    [[ "$mock_nft_output" =~ type\ ifname ]]
    [[ "$mock_nft_output" =~ flags\ interval ]]
}

@test "nft_add_set_elements should add elements to set" {
    # Mock nft command
    local mock_nft_output
    mock_nft_output=$(nft_add_set_elements "test-table" "test-set" "192.168.1.0/24 10.0.0.0/8")
    
    # Should call nft with correct parameters
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ element\ inet\ test-table\ test-set ]]
    [[ "$mock_nft_output" =~ 192\.168\.1\.0/24 ]]
    [[ "$mock_nft_output" =~ 10\.0\.0\.0/8 ]]
}

@test "nft functions should handle empty parameters" {
    # Test with empty table name
    local mock_nft_output
    mock_nft_output=$(nft_create_table "")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ table\ inet\ \"\" ]]
    
    # Test with empty set name
    mock_nft_output=$(nft_create_ipv4_set "test-table" "")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ \"\" ]]
    
    # Test with empty elements
    mock_nft_output=$(nft_add_set_elements "test-table" "test-set" "")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ element\ inet\ test-table\ test-set ]]
}

@test "nft functions should handle special characters" {
    # Test with special characters in table name
    local mock_nft_output
    mock_nft_output=$(nft_create_table "test-table-with-dashes")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ table\ inet\ test-table-with-dashes ]]
    
    # Test with special characters in set name
    mock_nft_output=$(nft_create_ipv4_set "test-table" "test_set_with_underscores")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ test_set_with_underscores ]]
    
    # Test with special characters in elements
    mock_nft_output=$(nft_add_set_elements "test-table" "test-set" "192.168.1.1 10.0.0.1")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ element\ inet\ test-table\ test-set ]]
}

@test "nft functions should handle multiple elements" {
    # Test with multiple elements
    local mock_nft_output
    mock_nft_output=$(nft_add_set_elements "test-table" "test-set" "192.168.1.0/24 10.0.0.0/8 172.16.0.0/12")
    
    # Should contain all elements
    [[ "$mock_nft_output" =~ 192\.168\.1\.0/24 ]]
    [[ "$mock_nft_output" =~ 10\.0\.0\.0/8 ]]
    [[ "$mock_nft_output" =~ 172\.16\.0\.0/12 ]]
}

@test "nft functions should handle single element" {
    # Test with single element
    local mock_nft_output
    mock_nft_output=$(nft_add_set_elements "test-table" "test-set" "192.168.1.1")
    
    # Should contain the single element
    [[ "$mock_nft_output" =~ 192\.168\.1\.1 ]]
}

@test "nft functions should handle spaces in elements" {
    # Test with spaces in elements
    local mock_nft_output
    mock_nft_output=$(nft_add_set_elements "test-table" "test-set" "192.168.1.1 192.168.1.2")
    
    # Should handle spaces correctly
    [[ "$mock_nft_output" =~ 192\.168\.1\.1 ]]
    [[ "$mock_nft_output" =~ 192\.168\.1\.2 ]]
}

@test "nft functions should work with different table names" {
    # Test with different table names
    local mock_nft_output
    
    mock_nft_output=$(nft_create_table "PodkopTable")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ table\ inet\ PodkopTable ]]
    
    mock_nft_output=$(nft_create_table "CustomTable")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ table\ inet\ CustomTable ]]
}

@test "nft functions should work with different set names" {
    # Test with different set names
    local mock_nft_output
    
    mock_nft_output=$(nft_create_ipv4_set "test-table" "localv4")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ localv4 ]]
    
    mock_nft_output=$(nft_create_ipv4_set "test-table" "podkop_subnets")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ podkop_subnets ]]
    
    mock_nft_output=$(nft_create_ifname_set "test-table" "interfaces")
    [[ "$mock_nft_output" =~ MOCK\ NFT.*add\ set\ inet\ test-table\ interfaces ]]
}
