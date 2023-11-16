async in presenter appears because i hate nested code: Requests are performed 
somewhere on background threads and slap @MainActor + async is the cleanest way
to return on main thread w/0 writing nested code
