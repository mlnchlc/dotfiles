
import qutebrowser.api.interceptor
 
def rewrite(request: qutebrowser.api.interceptor.Request):
    if request.request_url.host() == 'www.reddit.com':
        request.request_url.setHost('libredd.it')
 
        try:
            request.redirect(request.request_url)
        except:
            pass

    if request.request_url.host() == 'www.google.com':
        request.request_url.setHost('search.disroot.org')
 
        try:
            request.redirect(request.request_url)
        except:
            pass
 

    if request.request_url.host().startswith('www.amazon.') and '/dp/' in request.request_url.path():
        path = request.request_url.path().split('/')
        i = path.index('dp')
        request.request_url.setPath('/' + '/'.join(path[i:i+2]))
        request.request_url.setQuery(None)
 
        try:
            request.redirect(request.request_url)
        except:
            pass
 
    if request.request_url.host().startswith('www.ebay.') and '/itm/' in request.request_url.path():
        path = request.request_url.path().split('/')
 
        if len(path) > 3:
            request.request_url.setPath('/' + path[1] + '/' + path[3])
            request.request_url.setQuery(None)
 
        try:
            request.redirect(request.request_url)
        except:
            pass
 
    if request.request_url.host() == 'www.youtube.com':
        #path = request.request_url.path().split('/') 
        #request.request_url.setPath(request.request_url.path()+"&local=true")
        #request.request_url.setQuery(None)
        request.request_url.setHost('yewtu.be')
        try:
            request.redirect(request.request_url)
        except:
            pass

    if request.request_url.host() == 'twitter.com':
        request.request_url.setHost('nitter.snopyta.org')
 
        try:
            request.redirect(request.request_url)
        except:
            pass
 

qutebrowser.api.interceptor.register(rewrite)
