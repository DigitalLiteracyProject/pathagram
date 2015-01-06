tabs = [] # jQuery elements
protectedIndices = [0] # indices in tab array that cannot be closed

# Opens a file with the given filename in a new tab, unless it's already opened.
addTab = (filename) ->
    return if filename in _.map tabs, (tab) -> tab.attr 'data-title'
    
    protect = tabs.length in protectedIndices
    tab = $ template "tab", { title: filename, href: "#", closable: not protect }
    tabs.push tab
    $('#tab-list').append tab
    # make tab "light up"
    tab.tab 'show'
    
    tab.find(".btn-close").click () =>
        # highlight previous tab
        index = tabs.indexOf tab
        tabs[index-1].tab 'show'
        
        tabs.remove tab
        tab.remove()