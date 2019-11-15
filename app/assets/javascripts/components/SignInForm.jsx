class SignInForm extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    alert('A name was submitted:');
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Podaj adres email w domenie punkta.pl:
          <input type="text" />
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}
