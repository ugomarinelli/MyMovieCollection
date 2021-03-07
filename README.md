# MyMovieCollection

This app is a two pages app that retrieves and show a list of movies. The user has the ability to see the detail of the movie by taping on one. 

The architecture used is a Model View Presenter State : 

- The View Controller : it handles only the display and user events, we don't want any logic in a VC to not overload it 
- The View State: a simple struct that contains all the elements the View Controller needs to render 
- The Presenter : all the logic happens here : call to the APIs, heavy logic etc. 

Basically, the View Controller has a reference to the Presenter, so we can access its method whenever we want. 
The Presenter will do some logic, and then recreate a new View State that will be passed back to the View Controller. 
The View Controller will then be updated with the new View State.
