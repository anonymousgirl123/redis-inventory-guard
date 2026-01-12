-- KEYS[1] = reserved
-- KEYS[2] = sold
-- KEYS[3] = idempotency set
-- ARGV[1] = quantity
-- ARGV[2] = eventId

if redis.call("SISMEMBER", KEYS[3], ARGV[2]) == 0 then
  return { "NO_RESERVATION_FOUND" }
end

local reserved = tonumber(redis.call("GET", KEYS[1]) or "0")
local qty = tonumber(ARGV[1])

if reserved < qty then
  return { "INVALID_COMMIT" }
end

redis.call("DECRBY", KEYS[1], qty)
redis.call("INCRBY", KEYS[2], qty)
redis.call("SREM", KEYS[3], ARGV[2])

return { "COMMITTED" }
