-- KEYS[1] = idempotency set
-- ARGV[1] = eventId

if redis.call("SISMEMBER", KEYS[1], ARGV[1]) == 1 then
  return { "DUPLICATE_EVENT" }
end

redis.call("SADD", KEYS[1], ARGV[1])
return { "ACCEPTED" }
