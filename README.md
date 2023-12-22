# car_pool

Mobile Programming project.


## Project Description
Carpool is a rideshare application designed to facilitate rideshare service to customers.
Carpool can be used by students to share rides to or from AinShams campus.
In this version of the application, we’ll create a customized version for the Faculty of Engineering
Community at Ainshams University. We’ll focus on riding to or from Gate 3 or Gate 4. Users must sign in
with an active account @eng.asu.edu.eg to build a trusted closed community. Carpool has a revolutionary
strategy in recruiting drivers and operating the service. Carpool is operated by students for students.
To regulate the service in this pilot project, there will be only two destination points Gate 3 and 4 and
one start ride time at 7:30 am from different locations and one return ride time at 5:30 pm from faculty of
engineering campus.

## Getting Started: Detailed Steps for using the app and reaching all the widgets.
This project is starting point from the WelcomePage. The WelcomePage will offer you whether to sign-in as a User or a Driver.

Let's start with the Driver:
click on "Driver" --> Enter your email and password (default: test@eng.asu.edu.eg, test1234) -->
if you don't have an account --> press on "Sign-up" --> fill the fields such that the password minimum length is 8 and the email
should end with '@eng.asu.edu.eg' --> press Sign up and congrats you now have an account -->
you will find yourself by default in DriverRidesPage which preview all rides and a floating action button add -->
press the add button "+" --> choose whether you are "Going to faculty" at 7:30 am or "Returning from faculty" at 5:30 pm. -->
fill all the fields in front of you like driver name, driver mobile no., ..etc. --> now from the bottom navigation bar, you can
go to the next page through the icon in the bar or by swiping the screen to reach "My Rides" --> click on the card ride -->
press "Accept" or "Reject" whether you want to accept the user in your ride or not --> you can press on "List of Accepted Users" -->
you shall see all the users, you have accepted their requests to join you this ride --> back to 'Users Requests Page' -->
if you want to accept a ride and its time limit is out --> click on "Assign by pass true" --> press "Accept" on users you want -->
click on "Assign by pass false" --> go back will take you to 'My Rides' --> if you pressed on the basket button, you shall delete
the ride you created or added --> again from the navigation bar or by screen swiping, go to 'History' see your past inactive rides --> 
once more from the navigation bar or by screen swiping, go to 'Profile' --> if you wrote anything in any of the two cells 
of 'Name' and 'Password' and pressed the pen button corresponding, you will be editing in your account name or password in all databases -->
if you pressed 'Delete Account', your account will be deleted from all databases and you shall return to the 'Welcome Page' -->
if you pressed 'Print mydb in console', you will see in console all the data in sqlite database --> Last time of pressing on the navigation bar
or by screen swiping, go to 'Logout' --> if you pressed "Logout", you will be signed out from your account and you shall navigate
to 'Welcome Page' once more.

Now Let's discuss the User side:
click on "User" --> Enter your email and password (default: test@eng.asu.edu.eg, test1234 || amal@eng.asu.edu.eg, amal1234) -->
if you don't have an account --> press on "Sign-up" --> fill the fields such that the password minimum length is 8 and the email
should end with '@eng.asu.edu.eg' --> press Sign up and congrats you now have an account -->
you will find yourself by default in AvailableRidesPage --> In 'Available Rides Page' you shall find 2 button on each ride card -->
if you pressed the add button "+", you shall find this ride added to your 'My Cart' --> if the time limit for requesting this ride is out, then
press "Assign by pass true" and try pressing the add button once more "+", if you visited 'My Cart' now, you shall find this ride added -->
press "Assign by pass false" to prevent any confusion --> if you pressed on the history button, this shall force the ride to be moved from 
'Rides' to 'History' (it has nothing to do with the logic of the app but for the evaluation steps done by the doctor) --> from the bottom navigation bar
or through swiping the screen to reach 'Cart', you shall see now in 'Cart' 2 buttons --> the first button is the delete which if you pressed, it
shall be like cancelling your request for this ride --> the second button is the eye button --> press on the eye button, it shall take you
to the 'Order Details Page' to see the full details of the ride you requested and pressed on --> from 'Order Details Page', if you
pressed "Check the Ride Status", it shall take you to the 'Ride Status Tracking Page' to see the status of your request for this ride -->
go back to 'Order Details Page' --> if you pressed "Pay for this ride", you shall have the option to pay visa through the app -->
go back again to 'Order Details Page' --> Back again to 'My Cart' --> from the bottom navigation bar or through swiping the screen to reach
'History', you will see all the past inactive rides that your status in them was 'Accepted' --> once more from the navigation bar or by screen 
swiping, go to 'Profile' --> if you wrote anything in any of the two cells of 'Name' and 'Password' and pressed the pen button corresponding, you 
will be editing in your account name or password in all databases --> if you pressed 'Delete Account', your account will be deleted from all databases 
and you shall return to the 'Welcome Page' --> if you pressed 'Print mydb in console', you will see in console all the data in sqlite database --> 
Last time of pressing on the navigation bar or by screen swiping, go to 'Logout' --> if you pressed "Logout", you will be signed out from your account 
and you shall navigate to 'Welcome Page' once more.

## Apk files
see the path for the build apk files from the documentation last page. You shall need it to run the app.



