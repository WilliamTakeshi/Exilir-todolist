import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
// import update from 'immutability-helper';

export default class RecentLists extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tasks: [],
      error: ''
    }

    this._renderTaskCard = this._renderTaskCard.bind(this);
  }

  componentDidMount() {
    axios.get('/api/recent_lists')
      .then(response => {
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
    return(
      <div key={task.id} className="col s6 m4">
        <div className="card light-blue darken-2">
          <div className="card-content white-text">
          <p>{task.name}</p>
          </div>
          <div className="card-action">
            <a href={"/lists/"+task.id}>Check</a>
          </div>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div>
        {this._renderError()}
        <div className="row">
          {this.state.tasks.map(task => this._renderTaskCard(task))}
        </div>
      </div>
    )
  }
}

ReactDOM.render(
  <RecentLists />,
  document.getElementById('react_recent_lists'),
);
