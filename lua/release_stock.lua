-- KEYS[1] = available
-- KEYS[2] = reserved
-- KEYS[3] = idempotency set
-- ARGV[1] = quantity
-- ARGV[2] = eventId

if redis.call("SISMEMBER", KEYS[3], ARGV[2]) == 0 then
  return { "NOTHING_TO_RELEASE" }
end

local reserved = tonumber(redis.call("GET", KEYS[2]) or "0")
local qty = tonumber(ARGV[1])

if reserved < qty then
  return { "INVALID_RELEASE" }
end

redis.call("INCRBY", KEYS[1], qty)
redis.call("DECRBY", KEYS[2], qty)
redis.call("SREM", KEYS[3], ARGV[2])

return { "RELEASED" }
