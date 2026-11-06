local MarketplaceService = game:GetService("MarketplaceService");
local table1 = {
	UpdateRate = 900,
	RetryRate = 900
};
local table2 = {};
function table1.clear() 
	table2 = {};
end
function table1.getProductInfo(p1, p2) 
	assert(typeof(p1) == "number");
	assert(typeof(p2) == "EnumItem" and p2.EnumType == Enum.InfoType or false);
	local v1 = table2[p2];
	if not v1 then
		v1 = {};
		table2[p2] = v1;
	end
	local v2 = v1[p1];
	if not v2 then
		v2 = {};
		v1[p1] = v2;
	end
	if v2.Info and v2.LastUpdated and time() - v2.LastUpdated < table1.UpdateRate then
		return v2, true;
	end
	if v2.LastFailure and time() - v2.LastFailure < table1.RetryRate then
		return v2, false;
	end
	local success, pcall_ret2 = pcall(function()
		local ProductInfo = MarketplaceService:GetProductInfo(p1, p2);
		return ProductInfo;
	end);
	local time_ret = time();
	if success then
		v2.LastUpdated = time_ret;
		v2.Info = pcall_ret2;
		return v2, true;
	end
	v2.LastFailure = time_ret;
	warn(string.format("[ProductCache] Failed to retrieve: productId=%d infoType=%s error='%s'", p1, p2.Name, tostring(pcall_ret2)));
	return v2, false;
end
return table1;
