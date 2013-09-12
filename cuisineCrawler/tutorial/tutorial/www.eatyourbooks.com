
<!DOCTYPE html>
<html class="ui-mobile-rendering">
<head>
    <title>Eat Your Books Mobile</title>    
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <link rel="stylesheet" type="text/css" href="/combres/mobile-css/-1018256223/"/>

     
    <link rel="apple-touch-icon" sizes="57x57" href="http://c1522072.r72.cf0.rackcdn.com/touch-icon-iphone-114.png" />
     
    <link rel="apple-touch-icon" sizes="114x114" href="http://c1522072.r72.cf0.rackcdn.com/touch-icon-iphone-114.png" />
     
    <link rel="apple-touch-icon" sizes="72x72" href="http://c1522072.r72.cf0.rackcdn.com/touch-icon-ipad-144.png" />
     
    <link rel="apple-touch-icon" sizes="144x144" href="http://c1522072.r72.cf0.rackcdn.com/touch-icon-ipad-144.png" />

    <script type="text/template" id="home">

        <div>
            <div data-role="header" class="header-line"></div>        
            <center class="logo"><img src="http://c1522072.r72.cf0.rackcdn.com/mobile-logo.png" /></center>
        
           <div data-role="content" class="transparent">
               {{#if LoggedIn}}
                    <p class="welcome">Welcome, {{ DisplayName }}!</p>
                {{/if}}
                <ul data-role="listview" data-inset="true">
                    {{#if LoggedIn}}
                        <li><a class="nav" href="bookshelf/recipes">My Bookshelf</a></li>
                    {{/if}}
                    <li><a class="nav" href="library/books">Library</a></li>                
                </ul>
                {{#unless LoggedIn}}
                    <center><a class="nav" href="signin" data-role="button" data-inline="true" data-theme="a">Sign In</a></center>
                {{/unless}}
                {{#if LoggedIn}}
                    <center><a href="/account/signout?url=/mobile" data-role="button" data-inline="true" data-theme="a" rel="external">Sign Out</a></center>
                {{/if}}
            </div>
            <div class="full-site"><a class="nav-external" href="/">Browse full website</a></div>
        </div>

    </script>

    <script type="text/template" id="signin">

        <div>
            <div data-role="header">
                {{> display-homelink}}
                <h1>Sign In</h1>
            </div>

            <div data-role="content">
                <form id="signin-form" action="/mobile/signin" method="post" data-ajax="false">
                    <div data-role="fieldcontain">
                        <div id="error-message" />
                        <fieldset data-role="controlgroup">
                            <label for="Userkey" style="display:none">Email / Username</label>
                            <input type="text" name="Userkey" placeholder="Email / Username" id="Userkey" class="input-first" autofocus />
                            <label for="Password" style="display:none">Password</label>
                            <input type="password" name="Password" placeholder="Password" id="Password" class="input-last" />
                            <br />
                            <label for="Remember">Remember me</label>
                            <input type="checkbox" name="Remember" id="Remember" class="remember" />
                            <br />
                        </fieldset>
                        <input type="submit" data-theme="a" value="Sign In" />
                    </div>
                </form>
            </div>
        </div>

    </script>

    <script type="text/template" id="search">

        <div data-role="header" id="search-header"></div>

        <div id="search-wrapper">
            <div id="search-box"></div>
        </div>

        <div data-role="content">
            <ul data-role="listview" id="results" class="plain"></ul>            
            <div id="search-error" style="display: none">Sorry there was an error with your search, please try again.</div>
            <br />
            <div id="pagination"></div>
        </div>

    </script>

    <script type="text/template" id="search-header">

        {{> display-homelink}}
        <h1>
        	{{#if isBookshelf }}My Bookshelf{{/if}}
            {{#unless isBookshelf }}Library{{/unless}}
        </h1>
        {{> display-searchoptionslink}}
        
        <div data-role="navbar" id="search-tabs">
            <ul>
                <li><a data-theme="a" href="#library/books">Books</a></li>
                <li><a data-theme="a" href="#library/magazines">Magazines</a></li>
                <li><a data-theme="a" href="#library/blogs">Blogs</a></li>
                <li><a data-theme="a" href="#library/recipes">Recipes</a></li>
            </ul>
        </div>

    </script>

    <script type="text/template" id="search-box">

        <input type="search" id="search" data-theme="d" value="{{ query }}" />

    </script>

    <script type="text/template" id="publication-search-item">

        <a href="#book-details/{{ Id }}">
            <img class="ui-li-thumb" src="{{ ImageUrl }}" />
            <div class="ui-li-heading {{#unless isMagazine}}ellipse{{/unless}}">{{ MainTitle }}</div>
            <div class="ui-li-desc ellipse">{{> display-authors}}</div>            
        </a>

    </script>

    <script type="text/template" id="recipe-search-item">
    
        <a href="#recipe-details/{{ Id }}">
            {{#if showImages}}
                <img class="ui-li-thumb" src="{{ ImageUrl }}" />
            {{/if}}
            <div class="ui-li-heading ellipse">{{ Title }}</div>
            <div class="ui-li-desc ellipse">{{ BookTitle }}{{> display-authors}}</div>
            <div class="show-more" style="display: none">
                <div class="ui-li-desc">{{> display-ingredients}}</div>
            </div>            
        </a>
        <a href="#" class="show-more-link">Show more</a>
    </script>

    <script type="text/template" id="search-paging">

		<div class="paging">            
            <i>Found {{ count }} result{{#unless onlyOneResult}}s{{/unless}}</i>
			{{#if hasMorePages }}
				<span data-role="button" class="nextpage blue">Show Next {{ showNextAmount }}</span>
			{{/if}}
		</div>

    </script>

    <script type="text/template" id="search-options">

        <div data-role="header">
            {{> display-resultslink}}
            <h1>Search Options</h1>
        </div>

        <div data-role="content">
            <div data-role="fieldcontain">
                <fieldset data-role="controlgroup">
                    <legend>Sort by:</legend>                    
                    {{#if displayPublicationSort}}
                        
<select id="sort" class="sort" name="sort">
    <option value="">Sort by ...</option>

    <option value="main_title asc" >A - Z</option>

    <option value="authors asc" >Author</option>

    <option value="buzz desc" >Buzz</option>

    <option value="create_date desc" >Date Added to Library</option>

    <option value="date_entered desc" >Date Indexed</option>

    <option value="date_published desc" >Date Published</option>

    <option value="number_of_bookshelves desc" >Popularity</option>

</select>
                    {{/if}}
                    {{#if displayRecipeSort}}
                        {{#unless isPubDetailPage}}
                            
<select id="sort" class="sort" name="sort">
    <option value="">Sort by ...</option>

    <option value="main_title asc" >A - Z</option>

    <option value="authors asc" >Author</option>

    <option value="buzz desc" >Buzz</option>

    <option value="date_published desc" >Date Published</option>

    <option value="average_rating desc" >Rating</option>

    <option value="create_date desc" >Recently Added</option>

</select>
                        {{/unless}}
                        {{#if isPubDetailPage}}
                            <select id="sort">
                            {{#if isBlog}}
                                <option value="sort_order desc">Publish Date</option>
                            {{/if}}
                            {{#unless isBlog}}
                                <option value="sort_order asc">Book Order</option>
                            {{/unless}}
                            <option value="main_title asc">A - Z</option>
                            <option value="main_title desc">Z - A</option>
                            <option value="average_rating desc">Rating</option>
                            <option value="buzz desc">Buzz</option>
                            </select>
                        {{/if}}
                    {{/if}}                    
                </fieldset>

                {{#if displayFilterSection}}                    
                    <fieldset data-role="controlgroup">
                        <legend>Filter by:</legend>
                        {{#if displayBookFilters}}                            
                            <input id="indexed" name="indexed" type="checkbox" value="true" /><input name="indexed" type="hidden" value="false" /><label for="indexed">Indexed Books</label>
                            <input id="indexing-now" name="indexing-now" type="checkbox" value="true" /><input name="indexing-now" type="hidden" value="false" /><label for="indexing-now">Indexing Now Books</label>
                            <input id="unindexed" name="unindexed" type="checkbox" value="true" /><input name="unindexed" type="hidden" value="false" /><label for="unindexed">Unindexed Books</label>
                        {{/if}}
                        {{#if displayRecipeFilters}}
                            <input id="book-recipes" name="book-recipes" type="checkbox" value="true" /><input name="book-recipes" type="hidden" value="false" /><label for="book-recipes">Book Recipes</label>
                            <input id="magazine-recipes" name="magazine-recipes" type="checkbox" value="true" /><input name="magazine-recipes" type="hidden" value="false" /><label for="magazine-recipes">Magazine Recipes</label>
                            <input id="online-recipes" name="online-recipes" type="checkbox" value="true" /><input name="online-recipes" type="hidden" value="false" /><label for="online-recipes">Online Recipes</label>
                            {{#if displayPersonalRecipeFilter}}
                                <input id="personal-recipes" name="personal-recipes" type="checkbox" value="true" /><input name="personal-recipes" type="hidden" value="false" /><label for="personal-recipes">Personal Recipes</label>
                            {{/if}}
                        {{/if}}
                    </fieldset>
                {{/if}}
                {{#if displayBookmarkSection}}
                    <fieldset data-role="controlgroup">
                        <legend>My Bookmarks:</legend>
                        {{#if displayBookBookmarks}}
                            <select id="book-bookmarks">
                                <option value="0">Look in Books ...</option>
                            </select>
                        {{/if}}
                        {{#if displayRecipeBookmarks}}
                            <select id="recipe-bookmarks">
                                <option value="0">Look in Recipes ...</option>
                            </select>
                        {{/if}}
                    </fieldset>
                {{/if}}
                <br />
                <a href="#" id="apply" data-role="button" data-theme="a">Apply</a>
            </div>
            
        </div>

    </script>

    <script type="text/template" id="publication-details">

        <div data-role="header">
            {{> display-resultslink}}
            <h1>{{ singularizeAndCapitalize PublicationType }} details</h1>
            {{#if IsIndexed}}
                {{> display-searchoptionslink}}
            {{/if}}
        </div>

        <div data-role="content">
            <h2>{{ Title }}</h2>
            <h3>{{> display-authors}}</h3>
            {{#if IsIndexed}}
                <a id="search-this" class="blue search-this" href="">Search recipes in this {{ singularize PublicationType }} &raquo;</a>
            {{/if}}
            
            <div data-role="navbar" id="tabs">
                <ul class="small-tabs">
                    <li><a href="#recipes" class="ui-btn-active">Recipes</a></li>
                    <li><a href="#notes">Notes</a></li>
                    <li><a href="#details">Details</a></li>                    
                </ul>
            </div>
            <div id="content" class="nested-content"></div>
        </div>

    </script>

    <script type="text/template" id="publication-recipes-tab">

        {{#unless IsIndexed}}
            <div id="index-status">Index status: {{ IndexStatus }}</div>
        {{/unless}}
        {{#if IsIndexed}}
            <ul data-role="listview" id="results" class="plain"></ul>            
            <br />
            <div id="pagination"></div>
        {{/if}}

    </script>

    <script type="text/template" id="publication-notes-tab">

        <ul id="notes" class="plain ui-listview"></ul>
        <div class="no-notes" style="display: none">There are no notes yet.</div>

    </script>



    <script type="text/template" id="publication-details-tab">

        <ul id="details" class="plain ui-listview">
            <li class="section">
                {{> display-rating}}
            </li>
            {{> display-categories}}
            {{#if IsMemberIndexed }}
                <div class="section">
                    <h4>Member Indexed</h4>
                    <div>This book has been indexed by an Eat Your Books Member.</div>
                </div>
            {{/if}} 
                <li class="section">
                    <h4>{{ singularizeAndCapitalize PublicationType }} Data</h4>
                    <ul>
                        {{#if Isbn10}}<li>ISBN 10: {{ Isbn10 }}</li>{{/if}}
                        {{#if Isbn13}}<li>ISBN 13: {{ Isbn13 }}</li>{{/if}}
                        {{#if DatePublished}}<li>Published: {{ DatePublished }}</li>{{/if}}
                        {{#if Countries}}<li>Countries: {{ Countries }}</li>{{/if}}
                        {{#if Format}}<li>Format: {{ Format }}</li>{{/if}}
                        {{#if Language}}<li>Language: {{ Language }}</li>{{/if}}
                    </ul>
                </li>
            {{#if Description }}
                <li class="section">
                    <h4>Description</h4>
                    {{{ Description }}}
                </li>
            {{/if}}
        </ul>

    </script>

    <script type="text/template" id="recipe-details">

        <div data-role="header">
            {{> display-resultslink}}
            <h1>Recipe details</h1>
        </div>

        <div data-role="content">
            <h2>{{ Title }}</h2>
            <h3><i>from</i> {{ BookTitle }} {{> display-authors}}</h3>
            {{#if OnlineUrl }}
                <a class="blue external-link" href="{{ OnlineUrl }}" target="_blank">View complete recipe online</a>
            {{/if}}

            <div data-role="navbar" id="tabs">
                <ul class="small-tabs">
                    <li><a href="#ingredients" class="ui-btn-active">Ingredients</a></li>
                    <li><a href="#notes">Notes</a></li>
                    <li><a href="#details">Details</a></li>                    
                </ul>
            </div>

            <div id="content" class="nested-content"></div>
        </div>

    </script>

    <script type="text/template" id="recipe-ingredients-tab">

        <ul data-role="listview" id="ingredients" class="plain">
            {{#each Ingredients}}
                <li>{{ this }}</li>
            {{/each}}
        </ul>
        <div class="notification subtle">Always check the publication for a full list of ingredients.</div>

    </script>

    <script type="text/template" id="recipe-notes-tab">

        <ul id="notes" class="plain ui-listview"></ul>
        <div class="no-notes" style="display: none">There are no notes yet.</div>

    </script>

    <script type="text/template" id="recipe-details-tab">

        <ul id="details" class="plain ui-listview">
            <li class="section">
                {{> display-rating}}
            </li>
            {{> display-categories}}
            {{#if IsMemberIndexed }}
                <li class="section">
                    <h4>Member Indexed</h4>
                    <div>This recipe has been indexed by an Eat Your Books Member.</div>
                </li>
            {{/if}}
        </ul>

    </script>

    <script type="text/template" id="note-item">

        <li class="section">
            <div class="note-body">{{ Text }}</div>  
            <div class="ui-li-desc">
                {{#if IsPersonal}}<span class="is-personal" title="This note is personal and can only be seen by you."></span>&nbsp;{{/if}}            
                <i>by</i> {{ DisplayName }}
                {{#if FormattedDate}}<i>on</i> {{ FormattedDate }} {{/if}}
            </div>
        </li>

    </script>

    <!-- Partials -->

    <script type="text/template" id="authors-partial">
        {{#if Authors}}           
            <span class="last-child"> 
                <span><i>by </i></span>
                {{#each Authors}}
                    <span>{{ this }} </span>
                    <span><i>and </i></span>
                {{/each}}
            </span>
        {{/if}}
    </script>

    <script type="text/template" id="list-partial">        
        <ul>
            {{#each this}}
                <li>{{ this }}</li>
            {{/each}} 
        </ul>
    </script>

    <script type="text/template" id="categories-partial">        
        {{#if Categories}}
            <li class="section">
                <h4>Categories</h4>
                {{> display-list Categories}}
            </li>
        {{/if}}
    </script>



    <script type="text/template" id="homelink-partial">
        <a href="#" data-icon="home" data-iconpos="notext" data-rel="back" data-theme="b" class="home ui-btn-left">Home</a>
    </script>

    <script type="text/template" id="ingredients-partial">                
        <div class="ingredients">
            <span><b>Ingredients:</b>&nbsp;&nbsp;</span>        
            {{#each Ingredients}}
                <span>{{ this }}</span>
                <span>;&nbsp;</span>
            {{/each}}
        </div>
    </script>


    <script type="text/template" id="rating-partial">
        <h4>Member Rating</h4>
        <div class="rating">
            {{#each RatingStates}}
                <a class="{{ this }}" />
            {{/each}}             
        </div>
        <span class="small">Average rating of {{ RatingAverage }} by {{ RatingCount }} {{ RatingText }}.</span>
    </script>

    <script type="text/template" id="resultslink-partial">
        <a href="#" data-icon="back" data-theme="b" class="back ui-btn-left">{{resultsLinkText}}</a>
    </script>  

    <script type="text/template" id="searchoptionslink-partial">
        <a href="#" id="search-options" data-icon="gear" data-iconpos="notext" data-theme="b" class="ui-btn-right">Options</a>
    </script>  
    
    
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript">
    if (typeof jQuery == 'undefined') {
        document.write(unescape("%3Cscript src='/scripts/lib/jquery/jquery-1.7.2.min.js' type='text/javascript'%3E%3C/script%3E"));
    }
</script>

    <script type="text/javascript" src="/combres/mobile-js/-79331231/"></script>

    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-10146046-1']);
        _gaq.push(['_trackPageview']);
        (function () {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
    </script>
</head>

<body>
    <div id="member-boostrap" style="display: none">{"BookBookmarkLists":null,"DisplayName":null,"ErrorMessage":null,"Id":0,"LoggedIn":false,"RecipeBookmarkLists":null}</div>
    <div id="mobile-redirect-fragment" style="display: none">library/recipes/&f_ethnicity=indian&online-recipes=true&sort=</div>
</body>

</html>