const util = require('util')
const sdk = require('dragonchain-sdk')

const main = async () => {
    const client = await sdk.createClient()
    const blocks = await client.queryBlocks({redisearchQuery:'*', limit:10, sortBy: "block_id", sortAscending: false})

    console.log(util.inspect(blocks, false, null, true));

}

main().then().catch(console.error)
