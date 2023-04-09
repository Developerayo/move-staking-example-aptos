address 0x1 {
module StakingPool {
    use 0x1::Signer;
    use 0x1::Vector;

    struct PoolInfo has key {
        total_stake: u64,
        stakers: vector<address>,
    }

    struct OwnerCapability has key {
        owner_address: address,
    }

    public fun create_pool(owner: &signer) {
        let owner_address = Signer::address_of(owner);
        move_to(owner, OwnerCapability { owner_address });
        move_to(owner, PoolInfo { total_stake: 0, stakers: Vector::empty() });
    }

    public fun add_stake(owner_capability: &OwnerCapability, staker: &signer, amount: u64) acquires PoolInfo {
        let pool_info = borrow_global_mut<PoolInfo>(owner_capability.owner_address);
        pool_info.total_stake = pool_info.total_stake + amount;
        Vector::push_back(&mut pool_info.stakers, Signer::address_of(staker));
    }

    public fun get_total_stake(owner_capability: &OwnerCapability): u64 acquires PoolInfo {
        let pool_info = borrow_global<PoolInfo>(owner_capability.owner_address);
        pool_info.total_stake
    }

    public fun get_stakers(owner_capability: &OwnerCapability): &vector<address> acquires PoolInfo {
        let pool_info = borrow_global<PoolInfo>(owner_capability.owner_address);
        &pool_info.stakers
    }
}
}
