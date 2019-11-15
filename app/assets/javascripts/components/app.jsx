const App = (props) => {
    return(
      <div>
        <h1>Zagloguj się, aby uzyskać fajrant!</h1>
        <SignInForm/>
        { PushNotification.isSupported() && <p>bangla</p>}
      </div>
    )
}
