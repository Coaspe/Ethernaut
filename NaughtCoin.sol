await contract.approve(player, await contract.balanceOf(player))
await contract.transferFrom(player, instance, await contract.balanceOf(player))
