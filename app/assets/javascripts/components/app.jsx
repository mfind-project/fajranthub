import { isPushNotificationSupported } from '../push-notifications'


const App = (props) => {
    return(
      <div>
        <h1>Zagloguj się, aby uzyskać fajrant!</h1>
        <SignInForm/>
        { isPushNotificationSupported && <p>bangla</p>}
      </div>
    )
}
