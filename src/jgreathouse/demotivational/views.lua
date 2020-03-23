-- methods for producing each endpoint of the application
local adapters = require "adapters"
local helpers = require "helpers"
local template = require "resty.template"
local cjson = require "cjson"

local function new()
    local views = {}

    local function get_session()
        local session = require "resty.session".open()
        session.data.ip = ngx.var.remote_addr
        session.data.name = ngx.var.remote_user
        -- save session and update the cookie to be sent to the client
        session:save()
        return session;
    end

    local function require_login(session)
        -- If there is no token associated with this session
        -- Force the user to the login screen
        if not session.data.token then
            ngx.redirect('/login')
        end
    end

    local function get_view(tpl, layout)
        template.caching(false)
        local view              = template.new(tpl, layout)
        view.google_oauth_key   = ngx.var.GOOGLE_OAUTH_KEY
        view.facebook_oauth_key = ngx.var.FACEBOOK_OAUTH_KEY
        return view
    end

    function views.index()
        local session = get_session()
        require_login(session)
        local view = get_view("index.html", "layout.html")

        -- Dress the view
        view.title      = "Demotivational | Home"
        view.user       = session.data.user
        view.token      = session.data.token
        view.ip         = session.data.ip
        view.search_url = helpers.get_search_url()

        view:render()
    end

    function views.login()
        require "resty.session".start()
        get_session()
        local view     = get_view("login.html", "layout.html")
        view.title     = "Demotivational | Login"
        view:render()
    end

    function views.logout()
        local session       = get_session()
        local models        = require "models"
        local view          = get_view("logout.html", "layout.html")

        -- Prevents execution from breaking if the
        -- user lands on /logout without a token
        if not session.data.token then
            session:destroy()
            ngx.redirect('/login')
        end

        view.title          = "Demotivational | Logout"
        view.token          = session.data.token
        view.google_type    = models.GOOGLE_TOKEN_TYPE
        view.facebook_type  = models.FACEBOOK_TOKEN_TYPE

        session:destroy()
        view:render()
    end

    function views.google_auth()
        local session  = get_session()
        local response = {
            error = 0
        }
        ngx.req.read_body()
        local args, err = ngx.req.get_post_args()

        if err then
            response.error = 1;
            response.message = err
        elseif next(args) == nil then
            response.error = 1;
            response.message = "failed to get post args"
        else
            response.message = "logged in user"
            session.data.user = adapters.google_user(args)
            session.data.token = adapters.google_token(args)
            session:save()
        end

        ngx.say(cjson.encode(response))
    end

    function views.facebook_auth()
        local session  = get_session()
        local response = {
            error = 0
        }
        ngx.req.read_body()
        local args, err = ngx.req.get_post_args()

        if err then
            response.error = 1;
            response.message = err
        elseif next(args) == nil then
            response.error = 1;
            response.message = "failed to get post args"
        else
            response.message = "logged in user"
            session.data.user = adapters.facebook_user(args)
            session.data.token = adapters.facebook_token(args)
            session:save()
        end

        ngx.say(cjson.encode(response))
    end

    return views
end

return new()
