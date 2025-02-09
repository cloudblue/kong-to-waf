local http = require "resty.http"

local _M = {}

local function get_path()
    if kong.request.get_raw_path ~= nil then
        return kong.request.get_raw_path()
    else
        return kong.request.get_path()
    end
end

local function call_waf(config)
    local ok, err
    local host = config.waf_host
    local port = tonumber(config.waf_port)
    local path = config.waf_uri or ""

    local httpc = http.new()
    httpc:set_timeout(config.waf_timeout)
    ok, err = httpc:connect(host, port, {pool_size = config.waf_conn_pool_size})
    if not ok then
        kong.log.err('Failed to connect to WAF service')
        return
    end

    local headers = kong.request.get_headers()
    headers['X-Forwarded-Host'] = kong.request.get_host()
    headers['X-Forwarded-Method'] = kong.request.get_method()
    headers['X-Forwarded-Path'] = get_path()
    headers['X-Forwarded-For'] = kong.client.get_forwarded_ip()

    local res
    res, err = httpc:request({
        method = config.waf_method,
        path = path .. kong.request.get_path_with_query(),
        headers = headers
    })

    if not res then
        kong.log.err('Failed to get response from WAF service')
        return
    end

    res:read_body()
    httpc:set_keepalive(config.waf_keepalive)

    if res.status >= 400 then
        kong.log.warn('WAF service responded with ' .. tostring(res.status) .. ': ' .. path)
        if config.mode == 'full' then
            return kong.response.exit(403)
        end
    end
end

function _M.execute(config)
    local mode = config.mode
    if mode == 'disabled' then
        return
    end

    call_waf(config)
end

return _M
