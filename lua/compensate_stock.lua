-- KEYS[1] = available
-- KEYS[2] = reserved
-- KEYS[3] = sold
-- ARGV[1] = availableDelta
-- ARGV[2] = reservedDelta
-- ARGV[3] = soldDelta

redis.call("INCRBY", KEYS[1], tonumber(ARGV[1]))
redis.call("INCRBY", KEYS[2], tonumber(ARGV[2]))
redis.call("INCRBY", KEYS[3], tonumber(ARGV[3]))

return { "COMPENSATED" }
