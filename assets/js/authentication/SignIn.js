import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
import update from 'immutability-helper';

export default class SignIn extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      credentials: {
        login: '',
        password: ''
      },
      error: ''
    }

    this._handleSubmit = this._handleSubmit.bind(this);
    this._updateCredentials = this._updateCredentials.bind(this);
  }

  _handleSubmit(e) {
    e.preventDefault();
    axios.post('/api/users/sign_in', this.state.credentials)
      .then(_response => {
        window.location.href = "/";
      }).catch(error => {
        this.setState({"error": error.response.data.errors.detail});
      });
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
        <h5 className="indigo-text">Please, login into your account</h5>
        <div className="section"></div>

        <div className="container">
          <div className="z-depth-1 grey lighten-4 row" style={{display: "inline-block", padding: "32px 48px 0px 48px", border: "1px solid #EEE"}}>
            {this._renderError()}
            <form className="col s12" onSubmit={(e) => this._handleSubmit(e)}>

              <div className='row'>
                <div className='input-field col s12'>
                  <input className='validate' onChange={e => this._updateCredentials("login", e.target.value)}  type='text' value={this.state.credentials.login} name='login' id='login' placeholder="Enter your email or username"/>
                </div>
              </div>

              <div className='row'>
                <div className='input-field col s12'>
                  <input onChange={e => this._updateCredentials("password", e.target.value)} className='validate' type='password' value={this.state.credentials.password} name='password' id='password' placeholder="Enter your password" />
                </div>
                <label >
                  <a className='pink-text' href='#!'><b>Forgot Password?</b></a>
                </label>
              </div>

              <br />
              <center>
                <div className='row'>
                  <button type='submit' name='btn_login' className='col s12 btn btn-large waves-effect light-blue darken-2'>Login</button>
                </div>
              </center>
            </form>
          </div>

        </div>
        <a href="#!">Create account</a>
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
  document.getElementById('react_sign_in'),
);
