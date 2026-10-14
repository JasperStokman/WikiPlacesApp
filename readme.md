
# Places / Wikipedia app
Places is an iOS application that uses the Wikipedia app to show locations on their places tab. This application is made as an iOS assessment for joining the ABN AMRO team.

## Building and Running
Build both the Places and modified Wikipedia app in Xcode, to test how the two work together.

## Thought process and decisions
With the prerequisites clearly in my mind, i made decisions aligning with those goals. The Places app is written in SwiftUI, but i tried to seperate the responsibilities of all the modules quite clearly. Overall, i used a MVVM approach, where the business logic is seperated from the view state. Using Combine's publishers, i kept the views reactive to the changes coming from the services.
The services are passed to the viewModels using protocols, to make mocking and  unit testing easy and clear.
I added small chunks of code per commit, to give an insight in my process as a developer. Making small iterations, and from there looking at my smallest next step to add to functionality is how i work as a developer.

## Usage of AI
The way i like to see the usage as an iOS developer, is to supercharge my programming. I like to be in control of the written code, but i see very clear advantages of using it to speed up the process. Writing boilerplate code or fixing strange Xcode errors were not my favorite way of spending my time as a developer. In those cases i use agents to find where the errors are located, so i can fix them more quickly.
In the case of the wikpedia app; reading through thousands of lines of code to find right viewController to add my changes will take a lot of time; in those cases i used Cursor to give me advice on where i could find the right functions for the solutions i needed to create. This way, i use AI to still learn new things about iOS development so that i still keep and expand my skills as a programmer, while minimizing frustration and loss of time.
