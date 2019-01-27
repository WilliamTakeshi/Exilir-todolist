import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
import update from 'immutability-helper';

export default class SignIn extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      credentials: {
        username: '',
        email: '',
        password: '',
        password2: ''
      },
      error: ''
    }

    this._handleSubmit = this._handleSubmit.bind(this);
    this._updateCredentials = this._updateCredentials.bind(this);
  }

  _handleSubmit(e) {
    e.preventDefault();
    const password = this.state.credentials.password;
    const password2 = this.state.credentials.password2;
    if (this.state.credentials.username === '') {
      this.setState({"error": "Username is required"});
    } else if (this.state.credentials.email === '') {
      this.setState({"error": "Email is required"});
    } else if (password === '') {
      this.setState({"error": "Passwords is required"});
    } else if (password !== password2) {
      this.setState({"error": "Passwords must be the same"});
    } else {
      axios.post('/api/users', {"user": this.state.credentials})
        .then(_response => {
          window.location.href = "/";
        }).catch(_error => {
          this.setState({"error": "Username or Email already used"});
        });
    }

  }

  _renderError() {
    let error = this.state.error;

    if (!error) return false;

    return (
      <div className="error">
        {error}
      </div>
    );
  }

  render() {
    return (
      <center>
        <h5 className="indigo-text">Join now the world leader To-Do lists</h5>
        <div className="section"></div>

        <div className="container">
          <div className="z-depth-1 grey lighten-4 row" style={{display: "inline-block", padding: "32px 48px 0px 48px", border: "1px solid #EEE"}}>
            {this._renderError()}
            <form className="col s12" onSubmit={(e) => this._handleSubmit(e)}>
              <div className='row'>
                <div className='col s12'>
                </div>
              </div>

              <div className='row'>
                <div className='input-field col s12'>
                  <input className='validate' onChange={e => this._updateCredentials("username", e.target.value)}  type='text' value={this.state.credentials.username} name='username' id='username' placeholder="Enter your username"/>
                </div>
              </div>

              <div className='row'>
                <div className='input-field col s12'>
                  <input className='validate' onChange={e => this._updateCredentials("email", e.target.value)}  type='email' value={this.state.credentials.email} name='email' id='email' placeholder="Enter your email"/>
                </div>
              </div>

              <div className='row'>
                <div className='input-field col s12'>
                  <input onChange={e => this._updateCredentials("password", e.target.value)} className='validate' type='password' value={this.state.credentials.password} name='password' id='password' placeholder="Enter your password" />
                </div>
              </div>
              <div className='row'>
                <div className='input-field col s12'>
                  <input onChange={e => this._updateCredentials("password2", e.target.value)} className='validate' type='password' value={this.state.credentials.password2} name='password2' id='password2' placeholder="Repeat your password" />
                </div>
              </div>

              <br />
              <center>
                <div className='row'>
                  <button type='submit' name='btn_login' className='col s12 btn btn-large waves-effect indigo'>Sign Up</button>
                </div>
              </center>
            </form>
          </div>

        </div>
      </center>
    )
  }

  _updateCredentials(field, value) {
    const newData = update(this.state.credentials, {
      [field]: {$set: value}
    });

    this.setState({"credentials": newData})
  }
}

ReactDOM.render(
  <SignIn />,
  document.getElementById('react_sign_up'),
);
