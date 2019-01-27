import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
import update from 'immutability-helper';

export default class ListsNew extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      list: {
        name: '',
        public: true,
      },
      error: ''
    }
  }

  _handleSubmit(e) {
    e.preventDefault();
    console.log('+++++++++++++++++')
    axios.post('/api/lists', {"list": this.state.list})
      .then(response => {
        console.log(response.data.data.id)
        window.location.href = "/lists/" + response.data.data.id
      }).catch(error => {
        console.log(error)
        this.setState({"error": "Error creating the list, please try again later"});
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
      <div>
        <h3>Create a to-do list</h3>
        {this._renderError()}       
        <div className="container">
          <div className="z-depth-1 grey lighten-4 row" style={{display: "inline-block", padding: "32px 48px 0px 48px", border: "1px solid #EEE"}}> 
            <center>
              <p>A trip? A project? A User Story? Insert the name your big next thing!</p>
            <form className="col s12" onSubmit={(e) => this._handleSubmit(e)}>

              <div className='row'>
                <div className='input-field col s12'>
                  <input className='validate' onChange={e => this._updateList("name", e.target.value)}  type='text' value={this.state.list.name} name='name' id='name' placeholder="Enter your list name"/>
                </div>
              </div>
              <div className='row'>
                <div className='col m6 s6'>
                  <label>
                    <input className="with-gap" name="group3" type="radio" checked={(this.state.list.public)} onChange={() => this._updateList("public", true)} />
                    <span>Public</span>
                  </label>
                </div>
                <div className='col m6 s6'>
                  <label>
                    <input className="with-gap" name="group3" type="radio" checked={!this.state.list.public} onChange={() => this._updateList("public", false)}/>
                    <span>Private</span>
                  </label>
                </div>
              </div>
              <br/>
              <div className='row'>
                <button type='submit' name='btn_submit' className='col s12 btn btn-large waves-effect light-blue darken-2'>Create</button>
              </div>
            </form>
            </center>
          </div>
        </div>
      </div>
    )
  }

  _updateList(field, value) {
    const newData = update(this.state.list, {
      [field]: {$set: value}
    });

    this.setState({"list": newData})
  }

}

ReactDOM.render(
  <ListsNew />,
  document.getElementById('react_lists_new'),
);
