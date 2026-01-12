-- KEYS[1] = available
-- KEYS[2] = reserved
-- KEYS[3] = idempotency set
-- ARGV[1] = quantity
-- ARGV[2] = eventId

if redis.call("SISMEMBER", KEYS[3], ARGV[2]) == 1 then
  return { "DUPLICATE" }
end

local available = tonumber(redis.call("GET", KEYS[1]) or "0")
local qty = tonumber(ARGV[1])

if available < qty then
  return { "INSUFFICIENT_STOCK" }
end

redis.call("DECRBY", KEYS[1], qty)
redis.call("INCRBY", KEYS[2], qty)
redis.call("SADD", KEYS[3], ARGV[2])

return { "RESERVED" }
