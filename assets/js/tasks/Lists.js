import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
import update from 'immutability-helper';

export default class Lists extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tasks: [],
      error: ''
    }

    this._renderTaskCard = this._renderTaskCard.bind(this);
  }

  componentDidMount() {
    axios.get('/api/lists')
      .then(response => {
        console.log(response);
        this.setState({tasks: response.data.data})
      }).catch(error => {
        this.setState({"error": "Error loading your lists, please try again"});
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
  
  _renderTaskCard(task) {
    console.log(task)
    return(
      <div key={task.id} className="col s6 m4">
        <div className="card light-blue darken-2">
          <div className="card-content white-text">
          {/* <span className="card-title">Card Title</span> */}
          <p>{task.name}</p>
          </div>
          <div className="card-action">
            <a href={"/lists/"+task.id}>Edit</a>
          </div>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div>
        <center><a class="light-blue darken-2 waves-effect waves-light btn">Create List</a></center>
        <div className="row">
          {this.state.tasks.map(task => this._renderTaskCard(task))}
        </div>
      </div>
    )
  }
}

ReactDOM.render(
  <Lists />,
  document.getElementById('react_lists'),
);
