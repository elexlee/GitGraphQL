
## GitGraphQL  
### A GitHub GraphQL API Demo

<img align="right" width="275" height="471" src="https://i.imgur.com/EXwwRLG.png">

GitGraphQL is an iOS application that makes use of [GitHub's GraphQL API](https://developer.github.com/v4/) to display a list of repositories.

### Specifics
1. Searches for repositories containing the string "GraphQL".
2. Includes infinite scrolling.
3. Displays the following repository information:
    - Repository's name
    - Repository owner's login name
    - Repository owner's avatar
    - Repository's number of stars
    
### Development log
1. Created GitHub Access Token and set up Apollo pod in project.
2. Creation of RepoScrollVC and setting up corresponding RepoScrollViewModel.
3. Simple implementation of ApolloClient on RepoScrollVC to work on UI/UX changes and ViewModel delegates.
4. Created GraphQLClientProtocol and a GraphQLClient class that included singleton instance of ApolloClient.
5. Created GraphQLHTTPNetworkTransport conforming to Apollo's NetworkTransport protocol allowing more control over request header/body and handling responses.
6. Finished with some surface UI changes to make application more presentable.

### Takeaway
Having not had the chance to work extensively with GraphQL in the past, I found it to be extremely interesting. During the development process, I had to do a good deal of reading into GraphQL, Apollo, and of course GitHub's API Documentation. 
My first thought was to just have a simple instance of ApolloClient because the requirements for the query were very specific and not overly complex, but this did not allow for much customization outside of the basic functionality Apollo comes built with.
I also initially tried using UITableViewDataSourcePrefetching on my UITableView to allow for a smoother scrolling experience. However not having used this particular method for infinite scrolling before, I ran into complications.
I did manage to have the cells showing up with the data, however trying to calculate which cells were visible on screen to reload caused flickering of the TableView and overall created an undesirable user experience.
Eventually I went with just loading batches of repositories and reloading the TableView with new data. The custom AvatarImageView has asynchronous fetching and caches images after the first fetch to save on network calls.  
If I were to continue working on this, I might add a search bar so that users can change their query to whatever string they wanted to search. I've implemented the client and query in the code in such a way that this would be a simple enough feature to implement.

### Conclusion
I learned a lot and am definitely interested in looking more into GraphQL. Not having to parse JSON, the ability to request exactly what one needs, and receiving that data in a predictable manner makes for an awesome single endpoint API.

### Sidenote
Currently using my GitHub token. For reasons unknown, my initial token was somehow deleted from my account without my knowledge and caused 401 responses from GitHub. Should that happen, the token can be replaced in the GraphQLClientProtocol.swift file.
