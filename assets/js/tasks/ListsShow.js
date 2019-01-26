import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
import update from 'immutability-helper';
import {RIEInput} from 'riek'

export default class ListsShow extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      list: {
        id: '',
        inserted_at: '',
        name: '',
        public: '',
        updated_at: '',
        tasks: [],
      },
      error: ''
    }

    this._addNewTaskToState = this._addNewTaskToState.bind(this);
    this._handleKeyPress = this._handleKeyPress.bind(this);
  }

  _addNewTaskToState(task) {
    const newData = update(this.state.list, {
      tasks: {$push: [task]}
    });

    this.setState({"list": newData})
  }

  componentDidMount() {
    axios.get('/api/lists/' +  this._getListId())
      .then(response => {
        this.setState({list: response.data.data});
        // window.location.href = "/";
      }).catch(error => {
        this.setState({"error": "Error loading your list, please try again"});
      });
  }

  _createNewTask(name, listId) {
    axios.post('/api/lists/' + listId + '/tasks', {task: {name: name, done: false}})
      .then(response => {
        this._addNewTaskToState(response.data.data)
      }).catch(error => {
        this.setState({"error": error.response.data.errors.detail});
      });
  }

  _handleRIEInputChange(value, task) {
    this._editTask("name", value.name, task)
  }

  _editTask(field, value, task) {
    axios.put('/api/lists/' + task.list_id + '/tasks/' + task.id, {task: {[field]: value}})
      .then(response => {
        this._updateNewTaskToState(response.data.data)
      }).catch(error => {
        this.setState({"error": error.response.data.errors.detail});
      });
  }

  _getListId() {
    const re = /lists\/(\d+)/;
    var result = re.exec(document.URL);
    return result[1];
  }

  _handleKeyPress(e) {
    if (e.key == 'Enter') {
      this.setState({newTaskName: ''});
      this._createNewTask(this.state.newTaskName, this._getListId())
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

  _renderTask(task) {
    return (
      <div className="row" key={task.id}>
        <label className="col s3 m3" style={{marginTop: '16px'}}>
          <input type="checkbox" checked={task.done} onChange={e => this._editTask("done", e.target.checked, task)}/>
          <span></span>
        </label>
        <RIEInput
          classEditing="input-field col s5 m5"
          className={"input-field col s5 m5" + (task.done ? ' finished-task' : '')}
          value={task.name}
          change={name => this._handleRIEInputChange(name, task)}
          propName='name' />
        <i className="small material-icons">delete</i>
      </div>
    )
  }

  render() {
    return (
      <div>
        <h3>{this.state.list.name}</h3>
        <p>Created at, last updated at</p>
        {this._renderError()} 
        <br/><br/>  
        <center>
          <p>Break down time! Type the task name and hit enter</p>
          <div className="row">
            <div className="input-field col s12">
              <input
                type="text"
                value={this.state.newTaskName}
                onChange={e => this.setState({newTaskName: e.target.value})}
                onKeyPress={this._handleKeyPress}></input>
            </div>
          </div>
          {this.state.list.tasks.map(task => this._renderTask(task))}
        </center>
      </div>
    )
  }

  _updateNewTaskToState(task) {
    const taskList = this.state.list.tasks
    let idx;

    for (let i=0; i < taskList.length; i++) {
      if (taskList[i].id === task.id) {
        idx=i;
        break;
      }
    }
    const newData = update(this.state.list, 
        {tasks: {[idx]: {$set: task}}}
    );
    this.setState({"list": newData})
  }

  _updateList(field, value) {
    const newData = update(this.state.list, {
      [field]: {$set: value}
    });

    this.setState({"list": newData})
  }

}

ReactDOM.render(
  <ListsShow />,
  document.getElementById('react_lists_show'),
);
