local Authentication = {}
local Encrypt = require(script.Parent:WaitForChild("Encryption"))

-- ======== AUTHENTICATION SPECIFICATION ========
-- Write requests require a few things.  First, each request must contain the
-- following fields: "TS" (timestamp), "baseURL" and "PBLC" (the public access key).
-- each request requires an 'Authentication' header, which can be built as follows:
-- MAKE_AUTH_STRING(query):
--   assert(query contains TS, baseURL, PBLC)
--   let alph = empty string
--   for key, value in alphabeticalSorted(query):
--     append (key + "=" + value + "&") to alph
--   remove trailing '&' from alph
--   let signingKey = KEY_PUBLIC + KEY_PRIVATE
--   let encrypted = HMAC_SHA256(key=signingKey, message=alph)
--   let finalAuthenticationString = "OAuth " + encrypted
-- 
-- The function Authentication.EncodeAuthenticationString implements
-- the pseudocode listed above.

-- ======== PUBLIC AND PRIVATE WRITE KEYS ========
-- protect these bad boys at all cost.  it's okay if the public key gets out, but
-- if the private key is released, anybody will be able to write data.  there is
-- an entirely different set of keys used for reading, which should never be
-- placed inside of a ROBLOX script for security purposes.  if these keys are released,
-- our data is still protected.  worst case scenario, somebody can write some junk
-- data that we can delete later.  but again, that can only happen if this source
-- code is leaked, and some neferious guy actually knows what to do w/ these keys.
-- If these are discovered, we can easily swap them out for a new set of keys.

Authentication.API_URL           =  script:WaitForChild("API_URL").Value;
Authentication.API_KEY_PUBLIC    = script:WaitForChild("API_KEY_PUBLIC").Value;
Authentication.API_KEY_PRIVATE   = script:WaitForChild("API_KEY_PRIVATE").Value;

function Authentication.getAuthParameters()  
	local auth = {
		baseURL = Authentication.API_URL,
		TS = tostring((math.floor((os.time())))),
		PBLC = Authentication.API_KEY_PUBLIC
	}

	return auth
end

function Authentication.EncodeAuthenticationString(queryParams)

	local alph = {}
	for k, v in pairs(queryParams) do
		if typeof(k) == "string" and typeof(v) == "string" then
			table.insert(alph, {k, v})
		end	
	end

	table.sort(alph, function(a, b)
		return a[1] < b[1]
	end)

	local sigBase = ""
	for _, tuple in ipairs(alph) do
		sigBase = sigBase .. tuple[1] .. "=" .. tuple[2] .. "&"
	end
	sigBase = sigBase:sub(1, sigBase:len() - 1)

	local signingKey = Authentication.API_KEY_PUBLIC .. Authentication.API_KEY_PRIVATE
	local encrypted = Encrypt.hmac(Encrypt.sha256, signingKey, sigBase)

	local authString = "OAuth " .. encrypted
	return authString

end

return Authentication
